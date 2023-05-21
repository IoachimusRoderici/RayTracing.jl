#include "RayTacing.h"

/* Variables de la Simulación */

static gsl_vector_long_double *pos; //posición actual del rayo
static gsl_vector_long_double *dir; //dirección actual del rayo (vector unitario)

static struct RT_parametros config; //parámetros pasados por el usuario
static struct RT_resultados data;   //información que devolver al usuario