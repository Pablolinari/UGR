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

= Casos de uso de los sistemas basados en reglas

En esta primera parte se recogen 8 casos de uso por programa de los
sistemas implementados en CLIPS: `prestamo.clp` , `coche.clp` e `infarto.clp`.
Cada programa se presenta en su propia sección, con una breve explicación de su
funcionamiento y una tabla de casos. Todas las salidas que se muestran han sido
obtenidas ejecutando directamente los programas sobre CLIPS.

== Deducibilidad de préstamos: `prestamo.clp`

`prestamo.clp` es un sistema de clasificación que decide si un préstamo es
*deducible* o *no deducible* en la declaración de la renta. Parte de una lista
de préstamos predefinidos (cada uno con un `tipo` y un `destino`) y permite
seleccionar uno existente o dar de alta uno nuevo respondiendo a las preguntas
de si es personal y si se destina a vivienda.
#figure(
  table(
    columns: (auto, 1fr, auto, 1.3fr),
    align: (center, left, center, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header([*\#*], [*Entradas*], [*Resultado*], [*Justificación*]),
    [1], [`p1`: personal, vivienda], [Deducible], [Personal para vivienda],
    [2], [`p3`: hipotecario, vivienda], [Deducible], [Préstamo no personal],
    [3], [`p4`: comercial, negocio], [Deducible], [Préstamo no personal],
    [4],
    [`p2`: personal, coche],
    [No deducible],
    [Personal con destino #sym.eq.not vivienda],

    [5],
    [`p5`: personal, destino desconocido],
    [No deducible],
    [Personal sin constancia de vivienda: por defecto no deducible ],

    [6],
    [nuevo `p6`: personal sí, vivienda sí],
    [Deducible],
    [Alta de préstamo personal para vivienda ],

    [7],
    [nuevo `p7`: personal sí, vivienda no],
    [No deducible],
    [Alta de préstamo personal con destino #sym.eq.not vivienda ],

    [8],
    [`p8` (id inexistente): tipo y destino desconocidos],
    [Deducible],
    [No consta que sea personal: por defecto deducible ],
  ),
  caption: [Casos de uso de `prestamo.clp`.],
)

== Recomendación de motorización: `coche.clp`

`coche.clp` es un sistema de recomendación basado en *factores de certeza
(CF)*. Realiza siete preguntas (presupuesto, kilometraje anual, trayectos
largos, remolque pesado, uso urbano, viajes a Zonas de Bajas Emisiones y
beneficios por etiqueta Cero) y, según el contexto, dispara reglas que aportan
evidencia a favor o en contra de cada tipo de motorización. Finalmente se recomienda la motorización con mayor factor de certeza.

#figure(
  table(
    columns: (auto, 1fr, auto, 1.3fr),
    align: (center, left, center, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header(
      [*\#*], [*Entradas relevantes*], [*Resultado*], [*Justificación*]
    ),
    [1],
    [presupuesto medio, \<20000 km sí, resto no],
    [Híbrido auto-rec. \ (CF = 0.8)],
    [Pocos km favorecen el híbrido auto-recargable (0.8) frente a gasolina (0.6)],

    [2],
    [presupuesto medio, uso en ciudad sí, resto no],
    [Eléctrico \ (CF = 0.8)],
    [El uso urbano favorece el eléctrico],

    [3],
    [presupuesto alto, trayectos largos sí, resto no],
    [Híbrido \ (CF = 0.6)],
    [Los trayectos largos penalizan el eléctrico ($0.7 #sym.plus.o (-0.9) approx -0.67$) y gana el híbrido del presupuesto alto],

    [4],
    [presupuesto bajo, resto no],
    [Gasolina \ (CF = 0.7)],
    [Presupuesto bajo: gasolina (0.7) supera al gas (0.6)],

    [5],
    [presupuesto medio, remolque pesado sí, resto no],
    [Diésel \ (CF = 0.5)],
    [El remolque pesado exige par y robustez],

    [6],
    [presupuesto medio, \<20000 km sí, ciudad sí, etiqueta Cero sí],
    [Eléctrico \ (CF = 0.84)],
    [Combina uso urbano (0.8) #sym.plus.o etiqueta Cero (0.2): $0.8 + 0.2 dot 0.2 = 0.84$],

    [7],
    [presupuesto alto, etiqueta Cero sí, resto no],
    [Eléctrico \ (CF = 0.76)],
    [Presupuesto alto (0.7) #sym.plus.o etiqueta Cero (0.2): $0.7 + 0.2 dot 0.3 = 0.76$],

    [8],
    [presupuesto bajo, trayectos largos sí, remolque sí],
    [Gasolina \ (CF = 0.7)],
    [El presupuesto bajo prima el coste y supera al diésel del remolque (0.5)],
  ),
  caption: [Casos de uso de `coche.clp`.],
)

#pagebreak()

= Sistema experto difuso: `infarto.clp`

`infarto.clp` estima el *riesgo de infarto* de un paciente mediante un sistema
experto *difuso* . A partir de tres variables de
entrada (índice de masa corporal *IMC*, *edad* y *colesterol*), el sistema determina la probabilidad de sufrir un infarto

Cada entrada se evalúa sobre funciones de pertenencia
(triangulares y trapezoidales) que definen los conjuntos:
IMC ${"normal", "elevado", "muy elevado"}$, edad
${"joven", "media", "avanzada"}$ y colesterol
${"normal", "alto", "muy alto"}$. Los valores concretos de cada conjunto
(triangular $[a, b, c]$ y trapezoidal $[a, b, c, d]$) son:

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt,
  stroke: 0.5pt,
  align: (left, left, left),
  table.header([*Variable*], [*Conjunto*], [*Función de pertenencia*]),
  table.cell(rowspan: 3)[*IMC*], [normal],      [triangular $[16, 21, 25]$],
                                 [elevado],     [triangular $[23, 27.5, 32]$],
                                 [muy elevado], [trapezoidal $[30, 35, 50, 50]$],
  table.cell(rowspan: 3)[*Edad* \ (años)], [joven],    [trapezoidal $[0, 10, 20, 30]$],
                                 [media],       [triangular $[20, 50, 70]$],
                                 [avanzada],    [trapezoidal $[60, 75, 100, 100]$],
  table.cell(rowspan: 3)[*Colesterol* \ (mg/dL)], [normal], [trapezoidal $[100, 150, 190, 210]$],
                                 [alto],        [triangular $[190, 220, 250]$],
                                 [muy alto],    [trapezoidal $[240, 270, 400, 400]$],
)

La salida (riesgo) se define de 0 a 100  mediante
tres conjuntos gaussianos de spread 20 y media la indicada en la tabla.

#table(
  columns: (auto, auto, auto, auto),
  inset: 6pt,
  stroke: 0.5pt,
  align: (left, center, center, center),
  table.header([*Riesgo*], [*Conjunto de salida*], [*Centro*], [*Rango (escala 0-10)*]),
  [Bajo],     [#sym.dash (ninguna regla)],     [0],  [$0.0 - 2.5$ #sym.space.quad ($<25$)],
  [Medio],    [gaussiana (media 30)],          [30], [$2.5 - 4.5$ #sym.space.quad ($<45$)],
  [Alto],     [gaussiana (media 50)],          [50], [$4.5 - 6.5$ #sym.space.quad ($<65$)],
  [Muy Alto], [gaussiana (media 80)],          [80], [$6.5 - 10.0$ #sym.space.quad ($>= 65$)],
)


#figure(
  table(
    columns: (auto, auto, 1.6fr, auto),
    align: (center, center, left, center),
    inset: 6pt,
    stroke: 0.5pt,
    table.header(
      [*\#*],
      [*IMC / edad / col.*],
      [*Reglas activadas (grado)*],
      [*Riesgo (escala)*],
    ),
    [1], [22 / 25 / 180], [Ninguna], [Bajo \ (0.0 / 10)],
    [2], [40 / 50 / 180], [ Muy Alto (1.0)], [Muy Alto \ (8.0 / 10)],
    [3], [22 / 30 / 300], [ Muy Alto (1.0)], [Muy Alto \ (8.0 / 10)],
    [4],
    [28 / 80 / 200],
    [R3 Alto (0.89),  Alto (0.33),  Medio (0.5)],
    [Medio \ (4.42 / 10)],

    [5], [22 / 40 / 220], [ Alto (1.0)], [Alto \ (5.0 / 10)],
    [6], [28 / 40 / 170], [ Medio (0.89)], [Medio \ (3.0 / 10)],
    [7], [28 / 80 / 230], [ Alto (0.89),  Alto (0.67)], [Alto \ (5.0 / 10)],
    [8],
    [45 / 80 / 320],
    [ Muy Alto (1.0),Muy Alto (1.0)],
    [Muy Alto \ (8.0 / 10)],
  ),
  caption: [Casos de uso de `infarto.clp`.],
)


#pagebreak()

= Razonamiento bayesiano: `pasta.clp`

El programa `pasta.clp` implementa un sistema para estimar la
probabilidad de que a una persona le gustaría comer pasta hoy. La variable a
inferir es:

- *CP* = _comer pasta hoy_, con valores ${"SÍ", "NO"}$.

Sobre ella actúan dos causas y dos
efectos:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  stroke: 0.5pt,
  align: (left, left),
  [*Causas*],
  [*E* = edad ${"joven", "mediana", "mayor"}$ \ *C* = comió pasta ayer ${"sí", "no"}$],

  [*Efectos*],
  [*G* = le gustan los restaurantes italianos ${"sí", "no"}$ \ *F* = frecuencia con que come pasta ${"esporádicamente", "frecuentemente", "habitualmente"}$],
)

A continuación respondo las preguntas que se hacen en la práctica.Como la 1 trata de la definición de las distribuciones y esto ya se ha hecho en el programa , salto directamente a la 2.

== Pregunta 2

#emph[¿Probabilidad de que le gustaría comer pasta si es _joven_, _no_ comió
  pasta ayer, le gustan los restaurantes italianos  y come pasta
  _esporádicamente_?]

Si ejecutamos el programa con la entrada que nos dá la pregunta nos sale que: 

*La probabilidad de que le gustaría comer pasta es $approx 0.7215$ (72.15 %).*

== Pregunta 3

#emph[¿Probabilidad de que _no_ le gustaría comer pasta si es mayor, sí
  comió pasta ayer, le gustan los restaurantes italianos  y come pasta
  _frecuentemente_?]


  Como nos preguntan por el caso contrario calculamos la probabilidad de que si le guste y calculamos el complementario.


*La probabilidad de que NO le gustaría comer pasta es $approx 1-0.886 = 0,114$
(11.4 %).*

== Pregunta 4

#emph[¿Probabilidad de que le gustaría comer pasta si _no se conoce su edad_,
  _no_ comió pasta ayer, le gustan los restaurantes italianos  y come
  pasta _frecuentemente_?]

Si ejecutamos el programa con la entrada que nos dá la pregunta nos sale que: 

*La probabilidad de que le gustaría comer pasta es $approx 0.941$ (94.1 %).*


== Pregunta 5

#emph[A la persona anterior (la de la pregunta 4) se le pregunta si su
  necesidad energética es alta y responde que _sí_. Sabiendo que
  $P("N"="alta" | "CP"="SÍ") = 0.7$ y
  $P("N"="no alta" | "CP"="NO") = 0.8$, ¿cuál es ahora la probabilidad de que
  le gustaría comer pasta?]

Se incorpora un *nuevo efecto* $N$ = _necesidad energética alta_. La creencia
de partida es la probabilidad obtenida en la pregunta 4, que
ahora actúa como nueva probabilidad _a priori_:

$ P("CP"="SÍ") = 0.9414, quad P("CP"="NO") = 1 - 0.9414 = 0.0586. $


$ P("N"="alta" | "CP"="SÍ") = 0.7, quad P("N"="alta" | "CP"="NO") = 1 - 0.8 = 0.2. $

Como el efecto $N$ es condicionalmente independiente de los demás dado $"CP"$,
basta con actualizar la creencia anterior mediante el teorema de Bayes:

$
  P("CP"="SÍ" | "N"="alta") = (0.7 dot 0.9414) / (0.7 dot 0.9414 + 0.2 dot 0.0586) = 0.65898 / 0.67071 approx bold(0.9825).
$

La probabilidad de que le gustaría comer pasta sube a $approx 0.9825$
(98.25 %).
