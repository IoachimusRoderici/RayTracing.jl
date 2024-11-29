My GSL io
=========

Acá hay funciones para leer y escribir vectores y matrices.

Siempre que se puede, se definen macros genéricos para facilitar el uso.

Funciones Disponibles
---------------------

```c
#define mygsl_write_txt(arr, ...) ...
void mygsl_write_vector_int (const gsl_vector_int  *v, FILE *file);
void mygsl_write_vector_d   (const gsl_vector      *v, FILE *file, const char *format);
void mygsl_write_matrix_int (const gsl_mattrix_int *m, FILE *file);
void mygsl_write_matrix_d   (const gsl_mattrix     *m, FILE *file, const char *format);
```
Escribe el vector o matríz en el archivo dado. Los vectores se escriben en
una línea, las matríces se escriben una fila por línea. En ambos casos las 
componentes se separan con espacios.
Para el tipo `double`, hay que especificar el formato.
Actualmente sólo está implementada la versión para `double`.


```c
gsl_vector_int *mygsl_read_vector_int (const char *filename, gsl_vector_int *dest);
gsl_vector     *mygsl_read_vector_d   (const char *filename, gsl_vector     *dest);
```
Lee un vector del archivo dado. Si dest no es `NULL`, escribe el vector en dest,
que tiene que ser del tamaño correcto. Si dest es `NULL`, aloca un vector nuevo.
En ambos casos devuelve un pointer al vector donde se escribieron los resultados.
Se lee el vector de la primera línea que empiece con dígitos o `-` o `+`, y se 
ignoran las líneas anteriores y siguientes. Se asume que las componentes del
vector están separadas por whitespace.
Actualmente sólo está implementada la versión para `double`.


```c
gsl_matrix_int *mygsl_read_matrix_int (const char *filename, gsl_matrix_int *dest);
gsl_matrix     *mygsl_read_matrix_d   (const char *filename, gsl_matrix     *dest);
```
Lee una matríz del archivo dado. Si dest no es `NULL`, escribe la matríz en dest,
que tiene que ser de la forma correcta. Si dest es `NULL`, aloca una matríz nueva.
En ambos casos devuelve un pointer a la matríz donde se escribieron los resultados.
El archivo puede comenzar con líneas de texto que no tengan como primer caracter un
dígito ni un signo `+` o `-`; estas líneas se ignoran. Luego de estas líneas se 
asume que el resto del archivo contiene los elementos de la matríz, con una fila en
cada línea, y las columnas separadas por whitespace.
Actualmente sólo está implementada la versión para `double`.

```c
#define mygsl_print(v, n...) ...
void mygsl_print_vector_int (const gsl_vector_int *v, ssize_t n);
void mygsl_print_vector_d   (const gsl_vector     *v, ssize_t n);
void mygsl_print_matrix_int (const gsl_matrix_int *v, ssize_t n);
void mygsl_print_matrix_d   (const gsl_matrix     *v, ssize_t n);
```
Imprime en la terminal los primeros n elementos del vector o las primeras n filas de la
matríz. Los elementos se separan con `\t`, y la impresión termina con `\n`.
Si n es 0, imprime el vector o la matríz completa. Si n es negativo, los elementos o las
filas se cuentan desde el final. Omitir n en el macro es equivalente a pasar 0.
Actualmente sólo están implementadas las versiones para `double`.