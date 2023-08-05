/*Lectura de datos de la serie histórica de tablas de mortalidad desde 1991 por año edad y funciones
https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177004&menu=resultados&idp=1254735573002 

Csv separado por tabuladores
Variables importantes estan en la columna funciones: Tasa de mortalidad	Promedio de años vividos el último año de vida	Riesgo de muerte	Supervivientes	Defunciones teóricas	Población estacionaria	Tiempo por vivir	Esperanza de vida

El objetivo es tener en una tabla la funcion de supervivencia y prob de mortalidad para cada periodo, edad y sexo (no ambos)
*/


filename ine url "https://www.ine.es/jaxiT3/files/t/es/csv_bd/27153.csv?nocab=1" encoding= utf8 termstr=crlf;

data WORK.DATOS    ;
       %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
       infile INE delimiter='09'x MISSOVER DSD  firstobs=2 ;
      	    informat Sexo $11.  Periodo best32.  Total commax12. ;
       		format Sexo $11. Edad $10. Funciones $50. Periodo best12.  Total nlnum12.6 ;
			input Sexo $  Edad $ Funciones $ Periodo Total;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;




data f_sup_M f_sup_F;
set datos(rename=(edad=edad2));

if edad2="100 y más" then edad2=100;
else edad2=input(edad2,2.);
edad2=compress(edad2);
drop edad2;
Edad=input(edad2,best.);

where sexo ^= "Ambos sexos" and funciones="Supervivientes"; 
drop Funciones;
	if sexo="Hombres" then output f_sup_M;
	else  output f_sup_F;

run;

Proc sort data=f_sup_M;by Periodo Edad;run;
Proc sort data=f_sup_F;by Periodo Edad;run;

data f_sup_M;
set f_sup_M;
F_supervivencia_M=total;
prob_muerte_m=(lag(F_supervivencia_M)-F_supervivencia_M)/lag(F_supervivencia_M);
if edad=0 then prob_muerte_m=0;
drop total sexo;run;


data f_sup_F;
set f_sup_F;
F_supervivencia_F=total;
prob_muerte_f=(lag(F_supervivencia_f)-F_supervivencia_f)/lag(F_supervivencia_f);
if edad=0 then prob_muerte_f=0;
drop total sexo;run;

libname lib "path";

data lib.f_sup_both;
merge f_sup_F f_sup_M;
by periodo edad;run;

/*a)  Incluir las siguientes variables: 
    • Prob_supervivencia_M, es la complementaria a la probabilidad de muerte para un hombre a cualquier edad y según el año en el que se valore. 
    • Prob_supervivencia_F, es la complementaria a la probabilidad de muerte para una mujer, a cualquier edad y según el año en el que se valore. 
	• Cociente_supervivencia,  es el cociente entre la supervivencia de una mujer y la de un hombre para una edad cualquiera. (razon/cociente de feminidad)
*/

data lib.f_sup_both;
set lib.f_sup_both;
Prob_supervivencia_M=1-prob_muerte_m;
Prob_supervivencia_F=1-prob_muerte_f;
Cociente_Supervivencia=F_Supervivencia_F/F_Supervivencia_M;
run;

/*b) Crear un conjunto de datos con las medias durante el periodo estudiado de las varibles Prob_supervivencia_M, prob_supervivencia_F y cociente_supervivencia para cada edad. */

proc means data =lib.f_sup_both mean noprint;
var Prob_supervivencia_M Prob_supervivencia_F cociente_supervivencia;
class edad;
output out=prob_edad mean=;
run;

/*c) Realizar una grafica que contenga la prob_supervivencia_M y la prob_supervivencia_F media para cada edad  durante el periodo (las dos gráficas en la misma figura). */
proc sgplot data=prob_edad (where=( _type_=1));
title "Media de las probabilidades de supervivencia";
title2 "para hombres y mujeres entre 1991 y 2022*";
series   x=edad y=Prob_supervivencia_F /name="Mujeres";
series x=edad  y=Prob_supervivencia_M/name="Hombres";
xaxis values=(0 to 100 by 5) minor minorcount=1  grid display=all;
yaxis label="Probabilidad media de supervivencia";
label Prob_supervivencia_F="Mujeres" prob_supervivencia_M="Hombres";
run;

/*/d) Realizar otra gráfica con el cociente_supervivencia medio frente a la  edad.*/

proc sgplot data=prob_edad (where=( _type_=1));
title "Media de la razón de supervivencia";
title2 "entre hombres y mujeres entre 1991 y 2022*";
series   x=edad y=cociente_supervivencia /name="Cociente Supervivencia";
xaxis values=(0 to 100 by 5) minor minorcount=1  grid display=all;
yaxis label="Razón media de supervivencia";
label cociente_supervivencia="Mujeres" ;
run;

/*e) Evaluar gráficamente la evolución de la prob_supervivencia_M y prob_supervivencia_F y Cociente de Supervivencia 
para los 18 años durante el periodo 1991-2012. (graficas exclusivas para ese grupo de edad).*/

proc sgplot data=lib.f_sup_both (where=(edad=18));
title "Probabilidad de supervivencia y Cociente de Supervivencia";
title2 "para edad=18 años durante el periodo 1991-2022";
series   x=periodo y=prob_supervivencia_M /name="Hombres";
series   x=periodo y=prob_supervivencia_F /name="Mujeres";
series   x=periodo y=cociente_supervivencia/name="Cociente Supervivencia";

xaxis values=(1991 to 2022 by 5) minor minorcount=1  grid display=all;
yaxis label=" ";
label prob_supervivencia_M="Hombres" prob_supervivencia_F="Mujeres" cociente_supervivencia="Cociente Supervivencia";
run;




/*f) repetir para los 52 años*/
proc sgplot data=lib.f_sup_both (where=(edad=52));
title "Probabilidad de supervivencia y Cociente de Supervivencia";
title2 "para edad=52 años durante el periodo 1991-2022";
series   x=periodo y=prob_supervivencia_M /name="Hombres";
series   x=periodo y=prob_supervivencia_F /name="Mujeres";
series   x=periodo y=cociente_supervivencia/name="Cociente Supervivencia";

xaxis values=(1991 to 2022 by 5) minor minorcount=1  grid display=all;
yaxis label=" ";
label prob_supervivencia_M="Hombres" prob_supervivencia_F="Mujeres" cociente_supervivencia="Cociente Supervivencia";
run;

/*f) repetir para los 87 años*/

proc sgplot data=lib.f_sup_both (where=(edad=87));
title "Probabilidad de supervivencia y Cociente de Supervivencia";
title2 "para edad=87 años durante el periodo 1991-2022";
series   x=periodo y=prob_supervivencia_M /name="Hombres";
series   x=periodo y=prob_supervivencia_F /name="Mujeres";
series   x=periodo y=cociente_supervivencia/name="Cociente Supervivencia";

xaxis values=(1991 to 2022 by 5) minor minorcount=1  grid display=all;
yaxis label=" ";
label prob_supervivencia_M="Hombres" prob_supervivencia_F="Mujeres" cociente_supervivencia="Cociente Supervivencia";
run;
