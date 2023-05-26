#include "RayTacing.h"
#include <tgmath.h>
#include <stdio.h>

/* Variables de la Simulación */

static bool hemosidoconfigurados = false;   //indica si la simulación está configurada
static bool use_random_dir;                 //indica si hay que elegir una dirección aleatoria

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

static void alocar_vectores (unsigned int d); //aloca los vectores, con tamaño d
__attribute__((destructor))
static void free_vectores ();                 //libera los vectores

static void escribir_pos();                   //escribe la posición en recorrido

static void correr_simulacion ();             //corre la simulación y deja los resultados en
                                              //data, excepto exito y dir_inicial.

static void primera_interseccion ();          //actualiza dist y centro_interseccion
static void avanzar_dist ();                  //avanza una distancia dist en la dirección actual
static void rebotar (gsl_vector *centro);     //rebota contra un cuerpo con el centro dado


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
   if (!hemosidoconfigurados || params.dims != dims){
      alocar_vectores(params.dims);
   }
   
   //desempacamos los datos
   registrar_recorrido = params.registrar_recorrido;
   recorrido_filename = params.recorrido_filename;
   
   max_rebotes = params.max_rebotes;
   dims = params.dims;
   
   centros = params.centros;
   radio_cuerpo = params.radio_cuerpo;
   radio_estrella = params.radio_estrella;
      
   use_random_dir = params.dir_inicial == NULL;
   if (!use_random_dir){
      gsl_vector_memcpy(data.dir_inicial, params.dir_inicial);
   }
      
   //listo
   hemosidoconfiguraos = true;
}

struct RT_resultados RT_simular(){
   
   //vemos que la cosa esté configurada
   if (!hemosidoconfigurados){
      puts("ERROR: RT_simular: No se configuró la simulación.");
      exit(1);
   }
   
   //seteamos la dirección inicial
   if (use_random_dir){
      gsl_ran_dir_nd(generador, dims, data.dir_inicial->data); //falta hacer el generador
   }
   gsl_vector_memcpy(dir, data.dir_inicial);
   
   //seteamos la posición inicial
   gsl_vector_set_zero(pos);
   
   //ponemos en cero las métricas
   rebotes = 0;
   distancia_rec = 0;
   
   //abrimos el archivo para el recorrido
   if (registrar_recorrido){
      recorrido = fopen(recorrido_filename, "w");
   }
   
   //corremos la simulación
   correr_simulacion();
   
   //cerramos el archivo del el recorrido
   if (registrar_recorrido){
      fclose(recorrido);
   }
   
   //y finalmente reportamos los resultados
   data.exito = rebotes < max_rebotes;
   return data;   
}






