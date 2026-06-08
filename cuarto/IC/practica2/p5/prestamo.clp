
(deftemplate prestamo
  (slot id)
  (slot tipo)
  (slot destino (default desconocido)))

(deftemplate deducibilidad
  (slot id)
  (slot estado)
  (slot explicacion))

(deftemplate seleccion
  (slot id))

(deftemplate consulta
  (slot id))

(deftemplate fase
  (slot nombre))

(deftemplate nuevo-prestamo
  (slot id))

(deftemplate nuevo-tipo
  (slot id)
  (slot tipo))

(deftemplate respuesta-personal
  (slot id)
  (slot valor))

(deftemplate respuesta-vivienda
  (slot id)
  (slot valor))

(deftemplate resultado-impreso
  (slot id))

; Prestamos disponibles
(deffacts prestamos-disponibles
  (prestamo (id p1) (tipo personal) (destino vivienda))
  (prestamo (id p2) (tipo personal) (destino coche))
  (prestamo (id p3) (tipo hipotecario) (destino vivienda))
  (prestamo (id p4) (tipo comercial) (destino negocio))
  (prestamo (id p5) (tipo personal) (destino desconocido)))

(deffacts fase-inicial
  (fase (nombre listar)))

(defrule listar-prestamos
  ?f <- (fase (nombre listar))
  =>
  (retract ?f)
  (printout t "Prestamos disponibles:" crlf)
  (printout t "ID" tab "TIPO" tab "DESTINO" crlf)
  (do-for-all-facts ((?p prestamo)) TRUE
    (printout t (fact-slot-value ?p id) tab (fact-slot-value ?p tipo) tab (fact-slot-value ?p destino) crlf))
  (assert (fase (nombre pedir-seleccion))))

(defrule pedir-seleccion
  ?f <- (fase (nombre pedir-seleccion))
  =>
  (retract ?f)
  (printout t "Seleccione id de prestamo o 'nuevo': ")
  (bind ?resp (read))
  (assert (seleccion (id ?resp))))

(defrule seleccionar-existente
  ?s <- (seleccion (id ?id))
  (prestamo (id ?id))
  =>
  (retract ?s)
  (assert (consulta (id ?id))))

(defrule seleccionar-nuevo
  ?s <- (seleccion (id nuevo))
  =>
  (retract ?s)
  (printout t "Indique un id para el prestamo nuevo: ")
  (bind ?nid (read))
  (assert (nuevo-prestamo (id ?nid)))
  (assert (fase (nombre nuevo-pedir-personal))))

(defrule seleccionar-id-no-existe
  ?s <- (seleccion (id ?id&~nuevo))
  (not (prestamo (id ?id)))
  =>
  (retract ?s)
  (printout t "No existe. Se tratara como nuevo." crlf)
  (assert (nuevo-prestamo (id ?id)))
  (assert (fase (nombre nuevo-pedir-personal))))

(defrule nuevo-id-existente
  ?n <- (nuevo-prestamo (id ?id))
  (prestamo (id ?id))
  =>
  (retract ?n)
  (printout t "Ese id ya existe. Se usara el prestamo existente." crlf)
  (assert (consulta (id ?id))))

(defrule pedir-personal
  ?f <- (fase (nombre nuevo-pedir-personal))
  (nuevo-prestamo (id ?id))
  (not (prestamo (id ?id)))
  =>
  (retract ?f)
  (printout t "Es un prestamo personal? (si/no/desconocido): ")
  (bind ?resp (read))
  (assert (respuesta-personal (id ?id) (valor ?resp))))

(defrule personal-si
  ?r <- (respuesta-personal (id ?id) (valor si))
  =>
  (retract ?r)
  (assert (nuevo-tipo (id ?id) (tipo personal)))
  (assert (fase (nombre nuevo-pedir-vivienda))))

(defrule personal-no
  ?r <- (respuesta-personal (id ?id) (valor no))
  =>
  (retract ?r)
  (assert (nuevo-tipo (id ?id) (tipo no-personal)))
  (assert (fase (nombre nuevo-pedir-vivienda))))

(defrule personal-desconocido
  ?r <- (respuesta-personal (id ?id) (valor desconocido))
  =>
  (retract ?r)
  (assert (nuevo-tipo (id ?id) (tipo desconocido)))
  (assert (fase (nombre nuevo-pedir-vivienda))))

(defrule personal-otro
  ?r <- (respuesta-personal (id ?id) (valor ?v&~si&~no&~desconocido))
  =>
  (retract ?r)
  (printout t "Respuesta no valida. Se usara 'desconocido'." crlf)
  (assert (nuevo-tipo (id ?id) (tipo desconocido)))
  (assert (fase (nombre nuevo-pedir-vivienda))))

(defrule pedir-vivienda
  ?f <- (fase (nombre nuevo-pedir-vivienda))
  (nuevo-tipo (id ?id))
  (nuevo-prestamo (id ?id))
  =>
  (retract ?f)
  (printout t "Se usa para vivienda? (si/no/desconocido): ")
  (bind ?resp (read))
  (assert (respuesta-vivienda (id ?id) (valor ?resp))))

(defrule vivienda-si
  ?r <- (respuesta-vivienda (id ?id) (valor si))
  ?t <- (nuevo-tipo (id ?id) (tipo ?tipo))
  ?n <- (nuevo-prestamo (id ?id))
  =>
  (retract ?r ?t ?n)
  (assert (prestamo (id ?id) (tipo ?tipo) (destino vivienda)))
  (assert (consulta (id ?id))))

(defrule vivienda-no
  ?r <- (respuesta-vivienda (id ?id) (valor no))
  ?t <- (nuevo-tipo (id ?id) (tipo ?tipo))
  ?n <- (nuevo-prestamo (id ?id))
  =>
  (retract ?r ?t ?n)
  (assert (prestamo (id ?id) (tipo ?tipo) (destino otro)))
  (assert (consulta (id ?id))))

(defrule vivienda-desconocido
  ?r <- (respuesta-vivienda (id ?id) (valor desconocido))
  ?t <- (nuevo-tipo (id ?id) (tipo ?tipo))
  ?n <- (nuevo-prestamo (id ?id))
  =>
  (retract ?r ?t ?n)
  (assert (prestamo (id ?id) (tipo ?tipo) (destino desconocido)))
  (assert (consulta (id ?id))))

(defrule vivienda-otro
  ?r <- (respuesta-vivienda (id ?id) (valor ?v&~si&~no&~desconocido))
  ?t <- (nuevo-tipo (id ?id) (tipo ?tipo))
  ?n <- (nuevo-prestamo (id ?id))
  =>
  (retract ?r ?t ?n)
  (printout t "Respuesta no valida. Se usara 'desconocido'." crlf)
  (assert (prestamo (id ?id) (tipo ?tipo) (destino desconocido)))
  (assert (consulta (id ?id))))

; Regla 1: prestamos personales para vivienda => deducible
(defrule personal-vivienda-deducible
  (consulta (id ?id))
  (prestamo (id ?id) (tipo personal) (destino vivienda))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado deducible)
                         (explicacion "Prestamo personal para vivienda: deducible."))))

; Regla 2: prestamos personales no vivienda => no deducible
(defrule personal-no-deducible
  (consulta (id ?id))
  (prestamo (id ?id) (tipo personal) (destino ?d&~vivienda&~desconocido))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado no-deducible)
                         (explicacion "Prestamo personal no destinado a vivienda: no deducible."))))

; Regla 3: prestamos no personales => deducible
(defrule prestamo-deducible
  (consulta (id ?id))
  (prestamo (id ?id) (tipo ?t&~personal&~desconocido))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado deducible)
                         (explicacion "Prestamo no personal: deducible."))))

; Regla 4: informacion insuficiente => indeterminado
(defrule prestamo-indeterminado-tipo
  (consulta (id ?id))
  (prestamo (id ?id) (tipo desconocido))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado indeterminado)
                         (explicacion "Tipo de prestamo desconocido; no se puede determinar."))))

(defrule prestamo-indeterminado-destino
  (consulta (id ?id))
  (prestamo (id ?id) (tipo personal) (destino desconocido))
  (not (deducibilidad (id ?id)))
  =>
  (assert (deducibilidad (id ?id) (estado indeterminado)
                         (explicacion "Destino de prestamo personal desconocido; no se puede determinar."))))

(defrule imprimir-resultado
  (consulta (id ?id))
  (prestamo (id ?id) (tipo ?tipo) (destino ?destino))
  (deducibilidad (id ?id) (estado ?estado) (explicacion ?exp))
  (not (resultado-impreso (id ?id)))
  =>
  (assert (resultado-impreso (id ?id)))
  (printout t crlf "Resultado para " ?id ":" crlf)
  (printout t "Tipo: " ?tipo "  Destino: " ?destino crlf)
  (printout t "Estado: " ?estado crlf)
  (printout t "Explicacion: " ?exp crlf))
