
;; al ejecutar (load"SE_simple_recetas.clp") hay que hacer después
;; (load "BDrecetas_100.clp") para cargar la informacion de las recetas

(deftemplate receta

  (slot nombre (type STRING))
  (slot tipo-plato (type SYMBOL))
	(slot dificultad (type SYMBOL))
  (slot comensales (type INTEGER))
  (slot tiempo-cocinado (type INTEGER))
  (multislot info-nutricional)
  (slot enlace-web (type STRING))
)

(deftemplate ingrediente
  (slot nombre-receta (type STRING))
  (slot nombre-ingrediente (type STRING))
  (slot cantidad (type FLOAT))
  (slot unidad (type SYMBOL))
)


(deffunction contiene (?texto ?patron)
  (if (neq (str-index (lowcase ?patron) (lowcase ?texto)) FALSE)
    then TRUE
    else FALSE)
)

(deffunction es-condimento (?ing)
  (if (or (contiene ?ing "sal")
          (contiene ?ing "pimienta")
          (contiene ?ing "perejil")
          (contiene ?ing "laurel")
          (contiene ?ing "oregano")
          (contiene ?ing "tomillo")
          (contiene ?ing "albahaca")
          (contiene ?ing "esencia")
          (contiene ?ing "canela")
          (contiene ?ing "vinagre")
          (contiene ?ing "comino")
          (contiene ?ing "curry")
          (contiene ?ing "pimenton"))
    then TRUE
    else FALSE)
)

(deffunction es-importante (?ing)
  (if (or (contiene ?ing "pollo")
          (contiene ?ing "carne")
          (contiene ?ing "ternera")
          (contiene ?ing "cerdo")
          (contiene ?ing "pato")
          (contiene ?ing "atun")
          (contiene ?ing "bacalao")
          (contiene ?ing "merluza")
          (contiene ?ing "gamba")
          (contiene ?ing "pulpo")
          (contiene ?ing "arroz")
          (contiene ?ing "pasta")
          (contiene ?ing "fideos")
          (contiene ?ing "patata")
          (contiene ?ing "garbanzo")
          (contiene ?ing "lenteja")
          (contiene ?ing "queso")
          (contiene ?ing "chocolate"))
    then TRUE
    else FALSE)
)

(deffunction es-dulce (?ing)
  (if (or (contiene ?ing "azucar")
          (contiene ?ing "chocolate")
          (contiene ?ing "galleta")
          (contiene ?ing "vainilla")
          (contiene ?ing "miel")
          (contiene ?ing "cacao")
          (contiene ?ing "leche condensada")
          (contiene ?ing "manjar"))
    then TRUE
    else FALSE)
)

(deffunction obtener-kcal ($?info)
  (if (= (length$ ?info) 0) then (return -1))
  (bind ?prim (nth$ 1 ?info))

  (if (numberp ?prim) then (return ?prim))

  (if (symbolp ?prim) then
    (bind ?num-sym (string-to-field (sym-cat ?prim)))
    (if (numberp ?num-sym) then (return ?num-sym)))

  (if (stringp ?prim) then
    (bind ?partes (explode$ ?prim))
    (if (> (length$ ?partes) 0) then
      (bind ?primera-parte (nth$ 1 ?partes))
      (if (numberp ?primera-parte) then
        (return ?primera-parte)
      else
        (if (or (stringp ?primera-parte) (symbolp ?primera-parte) (instance-namep ?primera-parte)) then
          (bind ?num (string-to-field (sym-cat ?primera-parte)))
          (if (numberp ?num) then (return ?num))))))

  (return -1)
)

(deffunction extraer-numero-gramos (?dato)
  (if (numberp ?dato) then (return ?dato))

  (if (stringp ?dato) then
    (bind ?txt ?dato)
  else
    (bind ?txt (str-cat ?dato)))

  (bind ?partes (explode$ ?txt))
  (if (= (length$ ?partes) 0) then (return -1))

  (bind ?tok (sym-cat (nth$ 1 ?partes)))
  (bind ?len (str-length ?tok))
  (if (= ?len 0) then (return -1))

  (if (eq (lowcase (sub-string ?len ?len ?tok)) "g") then
    (bind ?tok (sub-string 1 (- ?len 1) ?tok)))

  (bind ?num (string-to-field ?tok))
  (if (numberp ?num) then (return ?num))

  (return -1)
)

(deffunction obtener-proteinas ($?info)
  (bind ?n (length$ ?info))
  (if (= ?n 0) then (return -1))

  (bind ?i 1)
  (while (<= ?i ?n) do
    (bind ?dato (nth$ ?i ?info))
    (if (contiene (sym-cat ?dato) "proteina") then
      (bind ?p (extraer-numero-gramos ?dato))
      (if (>= ?p 0) then (return ?p)))
    (bind ?i (+ ?i 1)))

  (return -1)
)


;;; ============================================================
;;; MODULO 1: DEDUCIR PROPIEDADES DE RECETAS (base de conocimiento)
;;; ============================================================




;Ingredientes relevantes

(defrule ingrediente-relevante-por-nombre
  (declare (salience 2000))
  (receta (nombre ?r))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (contiene ?r ?a))
  (not (propiedad_receta ingrediente_relevante ?r ?a))
  =>
  (assert (propiedad_receta ingrediente_relevante ?r ?a))
)

(defrule ingrediente-relevante-por-tipo
  (declare (salience 2000))
  (receta (nombre ?r))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (es-importante ?a))
  (not (propiedad_receta ingrediente_relevante ?r ?a))
  =>
  (assert (propiedad_receta ingrediente_relevante ?r ?a))
)


;Deducir tipo de plato si no viene informado

(defrule deducir-tipo-plato-postre
  (declare (salience 2000))
  ?f <- (receta (nombre ?r) (tipo-plato ?tp&:(or (eq ?tp desconocido) (eq ?tp sin-clasificar) (eq ?tp ninguno))))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (es-dulce ?a))
  =>
  (modify ?f (tipo-plato postre))
)

(defrule deducir-tipo-plato-principal
  (declare (salience 2000))
  ?f <- (receta (nombre ?r) (tipo-plato ?tp&:(or (eq ?tp desconocido) (eq ?tp sin-clasificar) (eq ?tp ninguno))))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (es-importante ?a))
  =>
  (modify ?f (tipo-plato principal))
)

(defrule deducir-tipo-plato-por-defecto
  ; Por debajo de postre/principal (2000) pero aun antes de la interaccion.
  (declare (salience 1990))
  ?f <- (receta (nombre ?r) (tipo-plato ?tp&:(or (eq ?tp desconocido) (eq ?tp sin-clasificar) (eq ?tp ninguno))))
  =>
  (modify ?f (tipo-plato entrante))
)


; Clasificaciones: vegana/vegetariana/picante/sin gluten/sin lactosa
;    + calorias/proteinas

(defrule marcar-picante
  (declare (salience 2000))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (or (contiene ?a "guindilla")
            (contiene ?a "chile")
            (contiene ?a "cayena")
            (contiene ?a "aji")
            (contiene ?a "picante")
            (contiene ?r "picante")))
  (not (propiedad_receta es_picante ?r))
  =>
  (assert (propiedad_receta es_picante ?r))
)

(defrule marcar-contiene-gluten
  (declare (salience 2000))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (or (contiene ?a "harina")
            (contiene ?a "pan")
            (contiene ?a "pasta")
            (contiene ?a "fideos")
            (contiene ?a "galleta")
            (contiene ?a "hojaldre")
            (contiene ?a "bizcocho")
            (contiene ?a "trigo")))
  (not (propiedad_receta contiene_gluten ?r))
  =>
  (assert (propiedad_receta contiene_gluten ?r))
)

(defrule marcar-contiene-lactosa
  (declare (salience 2000))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (or (contiene ?a "leche")
            (contiene ?a "queso")
            (contiene ?a "nata")
            (contiene ?a "mantequilla")
            (contiene ?a "yogur")
            (contiene ?a "crema")
            (contiene ?a "mascarpone")))
  (not (propiedad_receta contiene_lactosa ?r))
  =>
  (assert (propiedad_receta contiene_lactosa ?r))
)

(defrule marcar-no-vegetariana
  (declare (salience 2000))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (or (contiene ?a "carne")
          	(contiene ?a "pollo")
            (contiene ?a "ternera")
            (contiene ?a "cerdo")
            (contiene ?a "jamon")
            (contiene ?a "chorizo")
            (contiene ?a "morcilla")
            (contiene ?a "pato")
            (contiene ?a "atun")
            (contiene ?a "bacalao")
            (contiene ?a "merluza")
            (contiene ?a "pescado")
            (contiene ?a "gamba")
            (contiene ?a "pulpo")
            (contiene ?a "salmon")
            (contiene ?a "marisco")))
  (not (propiedad_receta no_vegetariana ?r))
  =>
  (assert (propiedad_receta no_vegetariana ?r))
)

(defrule marcar-no-vegana-por-otros
  (declare (salience 2000))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (contiene ?a "huevo"))
  (not (propiedad_receta no_vegana ?r))
  =>
  (assert (propiedad_receta no_vegana ?r))
)

(defrule marcar-no-vegana-por-animal
  (declare (salience 2000))
  (propiedad_receta no_vegetariana ?r)
  (not (propiedad_receta no_vegana ?r))
  =>
  (assert (propiedad_receta no_vegana ?r))
)

(defrule marcar-no-vegana-por-lactosa
  (declare (salience 2000))
  (propiedad_receta contiene_lactosa ?r)
  (not (propiedad_receta no_vegana ?r))
  =>
  (assert (propiedad_receta no_vegana ?r))
)

(defrule marcar-es-vegetariana
  (declare (salience 1900))
  (receta (nombre ?r))
  (not (propiedad_receta no_vegetariana ?r))
  (not (propiedad_receta es_vegetariana ?r))
  =>
  (assert (propiedad_receta es_vegetariana ?r))
)

(defrule marcar-es-vegana
  (declare (salience 1900))
  (receta (nombre ?r))
  (not (propiedad_receta no_vegana ?r))
  (not (propiedad_receta es_vegana ?r))
  =>
  (assert (propiedad_receta es_vegana ?r))
)

(defrule marcar-es-sin-gluten
  (declare (salience 1900))
  (receta (nombre ?r))
  (not (propiedad_receta contiene_gluten ?r))
  (not (propiedad_receta es_sin_gluten ?r))
  =>
  (assert (propiedad_receta es_sin_gluten ?r))
)

(defrule marcar-es-sin-lactosa
  (declare (salience 1900))
  (receta (nombre ?r))
  (not (propiedad_receta contiene_lactosa ?r))
  (not (propiedad_receta es_sin_lactosa ?r))
  =>
  (assert (propiedad_receta es_sin_lactosa ?r))
)

(defrule clasificar-calorias
  (declare (salience 2000))
  (receta (nombre ?r) (info-nutricional $?info))
  (not (propiedad_receta calorias ?categoria ?r))
  =>
  (bind ?kcal (obtener-kcal ?info))
  (if (or (< ?kcal 0) (<= ?kcal 100)) then
    (assert (propiedad_receta calorias baja ?r))
  else
    (if (or (< ?kcal 100) (<= ?kcal 250)) then
      (assert (propiedad_receta calorias media ?r))
    else
      (assert (propiedad_receta calorias alta ?r))))
)

(defrule clasificar-proteinas
  (declare (salience 2000))
  (receta (nombre ?r) (info-nutricional $?info))
  (not (propiedad_receta proteinas ?nivel ?r))
  =>
  (bind ?p (obtener-proteinas ?info))
  (if (or (< ?p 0) (<= ?p 10)) then
    (assert (propiedad_receta proteinas baja ?r))
  else
    (if (<= ?p 15) then
      (assert (propiedad_receta proteinas media ?r))
    else
      (assert (propiedad_receta proteinas alta ?r))))
)
(deftemplate RecetaCandidata (slot nombre) (slot cf (type FLOAT) (default 0.0)))
(deftemplate RecetaOfertada (slot nombre))
(deftemplate RecetaRechazada (slot nombre) (slot motivo))
(deftemplate respuesta-sin-lactosa (slot valor))
(deftemplate respuesta-sin-gluten (slot valor))

;; Evidencia de certeza: por cada preferencia del usuario y cada receta
;; candidata se genera una evidencia con su CF y una   que
;; se mostrara al usuario como justificacion del razonamiento.
(deftemplate evidencia
  (slot receta)
  (slot factor)
  (slot cf (type FLOAT))
  (slot descripcion (type STRING)))

;; Marca de que ya se ha combinado el CF de una receta (evita recalcular).
(deftemplate cf-calculada (slot receta))

;; Registro de las preguntas que el sistema decidio NO hacer (porque no
;; discriminaban), para poder explicarlo al usuario al final.
(deftemplate pregunta-omitida (slot que))

(deffacts inicio-sistema-experto
  (arrancar)
  (pregunta dieta)
  (pregunta sin_lactosa)
  (pregunta sin_gluten)
  (pregunta tipo)
  (pregunta comensales)
  (pregunta tiempo)
  (pregunta proteina)
  (pregunta densidad_calorica)
  (pregunta ingrediente_obligatorio)
)

(deffunction normalizar-respuesta (?x)
  (if (or (symbolp ?x) (stringp ?x) (instance-namep ?x)) then (return (lowcase ?x)) else (return ?x))
)

(deffunction tipo-respuesta-a-simbolo (?resp)
  (if (eq ?resp principal) then (return principal))
  (if (eq ?resp entrante) then (return entrante))
  (if (eq ?resp postre) then (return postre))
  (return ns)
)

(deffunction dieta-valida (?r)
  (if (or (eq ?r normal) (eq ?r vegetariana) (eq ?r vegana)
          (eq ?r ns) (eq ?r fin))
    then TRUE
    else FALSE)
)

(deffunction si-no-valido (?r)
  (if (or (eq ?r si) (eq ?r no) (eq ?r ns) (eq ?r fin))
    then TRUE
    else FALSE)
)

(deffunction tipo-valido (?r)
  (if (or (eq ?r principal) (eq ?r entrante) (eq ?r postre)
          (eq ?r ns) (eq ?r fin))
    then TRUE
    else FALSE)
)

(deffunction alta-media-baja-valida (?r)
  (if (or (eq ?r alta) (eq ?r media) (eq ?r baja) (eq ?r ns) (eq ?r fin))
    then TRUE
    else FALSE)
)

(deffunction densidad-calorica-valida (?r)
  (return (alta-media-baja-valida ?r))
)

(deffunction proteina-valida (?r)
  (return (alta-media-baja-valida ?r))
)

(deffunction numero-o-control (?r)
  (if (or (numberp ?r) (eq ?r ns) (eq ?r fin))
    then TRUE
    else FALSE)
)

(deffunction limpiar-evaluacion ()
  (do-for-all-facts ((?f RecetaCandidata)) TRUE (retract ?f))
  (do-for-all-facts ((?f RecetaOfertada)) TRUE (retract ?f))
  (do-for-all-facts ((?f RecetaRechazada)) TRUE (retract ?f))
  (do-for-all-facts ((?f evidencia)) TRUE (retract ?f))
  (do-for-all-facts ((?f cf-calculada)) TRUE (retract ?f))
)

; Crea una RecetaCandidata por cada receta existente en la base de hechos.
(deffunction crear-candidatas-iniciales ()
  (do-for-all-facts ((?r receta)) TRUE
    (assert (RecetaCandidata (nombre ?r:nombre))))
)

; Comprueba si una receta tiene una propiedad binaria (propiedad, receta).
(deffunction tiene-prop2 (?prop ?r)
  (return
    (any-factp ((?f propiedad_receta))
      (and (eq (nth$ 1 ?f:implied) ?prop)
           (eq (nth$ 2 ?f:implied) ?r))))
)

; Comprueba si una receta tiene una propiedad ternaria (propiedad, valor, receta).
(deffunction tiene-prop3 (?prop ?valor ?r)
  (return
    (any-factp ((?f propiedad_receta))
      (and (eq (nth$ 1 ?f:implied) ?prop)
           (eq (nth$ 2 ?f:implied) ?valor)
           (eq (nth$ 3 ?f:implied) ?r))))
)

; Valoro si una receta pasa las preguntas mínimas 

(deffunction receta-cumple-base (?r ?d ?sl ?sg ?ing)
  (if (and (eq ?d vegana) (tiene-prop2 no_vegana ?r))
    then (return FALSE))

  (if (and (eq ?d vegetariana) (tiene-prop2 no_vegetariana ?r))
    then (return FALSE))

  (if (and (eq ?sl si) (tiene-prop2 contiene_lactosa ?r))
    then (return FALSE))

  (if (and (eq ?sg si) (tiene-prop2 contiene_gluten ?r))
    then (return FALSE))

  (if (and (neq ?ing ns)
           (not (any-factp ((?i ingrediente))
                  (and (eq ?i:nombre-receta ?r)
                       (contiene ?i:nombre-ingrediente (sym-cat ?ing))))))
    then (return FALSE))

  (return TRUE)
)

; Devuelve el valor de un campo de receta (tipo, comensales, tiempo, proteínas o calorías).

(deffunction valor-campo-receta (?campo ?r)
  (if (eq ?campo tipo) then
    (do-for-all-facts ((?x receta)) (eq ?x:nombre ?r) (return ?x:tipo-plato)))

  (if (eq ?campo comensales) then
    (do-for-all-facts ((?x receta)) (eq ?x:nombre ?r) (return ?x:comensales)))

  (if (eq ?campo tiempo) then
    (do-for-all-facts ((?x receta)) (eq ?x:nombre ?r) (return ?x:tiempo-cocinado)))

  (if (eq ?campo proteinas) then
    (if (tiene-prop3 proteinas baja ?r) then (return baja))
    (if (tiene-prop3 proteinas media ?r) then (return media))
    (if (tiene-prop3 proteinas alta ?r) then (return alta)))

  (if (eq ?campo calorias) then
    (if (tiene-prop3 calorias baja ?r) then (return baja))
    (if (tiene-prop3 calorias media ?r) then (return media))
    (if (tiene-prop3 calorias alta ?r) then (return alta)))

  (return desconocido)
)

; Indica si todas las recetas que pasan filtros comparten el mismo valor en un campo.
(deffunction unico-campo-base (?campo ?d ?sl ?sg ?ing)
  (bind ?hay FALSE)
  (bind ?v ninguno)
  (do-for-all-facts ((?r receta)) TRUE
    (if (receta-cumple-base ?r:nombre ?d ?sl ?sg ?ing) then
      (bind ?x (valor-campo-receta ?campo ?r:nombre))
      (if (not ?hay) then
        (bind ?v ?x)
        (bind ?hay TRUE)
      else
        (if (neq ?v ?x) then (return FALSE)))))
  (return ?hay)
)

(deffunction obtener-dieta-receta (?r)
  (if (tiene-prop2 es_vegana ?r) then (return "vegana"))
  (if (tiene-prop2 es_vegetariana ?r) then (return "vegetariana"))

  (return "normal")
)

;;; RAZONAMIENTO CON INCERTIDUMBRE 

os alimentan o complementan esa decision y se explican al usuario.

; Mantiene el CF dentro de (-1,1) para evitar divisiones por cero al combinar.
(deffunction acotar-cf (?x)
  (if (> ?x 0.95) then (return 0.95))
  (if (< ?x -0.95) then (return -0.95))
  (return ?x)
)

; Combinacion de dos factores de certeza segun MYCIN:
(deffunction combinar-cf (?a ?b)
  (if (and (>= ?a 0.0) (>= ?b 0.0)) then
    (return (- (+ ?a ?b) (* ?a ?b))))
  (if (and (<= ?a 0.0) (<= ?b 0.0)) then
    (return (+ (+ ?a ?b) (* ?a ?b))))
  (bind ?m (min (abs ?a) (abs ?b)))
  (return (/ (+ ?a ?b) (- 1 ?m)))
)

; Convierte un nivel cualitativo (baja/media/alta) en un numero para medir
; distancias entre el nivel pedido y el real.
(deffunction nivel-num (?n)
  (if (eq ?n baja) then (return 1))
  (if (eq ?n media) then (return 2))
  (if (eq ?n alta) then (return 3))
  (return 0)
)

(deffunction cf-nivel (?deseado ?real)
  (bind ?d (abs (- (nivel-num ?deseado) (nivel-num ?real))))
  (if (= ?d 0) then (return 0.85))
  (if (= ?d 1) then (return 0.25))
  (return -0.6)
)


(deffunction membership (?value ?a ?b ?c ?d)
  (if (< ?value ?a) then (bind ?rv 0)
    else
      (if (< ?value ?b) then (bind ?rv (/ (- ?value ?a) (- ?b ?a)))
        else
          (if (< ?value ?c) then (bind ?rv 1)
            else
              (if (< ?value ?d) then (bind ?rv (/ (- ?d ?value) (- ?d ?c)))
                else (bind ?rv 0)))))
  ?rv
)

; Conjuntos difusos de densidad calorica definidos sobre las kcal de la receta.

(deffunction grado-densidad (?kcal ?cat)
  (if (eq ?cat baja)  then (return (membership ?kcal 0 0 120 200)))    ; ligera
  (if (eq ?cat media) then (return (membership ?kcal 150 220 300 380))); media
  (if (eq ?cat alta)  then (return (membership ?kcal 320 420 5000 5000))) ; copiosa
  (return 0)
)

;;; ---- (4) RAZONAMIENTO PROBABILISTICO ----

; Traduce un factor de certeza [-1,1] a una probabilidad [0,1] de que el
; usuario quede satisfecho en ese aspecto.

(deffunction cf-a-prob (?cf)
  (+ 0.5 (/ ?cf 2))
)

; Probabilidad de que la receta resulte satisfactoria, combinando las
; probabilidades por aspecto con su media geométrica.

(deffunction prob-acierto-receta (?r)
  (bind ?p 1.0)
  (bind ?n 0)
  (do-for-all-facts ((?e evidencia))
                    (and (eq ?e:receta ?r) (neq ?e:descripcion ""))
    (bind ?p (* ?p (cf-a-prob ?e:cf)))
    (bind ?n (+ ?n 1)))
  (if (= ?n 0) then (return 0.5))
  (return (** ?p (/ 1.0 ?n)))
)

; Combina todas las evidencias acumuladas sobre una receta en un unico CF.
(deffunction cf-combinada-receta (?r)
  (bind ?acc 0.0)
  (do-for-all-facts ((?e evidencia)) (eq ?e:receta ?r)
    (bind ?acc (combinar-cf ?acc ?e:cf)))
  (return ?acc)
)

; Traduce el CF global a una etiqueta comprensible para el usuario.
(deffunction etiqueta-confianza (?cf)
  (if (>= ?cf 0.7) then (return "MUY recomendable"))
  (if (>= ?cf 0.4) then (return "recomendable"))
  (if (>= ?cf 0.1) then (return "aceptable"))
  (if (>= ?cf -0.1) then (return "indiferente"))
  (return "poco adecuada")
)

; Une una lista de frases en una enumeracion natural: "a, b y c".
(deffunction unir-frases ($?frases)
  (bind ?n (length$ ?frases))
  (if (= ?n 0) then (return ""))
  (bind ?res (nth$ 1 ?frases))
  (bind ?i 2)
  (while (<= ?i ?n) do
    (if (= ?i ?n)
      then (bind ?res (str-cat ?res " y " (nth$ ?i ?frases)))
      else (bind ?res (str-cat ?res ", " (nth$ ?i ?frases))))
    (bind ?i (+ ?i 1)))
  (return ?res)
)

; Redacta, al final del proceso, un texto natural que justifica por que se
; aconseja la receta   
  (if (and (neq ?dieta ns) (neq ?dieta normal) (neq ?dieta fin)) then
    (bind ?restr (create$ ?restr (str-cat "es apta para dieta " ?dieta))))
  (if (eq ?sl si) then (bind ?restr (create$ ?restr "no contiene lactosa")))
  (if (eq ?sg si) then (bind ?restr (create$ ?restr "no contiene gluten")))
  (if (and (neq ?ing ns) (neq ?ing fin)) then
    (bind ?restr (create$ ?restr (str-cat "incluye " ?ing))))

  ;; --- Evidencia a favor y en contra (preferencias + razonamiento por defecto) ---
  (bind ?favor (create$))
  (bind ?contra (create$))
  (do-for-all-facts ((?e evidencia))
                    (and (eq ?e:receta ?r) (neq ?e:descripcion ""))
    (if (>= ?e:cf 0.0)
      then (bind ?favor (create$ ?favor ?e:descripcion))
      else (bind ?contra (create$ ?contra ?e:descripcion))))

  ;; --- Preguntas que no se hicieron por no discriminar ---
  (bind ?omit (create$))
  (do-for-all-facts ((?o pregunta-omitida)) TRUE
    (bind ?omit (create$ ?omit ?o:que)))

  ;; Redaccion del texto
  (printout t crlf "Por que te aconsejo esta receta:" crlf "  ")
  (if (> (length$ ?restr) 0)
    then (printout t "Marcaste condiciones innegociables y esta receta las respeta todas: "
                    (unir-frases ?restr) ". ")
    else (printout t "No fijaste ninguna restriccion obligatoria, asi que parti de todo el recetario. "))
  (if (> (length$ ?favor) 0) then
    (printout t "Encaja con lo que buscas porque " (unir-frases ?favor) ". "))
  (if (> (length$ ?contra) 0) then
    (printout t "El unico pero es que " (unir-frases ?contra)
              ", aunque no es razon suficiente para descartarla. "))
  (if (> (length$ ?omit) 0) then
    (printout t "No te pregunte por " (unir-frases ?omit)
              " porque todas las recetas compatibles coincidian en eso. "))
  (printout t "Combinando estas evidencias con factores de certeza obtengo una confianza "
            (etiqueta-confianza ?cf) " (CF=" ?cf "), la mas alta entre las recetas que cumplen tus restricciones. ")
  (printout t "Como segunda opinion, un modelo probabilistico  estima una probabilidad de acierto del "
            (round (* 100 (prob-acierto-receta ?r))) "%." crlf)
)

(defrule comprobar-recetas-cargadas
  (declare (salience 1000))
  ?f <- (arrancar)
  (not (receta (nombre ?)))
  =>
  (retract ?f)
  (printout t crlf "No hay recetas cargadas. Ejecuta (load del archivo con las recetas), reset y run." crlf)
  (assert (fin))
)

(defrule mensaje-bienvenida
  (declare (salience 990))
  ?f <- (arrancar)
  =>
  (retract ?f)
  (assert (fase preguntar))
  (printout t crlf "=== Sistema experto de recetas (con factores de certeza) ===" crlf)
  (printout t "Responde en minuscula o mayuscula. 'ns' significa sin preferencia." crlf)
  (printout t "Si respondes 'fin' antes de la recomendacion, el sistema recomendara con lo respondido hasta ese momento." crlf)
  (printout t crlf)
  (printout t "RESTRICCIONES (dieta, sin lactosa, sin gluten, ingrediente" crlf)
  (printout t "PREFERENCIAS (tipo, proteina, calorias, comensales, tiempo) no descartan: suman o restan certeza." crlf)
)

;; MODULO 2: PEDIR INFORMACION


(defrule pregunta-dieta
  (declare (salience 800))
  (fase preguntar)
  ?f <- (pregunta dieta)
  =>
  (retract ?f)
  (printout t crlf " La dieta es una restriccion innegociable: descartare por completo las recetas que no la cumplan." crlf)
  (printout t "Dieta (normal|vegetariana|vegana|ns|fin): ")
  (assert (respuesta-dieta (normalizar-respuesta (read))))
)

(defrule validar-dieta
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-dieta ?r)
  (test (not (dieta-valida ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para dieta." crlf)
  (assert (pregunta dieta))
)

(defrule pregunta-tipo
  (declare (salience 794))
  (fase preguntar)
  ?f <- (pregunta tipo)
  =>
  (retract ?f)

  ;; MODULO 3: proponer tipo de receta segun preferencia del usuario.
  ;; Si responde ns, no aporta evidencia de tipo.
  (printout t crlf "que pregunto esto] El tipo es una preferencia: no descarta, da mucha certeza a las recetas del tipo pedido." crlf)
  (printout t "Tipo (principal|entrante|postre|ns|fin): ")
  (assert (respuesta-tipo (normalizar-respuesta (read))))
)

(defrule validar-tipo
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-tipo ?r)
  (test (not (tipo-valido ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para tipo." crlf)
  (assert (pregunta tipo))
)

(defrule omitir-sin-lactosa-si-vegana
  (declare (salience 850))
  (fase preguntar)
  (respuesta-dieta vegana)
  ?q <- (pregunta sin_lactosa)
  =>
  (retract ?q)
  (do-for-all-facts ((?f respuesta-sin-lactosa)) TRUE (retract ?f))
  (assert (respuesta-sin-lactosa (valor si)))
)

(defrule poner-default-ingrediente-pronto
  (declare (salience 845))
  (fase preguntar)
  (not (respuesta-ingrediente-obligatorio ?))
  =>
  (assert (respuesta-ingrediente-obligatorio ns))
)

(defrule pregunta-sin-lactosa
  (declare (salience 799))
  (fase preguntar)
  ?f <- (pregunta sin_lactosa)
  =>
  (retract ?f)
  (printout t crlf " Es una restriccion: si la evitas, descartare las recetas con lactosa." crlf)
  (printout t "Quieres que sea sin lactosa? (si|no|ns|fin): ")
  (assert (respuesta-sin-lactosa (valor (normalizar-respuesta (read)))))
)

(defrule validar-sin-lactosa
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-sin-lactosa (valor ?r))
  (test (not (si-no-valido ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para sin lactosa." crlf)
  (assert (pregunta sin_lactosa))
)

(defrule pregunta-sin-gluten
  (declare (salience 798))
  (fase preguntar)
  ?f <- (pregunta sin_gluten)
  =>
  (retract ?f)
  (printout t crlf "Es una restriccion: si lo evitas, descartare las recetas con gluten." crlf)
  (printout t "Quieres que sea sin gluten? (si|no|ns|fin): ")
  (assert (respuesta-sin-gluten (valor (normalizar-respuesta (read)))))
)

(defrule validar-sin-gluten
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-sin-gluten (valor ?r))
  (test (not (si-no-valido ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para sin gluten." crlf)
  (assert (pregunta sin_gluten))
)
;; compruebo que de las recetas que quedan, tenga o no todos sus campos 
;; sin lactosa o sin gluten con el mismo valor 
;; si tienen el mismo valor me salto la pregunta 
;; las siguientes reglas  hacen lo mismo pero con otros atributos en las siguientes definiciones 
(defrule omitir-tipo-si-no-aporta
  (declare (salience 840))
  (fase preguntar)
  (respuesta-dieta ?d&~fin)
  (respuesta-sin-lactosa (valor ?sl&~fin));; respuesta que no sea fin
  (respuesta-sin-gluten (valor ?sg&~fin))
  (respuesta-ingrediente-obligatorio ?ing&~fin)
  ?q <- (pregunta tipo)
  (test (unico-campo-base tipo ?d ?sl ?sg ?ing))
  =>
  (retract ?q)
  (printout t crlf "[No te pregunto el TIPO] Todas las recetas que aun encajan coinciden en el tipo, asi que preguntarlo no aportaria nada." crlf)
  (assert (pregunta-omitida (que tipo)))
)

(defrule omitir-proteina-si-no-aporta
  (declare (salience 839))
  (fase preguntar)
  (respuesta-dieta ?d&~fin) ;; respuesta que no sea fin 
  (respuesta-sin-lactosa (valor ?sl&~fin))
  (respuesta-sin-gluten (valor ?sg&~fin))
  (respuesta-ingrediente-obligatorio ?ing&~fin)
  ?q <- (pregunta proteina)
  (test (unico-campo-base proteinas ?d ?sl ?sg ?ing))
  =>
  (retract ?q)
  (printout t crlf "[No te pregunto la PROTEINA] Todas las recetas compatibles tienen el mismo nivel, no discriminaria." crlf)
  (assert (pregunta-omitida (que proteina)))
)

(defrule omitir-densidad-si-no-aporta
  (declare (salience 838))
  (fase preguntar)
  (respuesta-dieta ?d&~fin)
  (respuesta-sin-lactosa (valor ?sl&~fin))
  (respuesta-sin-gluten (valor ?sg&~fin))
  (respuesta-ingrediente-obligatorio ?ing&~fin)
  ?q <- (pregunta densidad_calorica)
  (test (unico-campo-base calorias ?d ?sl ?sg ?ing))
  =>
  (retract ?q)
  (printout t crlf "[No te pregunto la DENSIDAD CALORICA] Todas las recetas compatibles comparten el mismo nivel." crlf)
  (assert (pregunta-omitida (que densidad_calorica)))
)

(defrule omitir-comensales-si-no-aporta
  (declare (salience 837))
  (fase preguntar)
  (respuesta-dieta ?d&~fin)
  (respuesta-sin-lactosa (valor ?sl&~fin))
  (respuesta-sin-gluten (valor ?sg&~fin))
  (respuesta-ingrediente-obligatorio ?ing&~fin)
  ?q <- (pregunta comensales)
  (test (unico-campo-base comensales ?d ?sl ?sg ?ing))
  =>
  (retract ?q)
  (printout t crlf "[No te pregunto los COMENSALES] Todas las recetas compatibles rinden para el mismo numero." crlf)
  (assert (pregunta-omitida (que comensales)))
)

(defrule omitir-tiempo-si-no-aporta
  (declare (salience 836))
  (fase preguntar)
  (respuesta-dieta ?d&~fin)
  (respuesta-sin-lactosa (valor ?sl&~fin))
  (respuesta-sin-gluten (valor ?sg&~fin))
  (respuesta-ingrediente-obligatorio ?ing&~fin)
  ?q <- (pregunta tiempo)
  (test (unico-campo-base tiempo ?d ?sl ?sg ?ing))
  =>
  (retract ?q)
  (printout t crlf "[No te pregunto el TIEMPO] Todas las recetas compatibles tardan lo mismo." crlf)
  (assert (pregunta-omitida (que tiempo)))
)
(defrule pregunta-ingrediente-obligatorio
  (declare (salience 797))
  (fase preguntar)
  ?f <- (pregunta ingrediente_obligatorio)
  =>
  (retract ?f)
  (printout t crlf "Es una restriccion: si fijas un ingrediente, solo conservare recetas que lo lleven." crlf)
  (printout t "Ingrediente obligatorio (texto|ns|fin): ")
  (assert (respuesta-ingrediente-obligatorio (normalizar-respuesta (read))))
)
(defrule pregunta-comensales
  (declare (salience 796))
  (fase preguntar)
  ?f <- (pregunta comensales)
  =>
  (retract ?f)
  (printout t crlf "Es una preferencia: doy mas certeza a las recetas que cubren ese numero de comensales." crlf)
  (printout t "Comensales (numero|ns|fin): ")
  (assert (respuesta-comensales (normalizar-respuesta (read))))
)

(defrule validar-comensales
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-comensales ?r)
  (test (not (numero-o-control ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para comensales." crlf)
  (assert (pregunta comensales))
)

(defrule pregunta-tiempo
  (declare (salience 795))
  (fase preguntar)
  ?f <- (pregunta tiempo)
  =>
  (retract ?f)
  (printout t crlf "Es una preferencia: premio a las recetas dentro de tu tiempo y penalizo gradualmente a las que se pasan." crlf)
  (printout t "Tiempo maximo en minutos (numero|ns|fin): ")
  (assert (respuesta-tiempo (normalizar-respuesta (read))))
)

(defrule pregunta-proteina
  (declare (salience 793))
  (fase preguntar)
  ?f <- (pregunta proteina)
  =>
  (retract ?f)
  (printout t crlf "Es una preferencia: el nivel exacto da mas certeza y un nivel adyacente suma algo (parecido parcial)." crlf)
  (printout t "Nivel de proteina (alta|media|baja|ns|fin): ")
  (assert (respuesta-proteina (normalizar-respuesta (read))))
)

(defrule validar-proteina
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-proteina ?r)
  (test (not (proteina-valida ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para proteina." crlf)
  (assert (pregunta proteina))
)

(defrule validar-tiempo
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-tiempo ?r)
  (test (not (numero-o-control ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para tiempo." crlf)
  (assert (pregunta tiempo))
)



(defrule pregunta-densidad-calorica
  (declare (salience 792))
  (fase preguntar)
  ?f <- (pregunta densidad_calorica)
  =>
  (retract ?f)
  (printout t crlf " Es una preferencia: el nivel exacto da mas certeza y un nivel adyacente suma algo (parecido parcial)." crlf)
  (printout t "Densidad calorica (alta|media|baja|ns|fin): ")
  (assert (respuesta-densidad-calorica (normalizar-respuesta (read))))
)

(defrule validar-densidad-calorica
  (declare (salience 900))
  (fase preguntar)
  ?f <- (respuesta-densidad-calorica ?r)
  (test (not (densidad-calorica-valida ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para densidad calorica." crlf)
  (assert (pregunta densidad_calorica))
)

(defrule finalizar-preguntas-por-fin
  (declare (salience 950))
  ?p <- (fase preguntar)
  (or (respuesta-dieta fin)
      (respuesta-sin-lactosa (valor fin))
      (respuesta-sin-gluten (valor fin))
      (respuesta-tipo fin)
      (respuesta-comensales fin)
      (respuesta-tiempo fin)
      (respuesta-proteina fin)
      (respuesta-densidad-calorica fin)
      (respuesta-ingrediente-obligatorio fin)
  )
  =>
  (retract ?p)
  (assert (fase elegir))
)

(defrule finalizar-preguntas
  ?p <- (fase preguntar)
  (not (pregunta ?))
  =>
  (retract ?p)
  (assert (fase elegir))
)
;;Garantizo qe haya respuestas para todo , hago 
;; que si no hay ningun fact que coincidad con lo indicaado , este se quede en ns
(defrule defaults-respuestas
  (fase elegir)
  (not (defaults-listos))
  =>
  (if (not (any-factp ((?f respuesta-dieta)) TRUE)) then (assert (respuesta-dieta ns)))
  (if (not (any-factp ((?f respuesta-sin-lactosa)) TRUE)) then (assert (respuesta-sin-lactosa (valor ns))))
  (if (not (any-factp ((?f respuesta-sin-gluten)) TRUE)) then (assert (respuesta-sin-gluten (valor ns))))
  (if (not (any-factp ((?f respuesta-tipo)) TRUE)) then (assert (respuesta-tipo ns)))
  (if (not (any-factp ((?f respuesta-comensales)) TRUE)) then (assert (respuesta-comensales ns)))
  (if (not (any-factp ((?f respuesta-tiempo)) TRUE)) then (assert (respuesta-tiempo ns)))
  (if (not (any-factp ((?f respuesta-proteina)) TRUE)) then (assert (respuesta-proteina ns)))
  (if (not (any-factp ((?f respuesta-densidad-calorica)) TRUE)) then (assert (respuesta-densidad-calorica ns)))
  (if (not (any-factp ((?f respuesta-ingrediente-obligatorio)) TRUE)) then (assert (respuesta-ingrediente-obligatorio ns)))
  (assert (defaults-listos))
)

;; ------------------------
;; MODULO 3: FILTRADO POR RESTRICCIONES ESENCIALES (conocimiento cierto)
;; ------------------------
;; Se parte de TODAS las recetas y se descartan unicamente las que incumplen
;; una restriccion que el usuario considera innegociable (dieta, sin lactosa,
;; sin gluten, ingrediente obligatorio). El resto de condiciones no se descartan
;; aqui: se valoran despues con factores de certeza (MODULO 4).

(defrule iniciar-evaluacion
  (declare (salience 700))
  (fase elegir)
  (defaults-listos)
  (not (evaluacion-iniciada))
  =>
  (limpiar-evaluacion)
  (crear-candidatas-iniciales)
  (assert (evaluacion-iniciada))
)

(defrule filtrar-vegana
  (fase elegir)
  (respuesta-dieta vegana)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta no_vegana ?r)
  =>
  (retract ?f)
)

(defrule filtrar-vegetariana
  (fase elegir)
  (respuesta-dieta vegetariana)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta no_vegetariana ?r)
  =>
  (retract ?f)
)

(defrule filtrar-sin-lactosa
  (fase elegir)
  (respuesta-sin-lactosa (valor si))
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta contiene_lactosa ?r)
  =>
  (retract ?f)
)

(defrule filtrar-sin-gluten
  (fase elegir)
  (respuesta-sin-gluten (valor si))
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta contiene_gluten ?r)
  =>
  (retract ?f)
)

(defrule filtrar-ingrediente-obligatorio
  (fase elegir)
  (respuesta-ingrediente-obligatorio ?ing&~ns)
  ?f <- (RecetaCandidata (nombre ?r))
  (not (and (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
            (test (contiene ?a (sym-cat ?ing)))))
  =>
  (retract ?f)
)

;; Cuando ya no queda ningun filtro duro por aplicar, pasamos a valorar las
;; recetas supervivientes con factores de certeza.
(defrule pasar-a-puntuar
  (declare (salience -50))
  ?f <- (fase elegir)
  =>
  (retract ?f)
  (assert (fase puntuar))
)

;; ------------------------
;; MODULO 4: VALORACION POR FACTORES DE CERTEZA (incertidumbre)
;; ------------------------
;; Para cada receta superviviente y cada PREFERENCIA expresada por el usuario
;; se genera una evidencia con su CF. Las preferencias no expresadas (ns) no
;; generan evidencia: ;; (1) RAZONAMIENTO POR DEFECTO: igual que "por defecto un ave vuela", a falta
;; de TODA preferencia asumimos por defecto que el usuario prefiere recetas
;; faciles. Esta suposicion solo se activa cuando no hay ninguna otra evidencia

(defrule evidencia-por-defecto-dificultad
  (declare (salience 10))
  (fase puntuar)
  (RecetaCandidata (nombre ?r))
  (receta (nombre ?r) (dificultad ?dif))
  (respuesta-tipo ns)
  (respuesta-proteina ns)
  (respuesta-densidad-calorica ns)
  (respuesta-comensales ns)
  (respuesta-tiempo ns)
  (not (evidencia (receta ?r) (factor dificultad)))
  =>
  (bind ?cf 0.0)
  (bind ?txt "")
  (if (eq ?dif facil) then
    (bind ?cf 0.3)
    (bind ?txt "por defecto (no diste preferencias) priorizo que sea facil de preparar"))
  (if (eq ?dif dificil) then
    (bind ?cf -0.3)
    (bind ?txt "por defecto (no diste preferencias) evito las recetas dificiles, y esta lo es"))
  (assert (evidencia (receta ?r) (factor dificultad) (cf ?cf) (descripcion ?txt)))
)

(defrule evidencia-tipo
  (declare (salience 10))
  (fase puntuar)
  (RecetaCandidata (nombre ?r))
  (respuesta-tipo ?tp&~ns&~fin)
  (receta (nombre ?r) (tipo-plato ?real))
  (not (evidencia (receta ?r) (factor tipo)))
  =>
  (bind ?objetivo (tipo-respuesta-a-simbolo ?tp))
  (if (eq ?real ?objetivo) then
    (assert (evidencia (receta ?r) (factor tipo) (cf 0.85)
      (descripcion (str-cat "es un plato " ?real ", justo el tipo que buscabas"))))
  else
    (assert (evidencia (receta ?r) (factor tipo) (cf -0.7)
      (descripcion (str-cat "no es del tipo " ?objetivo " que pediste, sino " ?real)))))
)

(defrule evidencia-proteina
  (declare (salience 10))
  (fase puntuar)
  (RecetaCandidata (nombre ?r))
  (respuesta-proteina ?p&~ns&~fin)
  (propiedad_receta proteinas ?real ?r)
  (not (evidencia (receta ?r) (factor proteinas)))
  =>
  (bind ?cf (cf-nivel ?p ?real))
  (bind ?d (abs (- (nivel-num ?p) (nivel-num ?real))))
  (if (= ?d 0) then
    (bind ?txt (str-cat "tiene el nivel de proteina " ?real " que querias"))
  else
    (if (= ?d 1) then
      (bind ?txt (str-cat "su proteina (" ?real ") se aproxima a la " ?p " que pediste"))
    else
      (bind ?txt (str-cat "su proteina es " ?real ", lejos de la " ?p " que pediste"))))
  (assert (evidencia (receta ?r) (factor proteinas) (cf ?cf) (descripcion ?txt)))
)

;; LOGICA DIFUSA: el encaje de la densidad calorica se mide con el grado de
;; pertenencia  de las kcal reales al conjunto difuso pedido.
(defrule evidencia-calorias
  (declare (salience 10))
  (fase puntuar)
  (RecetaCandidata (nombre ?r))
  (respuesta-densidad-calorica ?dc&~ns&~fin)
  (receta (nombre ?r) (info-nutricional $?info))
  (not (evidencia (receta ?r) (factor calorias)))
  =>
  (bind ?kcal (obtener-kcal ?info))
  (bind ?mu (grado-densidad ?kcal ?dc))
  (bind ?cf (* 0.85 (- (* 2 ?mu) 1)))
  (bind ?pct (round (* 100 ?mu)))
  (if (>= ?mu 0.5)
    then (bind ?txt (str-cat "sus " ?kcal " kcal encajan con densidad '" ?dc
                             "' en grado difuso " ?pct "%"))
    else (bind ?txt (str-cat "sus " ?kcal " kcal apenas encajan con densidad '" ?dc
                             "' (grado difuso " ?pct "%)")))
  (assert (evidencia (receta ?r) (factor calorias) (cf ?cf) (descripcion ?txt)))
)

(defrule evidencia-comensales
  (declare (salience 10))
  (fase puntuar)
  (RecetaCandidata (nombre ?r))
  (respuesta-comensales ?n&:(numberp ?n))
  (receta (nombre ?r) (comensales ?c))
  (not (evidencia (receta ?r) (factor comensales)))
  =>
  (if (>= ?c ?n) then
    (assert (evidencia (receta ?r) (factor comensales) (cf 0.5)
      (descripcion (str-cat "rinde para " ?c " comensales, cubriendo los " ?n " que necesitas"))))
  else
    (bind ?gap (- ?n ?c))
    (bind ?cf (max -0.7 (* -0.25 ?gap)))
    (assert (evidencia (receta ?r) (factor comensales) (cf ?cf)
      (descripcion (str-cat "se queda algo corta: rinde para " ?c " y necesitabas " ?n)))))
)

(defrule evidencia-tiempo
  (declare (salience 10))
  (fase puntuar)
  (RecetaCandidata (nombre ?r))
  (respuesta-tiempo ?t&:(numberp ?t))
  (receta (nombre ?r) (tiempo-cocinado ?tc))
  (not (evidencia (receta ?r) (factor tiempo)))
  =>
  (if (<= ?tc ?t) then
    (bind ?cf 0.5)
    (bind ?txt (str-cat "se prepara en " ?tc " minutos, dentro de tu limite de " ?t))
  else
    (bind ?over (- ?tc ?t))
    (if (<= ?over 15) then
      (bind ?cf 0.1)
      (bind ?txt (str-cat "tarda " ?tc " minutos, solo un poco mas de los " ?t " que querias"))
    else
      (if (<= ?over 30) then
        (bind ?cf -0.3)
        (bind ?txt (str-cat "tarda " ?tc " minutos, bastante mas de los " ?t " que querias"))
      else
        (bind ?cf -0.6)
        (bind ?txt (str-cat "tarda " ?tc " minutos, mucho mas de los " ?t " que querias")))))
  (assert (evidencia (receta ?r) (factor tiempo) (cf ?cf) (descripcion ?txt)))
)

;; Una vez generada toda la evidencia (salience mayor), se combina en el CF
;; global de cada receta. Se ejecuta una sola vez por receta.
(defrule combinar-cf-receta
  (declare (salience 5))
  (fase puntuar)
  ?c <- (RecetaCandidata (nombre ?r))
  (not (cf-calculada (receta ?r)))
  =>
  (modify ?c (cf (acotar-cf (cf-combinada-receta ?r))))
  (assert (cf-calculada (receta ?r)))
)

;; Cuando todas las candidatas tienen su CF combinado, pasamos a proponer.
(defrule pasar-a-resultados
  (declare (salience -10))
  ?f <- (fase puntuar)
  (not (and (RecetaCandidata (nombre ?r)) (not (cf-calculada (receta ?r)))))
  =>
  (retract ?f)
  (assert (fase resultados))
)

;; ------------------------
;; MODULO 5: PROPONER RECETA Y PERMITIR REAJUSTES
;; ------------------------
;; Se propone primero la receta de MAYOR factor de certeza, justificando cada
;; aporte. El usuario puede aceptar, rechazar (se ofrece la siguiente mejor) o
;; reajustar un criterio y relanzar el razonamiento.

(defrule sin-recetas-compatibles
  ?fr <- (fase resultados)
  (not (RecetaCandidata (nombre ?)))
  =>
  (retract ?fr)
  (printout t crlf "No hay recetas compatibles con los criterios actuales." crlf)
  (printout t "Quieres modificar un parametro? (dieta|tipo|comensales|tiempo|proteina|calorias|ingrediente|salir): ")
  (bind ?x (normalizar-respuesta (read)))

  (if (eq ?x dieta) then
    (printout t "Nueva dieta (normal|vegetariana|vegana|ns): ")
    (do-for-all-facts ((?f respuesta-dieta)) TRUE (retract ?f))
    (assert (respuesta-dieta (normalizar-respuesta (read)))))

  (if (eq ?x tipo) then
    (printout t "Nuevo tipo (principal|entrante|postre|ns): ")
    (do-for-all-facts ((?f respuesta-tipo)) TRUE (retract ?f))
    (assert (respuesta-tipo (normalizar-respuesta (read)))))

  (if (eq ?x comensales) then
    (printout t "Nuevos comensales (numero|ns): ")
    (do-for-all-facts ((?f respuesta-comensales)) TRUE (retract ?f))
    (assert (respuesta-comensales (normalizar-respuesta (read)))))

  (if (eq ?x tiempo) then
    (printout t "Nuevo tiempo maximo (numero|ns): ")
    (do-for-all-facts ((?f respuesta-tiempo)) TRUE (retract ?f))
    (assert (respuesta-tiempo (normalizar-respuesta (read)))))

  (if (eq ?x proteina) then
    (printout t "Nuevo nivel de proteina (alta|media|baja|ns): ")
    (do-for-all-facts ((?f respuesta-proteina)) TRUE (retract ?f))
    (assert (respuesta-proteina (normalizar-respuesta (read)))))

  (if (or (eq ?x densidad) (eq ?x calorias)) then
    (printout t "Nueva densidad calorica (alta|media|baja|ns): ")
    (do-for-all-facts ((?f respuesta-densidad-calorica)) TRUE (retract ?f))
    (assert (respuesta-densidad-calorica (normalizar-respuesta (read)))))

  (if (eq ?x ingrediente) then
    (printout t "Nuevo ingrediente obligatorio (texto|ns): ")
    (do-for-all-facts ((?f respuesta-ingrediente-obligatorio)) TRUE (retract ?f))
    (assert (respuesta-ingrediente-obligatorio (normalizar-respuesta (read)))))

  (if (or (eq ?x dieta) (eq ?x tipo) (eq ?x comensales) (eq ?x tiempo)
          (eq ?x proteina) (eq ?x densidad) (eq ?x calorias) (eq ?x ingrediente)) then
    (do-for-all-facts ((?f defaults-listos)) TRUE (retract ?f))
    (do-for-all-facts ((?f evaluacion-iniciada)) TRUE (retract ?f))
    (assert (fase elegir))
  else
    (assert (fin)))
)

;; Propone la receta NO rechazada con mayor factor de certeza (no existe otra
;; candidata viable con CF estrictamente mayor) y muestra su justificacion.
(defrule mostrar-receta
  (fase resultados)
  (RecetaCandidata (nombre ?r) (cf ?cf))
  (not (RecetaRechazada (nombre ?r) (motivo ?)))
  (not (RecetaOfertada (nombre ?)))
  (not (and (RecetaCandidata (nombre ?o) (cf ?cf2))
            (not (RecetaRechazada (nombre ?o) (motivo ?)))
            (test (> ?cf2 ?cf))))
  (receta (nombre ?r) (tipo-plato ?tp) (dificultad ?d) (comensales ?c) (tiempo-cocinado ?t))
  (respuesta-dieta ?dietaPref)
  (respuesta-sin-lactosa (valor ?slPref))
  (respuesta-sin-gluten (valor ?sgPref))
  (respuesta-ingrediente-obligatorio ?ingPref)
  =>
  (assert (RecetaOfertada (nombre ?r)))
  (printout t crlf "----------------------------------------" crlf)
  (printout t "Receta recomendada: " ?r crlf)
  (printout t "Tipo: " ?tp ", dificultad: " ?d ", comensales: " ?c ", tiempo: " ?t " min" crlf)
  (explicar-receta ?r ?cf ?dietaPref ?slPref ?sgPref ?ingPref)
  (printout t "----------------------------------------" crlf)
  (printout t "Respuesta (a|rechazar|dieta|tipo|comensales|tiempo|proteina|calorias|ingrediente): ")
  (assert (respuesta-final (normalizar-respuesta (read))))
)

(defrule aceptar-receta
  ?fr <- (fase resultados)
  ?o <- (RecetaOfertada (nombre ?r))
  ?a <- (respuesta-final a)
  =>
  (retract ?fr ?o ?a)
  (printout t crlf "Receta aceptada: " ?r crlf)
  (assert (fin))
)

(defrule rechazar-receta
  ?o <- (RecetaOfertada (nombre ?r))
  ?a <- (respuesta-final rechazar)
  =>
  (retract ?o ?a)
  (assert (RecetaRechazada (nombre ?r) (motivo rechazar)))
)

(defrule reajustar-criterio
  ?o <- (RecetaOfertada (nombre ?r))
  ?a <- (respuesta-final ?x&:(or (eq ?x dieta) (eq ?x tipo) (eq ?x comensales) (eq ?x tiempo) (eq ?x proteina) (eq ?x densidad) (eq ?x calorias) (eq ?x ingrediente)))
  =>
  (retract ?o ?a)
  (assert (RecetaRechazada (nombre ?r) (motivo ?x)))

  (if (eq ?x dieta) then
    (printout t "Nueva dieta (normal|vegetariana|vegana|ns): ")
    (do-for-all-facts ((?f respuesta-dieta)) TRUE (retract ?f))
    (assert (respuesta-dieta (normalizar-respuesta (read)))))

  (if (eq ?x tipo) then
    (printout t "Nuevo tipo (principal|entrante|postre|ns): ")
    (do-for-all-facts ((?f respuesta-tipo)) TRUE (retract ?f))
    (assert (respuesta-tipo (normalizar-respuesta (read)))))

  (if (eq ?x comensales) then
    (printout t "Nuevos comensales (numero|ns): ")
    (do-for-all-facts ((?f respuesta-comensales)) TRUE (retract ?f))
    (assert (respuesta-comensales (normalizar-respuesta (read)))))

  (if (eq ?x tiempo) then
    (printout t "Nuevo tiempo maximo (numero|ns): ")
    (do-for-all-facts ((?f respuesta-tiempo)) TRUE (retract ?f))
    (assert (respuesta-tiempo (normalizar-respuesta (read)))))

  (if (eq ?x proteina) then
    (printout t "Nuevo nivel de proteina (alta|media|baja|ns): ")
    (do-for-all-facts ((?f respuesta-proteina)) TRUE (retract ?f))
    (assert (respuesta-proteina (normalizar-respuesta (read)))))

  (if (or (eq ?x densidad) (eq ?x calorias)) then
    (printout t "Nueva densidad calorica (alta|media|baja|ns): ")
    (do-for-all-facts ((?f respuesta-densidad-calorica)) TRUE (retract ?f))
    (assert (respuesta-densidad-calorica (normalizar-respuesta (read)))))

  (if (eq ?x ingrediente) then
    (printout t "Nuevo ingrediente obligatorio (texto|ns): ")
    (do-for-all-facts ((?f respuesta-ingrediente-obligatorio)) TRUE (retract ?f))
    (assert (respuesta-ingrediente-obligatorio (normalizar-respuesta (read)))))

  (do-for-all-facts ((?f defaults-listos)) TRUE (retract ?f))
  (do-for-all-facts ((?f evaluacion-iniciada)) TRUE (retract ?f))
  (do-for-all-facts ((?f fase)) (eq (nth$ 1 ?f:implied) resultados) (retract ?f))
  (assert (fase elegir))
)

;; Habia recetas compatibles, pero el usuario las ha ido rechazando todas.
(defrule sin-mas-recetas
  ?fr <- (fase resultados)
  (not (RecetaOfertada (nombre ?)))
  (RecetaCandidata (nombre ?))
  (not (and (RecetaCandidata (nombre ?r))
            (not (RecetaRechazada (nombre ?r) (motivo ?)))))
  =>
  (retract ?fr)
  (printout t crlf "No quedan mas recetas para proponer (has rechazado todas las compatibles)." crlf)
  (assert (fin))
)

(defrule cerrar-sistema
  (declare (salience -1000))
  (fin)
  =>
  (printout t crlf "--- Fin del sistema experto ---" crlf)
)
