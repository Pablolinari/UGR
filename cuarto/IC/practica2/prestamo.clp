
(deftemplate prestamo
  (slot id)
  (slot tipo)
  (slot destino (default desconocido)))

(deftemplate deducibilidad
  (slot id)
  (slot estado))

; Regla 1: prestamos personales para vivienda => deducible
(defrule personal-vivienda-deducible
  (prestamo (id ?id) (tipo personal) (destino vivienda))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado deducible))))

; Regla 2: prestamos personales no vivienda => no deducible
(defrule personal-no-deducible
  (prestamo (id ?id) (tipo personal) (destino ?d&~vivienda))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado no-deducible))))

; Regla 3: prestamos no personales => deducible
(defrule prestamo-deducible
  (prestamo (id ?id) (tipo ?t&~personal))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado deducible))))

; Casos de prueba (tabla con al menos 5 casos)
(deffacts casos-prueba
  (prestamo (id p1) (tipo personal) (destino vivienda))
  (prestamo (id p2) (tipo personal) (destino coche))
  (prestamo (id p3) (tipo hipotecario) (destino vivienda))
  (prestamo (id p4) (tipo comercial) (destino negocio))
  (prestamo (id p5) (tipo personal)))

(defrule imprimir-cabecera
  (declare (salience 100))
  (initial-fact)
  (not (cabecera-impresa))
  =>
  (assert (cabecera-impresa))
  (printout t "ID\tTIPO\tDESTINO\tESTADO" crlf))

(defrule imprimir-fila
  (deducibilidad (id ?id) (estado ?estado))
  (prestamo (id ?id) (tipo ?tipo) (destino ?destino))
  =>
  (printout t ?id "\t" ?tipo "\t" ?destino "\t" ?estado crlf))
