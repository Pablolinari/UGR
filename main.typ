#import "@preview/basic-resume:0.2.9": *
// Put your personal information here, replacing mine
#let name = "Pablo Linair Pérez"
#let email = "linariperez@gmail.com"
#let github = "github.com/Pablolinari"
#let linkedin = "linkedin.com/in/Pablolinari"
#let phone = "+34 674668690"
#let personal-site = "stuxf.dev"

#show: resume.with(
  author: name,
  // All the lines below are optional.
  // For example, if you want to to hide your phone number:
  // feel free to comment those lines out and they will not show.
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

#set text(size: 9pt)
/*
* Lines that start with == are formatted into section headings
* You can use the specific formatting functions if needed
* The following formatting functions are listed below
* #edu(dates: "", degree: "", gpa: "", institution: "", location: "", consistent: false)
* #work(company: "", dates: "", location: "", title: "")
* #project(dates: "", name: "", role: "", url: "")
* certificates(name: "", issuer: "", url: "", date: "")
* #extracurriculars(activity: "", dates: "")
* There are also the following generic functions that don't apply any formatting
* #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
* #generic-one-by-two(left: "", right: "")
*/
== Education

#edu(
  institution: "University of Granada",
  location: "Granada, Spain",
  dates: dates-helper(start-date: "Sep 2022", end-date: "present (fourth year) "),
  degree: "Double degree in Computer science and Math ",

  // Uncomment the line below if you want edu formatting to be consistent with everything else
  // consistent: true
)
- Relevant Coursework:Artificial intelligence , Machine Learning , Data structures , Object oriented programming,Concurrent and Parallel programming , Metaheuristics , Probability and statistics , Mathemathical Analysis , Mthematical Models , Diferential ecuations , Geometry.
#edu(
  institution: "Colegio inmacuadad Niña",
  location: "Granada, Spain",
  dates: dates-helper(start-date: "Sep 2022", end-date: "Jun 2022"),
  degree: "Bachillerato Ciencias Tecnológicas ",

  // Uncomment the line below if you want edu formatting to be consistent with everything else
  // consistent: true
)
- Attained an average grade 9.8/10 in the Título de Bachiller in  Technological Sciences  (school diploma).
#edu(
  institution: "Federación Española de Rugby ",
  location: "Granada, Spain",
  dates: dates-helper(start-date: " 2021"),
  degree: "Sports technician , High-performance rugby player",

  // Uncomment the line below if you want edu formatting to be consistent with everything else
  // consistent: true
)
- Formed in rugby coaching  , sports event planning and first aid  in sports.
#edu(
  institution: "Conservatorio Profesional de Música Ángel Barrios",
  location: "Granada, Spain",
  dates: dates-helper(start-date: " 2013",end-date: "2020"),
  degree: "Musician",

  // Uncomment the line below if you want edu formatting to be consistent with everything else
  // consistent: true
)
- Studied percussion for several years and participated in various wind bands . 



== Work Experience

#work(
  title: "Rugby coach",
  location: "Granada , Spain",
  company: "University of Granada",
  dates: dates-helper(start-date: "Sep 2021", end-date: "Jul 2024"),
)
- Categories from 4 to 16 years.
- Organization of training sessions, competitions, and rugby events.

#work(
  title: "Recepcionist",
  location: "Tau , Norway",
  company: "Vaulali Hostel",
  dates: dates-helper(start-date: "Jun 2022", end-date: "Sep 2022"),
)
- Tourist orientation, room assignment, and exterior maintenance of the hotel.

== Projects

#project(
  name: "Ai Rescuers",
  // Dates is optional
  dates: dates-helper(start-date: "Feb 2025", end-date: "Apr 2025"),
  // URL is also optional
)
- Developed an AI agent for the Artificial Intelligence subject using A\* and Dijkstra algorithms. The system optimizes pathfinding to complete mission objectives by minimizing energy waste and adhering to strict time constraints.
- Throughout the project’s development, we evaluated several heuristics and mapping techniques to optimize terrain scanning in the virtual environment.

#project(
  name: "Parcheckers",
  // Dates is optional
  dates: dates-helper(start-date: "Apr 2025", end-date: "Jun 2025")
)
- Developed an AI agent for an Artificial Intelligence course, implementing Minimax algorithm variants with advanced pruning techniques and custom heuristics. The system optimizes decision-making in a competitive two-player board game involving dice rolls and movement constraints.
== Volunteering 
#work(
  title: "Muala Marine Sanctuary",
  location: "Nacala, Mozambique",
  dates: "Summer 2024",
)
- The main goal of the volunteering is to rebuild the coral barrier of Nacala Bay and help the local communities to find a sustainable diet  without harming the environment. 
#work(
  title: "Hygee Farm ",
  location: "Quang Nam, Vietnam",
  dates: "Summer 2023",
)
- Volunteered at a sustainable farm in a countryside village in Vietnam, immersing myself in authentic Vietnamese culture and customs through meals, daily life, traditional landscape and a wedding party.
- Collaborated with 10 other international volunteers, gaining experience in building relationships and working with people from diverse backgrounds and different age groups.



// #extracurriculars(
//   activity: "Science Olympiad Volunteering",
//   dates: "Sep 2023 --- Present"
// )
// - Volunteer and write tests for tournaments, including LA Regionals and SoCal State \@ Caltech

// #certificates(
//   name: "OSCP",
//   issuer: "Offensive Security",
//   // url: "",
//   date: "Oct 2024",
// )

== Skills
- *Programming Languages*:C++, Python, Java, Bash, SQL, Ruby.
- *Technologies*: Git, UNIX, Pytorch, Matplotlib, scikit-learn ,Pandas.
- *Language skills*:  C1 Cambridge English certificate , Spanish.
