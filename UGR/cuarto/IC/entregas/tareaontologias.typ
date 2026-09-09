#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2cm),
  fill: rgb("#f4f7f6")
)
#set text(
  font: "Libertinus Serif",
  size: 11pt,
  lang: "es"
)

#show heading: set text(fill: rgb("#2c3e50"))
#show heading.where(level: 1): set text(size: 22pt)

= Ejercicio de Ingeniería del Conocimiento: Ontologías
== Ejercicio 1
=== 1.1 Enunciado
Basado en la *Ontología del Congreso*, traducir a palabras el siguiente axioma en Lógica de Descripción (DL):

$"Presentación" subset.eq ∃ "P-Autor". (∃ "Nombre_aut". (∃ "Nombre_Ins"^(-1)."Inscrito"))$

=== 1.2. Descomposición de la expresión

Para entender el axioma, lo dividimos en sus componentes atómicos:

- *#strong("Presentación") $subset.eq ...$*: Indica una relación de inclusión o restricción. Se lee como "Toda instancia de Presentación debe ser..." o "Todas las Presentaciones cumplen que...".
- *#strong("∃ P-Autor")*: Es una restricción de existencia sobre la propiedad de objeto. Indica que la presentación debe estar vinculada a, al menos, un individuo de la clase #underline("Autor").
- *#strong("∃ Nombre_aut")*: Es una restricción sobre una propiedad de datos. Se refiere al valor del nombre del autor.
- *#strong("∃ Nombre_Ins")*: Aquí se utiliza el #strong("rol inverso"). Dado que en la ontología `Nombre_Ins` es una propiedad que va de #emph[Inscrito] a #emph[String], su inversa va de #emph[String] a #emph[Inscrito].
- *#strong("Inscrito")*: Es la clase destino.
=== 1.3 Resultado final (Lenguaje Natural)

Toda presentación realizada en el congreso debe tener un autor que figure en la lista de personas inscritas.



== Ejercicio 2

=== 1. Enunciado
Crear un axioma para representar: *"Todas las presentaciones tienen que estar justificadas por las inscripciones, de acuerdo al siguiente criterio: cada inscripción justifica solo una de las presentaciones de las que el inscrito es autor"*.







=== 2. Descomposición de los componentes

- *#strong("esJustificadaPor")*: Relación entre una #emph[Presentación] y un #emph[Inscrito]. Indica que la presentación está respaldada por una inscripción concreta.
- *#strong("Inscrito")*: Clase de las personas registradas en el congreso. Son quienes pueden justificar presentaciones.
- *#strong("P-autor")*: Relación entre una #emph[Presentación] y su #emph[Autor]. Sirve para vincular cada presentación con quien la firma.
- *#strong("Presentacion")*: Clase de las contribuciones del congreso (artículos, conferencias invitadas y pósteres) que deben estar justificadas.


$ "Presentacion" subset.eq exists "esJustificadaPor" . ("Inscrito" inter exists "P-autor"^-1 . "Presentacion") $

$ "Inscrito" subset.eq <= 1 "esJustificadaPor"^-1 . "Presentacion" $
