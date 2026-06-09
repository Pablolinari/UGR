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

En esta primera parte se recogen *8 casos de uso* (4 por programa) de los
sistemas de producción implementados en CLIPS: `prestamo.clp` y `coche.clp`.
Cada programa se presenta en su propia sección, con una breve explicación de su
funcionamiento y una tabla de casos. Todas las salidas que se muestran han sido
obtenidas ejecutando directamente los programas sobre CLIPS 6.4.

== Deducibilidad de préstamos: `prestamo.clp`

`prestamo.clp` es un sistema de clasificación que decide si un préstamo es
*deducible* o *no deducible* en la declaración de la renta. Parte de una lista
de préstamos predefinidos (cada uno con un `tipo` y un `destino`) y permite
seleccionar uno existente o dar de alta uno nuevo respondiendo a las preguntas
de si es personal y si se destina a vivienda. La base de conocimiento aplica
cinco reglas:

- *R1.* Préstamo personal destinado a vivienda #sym.arrow.r deducible.
- *R2.* Préstamo personal con destino conocido distinto de vivienda #sym.arrow.r no deducible.
- *R3.* Préstamo no personal (hipotecario, comercial, ...) #sym.arrow.r deducible.
- *R4.* Tipo desconocido #sym.arrow.r por defecto deducible.
- *R5.* Personal sin constancia del destino #sym.arrow.r por defecto no deducible.

#figure(
  table(
    columns: (auto, 1fr, auto, 1.3fr),
    align: (center, left, center, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header(
      [*\#*], [*Entradas relevantes*], [*Resultado*], [*Justificación*],
    ),
    [1], [`p1`: personal, vivienda],
      [Deducible], [Personal para vivienda (R1)],
    [2], [`p3`: hipotecario, vivienda],
      [Deducible], [Préstamo no personal (R3)],
    [3], [`p4`: comercial, negocio],
      [Deducible], [Préstamo no personal (R3)],
    [4], [`p2`: personal, coche],
      [No deducible], [Personal con destino #sym.eq.not vivienda (R2)],
    [5], [`p5`: personal, destino desconocido],
      [No deducible], [Personal sin constancia de vivienda: por defecto no deducible (R5)],
    [6], [nuevo `p9`: personal sí, vivienda sí],
      [Deducible], [Alta de préstamo personal para vivienda (R1)],
    [7], [nuevo `p11`: personal sí, vivienda no],
      [No deducible], [Alta de préstamo personal con destino #sym.eq.not vivienda (R2)],
    [8], [`p77` (id inexistente): tipo y destino desconocidos],
      [Deducible], [No consta que sea personal: por defecto deducible (R4)],
  ),
  caption: [Casos de uso de `prestamo.clp`.],
)

== Recomendación de motorización: `coche.clp`

`coche.clp` es un sistema de recomendación basado en *factores de certeza
(CF)*. Realiza siete preguntas (presupuesto, kilometraje anual, trayectos
largos, remolque pesado, uso urbano, viajes a Zonas de Bajas Emisiones y
beneficios por etiqueta Cero) y, según el contexto, dispara reglas que aportan
evidencia a favor o en contra de cada tipo de motorización. Cuando varias
reglas apoyan el mismo tipo, sus CF se combinan mediante la fórmula clásica
de MYCIN:

$ "CF"_("comb") = "CF"_1 + "CF"_2 dot (1 - "CF"_1) quad ("ambos" >= 0). $

Finalmente se recomienda la motorización con mayor factor de certeza.

#figure(
  table(
    columns: (auto, 1fr, auto, 1.3fr),
    align: (center, left, center, left),
    inset: 6pt,
    stroke: 0.5pt,
    table.header(
      [*\#*], [*Entradas relevantes*], [*Resultado*], [*Justificación*],
    ),
    [1], [presupuesto medio, \<20000 km sí, resto no],
      [Híbrido auto-rec. \ (CF = 0.8)], [Pocos km favorecen el híbrido auto-recargable (0.8) frente a gasolina (0.6)],
    [2], [presupuesto medio, uso en ciudad sí, resto no],
      [Eléctrico \ (CF = 0.8)], [El uso urbano favorece el eléctrico],
    [3], [presupuesto alto, trayectos largos sí, resto no],
      [Híbrido \ (CF = 0.6)], [Los trayectos largos penalizan el eléctrico ($0.7 #sym.plus.o (-0.9) approx -0.67$) y gana el híbrido del presupuesto alto],
    [4], [presupuesto bajo, resto no],
      [Gasolina \ (CF = 0.7)], [Presupuesto bajo: gasolina (0.7) supera al gas (0.6)],
    [5], [presupuesto medio, remolque pesado sí, resto no],
      [Diésel \ (CF = 0.5)], [El remolque pesado exige par y robustez],
    [6], [presupuesto medio, \<20000 km sí, ciudad sí, etiqueta Cero sí],
      [Eléctrico \ (CF = 0.84)], [Combina uso urbano (0.8) #sym.plus.o etiqueta Cero (0.2): $0.8 + 0.2 dot 0.2 = 0.84$],
    [7], [presupuesto alto, etiqueta Cero sí, resto no],
      [Eléctrico \ (CF = 0.76)], [Presupuesto alto (0.7) #sym.plus.o etiqueta Cero (0.2): $0.7 + 0.2 dot 0.3 = 0.76$],
    [8], [presupuesto bajo, trayectos largos sí, remolque sí],
      [Gasolina \ (CF = 0.7)], [El presupuesto bajo prima el coste y supera al diésel del remolque (0.5)],
  ),
  caption: [Casos de uso de `coche.clp`.],
)

#pagebreak()

= Razonamiento bayesiano: `pasta.clp`

El programa `pasta.clp` implementa una *red causal* para estimar la
probabilidad de que a una persona le gustaría comer pasta hoy. La variable a
inferir es:

- *CP* = _comer pasta hoy_, con valores ${"SÍ", "NO"}$.

Sobre ella actúan dos *causas* (variables que influyen _a priori_) y dos
*efectos* o indicios (variables que se observan para actualizar la creencia):

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  stroke: 0.5pt,
  align: (left, left),
  [*Causas*], [*E* = edad ${"joven", "mediana", "mayor"}$ \ *C* = comió pasta ayer ${"sí", "no"}$],
  [*Efectos*], [*G* = le gustan los restaurantes italianos ${"sí", "no"}$ \ *F* = frecuencia con que come pasta ${"esporádicamente", "frecuentemente", "habitualmente"}$],
)

El razonamiento se realiza en dos fases. Primero, a partir de las causas
conocidas se obtiene la probabilidad _a priori_ (ajustada) de $P("CP"="SÍ")$.
Después, cada efecto observado se utiliza para actualizar esa probabilidad
mediante el *teorema de Bayes*.

== Pregunta 1: distribuciones de probabilidad necesarias

Para llevar a cabo el razonamiento son necesarias las siguientes
distribuciones de probabilidad, que se supone se obtienen y actualizan de un
banco de datos estadísticos. Se asignan los siguientes valores subjetivos
(los mismos que figuran en `pasta.clp`):

*(a) Distribución _a priori_ de las causas, $P(E)$ y $P(C)$:*

#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 6pt,
  stroke: 0.5pt,
  align: center,
  table.header([$P(E="joven")$], [$P(E="mediana")$], [$P(E="mayor")$], [$P(C="sí")$], [$P(C="no")$]),
  [0.4], [0.3], [0.3], [0.2], [0.8],
)

*(b) Distribución condicional de la variable a inferir dadas las causas,
$P("CP"="SÍ" | E, C)$* (la de $"NO"$ es su complementario):

#table(
  columns: (auto, auto, auto),
  inset: 6pt,
  stroke: 0.5pt,
  align: center,
  table.header([*Edad (E)*], [*Comió ayer (C)*], [$P("CP"="SÍ" | E, C)$]),
  [joven],   [sí], [0.60],
  [joven],   [no], [0.85],
  [mediana], [sí], [0.50],
  [mediana], [no], [0.70],
  [mayor],   [sí], [0.30],
  [mayor],   [no], [0.55],
)

*(c) Distribución condicional de los efectos dada la variable a inferir,
$P(G | "CP")$ y $P(F | "CP")$:*

#table(
  columns: (auto, auto, auto),
  inset: 6pt,
  stroke: 0.5pt,
  align: center,
  table.header([*Efecto*], [$dot | "CP"="SÍ"$], [$dot | "CP"="NO"$]),
  [$P(G="sí")$], [0.80], [0.25],
  [$P(G="no")$], [0.20], [0.75],
  [$P(F="esporádicamente")$], [0.10], [0.70],
  [$P(F="frecuentemente")$],  [0.40], [0.20],
  [$P(F="habitualmente")$],   [0.50], [0.10],
)

A partir de (a) y (b), el sistema deduce la probabilidad _a priori_ marginal
combinando todas las situaciones de las causas:

$ P("CP"="SÍ") = sum_(E,C) P("CP"="SÍ" | E, C) dot P(E) dot P(C) = 0.668. $

Esta es la creencia inicial antes de observar ningún dato de la persona.

== Pregunta 2

#emph[¿Probabilidad de que le gustaría comer pasta si es _joven_, _no_ comió
pasta ayer, le gustan los restaurantes italianos ($G="sí"$) y come pasta
_esporádicamente_?]

Se conocen *las dos causas*, luego la probabilidad ajustada por las causas es
directamente la de la tabla (b):

$ P("CP"="SÍ" | E="joven", C="no") = 0.85, quad P("CP"="NO" | dots) = 0.15. $

Ahora se incorporan los dos efectos observados ($G="sí"$, $F="esporádicamente"$)
mediante Bayes. Las verosimilitudes de cada hipótesis son:

$ P(G="sí", F="esp" | "CP"="SÍ") = 0.80 dot 0.10 = 0.08, $
$ P(G="sí", F="esp" | "CP"="NO") = 0.25 dot 0.70 = 0.175. $

Aplicando el teorema de Bayes (los factores comunes $P(E)P(C)$ se cancelan en
la normalización):

$ P("CP"="SÍ" | "evidencia") = (0.85 dot 0.08) / (0.85 dot 0.08 + 0.15 dot 0.175) = 0.068 / 0.09425 approx bold(0.7215). $

*La probabilidad de que le gustaría comer pasta es $approx 0.7215$ (72.15 %).*

== Pregunta 3

#emph[¿Probabilidad de que _no_ le gustaría comer pasta si es _mayor_, _sí_
comió pasta ayer, le gustan los restaurantes italianos ($G="sí"$) y come pasta
_frecuentemente_?]

De nuevo se conocen las dos causas:

$ P("CP"="SÍ" | E="mayor", C="sí") = 0.30, quad P("CP"="NO" | dots) = 0.70. $

Verosimilitudes con $G="sí"$ y $F="frecuentemente"$:

$ P(dot | "CP"="SÍ") = 0.80 dot 0.40 = 0.32, quad P(dot | "CP"="NO") = 0.25 dot 0.20 = 0.05. $

Teorema de Bayes para la hipótesis $"SÍ"$:

$ P("CP"="SÍ" | "evidencia") = (0.30 dot 0.32) / (0.30 dot 0.32 + 0.70 dot 0.05) = 0.096 / 0.131 approx 0.7328. $

Como nos preguntan por el caso contrario:

$ P("CP"="NO" | "evidencia") = 1 - 0.7328 = (0.70 dot 0.05) / 0.131 approx bold(0.2672). $

*La probabilidad de que NO le gustaría comer pasta es $approx 0.2672$
(26.72 %).*

== Pregunta 4

#emph[¿Probabilidad de que le gustaría comer pasta si _no se conoce su edad_,
_no_ comió pasta ayer, le gustan los restaurantes italianos ($G="sí"$) y come
pasta _frecuentemente_?]

Ahora solo se conoce *una causa* ($C="no"$); la edad es desconocida. El sistema
*marginaliza* sobre la edad para obtener la probabilidad ajustada:

$ P("CP"="SÍ" | C="no") = sum_E P("CP"="SÍ" | E, C="no") dot P(E) $
$ = 0.85 dot 0.4 + 0.70 dot 0.3 + 0.55 dot 0.3 = 0.34 + 0.21 + 0.165 = 0.715. $

Por tanto $P("CP"="NO" | C="no") = 0.285$. Verosimilitudes con $G="sí"$ y
$F="frecuentemente"$ (iguales que en la pregunta 3): $0.32$ para $"SÍ"$ y
$0.05$ para $"NO"$. Aplicando Bayes:

$ P("CP"="SÍ" | "evidencia") = (0.715 dot 0.32) / (0.715 dot 0.32 + 0.285 dot 0.05) = 0.2288 / 0.24305 approx bold(0.9414). $

*La probabilidad de que le gustaría comer pasta es $approx 0.9414$ (94.14 %).*

Obsérvese que, al no penalizar la edad avanzada y proceder de una persona que
no comió pasta ayer, los dos indicios fuertemente a favor (le gustan los
restaurantes italianos y come pasta con frecuencia) elevan notablemente la
creencia respecto a la inicial de $0.668$.
