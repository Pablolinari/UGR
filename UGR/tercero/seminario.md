devops se asocia a  equipos de 
ingenieros especializados 

como surge : por dos cosas solucionar el tiempo que se tarda desde que una org it concibe una idea hasta que se lleva a produccion , se plantea por que tarda tanto 
y por que ya existe en la ind it movimientos culturales muy parecidos .

Service delivery per line : flujo de liveracion de servicions , como se generan los nuevos servicios , se siqge el diagrama 

Deployment liead time :tiempo que se tarda en desplegar , consiste cuando la gente de desarrollo lo despliega para que lo usen los clientes finales ,¿ cuanto estamos tardando ?

Por que tarda tanto?: dos causas principales , la transferencia de responsabilidades 
Primera causa : (habia una entrega y se iban , estaria mal documentado o mal estructurado , mucha desconfianza entre los equipos ),hay confrontamiento entre los op y los dev , los de op se encargan de la esta Lo solucionamos con equipos multidisciplinares , que tengan todas la habilidades para desarrollar y mantener el sistema de esta manera no hay transferencia de responsabilidad , hace que la gente se comprometa.

segunda causa : falta de automatizacion y muchos procesos manuales propenso a errores , solucion automatizar . Ventajas de automatizar : tardas menos , y REDUCES LOS ERRORES , una vez que progrmamos un script siempre se ejecuta igual por tanto mas facil de detectar errores y al ser software se puede evolucionar con el tiempo.




empiezan a surgir empresas que hacen muchos despliegues gracias a la automatizacion (test y continuos integration )

--------------------------------------------------

DevOps es un movimiento no centralizado y es no normativo , nadie te dice como lo deves hacer 

?funciona¿ : principales motivos de devops , tomar medidas de cosas para ver si funciona , hay muchas empresas que usan devops ya que la idea es lanzar la idea antes que los competidores . Las empresas que usan devops mejoran sus estadisticas .

-------------Metricas --------------------
En devops se hace mucho incapie en las metricas 
lo interesante es la tendencia no el valor  puntual 
las 4 metricas son muy buenos predictores de la calidad y la velocidad de despliegue de un equipo .

Deploymen lead time : desde que hacemos un cambio hasta que esta en produccion . 

Deployment frecuency : frecuencia de despliegue por dia , mes o anio . 

MeanTimetoTorestore : indica el tiempo que tarmdamos en recuperar el sistema una vez se produce un bug . 

Change fail ratio : numero de errores que se producen cada vez que hacemos un cambio . 

-------Como Se miden ------- 
Con plataformas de monitorizacion 

------Automatizacion -----
contiunuos delivery : hago un commit a main y llega a produccion 
integracion continua:busca que que cuando haga el commit (merge) se realicen una serie de operaciones que garanticen que el cambio es correcto(esta testeado) y se instala en los servidores de la compania internos , es decir esta disponibel(entra en los servidores de la compañia ) esta para que otros equipos la puedan usar . Todo interni nada externo.

el crecimiento del coste es exponencial , cuanto mas tarde mezclo mas me cuesta . nos interesa hacerlo todos los dias al menos una vez al dia , es muy dificil 


--------------Test Automaticos --------------------
ver robert cmartin

Beneficios : los desarrolladores podemos validar el trabajo . Reducen el coste en control de calidad.



------------motores ic 

ejecutan una serie de tareas para garantizar que se hacen los tests correctamente.
Se lanmza por cada merge que se hace 


Site realibility -------
la usa google , es un devops pero con normas , muy enfocado a administracion  


metricas SRE : 

latencia : tiempo que se tarda en revisar algo 

Trafico : numero de peticiones por segundo/hora/dia
Errores: cuantas peticiones producen errores 
Saturacion : porcentaje de uso en este momento del sistema respecto  a su maximo .
















