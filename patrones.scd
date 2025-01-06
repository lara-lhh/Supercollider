
//======================================================
// Ejemplos de patrones
//======================================================

// Pbind y pseq
(
Pbind(
	\note, Pseq([0,3,7,12,3,7,12,15,7,12,3,7],7),
	\dur, 0.25
).play;
)

// Pshuf
(
Pbind(
	\note, Pshuf([0,3,7,12],8),
	\dur, 1/8
).play;
)

// Ejemplo Permutaciones de [1,2,3]
[1,3,2];
[2,1,3];
[2,3,1];
[3,1,2];
[3,2,1];

// Prand
(
Pbind(
	\note, Prand([0,3,7,12],inf).poll,
	\dur, 1/8
).play;
)

// Pxrand
(
Pbind(
	\note, Pxrand([0,\r,4,\r,9,10,\r],inf).poll,
	\dur, 1/8
).play;
)

// Para duraciones
(
Pbind(
	\note, 0,
	\dur,Pxrand([0.5,0.5,0.25,0.25,1]/2,inf).poll,
).play;
)

//======================================================
// Distribuciones de probabilidad
//======================================================

// Pbrown
(
Pbind(
	\note, Pbrown(0,12,1,inf).poll,
	\dur, 1/8
).play;
)

// Movimiento por terceras menores en un rango de 2 octavas
(
Pbind(
	\note, Pbrown(-12,12,3,inf).poll,
	\dur, 1/8,
).play;
)

// Dinámicas graduales con Pbrown
(
Pbind(
	\note, Pseq([0,2,4,5,7,9,10,12]++[2,4,5,7,9,10].reverse,inf),
	\dur, 1/8,
	\amp, Pbrown(0,1,0.1,inf).poll
).play;
)

// Concatenación de arreglos
[1,2,3]++[4,5,6];

//======================================================
// Pwhite
//======================================================

(
Pbind(
	\note, Pwhite(0,12,inf).poll,
	\dur, 1/8
).play;
)

// Aleatorios con decimales
(
Pbind(
	\note, Pwhite(0,12.0,inf).poll,
	\dur, 1/8
).play;
)

// Distribución gausiana
(
Pbind(
	\note, Pgauss(0,3,inf).asInt.poll,
	\dur, 1/8
).play;
)

// Diferente desviación
(
Pbind(
	\note, Pgauss(0,10,inf).asInt.poll,
	\dur, 1/8
).play;
)

//======================================================
// Patrones de repetición
//======================================================

// Stutter
(
Pbind(
	\note, Pstutter(1, Pseq([0,2,3,5,7],inf)).poll,
	\dur, 1/4
).play;
)

(
Pbind(
	\note, Pstutter(2, Pseq([0,2,3,5,7],inf)).poll,
	\dur, 1/8
).play;
)

(
Pbind(
	\note, Pstutter(3, Pseq([0,2,3,5,7],inf)).poll,
	\dur,1/6
).play;
)

(
Pbind(
	\note, Pstutter(4, Pseq([0,2,3,5,7],inf)).poll,
	\dur,1/8
).play;
)

// Sutter para otros patrones
(
Pbind(
	\note, Pstutter(3, Pbrown(0,12,1)).poll,
	\dur,1/6
).play;
)

//======================================================
// Repetición de secciones
//======================================================

// Pn
(
Pbind(
	\note, Pn(Pwhite(0,12,4),5).poll,
	\dur, 1/8
).play;
)

// Generación de series
(
Pbind(
	\note, Pseries(0,1,12).poll,
	\dur, 1/8
).play;
)

// Serie de intervalos de tercera
(
Pbind(
	\note, Pseries(0,3,12)++Pseries(30,-3,12).poll,
	\dur, 1/10
).play;
)

