;;; ===================================================================
;;; SISTEMA EXPERTO DIFUSO DE ESTIMACION DE RIESGO DE INFARTO
;;; -------------------------------------------------------------------
;;; Inferencia tipo Mamdani simplificada:
;;;   - Fuzzificacion mediante funciones de pertenencia.
;;;   - Reglas difusas: grado de activacion = min de los antecedentes.
;;;   - Defuzzificacion por media ponderada (centros de los conjuntos
;;;     de salida = medias de las gaussianas de riesgo).
;;; ===================================================================

;;; ===================================================================
;;; FUNCIONES DE PERTENENCIA
;;; ===================================================================

;; Triangular [a, b, c]:  0 en a, sube a 1 en b, baja a 0 en c
(deffunction triangular (?x ?a ?b ?c)
   (if (or (<= ?x ?a) (>= ?x ?c)) then (return 0.0))
   (if (<= ?x ?b)
      then (return (/ (- ?x ?a) (- ?b ?a)))
      else (return (/ (- ?c ?x) (- ?c ?b)))))

;; Trapezoidal [a, b, c, d]: 0 en a, 1 en [b,c], 0 en d.
;; Soporta hombros: a=b (hombro izq) y c=d (hombro der).
(deffunction trapezoidal (?x ?a ?b ?c ?d)
   (if (<= ?x ?a)
      then (if (= ?a ?b) then (return 1.0) else (return 0.0)))
   (if (>= ?x ?d)
      then (if (= ?c ?d) then (return 1.0) else (return 0.0)))
   (if (< ?x ?b) then (return (/ (- ?x ?a) (- ?b ?a))))
   (if (<= ?x ?c) then (return 1.0))
   (return (/ (- ?d ?x) (- ?d ?c))))

;; Gaussiana: media (centro) y spread (sigma).
;; mu(x) = exp( -(x - media)^2 / (2 * spread^2) )
(deffunction gaussiana (?x ?media ?spread)
   (return (exp (/ (* -1.0 (* (- ?x ?media) (- ?x ?media)))
                   (* 2.0 (* ?spread ?spread))))))

;; Minimo difuso (AND)
(deffunction minimo (?a ?b)
   (if (< ?a ?b) then (return ?a) else (return ?b)))

;;; ===================================================================
;;; DEFTEMPLATES
;;; ===================================================================

(deftemplate paciente
   (slot imc)
   (slot edad)
   (slot colesterol))

;; Cada regla difusa que se activa aporta una contribucion al riesgo:
;;   centro = posicion (media) del conjunto de salida activado
;;   grado  = fuerza de activacion de la regla (0..1)
(deftemplate contribucion
   (slot termino)
   (slot centro)
   (slot grado)
   (slot regla))

(deftemplate resultado
   (slot nivel)
   (slot valor-escala)
   (slot regla))

;;; ===================================================================
;;; CENTROS DE LOS CONJUNTOS DE SALIDA (riesgo, universo 0..100)
;;;   Medio    : Gaussiana media 30, spread 20
;;;   Alto     : Gaussiana media 50, spread 20
;;;   Muy Alto : Gaussiana media 80, spread 20
;;; ===================================================================
;;; (Se usan las medias como centros para la media ponderada.)

;;; ===================================================================
;;; REGLA DE INTERFAZ: Lectura de Datos
;;; ===================================================================

;; Hecho de arranque (este CLIPS no asierta (initial-fact) en reset)
(deffacts arranque
   (iniciar))

(defrule iniciar-sistema
   (iniciar)
   =>
   (printout t "==================================================" crlf)
   (printout t "   SISTEMA EXPERTO DIFUSO DE RIESGO DE INFARTO     " crlf)
   (printout t "==================================================" crlf)

   (printout t "1. Ingrese el IMC (Indice de Masa Corporal) [ej. 28.5]: ")
   (bind ?imc (read))

   (printout t "2. Ingrese la edad (en anos) [ej. 65]: ")
   (bind ?edad (read))

   (printout t "3. Ingrese el nivel de colesterol (mg/dL) [ej. 210]: ")
   (bind ?col (read))

   (assert (paciente (imc ?imc) (edad ?edad) (colesterol ?col))))

;;; ===================================================================
;;; BASE DE REGLAS DIFUSAS
;;; -------------------------------------------------------------------
;;; Conjuntos de entrada:
;;;   EDAD  -> Joven    : trapezoidal [0, 10, 20, 30]
;;;            Media    : triangular  [20, 50, 70]
;;;            Avanzada : trapezoidal [60, 75, 100, 100]
;;;   IMC   -> Normal       : triangular  [0, 10, 20]
;;;            Elevado      : triangular  [15, 30, 50]
;;;            Muy elevado  : trapezoidal [30, 38, 50, 50]
;;;   COLESTEROL (criterio clinico estandar, mg/dL):
;;;            Normal     : trapezoidal [100, 150, 190, 210]
;;;            Alto       : triangular  [190, 220, 250]
;;;            Muy alto   : trapezoidal [240, 270, 400, 400]
;;; ===================================================================

;; R1: Si el IMC es muy elevado -> riesgo MUY ALTO
(defrule regla-imc-muy-elevado
   (paciente (imc ?i))
   =>
   (bind ?g (trapezoidal ?i 30 38 50 50))
   (if (> ?g 0.0) then
      (assert (contribucion (termino "Muy Alto") (centro 80) (grado ?g)
                            (regla "Si el IMC es muy elevado, el riesgo es muy alto.")))))

;; R2: Si el colesterol es muy alto -> riesgo MUY ALTO
(defrule regla-colesterol-muy-alto
   (paciente (colesterol ?c))
   =>
   (bind ?g (trapezoidal ?c 240 270 400 400))
   (if (> ?g 0.0) then
      (assert (contribucion (termino "Muy Alto") (centro 80) (grado ?g)
                            (regla "Si el colesterol es muy alto, el riesgo es muy alto.")))))

;; R3: Si el IMC es elevado y la edad avanzada -> riesgo ALTO
(defrule regla-imc-elevado-edad-avanzada
   (paciente (imc ?i) (edad ?e))
   =>
   (bind ?g (minimo (triangular ?i 15 30 50)
                    (trapezoidal ?e 60 75 100 100)))
   (if (> ?g 0.0) then
      (assert (contribucion (termino "Alto") (centro 50) (grado ?g)
                            (regla "Si el IMC es elevado y la edad avanzada, el riesgo es alto.")))))

;; R4: Si el colesterol es alto -> riesgo ALTO
(defrule regla-colesterol-alto
   (paciente (colesterol ?c))
   =>
   (bind ?g (triangular ?c 190 220 250))
   (if (> ?g 0.0) then
      (assert (contribucion (termino "Alto") (centro 50) (grado ?g)
                            (regla "Si el colesterol es alto, el riesgo es alto.")))))

;; R5: Si el IMC es elevado pero el colesterol normal -> riesgo MEDIO
(defrule regla-imc-elevado-colesterol-normal
   (paciente (imc ?i) (colesterol ?c))
   =>
   (bind ?g (minimo (triangular ?i 15 30 50)
                    (trapezoidal ?c 100 150 190 210)))
   (if (> ?g 0.0) then
      (assert (contribucion (termino "Medio") (centro 30) (grado ?g)
                            (regla "Si el IMC es elevado pero el colesterol normal, el riesgo es medio.")))))

;;; ===================================================================
;;; DEFUZZIFICACION: media ponderada de los centros activados
;;; ===================================================================

(defrule defuzzificar
   (declare (salience -20))
   (paciente)
   (not (resultado))
   =>
   (bind ?sum-w 0.0)
   (bind ?sum-wc 0.0)
   (bind ?mejor-grado 0.0)
   (bind ?mejor-termino "Bajo")
   (bind ?mejor-regla "Ninguna condicion de riesgo activa: riesgo bajo.")

   (do-for-all-facts ((?r contribucion)) TRUE
      (bind ?g (fact-slot-value ?r grado))
      (bind ?c (fact-slot-value ?r centro))
      (bind ?sum-w  (+ ?sum-w ?g))
      (bind ?sum-wc (+ ?sum-wc (* ?g ?c)))
      (if (> ?g ?mejor-grado) then
         (bind ?mejor-grado ?g)
         (bind ?mejor-termino (fact-slot-value ?r termino))
         (bind ?mejor-regla (fact-slot-value ?r regla))))

   ;; Valor crisp de riesgo en 0..100 (0 si no se activo ninguna regla)
   (if (> ?sum-w 0.0)
      then (bind ?riesgo (/ ?sum-wc ?sum-w))
      else (bind ?riesgo 0.0))

   ;; Etiqueta linguistica a partir del valor defuzzificado
   (if (< ?riesgo 25.0) then
      (bind ?nivel "Bajo") (bind ?rango "0.0 a 2.5")
    else (if (< ?riesgo 45.0) then
      (bind ?nivel "Medio") (bind ?rango "2.5 a 4.5")
    else (if (< ?riesgo 65.0) then
      (bind ?nivel "Alto") (bind ?rango "4.5 a 6.5")
    else
      (bind ?nivel "Muy Alto") (bind ?rango "6.5 a 10.0"))))

   (assert (resultado (nivel ?nivel)
                      (valor-escala (str-cat (/ ?riesgo 10.0) " / 10  (" ?rango ")"))
                      (regla ?mejor-regla))))

;;; ===================================================================
;;; REGLA DE SALIDA: Mostrar diagnostico
;;; ===================================================================

(defrule mostrar-diagnostico
   (declare (salience -30))
   (resultado (nivel ?n) (valor-escala ?v) (regla ?r))
   =>
   (printout t crlf "--------------------------------------------------" crlf)
   (printout t "              DIAGNOSTICO FINAL" crlf)
   (printout t "--------------------------------------------------" crlf)
   (printout t "REGLA DOMINANTE : " ?r crlf)
   (printout t "RIESGO ESTIMADO : " ?n crlf)
   (printout t "ESCALA (0 al 10): " ?v crlf)
   (printout t "--------------------------------------------------" crlf)
   (printout t "Reglas difusas activadas:" crlf)
   (do-for-all-facts ((?c contribucion)) TRUE
      (printout t "  - [" (fact-slot-value ?c termino)
                "] grado=" (fact-slot-value ?c grado)
                " :: " (fact-slot-value ?c regla) crlf))
   (printout t "--------------------------------------------------" crlf))
