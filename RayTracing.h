
/* Parámetros de la Simulación */
struct RT_parametros{
   bool registrar_recorrido; //si es true se guarda una lista de los rebotes
   unsigned int max_rebotes; //abortar la simulación si llega a este número de rebotes

   unsigned int dims;        //número de dimensiones

   gsl_vector_long_double *dir_inicial; //vector unitario, o nulo

   double radio_cuerpo;      //radio de los átomos
   double radio_estrella;    //radio de la estrella
   gsl_matrix *cuerpos;      //lista de coordenadas de los centros de los átomos
}

//template para que el usuario modifique:
struct RT_parametros RT_default_params = { 
   .registrar_recorrido = false;
   .max_rebotes = 1000;

   .dims = 0;           //no modificar esto da error

   .dir_inicial = NULL; //se elige una dirección aleatoria

   .radio_cuerpo = 0;   //no modificar esto da error
   .radio_estrella = 0; //no modificar esto da error
   .cuerpos = NULL;     //no modificar esto da error
}; 

/* Resultados de la Simulación */
struct RT_resultados{
   bool exito;            //true si el rayo salió de la estrella, false si no

   unsigned int rebotes;  //cuantas veces rebotó
   long double distancia; //distancia recorrida

   time_t t_elapsed;      //tiempo que tomó la simulación
}