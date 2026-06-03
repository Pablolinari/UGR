
(deftemplate contexto
  (slot km-anuales (default 0))
  (slot remolque-pesado (default no))
  (slot trayectos-largos (default no))
  (slot presupuesto (default medio))
  (slot ciudad (default no))
  (slot zbe (default no))
  (slot beneficios-cero (default no)))

(deftemplate recomendacion
  (slot tipo)
  (slot cf))

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
  (contexto (km-anuales ?km&:(< ?km 20000)))
  =>
  (assert (recomendacion (tipo gasolina) (cf 0.6))))

(defrule km-bajo-hibrido-auto
  (contexto (km-anuales ?km&:(< ?km 20000)))
  =>
  (assert (recomendacion (tipo hibrido-auto-recargable) (cf 0.8))))

; Remolque pesado
(defrule remolque-pesado-diesel
  (contexto (remolque-pesado si))
  =>
  (assert (recomendacion (tipo diesel) (cf 0.5))))

; Muchos trayectos largos
(defrule trayectos-largos-no-electrico
  (contexto (trayectos-largos si))
  =>
  (assert (recomendacion (tipo electrico) (cf -0.9))))

(defrule trayectos-largos-no-gas
  (contexto (trayectos-largos si))
  =>
  (assert (recomendacion (tipo gas) (cf -0.3))))

; Presupuesto bajo
(defrule presupuesto-bajo-gasolina
  (contexto (presupuesto bajo))
  =>
  (assert (recomendacion (tipo gasolina) (cf 0.7))))

(defrule presupuesto-bajo-gas
  (contexto (presupuesto bajo))
  =>
  (assert (recomendacion (tipo gas) (cf 0.6))))

; Presupuesto alto
(defrule presupuesto-alto-hibrido
  (contexto (presupuesto alto))
  =>
  (assert (recomendacion (tipo hibrido) (cf 0.6))))

(defrule presupuesto-alto-electrico
  (contexto (presupuesto alto))
  =>
  (assert (recomendacion (tipo electrico) (cf 0.7))))

; Circulas por ciudad
(defrule ciudad-electrico
  (contexto (ciudad si))
  =>
  (assert (recomendacion (tipo electrico) (cf 0.8))))

; Viajes a ciudades con ZBE
(defrule zbe-no-gasolina
  (contexto (zbe si))
  =>
  (assert (recomendacion (tipo gasolina) (cf -0.8))))

(defrule zbe-no-hibrido-auto
  (contexto (zbe si))
  =>
  (assert (recomendacion (tipo hibrido-auto-recargable) (cf -0.3))))

; Beneficios etiqueta Cero
(defrule beneficios-cero-electrico
  (contexto (beneficios-cero si))
  =>
  (assert (recomendacion (tipo electrico) (cf 0.2))))

; Combinar recomendaciones del mismo tipo
(defrule combinar-recomendaciones
  ?r1 <- (recomendacion (tipo ?t) (cf ?cf1))
  ?r2 <- (recomendacion (tipo ?t) (cf ?cf2))
  (test (< (fact-index ?r1) (fact-index ?r2)))
  =>
  (retract ?r1 ?r2)
  (assert (recomendacion (tipo ?t) (cf (combine-cf ?cf1 ?cf2)))))

; Casos de prueba (tabla con al menos 5 casos)
(deffacts casos-prueba
  (contexto (km-anuales 15000) (presupuesto bajo) (ciudad si) (zbe si) (beneficios-cero si))
  (contexto (km-anuales 30000) (trayectos-largos si) (presupuesto medio) (remolque-pesado si))
  (contexto (km-anuales 12000) (presupuesto alto) (ciudad no) (zbe no))
  (contexto (km-anuales 18000) (trayectos-largos si) (presupuesto bajo) (zbe si))
  (contexto (km-anuales 8000) (presupuesto alto) (ciudad si) (beneficios-cero si)))

(defrule imprimir-cabecera
  (declare (salience 100))
  (initial-fact)
  (not (cabecera-impresa))
  =>
  (assert (cabecera-impresa))
  (printout t "TIPO\tCF" crlf))

(defrule imprimir-recomendacion
  (recomendacion (tipo ?tipo) (cf ?cf))
  =>
  (printout t ?tipo "\t" ?cf crlf))
