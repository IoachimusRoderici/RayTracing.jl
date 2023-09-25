#include <stdlib.h>
#include "RayTracing.h"
#include "distribuciones.h"
#include "../C/MyLib/MyGSL/MyGSLio.h"

//muestra un plot de las cosas. recorrido_filename puede ser "".
void show_plot(const char *centros_file, double radio_cuerpo, const char *recorrido_filename);

int main(){
   //seteamos los parámetros
  struct RT_parametros params = {
      .registrar_recorrido = true,
      .recorrido_filename = "rec.recorrido",
      
      .max_rebotes = 1000,
      
      .dims = 2,
      
      .dir_inicial = NULL,
      .centros = NULL,
      
      .radio_cuerpo = 1,
      .radio_estrella = 10
   };

   //generamos la distribución de cuerpos
   __attribute__((unused)) double lado = 3;
   char distr_file[] = "distr.distribucion";
   gsl_matrix *centros;
   
   //distribucion_cuadrada (params.radio_estrella, lado, params.dims, distr_file, &centros);
   centros = mygsl_read_matrix_d(distr_file, NULL);
   params.centros = centros;

   //show_plot(distr_file, params.radio_cuerpo, "");

   //simulamos
   RT_configurar(params);

   __attribute__((unused)) struct RT_resultados data = RT_simular();

   show_plot(distr_file, params.radio_cuerpo, params.recorrido_filename);

   return 0;
}

void show_plot(const char *centros_file, double radio_cuerpo, const char *recorrido_filename){
   const int cmd_len = 100;
   char cmd[cmd_len];

   snprintf(cmd, cmd_len, "python3 plot.py %s %lf %s", centros_file, radio_cuerpo, recorrido_filename);

   system(cmd);
}