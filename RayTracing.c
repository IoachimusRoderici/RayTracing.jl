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
static unsigned double radio_cuerpo2;       //radio_cuerpo al cuadrado
static unsigned double radio_cuerpo_inv;    // = 1/radio_cuerpo
static unsigned double radio_estrella;      //radio de la estrella

static gsl_vector *pos;                     //posición actual del rayo
static gsl_vector *dir;                     //dirección actual del rayo (vector unitario)

static unsigned long double dist;           //distancia hasta la primera intersección
static gsl_vector_view *centro_intersec;    //centro del cuerpo con el que interseca
static gsl_vector *aux_vector;              //vector auxiliar para algunas funciones

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
static void rebotar_centro_intersec ();       //rebota contra el cuerpo de centro_intersec


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
   radio_cuerpo2 = radio_cuerpo*radio_cuerpo;
   radio_cuerpo_inv = 1.0/radio_cuerpo;
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

/* Código de la simulación */

static void alocar_vectores (unsigned int d){
   /* Aloca todos los vectores que usa la simulación, con d dimensiones.
      Si ya están alocados, los libera y los vuelve a alocar.
   */
   
   //si ya están alocados los liberamos
   if (hemosidoconfigurados){
      free_vectores();
   }
   
   //luego los alocamos
   pos = gsl_vector_alloc(d);
   dir = gsl_vector_alloc(d);
   ector_aux = gsl_vector_alloc(d);
}

__attribute__((destructor))
static void free_vectores (){
   /* libera todos los vectores que usa la simulación */
   
   //esto es para ver que ande
   puts("Liberando los vectores...");
   
   gsl_vector_free(pos);
   gsl_vector_free(dir);
   gsl_vector_free(vector_aux);
}

static void escribir_pos (){
   /* Escribe pos en el archivo recorrido, en formato csv.
      No la llames si no se está registrando el recorrido.
   */
   
   for (int i = 0; i<dims-1; i++){
      fprintf(recorrido, "%lf, ", gsl_vector_get(pos, i));
   }
   fprintf(recorrido, "%lf\n", gsl_vector_get(pos, dims-1));
}

static void correr_simulacion (){
   /* Corre la simulación.
      Es una extracción de RT_simular.
   */
   
   t_elapsed = time();     //falta hacer la cosa del tiempo
   
   primera_interseccion();
   
   while (dist < INFINITY && rebotes < max_rebotes){
      avanzar_dist();
      rebotar();
      
      primera_interseccion();
   }
   
   if (rebotes < max_rebotes){
      ir_al_borde();
   }
   
   t_elapsed = time() - t_elapsed;
}

static void primera_interseccion (){
   /* Busca la primera intersección y deja la distancia a la intersección en dist,
      y el centro del cuerpo correspondiente en centro_intersec.
      Si no hay intersección, deja INFINITY en dest, y centro_intersec está indefinido.
      
      Acá aux_vector es el vector que va de pos a un centro (centros[i] - pos).
   */
   
   size_t i_intersec;
   double auxdotdir, posdotdir, nabla;
   
   dist = INFINITY; //si no hay intersección queda así
   
   //esto ahorra cuentas para calcular aux_vector·dir
   posdotdir = gsl_blas_ddot(pos, dir); //revisar si se escribe así
   
   for(int i = centros->size; i>=0; i--){
      centro_intersec = gsl_matrix_row(centros, i); //chequear si se escribe así
      
      auxdotdir = gsl_blas_ddot(&centro_intersec->vector, dir) - posdotdir;
      
      if (auxdotdir > 0  &&  auxdotdir < dist){ //si está adelante y más cerca que dist
      
         //calculamos centro-pos y nabla
         gsl_vector_memcpy(aux_vector, &centro_intersec->vector);
         gsl_vector_sub(aux_vector, pos); //chequear si se escribe así
         
         nabla = auxdotdir*auxdotdir - gsl_blas_ddot(aux_vector, aux_vector) + radio_cuerpo2;
         
         if (nabla>0){ //si hay intersección, es la nueva más cercana
            dist = x;
            i_intersec = i;
         }
      }
   }
   
   if (dist != INFINITY){
      centro_intersec = gsl_matrix_row(centros, i_intersec); //chequear si se escribe así
      
      //calculamos bien la distancia
      gsl_vector_memcpy(aux_vector, &centro_intersec->vector);
      gsl_vector_sub(aux_vector, pos); //chequear si se escribe así
      
      nabla = dist*dist - gsl_blas_ddot(aux_vector, aux_vector) + radio_cuerpo2;
      dist -= sqrt(nabla);
   }
}

static void avanzar_dist (){
   /* Avanza una distancia dist en la dirección actual */
   
   distancia_rec += dist;
   gsl_blas_axpy(dist, dir, pos); //revisar si se escribe así   
}

static void rebotar_centro_intersec (){
   /* Rebota (cambia la dirección) contra el cuerpo con centro centro_intersec.
      Esta función asume que el cuerpo tiene radio radio_cuerpo y que pos ya está
      en el borde del cuerpo.
      
      Acá aux_vector es la normal exterior al cuerpo en el punto de la intersección.
   */
   
   //calculamos la normal
   gsl_vector_memcpy(aux_vector, pos);
   gsl_vector_sub(aux_vector, centro_intersec); //chequear si se escribe así
   gsl_vector_scale(aux_vector, radio_cuerpo_inv);
   
   //calculamos el factor de escala
   double escala = -2 * gsl_blas_ddot(dir, aux_vector);
   
   //cambiamos la dirección
   gsl_blas_axpy(escala, aux_vector, dir); //ver si esta es la función correcta
   
   //nos aseguramos que quede unitaria la dirección
   gsl_vector_scale(dir, 1/gsl_vector_norm2(dir)); //ver si son las funciones correctas
   
   //contamos los rebotes
   rebotes++;
   if (registrar_recorrido){
      escribir_pos();
   }
}





