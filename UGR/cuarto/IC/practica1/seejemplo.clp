;;;; AÑADIR LA INFORMACION DE AL MENOS 5 RECETAS NUEVAS (con al menos dos platos principales, un postre y un entrante) (al archivo compartido recetas.txt (https://docs.google.com/document/d/15zLHIeCEUplwsxUxQU66LsyKPY9n9p5v1bmi8M85YlU/edit?usp=sharing)
;;;;;recoger los datos de https://www.recetasgratis.net  en el siguiente formato
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
(slot nombre-receta (type STRING)) ; Enlace con la receta
(slot nombre-ingrediente (type STRING)) 
(slot cantidad (type FLOAT))
(slot unidad (type SYMBOL)) ; g, ml, unidades, pizca... 
)


(deffacts tipo_datos_analisis
(tipo_dato tipo_plato enumerado)
(tipo_dato dificultad enumerado)
(tipo_dato comensales enumerado)
(tipo_dato tiempo_cocinado numero)
(tipo_dato calorias numero)
(tipo_dato grasas numero)
(tipo_dato fibra numero)
(tipo_dato carbohidratos numero)
(tipo_dato proteinas numero)
(tipo_dato ingredientes multimples_cadenas)
)

(deffacts unidades
(unidades tiempo_cocinado minutos)
(unidades calorias kcal)
(unidades grasas gramos)
(unidades carbohidratos gramos)
(unidades proteinas gramos)
(unidades fibra gramos)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; CALCULAR NUMERO DE RECETAS DE INTERES ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule mandar_contar
(tipo_interes ?x)
=>
(assert (calcular_numero_recetas) )
;(printout t crlf "mandando contar recetas" crlf)
)

(defrule inicializar_numero_recetas
(declare (salience 3))
(calcular_numero_recetas)
=>
(assert (numero-recetas 0))
)

(defrule contabilizar-otra-receta
(calcular_numero_recetas)
(receta_interes ?)
=>
(assert (otra-receta))
)

(defrule actualizar-numero-recetas
(declare (salience 1))
(calcular_numero_recetas)
?f <- (otra-receta)
?g <- (numero-recetas ?n)
=>
(assert (numero-recetas (+ ?n 1)))
(retract ?f ?g)
)

(defrule decir-numero-recetas
(declare (salience -1))
?f <- (calcular_numero_recetas)
(numero-recetas ?n)
(tipo_interes ?x)
=> 
(printout t crlf)
(printout t "Actualmente tenemos " ?n " recetas " ?x crlf crlf)
(retract ?f)
)

(defrule preguntar-si-listar
(declare (salience -2))
(tipo_interes ?x)
   =>
   (printout t "¿Quieres que te las liste? (si/no): ")
   (assert (respuesta-listar (read)))
)

(defrule añadir-hecho-seguir
(respuesta-listar si) ;; Si la respuesta guardada es "si"
=>
(assert (listar_recetas_interes))
)

(defrule borrar-respuesta-seguir
(declare (salience -1))
   ?f <- (respuesta-listar ?)
   =>
   (retract ?f)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; LISTAR RECETAS DE INTERES ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule anunciar_listar_tipo
(declare (salience 1))
(tipo_interes ?x)
(listar_recetas_interes)
=>
(printout t crlf "Estas son las recetas " ?x ":" crlf)
)

(defrule de_tipo_actual
(listar_recetas_interes)
(tipo_interes ?x)
(receta_interes ?r)
=>
(printout t ?r crlf)
)

(defrule borrar-listar-recetas
(declare (salience -1))
   ?f <- (listar_recetas_interes)
   =>
   (retract ?f)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; INICIALIZAR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule inicialmente_todas_son_de_interes 
(receta (nombre ?r))
=>
(assert (receta_interes ?r) )
)


(defrule inicializar_temas_posibles
(declare (salience -2))
=>
(assert (posible_tema fibra))
(assert (posible_tema carbohidratos))
(assert (posible_tema grasas))
(assert (posible_tema proteinas))
(assert (posible_tema calorias))
(assert (posible_tema comensales))
(assert (posible_tema tipo_plato))
(assert (posible_tema dificultad))
(assert (posible_tema tiempo_cocinado))
(assert (posible_tema ingrediente))
)

(defrule inicializar_tipo_cualquiera
(declare (salience -3))
=>
(assert (tipo_interes "en la base de datos"))
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; ELEGIR NUEVO TEMA INTERES ;;;;;::::::::::::::::::::::
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

(defrule preguntar_seguir
(declare (salience -100))
(tipo_interes ?x)
=>
(printout t crlf crlf "Quieres seguir? (si/no): ")
(assert (seguir (read)))
)

(defrule seguir
(seguir si)
=>
(assert (ampliar_interes))
)


(defrule eliminar_dato_seguir
(declare (salience -1))
?f <- (seguir ?)
=>
(retract ?f)
)

	
(defrule elegir_interes
(declare (salience 1))
(ampliar_interes)
=>
(printout t crlf crlf "Sobre que estas interesado ahora: " crlf)
)

(defrule listar_resto_temas
(ampliar_interes)
(posible_tema ?t)
=>
(printout t "- " ?t crlf)
)

(defrule ofrecer_terminar
(declare (salience -1))
(ampliar_interes)
=>
(printout t "- terminar" crlf)
)

(defrule recoger_eleccion
(declare (salience -2))
?g <- (ampliar_interes)
=>
(printout t "Por favor elige una opción: ")
(assert (interesado (read)))
(retract ?g)
)

(defrule eliminar_eligido_posibles_temas
(interesado ?x)
(not (eq ?x ingrediente))
?f <- (posible_tema ?x)
=>
(retract ?f)
)

(defrule obtener_valores_tipo_plato
(interesado tipo_plato)
(receta (nombre ?r) (tipo-plato ?x))
=>
(assert (valor ?r tipo_plato ?x))
)

(defrule obtener_valores_dificultad
(interesado dificultad)
(receta (nombre ?r) (dificultad ?x))
=>
(assert (valor ?r dificultad ?x))
)

(defrule obtener_valores_comensales
(interesado comensales)
(receta (nombre ?r) (comensales ?x))
=>
(assert (valor ?r comensales ?x))
)

(defrule obtener_valores_tiempo_cocinado
(interesado tiempo_cocinado)
(receta (nombre ?r) (tiempo-cocinado ?x))
=>
(assert (valor ?r tiempo_cocinado ?x))
)

(defrule obtener_valores_tiempo_cocinado
(interesado tiempo_cocinado)
(receta (nombre ?r) (tiempo-cocinado ?x))
=>
(assert (valor ?r tiempo_cocinado ?x))
)

(deffunction obtener-numero-previo (?str ?sub)
   (bind ?pos (str-index ?sub ?str))
   (if (eq ?pos FALSE) then (return "")) 

   (bind ?pos-actual (- ?pos 1))
   (bind ?resultado "")

   (while (> ?pos-actual 0)
      (bind ?char (sub-string ?pos-actual ?pos-actual ?str))
      
      ;; NUEVA CONDICIÓN: Acepta dígitos (0-9) O el punto decimal (.)
      (if (or (and (>= (str-compare ?char "0") 0) 
                   (<= (str-compare ?char "9") 0))
              (eq ?char "."))
       then
          (bind ?resultado (format nil "%s%s" ?char ?resultado))
          (bind ?pos-actual (- ?pos-actual 1))
       else
          ;; Si es un espacio, simplemente lo saltamos y seguimos buscando
          (if (eq ?char " ")
           then (bind ?pos-actual (- ?pos-actual 1))
           else (break)) ;; Si es cualquier otra cosa (letras, símbolos), paramos
      )
   )

   (if (neq ?resultado "")
      then (return (string-to-field ?resultado))
      else (return 0))
)



(defrule obtener_calorias
(interesado calorias)
(receta (nombre ?r)(info-nutricional $? ?y $?))
(test (str-index " kcal" (sym-cat ?y)))
=>
(assert (valor ?r calorias (obtener-numero-previo (sym-cat ?y) " kcal")))
)

(defrule obtener_grasas
(interesado grasas)
(receta (nombre ?r)(info-nutricional $? ?y $?))
(test (str-index "g grasas" (sym-cat ?y)))
=>
(assert (valor ?r grasas (obtener-numero-previo (sym-cat ?y) "g grasas")))
)


(defrule obtener_proteinas
(interesado proteinas)
(receta (nombre ?r)(info-nutricional $? ?y $?))
(test (str-index "g proteinas" (sym-cat ?y)))
=>
(assert (valor ?r proteinas (obtener-numero-previo (sym-cat ?y) "g proteinas")))
)

(defrule obtener_carbohidratos
(interesado carbohidratos)
(receta (nombre ?r)(info-nutricional $? ?y $?))
(test (str-index "g carbohidratos" (sym-cat ?y)))
=>
(assert (valor ?r carbohidratos (obtener-numero-previo (sym-cat ?y) "g carbohidratos")))
)

(defrule obtener_fibra
(interesado fibra)
(receta (nombre ?r)(info-nutricional $? ?y $?))
(test (str-index "g fibra" (sym-cat ?y)))
=>
(assert (valor ?r fibra (obtener-numero-previo (sym-cat ?y) "g fibra")))
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;; LISTAR VALORES PARA TEMA ENUMERADOS Y ELEGIR VALOR :;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

(defrule reconocer_posibles_valores
(declare (salience 5))
(interesado ?t)
(tipo_dato ?t enumerado)
(valor ?r ?t ?tp)
(not (posible ?t ?tp))
=>
(assert (posible ?t ?tp))
)

(defrule anunciando_posibles_valores
(declare (salience 6))
(interesado ?x)
(tipo_dato ?x enumerado)
=>
(printout t crlf "Tengo recetas para los siguientes valores de " ?x ": "  crlf)
)

(defrule listar_valores_tema
(declare (salience 4))
(interesado ?x)
(tipo_dato ?x enumerado)
(posible ?x ?tp)
=>
(printout t "- " ?tp crlf)
)

(defrule elegir_valores_tema
(declare (salience -1))
?g <- (interesado ?x)
(tipo_dato ?x enumerado)
=> 
(printout t "Elige cual de esos valores te interesa: ")
(assert (interes_valor ?x (read)))
(retract ?g)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; FILTRAR INTERES VALOR TIPO DATO ENUMERADO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule filtrar_valor_tipo_dato_enumerado
(interes_valor ?x ?valor)
?f <- (receta_interes ?r)
(valor ?r ?x ~?valor)
=>
(retract ?f)
)

(defrule actualizar_tipo_interes_valor_tipo_dato_enumerado
(declare (salience -1))
?f <- (interes_valor ?x ?valor)
?g <- (tipo_interes ?t)
=>
(assert (tipo_interes (str-cat ?t ", " ?x " " ?valor)))
(retract ?f ?g)
)
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;; ELEGIR LIMITES PARA TEMA TIPO DATO NUMERICO y FILTRAR :;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

(defrule obteniendo_tipo_limites_dato_numerico
(interesado ?x)
(tipo_dato ?x numero)
(unidades ?x ?u)
=>
(printout t "Te interesa considerar recetas con " ?x " mayor o menor que un número de " ?u "? (mayor/menor): ")
(assert (interes ?x (read)))
)

(defrule obteniendo_limites_dato_numero
(interesado ?x)
(tipo_dato ?x numero)
?f <- (interes ?x ?m)
(unidades ?x ?u)
=>
(printout t "Quieres recetas con " ?x " " ?m " que? (indicar el número de " ?u ") ")
(assert (interes ?x ?m (read)))
(retract ?f)
)

(defrule filtar_por_numero_maximo
(interes ?t menor ?n)
?f <- (receta_interes ?r)
(valor ?r ?t ?y)
(test (> ?y ?n))
=>
(retract ?f)
)

(defrule filtar_por_numero_minimo
(interes ?t mayor ?n)
?f <- (receta_interes ?r)
(valor ?r ?t ?y)
(test (< ?y ?n))
=>
(retract ?f)
)


(defrule actualizar_tipo_interes_limite_tipo_dato_numerico
(declare (salience -1))
?f <- (interes ?x ?m ?valor)
?g <- (tipo_interes ?t)
(unidades ?x ?u)
=>
(assert (tipo_interes (str-cat ?t ", " ?x " " ?m " que "  ?valor " " ?u)))
(retract ?f ?g)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SEGUN  INGREDIENTES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule interesado_ingrediente
?f <- (interesado ingrediente)
=> 
(printout t "Que ingrediente te interesa?: ")
(assert (alimento_interesante (read)))
(retract ?f)
)

(defrule registrar_con_ingrediente
(declare (salience 1))
(alimento_interesante ?x)
(receta_interes ?r)
(ingrediente (nombre-receta ?r)(nombre-ingrediente ?a))
(test (str-index (lowcase ?x) (lowcase ?a)))
=>
(assert (con_ingrediente ?x ?r))
)

(defrule filtrar_sin_ingrediente
?f <- (receta_interes ?r)
(alimento_interesante ?x)
(not (con_ingrediente ?x ?r))
=>
(retract ?f)
)

(defrule actualizar_tipo_interes_con_ingrediente
(declare (salience -1))
?f <- (alimento_interesante ?x)
?g <- (tipo_interes ?t)
=>
(assert (tipo_interes (str-cat ?t ", con ingrediente " ?x )))
(retract ?f ?g)
)

 
