#include "RayTacing.h"

/* Variables de la Simulación */

static bool registrar_recorrido;            //si es true guardamos una lista de los rebotes
static unsigned int max_rebotes;            //abortar la simulación si llega a este número de rebotes

static unsigned int dims;                   //número de dimensiones
static gsl_vector_long_double *dir_inicial; //vector unitario, o nulo
static gsl_matrix *cuerpos;                 //lista de coordenadas de los centros de los átomos

static double radio_cuerpo;                 //radio de los átomos
static double radio_estrella;               //radio de la estrella

static gsl_vector_long_double *pos;         //posición actual del rayo
static gsl_vector_long_double *dir;         //dirección actual del rayo (vector unitario)

unsigned int rebotes;                       //cuantas veces rebotamos hasta ahora
long double distancia;                      //distancia recorrida hasta ahora
