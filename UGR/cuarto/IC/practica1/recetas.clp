
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

(deffunction obtener-numero-previo (?str ?sub)
  (bind ?pos (str-index ?sub ?str))
  (if (eq ?pos FALSE) then (return FALSE))

  (bind ?pos-actual (- ?pos 1))
  (bind ?resultado "")

  (while (> ?pos-actual 0)
    (bind ?char (sub-string ?pos-actual ?pos-actual ?str))

    (if (or (and (>= (str-compare ?char "0") 0)
                 (<= (str-compare ?char "9") 0))
            (eq ?char "."))
      then
      (bind ?resultado (format nil "%s%s" ?char ?resultado))
      (bind ?pos-actual (- ?pos-actual 1))
    else
      (if (eq ?char " ") then
        (bind ?pos-actual (- ?pos-actual 1))
      else
        (break))
    )
  )

  (if (neq ?resultado "") then
    (return (string-to-field ?resultado))
  else
    (return FALSE))
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
            (contiene ?a "espaguetis")
            (contiene ?a "fideos")
            (contiene ?a "galleta")
            (contiene ?a "hojaldre")
            (contiene ?a "bizcocho")
						(contiene ?r "espaguetis")
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

(defrule deducir-gramos-proteinas
  (receta (nombre ?r) (info-nutricional $? ?dato $?))
  (test (str-index "g proteinas" (lowcase (sym-cat ?dato))))
  (not (propiedad_receta gramos_proteinas ?x ?r))
  =>
  (bind ?g (obtener-numero-previo (lowcase (sym-cat ?dato)) "g proteinas"))
  (if (numberp ?g) then
    (assert (propiedad_receta gramos_proteinas ?g ?r)))
)

(defrule deducir-gramos-grasas
  (receta (nombre ?r) (info-nutricional $? ?dato $?))
  (test (str-index "g grasas" (lowcase (sym-cat ?dato))))
  (not (propiedad_receta gramos_grasas ?x ?r))
  =>
  (bind ?g (obtener-numero-previo (lowcase (sym-cat ?dato)) "g grasas"))
  (if (numberp ?g) then
    (assert (propiedad_receta gramos_grasas ?g ?r)))
)

(defrule deducir-gramos-carbohidratos
  (receta (nombre ?r) (info-nutricional $? ?dato $?))
  (test (str-index "g carbohidratos" (lowcase (sym-cat ?dato))))
  (not (propiedad_receta gramos_carbohidratos ?x ?r))
  =>
  (bind ?g (obtener-numero-previo (lowcase (sym-cat ?dato)) "g carbohidratos"))
  (if (numberp ?g) then
    (assert (propiedad_receta gramos_carbohidratos ?g ?r)))
)

(defrule deducir-gramos-fibra
  (receta (nombre ?r) (info-nutricional $? ?dato $?))
  (test (str-index "g fibra" (lowcase (sym-cat ?dato))))
  (not (propiedad_receta gramos_fibra ?x ?r))
  =>
  (bind ?g (obtener-numero-previo (lowcase (sym-cat ?dato)) "g fibra"))
  (if (numberp ?g) then
    (assert (propiedad_receta gramos_fibra ?g ?r)))
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
;       (propiedad_receta gramos_proteinas ?g ?r)
;       (propiedad_receta gramos_grasas ?g ?r)
;       (propiedad_receta gramos_carbohidratos ?g ?r)
;       (propiedad_receta gramos_fibra ?g ?r)

;; lo descomento para comprobar sin tener que mirar deffacts
;(defrule imprimir-propiedades-de-cada-receta
;  (declare (salience -1000))
;  (receta (nombre ?r))
;  (not (receta_impresa ?r))
;  =>
;  (printout t crlf "========================================" crlf)
;  (printout t "Receta: " ?r crlf)
;  (printout t "Propiedades deducidas:" crlf)
;
;  (bind ?hay FALSE)
;  (do-for-all-facts ((?p propiedad_receta)) TRUE
;    (bind ?datos ?p:implied)
;    (bind ?l (length$ ?datos))
;
;    (if (or (and (>= ?l 2) (eq (nth$ 2 ?datos) ?r))
;            (and (>= ?l 3) (eq (nth$ 3 ?datos) ?r)))
;      then
;      (bind ?hay TRUE)
;      (printout t "- " ?datos crlf)
;    )
;  )
;
;  (if (eq ?hay FALSE) then
;    (printout t "- (sin propiedades deducidas)" crlf)
;  )
;
;  (assert (receta_impresa ?r))
;)
