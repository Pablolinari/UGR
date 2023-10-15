cmake_minimum_required(VERSION 3.16)
project(practica2)

set(CMAKE_CXX_STANDARD 14)
set(BASE_FOLDER estudiante)

include_directories(${BASE_FOLDER}/include)
#add_library(imageio ${BASE_FOLDER}/src/imageio.cpp)
add_library(image ${BASE_FOLDER}/src/image.cpp ${BASE_FOLDER}/src/imageop.cpp ${BASE_FOLDER}/src/imageIO.cpp)

if (EXISTS ${CMAKE_SOURCE_DIR}/${BASE_FOLDER}/src/negativo.cpp)
add_executable(negativo ${BASE_FOLDER}/src/negativo.cpp)
target_link_libraries(negativo LINK_PUBLIC image)
endif()

if (EXISTS ${CMAKE_SOURCE_DIR}/${BASE_FOLDER}/src/subimagen.cpp)
add_executable(subimagen ${BASE_FOLDER}/src/subimagen.cpp)
target_link_libraries(subimagen LINK_PUBLIC image)
endif()

if (EXISTS ${CMAKE_SOURCE_DIR}/${BASE_FOLDER}/src/zoom.cpp)
add_executable(zoom ${BASE_FOLDER}/src/zoom.cpp)
target_link_libraries(zoom LINK_PUBLIC image)
endif()

if (EXISTS ${CMAKE_SOURCE_DIR}/${BASE_FOLDER}/src/icono.cpp)
add_executable(icono ${BASE_FOLDER}/src/icono.cpp)
target_link_libraries(icono LINK_PUBLIC image)
endif()

if (EXISTS ${CMAKE_SOURCE_DIR}/${BASE_FOLDER}/src/contraste.cpp)
add_executable(contraste ${BASE_FOLDER}/src/contraste.cpp)
target_link_libraries(contraste LINK_PUBLIC image)
endif()

if (EXISTS ${CMAKE_SOURCE_DIR}/${BASE_FOLDER}/src/barajar.cpp)
add_executable(barajar ${BASE_FOLDER}/src/barajar.cpp)
target_link_libraries(barajar LINK_PUBLIC image)
endif()

