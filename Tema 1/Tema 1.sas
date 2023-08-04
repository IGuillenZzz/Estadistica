/** El conjunto de datos clase contiene la información relativa a los alumnos de una clase de baile en USA. La altura esta en pulgadas (1 pulgada=2.54 cm.) y el peso en libras (1 libra= 0.45 kilos). **/


/* a) Crear el conjunto de datos clase_hispana y guardarlo en una librería permanente conteniendo la información de conjunto de datos clase pero con la altura en centímetros y el peso en kilos. */
libname lib "C:\Users\isma_\Desktop\Github\Software I\Tema 1";
data lib.clase_hispania;
input nombre $ sexo $ edad $ altura peso;
	peso=peso*.45;
	altura=altura*2.54;
cards;
ALFRED  M  14  69.0 112.5
ALICE   F  13  56.5  84.0
BARBARA F  13  65.3  98.0
CAROL   F  14  62.8 102.5
HENRY   M  14  63.5 102.5
JAMES   M  12  57.3  83.0
JANE    F  12  59.8  84.5
JANET   F  15  62.5 112.5
JEFFREY M  13  62.5  84.0
JOHN    M  12  59.0  99.5
JOYCE   F  11  51.3  50.5
JUDY    F  14  64.3  90.0
LOUISE  F  12  56.3  77.0
MARY    F  15  66.5 112.0
PHILIP  M  16  72.0 150.0
ROBERT  M  12  64.8 128.0
RONALD  M  15  67.0 133.0
THOMAS  M  11  57.5  85.0
WILLIAM M  15  66.5 112.0
;

/*b) obtener la media y la desviación típica del peso y de la altura para cada sexo.*/
proc means data= lib.clase_hispania mean std;
class sexo;
var peso altura;
run;

/*c)  Crear los conjuntos de datos masculino y femenino con sólo chicos y solo chicas respectivamente. */
data lib.clase_hispania_M  lib.clase_hispania_F;
	set lib.clase_hispania;
	if sexo="F" then output  lib.clase_hispania_F;
	else output  lib.clase_hispania_M;
run;

/*d) Ordenar las observaciones de los conjuntos creados en el anterior apartado según el peso de los individuos. */

proc sort data= lib.clase_hispania_M;by peso;run;
proc sort data= lib.clase_hispania_F;by peso;run;

/*e) Representar gráficamente la altura (eje y) frente al peso (eje x) en una gráfica tanto para chicas como para chicos. **/

proc sgplot data= lib.clase_hispania;
	scatter x= peso y=altura;
run;
/* LOS DATOS SALEN DE LA AYUDA DE SAS*/
data lib.clase_baile;
set sashelp.class;
run;

/*f) Ordenar el conjunto de datos clase_hispana que creaste en el apartado a) según el peso.*/
proc sort data= lib.clase_hispania;by peso;run;

/*g) Representar gráficamente en una misma gráfica la altura frente al peso (unida por puntos) según el sexo. (Es decir se pide una figura con dos gráficas,  una para las chicas y otra para los chicos). */

proc gplot data= lib.clase_hispania;
	symbol v=star i=j h=2 w=2;
	plot altura*peso=sexo;
run;

/*h) Representar gráficamente dos rectas de regresión que relacionen la altura frente al peso (una para chicas y otra para chicos). */
proc sgplot data= lib.clase_hispania;
	scatter x= peso y=altura/group=sexo;
	reg y=altura x=peso/group=sexo;
run;



