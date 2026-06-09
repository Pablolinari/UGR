// --- CONFIGURACIÓN ESTILO LATEX ---
#set page(
  paper: "a4",
  margin: (x: 3cm, y: 2.5cm),
  numbering: "1",
)

#set text(
  // "New Computer Modern" es la versión moderna de la fuente de LaTeX
  font: "New Computer Modern",
  size: 11pt,
  lang: "es",
  region: "es",
  hyphenate: true, // Activa la partición de palabras (silabeo)
)

// Justificar el texto (típico de LaTeX)
#set par(
  justify: true,
  leading: 0.65em, // Espacio entre líneas
  first-line-indent: 1.5em, // Indentación de la primera línea
)

// Regla para que el primer párrafo tras un título SÍ tenga sangría
// (En LaTeX estándar el primero no tiene, pero muchos lo prefieren así)

#show heading: it => {
  it
  par(text(size: 0pt, ""))
}

// Configuración de encabezados
#set heading(numbering: "1.1")
#show heading: set block(above: 1.4em, below: 1em)

// --- PORTADA ---
#align(center)[
  #v(1cm)
  #image("logo.jpg", width: 60%)
  #v(3cm)

  #block(text(weight: "bold", 2.5em)[Práctica 5])
  #v(0.5em)
  #block(text(weight: "bold", 1.8em)[Casos de uso])
  #v(1cm)
  #block(text(weight: "bold", 1.5em)[Pablo Linari Pérez])

  #v(3cm)

  #text(size: 1.2em)[
    #underline[DNI:] 75571079W \
    #underline[Curso]: 25/26 \
    #underline[Correo]: #link("mailto:pablolinari@correo.ugr.es")[pablolinari\@correo.ugr.es]
  ]
  #v(1fr)
]

#pagebreak()

// --- ÍNDICE ---
#outline(
  title: [Índice de contenidos],
  indent: auto,
)

#pagebreak()

= Casos de uso

A continuación se recogen, en formato tabla, varios casos de uso ejecutados sobre
los sistemas basados en conocimiento desarrollados. Cada caso muestra las entradas
proporcionadas por el usuario y la salida producida por el sistema.

== Deducibilidad de intereses de préstamos (`prestamo.clp`)

Sistema de *lógica por defecto*. Por defecto los préstamos son deducibles; los
préstamos personales son la excepción (no deducibles), salvo que se empleen para
vivienda. Cuando falta información se aplica el default correspondiente.

#block[
  #set text(size: 9.5pt)
  #table(
    columns: (auto, auto, auto, auto, 1fr),
    align: (center, center, center, center, left),
    inset: 6pt,
    table.header(
      [*Préstamo*], [*Tipo*], [*Destino*], [*Resultado*], [*Explicación*],
    ),
    [p1], [personal], [vivienda], [Deducible],
      [Préstamo personal para vivienda: deducible.],
    [p2], [personal], [coche], [No deducible],
      [Préstamo personal no destinado a vivienda.],
    [p3], [hipotecario], [vivienda], [Deducible],
      [Préstamo no personal: deducible.],
    [p4], [comercial], [negocio], [Deducible],
      [Préstamo no personal: deducible.],
    [p5], [personal], [desconocido], [No deducible],
      [Personal sin constancia de uso para vivienda: por defecto no deducible.],
    [nuevo], [desconocido], [vivienda], [Deducible],
      [No consta que sea personal: por defecto los préstamos son deducibles.],
    [nuevo], [personal], [desconocido], [No deducible],
      [Personal sin constancia de uso para vivienda: por defecto no deducible.],
  )
]

== Recomendación de tipo de coche (`coche.clp`)

Sistema de *factores de certeza*. Se combinan las recomendaciones de cada regla
mediante la fórmula de combinación de FC (MYCIN) y se muestra la opción con mayor
factor de certeza.

#block[
  #set text(size: 9pt)
  #table(
    columns: 9,
    align: center,
    inset: 5pt,
    table.header(
      [*Presup.*], [*\<20k km*], [*Tray. largos*], [*Remolque*],
      [*Ciudad*], [*ZBE*], [*Etiq. 0*], [*Recomendación*], [*FC*],
    ),
    [alto], [no], [no], [no], [sí], [no], [sí], [eléctrico], [0,95],
    [bajo], [sí], [sí], [sí], [no], [sí], [no], [híbrido auto-rec.], [0,71],
    [medio], [no], [no], [sí], [no], [no], [no], [diésel], [0,50],
    [bajo], [sí], [no], [no], [no], [no], [no], [gasolina], [0,88],
  )
]

== Estimación del riesgo de infarto (`infarto.clp`)

Sistema *difuso* (Mamdani simplificado). A partir del IMC, la edad y el colesterol
se estima el riesgo de infarto en una escala de 0 a 10.

#block[
  #set text(size: 9.5pt)
  #table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    inset: 6pt,
    table.header(
      [*IMC*], [*Edad*], [*Colesterol*], [*Riesgo*], [*Escala (0–10)*],
    ),
    [22], [25], [150], [Bajo], [0,0],
    [28], [70], [150], [Medio], [3,86],
    [40], [30], [150], [Muy Alto], [8,0],
    [24], [50], [300], [Muy Alto], [8,0],
    [24], [50], [220], [Alto], [5,0],
  )
]

= Razonamiento probabilístico: ¿le gustaría comer pasta? (`pasta.clp`)

Sistema de *razonamiento bayesiano*. Partiendo de la probabilidad a priori
$P("ComerPasta") = 0,668$, se actualiza con las causas conocidas (edad y si comió
pasta ayer) y, mediante el teorema de Bayes, con las evidencias o efectos
(restaurantes italianos y frecuencia de consumo). A continuación se responden los
tres casos planteados.

#block[
  #set text(size: 9.5pt)
  #table(
    columns: (auto, auto, auto, auto, auto),
    align: (center, center, center, center, center),
    inset: 6pt,
    table.header(
      [*Edad*], [*Comió ayer*], [*Rest. italianos*], [*Frecuencia*],
      [*P(le gusta la pasta)*],
    ),
    [Joven], [No], [Sí], [Esporádicamente], [0,7215 (72,15 %)],
    [Mayor], [Sí], [Sí], [Frecuentemente], [0,7328 (73,28 %)],
    [Desconocida], [No], [Sí], [Frecuentemente], [0,9414 (94,14 %)],
  )
]

- *Es joven, no comió pasta ayer, le gustan los restaurantes italianos y come pasta
  esporádicamente.* Con ambas causas conocidas la probabilidad sube a $0,85$; tras
  incorporar las evidencias (le gustan los restaurantes italianos, pero come pasta
  solo esporádicamente, lo que la rebaja) la probabilidad final es
  *$0,7215$ (72,15 %)*.

- *Es mayor, comió pasta ayer, le gustan los restaurantes italianos y come pasta
  frecuentemente.* Las causas (mayor y haber comido ayer) bajan la probabilidad a
  $0,30$, pero las evidencias positivas (restaurantes italianos y consumo frecuente)
  la elevan hasta *$0,7328$ (73,28 %)*.

- *No sabemos la edad, no comió pasta ayer, le gustan los restaurantes italianos y
  come pasta frecuentemente.* Al desconocerse la edad solo influye la causa "no comió
  ayer" ($0,715$); con las evidencias positivas la probabilidad final asciende a
  *$0,9414$ (94,14 %)*.
