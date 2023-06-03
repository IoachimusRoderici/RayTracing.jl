#include <stdbool.h>
#include <time.h>

#define HAVE_INLINE
#include <gsl/gsl_vector.h>


/* Parámetros de la Simulación */

struct RT_parametros{
   bool registar_recorrido;             //indica si hay que guardar el recorrido
   char *recorrido_filename;            //donde escribir el recorrido

   unsigned int max_rebotes;            //abortar la simulación si llega a este número de rebotes

   unsigned int dims;                   //número de dimensiones

   gsl_vector_double *dir_inicial;      //vector unitario, o NULL

   gsl_matrix *centros;                 //lista de coordenadas de los centros de los cuerpos 
   unsigned double radio_cuerpo;        //radio de los átomos
   unsigned double radio_estrella;      //radio de la estrella
}

//template para que el usuario modifique:
struct RT_parametros RT_default_params = { 
   .registar_recorrido = false;
   .recorrido_filename = NULL;

   .max_rebotes = 1000;

   .dims = 0;                           //no modificar esto da error

   .dir_inicial = NULL;                 //se elige una dirección aleatoria

   .radio_cuerpo = 0;                   //no modificar esto da error
   .radio_estrella = 0;                 //no modificar esto da error
   .centros = NULL;                     //no modificar esto da error
}; 

/* Resultados de la Simulación */

struct RT_resultados{
   bool exito;                          //true si el rayo salió de la estrella, false si no

   unsigned int rebotes;                //cuantas veces rebotó
   unsigned long double distancia;      //distancia recorrida

   gsl_vector *dir_inicial;             //dirección inicial simulada
                                        //no tenés propiedad de este vector, tirate un memcpy.

   time_t t_elapsed;                    //tiempo que tomó la simulación (segundos)
}


/* Funciones de la API */

void RT_configurar(struct RT_parametros params); //configura la simulación con los parámetros dados

struct RT_resultados RT_simular();               //corre la simulación y devuelve los resultados.
                                                 //guarda el recorrido en filename si corresponde


