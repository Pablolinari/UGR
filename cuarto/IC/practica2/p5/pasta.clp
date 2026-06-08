;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;   RAZONAMIENTO BAYESIANO   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;  ¿LE GUSTARIA COMER PASTA HOY? (DOS CAUSAS Y DOS EFECTOS) ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CP = comer pasta hoy   (variable a inferir, X)
;; E  = edad de la persona            (causa que influye)
;; C  = comio pasta ayer              (causa que influye)
;; G  = le gustan los restaurantes italianos   (efecto)
;; F  = frecuencia con la que come pasta        (efecto)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deffacts relaciones_causa_efecto
(influye  edad ComerPasta)        ; la edad influye en la probabilidad de comer pasta
(influye  comio_ayer ComerPasta)  ; haber comido pasta ayer influye
(efecto restaurantes_italianos ComerPasta)  ; le gustan los restaurantes italianos
(efecto frecuencia ComerPasta)              ; frecuencia con la que come pasta
)

(deffacts probabilidad_variables_que_influyen
(prob edad joven 0.4)
(prob edad mediana 0.3)
(prob edad mayor 0.3)
(prob comio_ayer si 0.2)
(prob comio_ayer no 0.8)
)

(deffacts distribucion_segun_valores_variables_que_influyen
(probcond2 ComerPasta SI edad joven   comio_ayer si 0.6)
(probcond2 ComerPasta SI edad joven   comio_ayer no 0.85)
(probcond2 ComerPasta SI edad mediana comio_ayer si 0.5)
(probcond2 ComerPasta SI edad mediana comio_ayer no 0.7)
(probcond2 ComerPasta SI edad mayor   comio_ayer si 0.3)
(probcond2 ComerPasta SI edad mayor   comio_ayer no 0.55)
)

(deffacts probabilidad_efectos
; G = le gustan los restaurantes italianos (efecto binario)
(probcond restaurantes_italianos si ComerPasta SI 0.8)
(probcond restaurantes_italianos si ComerPasta NO 0.25)
; F = frecuencia con la que come pasta (efecto con tres valores)
(probcond frecuencia esporadicamente ComerPasta SI 0.10)
(probcond frecuencia frecuentemente  ComerPasta SI 0.4)
(probcond frecuencia habitualmente   ComerPasta SI 0.5)
(probcond frecuencia esporadicamente ComerPasta NO 0.7)
(probcond frecuencia frecuentemente  ComerPasta NO 0.2)
(probcond frecuencia habitualmente   ComerPasta NO 0.1)
)
; Inicializamos valores para calculos a partir de probcond2
(deffacts inicializacion_probabilidades
(probconj2 ComerPasta SI edad joven 0)
(probconj2 ComerPasta SI edad mediana 0)
(probconj2 ComerPasta SI edad mayor 0)
(probconj2 ComerPasta SI comio_ayer si 0)
(probconj2 ComerPasta SI comio_ayer no 0)
(prob ComerPasta SI 0)
)

(defrule inicio
=>
(printout t "Este es un sistema para estimar si a usted le gustaria comer pasta hoy" crlf)
(assert (informar datos))
(printout t crlf crlf "DATOS: Los datos estadisticos de que dispongo son:" crlf)
)

;;;; MODULO INFORMAR DATOS ;;;;

(defrule mostrar_prob_simples
(declare (salience 10))
(informar datos)
(influye ?i ?X)
(prob ?i ?v  ?p)
=>
(printout t "Probabilidad de " ?i "=" ?v " es " ?p crlf)
)

(defrule mostrar_prob_condicionales
(declare (salience 9))
(informar datos)
(efecto ?e ?X)
(probcond ?e ?v ?X SI ?p)
=>
(printout t "Probabilidad de " ?e "=" ?v " si " ?X " es " ?p crlf)
)

(defrule mostrar_prob_condicionales_bis
(declare (salience 9))
(informar datos)
(efecto ?e ?X)
(probcond ?e ?v ?X NO ?p)
=>
(printout t "Probabilidad de " ?e "=" ?v " si no " ?X " es " ?p crlf)
)

(defrule mostrar_prob_condicionales2
(declare (salience 8))
(informar datos)
(probcond2 ?X SI ?i1 ?v1 ?i2 ?v2 ?p)
=>
(printout t "Probabilidad de " ?X " si " ?i1 "=" ?v1 " y " ?i2 "=" ?v2 " es " ?p crlf)
)

(defrule ir_a_deducciones_simples
(informar datos)
=>
(printout t crlf crlf "DEDUCCIONES SIMPLES:" crlf)
(assert (deducciones simples))
)

;;;;;;;  MODULO DEDUCCIONES SIMPLES

(defrule calcula_condicionada_negado
(declare (salience 3))
(deducciones simples)
(probcond ?e si ?X ?v ?p)
=>
(assert (probcond ?e no ?X ?v (- 1 ?p)))
)

(defrule probconj3
(declare (salience 2))
(deducciones simples)
(probcond2 ?X SI ?c1 ?v1 ?c2 ?v2 ?pc)
(prob ?c1 ?v1 ?p1)
(prob ?c2 ?v2 ?p2)
=>
(bind ?p (* (* ?pc ?p1) ?p2))
(assert (probconj3 ?X SI ?c1 ?v1 ?c2 ?v2 ?p))
(assert (sumar probconj2 ?X SI ?c1 ?v1 ?p))
(assert (sumar probconj2 ?X SI ?c2 ?v2 ?p))
(assert (sumar prob ?X SI ?p))
)

(defrule probconj2
(declare (salience 3))
(deducciones simples)
?f <- (probconj2 ?X SI ?c ?v ?p)
?g <- (sumar probconj2 ?X SI ?c ?v ?p1)
=>
(assert (probconj2 ?X SI ?c ?v (+ ?p ?p1)))
(retract ?f ?g)
)

(defrule calcula_probabilidad_condicionada
(declare (salience 1))
(deducciones simples)
(probconj2 ?X SI ?c ?v ?p)
(prob ?c ?v ?pc)
=>
(assert (probcond ?X SI ?c ?v (/ ?p ?pc)))
)


(defrule calcula_probabilidad
(declare (salience 2))
(deducciones simples)
?f <- (prob ?X SI ?p)
?g <- (sumar prob ?X SI ?pc)
=>
(assert (prob ?X SI (+ ?p ?pc)))
(retract ?f ?g)
)

(defrule mostrar_prob_condicionales_tris
(deducciones simples)
(probcond ?X SI ?i ?v ?p)
=>
(printout t "Probabilidad de " ?X " si " ?i "=" ?v " es " ?p crlf)
)

(defrule Informa_probabilidad_a_priori
(declare (salience -1))
(deducciones simples)
(prob ?X SI ?p)
=>
(printout t crlf crlf "--> Segun los datos estadisticos: " crlf)
(printout t crlf "A PRIORI: la probabilidad de " ?X " es: " ?p crlf)
(printout t crlf)
)

(defrule ir_a_red_causal_causas
(declare (salience -2))
?f <- (deducciones simples)
=>
(printout t crlf crlf "INDAGANDO: Vamos a indagar en base a esos datos" crlf)
(retract ?f)
(assert (red causal causas))
)

;;;;;; MODULO RED CAUSAL CAUSAS

(defrule inferencia0causas
(red causal causas)
(influye ?c1 ?X)
(influye ?c2 ?X)
(test (neq ?c1 ?c2))
(valor ?c1 Desconocido)
(valor ?c2 Desconocido)
(prob ?X SI ?p)
=>
(assert (prob_posteriori_causas ?X ?p))
(assert (prob_conjunta ?X ?p))
(assert (prob_conjunta_negativo ?X (- 1 ?p)))
)

(defrule inferencia1causas
(red causal causas)
(influye ?c1 ?X)
(influye ?c2 ?X)
(valor ?c1 ?v1)
(valor ?c2 Desconocido)
(probcond ?X SI ?c1 ?v1 ?p+x/c)
(prob ?c1 ?v1 ?p)
=>
(assert (prob_posteriori_causas ?X ?p+x/c))
(assert (prob_conjunta ?X (* ?p ?p+x/c)))
(assert (prob_conjunta_negativo ?X (* ?p (- 1 ?p+x/c))))
(printout t  "--> " ?c1 " influye en la probabilidad de " ?X crlf)
(printout t "--> Como " ?c1 " toma el valor " ?v1 ":" crlf)
(printout t crlf "CON ESOS FACTORES: La probabilidad de " ?X " ha cambiado a " ?p+x/c crlf)
(printout t crlf)
)

(defrule inferencia2causas
(red causal causas)
(influye ?c1 ?X)
(influye ?c2 ?X)
(test (neq ?c1 ?c2))
(valor ?c1 ?v1)
(valor ?c2 ?v2)
(probcond2 ?X SI ?c1 ?v1 ?c2 ?v2 ?p+x/c1c2)
(prob ?c1 ?v1 ?p1)
(prob ?c2 ?v2 ?p2)
=>
(assert (prob_posteriori_causas ?X  ?p+x/c1c2))
(assert (prob_conjunta ?X (* ?p2 (* ?p1 ?p+x/c1c2))))
(assert (prob_conjunta_negativo ?X (* ?p2 (* ?p1 (- 1 ?p+x/c1c2)))))
(printout t  "---> " ?c1 " y " ?c2 " influyen la probabilidad de " ?X crlf)
(printout t "--->  Como " ?c1 " toma el valor " ?v1 " y " ?c2 " toma el valor " ?v2 ":" crlf)
(printout t crlf "CON ESOS FACTORES: La probabilidad de " ?X " ha cambiado a " ?p+x/c1c2 crlf)
(printout t crlf)
)

(defrule ir_a_red_causal_efectos
(declare (salience -1))
?f <- (red causal causas)
=>
(printout t crlf crlf "BUSCANDO INDICIOS" crlf)
(retract ?f)
(assert (red causal efectos))
)

;;;;; MODULO RED CAUSAL EFECTOS

(defrule redcausal1efecto
(red causal efectos)
(efecto ?e ?X)
(valor ?e ?v & ~Desconocido)
(probcond ?e ?v ?X SI ?pe/+x)
(probcond ?e ?v ?X NO ?pe/-x)
=>
(assert (multiplicar prob_conjunta ?pe/+x))
(assert (multiplicar prob_conjunta_negativo ?pe/-x))
(printout t "--> " ?e " es un efecto de " ?X ". Como " ?e " toma el valor " ?v ":" crlf)
(printout t "--> vamos a utilizarlo para actualizar la probabilidad de " ?X crlf)
(printout t crlf)
)

(defrule actualizar_prob_conjunta
(red causal efectos)
?f <- (prob_conjunta ?X ?p+x)
?g <- (multiplicar prob_conjunta ?pe/+x)
=>
(bind ?p+x+e (* ?pe/+x ?p+x))
(assert (prob_conjunta ?X ?p+x+e))
(retract ?f ?g)
)

(defrule actualizar_prob_conjunta_negativa
(red causal efectos)
?f <- (prob_conjunta_negativo ?X ?p)
?g <- (multiplicar prob_conjunta_negativo ?pe)
=>
(assert (prob_conjunta_negativo ?X (* ?p ?pe)))
(retract ?f ?g)
)

(defrule prob_posteriori
(declare (salience -1))
(red causal efectos)
(prob_conjunta ?X ?p+x)
(prob_conjunta_negativo ?X ?p-x)
=>
(bind ?pc (+ ?p+x ?p-x))
(bind ?p (/ ?p+x ?pc))
(assert (prob_posteriori ?X ?p))
(printout t "FINALMENTE: Por el teorema de Bayes la probabilidad de que le guste comer pasta ha cambiado a " ?p crlf)
(printout t crlf)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;   INTERACCION CON EL USUARIO  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Se solicitan al usuario (total o parcialmente) los datos de la persona:
;;;  la edad, si comio pasta ayer, si le gustan los restaurantes italianos y
;;;  la frecuencia con la que come pasta. Con ello se estima la probabilidad
;;;  de que a la persona le guste comer pasta.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule preguntar_edad
(red causal causas)
=>
(printout t "Que edad tiene la persona (1=joven 2=mediana edad 3=mayor 4=Desconocido): " )
(bind ?respuesta (read))
(if (= ?respuesta 1) then (assert (valor edad joven))
  else (if (= ?respuesta 2) then (assert (valor edad mediana))
    else (if (= ?respuesta 3) then (assert (valor edad mayor))
	 else (assert (valor edad Desconocido)))))
(printout t crlf)
)

(defrule preguntar_comio_ayer
(red causal causas)
=>
(printout t "Comio pasta ayer (1=si 2=no 3=Desconocido): " )
(bind ?respuesta (read))
(if (= ?respuesta 1) then (assert (valor comio_ayer si))
  else (if (= ?respuesta 2) then (assert (valor comio_ayer no))
	 else (assert (valor comio_ayer Desconocido))))
(printout t crlf)
)

(defrule preguntar_restaurantes
(red causal efectos)
=>
(printout t "Le gustan los restaurantes italianos (1=si 2=no 3=Desconocido): " )
(bind ?respuesta (read))
(if (= ?respuesta 1) then (assert (valor restaurantes_italianos si))
  else (if (= ?respuesta 2) then (assert (valor restaurantes_italianos no))
	 else (assert (valor restaurantes_italianos Desconocido))))
(printout t crlf)
)

(defrule preguntar_frecuencia
(red causal efectos)
=>
(printout t "Con que frecuencia come pasta (1=esporadicamente 2=frecuentemente 3=habitualmente 4=Desconocido): " )
(bind ?respuesta (read))
(if (= ?respuesta 1) then (assert (valor frecuencia esporadicamente))
  else (if (= ?respuesta 2) then (assert (valor frecuencia frecuentemente))
    else (if (= ?respuesta 3) then (assert (valor frecuencia habitualmente))
	 else (assert (valor frecuencia Desconocido)))))
(printout t crlf)
)
