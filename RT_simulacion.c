#include "RayTacing.h"
#include <tgmath.h>
#include <stdio.h>

/* Variables de la Simulación */

static bool hemosidoconfigurados = false;   //indica si la simulación está configurada
static bool use_random_dir;                 //indica si hay que elegir una dirección aleatoria
static bool vectores_alocados = false;      //indica si los vectores están alocados

static bool registrar_recorrido;            //si es true guardamos una lista de los rebotes
static char *recorrido_filename;            //string con el nombre de archivo
static FILE *reccorrido;                    //archivo donde escribimos el recorrido

static unsigned int max_rebotes;            //abortar la simulación en este número de rebotes

static unsigned int dims;                   //número de dimensiones
static gsl_matrix *centros;                 //lista de coordenadas de los centros de los átomos

static unsigned double radio_cuerpo;        //radio de los átomos
static unsigned double radio_estrella;      //radio de la estrella

static gsl_vector *pos;                     //posición actual del rayo
static gsl_vector *dir;                     //dirección actual del rayo (vector unitario)

static unsigned long double dist;           //distancia hasta la primera intersección
static gsl_vector *centro_interseccion;     //centro del cuerpo con el que interseca

struct RT_resultados data;                  //info para delvolver al usuario
//estas definiciones son para no ensuciar
//el código pero usar la misma estructura
//como variables internas.
#define rebotes       data.rebotes          //cuantas veces rebotamos hasta ahora       
#define distancia_rec data.distancia        //distancia recorrida hasta ahora
#define t_elapsed     data.t_elapsed        //tiempo que tomó la simulación


/* Funciones de la Simulación */

static void alocar_vectores ();             //aloca los vectores, con tamaño dims

static void correr_simulacion ();           //corre la simulación y deja los resultados en data,
                                            //excepto exito y dir_inicial.

static void primera_interseccion ();        //actualiza dist y centro_interseccion
static void avanzar (double d);             //avanza una distancia d en la dirección actual
static void rebotar (gsl_vector *centro);   //rebota contra un cuerpo con el centro dado


/* Código de la API */

void RT_configurar(struct RT_parametros params){
   //vemos que los parámetros estén completos
   if (params.dims == 0 || params.centros == NULL || \
       params.radio_estrella == 0 || params.radio_cuerpo==0){
      puts("ERROR: RT_configurar: Hay parámetros inválidos.");
      exit(1);
   }
   
   //vemos que las dimensiones estén bien
   if (params.dims < 2){
      puts("ERROR: RT_configurar: No se puede simular en menos de dos dimensiones.");
      exit(1);
   }
   
   //si hace falta alocamos los vectores
   if (!vectores_alocados || params.dims != dims){
      alocar_vectores();
   }
   
   //desempacamos los datos
   max_rebotes = params.max_rebotes;
   registrar_recorrido = params.registrar_recorrido;
   dims = params.dims;
   radio_cuerpo = params.radio_cuerpo;
   radio_estrella = params.radio_estrella;
   centros = params.centros;
   
   use_random_dir = params.dir_inicial == NULL;
   data.dir_inicial = params.dir_inicial;
      
   //listo
   hemosidoconfiguraos = true;
}

struct RT_resultados RT_simular(){
   
   //vemos que la cosa esté configurada
   if (!hemosidoconfigurados){
      puts("ERROR: RT_simular: No se configuró la simulación.");
      exit(1);
   }
   
   //abrimos el archivo para el recorrido
   if (registrar_recorrido){
      recorrido = fopen(filename, "w");
   }
   
   //seteamos la dirección inicial
   if (use_random_dir){
      gsl_ran_dir_nd(generador, dims, data.dir_inicial->data); //falta hacer el generador
   }
   gsl_vector_memcpy(dir, data.dir_inicial);
}






