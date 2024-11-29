#include "MyGSLRandom.h"
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <time.h>

/* Nuestro generador */
gsl_rng *random_generador = NULL;

/* Init, Seed & Free */
__attribute__((constructor))
void _random_init (){   
   struct timespec t;
   clock_gettime (CLOCK_MONOTONIC, &t);

   _random_init_seed(t.tv_sec+t.tv_nsec);
}

void _random_init_seed (unsigned long int seed){
   //si ya había un generador, hay que liberarlo
   if (random_generador != NULL){
      gsl_rng_free(random_generador);
   }
   
   random_generador = gsl_rng_alloc (gsl_rng_mt19937); //este es el que viene por default
   gsl_rng_set(random_generador, seed);
}

__attribute__((destructor))
static void _random_free (){
   gsl_rng_free(random_generador);
}


/* Distribuciones Uniformes */

int random_uniform_int (int min, int max){
   return min + gsl_rng_uniform_int(random_generador, max-min);
}

double random_uniform_double (double min, double max){
   return gsl_ran_flat(random_generador, min, max);
}

void random_fill_vector_int (gsl_vector_int *dest, int min, int max){
   for (int i = dest->size-1; i>=0; i--){
      gsl_vector_int_set(dest, i, random_uniform(min, max));
   }
}

void random_fill_vector_double (gsl_vector *dest, double min, double max){
   for (int i = dest->size-1; i>=0; i--){
      gsl_vector_set(dest, i, random_uniform(min, max));
   }
}

void random_fill_vector_ldouble (gsl_vector_long_double *dest, double min, double max){
   for (int i = dest->size-1; i>=0; i--){
      gsl_vector_long_double_set(dest, i, random_uniform(min, max));
   }
}


/* Dirección Aleatoria */

void random_direction (gsl_vector *v){
   gsl_ran_dir_nd(random_generador, v->size, v->data);
}