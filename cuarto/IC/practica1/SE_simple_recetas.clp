


;;;; Carga automatica de la base de recetas
;;;; Al cargar este archivo se cargan tambien las recetas de BDrecetas_100.clp

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

(deffunction cargar-bd-recetas ()
  (load "BDrecetas_100.clp")
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


;;;EJERCICIO: Añadir reglas para  deducir tal y como tú lo harias (usando razonamiento basado en conocimiento):
;;;  1) cual o cuales son los ingredientes relevantes de una receta
;;;  2) Si una receta no incluye el tipo de plato, que deduzca y añada, modificando la receta, el tipo de plato que le correspondería (plato principal, postre, entrante, merienda, …)
;;;  3) si una receta es: vegana, vegetariana, picante, sin gluten o sin lactosa,o ,  si en cuanto a calorías es ligera, normal o calórica o si es de digestión ligera, normal o pesada (teniendo en cuenta en estos últimos casos el tipo de plato que es) 




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
;    y calorias + digestion

(defrule marcar-picante
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (or (contiene ?a "guindilla")
            (contiene ?a "chile")
            (contiene ?a "cayena")
            (contiene ?a "aji")
            (contiene ?a "picante")))
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

(defrule marcar-receta-pesada
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (or (contiene ?a "frito")
            (contiene ?a "freir")
            (contiene ?r "frito")
            (contiene ?r "carne")
            (contiene ?a "mantequilla")
            (contiene ?a "nata")
            (contiene ?a "queso")
            (contiene ?a "tocino")
            (contiene ?a "bacon")
            (contiene ?a "morcilla")))
  (not (propiedad_receta receta_pesada ?r))
  =>
  (assert (propiedad_receta receta_pesada ?r))
)

(defrule clasificar-calorias
  (receta (nombre ?r) (info-nutricional $?info))
  (not (propiedad_receta calorias ?categoria ?r))
  =>
  (bind ?kcal (obtener-kcal ?info))
  (if (or (< ?kcal 0) (<= ?kcal 100)) then
    (assert (propiedad_receta calorias ligera ?r))
  else
    (if (or (< ?kcal 100) (<= ?kcal 250)) then
      (assert (propiedad_receta calorias normal ?r))
    else
      (assert (propiedad_receta calorias calorica ?r))))
)

(defrule clasificar-digestion-pesada
  (receta (nombre ?r))
  (or (propiedad_receta receta_pesada ?r)
      (propiedad_receta calorias calorica ?r))
  (not (propiedad_receta digestion ?nivel ?r))
  =>
  (assert (propiedad_receta digestion pesada ?r))
)

(defrule clasificar-digestion-ligera
  (declare (salience -2))
  (receta (nombre ?r) (tipo-plato ?tp))
  (or (eq ?tp entrante)
      (propiedad_receta calorias ligera ?r))
  (not (propiedad_receta digestion ?nivel ?r))
  =>
  (assert (propiedad_receta digestion ligera ?r))
)

(defrule clasificar-digestion-normal
  (declare (salience -5))
  (receta (nombre ?r))
  (not (propiedad_receta digestion ?nivel ?r))
  =>
  (assert (propiedad_receta digestion normal ?r))
)

;;;FORMATO DE LOS HECHOS:  (siendo ?r el nombre de la receta)
;  
;       (propiedad_receta ingrediente_relevante ?r ?a)
;       (propiedad_receta digestion ligera/normal/pesada ?r)
;       (propiedad_receta calorias ligera/normal/calorica ?r)
;       (propiedad_receta es_vegetariana ?r) 
;       (propiedad_receta es_vegana ?r)
;       (propiedad_receta es_sin_gluten ?r)
;       (propiedad_receta es_picante ?r)
;       (propiedad_receta es_sin_lactosa ?r)

;; HASTA ESTA PARTE SE CLASIFICAN LAS RECETAS DE LA BD

;; AQUI EMPIEZA EL SISTEMA EXPERTO

(deftemplate RecetaCandidata (slot nombre))
(deftemplate RecetaAdecuada (slot nombre) (slot motivo))
(deftemplate RecetaOfertada (slot nombre))
(deftemplate RecetaRechazada (slot nombre) (slot motivo))

(deffacts inicio-sistema-experto
  (arrancar)
  (pregunta dieta)
  (pregunta tipo)
  (pregunta comensales)
  (pregunta tiempo)
  (pregunta ingrediente_obligatorio)
  (pregunta ingrediente_prohibido)
)

(deffunction normalizar-respuesta (?x)
  (if (or (symbolp ?x) (stringp ?x) (instance-namep ?x)) then (return (lowcase ?x)) else (return ?x))
)

(deffunction tipo-respuesta-a-simbolo (?resp)
  (if (eq ?resp principal) then (return principal))
  (if (eq ?resp entrante) then (return entrante))
  (if (eq ?resp postre) then (return postre))
  (if (eq ?resp desayuno_merienda) then (return desayuno-merienda))
  (return cualquiera)
)

(deffunction dieta-valida (?r)
  (if (or (eq ?r normal) (eq ?r vegetariana) (eq ?r vegana)
          (eq ?r sin_gluten) (eq ?r sin_lactosa) (eq ?r ns) (eq ?r fin))
    then TRUE
    else FALSE)
)

(deffunction tipo-valido (?r)
  (if (or (eq ?r principal) (eq ?r entrante) (eq ?r postre)
          (eq ?r desayuno_merienda) (eq ?r cualquiera) (eq ?r ns) (eq ?r fin))
    then TRUE
    else FALSE)
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

(deffunction crear-candidatas-iniciales ()
  (do-for-all-facts ((?r receta)) TRUE
    (assert (RecetaCandidata (nombre ?r:nombre))))
)

(defrule comprobar-recetas-cargadas
  (declare (salience 10000))
  ?f <- (arrancar)
  (not (receta (nombre ?)))
  =>
  (retract ?f)
  (printout t crlf "No hay recetas cargadas. Ejecuta (cargar-bd-recetas), reset y run." crlf)
  (assert (fin))
)

(defrule mensaje-bienvenida
  (declare (salience 9999))
  ?f <- (arrancar)
  =>
  (retract ?f)
  (assert (fase preguntar))
  (printout t crlf "=== Sistema experto simple de recetas ===" crlf)
  (printout t "Responde en minuscula o mayuscula. 'ns' significa sin preferencia." crlf)
)

;; ------------------------
;; BLOQUE 1: PREGUNTAS
;; ------------------------

(defrule pregunta-dieta
  (declare (salience 10))
  (fase preguntar)
  ?f <- (pregunta dieta)
  =>
  (retract ?f)
  (printout t "Dieta (normal|vegetariana|vegana|sin_gluten|sin_lactosa|ns|fin): ")
  (assert (respuesta-dieta (normalizar-respuesta (read))))
)

(defrule validar-dieta
  (declare (salience 1000))
  (fase preguntar)
  ?f <- (respuesta-dieta ?r)
  (test (not (dieta-valida ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para dieta." crlf)
  (assert (pregunta dieta))
)

(defrule pregunta-tipo
  (declare (salience 9))
  (fase preguntar)
  ?f <- (pregunta tipo)
  =>
  (retract ?f)
  (printout t "Tipo (principal|entrante|postre|desayuno_merienda|cualquiera|ns|fin): ")
  (assert (respuesta-tipo (normalizar-respuesta (read))))
)

(defrule validar-tipo
  (declare (salience 1000))
  (fase preguntar)
  ?f <- (respuesta-tipo ?r)
  (test (not (tipo-valido ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para tipo." crlf)
  (assert (pregunta tipo))
)

(defrule pregunta-comensales
  (declare (salience 8))
  (fase preguntar)
  ?f <- (pregunta comensales)
  =>
  (retract ?f)
  (printout t "Comensales (numero|ns|fin): ")
  (assert (respuesta-comensales (normalizar-respuesta (read))))
)

(defrule validar-comensales
  (declare (salience 1000))
  (fase preguntar)
  ?f <- (respuesta-comensales ?r)
  (test (not (numero-o-control ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para comensales." crlf)
  (assert (pregunta comensales))
)

(defrule pregunta-tiempo
  (declare (salience 7))
  (fase preguntar)
  ?f <- (pregunta tiempo)
  =>
  (retract ?f)
  (printout t "Tiempo maximo en minutos (numero|ns|fin): ")
  (assert (respuesta-tiempo (normalizar-respuesta (read))))
)

(defrule validar-tiempo
  (declare (salience 1000))
  (fase preguntar)
  ?f <- (respuesta-tiempo ?r)
  (test (not (numero-o-control ?r)))
  =>
  (retract ?f)
  (printout t "Valor no valido para tiempo." crlf)
  (assert (pregunta tiempo))
)

(defrule pregunta-ingrediente-obligatorio
  (declare (salience 6))
  (fase preguntar)
  ?f <- (pregunta ingrediente_obligatorio)
  =>
  (retract ?f)
  (printout t "Ingrediente obligatorio (texto|ns|fin): ")
  (assert (respuesta-ingrediente-obligatorio (normalizar-respuesta (read))))
)

(defrule pregunta-ingrediente-prohibido
  (declare (salience 5))
  (fase preguntar)
  ?f <- (pregunta ingrediente_prohibido)
  =>
  (retract ?f)
  (printout t "Ingrediente prohibido (texto|ns|fin): ")
  (assert (respuesta-ingrediente-prohibido (normalizar-respuesta (read))))
)

(defrule finalizar-preguntas-por-fin
  (declare (salience 1100))
  ?p <- (fase preguntar)
  (or (respuesta-dieta fin)
      (respuesta-tipo fin)
      (respuesta-comensales fin)
      (respuesta-tiempo fin)
      (respuesta-ingrediente-obligatorio fin)
      (respuesta-ingrediente-prohibido fin))
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

(defrule defaults-respuestas
  (fase elegir)
  (not (defaults-listos))
  =>
  (if (not (any-factp ((?f respuesta-dieta)) TRUE)) then (assert (respuesta-dieta ns)))
  (if (not (any-factp ((?f respuesta-tipo)) TRUE)) then (assert (respuesta-tipo ns)))
  (if (not (any-factp ((?f respuesta-comensales)) TRUE)) then (assert (respuesta-comensales ns)))
  (if (not (any-factp ((?f respuesta-tiempo)) TRUE)) then (assert (respuesta-tiempo ns)))
  (if (not (any-factp ((?f respuesta-ingrediente-obligatorio)) TRUE)) then (assert (respuesta-ingrediente-obligatorio ns)))
  (if (not (any-factp ((?f respuesta-ingrediente-prohibido)) TRUE)) then (assert (respuesta-ingrediente-prohibido ns)))
  (assert (defaults-listos))
)

;; ------------------------
;; BLOQUE 2: FILTRADO
;; ------------------------

(defrule iniciar-evaluacion
  (declare (salience 900))
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

(defrule filtrar-sin-gluten
  (fase elegir)
  (respuesta-dieta sin_gluten)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta contiene_gluten ?r)
  =>
  (retract ?f)
)

(defrule filtrar-sin-lactosa
  (fase elegir)
  (respuesta-dieta sin_lactosa)
  ?f <- (RecetaCandidata (nombre ?r))
  (propiedad_receta contiene_lactosa ?r)
  =>
  (retract ?f)
)

(defrule filtrar-tipo
  (fase elegir)
  (respuesta-tipo ?tp&~ns&~cualquiera)
  ?f <- (RecetaCandidata (nombre ?r))
  (receta (nombre ?r) (tipo-plato ?real))
  (test (neq ?real (tipo-respuesta-a-simbolo ?tp)))
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

(defrule filtrar-ingrediente-prohibido
  (fase elegir)
  (respuesta-ingrediente-prohibido ?ing&~ns)
  ?f <- (RecetaCandidata (nombre ?r))
  (ingrediente (nombre-receta ?r) (nombre-ingrediente ?a))
  (test (contiene ?a (sym-cat ?ing)))
  =>
  (retract ?f)
)

(defrule registrar-adecuadas
  (fase elegir)
  (RecetaCandidata (nombre ?r))
  (not (RecetaAdecuada (nombre ?r)))
  =>
  (assert (RecetaAdecuada (nombre ?r) (motivo "Cumple tus restricciones.")))
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
  (assert (fin))
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
  (printout t "Respuesta (a|rechazar|dieta|tipo|comensales|tiempo|ingrediente): ")
  (assert (respuesta-final (normalizar-respuesta (read))))
)

;; ------------------------
;; BLOQUE 3: RESULTADOS
;; ------------------------

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
  ?a <- (respuesta-final ?x&:(or (eq ?x dieta) (eq ?x tipo) (eq ?x comensales) (eq ?x tiempo) (eq ?x ingrediente)))
  =>
  (retract ?o ?a)
  (assert (RecetaRechazada (nombre ?r) (motivo ?x)))

  (if (eq ?x dieta) then
    (printout t "Nueva dieta (normal|vegetariana|vegana|sin_gluten|sin_lactosa|ns): ")
    (do-for-all-facts ((?f respuesta-dieta)) TRUE (retract ?f))
    (assert (respuesta-dieta (normalizar-respuesta (read)))))

  (if (eq ?x tipo) then
    (printout t "Nuevo tipo (principal|entrante|postre|desayuno_merienda|cualquiera|ns): ")
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

  (if (eq ?x ingrediente) then
    (printout t "Nuevo ingrediente prohibido (texto|ns): ")
    (do-for-all-facts ((?f respuesta-ingrediente-prohibido)) TRUE (retract ?f))
    (assert (respuesta-ingrediente-prohibido (normalizar-respuesta (read)))))

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
