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

  #block(text(weight: "bold", 2.5em)[Práctica 4])
  #v(0.5em)
  #block(text(weight: "bold", 1.8em)[Ontologías])
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

= Inferencias del razonador

Esta ontología (`nutricion.owl`) modela un centro de nutrición con las clases
*Cliente*, *Receta*, *Ingrediente*, *TipoPlato*, *Dieta* y *Alergeno*. Se ha
ejecutado el razonador #emph[HermiT], que confirma que la ontología es
#strong[consistente]. A continuación se recogen tres ejemplos de hechos
deducidos por el razonador (ninguno aparece asertado de forma explícita) junto
con su explicación.

== Valor de propiedad deducido

#block(fill: luma(240), inset: 10pt, radius: 4pt, width: 100%)[
  *Hecho inferido:* `Quinoa esIngredienteDe EnsaladaDeQuinoa`
]

En la ontología se declara la propiedad de objeto `esIngredienteDe` como
#emph[inversa] de `tieneIngrediente`:

```
esIngredienteDe  owl:inverseOf  tieneIngrediente
```

Sobre el individuo `EnsaladaDeQuinoa` solo se aserta el hecho directo
`EnsaladaDeQuinoa tieneIngrediente Quinoa`. Aplicando la semántica de
`owl:inverseOf` (si un individuo $a$ se relaciona con $b$ mediante una propiedad
$P$, entonces $b$ se relaciona con $a$ mediante su inversa $P^(-1)$), el
razonador deduce automáticamente el valor recíproco:

```
Quinoa  esIngredienteDe  EnsaladaDeQuinoa
```

Este valor no se ha introducido manualmente —se respeta el criterio de asertar
solo los valores no deducibles—: lo genera el razonador al sincronizar.

== Axioma de clase deducido (clasificación de un individuo)

#block(fill: luma(240), inset: 10pt, radius: 4pt, width: 100%)[
  *Hecho inferido:* `Ana rdf:type ClienteVegano`
]

`ClienteVegano` es una #emph[clase definida] (no primitiva), declarada como
equivalente a la intersección de `Cliente` con los individuos cuya dieta es
`Vegana`:

```
ClienteVegano  ≡  Cliente  ⊓  (sigueDieta value Vegana)
```

Del individuo `Ana` solo se asertan los hechos `Ana rdf:type Cliente` y
`Ana sigueDieta Vegana`; en ningún momento se declara que sea `ClienteVegano`.
Como `Ana` satisface las dos condiciones necesarias y suficientes de la
definición (es un `Cliente` y su valor de `sigueDieta` es exactamente `Vegana`),
el razonador deduce el nuevo axioma de tipo:

```
Ana  rdf:type  ClienteVegano
```

Es decir, #emph[clasifica] el individuo dentro de la clase definida. De forma
análoga, el razonador deduce `PechugaPollo rdf:type IngredienteProteico`, ya que
su valor de `proteinas` es $31.0 >= 20.0$, lo que satisface la definición de
`IngredienteProteico`.

== Relación de jerarquía deducida

#block(fill: luma(240), inset: 10pt, radius: 4pt, width: 100%)[
  *Hecho inferido:* `RecetaVegana ⊑ Receta` (RecetaVegana es subclase de Receta)
]

La clase `RecetaVegana` se ha definido #emph[únicamente] mediante una
equivalencia, sin declarar explícitamente ninguna relación `rdfs:subClassOf`:

```
RecetaVegana  ≡  Receta  ⊓  (aptaParaDieta value Vegana)
```

A partir de esta definición, el razonador deduce que toda instancia de
`RecetaVegana` es necesariamente una instancia de `Receta` (la intersección es
un subconjunto de cada uno de sus operandos) e infiere la relación de jerarquía:

```
RecetaVegana  rdfs:subClassOf  Receta
```

Esta arista no estaba asertada: antes de razonar, `RecetaVegana` colgaba
directamente de `owl:Thing` en la jerarquía. Tras la clasificación, el razonador
la reubica como subclase de `Receta`. El mismo mecanismo coloca `ClienteVegano`
bajo `Cliente`, `IngredienteProteico` bajo `Ingrediente`, y `RecetaPostre`,
`RecetaRapida` y `RecetaPopular` bajo `Receta`.
