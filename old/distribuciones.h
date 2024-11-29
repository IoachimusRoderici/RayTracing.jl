/* Estas funciones generan distintas distribuciones de puntos.
   
   Reciben como argumento un nombre de archivo y un double pointer a una
   matríz. Cualquiera de esos dos puede ser NULL. Si el nombre de archivo
   no es NULL, se guardan los datos en ese archivo. Si el pointer no es
   NULL, se aloca una nueva matríz, se la llena con los datos, y se pone
   su pointer en *centros_matrix.
*/

#ifndef RT_distribuciones
#define RT_distribuciones

#include <gsl/gsl_matrix.h>


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
                            const char *filename, gsl_matrix **centros_matrix);


#endif //RT_distribuciones