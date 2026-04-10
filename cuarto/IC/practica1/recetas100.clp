
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
(slot nombre-receta (type STRING)) ; Enlace con la receta
(slot nombre-ingrediente (type STRING)) 
(slot cantidad (type FLOAT))
(slot unidad (type SYMBOL)) ; g, ml, unidades, pizca... 
)


(deffacts receta-merluza-donostiarra
  (receta
    (nombre "Merluza a la donostiarra")
    (tipo-plato principal)
    (dificultad media)
    (comensales 4)
    (tiempo-cocinado 30)
    (info-nutricional "285 kcal" "24g proteinas" "18g grasas" "5g carbohidratos")
    (enlace-web "https://recetas.elperiodico.com/receta-de-merluza-a-la-donostiarra-el-paso-a-paso-para-que-quede-tan-jugosa-como-en-un-asador-vasco-78584.html"))

  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "lomos de merluza") (cantidad 800.0) (unidad g))
  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "aceite de oliva virgen extra") (cantidad 150.0) (unidad ml))
  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "dientes de ajo") (cantidad 6.0) (unidad unidades))
  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "guindilla") (cantidad 1.0) (unidad unidades))
  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "esparragos blancos") (cantidad 8.0) (unidad unidades))
  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "huevos") (cantidad 2.0) (unidad unidades))
  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "perejil fresco") (cantidad 1.0) (unidad manojo))
  (ingrediente (nombre-receta "Merluza a la donostiarra") (nombre-ingrediente "sal") (cantidad 1.0) (unidad pizca))
)

(deffacts receta-filloas-crema
  (receta
    (nombre "Filloas rellenas de crema")
    (tipo-plato postre)
    (dificultad media)
    (comensales 6)
    (tiempo-cocinado 45)
    (info-nutricional "320 kcal" "8g proteinas" "12g grasas" "45g carbohidratos")
    (enlace-web "https://recetas.elperiodico.com/receta-de-filloas-rellenas-de-crema-el-postre-gallego-que-conquista-a-todos-con-su-interior-suave-y-cremoso-78583.html"))

  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "harina de trigo") (cantidad 250.0) (unidad g))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "leche") (cantidad 500.0) (unidad ml))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "huevos") (cantidad 3.0) (unidad unidades))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "mantequilla") (cantidad 30.0) (unidad g))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "sal") (cantidad 1.0) (unidad pizca))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "yemas de huevo") (cantidad 4.0) (unidad unidades))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "azucar") (cantidad 150.0) (unidad g))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "maizena") (cantidad 40.0) (unidad g))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "esencia de vainilla") (cantidad 1.0) (unidad cucharadita))
  (ingrediente (nombre-receta "Filloas rellenas de crema") (nombre-ingrediente "canela en polvo") (cantidad 1.0) (unidad pizca))
)

(deffacts receta-arroz-meloso-secreto-setas
  (receta
    (nombre "Arroz meloso con secreto y setas")
    (tipo-plato principal)
    (dificultad media)
    (comensales 4)
    (tiempo-cocinado 50)
    (info-nutricional "520 kcal" "28g proteinas" "22g grasas" "52g carbohidratos")
    (enlace-web "https://recetas.elperiodico.com/receta-de-arroz-meloso-con-secreto-y-setas-el-plato-casero-con-el-que-siempre-aciertas-si-tienes-invitados-78575.html"))

  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "arroz bomba") (cantidad 320.0) (unidad g))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "secreto iberico") (cantidad 400.0) (unidad g))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "setas variadas") (cantidad 250.0) (unidad g))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "cebolla") (cantidad 1.0) (unidad unidades))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "dientes de ajo") (cantidad 3.0) (unidad unidades))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "caldo de carne") (cantidad 1000.0) (unidad ml))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "vino blanco") (cantidad 100.0) (unidad ml))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "aceite de oliva") (cantidad 50.0) (unidad ml))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "pimenton dulce") (cantidad 1.0) (unidad cucharadita))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "perejil") (cantidad 1.0) (unidad manojo))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "sal") (cantidad 1.0) (unidad pizca))
  (ingrediente (nombre-receta "Arroz meloso con secreto y setas") (nombre-ingrediente "pimienta negra") (cantidad 1.0) (unidad pizca))
)

(deffacts receta-pie-limon-merengue
  (receta
    (nombre "Pie de limon y merengue facil")
    (tipo-plato postre)
    (dificultad facil)
    (comensales 8)
    (tiempo-cocinado 60)
    (info-nutricional "380 kcal" "5g proteinas" "14g grasas" "58g carbohidratos")
    (enlace-web "https://recetas.elperiodico.com/receta-de-pie-de-limon-y-merengue-facil-44654.html"))

  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "galletas digestive") (cantidad 200.0) (unidad g))
  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "mantequilla") (cantidad 100.0) (unidad g))
  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "leche condensada") (cantidad 400.0) (unidad g))
  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "zumo de limon") (cantidad 150.0) (unidad ml))
  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "ralladura de limon") (cantidad 2.0) (unidad cucharadas))
  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "yemas de huevo") (cantidad 4.0) (unidad unidades))
  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "claras de huevo") (cantidad 4.0) (unidad unidades))
  (ingrediente (nombre-receta "Pie de limon y merengue facil") (nombre-ingrediente "azucar") (cantidad 120.0) (unidad g))
)

(deffacts receta-gambas-ajillo
  (receta
    (nombre "Gambas al ajillo")
    (tipo-plato entrante)
    (dificultad facil)
    (comensales 4)
    (tiempo-cocinado 15)
    (info-nutricional "280 kcal" "18g proteinas" "22g grasas" "3g carbohidratos")
    (enlace-web "https://recetas.elperiodico.com/receta-de-gambas-al-ajillo-caseras-46498.html"))

  (ingrediente (nombre-receta "Gambas al ajillo") (nombre-ingrediente "gambas peladas") (cantidad 500.0) (unidad g))
  (ingrediente (nombre-receta "Gambas al ajillo") (nombre-ingrediente "aceite de oliva virgen extra") (cantidad 150.0) (unidad ml))
  (ingrediente (nombre-receta "Gambas al ajillo") (nombre-ingrediente "dientes de ajo") (cantidad 6.0) (unidad unidades))
  (ingrediente (nombre-receta "Gambas al ajillo") (nombre-ingrediente "guindilla") (cantidad 2.0) (unidad unidades))
  (ingrediente (nombre-receta "Gambas al ajillo") (nombre-ingrediente "perejil fresco") (cantidad 1.0) (unidad manojo))
  (ingrediente (nombre-receta "Gambas al ajillo") (nombre-ingrediente "sal") (cantidad 1.0) (unidad pizca))
  (ingrediente (nombre-receta "Gambas al ajillo") (nombre-ingrediente "vino blanco") (cantidad 50.0) (unidad ml))
)

(deffacts receta-croquetas-morcilla
   
   (receta
      (nombre "Croquetas de morcilla")
      (tipo-plato entrante)
      (dificultad baja)
      (comensales 3)
      (tiempo-cocinado 30)
      (info-nutricional "373.3 kcal" "14g proteinas" "26g grasas" "26.7g carbohidratos" "2.7g fibra")
      (enlace-web "https://recetas.elperiodico.com/receta-de-croquetas-de-morcilla-75134.html")
   )

   
   (ingrediente
      (nombre-receta "Croquetas de morcilla")
      (nombre-ingrediente "morcilla")
      (cantidad 2.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Croquetas de morcilla")
      (nombre-ingrediente "pan rallado")
      (cantidad 1.0)
      (unidad taza)
   )

   (ingrediente
      (nombre-receta "Croquetas de morcilla")
      (nombre-ingrediente "huevo")
      (cantidad 1.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Croquetas de morcilla")
      (nombre-ingrediente "papa")
      (cantidad 1.0)
      (unidad unidades)
   )
)


(deffacts receta-tartar-atun-mango
   
   (receta
      (nombre "Tartar de atun y mango")
      (tipo-plato principal)
      (dificultad baja)
      (comensales 2)
      (tiempo-cocinado 45)
      (info-nutricional "41 kcal" "25g proteinas" "25g grasas" "25g carbohidratos" "6g fibra")
      (enlace-web "https://recetas.elperiodico.com/receta-de-tartar-de-atun-y-mango-75552.html")
   )

   
   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "atun fresco")
      (cantidad 150.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "mango")
      (cantidad 1.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "aguacate")
      (cantidad 1.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "limon")
      (cantidad 1.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "aceite de sesamo")
      (cantidad 1.0)
      (unidad cucharada)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "salsa de soja")
      (cantidad 1.0)
      (unidad cucharada)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "aceite de oliva")
      (cantidad 1.0)
      (unidad cucharada)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "sal")
      (cantidad 1.0)
      (unidad pizca)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "pimienta negra")
      (cantidad 1.0)
      (unidad pizca)
   )

   (ingrediente
      (nombre-receta "Tartar de atun y mango")
      (nombre-ingrediente "semillas de lino y sesamo")
      (cantidad 1.0)
      (unidad cucharada)
   )
)


(deffacts receta-albondigas-patatas
   
   (receta
      (nombre "Albondigas con patatas")
      (tipo-plato principal)
      (dificultad baja)
      (comensales 4)
      (tiempo-cocinado 45)
      (info-nutricional "362.5 kcal" "18.8g proteinas" "17.5g grasas" "32.5g carbohidratos" "3.8g fibra")
      (enlace-web "https://recetas.elperiodico.com/receta-de-albondigas-con-patatas-73386.html")
   )

   
   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "carne picada")
      (cantidad 300.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "cebolla")
      (cantidad 1.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "tomate frito")
      (cantidad 2.0)
      (unidad cucharadas)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "vino blanco")
      (cantidad 1.0)
      (unidad vaso-pequeno)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "pimienta")
      (cantidad 1.0)
      (unidad pizca)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "ajos")
      (cantidad 2.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "perejil")
      (cantidad 1.0)
      (unidad punado)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "patatas")
      (cantidad 4.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Albondigas con patatas")
      (nombre-ingrediente "harina")
      (cantidad 1.0)
      (unidad cucharada)
   )
)


(deffacts receta-natilla-vainilla
   
   (receta
      (nombre "Natilla de vainilla")
      (tipo-plato postre)
      (dificultad muy-baja)
      (comensales 5)
      (tiempo-cocinado 45)
      (info-nutricional "204 kcal" "6.2g proteinas" "7.2g grasas" "29.2g carbohidratos")
      (enlace-web "https://recetas.elperiodico.com/receta-de-natilla-de-vainilla-75264.html")
   )

   
   (ingrediente
      (nombre-receta "Natilla de vainilla")
      (nombre-ingrediente "leche fresca")
      (cantidad 460.0)
      (unidad ml)
   )

   (ingrediente
      (nombre-receta "Natilla de vainilla")
      (nombre-ingrediente "canela")
      (cantidad 2.0)
      (unidad ramas)
   )

   (ingrediente
      (nombre-receta "Natilla de vainilla")
      (nombre-ingrediente "yemas de huevo")
      (cantidad 4.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Natilla de vainilla")
      (nombre-ingrediente "fecula de maiz")
      (cantidad 15.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Natilla de vainilla")
      (nombre-ingrediente "esencia de vainilla")
      (cantidad 1.0)
      (unidad chorro)
   )

   (ingrediente
      (nombre-receta "Natilla de vainilla")
      (nombre-ingrediente "azucar")
      (cantidad 100.0)
      (unidad g)
   )
)


(deffacts receta-brownie-chocolate
   
   (receta
      (nombre "Brownie de chocolate")
      (tipo-plato postre)
      (dificultad baja)
      (comensales 6)
      (tiempo-cocinado 30)
      (info-nutricional "736.7 kcal" "10.2g proteinas" "36.8g grasas" "91.3g carbohidratos" "3.8g fibra")
      (enlace-web "https://recetas.elperiodico.com/receta-de-brownie-de-chocolate-51326.html")
   )

   
   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "mantequilla sin sal")
      (cantidad 125.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "huevo")
      (cantidad 4.0)
      (unidad unidades)
   )

   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "cocoa en polvo")
      (cantidad 80.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "azucar blanca")
      (cantidad 250.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "harina de trigo")
      (cantidad 250.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "leche")
      (cantidad 50.0)
      (unidad ml)
   )

   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "polvo de hornear")
      (cantidad 8.0)
      (unidad g)
   )

   (ingrediente
      (nombre-receta "Brownie de chocolate")
      (nombre-ingrediente "esencia de vainilla")
      (cantidad 3.0)
      (unidad ml)
   )
)

(deffacts receta-tacos-teriyaki
 (receta
   (nombre "Tacos de pollo teriyaki")
   (tipo-plato principal)
   (dificultad media)
   (comensales 2)
   (tiempo-cocinado 30)
   (info-nutricional "380 kcal" "28g proteinas" "12g grasas" "40g carbohidratos" "3g fibra")
   (enlace-web "https://recetas.elperiodico.com/receta-de-tacos-de-pollo-teriyaki-57934.html")
 )

 (ingrediente
   (nombre-receta "Tacos de pollo teriyaki")
   (nombre-ingrediente "pechuga de pollo")
   (cantidad 200.0)
   (unidad g))

 (ingrediente
   (nombre-receta "Tacos de pollo teriyaki")
   (nombre-ingrediente "salsa teriyaki")
   (cantidad 30.0)
   (unidad ml))

 (ingrediente
   (nombre-receta "Tacos de pollo teriyaki")
   (nombre-ingrediente "tortillas de maiz")
   (cantidad 2.0)
   (unidad unidades))

 (ingrediente
   (nombre-receta "Tacos de pollo teriyaki")
   (nombre-ingrediente "cebolla roja")
   (cantidad 50.0)
   (unidad g))
)

(deffacts receta-bolitas-papas-queso

(receta
	(nombre "Bolitas de papas con queso")
	(tipo-plato entrante)
	(dificultad baja) 
	(comensales 4) 
	(tiempo-cocinado 45)
	(info-nutricional "26 kcal" "9.5g proteinas" "13g grasas" "29g carbohidratos" "3g fibra") 
	(enlace-web "https://recetas.elperiodico.com/receta-de-bolitas-de-papas-con-queso-78307.html")
)

(ingrediente 
	(nombre-receta "Bolitas de papas con queso")
	(nombre-ingrediente "Papas") 
	(cantidad 4.0)
	(unidad unidades)
)

(ingrediente
	(nombre-receta "Bolitas de papas con queso")
	(nombre-ingrediente "Queso")
	(cantidad 50.0)
	(unidad g)
)

(ingrediente
	(nombre-receta "Bolitas de papas con queso")
	(nombre-ingrediente "Huevo")
	(cantidad 1.0)
	(unidad unidades)
)

(ingrediente
	(nombre-receta "Bolitas de papas con queso")
	(nombre-ingrediente "Pan molido")
	(cantidad 50.0)
	(unidad g)
)

(ingrediente
	(nombre-receta "Bolitas de papas con queso")
	(nombre-ingrediente "Azucar")
	(cantidad 20.0)
	(unidad g)
)
)



(deffacts receta-tarta-manzana 
(receta
	(nombre "Tarta de manzana")
	(tipo-plato postre)
	(dificultad baja) 
	(comensales 3) 
	(tiempo-cocinado 45)
	(info-nutricional "373.3 kcal" "3.3g proteinas" "18.7g grasas" "49.3g carbohidratos" "3.3g fibra") 
	(enlace-web "https://recetas.elperiodico.com/receta-de-tarta-de-manzana-facil-60477.html")
)

(ingrediente 
	(nombre-receta "Tarta de manzana")
	(nombre-ingrediente "Hojaldre") 
	(cantidad 1.0)
	(unidad unidades)
)

(ingrediente
	(nombre-receta "Tarta de manzana")
	(nombre-ingrediente "Manzana")
	(cantidad 3.0)
	(unidad unidades)
)

(ingrediente
	(nombre-receta "Tarta de manzana")
	(nombre-ingrediente "Mantequilla")
	(cantidad 20.0)
	(unidad g)
)

(ingrediente
	(nombre-receta "Tarta de manzana")
	(nombre-ingrediente "Mermelada de melocoton")
	(cantidad 50.0)
	(unidad g)
)

(ingrediente
	(nombre-receta "Tarta de manzana")
	(nombre-ingrediente "Azucar")
	(cantidad 20.0)
	(unidad g)
)
)



(deffacts receta-tarta-queso-leche-condensada
  
  (receta
    (nombre "Tarta de queso y leche condensada al horno")
    (tipo-plato postre)
    (dificultad baja)
    (comensales 4)
    (tiempo-cocinado 90)
    (info-nutricional "1787.5 kcal" "36.5g proteinas" "142.5g grasas" "8g carbohidratos")
    (enlace-web "https://recetas.elperiodico.com/receta-de-tarta-de-queso-y-leche-condensada-al-horno-68953.html"))

  
  (ingrediente (nombre-receta "Tarta de queso y leche condensada al horno") (nombre-ingrediente "queso de untar") (cantidad 700.0) (unidad g))
  (ingrediente (nombre-receta "Tarta de queso y leche condensada al horno") (nombre-ingrediente "nata de montar") (cantidad 500.0) (unidad g))
  (ingrediente (nombre-receta "Tarta de queso y leche condensada al horno") (nombre-ingrediente "leche condensada") (cantidad 370.0) (unidad g))
  (ingrediente (nombre-receta "Tarta de queso y leche condensada al horno") (nombre-ingrediente "huevos") (cantidad 4.0) (unidad unidades))
  (ingrediente (nombre-receta "Tarta de queso y leche condensada al horno") (nombre-ingrediente "ralladura de limon") (cantidad 1.0) (unidad unidades))
)

(deffacts arepas_andinas
    (receta
        (nombre "Arepas andinas")
        (tipo-plato desayuno-merienda)
        (dificultad baja)
        (comensales 10)
        (tiempo-cocinado 30)
        (info-nutricional "165 kcal" "4.5g proteinas" "6g grasas" "24g carbohidratos" "0.6g fibra")
        (enlace-web "https://recetas.elperiodico.com/receta-de-arepas-andinas-78319.html"))


    (ingrediente (nombre-receta "Arepas andinas") (nombre-ingrediente "mantequilla") (cantidad 1.0) (unidad cucharada_sopera))
    (ingrediente (nombre-receta "Arepas andinas") (nombre-ingrediente "huevo ") (cantidad 1.0) (unidad huevo))
    (ingrediente (nombre-receta "Arepas andinas") (nombre-ingrediente "leche liquida") (cantidad 1.0) (unidad taza))
    (ingrediente (nombre-receta "Arepas andinas") (nombre-ingrediente "harina") (cantidad 420.0) (unidad g))
    (ingrediente (nombre-receta "Arepas andinas") (nombre-ingrediente "polvo para hornear") (cantidad 1.0) (unidad cucharada_de_postre))
    (ingrediente (nombre-receta "Arepas andinas") (nombre-ingrediente "azucar") (cantidad 3.0) (unidad cucharadas_de_postre))
)

(deffacts Solomillo-al-roquefort
    
   (receta 
      (nombre "Solomillo al roquefort")
      (tipo-plato principal)
      (dificultad baja)
      (comensales 4)
      (tiempo-cocinado 30)
      (info-nutricional "595 kcal" "4g proteinas" "48.8g grasas" "3.8g carbohidratos" "1g fibra")
      (enlace-web "https://recetas.elperiodico.com/receta-de-solomillo-al-roquefort-60403.html")
   )

   
   (ingrediente 
      (nombre-receta "Solomillo al roquefort")
      (nombre-ingrediente "Queso roquefort")
      (cantidad 150.0)
      (unidad g)
   )
   
   (ingrediente 
      (nombre-receta "Solomillo al roquefort")
      (nombre-ingrediente "solomillo de cerdo")
      (cantidad 2.0)
      (unidad piezas)
   )

   (ingrediente 
      (nombre-receta "Solomillo al roquefort")
      (nombre-ingrediente "Nata de cocinar")
      (cantidad 200.0)
      (unidad ml)
   )

   (ingrediente 
      (nombre-receta "Solomillo al roquefort")
      (nombre-ingrediente "Leche")
      (cantidad 50.0)
      (unidad ml)
   )

   (ingrediente 
      (nombre-receta "Solomillo al roquefort")
      (nombre-ingrediente "Aceite de oliva")
      (cantidad 1.0)
      (unidad chorro)
   )
      
   (ingrediente 
      (nombre-receta "Solomillo al roquefort")
      (nombre-ingrediente "Sal")
      (cantidad 1.0)
      (unidad pizca)
   )

   (ingrediente 
      (nombre-receta "Solomillo al roquefort")
      (nombre-ingrediente "Pimienta")
      (cantidad 1.0)
      (unidad pizca)
   )
)

; ==========================
; Reglas de deduccion
; ==========================

(deftemplate ingrediente-relevante
  (slot nombre-receta (type STRING))
  (slot nombre-ingrediente (type STRING))
)

(deftemplate marca-receta
  (slot nombre-receta (type STRING))
  (slot marca (type SYMBOL))
)

(deftemplate propiedad-receta
  (slot nombre-receta (type STRING))
  (slot propiedad (type SYMBOL))
)

(deftemplate clasificacion-nutricional
  (slot nombre-receta (type STRING))
  (slot calorias (type SYMBOL))
  (slot digestion (type SYMBOL))
)

(deffunction contiene (?texto ?patron)
  (if (neq (str-index (lowcase ?patron) (lowcase ?texto)) FALSE)
    then TRUE
    else FALSE)
)

(deffunction es-dulce (?ing)
  (if (or (contiene ?ing "azucar")
          (contiene ?ing "chocolate")
          (contiene ?ing "galleta")
          (contiene ?ing "vainilla")
          (contiene ?ing "miel")
          (contiene ?ing "cacao")
          (contiene ?ing "postre"))
    then TRUE
    else FALSE)
)

(deffunction es-principal (?ing)
  (if (or (contiene ?ing "carne")
          (contiene ?ing "pollo")
          (contiene ?ing "ternera")
          (contiene ?ing "cerdo")
          (contiene ?ing "pesc")
          (contiene ?ing "atun")
          (contiene ?ing "salmon")
          (contiene ?ing "bacalao")
          (contiene ?ing "lenteja")
          (contiene ?ing "garbanzo")
          (contiene ?ing "arroz")
          (contiene ?ing "pasta")
          (contiene ?ing "espaguet")
          (contiene ?ing "noqui")
          (contiene ?ing "patata"))
    then TRUE
    else FALSE)
)

(deffunction es-condimento (?ing)
  (if (or (contiene ?ing "sal")
          (contiene ?ing "pimienta")
          (contiene ?ing "oregano")
          (contiene ?ing "perejil")
          (contiene ?ing "albahaca")
          (contiene ?ing "laurel")
          (contiene ?ing "canela")
          (contiene ?ing "vinagre")
          (contiene ?ing "esencia")
          (contiene ?ing "nuez moscada")
          (contiene ?ing "pimenton")
          (contiene ?ing "aji")
          (contiene ?ing "guindilla")
          (contiene ?ing "curry")
          (contiene ?ing "comino"))
    then TRUE
    else FALSE)
)

(deffunction obtener-kcal ($?info)
  (if (= (length$ ?info) 0) then (return -1))
  (bind ?prim (nth$ 1 ?info))

  (if (numberp ?prim) then (return ?prim))

  (if (symbolp ?prim) then
    (bind ?num-sym (string-to-field ?prim))
    (if (numberp ?num-sym) then (return ?num-sym))
  )

  (if (stringp ?prim) then
    (bind ?partes (explode$ ?prim))
    (if (> (length$ ?partes) 0) then
      (bind ?txt (nth$ 1 ?partes))
      (if (numberp ?txt) then
        (return ?txt)
      )
      (if (or (stringp ?txt) (symbolp ?txt) (instance-namep ?txt)) then
        (bind ?num (string-to-field ?txt))
        (if (numberp ?num) then (return ?num))
      )
    )
  )

  (return -1)
)


; 1) Ingredientes principales/relevantes
; Regla fuerte: si aparece en el nombre de la receta, es principal
(defrule identificar-ingrediente-principal-por-nombre
  (receta (nombre ?n))
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (not (ingrediente-relevante (nombre-receta ?n) (nombre-ingrediente ?ing)))
  (test (contiene ?n ?ing))
  =>
  (assert (ingrediente-relevante (nombre-receta ?n) (nombre-ingrediente ?ing)))
)

; Regla complementaria: ingredientes tipicos protagonistas
(defrule identificar-ingrediente-principal-por-tipo
  (receta (nombre ?n))
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (not (ingrediente-relevante (nombre-receta ?n) (nombre-ingrediente ?ing)))
  (test (es-principal ?ing))
  =>
  (assert (ingrediente-relevante (nombre-receta ?n) (nombre-ingrediente ?ing)))
)

; Garantia: toda receta tendra al menos un ingrediente principal/relevante
; Si no se detecto ninguno, toma el primer ingrediente no-condimento disponible
(defrule asegurar-minimo-un-ingrediente-principal
  (declare (salience -50))
  (receta (nombre ?n))
  (not (ingrediente-relevante (nombre-receta ?n)))
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (not (es-condimento ?ing)))
  =>
  (assert (ingrediente-relevante (nombre-receta ?n) (nombre-ingrediente ?ing)))
)

; Fallback final: si todos parecen condimentos, igualmente toma uno
(defrule asegurar-minimo-un-ingrediente-principal-fallback
  (declare (salience -60))
  (receta (nombre ?n))
  (not (ingrediente-relevante (nombre-receta ?n)))
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  =>
  (assert (ingrediente-relevante (nombre-receta ?n) (nombre-ingrediente ?ing)))
)


; 2) Deduccion de tipo de plato cuando falte
(defrule deducir-tipo-plato-postre
  ?r <- (receta (nombre ?n) (tipo-plato ?tp&:(or (eq ?tp nil) (eq ?tp desconocido))))
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (es-dulce ?ing))
  =>
  (modify ?r (tipo-plato postre))
)

(defrule deducir-tipo-plato-principal
  ?r <- (receta (nombre ?n) (tipo-plato ?tp&:(or (eq ?tp nil) (eq ?tp desconocido))))
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (es-principal ?ing))
  =>
  (modify ?r (tipo-plato principal))
)

(defrule deducir-tipo-plato-entrante-por-defecto
  (declare (salience -10))
  ?r <- (receta (nombre ?n) (tipo-plato ?tp&:(or (eq ?tp nil) (eq ?tp desconocido))))
  =>
  (modify ?r (tipo-plato entrante))
)


; 3) Marcas intermedias para dieta, alergenos y picante
(defrule marcar-picante
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (or (contiene ?ing "aji")
            (contiene ?ing "guindilla")
            (contiene ?ing "cayena")
            (contiene ?ing "habanero")
            (contiene ?ing "chile")
            (contiene ?ing "picante")
            (contiene ?ing "pimienta")))
  (not (marca-receta (nombre-receta ?n) (marca picante)))
  =>
  (assert (marca-receta (nombre-receta ?n) (marca picante)))
)

(defrule marcar-gluten
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (or (contiene ?ing "harina")
            (contiene ?ing "pan")
            (contiene ?ing "pasta")
            (contiene ?ing "espaguet")
            (contiene ?ing "macarr")
            (contiene ?ing "fideos")
            (contiene ?ing "galleta")
            (contiene ?ing "hojaldre")
            (contiene ?ing "bizcocho")))
  (not (marca-receta (nombre-receta ?n) (marca contiene-gluten)))
  =>
  (assert (marca-receta (nombre-receta ?n) (marca contiene-gluten)))
)

(defrule marcar-lactosa
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (or (contiene ?ing "leche")
            (contiene ?ing "queso")
            (contiene ?ing "nata")
            (contiene ?ing "mantequilla")
            (contiene ?ing "yogur")
            (contiene ?ing "crema")))
  (not (marca-receta (nombre-receta ?n) (marca contiene-lactosa)))
  =>
  (assert (marca-receta (nombre-receta ?n) (marca contiene-lactosa)))
)

(defrule marcar-no-vegetariana
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (or (contiene ?ing "carne")
            (contiene ?ing "pollo")
            (contiene ?ing "ternera")
            (contiene ?ing "cerdo")
            (contiene ?ing "jamon")
            (contiene ?ing "choriz")
            (contiene ?ing "morcilla")
            (contiene ?ing "bacon")
            (contiene ?ing "panceta")
            (contiene ?ing "pato")
            (contiene ?ing "atun")
            (contiene ?ing "salmon")
            (contiene ?ing "bacalao")
            (contiene ?ing "merluza")
            (contiene ?ing "gamba")
            (contiene ?ing "camaron")
            (contiene ?ing "pulpo")
            (contiene ?ing "marisc")
            (contiene ?ing "pescad")
            (contiene ?ing "huevo")))
  (not (marca-receta (nombre-receta ?n) (marca no-vegetariana)))
  =>
  (assert (marca-receta (nombre-receta ?n) (marca no-vegetariana)))
)

(defrule marcar-no-vegana-por-animal
  (marca-receta (nombre-receta ?n) (marca no-vegetariana))
  (not (marca-receta (nombre-receta ?n) (marca no-vegana)))
  =>
  (assert (marca-receta (nombre-receta ?n) (marca no-vegana)))
)

(defrule marcar-no-vegana-por-lactosa-o-miel
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (or (contiene ?ing "leche")
            (contiene ?ing "queso")
            (contiene ?ing "nata")
            (contiene ?ing "mantequilla")
            (contiene ?ing "yogur")
            (contiene ?ing "miel")))
  (not (marca-receta (nombre-receta ?n) (marca no-vegana)))
  =>
  (assert (marca-receta (nombre-receta ?n) (marca no-vegana)))
)

(defrule marcar-pesada
  (ingrediente (nombre-receta ?n) (nombre-ingrediente ?ing))
  (test (or (contiene ?ing "frito")
            (contiene ?ing "freir")
            (contiene ?ing "tocino")
            (contiene ?ing "bacon")
            (contiene ?ing "morcilla")
            (contiene ?ing "choriz")
            (contiene ?ing "mantequilla")
            (contiene ?ing "nata")
            (contiene ?ing "queso")
            (contiene ?ing "crema")))
  (not (marca-receta (nombre-receta ?n) (marca pesada)))
  =>
  (assert (marca-receta (nombre-receta ?n) (marca pesada)))
)


; 4) Clasificacion de propiedades finales
(defrule clasificar-picante
  (marca-receta (nombre-receta ?n) (marca picante))
  (not (propiedad-receta (nombre-receta ?n) (propiedad picante)))
  =>
  (assert (propiedad-receta (nombre-receta ?n) (propiedad picante)))
)

(defrule clasificar-sin-gluten
  (receta (nombre ?n))
  (not (marca-receta (nombre-receta ?n) (marca contiene-gluten)))
  (not (propiedad-receta (nombre-receta ?n) (propiedad sin-gluten)))
  =>
  (assert (propiedad-receta (nombre-receta ?n) (propiedad sin-gluten)))
)

(defrule clasificar-sin-lactosa
  (receta (nombre ?n))
  (not (marca-receta (nombre-receta ?n) (marca contiene-lactosa)))
  (not (propiedad-receta (nombre-receta ?n) (propiedad sin-lactosa)))
  =>
  (assert (propiedad-receta (nombre-receta ?n) (propiedad sin-lactosa)))
)

(defrule clasificar-vegetariana
  (receta (nombre ?n))
  (not (marca-receta (nombre-receta ?n) (marca no-vegetariana)))
  (not (propiedad-receta (nombre-receta ?n) (propiedad vegetariana)))
  =>
  (assert (propiedad-receta (nombre-receta ?n) (propiedad vegetariana)))
)

(defrule clasificar-vegana
  (receta (nombre ?n))
  (not (marca-receta (nombre-receta ?n) (marca no-vegana)))
  (not (propiedad-receta (nombre-receta ?n) (propiedad vegana)))
  =>
  (assert (propiedad-receta (nombre-receta ?n) (propiedad vegana)))
)


; 5) Clasificacion calorica y de digestion
(defrule clasificar-nutricion
  (receta (nombre ?n) (tipo-plato ?tipo) (info-nutricional $?info))
  (not (clasificacion-nutricional (nombre-receta ?n)))
  =>
  (bind ?kcal (obtener-kcal ?info))
  (bind ?cat normal)
  (bind ?dig normal)

  (if (>= ?kcal 0) then
    (if (or (eq ?tipo postre) (eq ?tipo desayuno-merienda)) then
      (if (<= ?kcal 180) then (bind ?cat ligera) else
        (if (<= ?kcal 350) then (bind ?cat normal) else (bind ?cat calorica)))
    else
      (if (eq ?tipo entrante) then
        (if (<= ?kcal 150) then (bind ?cat ligera) else
          (if (<= ?kcal 300) then (bind ?cat normal) else (bind ?cat calorica)))
      else
        (if (<= ?kcal 300) then (bind ?cat ligera) else
          (if (<= ?kcal 600) then (bind ?cat normal) else (bind ?cat calorica)))
      )
    )
  else
    (if (any-factp ((?m marca-receta))
          (and (eq ?m:nombre-receta ?n) (eq ?m:marca pesada)))
      then (bind ?cat calorica)
      else (if (eq ?tipo entrante) then (bind ?cat ligera) else (bind ?cat normal)))
  )

  (if (any-factp ((?m marca-receta))
        (and (eq ?m:nombre-receta ?n) (eq ?m:marca pesada)))
    then (bind ?dig pesada)
    else
      (if (or (eq ?tipo entrante)
              (any-factp ((?i ingrediente))
                (and (eq ?i:nombre-receta ?n)
                     (or (contiene ?i:nombre-ingrediente "ensalada")
                         (contiene ?i:nombre-ingrediente "caldo")
                         (contiene ?i:nombre-ingrediente "verdura")
                         (contiene ?i:nombre-ingrediente "fruta")))))
        then (bind ?dig ligera)
        else (bind ?dig normal))
  )

  (assert (clasificacion-nutricional
            (nombre-receta ?n)
            (calorias ?cat)
            (digestion ?dig)))
)


; =========================================================
; BLOQUE DE SALIDA / REPORTE (SEPARADO DE LAS REGLAS BASE)
; =========================================================

(deftemplate receta-reportada
  (slot nombre-receta (type STRING))
)

(defrule imprimir-reporte-receta
  (declare (salience -1000))
  (receta (nombre ?n) (tipo-plato ?tipo))
  (clasificacion-nutricional (nombre-receta ?n) (calorias ?cal) (digestion ?dig))
  (not (receta-reportada (nombre-receta ?n)))
  =>
  (printout t crlf)
  (printout t "====================================================" crlf)
  (printout t "REPORTE DE RECETA" crlf)
  (printout t "====================================================" crlf)
  (printout t "- Nombre: " ?n crlf)
  (printout t "- Tipo de plato: " ?tipo crlf)

  (if (any-factp ((?p propiedad-receta))
        (and (eq ?p:nombre-receta ?n) (eq ?p:propiedad vegana)))
    then (printout t "- Vegana: si" crlf)
    else (printout t "- Vegana: no" crlf))

  (if (any-factp ((?p propiedad-receta))
        (and (eq ?p:nombre-receta ?n) (eq ?p:propiedad vegetariana)))
    then (printout t "- Vegetariana: si" crlf)
    else (printout t "- Vegetariana: no" crlf))

  (if (any-factp ((?p propiedad-receta))
        (and (eq ?p:nombre-receta ?n) (eq ?p:propiedad picante)))
    then (printout t "- Picante: si" crlf)
    else (printout t "- Picante: no" crlf))

  (if (any-factp ((?p propiedad-receta))
        (and (eq ?p:nombre-receta ?n) (eq ?p:propiedad sin-gluten)))
    then (printout t "- Sin gluten: si" crlf)
    else (printout t "- Sin gluten: no" crlf))

  (if (any-factp ((?p propiedad-receta))
        (and (eq ?p:nombre-receta ?n) (eq ?p:propiedad sin-lactosa)))
    then (printout t "- Sin lactosa: si" crlf)
    else (printout t "- Sin lactosa: no" crlf))

  (printout t "- Calorias: " ?cal crlf)
  (printout t "- Digestion: " ?dig crlf)

  (printout t "- Ingredientes principales/relevantes: ")
  (bind ?hay-relevantes FALSE)
  (do-for-all-facts ((?ir ingrediente-relevante)) (eq ?ir:nombre-receta ?n)
    (bind ?hay-relevantes TRUE)
    (printout t ?ir:nombre-ingrediente "; "))
  (if (eq ?hay-relevantes FALSE) then
    (printout t "(ninguno detectado)"))
  (printout t crlf)

  (assert (receta-reportada (nombre-receta ?n)))
)
