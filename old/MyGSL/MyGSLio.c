#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>

#define MyAssert_name "MyGSLio"
#include "../MyAssert.h"
#include "MyGSLio.h"


/* Writing */

void mygsl_write_vector_d (const gsl_vector *v, FILE *file, const char *format){
   size_t n = v->size;
   int status;

   for (size_t i = 0; i<n; i++){
      status = fprintf(file, format, gsl_vector_get(v, i));
      MyAssert(status>0, "fprintf devolvió %d.", status);

      status = putc(' ', file);
      MyAssert(status!=EOF, "putc failed, error code is %d", ferror(file));
   }

   status = putc('\n', file);
   MyAssert(status!=EOF, "putc failed, error code is %d", ferror(file));
}

void mygsl_write_matrix_d (const gsl_matrix *m, FILE *file, const char *format){
   size_t n1 = m->size1;
   size_t n2 = m->size2;
   int status;

   for (size_t i = 0; i<n1; i++){
      for (size_t j = 0; j<n2; j++){
         status = fprintf(file, format, gsl_matrix_get(m, i, j));
         MyAssert(status>0, "fprintf devolvió %d.", status);

         status = putc(' ', file);
         MyAssert(status!=EOF, "putc failed, error code is %d", ferror(file));
      }

      status = putc('\n', file);
      MyAssert(status!=EOF, "putc failed, error code is %d", ferror(file));
   }   
}


/* Reading */

static inline void saltear_prologo (FILE *fp){
   /* Saltea las primeras líneas del archivo, hasta encontrar 
      una que empiece con un dígito o un signo.               */
   
   char c;

   fscanf(fp, " %c", &c);

   while (!isdigit(c) && c!='+' && c!='-'){
      fscanf(fp, "%*[^\n]\n"); //consumir los que queda de la línea
      fscanf(fp, " %c", &c);   //mirar el primer caracter de la línea siguiente
   }

   ungetc(c, fp); //reponer el primer caracter
}

static inline size_t contar_palabras (FILE *fp){
   /* Devuelve el número de palabras en la primera lìnea de fp. */
   bool enpalabra = false;   
   char c = fgetc(fp);
   size_t count = 0;

   while (c != '\n'){
      if (!enpalabra && !isspace(c)){
         enpalabra = true;
         count ++;
      }

      if (enpalabra && isspace(c)){
         enpalabra = false;
      }

      c = fgetc(fp);
   }

   return count;
}

static inline size_t contar_lineas (FILE *fp){
   /* Devuelve el número de líneas que quedan hasta el final del archivo. */
   size_t lines = 0;

   while (fscanf(fp, "%*[^\n]")!=EOF){
      fgetc(fp);
      lines++;
   }

   return lines;
}

gsl_vector *mygsl_read_vector_d (const char *filename, gsl_vector *dest){
   long start_of_vector;
   size_t dims;

   //abrimos el archivo
   FILE *fp = fopen(filename, "r");
   MyAssert(fp!=NULL, "No se pudo abrir el archivo \"%s\".", filename);

   saltear_prologo(fp);
   start_of_vector = ftell(fp);

   //detectamos el tamaño del vector
   dims = contar_palabras(fp);
   fseek(fp, start_of_vector, SEEK_SET);

   //chequeamos dest
   if (dest==NULL){
      dest = gsl_vector_alloc(dims);
      MyAssert(dest!=NULL, "No se pudo alocar el vector (leyendo %s).", filename);
   }
   else{
      MyAssert(dest->size==dims, "Se detectan %zd componentes en %s, pero dest->size=%zd.", dims, filename, dest->size);
   }

   //llenamos dest
   for (size_t i=0; i<dest->size; i++){
      fscanf(fp, "%lf", gsl_vector_ptr(dest, i));
   }

   return dest;
}

gsl_matrix *mygsl_read_matrix_d (const char *filename, gsl_matrix *dest){
   long start_of_matrix;
   size_t rows, cols;

   //abrimos el archivo
   FILE *fp = fopen(filename, "r");
   MyAssert(fp!=NULL, "No se pudo abrir el archivo \"%s\".", filename);

   saltear_prologo(fp);
   start_of_matrix = ftell(fp);
   

   //detectamos las dimensiones de la matríz
   rows = contar_lineas(fp);
   fseek(fp, start_of_matrix, SEEK_SET);
   cols = contar_palabras(fp);
   fseek(fp, start_of_matrix, SEEK_SET);

   //chequeamos dest
   if (dest==NULL){
      dest = gsl_matrix_alloc(rows, cols);
      MyAssert(dest!=NULL, "No se pudo alocar la matríz (leyendo %s).", filename);
   }
   else{
      MyAssert(dest->size1==rows && dest->size2==cols, "Se detectan %zd filas y %zd columnas en %s, pero dest->size1=%zd y dest->size2=%zd.", rows, cols, filename, dest->size1, dest->size2);
   }

   //llenamos dest
   for (size_t i=0; i<dest->size1; i++){
      for (size_t j=0; j<dest->size2; j++){
         fscanf(fp, "%lf", gsl_matrix_ptr(dest, i, j));
      }
   }

   return dest;
}


/* Printing */

void mygsl_print_vector_d (const gsl_vector *v, ssize_t n){

   //casos especiales
   if (v==NULL){
      puts("NULL");
      return;
   }
   if (v->size==0){
      puts("Empty Vector");
      return;
   }

   MyAssert(abs(n)<=v->size, "n=%zd está fuera de rango para un vector de tamaño %zd.", n, v->size);

   //seteamos el rango a imprimir
   size_t i;
   if (n==0){
      n = v->size;
      i = 0;
   }
   else if (n>0)
      i = 0;
   else if (n<0){
      i = v->size + n;
      n = v->size;    
   }

   //imprimimos
   for (; i<n; i++){
      printf("\t% .3f", gsl_vector_get(v, i));
   }
   putchar('\n');
}

void mygsl_print_matrix_d (const gsl_matrix *m, ssize_t n){

   //casos especiales
   if (m==NULL){
      puts("NULL");
      return;
   }
   if (m->size1==0 || m->size2==0){
      puts("Empty Matrix");
      return;
   }

   MyAssert(abs(n)<=m->size1, "n=%zd está fuera de rango para una matríz con %zd filas.", n, m->size1);

   //seteamos el rango a imprimir
   size_t i;
   if (n==0){
      n = m->size1;
      i = 0;
   }
   else if (n>0)
      i = 0;
   else if (n<0){
      i = m->size1 + n;
      n = m->size1;    
   }

   //imprimimos
   for (; i<n; i++){
      for (size_t j=0; j<m->size2; j++){
         printf("\t% .3f", gsl_matrix_get(m, i, j));
      }
      putchar('\n');
   }   
}