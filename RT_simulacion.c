#include "RayTacing.h"

/* Variables de la Simulación */

static bool hemosidoconfigurados = false;   //bandera que indica si la simulación está configurada
static bool use_random_dir;                 //bandera que indica si hay que elegir una dirección aleatoria

static bool registrar_recorrido;            //si es true guardamos una lista de los rebotes
static unsigned int max_rebotes;            //abortar la simulación si llega a este número de rebotes

static unsigned int dims;                   //número de dimensiones
static gsl_matrix *cuerpos;                 //lista de coordenadas de los centros de los átomos

unsigned static double radio_cuerpo;        //radio de los átomos
unsigned static double radio_estrella;      //radio de la estrella

static gsl_vector_long_double *pos;         //posición actual del rayo
static gsl_vector_long_double *dir;         //dirección actual del rayo (vector unitario)
static gsl_matrix *franja;                  //lista de los cuerpos con los que interseca el rayo

struct RT_resultados data;                  //info para delvolver al usuario
//estas definiciones son para no ensuciar
//el código pero usar la misma estructura
//como variables internas.
#define rebotes       data.rebotes          //cuantas veces rebotamos hasta ahora       
#define distancia_rec data.distancia        //distancia recorrida hasta ahora
#define recorrido     data.recorrido        //Lista de puntos por donde pasó el rayo, o NULL
#define t_elapsed     data.t_elapsed        //tiempo que tomó la simulación


/* Funciones de la Simulación */

static void correr_simulacion(){

   long double dist;                //distancia hasta la próxima intersección
   gsl_vector *centro_interseccion; //centro del (primer) cuerpo con el que interseca el rayo

}