======================================================
// Abrir SC en CSV
//======================================================

// Cómo abrir un CSV en SC
~path = thisProcess.nowExecutingPath.dirname +/+"datos.csv";

x = CSVFileReader.read(~path,true).postcs;

// Mostrar las lineas del 1 al 3 del CSV
// Los puntos decimales nos indican tomar
// los valores del arreglo con índices
// entre 1 y 3.
x[1..3];

// El primer renglón contiene los nombres
// de las columnas
x[0];

// Quitamos el primer renglón de los títulos
x = x[1..x.size-1];

// Traducir el CSV a una lista de arreglos
(
~colPrimera= x.collect({arg val;
	 val[1].asFloat;
});
)

// Columna siguiente
(
~colSegunda= x.collect({arg val;
	 val[2].asFloat;
});
)

// Columna siguiente
(
~colTercera= x.collect({arg val;
	 val[3].asFloat;
});
)

//======================================================
// Preparación de datos
//======================================================

// Tamaños de columnas
~colPrimera.size;
~colPrimera.plot;

// Normalizar datos
~normColPrimera = ~colPrimera.normalize;
~normColPrimera.plot;

// Ajustar rangos, usar asInt para quitar decimales
~normColPrimeraRango = ~normColPrimera.linlin(0,1,60,72).asInt;

// Graficar
~normColPrimeraRango.plot;

// Hagamos esto para otras columna

~normColSegundaRango = ~colSegunda.normalize.linlin(0,1,40,70).asInt;
~normColTerceraRango = ~colTercera.normalize.linlin(0,1,48,60).asInt;

// Grafica de las tres funciones
~normColPrimeraRango.plot;
~normColSegundaRango.plot;
~normColTerceraRango.plot;

// Necesitamos elegir el parámetro musical que queremos controlar
// Establecer la regla de mapeo

//======================================================
// Sonificación
//======================================================

// Primero intentemos cómo suena la primer columna
(
Pbind(
	\midinote, Pseq(~normColPrimeraRango, 1).poll,
	\dur, 0.2,
	\amp,0.01
).play;
)

// Ahora veamos como suena la segunda
(
Pbind(
	\midinote, Pseq(~normColTerceraRango, 1).poll,
	\dur, 0.4,
	\amp, 0.01
).play;
)

// Podemos filtrar los datos
(
~primeraFiltrada = Array.new(~normColPrimeraRango.size);
~terceraFiltrada = Array.new(~normColTerceraRango.size);

~normColPrimeraRango.do({arg val, i;
	if( i%20==0 ,{
		~primeraFiltrada.add(val.asInt);
	});
});

~normColTerceraRango.do({arg val, i;
	if(i%20==0,{
		~terceraFiltrada.add(val.asInt);
	});
})
)

~primeraFiltrada.size;
~primeraFiltrada.plot;

//======================================================
// Polifonía
//======================================================

// Dos columnas simultáneas
(
Pbind(
	\midinote, Pseq(~normColPrimeraRango, 1).poll,
	\dur, 0.2,
	\amp, 0.09
).play;

Pbind(
	\midinote, Pseq(~normColTerceraRango, 1).poll,
	\dur, 0.4
).play
)

