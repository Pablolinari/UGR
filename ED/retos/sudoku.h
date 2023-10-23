#include "celdas.h"


/**
 * @struct Uso el struct pos para poder identificar las posiciones de la celda en un solo dato
 * 
 * @struct @brief indica la posicion de una celda
 * @struct @pre @a i >0
 * @pre @a j >0
 *
 */
struct pos
{
    int i;
    int j;
};
class Sudoku
{
private:
    Celda sudoku[9][9];

public:
    /** 
     * @brief constructor del sudoku , inicia el sudoku con el valor 0 en todas sus celdas.
    */
   Sudoku();
    /**
     * @brief inserta un numero en la  matriz en la posicion indicada 
     * @param num numero que se quiere insertar 
     * @pre @a num > 0
     * @param p posicion en la que se va a insertar el numero
     * 
     */

    void set_num(int num ,pos p);

        /**
     * @brief devuelve  el numero que se aloja en la celda indicada   
     * @param p posicion de la celda que se quiere saber el numero 
     * @return numero dado a la celda 
     * 
     */

    int get_num(pos p);

    /**
     * @details Los conjuntos de celdas están identificados por un id  , todas las celdas que tengan el mismo id pertenecen a un grupo . 
     * De esta manera se pueden identificar los conjuntos y asignarles el valor de su suma. 
     * @brief indica el conjunto de celdas al que pertenece una celda dada
     * @param p posicion de la celda de la que se quiere averiguar su grupo
     * @param v vector de posiciones de las celdas que pertenecen al grupo incluyendo a la de la posicion p en la primera posicion
     * @param i dimension del vector 
     * 
     *
     */

    void conjuntoceldas(pos p, pos *v , int i);

    /**
     * @brief indica el id del conjunto al que pertenece la celda
     *
     * @param p posicion de la celda
     * @return int con el valor del id
     */
    int get_id_conjunto(pos p);
    /**
     * @brief vector de posiciones del conjunto de casillas que tengan el mismo @a id 
     * 
     * @param id id del grupo que se quiere buscar 
     * @param p vector de salida con las posiciones de cada casilla que compone el grupo
     * @param i dimension del vector 
     * @pre id > 0
     */
    void get_conjunto(int id , pos * p , int i);

    /**
     * @brief Indica el valor que falta para completar la suma
     * @param id id del grupo que se quiere comprobar el resto
     * @pre @a id > 0
     * @return int con el valor del valor que falta para completar la suma
     */
    int resto(int id);
    /**
     * @brief Indica el valor de la suma de un conjunto de celdas 
     *
     * @param id ide del grupo que se quiere saber el valor de la suma 
     * @pre @a id > 0
     * @return int con el valor que debe tomar la suma  del grupo de casillas 
     */
    int get_suma(int id);
    /**
     * @brief devuelve el numero de casillas que componen al grupo con el mismo id  mas pequenio 
     * 
     * @return int con el numero de casillas que lo componen  
     */
    int grupomaspequenio();

    /**
     * @details la casilla que esta rodeada por el minimo numero de casillas y que este vacia , por ejemplo en un sudoku donde haya una sola casilla con una suma
     * y vacia escogera esa ya que solo va un numero alli , cuando las de un hueco estén llenas devolvera las de dos y asi sucesivamente .
     *
     * @brief Devuelve la casilla que está rodeada de menos cuadrados y que está vacia .
     * @return struc posicion que indica las coordenadas e la celda.
     *
     */
    pos MasPequenia();

    /**
     * @details Este metodo usa los metodos privados pertenececolumna y pertenecefila para comprobar si el numero
     * puede ir en la posicion indicada .
     * @brief indica si el @a num puede estar en la fila y columna  indicada
     * @param num numero que se desa comprobar
     * @param p posicion de la celda
     * @pre @a num > 0 
     * @return dato bool true si se puede insertar o false si no ;
     *
     */
    bool escorrecto(int num, pos p);


    /**
     * @details Este método utiliza los metodos anteriores escorrecto , get_suma y resto para calcular los posibles valores 
     * que podria tomar la casilla comprobando las filas y las columnas y calculando las posibles sumas .
     * @brief Calcula los posibles valores que podría adquirir una casilla .
     * 
     * @param p posicion de la celda en la que se quiere hacer el cálculo 
     * @param nums vector de enteros con todos los valores posibles que puede tomar la casilla  indicada 
     * @param i dimension del vector 
     */
    void posiblenum( pos p , int * nums , int i);

    /**
     * @details Este metodo se sirve de los anteriores para encontrar las posiciones donde podria encajar el numero indicado .
     * @brief Calcula todas las posiciones donde es posible que pueda ir un número dado 
     * @param num numero que se quiere comprobar 
     * @param p vector de posibles posiciones donde puede ir el valor @a num
     * @param i dimension del vector 
     *  
     */

    void posiblepos(int num, pos * p , int i);
    /**
     * @brief intercambia los valores de dos casillas .
     * @details esta funcion se aplica cuando el sudoku está bastante avanzado y un numero debe ser cambiado por otro por conveniencia de la situacion.
     * 
     * @param p posicion de la celda 1 
     * @param t posicion de la celda 2
     */
    void change(pos p ,pos t);
    
    /**  
     * @brief Resuelve el sudoku
     * @details Con los metodos anteriores se puede resolver el sudoku comprobando de la  siguiente forma cada numero que se asigne a una casilla
     * @details 1. buscar el conjunto de casillas mas pequeño .
     * @details 2. colocar un numero de los posiblesnums. 
     * @details 3. si se necesita cambiar un numero de ubicacion se pueden usar posiblepos y change para buscar una nueva celda al numero en caso de que impida seguir desarrollando por las opciones actuales que se presentan.
     * @details 4. buscar otra casilla que pertenezca al grupo mas pequenio posible 
     * @return Sudoku resuelto  
     */
    Sudoku solve();

private:
    /**
     * @brief inicia todas las celdas del sudoku con valor 0 , aquellas que tienen valor 0 se reconocen coo celdas vacías.
     * 
     */
    void iniciasudoku();


    /**
     * @details indica el juego del sudoku un numero puede estar en una fila si no se repite por lo que el metodo
     * comprobara si este numero está ya o no en la fila.
     * @brief indica si el @a num puede estar en la fila indicada
     * @param num numero que se desa comprobar
     * @param col fila en la que se quiere comprobar si el numero puede estar
     * @pre @a num > 0 @a fil >0
     * @return dato bool true si se puede insertar o false si no ;
     *
     */
    bool insertarfila(int num, int fil);

    /**
     * @details Como indica el juego del sudoku un numero puede estar en una columna si no se repite por lo que el metodo
     * comprobara si este numero está ya o no en la columna.
     * @brief indica si el @a num puede estar en la columna indicada
     * @param num numero que se desa comprobar
     * @param col columna en la que se quiere comprobar si el numero puede estar
     * @pre @a num > 0 @a col >0
     * @return dato bool true si se puede insertar o false si no ;
     *
     */
    bool insertarcolumna(int num, int col);
};