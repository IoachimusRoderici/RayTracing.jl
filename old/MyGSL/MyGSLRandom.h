#ifndef MyGSLRandom
#define MyGSLRandom

#ifdef MyGSLRandom_need_gen
#include <gsl/gsl_rng.h>
extern gsl_rng *random_generador;
#endif

#include <gsl/gsl_vector.h>

// random_init (seed=time)
#define random_init(...) _random_init ## __VA_OPT__(_seed) (__VA_ARGS__)
void _random_init_seed(unsigned long int seed);
void _random_init();
/* Inicializa la generación de números aleatorios con una nueva semilla.
   Si la semilla no se especifica, se usa el tiempo como semilla.
   No es necesario llamarla porque está definida como constructora.
*/

// Distribuciones Uniformes

int    random_uniform_int    (   int min,    int max);
double random_uniform_double (double min, double max);
#define random_uniform(min, max)  _Generic((min),\
      int : random_uniform_int                  ,\
   double : random_uniform_double               )(min, max)
// Devuelven un número con distribución uniforme en el intervalo [min, max).

void random_fill_vector_int     (gsl_vector_int         *dest,    int min,    int max);
void random_fill_vector_double  (gsl_vector             *dest, double min, double max);
void random_fill_vector_ldouble (gsl_vector_long_double *dest, double min, double max);
#define random_fill_vector(dest, min, max)  _Generic((dest),\
   gsl_vector_int         * : random_fill_vector_int       ,\
   gsl_vector             * : random_fill_vector_double    ,\
   gsl_vector_long_double * : random_fill_vector_ldouble   )(dest, min, max)
// Ponen un valor con distribución uniforme en el intervalo [min, max) en cada componente de `dest`.


/* Dirección Aleatoria */
void random_direction (gsl_vector *v);


#endif //MyGSLRandom