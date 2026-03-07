#show heading: set block(below: 1cm)
#align(center)[

= Sistema Experto para recomendar qué comer

#text(size: 1.2em )[Pablo Linari Pérez \ *Experto*: David Segura Sánchez]

]

== Definición del problema 

El problema se basa en aconsejar a un usuario qué receta debe elaborar para comer.
Para esta tarea vamos a desarrollar un SBC de la mano de un experto del cual vamos a extraer información mediante una entrevista.

#v(0.5cm)
=== Variables de entrada

- * Alimentos disponibles actualmente:* Lista de alimentos genéricos.
- * Alimentos de los que se pueden disponer:* (Alimentos los cuales el usuario puede adquirir rápidamente) Lista de alimentos genéricos. 
- * Tipo de comida:* Desayuno, Comida, Merienda, Cena.
- * Tipo de plato:* Entrante, Plato Principal, Postre.
- * Alimentos a los que se tiene alergia*: Lista de alimentos genéricos
- * Densidad calórica: *alta, baja
- * Tiempo máximo disponible:* 10min, 15min, 20min, 30min, 45min, 1h, 1h30min.
- *Número de personas:* 1, 2, 3, 4, 5.

#v(0.5cm)
=== Variables de salida
La salida del SBC será una receta la cual se recomendará según los datos de entrada del usuario,
cada receta llevará asociada un título, una lista de alimentos, un texto explicativo con los pasos a seguir, el tiempo de preparación estimado y su densidad calórica.

- *Ejemplo de salida*: \ Título: Pollo al horno\
Alimentos: Pollo, Patatas, Aceite\
Pasos a seguir: 1. cortar las patatas , 2. poner aceite en una bandeja , 3. precalentar el horno a 200 grados, 4. poner las patatas en la bandeja y encima el pollo y hornear por 30 minutos. \

Tiempo: 45min\
Densidad Calórica: baja

#v(0.5cm)
== Esquema argumentativo del experto
La lógica argumentativa que sigue el experto consiste en comenzar con todas las recetas posibles y restringir según los datos de entrada, aplicando filtros en cadena por orden de prioridad. El proceso es el siguiente:

+ *Filtro por alergias (prioridad máxima):* Se eliminan todas las recetas que contengan cualquier alimento al que el usuario sea alérgico. Este filtro es absoluto y no admite excepciones.

+ *Filtro por ingredientes disponibles:* Se descartan las recetas cuyos ingredientes no estén ni en la lista de alimentos disponibles actualmente ni en la lista de alimentos que se pueden adquirir. Se priorizan las recetas que aprovechan mejor los alimentos ya disponibles, minimizando la necesidad de compra.

+ *Filtro por tipo de comida:* Se restringe el conjunto de recetas según el momento del día (Desayuno, Comida, Merienda, Cena). Para desayuno y cena se favorecen platos ligeros; para comida se permiten platos más contundentes; para merienda se seleccionan opciones intermedias o snacks.

+ *Filtro por tipo de plato:* Se filtra según la categoría del plato (Entrante, Plato Principal, Postre). Entrantes incluyen ensaladas, sopas o aperitivos; platos principales son preparaciones contundentes; postres son dulces o fruta.

+ *Filtro por tiempo máximo disponible:* Se descartan todas las recetas cuyo tiempo de preparación estimado supere el tiempo máximo indicado por el usuario. Con tiempos muy cortos (10-15 min) solo se ofrecen recetas rápidas como bocadillos, ensaladas simples o precocinados.

+ *Filtro por densidad calórica:* Si el usuario pide densidad baja, se eliminan fritos, recetas grasas y se favorecen preparaciones al horno, plancha o ensaladas. Si pide densidad alta, se priorizan recetas contundentes con salsas, carbohidratos o proteínas abundantes.

+ *Ajuste por número de personas:* Se descartan recetas que no escalen bien al número de comensales indicado (por ejemplo, recetas individuales para 5 personas o recetas pensadas para grupos cuando solo hay 1). Las cantidades de los ingredientes de la receta seleccionada se ajustan proporcionalmente.

Tras aplicar todos los filtros, del conjunto resultante se selecciona la receta más adecuada y se devuelve como salida con su título, lista de ingredientes (ajustada al número de personas), pasos a seguir, tiempo de preparación y densidad calórica.

=== Resumen de la entrevista

+ *¿Cómo decides qué receta recomendar cuando alguien te dice los ingredientes que tiene disponibles?*

  Descarto las recetas cuyos ingredientes no se tienen ni se pueden conseguir. Priorizo las que aprovechan mejor lo disponible y, si hay varias opciones, aplico el resto de restricciones (tiempo, tipo de comida, alergias).

+ *¿Cómo adaptas la recomendación según el tipo de comida (desayuno, comida, merienda, cena) y el tipo de plato (entrante, principal, postre)?*

  No todas las recetas valen para cualquier momento. Para desayuno recomiendo platos ligeros; para cena, también ligeros frente a la comida. El tipo de plato filtra más: entrantes (ensaladas, sopas), principales (platos contundentes) y postres (dulces o fruta). Ambas variables juntas reducen bastante las opciones.

+ *¿Cómo gestionas las alergias y la densidad calórica a la hora de filtrar recetas?*

Si una receta contiene un alérgeno, se descarta sin excepciones. Para densidad calórica baja, elimino fritos y recetas grasas, favoreciendo horno, plancha o ensaladas. Para alta, priorizo recetas contundentes con salsas, carbohidratos o proteínas abundantes.

+ *¿Cómo influyen el tiempo disponible y el número de personas en tu recomendación?*

  El tiempo es un filtro directo: descarto recetas que superen el máximo indicado. Con 10-15 minutos, me limito a bocadillos, ensaladas simples o precocinados. El número de personas afecta principalmente a las cantidades, aunque algunas recetas no escalan bien y se descartan en esos casos.

#v(0.5cm)
== Análisis de viabilidad 

- *Es factible obtener los datos que se usan de entrada? ¿Cuánto coste tienen?*: Sí es posible obtener los datos de entrada ya que estos los introduce el usuario. El coste de los mismos será bajo.
- *El esquema general del proceso de razonamiento se
puede representar?* Sí se puede representar mediante relaciones lógicas entre alimentos y etiquetas de recetas. Ya que como hemos visto en el razonamiento del experto, el sistema que construiremos se basa en partir de un conjunto de recetas general e ir restringiendo según los datos de entrada del usuario. Para ello usaremos las listas de alimentos y los tags de las recetas tales como número de personas, tiempo de preparación, listado de alimentos y densidad calórica para ir descartando según los datos proporcionados. 

Cabe destacar que las relaciones lógicas de este sistema tampoco serían muy costosas de implementar y no tienen un gran consumo computacional por lo que podríamos construirlo con facilidad. El único paso costoso sería el de etiquetar todos los datos disponibles. 


