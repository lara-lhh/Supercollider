
s.boot;
/*
Los granuladores funcionan con audios de un solo canal.
Se puede leer un solo canal utilizando Buffer.readChannel,
este método usa el argumento channels:0
para decidir qué canal del archivo de audio va a leer.
Si el Buffer no es mono el sinte no va a sonar, pero tampoco
dará un error.
*/

// Sintesis de sonido granular

Para la sintesis granular SuperCollider integra varios UGens.

GrainSin
GrainFM
GrainBuf
GrainIn
TGrains


// Comencemos con "GrainSin" el más simple de los granuladores.

//-------------------------------------------
GrainSin genera granos con sinusoidales, sus argumentos son:

 -> numChannels: número de canales de salida
 -> trigger: disparador de granos,
 -> dur: duración de cada grano,
 -> freq: frecuencia de la sinusoidal dentro de cada grano,
 -> pan: posición del grano en las bocinas (Izquierda - Derecha),
 -> envbufnum: bufer con la forma de la envolvente para cada grano,
 -> maxGrains: cantidad máxima dee granos,
 -> mul: amplitud,
 -> add: 0;

//-------------------------------------------

(
SynthDef(\gran1, {|amp 0.1, gate 1|
	var env, gr, trig;
	// utilicemos una envolvente sencilla
	env = EnvGen.kr(Env.asr(2, 0.9, 3), gate, doneAction:2);

	// Necesitamos un trigger para disparar los granos.
	// Impulse es un buen trigger, asignamosle una frecuencia
	// controlada por MouseY.
	// otra opción es utilizar Dust

	trig = Impulse.ar(MouseY.kr(10, 1000));
	//trig = Dust.ar(MouseY.kr(10, 1000));

	gr = GrainSin.ar(2, trig,
	// La duración del grano va a ser controlada por un MouseX,
		MouseX.kr(0.001, 0.1),
	// y la frecuencia por un LFNoise1, un UGen que genera un
	// nuevo valor aleatorio cada 3 segundos y los une
	// con una linea recta.
	// Para complementar le vamos a sumar un valor aleatorio a
	// la frecuencia de cada grano para evitar que el sonido sea
	// demasiado homogeneo.
	// TRand genera un valor aleatorio dentro de un rango definido cada vez que
	// recibe un trigger.
		LFNoise1.kr(0.33).range(20, 10000)+TRand.ar(-1000, 1000, trig),
	// Finalmente una onda triangular nos va a ayudar a mover el
	// sonido en el espacio de izquierda a derecha lentamente
		LFTri.ar(0.09));


	Out.ar(0, gr*amp*env);


}).add
)

// Creamos una instancia del sintetizador
// cuidado con la amplitud
~gran1 = Synth(\gran1)

~gran1.set(\amp, 0.2)
// Mueve el ratón, hacia la izquierda los granos se hacen más y
// más pequeños en duración. Hacia arriba aumentan en densidad, llegando a producirse 1000 granos por segundo.

// Apaga el sintetizaor
~gran1.set(\gate,0)


// GrainBuf
//------------


GrainBuf.ar(
	-> numChannels: 1,
	-> trigger: 0,
	-> dur: 1,
	-> sndbuf: define el buffer de audio de donde se generarán los granos
	-> rate: la velocidad a la cual se reproducirá cada grano, si es
	 igual a 2 el grano sonará una octava mas agudo, si es 0.5 sonará una
	 octaava más grave.
	-> pos: posición en el buffer de audio de la cual se producirá el grano.
	-> interp:  interpolación entre samples para implementar el cambio
	 de velocidad de reproducción de los granos.
	-> pan: 0,
	-> envbufnum: -1,
	-> maxGrains: 512,
	-> mul: 1,
	-> add: 0

	// Carga un Buffer
	// ------------------------------------------------------------------------

	// Buffer.read(server, path, startFrame: 0, numFrames: -1, action, bufnum)

	~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/cello3.wav", bufnum:0)

	~buf = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "cello3.wav", bufnum:0)



	Platform.resourceDir

	// Carga un solo canal del Buffer
	// ------------------------------------------------------------------------
	~bufM = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/cello3.wav", channels: 0, bufnum:1)


	(
		SynthDef(\gran2, {|amp 0.1, gate 1, buf 1|
			var env, gr, trig;

			env = EnvGen.kr(Env.asr(2, 0.9, 3), gate, doneAction:2);
			// El trigger puede ser un Impulse o un Dust, cada uno tiene implicaciones
			// diferentes


			//trig = Impulse.ar(500);
			trig = Dust.ar(500);

			// Para el granulador vamos a controlar la duración del grano con un MouseY
			// con un rango definido entre 0.001s y 0.5 segundos.
			// El buffer lo va a determinar el argumento "buf", rate lo vamos a mantener
			// en 1 y la posición en el Buffer de dónde se va a producir el grano la vamos
			// a determinar con un MouseX con un rango definido entre 0 y 1.
			gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, MouseX.kr(0.0, 1.0));


			// A continuación dejo comentadas otras posibilidades de control del UGen
			// para probar
			// para ejecutarlas solo comenta la linea anterior y quitan el comentario
			// de la linea que quieren utilizar.

			// Esta linea agrega un SinOsc a la posición del grano en el buffer para
			// generar un tipo de vibrato en el sonido.
			// gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, MouseX.kr(0.0, 1.0)+SinOsc.ar(3, 0, 0.01));

			// En esta linea la posición del grano se toma de una posición aleatoria
			// utilizando un TRand.
			// gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, TRand.ar(0.0, 1.0, trig));
			// En esta linea utilizamos la posibilidad de expandir canales mediante
			// el uso de arreglos para producir 4 señales con diferentes velocidades
			// de reproducción.
			// La velocidad de reproducción es controlada por valores producidos
			// utilizando midiratio, lo que nos permite producir sonido afinados
			// por semitonos a partir del sonido original del audio.
			// gr = Mix(GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, [0,4,-5, -12].midiratio, MouseX.kr(0.0, 1.0)));

			Out.ar(0, gr*amp*env);

		}).add
	)

	//Ejecutemos el sintetizador!!!

	~gran2 = Synth(\gran2)

	~gran2.set(\amp, 0.1)
	/* sobre las otras posibilidades de control del UGen:

         Esta linea agrega un SinOsc a la posición del grano en el buffer para
		 generar un tipo de vibrato en el sonido.
gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, MouseX.kr(0.              0, 1.0)+SinOsc.ar(3, 0, 0.01));

		En esta linea la posición del grano se toma de una posición aleatoria
		utilizando un TRand.
 gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, TRand.ar(0.0, 1.0, trig));

	   En esta linea utilizamos la posibilidad de expandir canales mediante
	   el uso de arreglos para producir 4 señales con diferentes velocidades
	   de reproducción.
	   La velocidad de reproducción es controlada por valores producidos
	   utilizando midiratio, lo que nos permite producir sonido afinados
	   por semitonos a partir del sonido original del audio.
gr = Mix(GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, [0,4,-5, -12].midiratio, MouseX.kr(0.0, 1.0)));     */

	//Si tienen varios buffers declarados pueden utilizar esta linea para
	//alternar.
	//¡¡El buffer debe contener un solo canal!!

	~bufM1 = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/aguahirviendo.wav", channels: 0, bufnum:2)
	~bufM2 = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/TrenLento.wav", channels: 0, bufnum:3)
	~bufM3 = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/birds.wav", channels: 0, bufnum:4)



	~gran2.set(\buf, 4)

	//Apagamos el Sintetizador
	~gran2.set(\gate,0)
