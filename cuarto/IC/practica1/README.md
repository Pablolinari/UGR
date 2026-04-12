# Sistema experto de recetas en CLIPS

Este proyecto implementa un **sistema experto** (no un simple formulario) para recomendar recetas a partir de:

- conocimiento culinario/nutricional codificado en reglas,
- deduccion de propiedades que no vienen explicitas,
- restricciones y preferencias del usuario,
- dialogo iterativo con reajuste de criterios.

El codigo principal esta en `SE_simple_recetas.clp`.

---

## 1) Idea general y por que es un sistema experto

No solo filtra campos de entrada. Antes de preguntar al usuario, el sistema:

1. **Infiere hechos nuevos** (`propiedad_receta ...`) desde ingredientes y texto nutricional.
2. **Completa informacion faltante** (ej. tipo de plato desconocido).
3. **Clasifica semanticamente** (vegana/vegetariana, sin gluten/lactosa, digestion, calorias, proteinas).

Luego usa esas inferencias para filtrar/proponer. Ese encadenamiento de reglas + hechos derivados es la parte experta.

---

## 2) Estructura modular del archivo

El flujo esta organizado en 5 modulos:

1. **Pedir informacion** (preguntas y validacion).
2. **Deducir propiedades de recetas** (base de conocimiento).
3. **Proponer tipo de receta** (preferencia de tipo del usuario).
4. **Obtener recetas compatibles** (filtrado sobre hechos inferidos).
5. **Proponer receta** (aceptar/rechazar/reajustar).

Internamente se controla con el hecho de fase:

- `(fase preguntar)`
- `(fase elegir)`
- `(fase resultados)`

---

## 3) Fundamentos CLIPS usados

- **`deftemplate`**: define estructura de hechos (similar a un "registro").
- **hechos ordenados implicitos**: por ejemplo `respuesta-dieta` no tiene template explicito.
- **`deffacts`**: estado inicial (`arrancar` + lista de preguntas).
- **`defrule`**: reglas condicion -> accion.
- **`deffunction`**: funciones auxiliares reutilizables.
- **`salience`**: prioridad de disparo de reglas.
- **`assert / retract / modify`**: crear, borrar y actualizar hechos.
- **`any-factp` / `do-for-all-facts`**: consultas y limpieza global de hechos.

---

## 4) Plantillas de hechos principales

### Base de datos

- `receta`: nombre, tipo-plato, dificultad, comensales, tiempo-cocinado, info-nutricional, enlace.
- `ingrediente`: ingrediente de cada receta con cantidad y unidad.

### Motor interactivo

- `RecetaCandidata`: recetas que siguen vivas durante el filtrado.
- `RecetaAdecuada`: candidatas finales con `motivo` textual.
- `RecetaOfertada`: receta actualmente mostrada al usuario.
- `RecetaRechazada`: recetas descartadas por el usuario durante la sesion.
- `respuesta-sin-lactosa`, `respuesta-sin-gluten`: respuestas como templates con slot `valor`.

### Hechos inferidos

Se generan como hechos ordenados del tipo:

- `(propiedad_receta es_vegana ?r)`
- `(propiedad_receta calorias baja|media|alta ?r)`
- `(propiedad_receta proteinas baja|media|alta ?r)`
- `(propiedad_receta digestion ligera|normal|pesada ?r)`
- etc.

---

## 5) Funciones (`deffunction`) y por que existen

- **`contiene(?texto ?patron)`**: busqueda case-insensitive por subcadena. Base de muchas reglas lexicas.
- **`es-condimento(?ing)`**: detector de condimentos por palabras clave. (Actualmente no participa en reglas de filtrado).
- **`es-importante(?ing)`**: marca ingredientes "fuertes" (proteina base, cereales, etc.) para inferencias.
- **`es-dulce(?ing)`**: identifica ingredientes dulces para deducir postres.
- **`obtener-kcal($?info)`**: extrae kcal del primer dato nutricional, tolerando string/symbol/numero.
- **`extraer-numero-gramos(?dato)`**: parsea gramos desde textos tipo `"14g proteinas"`.
- **`obtener-proteinas($?info)`**: recorre `info-nutricional` y devuelve gramos de proteina.

- **`normalizar-respuesta(?x)`**: homogeneiza entradas del usuario a minusculas.
- **`tipo-respuesta-a-simbolo(?resp)`**: mapea respuesta textual de tipo a simbolo interno.
- **`dieta-valida(?r)`**: valida dominio de respuesta dieta.
- **`si-no-valido(?r)`**: valida respuestas binarias (`si/no/ns/fin`).
- **`tipo-valido(?r)`**: valida tipo (`principal/entrante/postre/ns/fin`).
- **`densidad-calorica-valida(?r)`**: valida `alta/media/baja/ns/fin`.
- **`proteina-valida(?r)`**: valida `alta/media/baja/ns/fin`.
- **`numero-o-control(?r)`**: valida campos numericos o control (`ns/fin`).

- **`limpiar-evaluacion()`**: limpia hechos de evaluacion previa para recalcular desde cero.
- **`crear-candidatas-iniciales()`**: convierte todas las recetas en candidatas iniciales.
- **`obtener-dieta-receta(?r)`**: construye etiqueta de dieta para el motivo final (`vegana`, `vegetariana`, `normal`).

---

## 6) Modulo 1: deduccion de propiedades de recetas

### 6.1 Ingredientes relevantes

- `ingrediente-relevante-por-nombre`: relevante si aparece en el nombre de receta.
- `ingrediente-relevante-por-tipo`: relevante si entra en lista `es-importante`.

### 6.2 Deduccion de tipo de plato

Si `tipo-plato` es desconocido/sin-clasificar/ninguno:

- dulce -> `postre`
- ingrediente importante -> `principal`
- por defecto -> `entrante` (con menor prioridad/salience).

### 6.3 Clasificaciones de dieta y rasgos

- picante
- contiene gluten / contiene lactosa
- no vegetariana / no vegana
- es vegetariana / es vegana
- es sin gluten / es sin lactosa

### 6.4 Calorias, proteinas y digestion

- calorias desde `info-nutricional` -> `baja/media/alta`
- proteinas por umbral:
  - `baja`: `<= 10`
  - `media`: `>10` y `<=15`
  - `alta`: `>15`
- digestion:
  - `pesada` si receta pesada o calorias altas,
  - `ligera` si entrante o calorias bajas,
  - `normal` por defecto.

---

## 7) Modulo 2: pedir informacion (y justificar)

Preguntas al usuario:

- dieta base (normal/vegetariana/vegana)
- sin lactosa (si/no)
- sin gluten (si/no)
- tipo
- comensales
- tiempo maximo
- nivel de proteina
- densidad calorica
- ingrediente obligatorio

Reglas importantes:

- si dieta = vegana, se omite la pregunta de sin lactosa y se fija a `si`.
- cada pregunta tiene regla de validacion dedicada.
- `defaults-respuestas` completa `ns` si falta alguna respuesta para evitar huecos logicos.

---

## 8) Modulo 3: proponer tipo de receta

El tipo se usa como preferencia de usuario:

- `ns` significa "no restringir".
- en filtrado solo se compara tipo cuando la respuesta es distinta de `ns`.

---

## 9) Modulo 4: obtener recetas compatibles

Pipeline:

1. `iniciar-evaluacion`: limpia estado y crea `RecetaCandidata` para todas las recetas.
2. Reglas `filtrar-*`: retractan candidatas que incumplen criterios.
3. `registrar-adecuadas`: promueve candidatas a `RecetaAdecuada` y construye el motivo textual.

Filtros implementados:

- dieta vegana / vegetariana
- sin lactosa / sin gluten
- tipo
- densidad calorica
- nivel de proteina
- comensales minimos
- tiempo maximo
- ingrediente obligatorio

---

## 10) Modulo 5: proponer receta y reajustar

- Si no hay adecuadas: se ofrece cambiar un parametro (`sin-recetas-adecuadas`) y recalcular.
- `mostrar-receta`: muestra una receta y espera accion del usuario.
- `aceptar-receta`: termina con exito.
- `rechazar-receta`: marca receta rechazada y busca otra.
- `reajustar-criterio`: cambia un criterio en caliente y vuelve a `fase elegir`.
- `sin-mas-recetas`: fin cuando ya no quedan propuestas.

---

## 11) Control de agenda y orden de ejecucion

El sistema usa `salience` para forzar orden en puntos criticos:

- bienvenida/comprobaciones iniciales con salience muy alta,
- validaciones por encima de preguntas,
- deducciones por defecto con salience negativa,
- cierre final con salience muy baja.

Esto evita comportamientos no deterministas tipicos de motores de reglas.

---

## 12) Ejecucion

En CLIPS:

```clips
(load "SE_simple_recetas.clp")
(reset)
(run)
```

---

## 13) Nota tecnica importante

Las etiquetas de calorias estan unificadas en todo el sistema como `baja/media/alta`.
