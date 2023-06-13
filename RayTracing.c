#include "RayTracing.h"
#include <gsl/gsl_blas.h>
#include "../C/MyLib/MyGSL/MyGSLRandom.h"
#include "../C/MyLib/MyTime.h"
#include <tgmath.h>
#include <stdio.h>

/* Variables de la Simulación */

static bool hemosidoconfigurados = false;     //indica si la simulación está configurada
static bool use_random_dir;                   //indica si hay que elegir una dirección aleatoria
static bool registrar_recorrido;              //si es true guardamos una lista de los rebotes

static const char *recorrido_filename;        //string con el nombre de archivo
static FILE *recorrido;                       //archivo donde escribimos el recorrido

static unsigned int max_rebotes;              //abortar la simulación en este número de rebotes

static unsigned int dims;                     //número de dimensiones
static gsl_matrix *centros;                   //lista de coordenadas de los centros de los átomos

static double radio_estrella;                 //radio de la estrella
static double radio_cuerpo;                   //radio de los átomos
static double radio_cuerpo2;                  //radio_cuerpo al cuadrado

static gsl_vector *pos;                       //posición actual del rayo
static gsl_vector *dir;                       //dirección actual del rayo (vector unitario)
static gsl_vector *dir_inicial;               //dirección inicial simulada

static double dist;                           //distancia hasta la primera intersección
static gsl_vector_view centro_intersec;       //centro del cuerpo con el que interseca
static gsl_vector *aux_vector;                //vector auxiliar para algunas funciones

struct RT_resultados data;                    //info para delvolver al usuario

/* Funciones de la Simulación */

static void alocar_vectores (unsigned int d); //aloca los vectores, con tamaño d
static void free_vectores ();                 //libera los vectores

static void escribir_pos();                   //escribe la posición en recorrido

static void correr_simulacion ();             //corre la simulación y deja los resultados en
                                              //data, excepto exito, dir_inicial, y t_elapsed.

static void buscar_primera_interseccion ();   //actualiza dist y centro_interseccion
static void avanzar_dist ();                  //avanza una distancia dist en la dirección actual
static void rebotar_centro_intersec ();       //rebota contra el cuerpo de centro_intersec
static void avanzar_hasta_el_borde();         //avanza hasta el borde de la estrella


/* Código de la API */

void RT_configurar (struct RT_parametros params){
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
   radio_estrella = params.radio_estrella;
      
   use_random_dir = params.dir_inicial == NULL;
   if (!use_random_dir){
      gsl_vector_memcpy(dir_inicial, params.dir_inicial);
      gsl_vector_scale(dir_inicial, 1/gsl_blas_dnrm2(dir_inicial));
   }
      
   //listo
   hemosidoconfigurados = true;
}

struct RT_resultados RT_simular (){
   
   //vemos que la cosa esté configurada
   if (!hemosidoconfigurados){
      puts("ERROR: RT_simular: No se configuró la simulación.");
      exit(1);
   }
   
   iniciar_el_reloj();

   //seteamos la dirección inicial
   if (use_random_dir){
      random_direction(dir_inicial);
   }
   gsl_vector_memcpy(dir, dir_inicial);
   
   //seteamos la posición inicial
   gsl_vector_set_zero(pos);
   
   //ponemos en cero las métricas
   data.rebotes = 0;
   data.distancia = 0;
   
   //abrimos el archivo para el recorrido
   if (registrar_recorrido){
      recorrido = fopen(recorrido_filename, "w");
   }
   
   //corremos la simulación
   correr_simulacion();

   //populamos data
   data.t_elapsed = leer_time_t();
   data.exito = data.rebotes < max_rebotes;
   
   //cerramos el archivo del recorrido
   if (registrar_recorrido){
      fclose(recorrido);
   }
   
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
   dir_inicial = gsl_vector_alloc(d);
   aux_vector = gsl_vector_alloc(d);

   data.dir_inicial = gsl_vector_subvector(dir_inicial, 0, d);
}

__attribute__((destructor))
static void free_vectores (){
   /* libera todos los vectores que usa la simulación */
   
   gsl_vector_free(pos);
   gsl_vector_free(dir);
   gsl_vector_free(aux_vector);
   gsl_vector_free(dir_inicial);
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
   
   buscar_primera_interseccion();
   
   while (dist != INFINITY && data.rebotes < max_rebotes){
      avanzar_dist();
      rebotar_centro_intersec();
      
      buscar_primera_interseccion();
   }
   
   if (data.rebotes < max_rebotes){
      avanzar_hasta_el_borde();
   }
}

static void buscar_primera_interseccion (){
   /* Busca la primera intersección. Deja la distancia a la intersección en dist,
      y el centro del cuerpo correspondiente en centro_intersec.
      Si no hay intersección, deja INFINITY en dest, y centro_intersec está indefinido.
   */
   
   size_t i_intersec;
   double aux_dot_dir, pos_dot_dir;
   double nabla;
   
   dist = INFINITY; //si no hay intersección queda así

   /* Iteramos por todos los cuerpos filtrando los que intersecan con el rayo.

      Acá aux_vector es el vector que va de pos a centro_intersec (centros[i] - pos).

      Primero calculamos aux_vector·dir, que es la distancia a lo largo del rayo hasta
      el centro del cuerpo. En dist ponemos el valor de aux_dot_dir de la intersección
      más cercana.
      
      Descartamos los cuerpos que están en el hemisferio de atrás (aux_dot_dir<0), y
      los que están más lejos que dist (aux_dot_dir>dist).

      A los cuerpos que pasan este filtro les calculamos nabla para ver si intersecan
      al rayo, y en ese caso (nabla>0) actualizamos dist.
   */
   
   gsl_blas_ddot(pos, dir, &pos_dot_dir); //esto ahorra cuentas para calcular aux_vector·dir
   
   for(int i = centros->size1; i>=0; i--){
      centro_intersec = gsl_matrix_row(centros, i);
      
      gsl_blas_ddot(&centro_intersec.vector, dir, &aux_dot_dir);
      aux_dot_dir -= pos_dot_dir;
      
      if (aux_dot_dir > 0  &&  aux_dot_dir < dist){ //si está adelante y más cerca que dist
      
         //calculamos centro_intersec - pos y nabla
         gsl_vector_memcpy(aux_vector, &centro_intersec.vector);
         gsl_vector_sub(aux_vector, pos);
         
         gsl_blas_ddot(aux_vector, aux_vector, &nabla);
         nabla = aux_dot_dir*aux_dot_dir - nabla + radio_cuerpo2;
         
         if (nabla>0){ //si hay intersección, es la nueva más cercana
            dist = aux_dot_dir;
            i_intersec = i;
         }
      }
   }

   /* Ahora que sabemos cual es el cuerpo, calculamos bien la intersección.
      Excepto que no haya intersección, en cuyo caso no hay que hacer nada más.
   */   

   if (dist != INFINITY){
      //ponemos el valor correcto en centro_intersec
      centro_intersec = gsl_matrix_row(centros, i_intersec);
      
      //calculamos bien la distancia
      gsl_vector_memcpy(aux_vector, &centro_intersec.vector);
      gsl_vector_sub(aux_vector, pos);
      
      gsl_blas_ddot(aux_vector, aux_vector, &nabla);
      nabla = dist*dist - nabla + radio_cuerpo2;
      dist -= sqrt(nabla);
   }
}

static void avanzar_dist (){
   /* Avanza una distancia dist en la dirección actual */
   
   data.distancia += dist;
   gsl_blas_daxpy(dist, dir, pos);  
}

static void rebotar_centro_intersec (){
   /* Rebota (cambia la dirección) contra el cuerpo con centro centro_intersec.
      Esta función asume que el cuerpo tiene radio radio_cuerpo y que pos ya está
      en el borde del cuerpo.
      
      Acá aux_vector es la normal exterior al cuerpo en el punto de la intersección.
   */
   
   //calculamos la normal
   gsl_vector_memcpy(aux_vector, pos);
   gsl_vector_sub(aux_vector, &centro_intersec.vector);
   
   //cambiamos la dirección
   double escala;
   gsl_blas_ddot(dir, aux_vector, &escala);
   escala *= -2 / radio_cuerpo;
   gsl_blas_daxpy(escala, aux_vector, dir);
   
   //nos aseguramos que quede unitaria la dirección
   gsl_vector_scale(dir, 1/gsl_blas_dnrm2(dir));
   
   //registramos el rebote
   data.rebotes++;
   if (registrar_recorrido){
      escribir_pos();
   }
}

static void avanzar_hasta_el_borde(){
   /* Avanza en la dirección actual hasta llegar al borde.
      Se asume que el rayo está adentro de la estrella.
   */

   //calculamos la intersección
   double pos_dot_dir, nabla;

   gsl_blas_ddot(pos, dir, &pos_dot_dir);
   gsl_blas_ddot(pos, pos, &nabla);
   
   nabla = pos_dot_dir*pos_dot_dir - nabla + radio_estrella*radio_estrella;
   dist = -pos_dot_dir + sqrt(nabla);

   //avanzamos
   avanzar_dist();
   if (registrar_recorrido){
      escribir_pos();
   }
}
