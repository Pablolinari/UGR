#import "@preview/basic-resume:0.2.9": *
// Información personal
#let name = "Pablo Linari Pérez"
#let email = "linariperez@gmail.com"
#let github = "github.com/Pablolinari"
#let linkedin = "linkedin.com/in/Pablolinari"
#let phone = "+34 674668690"
#let personal-site = "stuxf.dev"

#show: resume.with(
  author: name,
  email: email,
  github: github,
  linkedin: linkedin,
  phone: phone,
  personal-site: personal-site,
  accent-color: "#26428b",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)
#place(
  top +right,
  dx: 0pt,
  dy: -15pt,
image("imagen.jpg",width: 2.5cm)
)
#set text(size: 9pt)
/*
* Las líneas que empiezan con == se formatean como encabezados de sección
* Puedes usar las funciones de formato específicas si lo necesitas
* Las siguientes funciones de formato están disponibles:
* #edu(dates: "", degree: "", gpa: "", institution: "", location: "", consistent: false)
* #work(company: "", dates: "", location: "", title: "")
* #project(dates: "", name: "", role: "", url: "")
* certificates(name: "", issuer: "", url: "", date: "")
* #extracurriculars(activity: "", dates: "")
* También hay funciones genéricas que no aplican formato:
* #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
* #generic-one-by-two(left: "", right: "")
*/
== Educación

#edu(
  institution: "Universidad de Granada",
  location: "Granada, España",
  dates: dates-helper(start-date: "Sep 2022", end-date: "presente (cuarto año)"),
  degree: "Doble Grado en Ingeniería Informática y Matemáticas",

  // Descomenta la línea siguiente si quieres que el formato de educación sea consistente con el resto
  // consistent: true
)
- Asignaturas relevantes: Inteligencia Artificial, Aprendizaje Automático, Estructuras de Datos, Programación Orientada a Objetos, Programación Concurrente y Paralela, Metaheurísticas, Probabilidad y Estadística, Análisis Matemático, Modelos Matemáticos, Ecuaciones Diferenciales, Geometría.
#edu(
  institution: "Colegio Inmaculada Niña",
  location: "Granada, España",
  dates: dates-helper(start-date: "Sep 2020", end-date: "Jun 2022"),
  degree: "Bachillerato Ciencias Tecnológicas",

  // Descomenta la línea siguiente si quieres que el formato de educación sea consistente con el resto
  // consistent: true
)
- Obtuve una nota media de 9.8/10 en el Título de Bachiller en Ciencias Tecnológicas.
#edu(
  institution: "Federación Española de Rugby",
  location: "Granada, España",
  dates: dates-helper(start-date: "2021"),
  degree: "Técnico Deportivo, Jugador de rugby de alto rendimiento",

  // Descomenta la línea siguiente si quieres que el formato de educación sea consistente con el resto
  // consistent: true
)
- Formación en entrenamiento de rugby, planificación de eventos deportivos y primeros auxilios en el deporte.
#edu(
  institution: "Conservatorio Profesional de Música Ángel Barrios",
  location: "Granada, España",
  dates: dates-helper(start-date: "2013", end-date: "2020"),
  degree: "Músico",

  // Descomenta la línea siguiente si quieres que el formato de educación sea consistente con el resto
  // consistent: true
)
- Estudié percusión durante varios años y participé en diversas bandas de música.



== Experiencia Laboral

#work(
  title: "Entrenador de rugby",
  location: "Granada, España",
  company: "Universidad de Granada",
  dates: dates-helper(start-date: "Sep 2021", end-date: "Jul 2024"),
)
- Categorías de 4 a 16 años.
- Organización de sesiones de entrenamiento, competiciones y eventos de rugby.

#work(
  title: "Recepcionista",
  location: "Tau, Noruega",
  company: "Vaulali Hostel",
  dates: dates-helper(start-date: "Jun 2022", end-date: "Sep 2022"),
)
- Orientación turística, asignación de habitaciones y mantenimiento exterior del hotel.

== Proyectos

#project(
  name: "Ai Rescuers",
  // Las fechas son opcionales
  dates: dates-helper(start-date: "Feb 2025", end-date: "Abr 2025"),
  // La URL también es opcional
)
- Desarrollé un agente de IA para la asignatura de Inteligencia Artificial utilizando algoritmos A\* y Dijkstra. El sistema optimiza la búsqueda de rutas para completar objetivos de misión minimizando el gasto de energía y cumpliendo restricciones de tiempo estrictas.
- Durante el desarrollo del proyecto, evaluamos varias heurísticas y técnicas de mapeo para optimizar el escaneo del terreno en el entorno virtual.

#project(
  name: "Parcheckers",
  // Las fechas son opcionales
  dates: dates-helper(start-date: "Abr 2025", end-date: "Jun 2025")
)
- Desarrollé un agente de IA para un curso de Inteligencia Artificial, implementando variantes del algoritmo Minimax con técnicas avanzadas de poda y heurísticas personalizadas. El sistema optimiza la toma de decisiones en un juego de mesa competitivo para dos jugadores que involucra tiradas de dados y restricciones de movimiento.
== Voluntariado
#work(
  title: "Santuario Marino Muala",
  location: "Nacala, Mozambique",
  dates: "Verano 2024",
)
- El objetivo principal del voluntariado es reconstruir la barrera de coral de la Bahía de Nacala y ayudar a las comunidades locales a encontrar una dieta sostenible sin dañar el medio ambiente.
#work(
  title: "Hygee Farm",
  location: "Quang Nam, Vietnam",
  dates: "Verano 2023",
)
- Voluntariado en una granja sostenible en un pueblo rural de Vietnam, sumergiéndome en la auténtica cultura y costumbres vietnamitas a través de comidas, vida cotidiana, paisajes tradicionales y una fiesta de boda.
- Colaboré con otros 10 voluntarios internacionales, adquiriendo experiencia en la construcción de relaciones y el trabajo con personas de diversos orígenes y diferentes grupos de edad.



// #extracurriculars(
//   activity: "Voluntariado en Olimpiada de Ciencias",
//   dates: "Sep 2023 --- Presente"
// )
// - Voluntario y redactor de pruebas para torneos, incluyendo LA Regionals y SoCal State \@ Caltech

// #certificates(
//   name: "OSCP",
//   issuer: "Offensive Security",
//   // url: "",
//   date: "Oct 2024",
// )

== Habilidades
- *Lenguajes de programación*: C++, Python, Java, Bash, SQL, Ruby.
- *Tecnologías*: Git, UNIX, Pytorch, Matplotlib, scikit-learn, Pandas.
- *Idiomas*: Certificado C1 Cambridge de inglés, español nativo.
