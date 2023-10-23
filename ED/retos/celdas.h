
class Celda
{
private:
    int valor;
    int suma;
    int id;

public:
    /**
     * @brief Construye una celda con los valores indicados 
     *
     * @param v valor de la celda 
     * @param s valor de la suma del conjunto al que pertenece 
     * @param id id del conjunto al que pertenece 
     */
    Celda (int v, int s, int id);
    /**
     * @brief Construye una celda con todos los valores iniciados a cero .
     * 
     */
    Celda ();

    /**
     * @brief devuelve el id de la celda
     * @return id de la celda
     *
     */
    int get_id();

    /**
     * @brief establece un id a la celda
     * @param p coordenadas de la celda ;
     *
     */
    void set_id();

    /**
     * @brief devuelve el valor de la suma del grupo al que pertenece la casilla
     * @return int con el valor de la suma del grupo de casillas
     *
     *
     */
    int get_suma();

    /**
     * @brief  establece el valor de la suma del grupo de casillas con el mismo id
     * @param sum valor de la suma
     * @param id id de las casillas que se deben asignar a la suma
     * @pre @a sum > 0 @a id > 0
     *
     */
    void set_suma(int sum, int id);
    /**
     * @brief devuelve el valor de la celda
     *
     * @return int que contiene el valor de la celda
     */
    int get_valor();

    /**
     * @brief atribuye un valor a la celda
     *
     */

    void set_valor();
};
