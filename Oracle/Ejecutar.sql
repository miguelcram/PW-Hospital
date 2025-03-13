/*Primero se ejecutan los tipos*/
@Ficheros\Tipos.sql
/*Segundo se ejecutan las tablas*/
@Ficheros\Tablas.sql
/*Tercero se ejecutan las secuencias y los disparadores*/
@Ficheros\Secuencias.sql
@Ficheros\Disparadores.sql
/*Cuarto se ejecuta el paquete con todas las funciones*/
@Ficheros\Paquete.sql
/*Por último se realizan inserts para las tablas*/
@Ficheros\Inserts.sql