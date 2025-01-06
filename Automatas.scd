

Arrray.fill(N, {|i| función}) produce
un arreglo con N elementos producidos
por función.



Automatas Celulares


Vecindad

01010

Cada celula puede estar en uno de dos estados, 1 ó 0, y dependiendo del estado en que se encuentre la celula y sus vecinos, será el estado que adopte la celula en la siguiente evolución.

Por ejemplo, el siguiente patron define una evolución:

101
 1

Tenemos que el esquema de evolución se puede representar con 3 bits, lo que signifíca que podemos tene 2^3=8 posibles combinaciones de estados.

111 , 110, 101, 100, 011, 010, 001, 000

A cada posible combinación se le asigna una posible evolución, a esto se le llama: regla.

Hay 256 reglas diferentes y se reconocen por el número que representan en sistema binario.

por ejemplo, esta seria la regla uno:

111 , 110, 101, 100, 011, 010, 001, 000
 0     0    0    0    0    0    0    1

Y esta la regla 88:

111 , 110, 101, 100, 011, 010, 001, 000
 0     1    0    1    1    0    0    0


// Genera un patrón inicial
(
~num = 48;
~startPattern = Array.fill(~num,{|i|
	if(i == (~num/2).asInteger, {1}, {0})
});
)


/* ..............................................................
Genera un patrón inicial con 75% probabilidad de un número sea 0
y 25% de probabilidad de que sea 1
...............................................................*/
(
~num = 48;
~startPattern = Array.fill(~num,{|i|
	[0,1].wchoose([0.75, 0.25]);
});
)

/*...........
Dictionary
...........*/


~rule150 = Dictionary.with(*[7->1, 6->0, 5->0, 4->1, 3->0, 2->1, 1->1, 0->0]);

- Apply transformationFunction

~rule150.at(7)
~rule150.at(6)
~rule150.at(5)
~rule150.at(4)
~rule150.at(3)
~rule150.at(2)
~rule150.at(1)
~rule150.at(0)


/*.............
 Función
.............*/

~step = 0;
~outputMatrix = Array.newClear(100)

(

~update = {arg sPattern = Array.fill(~num, {|i| if(i != 24, {0}, {1})}),
	rule = Dictionary.with(*[7->1, 6->0, 5->0, 4->1, 3->0, 2->1, 1->1, 0->0]),
	numIterations = 50;

	var key = 0, newPattern = Array.fill(~num, 0);
	//~step.postln;
	~outputMatrix[~step] = sPattern;

	sPattern.do({|item, i|

		var last = (~num-1).asInteger;

		if(i == 0, {

			key = (sPattern[last]*4) + (sPattern[i]*2) + (sPattern[i+1]);

		});

		if(i == last, {

			key = (sPattern[i-1]*4) + (sPattern[i]*2) + (sPattern[0]);

		});

		if((i > 0) && (i < last),{
			key = (sPattern[i-1]*4) + (sPattern[i]*2) + (sPattern[i+1]);
		});

		//key.postln;
		newPattern[i] = ~rule150.at(key);

	});

	~step = ~step + 1;

	if(~step < numIterations, {
		newPattern.postln;
		~update.value(newPattern, ~rule150, numIterations);

	});

})

//Echamos a andar el código.

(
~step = 0;
~outputMatrix = Array.newClear(100);
~out = ~update.value(~startPattern, ~rele150, 100)
)

a = ~outputMatrix[0]


/*..................................
Autómatas utilizados para el sonido.
....................................*/

Declaremos algunos sintes para hacer sonar el autómata
Leamoslo en orden y sonemos el sinte acell cada que hay un uno
conforme leamos el arreglo vamos a avanzar nota en una escala que escojamos


(
SynthDef(\acell, {|freq 432, gate 1, amp 1, pos 0|
	var sig, env, fx, pan, rev1, rev2;

	// Envolvente
	env = EnvGen.kr(Env.perc(0.02, 0.98), gate, timeScale:1, doneAction:2);

	// Generador de Señal
	sig = SinOsc.ar(freq, 0, 1) * Decay.ar(Impulse.ar(4), 1 / 4);

	// Efectos
	fx = DelayC.ar(sig, 0.2, 0.125);
	rev1 = FreeVerb.ar(fx, 0.75, 0.89, 0);
	pan = Pan2.ar(rev1, pos);

	// Salida de audio
	Out.ar(0, (pan+sig)*env*amp)


}).add
)

 Synth(\acell, [\pos, 1])

// Este sinte nos servirá de acompañamiento.
(
SynthDef(\snare, {|freq 160, amp 1, gate 1|
	var env, sig, fx, env2;

	env = EnvGen.kr(Env.perc(0.01, 1.5), gate, doneAction:2);
	env2 = EnvGen.kr(Env.perc(0.01, 0.125), gate);

	sig = SinOsc.ar(freq, 0, 1) + PinkNoise.ar(0.125)*env2;
	fx  = FreeVerb.ar(sig, 0.5, 0.4, 0.1)!2;

	Out.ar(0, fx*env*amp)

}).add

)

Synth(\snare, [\freq, 180])

Scale.directory

// Escojemos una escala

~scale = Scale.whole.degrees
~scale = Scale.minorPentatonic.degrees
~mel = ~scale.scramble

Leamos los elementos del outputmatrix con una rutina
mediante el metodo .do

(
{
	~outputMatrix.do({|item| item.postln;

		item.do({|item, i|

			if(item == 1, {
				Synth(\acell, [\freq, (60+~scale[(i%5)]).midicps, \amp, 0.2]);
				Synth(\acell, [\freq, (60+~mel[(i%5)]).midicps, \amp, 0.2]);
			});

			if(i%4 == 0, {
				Synth(\snare, [\freq, 80, \amp, 0.3])
			});

			if((i%6 == 0) || ((i%7 == 0)), {
				Synth(\snare, [\freq, 180, \amp, 0.3])
			});

			0.125.wait;
		})

	})
}.fork
)

/*..................................................
Introducción a las máquinas de estado finito, (MEF).
....................................................*/


// II- D F A C -PC: [2, 5, 9, 0]
~dos  = [2, 5, 9, 0]

// V - G B D F -PC: [7, 11, 2, 5]
~cinco = [7, 11, 2, 5]

// I - C E G B -PC: [0, 4, 7, 11]
~uno = [0, 4, 7, 11]

(
p = Pfsm([
	// Definición del estado inicial
	#[0],
	//Este es el item que devuelve la función cuando está en el primer estado, el cero.
	Pbind(\instrument, \acell,
		\freq, Pseq([(60+~uno[0]).midicps, (60+~uno[2]).midicps, (60+~uno[0]).midicps, (72+~uno).midicps]),
		\dur, Pseq([0.25, 0.25, 0.5, 1]),
		\legato, 1.25,
		\amp, 0.2),
	//Este arreglo define los estados a los cuales puede transitar en su siguiente paso.
	#[1,2],
	//Este es el item que devuelve la función cuando está en el segundo estado, el uno.
	Pbind(\instrument, \acell,
		\freq, Pseq([(60+~dos[1]).midicps, (60+~dos[0]).midicps, (72+~dos).midicps, (60+~dos[2]).midicps]),
		\dur, Pseq([0.25, 0.25, 0.5, 1]),
		\legato, 1.25,
		\amp, 0.2),
	//Este arreglo define los estados a los cuales puede transitar en su siguiente paso.
	#[2,0],
	//Este es el item que devuelve la función cuando está en el segundo estado, el uno.
	Pbind(\instrument, \acell,
		\freq, Pseq([(60+~cinco).midicps, (60+~cinco).midicps, \r, (60+~cinco).midicps]),
		\dur, Pseq([0.25, 0.5, 0.25, 1]),
		\legato, 1.25,
		\amp, 0.2),
	//Este arreglo define los estados a los cuales puede transitar en su siguiente paso.
	#[0, 1],
	nil, nil
]).play;
)

t = TempoClock.default
t.tempo_(1)

// Un Pfsm que arroja valores como resultado

(
a = Pfsm([
        #[0,1],
        62, #[0, 0, 3],
        65, #[2],
        69, #[0, 2],
        Pseq([79, 83, 74, 77], 2), #[2, 3, 3],
        nil, nil
    ], inf).asStream;


Routine({
    loop({
        Synth(\acell, [\freq, a.next.midicps]);
        1.wait;
    })
}).play;
)

// Final de FSM's





