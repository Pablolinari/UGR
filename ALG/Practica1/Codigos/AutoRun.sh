#!/bin/bash

# This Script executes de programs:
# opt variable for is the type of variable to execute (1 -> int , 2 -> float, 3 -> double)
# Then files is the executable files with O(n^2) complexity
# Then files2 is the executable files with O(nlogn) complexity
# If option "clean" is provided, the previous files are removed (CAUTION)
# Each file is executed with different sizes of data 5 times
# Once the files are executed, the python script AutoMedia.py is executed to get the average of the results
# The results are stored in the folder "Resultados"

# Option 1 to remove previous files if argument provided
if [ "$1" == "clean" ]; then
    rm -r Resultados
    rm -r Graficas
fi
mkdir Resultados
    

for ((opt=1; opt <= 3 ; ++opt)); do 

    files=("burbuja" "insercion" "seleccion")
    # files = ("fibonacci" "hanoi" "floyd" "heapsort" "insercion" "mergesort" "quicksort" "seleccion")
    

    for file in "${files[@]}"; do
        # Redireccion a archivo txt con los resultados con salto de linea tras cada archivo
        # printf "File: $file.cpp\n" >> $file.txt

        # Bucles principales de ejecucion-> i para el tamaño de los datos y j para el numero de ejecuciones
        for ((i=5000; i<=125000 ; i+=5000)) do
            printf "$i: \t\t" >> $file$opt.txt
            for ((j=1; j<=5 ; j++)) do
                # Ejecucion del programa y redireccion a archivo txt
                ./$file $i $opt >> $file$opt.txt            
                printf " " >> $file$opt.txt
            done
            printf "\n" >> $file$opt.txt
        done
    done



    for file in "${files[@]}"; do
        python3 AutoMedia.py $file$opt.txt output$file$opt.txt
    done

    # ALGORITMOS DE ORDENACION CON EFICIENCIA O(nlogn)----------------------------------------------

    files2=("mergesort" "quicksort")

    for file in "${files2[@]}"; do
        # Redireccion a archivo txt con los resultados con salto de linea tras cada archivo
        # printf "File: $file.cpp\n" >> $file.txt

        # Bucles principales de ejecucion-> i para el tamaño de los datos y j para el numero de ejecuciones
        for ((i=50000; i<=1250000 ; i+=50000)) do
            printf "$i: \t\t" >> $file$opt.txt
            for ((j=1; j<=5 ; j++)) do
                # Ejecucion del programa y redireccion a archivo txt
                ./$file $i $opt >> $file$opt.txt            
                printf " " >> $file$opt.txt
            done
            printf "\n" >> $file$opt.txt
        done
    done

    for file in "${files2[@]}"; do
        python3 AutoMedia.py $file$opt.txt output$file$opt.txt
    done


    mv *.txt ./Resultados
done

# Generación de gráficos con Gnuplot
mkdir Graficas
# Archivo de script de Gnuplot
cat << EOF > script_gnuplot.gp
# Configuración del gráfico
set xlabel "Tamaño de entrada"
set ylabel "Tiempo de ejecución"

EOF

# Bucle para generar gráficos para cada algoritmo y tipo de dato
for algorithm in "burbuja" "insercion" "seleccion" "mergesort" "quicksort"; do
    cat << EOF >> script_gnuplot.gp

# Algoritmo $algorithm

set title "Algoritmo - $algorithm"
plot "Resultados/output${algorithm}1.txt" using 1:2 with linespoints title "int", \
     "Resultados/output${algorithm}2.txt" using 1:2 with linespoints title "float", \
     "Resultados/output${algorithm}3.txt" using 1:2 with linespoints title "double"

# Guardar la gráfica en un archivo de imagen
set term png
set output "./Graficas/${algorithm}.png"
replot
EOF

# Ejecutar Gnuplot con el script generado
gnuplot script_gnuplot.gp

# Eliminar el script de Gnuplot
rm script_gnuplot.gp
done