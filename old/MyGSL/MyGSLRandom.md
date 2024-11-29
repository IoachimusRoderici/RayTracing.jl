My GSL Random
=============

En `MyGSLRandom.h` y `MyGSLRandom.c` se definen funciones de conveniencia para inicializar toda
la cosa de `gsl_rng` y generar números y vectores con las distribuciones de siempre.

También se provee un generador, por si necesitás hacer cosas más elegantes:

```c
extern gsl_rng *random_generador;
```
Si necesitas usar esto, definí `MyGSLRandom_need_gen` y se va a incluír el generador y
`<gsl/gsl_rng.h>`.

Pero en general no es necesario usar el generador directamente sino a través de las siguientes funciones.

Funciones Disponibles
---------------------

```c
void random_init(unsigned long int seed)
void random_init()
```
Inicializa la generación de números aleatorios con una nueva semilla. Si la semilla no
se especifica, se toma del tiempo.
Es seguro llamarla más de una vez, y no es necesario llamarla porque está definida como
constructora.

```c
random_uniform(min, max)
int    random_uniform_int    (   int min,    int max);
double random_uniform_double (double min, double max);
```
Devuelven un número con distribución uniforme en el intervalo [min, max).
`random_uniform` es un macro que redirige los argumentos a la función que corresponda según
el tipo de `min`.

```c
random_fill_vector (min, max, dest)
void random_fill_vector_int     (gsl_vector_int         *dest,    int min,    int max);
void random_fill_vector_double  (gsl_vector             *dest, double min, double max);
void random_fill_vector_ldouble (gsl_vector_long_double *dest, double min, double max);
```
Ponen un valor con distribución uniforme en el intervalo [min, max) en cada componente de `dest`.
`random_fill_vector` es un macro que redirige los argumentos a la función que corresponda según
el tipo de `dest`.

```c
void random_direction (gsl_vector *v);
```
Pone en v un vector unitario con dirección aleatoria. El número de dimensiones se maneja automáticamente.