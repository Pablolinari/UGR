;;; ===================================================================
;;; DEFTEMPLATES (Plantillas de Hechos)
;;; ===================================================================

(deftemplate paciente
   (slot imc)
   (slot edad)
   (slot colesterol))

(deftemplate clasificacion
   (slot imc)
   (slot edad)
   (slot colesterol))

(deftemplate resultado
   (slot nivel)
   (slot valor-escala)
   (slot regla))

;;; ===================================================================
;;; REGLA DE INTERFAZ: Lectura de Datos
;;; ===================================================================

(defrule iniciar-sistema
   (initial-fact)
   =>
   (printout t "==================================================" crlf)
   (printout t "   SISTEMA EXPERTO DE ESTIMACION DE INFARTOS      " crlf)
   (printout t "==================================================" crlf)
   
   (printout t "1. Ingrese el IMC (Indice de Masa Corporal) [ej. 28.5]: ")
   (bind ?imc (read))
   
   (printout t "2. Ingrese la edad (en anos) [ej. 65]: ")
   (bind ?edad (read))
   
   (printout t "3. Ingrese el nivel de colesterol (mg/dL) [ej. 210]: ")
   (bind ?col (read))
   
   (assert (paciente (imc ?imc) (edad ?edad) (colesterol ?col))))

;;; ===================================================================
;;; REGLA DE FUZZIFICACIÓN / CLASIFICACIÓN numérico-lingüística
;;; ===================================================================

(defrule clasificar-paciente
   (paciente (imc ?i) (edad ?e) (colesterol ?c))
   =>
   ;; Clasificación del IMC basada en el PDF
   (bind ?c-imc normal)
   (if (and (>= ?i 15.0) (< ?i 30.0)) then (bind ?c-imc elevado))
   (if (>= ?i 30.0) then (bind ?c-imc muy-elevado))

   ;; Clasificación de Edad basada en el PDF
   (bind ?c-edad joven-media)
   (if (>= ?e 60) then (bind ?c-edad avanzada))

   ;; Clasificación de Colesterol (parámetros clínicos estándar)
   (bind ?c-col normal)
   (if (and (>= ?c 200) (< ?c 240)) then (bind ?c-col alto))
   (if (>= ?c 240) then (bind ?c-col muy-alto))

   (assert (clasificacion (imc ?c-imc) (edad ?c-edad) (colesterol ?c-col))))

;;; ===================================================================
;;; REGLAS DEL NEGOCIO / INFERENCIA (Priorizadas por nivel de riesgo)
;;; ===================================================================

;; - Si el IMC es muy elevado el riesgo de infarto es muy alto
(defrule evaluar-regla-3
   (declare (salience 30))
   (clasificacion (imc muy-elevado))
   (not (resultado))
   =>
   (assert (resultado (nivel "Muy Alto") 
                      (valor-escala "7.5 a 10.0") 
                      (regla "Si el IMC es muy elevado el riesgo es muy alto."))))

;; - Si tiene el colesterol muy alto el riesgo de infarto es muy alto
(defrule evaluar-regla-5
   (declare (salience 30))
   (clasificacion (colesterol muy-alto))
   (not (resultado))
   =>
   (assert (resultado (nivel "Muy Alto") 
                      (valor-escala "7.5 a 10.0") 
                      (regla "Si tiene el colesterol muy alto el riesgo es muy alto."))))

;; - Si el IMC es elevado y la edad es avanzada el riesgo de infarto es alto
(defrule evaluar-regla-2
   (declare (salience 20))
   (clasificacion (imc elevado) (edad avanzada))
   (not (resultado))
   =>
   (assert (resultado (nivel "Alto") 
                      (valor-escala "5.0 a 7.5") 
                      (regla "Si el IMC es elevado y la edad es avanzada el riesgo es alto."))))

;; - Si tiene el colesterol alto el riesgo de infarto es alto
(defrule evaluar-regla-4
   (declare (salience 20))
   (clasificacion (colesterol alto))
   (not (resultado))
   =>
   (assert (resultado (nivel "Alto") 
                      (valor-escala "5.0 a 7.5") 
                      (regla "Si tiene el colesterol alto el riesgo es alto."))))

;; - Si el IMC es elevado pero tiene el colesterol normal el riesgo de infarto es medio
(defrule evaluar-regla-1
   (declare (salience 10))
   (clasificacion (imc elevado) (colesterol normal))
   (not (resultado))
   =>
   (assert (resultado (nivel "Medio") 
                      (valor-escala "2.5 a 5.0") 
                      (regla "Si el IMC es elevado pero el colesterol es normal el riesgo es medio."))))

;; - En otro caso el riesgo de infarto es bajo 
(defrule evaluar-regla-6-defecto
   (declare (salience 0))
   (clasificacion)
   (not (resultado))
   =>
   (assert (resultado (nivel "Bajo") 
                      (valor-escala "0.0 a 2.5") 
                      (regla "En otro caso el riesgo de infarto es bajo (Ninguna condicion crítica activa)."))))

;;; ===================================================================
;;; REGLA DE SALIDA: Mostrar diagnóstico
;;; ===================================================================

(defrule mostrar-diagnostico
   (declare (salience -10))
   (resultado (nivel ?n) (valor-escala ?v) (regla ?r))
   =>
   (printout t crlf "--------------------------------------------------" crlf)
   (printout t "              DIAGNOSTICO FINAL" crlf)
   (printout t "--------------------------------------------------" crlf)
   (printout t "REGLA DETECTADA : " ?r crlf)
   (printout t "RIESGO ESTIMADO : " ?n crlf)
   (printout t "ESCALA (0 al 10): " ?v crlf)
   (printout t "--------------------------------------------------" crlf))
