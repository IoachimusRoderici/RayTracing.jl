#define HAVE_INLINE

#include <tgmath.h>
#include <stdio.h>
#include <stdbool.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_blas.h>

#include "distribuciones.h"
#include "../C/MyLib/MyList.h"
#include "../C/MyLib/MyGSL/MyGSLio.h"

/* Distribución Cuadrada

   Genera un array de forma (n, dims) con puntos que forman una cuadrícula 
   limitada por la esfera; el radio real de la estrella es radio + radio_cuerpo.
   La cuadrícula está alineada de manera que el origen de coordenadas está en el
   centro de una de las celdas.
   Cuando se usa esta distribución, el radio de los cuerpos tiene que ser menor
   a lado/2.
    
   Parámetros:
   - radio:          radio de la esfera que limita la distribución.
   - lado:           distancia entre puntos.
   - dims:           número de dimensiones.
   
   - filename:       archivo donde escribir los datos, o NULL
   - centros_matrix: matríz donde guardar los datos, o NULL
*/
void distribucion_cuadrada (double radio, double lado, int dims,
                            const char *filename, gsl_matrix **centros_matrix){
                              
   size_t i;

   /* Cálculos Preliminares */
   
   //esta es una cota superior para el número de cuerpos que entran en un radio:
   int n_puntos = ceil(radio / lado);

   //estos índices identifican a cada punto de la cuadrícula,
   //su rango es de -n_puntos a n_puntos-1.
   //los inicializamos en sus valores mínimos:
   int indices[dims];
   for (i=0; i<dims; i++)
      indices[i] = -n_puntos;

   //esta función calcula una coordenada en función de un índice:
   #define x_from_i(indice)  lado * (indice + 0.5)

   //este vector contiene las coordenadas de un punto de la cuadrícula:
   gsl_vector *point = gsl_vector_alloc(dims);
   gsl_vector *temp;
   

   /* Configuramos el Output */

   FILE *fp;
   list_ptr *centros_list;

   bool out_file = false;   //indica si estamos escribiendo a un archivo
   bool out_matrix = false; //indica si estamos escribiendo a una matríz

   if (filename!=NULL){
      out_file = true;
      fp = fopen(filename, "w");
      fprintf(fp, "#distribución cuadrada con radio=%lf, lado=%lf, y dims=%d. \n", radio, lado, dims);
   }

   if (centros_matrix!=NULL){
      out_matrix = true;
      centros_list = list_init_ptr();
   }
   
   
   /* Ahora vamos a iterar por todas las combinaciones de índices. 
      Para cada combinación calculamos las coordenadas del punto correspondiente.
      Si está dentro del radio, lo escribimos en el output que esté activo.
   */
   
   while (indices[0]<n_puntos){
      //calculamos el vector para los índices actuales:
      for (i=0; i<dims; i++){
         gsl_vector_set(point, i, x_from_i(indices[i]) );
      }

      //si está adentro del radio
      if (gsl_blas_dnrm2(point)<=radio){         
         if (out_file){
            mygsl_write_txt(point, fp, "%lf");
         }
         if (out_matrix){
            temp = gsl_vector_alloc(dims);
            gsl_vector_memcpy(temp, point);
            list_append(centros_list, temp);
         }
      }

      //pasamos al siguiente índice, con el overflow que corresponda:
      indices[dims-1]++;
      for (i=dims-1; i>0; i--){
         if (indices[i]>=n_puntos){
            indices[i] = -n_puntos;
            indices[i-1]++;
         }
      }
   }

   if (out_file){
      fclose(fp);
   }

   if (out_matrix){
      //creamos la matríz y la llenamos con los puntos
      *centros_matrix = gsl_matrix_alloc(centros_list->len, dims);
      gsl_vector_view row;

      list_iter_begin(centros_list);
      while (list_iter_next(centros_list, &i, (void**)&temp)){
         row = gsl_matrix_row(*centros_matrix, i);
         gsl_vector_memcpy(&row.vector, temp);

         gsl_vector_free(temp);
      }

      list_free(centros_list);
   }
   

   //liberamos las cosas:
   gsl_vector_free(point);

   #undef x_from_i
}