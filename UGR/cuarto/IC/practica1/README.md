# Sistema experto de recetas en CLIPS

Este proyecto implementa un sistema experto para recomendar recetas a partir de reglas sobre ingredientes y propiedades nutricionales.

Archivo principal: `SE_simple_recetas.clp`.

## 1) Por que es un sistema experto

No se limita a filtrar entradas del usuario. Primero infiere conocimiento nuevo y luego decide:

- deduce tipo de plato cuando falta,
- clasifica recetas (vegana, vegetariana, sin gluten, sin lactosa, calorias, proteinas),
- usa esas inferencias para filtrar y justificar recomendaciones.

## 2) Estructura modular

El flujo se organiza en modulos:

1. Deducir propiedades de recetas (base de conocimiento).
2. Pedir informacion al usuario.
3. Proponer tipo de receta (preferencia).
4. Obtener recetas compatibles.
5. Proponer receta y permitir reajustes.

Fases de control:

- `(fase preguntar)`
- `(fase elegir)`
- `(fase resultados)`

## 3) Elementos CLIPS usados

- `deftemplate` para hechos estructurados.
- hechos ordenados implicitos para respuestas simples (por ejemplo `respuesta-dieta`).
- `deffacts` para estado inicial.
- `defrule` para reglas de inferencia y control.
- `deffunction` para reutilizar logica.
- `assert`, `retract`, `modify` para gestionar hechos.
- `any-factp`, `do-for-all-facts` para consultas/iteraciones.
- `salience` para controlar orden de disparo.

## 4) Plantillas y hechos clave

Base:

- `receta`
- `ingrediente`

Motor interactivo:

- `RecetaCandidata`
- `RecetaAdecuada`
- `RecetaOfertada`
- `RecetaRechazada`
- `respuesta-sin-lactosa` y `respuesta-sin-gluten` (con slot `valor`)

Hechos inferidos (ordenados):

- `(propiedad_receta es_vegana ?r)`
- `(propiedad_receta es_vegetariana ?r)`
- `(propiedad_receta contiene_gluten ?r)`
- `(propiedad_receta contiene_lactosa ?r)`
- `(propiedad_receta calorias baja|media|alta ?r)`
- `(propiedad_receta proteinas baja|media|alta ?r)`

## 5) Funciones importantes

Inferencia textual/nutricional:

- `contiene`, `es-condimento`, `es-importante`, `es-dulce`
- `obtener-kcal`, `extraer-numero-gramos`, `obtener-proteinas`

Validacion de respuestas:

- `normalizar-respuesta`
- `dieta-valida`, `si-no-valido`, `tipo-valido`
- `alta-media-baja-valida`, `densidad-calorica-valida`, `proteina-valida`
- `numero-o-control`

Soporte de motor:

- `limpiar-evaluacion`, `crear-candidatas-iniciales`
- `tiene-prop2`, `tiene-prop3` (helpers para consultar `propiedad_receta`)
- `receta-cumple-base` (compatibilidad segun respuestas base)
- `valor-campo-receta`, `unico-campo-base` (detectar si una pregunta ya no aporta variabilidad)
- `obtener-dieta-receta` (texto de motivo)

## 6) Modulo 1: deduccion de propiedades

Incluye reglas para:

- ingredientes relevantes,
- tipo de plato por heuristica,
- dieta y restricciones (vegana/vegetariana/sin gluten/sin lactosa),
- calorias y proteinas (clasificacion `baja/media/alta`).

## 7) Modulo 2: preguntas y adaptacion

Preguntas principales:

- dieta,
- sin lactosa,
- sin gluten,
- ingrediente obligatorio,
- tipo,
- comensales,
- tiempo,
- proteina,
- densidad calorica.

Comportamiento adaptativo:

- si dieta = `vegana`, se omite la pregunta de sin lactosa y se fija a `si`.
- el sistema puede omitir preguntas (`tipo`, `proteina`, `calorias`, `comensales`, `tiempo`) cuando, con las restricciones ya dadas, **no reducen** el conjunto de recetas compatibles.
- `defaults-respuestas` rellena `ns` para cualquier respuesta ausente antes de filtrar.

## 8) Modulo 3 y 4: preferencia de tipo y filtrado

- `tipo` se aplica solo si no es `ns`.
- En `fase elegir`, se crean candidatas y se eliminan con reglas `filtrar-*` según cada restriccion.
- `registrar-adecuadas` guarda candidatas finales con motivo explicativo.

## 9) Modulo 5: propuesta y reajuste

- `mostrar-receta` ofrece una receta.
- Acciones: `a`, `rechazar`, o reajustar (`dieta|tipo|comensales|tiempo|proteina|calorias|ingrediente`).
- Si no hay recetas, `sin-recetas-adecuadas` permite modificar un parametro y reintentar.

Nota: internamente el sistema mantiene `respuesta-densidad-calorica`, pero para el usuario se muestra como `calorias` en menús de correccion.

## 10) Convencion de salience (estado actual)

- `1000-990`: arranque y seguridad de inicio.
- `950-900`: validaciones y finalizacion temprana.
- `850-836`: omision/adaptacion de preguntas.
- `800-792`: preguntas del cuestionario.
- `700`: inicio de evaluacion.
- `0` y `-50`: flujo normal de resultados.
- `-1000`: cierre.

## 11) Ejecucion

```clips
(load "SE_simple_recetas.clp")
(load "BDrecetas_100.clp")
(reset)
(run)
```
