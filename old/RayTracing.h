#include <stdbool.h>
#include <time.h>

#define HAVE_INLINE
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>


/* Un par de estructuras para que sea más facil intercambiar datos */

struct RT_parametros{
   bool registrar_recorrido;            //indica si hay que guardar el recorrido
   const char *recorrido_filename;      //donde escribir el recorrido

   unsigned int max_rebotes;            //abortar la simulación si llega a este número de rebotes

   unsigned int dims;                   //número de dimensiones

   const gsl_vector *dir_inicial;       //vector unitario, o NULL

   gsl_matrix *centros;           //lista de coordenadas de los centros de los cuerpos 
   double radio_cuerpo;                 //radio de los átomos
   double radio_estrella;               //radio de la estrella
};

struct RT_resultados{
   bool exito;                          //true si el rayo salió de la estrella, false si no

   unsigned int rebotes;                //cuantas veces rebotó
   long double distancia;               //distancia recorrida

   gsl_vector_view dir_inicial;         //dirección inicial simulada. no modificar.

   time_t t_elapsed;                    //tiempo que tomó la simulación (segundos)
};


/* Funciones de la API */

void RT_configurar(struct RT_parametros params); //configura la simulación con los parámetros dados

struct RT_resultados RT_simular();               //corre la simulación y devuelve los resultados.
                                                 //guarda el recorrido en filename si corresponde


