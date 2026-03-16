(deftemplate receta
   (slot nombre (type STRING))
   (slot tipo-plato (type SYMBOL))
   (slot dificultad (type SYMBOL))
   (slot comensales (type INTEGER))
   (slot tiempo-cocinado (type INTEGER))
   (multislot info-nutricional)
   (slot enlace-web (type STRING))
)

(deftemplate ingrediente
   (slot nombre-receta (type STRING))
   (slot nombre-ingrediente (type STRING))
   (slot cantidad (type FLOAT))
   (slot unidad (type SYMBOL))
)



(deffacts receta-pionono-agridulce
   ;; Definición de la receta principal
   (receta 
      (nombre "Pionono agridulce")
      (tipo-plato entrante)
      (dificultad media)
      (comensales 6)
      (tiempo-cocinado 40)
      (info-nutricional 320.0 "kcal" 12.0 "g proteina" 18.0 "g grasas" 25.0 "g carbohidratos")
      (enlace-web "https://recetas.elperiodico.com/receta-de-pionono-agridulce-77770.html")
   )

   ;; Ingredientes de la masa y base
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "plancha de pionono o bizcochuelo") (cantidad 1.0) (unidad unidades))
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "mayonesa") (cantidad 150.0) (unidad g))
   
   ;; Ingredientes del relleno (Salados)
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "jamon cocido") (cantidad 200.0) (unidad g))
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "queso en lonchas") (cantidad 150.0) (unidad g))
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "huevo duro") (cantidad 3.0) (unidad unidades))
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "aceitunas verdes rellenas") (cantidad 50.0) (unidad g))
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "pimiento morron en conserva") (cantidad 100.0) (unidad g))

   ;; Ingredientes del toque dulce
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "palmito") (cantidad 4.0) (unidad unidades))
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "piña en almibar") (cantidad 3.0) (unidad rodajas))
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "cerezas al marrasquino") (cantidad 6.0) (unidad unidades))
   
   ;; Condimentos
   (ingrediente (nombre-receta "Pionono agridulce") (nombre-ingrediente "sal y pimienta") (cantidad 1.0) (unidad pizca))
)

(deffacts receta-carbonara-philadelphia
   ;; Definición de la receta principal
   (receta 
      (nombre "Espagueti carbonara con queso Philadelphia")
      (tipo-plato segundo-plato)
      (dificultad baja)
      (comensales 4)
      (tiempo-cocinado 20)
      (info-nutricional 580.0 "kcal" 18.0 "g proteina" 28.0 "g grasas" 65.0 "g carbohidratos")
      (enlace-web "https://recetas.elperiodico.com/receta-de-espagueti-carbonara-con-queso-philadelphia-59508.html")
   )

   ;; Ingredientes para la pasta y la salsa
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "espaguetis") (cantidad 400.0) (unidad g))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "queso Philadelphia") (cantidad 150.0) (unidad g))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "bacon o panceta") (cantidad 150.0) (unidad g))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "huevo") (cantidad 2.0) (unidad unidades))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "cebolla") (cantidad 0.5) (unidad unidades))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "aceite de oliva") (cantidad 2.0) (unidad cucharadas))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "queso parmesano rallado") (cantidad 50.0) (unidad g))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "sal") (cantidad 1.0) (unidad pizca))
   (ingrediente (nombre-receta "Espagueti carbonara con queso Philadelphia") (nombre-ingrediente "pimienta negra") (cantidad 1.0) (unidad pizca))
)


(deffacts receta-pejerrey-arrebozado
   ;; Definición de la receta principal
   (receta 
      (nombre "Pejerrey arrebozado")
      (tipo-plato segundo-plato)
      (dificultad baja)
      (comensales 2)
      (tiempo-cocinado 45)
      (info-nutricional 612.5 "kcal" 45 "g proteina" 3 "g grasas" 37.5 "g carbohidratos")
      (enlace-web "https://recetas.elperiodico.com/receta-de-pejerrey-arrebozado-77640.html")
   )

   ;; Ingredientes del pescado y rebozado
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "pejerrey limpio") (cantidad 500.0) (unidad g))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "huevo") (cantidad 1.0) (unidad unidades))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "mostaza") (cantidad 1.0) (unidad cucharada))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "ajo molido") (cantidad 1.0) (unidad cucharadita))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "pimienta negra") (cantidad 1.0) (unidad pizca))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "sal") (cantidad 1.0) (unidad cucharadita))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "cerveza rubia") (cantidad 100.0) (unidad ml))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "harina de trigo") (cantidad 150.0) (unidad g))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "aceite para freir") (cantidad 500.0) (unidad ml))

   ;; Ingredientes para la sarsa criolla (acompañamiento)
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "cebolla roja") (cantidad 1.0) (unidad unidades))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "tomate") (cantidad 1.0) (unidad unidades))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "limon") (cantidad 2.0) (unidad unidades))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "aji amarillo") (cantidad 1.0) (unidad unidades))
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "culantro") (cantidad 1.0) (unidad pizca))

   ;; Guarnición
   (ingrediente (nombre-receta "Pejerrey arrebozado") (nombre-ingrediente "yuca o camote") (cantidad 2.0) (unidad unidades))
)


(deffacts receta-camarones-tamarindo
   ;; Definición de la receta principal
   (receta 
      (nombre "Camarones al tamarindo")
      (tipo-plato segundo-plato)
      (dificultad baja)
      (comensales 4)
      (tiempo-cocinado 30)
      (info-nutricional 420.0 "kcal" 28.0 "g proteina" 12.0 "g grasas" 50.0 "g carbohidratos")
      (enlace-web "https://recetas.elperiodico.com/receta-de-camarones-al-tamarindo-74924.html")
   )

   ;; Ingredientes principales
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "camarones limpios") (cantidad 500.0) (unidad g))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "pasta de tamarindo") (cantidad 100.0) (unidad g))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "azucar rubia") (cantidad 2.0) (unidad cucharadas))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "salsa de soja") (cantidad 1.0) (unidad cucharada))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "ajo picado") (cantidad 2.0) (unidad dientes))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "kion o jengibre rallado") (cantidad 1.0) (unidad cucharadita))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "aceite vegetal") (cantidad 2.0) (unidad cucharadas))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "cebollita china") (cantidad 1.0) (unidad pizca))
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "sal y pimienta") (cantidad 1.0) (unidad pizca))

   ;; Acompañamiento sugerido
   (ingrediente (nombre-receta "Camarones al tamarindo") (nombre-ingrediente "arroz blanco cocido") (cantidad 200.0) (unidad g))
)
(deffacts receta-goxua
   ;; Definición de la receta principal
   (receta 
      (nombre "Goxua casero")
      (tipo-plato postre)
      (dificultad media)
      (comensales 4)
      (tiempo-cocinado 40)
      (info-nutricional 57 "kcal" 9 "g proteina" 32 "g grasas" 62 "g carbohidratos")
      (enlace-web "https://recetas.elperiodico.com/receta-de-goxua-casero-como-preparar-el-postre-vasco-de-crema-y-nata-irresistible-78505.html")
   )

   ;; Ingredientes para la Crema Pastelera
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "leche") (cantidad 500.0) (unidad ml))
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "yemas de huevo") (cantidad 3.0) (unidad unidades))
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "azucar") (cantidad 100.0) (unidad g))
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "maicena") (cantidad 40.0) (unidad g))
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "esencia de vainilla") (cantidad 1.0) (unidad pizca))

   ;; Ingredientes para la Nata Montada / Chantilly
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "nata para montar") (cantidad 400.0) (unidad ml))
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "azucar glas") (cantidad 60.0) (unidad g))

   ;; Ingredientes para el montaje
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "bizcocho de soletilla") (cantidad 12.0) (unidad unidades))
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "licor o almibar") (cantidad 50.0) (unidad ml))
   (ingrediente (nombre-receta "Goxua casero") (nombre-ingrediente "azucar para quemar") (cantidad 20.0) (unidad g))
)

