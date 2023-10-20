#include "celdas.h"
/**
 * Uso el struct pos para poder identificar las posiciones de la celda en un solo dato
 * @brief indica la posicion de una celda
 * @pre @a i >0
 * @pre @a j >0
 *
 */
struct pos
{
    int i;
    int j;
};
class sudoku
{
private:
    Celdas sudoku[9][9];

public:
    /**
     * Devuelve la casilla que esta rodeada por el minimo numero de casillas y que este vacia , por ejemplo en un sudoku donde haya una sola casilla con una suma
     * y vacia escogera esa ya que solo va un numero alli , cuando las de un hueco estén llenas devolvera las de dos y asi sucesivamente .
     *
     * @brief Devuelve la casilla que está rodeada de menos cuadrados y que está vacia .
     * @return struc posicion que indica las coordenadas e la celda.
     *
     */
    pos MasPequenia();

    /**
     * Este metodo usa los metodos privados pertenececolumna y pertenecefila para comprobar si el numero
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
     * @brief indica el conjunto de celdas al que pertenece una celda dada
     * @param p posicion de la celda de la que se quiere averiguar su grupo
     * @param v vector de posiciones de las celdas que pertenecen al grupo
     * incluyendo a la de la posicion p en la primera posicion
     *
     */

    void conjuntoceldas(pos p, pos *v);

    /**
     * @brief indica el id del conjunto al que pertenece la celda
     *
     * @param p posicion de la celda
     * @return int con el valor del id
     */
    int get_id_conjunto(pos p);

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
     * @brief inserta un numero en la  matriz en la posicion indicada 
     * @param num numero que se quiere insertar 
     * @pre @a num > 0
     * @param p posicion en la que se va a insertar el numero
     * 
     */

    void set_num(int num ,pos p);

private:
    /**
     * Como indica el juego del sudoku un numero puede estar en una fila si no se repite por lo que el metodo
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
     * Como indica el juego del sudoku un numero puede estar en una columna si no se repite por lo que el metodo
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