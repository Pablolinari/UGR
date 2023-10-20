class Celdas
{
private:
    int suma;
    int id;

public:

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
    void set_id(pos p);

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
    void set_suma(int sum , int id);


    /**
     * @brief devuelve el ide de una celda 
     * @return id de la celda 
     * 
     */

    int get_id();

    /**
     * @brief establece el valor del id de la celda 
     * @param id id de la celda 
     * @pre @a id > 0
     * 
     */


};

