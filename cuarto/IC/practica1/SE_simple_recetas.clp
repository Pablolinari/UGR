
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





; 1) Ingredientes relevantes

(defrule ingrediente-relevante-por-nombre
  (receta (nombre ?r))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (contiene ?r ?a))
  (not (propiedad_receta ingrediente_relevante ?r ?a))
  =>
  (assert (propiedad_receta ingrediente_relevante ?r ?a))
)

(defrule ingrediente-relevante-por-tipo
  (receta (nombre ?r))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (es-importante ?a))
  (not (propiedad_receta ingrediente_relevante ?r ?a))
  =>
  (assert (propiedad_receta ingrediente_relevante ?r ?a))
)


; 2) Deducir tipo de plato si no viene informado

(defrule deducir-tipo-plato-postre
  ?f <- (receta (nombre ?r) (tipo-plato ?tp&:(or (eq ?tp desconocido) (eq ?tp sin-clasificar) (eq ?tp ninguno))))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (es-dulce ?a))
  =>
  (modify ?f (tipo-plato postre))
)

(defrule deducir-tipo-plato-principal
  ?f <- (receta (nombre ?r) (tipo-plato ?tp&:(or (eq ?tp desconocido) (eq ?tp sin-clasificar) (eq ?tp ninguno))))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (es-importante ?a))
  =>
  (modify ?f (tipo-plato principal))
)

(defrule deducir-tipo-plato-por-defecto
  (declare (salience -5))
  ?f <- (receta (nombre ?r) (tipo-plato ?tp&:(or (eq ?tp desconocido) (eq ?tp sin-clasificar) (eq ?tp ninguno))))
  =>
  (modify ?f (tipo-plato entrante))
)


; 3) Clasificaciones: vegana/vegetariana/picante/sin gluten/sin lactosa
;    + calorias/proteinas

(defrule marcar-picante
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
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (contiene ?a "huevo"))
  (not (propiedad_receta no_vegana ?r))
  =>
  (assert (propiedad_receta no_vegana ?r))
)

(defrule marcar-no-vegana-por-animal
  (propiedad_receta no_vegetariana ?r)
  (not (propiedad_receta no_vegana ?r))
  =>
  (assert (propiedad_receta no_vegana ?r))
)

(defrule marcar-no-vegana-por-lactosa
  (propiedad_receta contiene_lactosa ?r)
  (not (propiedad_receta no_vegana ?r))
  =>
  (assert (propiedad_receta no_vegana ?r))
)

(defrule marcar-es-vegetariana
  (receta (nombre ?r))
  (not (propiedad_receta no_vegetariana ?r))
  (not (propiedad_receta es_vegetariana ?r))
  =>
  (assert (propiedad_receta es_vegetariana ?r))
)

(defrule marcar-es-vegana
  (receta (nombre ?r))
  (not (propiedad_receta no_vegana ?r))
  (not (propiedad_receta es_vegana ?r))
  =>
  (assert (propiedad_receta es_vegana ?r))
)

(defrule marcar-es-sin-gluten
  (receta (nombre ?r))
  (not (propiedad_receta contiene_gluten ?r))
  (not (propiedad_receta es_sin_gluten ?r))
  =>
  (assert (propiedad_receta es_sin_gluten ?r))
)

(defrule marcar-es-sin-lactosa
  (receta (nombre ?r))
  (not (propiedad_receta contiene_lactosa ?r))
  (not (propiedad_receta es_sin_lactosa ?r))
  =>
  (assert (propiedad_receta es_sin_lactosa ?r))
)

(defrule clasificar-calorias
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

;;;FORMATO DE LOS HECHOS:  (siendo ?r el nombre de la receta)
;  
;       (propiedad_receta ingrediente_relevante ?r ?a)
;       (propiedad_receta calorias baja/media/alta ?r)
;       (propiedad_receta es_vegetariana ?r) 
;       (propiedad_receta es_vegana ?r)
;       (propiedad_receta es_sin_gluten ?r)
;       (propiedad_receta es_picante ?r)
;       (propiedad_receta es_sin_lactosa ?r)


;; MODULOS DEL SISTEMA EXPERTO INTERACTIVO
;;  - MODULO 2: pedir informacion al usuario
;;  - MODULO 3: proponer tipo de receta (preferencia de tipo)
;;  - MODULO 4: obtener recetas compatibles (filtrado)
;;  - MODULO 5: proponer receta y permitir reajustes

(deftemplate RecetaCandidata (slot nombre))
(deftemplate RecetaAdecuada (slot nombre) (slot motivo))
(deftemplate RecetaOfertada (slot nombre))
(deftemplate RecetaRechazada (slot nombre) (slot motivo))
(deftemplate respuesta-sin-lactosa (slot valor))
(deftemplate respuesta-sin-gluten (slot valor))

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
  (do-for-all-facts ((?f RecetaAdecuada)) TRUE (retract ?f))
  (do-for-all-facts ((?f RecetaOfertada)) TRUE (retract ?f))
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
  (printout t crlf "=== Sistema experto simple de recetas ===" crlf)
  (printout t "Responde en minuscula o mayuscula. 'ns' significa sin preferencia." crlf)
  (printout t "Si respondes fin antes de la recomendación , el sistema recomendará con las preguntas que has respondido" crlf)
)

;; ------------------------
;; MODULO 2: PEDIR INFORMACION
;; ------------------------
;; - normal/vegana/vegetariana
;; - sin lactosa/sin gluten
;; - tipo: preferencia de consumo (principal/entrante/postre).
;; - comensales y tiempo.
;; - proteina y densidad calorica.
;; - ingrediente obligatorio.

(defrule pregunta-dieta
  (declare (salience 800))
  (fase preguntar)
  ?f <- (pregunta dieta)
  =>
  (retract ?f)
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
  ;; Si responde ns, luego no se filtra por tipo.
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
)
(defrule pregunta-ingrediente-obligatorio
  (declare (salience 797))
  (fase preguntar)
  ?f <- (pregunta ingrediente_obligatorio)
  =>
  (retract ?f)
  (printout t "Ingrediente obligatorio (texto|ns|fin): ")
  (assert (respuesta-ingrediente-obligatorio (normalizar-respuesta (read))))
)
(defrule pregunta-comensales
  (declare (salience 796))
  (fase preguntar)
  ?f <- (pregunta comensales)
  =>
  (retract ?f)
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
  (printout t "Tiempo maximo en minutos (numero|ns|fin): ")
  (assert (respuesta-tiempo (normalizar-respuesta (read))))
)

(defrule pregunta-proteina
  (declare (salience 793))
  (fase preguntar)
  ?f <- (pregunta proteina)
  =>
  (retract ?f)
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
;; MODULO : OBTENER RECETAS COMPATIBLES
;; ------------------------
;; Se parte de todas las recetas y se van eliminando las que no
;; cumplen cada restriccion del usuario.

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

(defrule filtrar-tipo
  (fase elegir)
  (respuesta-tipo ?tp&~ns)
  ?f <- (RecetaCandidata (nombre ?r))
  (receta (nombre ?r) (tipo-plato ?real))
  (test (neq ?real (tipo-respuesta-a-simbolo ?tp)))
  =>
  (retract ?f)
)

(defrule filtrar-densidad-calorica-baja
  (fase elegir)
  (respuesta-densidad-calorica baja)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta calorias ?c ?r)
  (test (neq ?c baja))
  =>
  (retract ?f)
)

(defrule filtrar-densidad-calorica-media
  (fase elegir)
  (respuesta-densidad-calorica media)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta calorias ?c ?r)
  (test (neq ?c media))
  =>
  (retract ?f)
)

(defrule filtrar-densidad-calorica-alta
  (fase elegir)
  (respuesta-densidad-calorica alta)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta calorias ?c ?r)
  (test (neq ?c alta))
  =>
  (retract ?f)
)

(defrule filtrar-proteina-baja
  (fase elegir)
  (respuesta-proteina baja)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta proteinas ?p ?r)
  (test (neq ?p baja))
  =>
  (retract ?f)
)

(defrule filtrar-proteina-media
  (fase elegir)
  (respuesta-proteina media)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta proteinas ?p ?r)
  (test (neq ?p media))
  =>
  (retract ?f)
)

(defrule filtrar-proteina-alta
  (fase elegir)
  (respuesta-proteina alta)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta proteinas ?p ?r)
  (test (neq ?p alta))
  =>
  (retract ?f)
)

(defrule filtrar-comensales
  (fase elegir)
  (respuesta-comensales ?n)
  (test (numberp ?n))
  ?f <- (RecetaCandidata (nombre ?r))
  (receta (nombre ?r) (comensales ?c))
  (test (< ?c ?n))
  =>
  (retract ?f)
)

(defrule filtrar-tiempo
  (fase elegir)
  (respuesta-tiempo ?t)
  (test (numberp ?t))
  ?f <- (RecetaCandidata (nombre ?r))
  (receta (nombre ?r) (tiempo-cocinado ?tc))
  (test (> ?tc ?t))
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

(defrule registrar-adecuadas
  (fase elegir)
  (RecetaCandidata (nombre ?r))
  (receta (nombre ?r) (tipo-plato ?tp) (comensales ?com))
  (propiedad_receta calorias ?cal ?r)
  (propiedad_receta calorias ?cal ?r)
  (not (RecetaAdecuada (nombre ?r)))
  =>
  (bind ?dieta (obtener-dieta-receta ?r))
  (bind ?txt-lactosa (if (tiene-prop2 contiene_lactosa ?r) then "si" else "no"))
  (bind ?txt-gluten (if (tiene-prop2 contiene_gluten ?r) then "si" else "no"))
  (bind ?motivo (str-cat "Se ha elegido esta receta ya que es un plato de tipo " ?tp
                         " y " ?cal " en calorias que sigue una dieta " ?dieta "la cual concuerda con el tipo de dieta" 
											"que se debe seguir , además es una receta que contiene de ingrediente principal . "
                         "Ademas, " ?txt-lactosa " tiene lactosa y " ?txt-gluten " tiene gluten y es apta para un numero maximo de " ?com " comensales."))
  (assert (RecetaAdecuada (nombre ?r) (motivo ?motivo)))
)

(defrule pasar-a-resultados
  (declare (salience -50))
  ?f <- (fase elegir)
  (or (RecetaAdecuada (nombre ?))
      (not (RecetaCandidata (nombre ?))))
  =>
  (retract ?f)
  (assert (fase resultados))
)

(defrule sin-recetas-adecuadas
  ?fr <- (fase resultados)
  (not (RecetaAdecuada (nombre ?)))
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

(defrule mostrar-receta
  (fase resultados)
  (RecetaAdecuada (nombre ?r) (motivo ?mot))
  (not (RecetaRechazada (nombre ?r) (motivo ?)))
  (not (RecetaOfertada (nombre ?)))
  (receta (nombre ?r) (tipo-plato ?tp) (dificultad ?d) (comensales ?c) (tiempo-cocinado ?t))
  =>
  (assert (RecetaOfertada (nombre ?r)))
  (printout t crlf "----------------------------------------" crlf)
  (printout t "Receta recomendada: " ?r crlf)
  (printout t "Tipo: " ?tp ", dificultad: " ?d ", comensales: " ?c ", tiempo: " ?t " min" crlf)
  (printout t "Motivo: " ?mot crlf)
  (printout t "Respuesta (a|rechazar|dieta|tipo|comensales|tiempo|proteina|calorias|ingrediente): ")
  (assert (respuesta-final (normalizar-respuesta (read))))
)

;; ------------------------
;; MODULO 5: PROPONER RECETA
;; ------------------------
;; Se ofertan recetas una a una. El usuario puede aceptar, rechazar
;; o reajustar un criterio y relanzar el filtrado.

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

(defrule sin-mas-recetas
  ?fr <- (fase resultados)
  (not (RecetaOfertada (nombre ?)))
  (not (and (RecetaAdecuada (nombre ?r))
            (not (RecetaRechazada (nombre ?r) (motivo ?)))))
  =>
  (retract ?fr)
  (printout t crlf "No quedan mas recetas para proponer." crlf)
  (assert (fin))
)

(defrule cerrar-sistema
  (declare (salience -1000))
  (fin)
  =>
  (printout t crlf "--- Fin del sistema experto ---" crlf)
)
