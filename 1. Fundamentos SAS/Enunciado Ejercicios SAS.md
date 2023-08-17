Antes de empezar, aunque no pretenda ser esto un curso, en este parrafo hablaré sobre las librerias.
Por defecto, si no se le indica nada a SAS, almacenará los conjuntos de datos en la librería temporal llamada Work.
Para evitar perder los datos, es recomendable usar librerias, con comando libname y la ruta, podemos tenerlos controlados los ficheros o usar datos previamente creados, de la siguiente forma:
```SAS
libname nombrelibreria "path";
```
En el primer ejemplo, se emplean los datos del conjunto class, almacenado en la libreria sashelp, en vez de importar el conjunto, se procede a importar desde el codigo con las funciones cards y input.
# Ejercicios SAS

# 1) El conjunto de datos clase contiene la información relativa a los alumnos de una clase de baile en USA. La altura esta en pulgadas (1 pulgada=2.54 cm.) y el peso en libras (1 libra= 0.45 kilos).


| Nombre | Sexo | Edad | Altura | Peso |
| ------ | ---- | ---- | ------ | ---- |
| ALFRED | M    | 14   | 69.0   | 112.5|
| ALICE  | F    | 13   | 56.5   | 84.0 |
| BARBARA| F    | 13   | 65.3   | 98.0 |
| CAROL  | F    | 14   | 62.8   | 102.5|
| HENRY  | M    | 14   | 63.5   | 102.5|
| JAMES  | M    | 12   | 57.3   | 83.0 |
| JANE   | F    | 12   | 59.8   | 84.5 |
| JANET  | F    | 15   | 62.5   | 112.5|
| JEFFREY| M    | 13   | 62.5   | 84.0 |
| JOHN   | M    | 12   | 59.0   | 99.5 |
| JOYCE  | F    | 11   | 51.3   | 50.5 |
| JUDY   | F    | 14   | 64.3   | 90.0 |
| LOUISE | F    | 12   | 56.3   | 77.0 |
| MARY   | F    | 15   | 66.5   | 112.0|
| PHILIP | M    | 16   | 72.0   | 150.0|
| ROBERT | M    | 12   | 64.8   | 128.0|
| RONALD | M    |15   |67.0 |133.0|
|THOMAS |M    |11 |57.5 |85.0 |
|WILLIAM |M |15 |66.5 |112.0|

Se pide:

a) Crear el conjunto de datos clase_hispana y guardarlo en una librería permanente conteniendo la información de conjunto de datos clase pero con la altura en centímetros y el peso en kilos.

b) obtener la media y la desviación típica del peso y de la altura para cada sexo. 

c)  Crear los conjuntos de datos masculino y femenino con sólo chicos y solo chicas respectivamente. 

d) Ordenar las observaciones de los conjuntos creados en el anterior apartado según el peso de los individuos. 

e) Representar gráficamente la altura (eje y) frente al peso (eje x) en una gráfica tanto para chicas como para chicos. 

f) Ordenar el conjunto de datos clase_hispana que creaste en el apartado a) según el peso. 

g) Representar gráficamente en una misma gráfica la altura frente al peso (unida por puntos) según el sexo. (Es decir se pide una figura con dos gráficas,  una para las chicas y otra para los chicos). 

h) Representar gráficamente dos rectas de regresión que relacionen la altura frente al peso (una para chicas y otra para chicos). 


# 2)  Con la información del conjunto de datos f_sup_both guardar en una libreria permanente el conjunto de datos supervivientes. 

Para este segundo ejercicio, he decido complicarlo mas, para obtener los datos, los he importado directamente desde la pagina del ine ya que no hay ningun problema si se descarga, pero queria explorar recopilar datos de la web.

Haré las siguientes consideraciones:
* Es importante la codificación debido a que la codificación de sas puede ser distinta y perderse información, en este caso es UTF-8
* Es un archivo .csv separado por tabuladores, por eso es necesario delimiter="09"x
* En un principio Proc Import, puede realizar esta importación de datos, sin embargo daría errores porque la variable total que almacena datos numericos, con puntos como separadores de miles y comas de decimales, por ello he optado por un paso data y el formato COMAX
* Tener todas las funciones demográficas permitiría seguir analizando otras funciones, pero para alcanzar la tabla del ejercicio ha requerido de varias transformaciones, como se puede ver en el archivo tema1.2



```SAS
filename ine url "https://www.ine.es/jaxiT3/files/t/es/csv_bd/27153.csv?nocab=1" encoding= utf8 termstr=crlf;

data WORK.DATOS    ;
       %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       infile INE delimiter='09'x MISSOVER DSD  firstobs=2 ;
      	    informat Sexo $11.  Periodo best32.  Total commax12. ;
       		format Sexo $11. Edad $10. Funciones $50. Periodo best12.  Total nlnum12.6 ;
			input Sexo $  Edad $ Funciones $ Periodo Total;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;
```

  a)  Incluir las siguientes variables: 
    • Prob_supervivencia_M, es la complementaria a la probabilidad de muerte para un hombre a cualquier edad y según el año en el que se valore. 
    • Prob_supervivencia_F, es la complementaria a la probabilidad de muerte para una mujer, a cualquier edad y según el año en el que se valore. 
    • Cociente_supervivencia,  es el cociente entre la supervivencia de una mujer y la de un hombre para una edad cualquiera. 
    
b) Crear un conjunto de datos con las medias durante el periodo estudiado de las varibles Prob_supervivencia_M, prob_supervivencia_F y cociente_supervivencia para cada edad. 

c) Realizar una grafica que contenga la prob_supervivencia_M y la prob_supervivencia_F media para cada edad  durante el periodo (las dos gráficas en la misma figura). 

d) Realizar otra gráfica con el cociente_supervivencia medio frente a la  edad. 

e) Evaluar gráficamente la evolución de la prob_supervivencia_M y prob_supervivencia_F y Cociente de Supervivencia para los 18 años durante el periodo 1991-2014. (graficas exclusivas para ese grupo de edad). 

f) Repetirlo para los 52 años.

g) Repetirlo para los 87 años. 
