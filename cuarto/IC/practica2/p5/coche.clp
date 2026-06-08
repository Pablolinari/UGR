
(deftemplate contexto
  (slot km-anuales (default 0))
  (slot remolque-pesado (default no))
  (slot trayectos-largos (default no))
  (slot presupuesto (default medio))
  (slot ciudad (default no))
  (slot zbe (default no))
  (slot beneficios-cero (default no)))

(deftemplate fase
  (slot nombre))

(deftemplate recomendacion
  (slot tipo)
  (slot cf)
  (slot explicacion))

(deffacts inicio
  (contexto)
  (fase (nombre pedir-presupuesto)))

(deffunction combine-cf (?cf1 ?cf2)
  (if (and (>= ?cf1 0) (>= ?cf2 0)) then
      (+ ?cf1 (* ?cf2 (- 1 ?cf1)))
    else
      (if (and (< ?cf1 0) (< ?cf2 0)) then
          (+ ?cf1 (* ?cf2 (+ 1 ?cf1)))
        else
          (/ (+ ?cf1 ?cf2)
             (- 1 (min (abs ?cf1) (abs ?cf2)))))))

; Menos de 20000 km
(defrule km-bajo-gasolina
  (fase (nombre evaluar))
  (contexto (km-anuales ?km&:(< ?km 20000)))
  =>
  (assert (recomendacion (tipo gasolina) (cf 0.6)
                         (explicacion (str-cat "Con " ?km " km al ano, el uso es moderado; gasolina equilibra coste y mantenimiento.")))))

(defrule km-bajo-hibrido-auto
  (fase (nombre evaluar))
  (contexto (km-anuales ?km&:(< ?km 20000)))
  =>
  (assert (recomendacion (tipo hibrido-auto-recargable) (cf 0.8)
                         (explicacion (str-cat "Con " ?km " km al ano, un hibrido auto-recargable aprovecha trayectos cortos y reduce consumo.")))))

; Remolque pesado
(defrule remolque-pesado-diesel
  (fase (nombre evaluar))
  (contexto (remolque-pesado si))
  =>
  (assert (recomendacion (tipo diesel) (cf 0.5)
                         (explicacion "Remolque pesado requiere par y robustez; diesel es mas adecuado."))))

; Muchos trayectos largos
(defrule trayectos-largos-no-electrico
  (fase (nombre evaluar))
  (contexto (trayectos-largos si))
  =>
  (assert (recomendacion (tipo electrico) (cf -0.9)
                         (explicacion "Trayectos largos penalizan autonomia y tiempos de recarga; se desaconseja electrico."))))

(defrule trayectos-largos-no-gas
  (fase (nombre evaluar))
  (contexto (trayectos-largos si))
  =>
  (assert (recomendacion (tipo gas) (cf -0.3)
                         (explicacion "Trayectos largos hacen menos conveniente el uso de gas; se penaliza."))))

; Presupuesto bajo
(defrule presupuesto-bajo-gasolina
  (fase (nombre evaluar))
  (contexto (presupuesto bajo))
  =>
  (assert (recomendacion (tipo gasolina) (cf 0.7)
                         (explicacion "Presupuesto bajo prioriza coste inicial; gasolina es opcion accesible."))))

(defrule presupuesto-bajo-gas
  (fase (nombre evaluar))
  (contexto (presupuesto bajo))
  =>
  (assert (recomendacion (tipo gas) (cf 0.6)
                         (explicacion "Presupuesto bajo: el gas reduce gasto por km si hay infraestructura."))))

; Presupuesto alto
(defrule presupuesto-alto-hibrido
  (fase (nombre evaluar))
  (contexto (presupuesto alto))
  =>
  (assert (recomendacion (tipo hibrido) (cf 0.6)
                         (explicacion "Presupuesto alto permite invertir en hibrido para eficiencia y etiqueta ambiental."))))

(defrule presupuesto-alto-electrico
  (fase (nombre evaluar))
  (contexto (presupuesto alto))
  =>
  (assert (recomendacion (tipo electrico) (cf 0.7)
                         (explicacion "Presupuesto alto facilita el electrico, con menor coste por km."))))

; Circulas por ciudad
(defrule ciudad-electrico
  (fase (nombre evaluar))
  (contexto (ciudad si))
  =>
  (assert (recomendacion (tipo electrico) (cf 0.8)
                         (explicacion "Uso urbano favorece el electrico por eficiencia y restricciones locales."))))

; Viajes a ciudades con ZBE
(defrule zbe-no-gasolina
  (fase (nombre evaluar))
  (contexto (zbe si))
  =>
  (assert (recomendacion (tipo gasolina) (cf -0.8)
                         (explicacion "ZBE limita gasolina y puede imponer costes; se penaliza."))))

(defrule zbe-no-hibrido-auto
  (fase (nombre evaluar))
  (contexto (zbe si))
  =>
  (assert (recomendacion (tipo hibrido-auto-recargable) (cf -0.3)
                         (explicacion "En ZBE, el hibrido auto-recargable puede tener restricciones; se penaliza."))))

; Beneficios etiqueta Cero
(defrule beneficios-cero-electrico
  (fase (nombre evaluar))
  (contexto (beneficios-cero si))
  =>
  (assert (recomendacion (tipo electrico) (cf 0.2)
                         (explicacion "Beneficios por etiqueta Cero favorecen el electrico."))))

; Combinar recomendaciones del mismo tipo
(defrule combinar-recomendaciones
  ?r1 <- (recomendacion (tipo ?t) (cf ?cf1) (explicacion ?e1))
  ?r2 <- (recomendacion (tipo ?t) (cf ?cf2) (explicacion ?e2))
  (test (< (fact-index ?r1) (fact-index ?r2)))
  =>
  (retract ?r1 ?r2)
  (assert (recomendacion (tipo ?t)
                         (cf (combine-cf ?cf1 ?cf2))
                         (explicacion (str-cat ?e1 " | " ?e2)))))

; Preguntas al usuario
(defrule pedir-presupuesto
  ?f <- (fase (nombre pedir-presupuesto))
  ?c <- (contexto)
  =>
  (retract ?f)
  (printout t "Nivel de presupuesto (bajo/medio/alto): ")
  (bind ?resp (read))
  (if (or (eq ?resp bajo) (eq ?resp medio) (eq ?resp alto)) then
      (modify ?c (presupuesto ?resp))
    else
      (printout t "Respuesta no valida. Se asume 'medio'." crlf)
      (modify ?c (presupuesto medio)))
  (assert (fase (nombre pedir-km-bajo))))

(defrule pedir-km-bajo
  ?f <- (fase (nombre pedir-km-bajo))
  ?c <- (contexto)
  =>
  (retract ?f)
  (printout t "Haces menos de 20000 km al ano? (si/no): ")
  (bind ?resp (read))
  (if (eq ?resp si) then
      (modify ?c (km-anuales 15000))
    else
      (if (eq ?resp no) then
          (modify ?c (km-anuales 30000))
        else
          (printout t "Respuesta no valida. Se asume 'no'." crlf)
          (modify ?c (km-anuales 30000))))
  (assert (fase (nombre pedir-trayectos-largos))))

(defrule pedir-trayectos-largos
  ?f <- (fase (nombre pedir-trayectos-largos))
  ?c <- (contexto)
  =>
  (retract ?f)
  (printout t "Haces muchos trayectos largos? (si/no): ")
  (bind ?resp (read))
  (if (eq ?resp si) then
      (modify ?c (trayectos-largos si))
    else
      (if (eq ?resp no) then
          (modify ?c (trayectos-largos no))
        else
          (printout t "Respuesta no valida. Se asume 'no'." crlf)
          (modify ?c (trayectos-largos no))))
  (assert (fase (nombre pedir-remolque-pesado))))

(defrule pedir-remolque-pesado
  ?f <- (fase (nombre pedir-remolque-pesado))
  ?c <- (contexto)
  =>
  (retract ?f)
  (printout t "Vas a remolcar un remolque con mucho peso? (si/no): ")
  (bind ?resp (read))
  (if (eq ?resp si) then
      (modify ?c (remolque-pesado si))
    else
      (if (eq ?resp no) then
          (modify ?c (remolque-pesado no))
        else
          (printout t "Respuesta no valida. Se asume 'no'." crlf)
          (modify ?c (remolque-pesado no))))
  (assert (fase (nombre pedir-ciudad))))

(defrule pedir-ciudad
  ?f <- (fase (nombre pedir-ciudad))
  ?c <- (contexto)
  =>
  (retract ?f)
  (printout t "Circulas fundamentalmente por ciudad? (si/no): ")
  (bind ?resp (read))
  (if (eq ?resp si) then
      (modify ?c (ciudad si))
    else
      (if (eq ?resp no) then
          (modify ?c (ciudad no))
        else
          (printout t "Respuesta no valida. Se asume 'no'." crlf)
          (modify ?c (ciudad no))))
  (assert (fase (nombre pedir-zbe))))

(defrule pedir-zbe
  ?f <- (fase (nombre pedir-zbe))
  ?c <- (contexto)
  =>
  (retract ?f)
  (printout t "Vas a viajar a ciudades con ZBE? (si/no): ")
  (bind ?resp (read))
  (if (eq ?resp si) then
      (modify ?c (zbe si))
    else
      (if (eq ?resp no) then
          (modify ?c (zbe no))
        else
          (printout t "Respuesta no valida. Se asume 'no'." crlf)
          (modify ?c (zbe no))))
  (assert (fase (nombre pedir-beneficios-cero))))

(defrule pedir-beneficios-cero
  ?f <- (fase (nombre pedir-beneficios-cero))
  ?c <- (contexto)
  =>
  (retract ?f)
  (printout t "Tu ciudad tiene beneficios para etiqueta Cero? (si/no): ")
  (bind ?resp (read))
  (if (eq ?resp si) then
      (modify ?c (beneficios-cero si))
    else
      (if (eq ?resp no) then
          (modify ?c (beneficios-cero no))
        else
          (printout t "Respuesta no valida. Se asume 'no'." crlf)
          (modify ?c (beneficios-cero no))))
  (assert (fase (nombre evaluar)))
  (assert (fase (nombre imprimir))))

(defrule imprimir-recomendacion-final
  (declare (salience -10))
  ?f <- (fase (nombre imprimir))
  (recomendacion)
  =>
  (retract ?f)
  (bind ?mejor-tipo "")
  (bind ?mejor-cf -1000)
  (bind ?mejor-exp "")
  (do-for-all-facts ((?r recomendacion)) TRUE
    (if (> (fact-slot-value ?r cf) ?mejor-cf) then
      (bind ?mejor-cf (fact-slot-value ?r cf))
      (bind ?mejor-tipo (fact-slot-value ?r tipo))
      (bind ?mejor-exp (fact-slot-value ?r explicacion))))
  (printout t crlf "Recomendacion: " ?mejor-tipo crlf)
  (printout t "Factor de certeza total: " ?mejor-cf crlf)
  (printout t "Explicacion: " ?mejor-exp crlf))

(defrule sin-recomendacion
  (declare (salience -10))
  ?f <- (fase (nombre imprimir))
  (not (recomendacion))
  =>
  (retract ?f)
  (printout t crlf "No se pudo determinar una recomendacion." crlf))
