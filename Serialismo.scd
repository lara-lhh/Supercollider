s.boot;
~arr = [0,9,4,7]
(
Pbind(
	\note, Pseq(~arr, 5),
	\dur, 0.5,
).play;
)
~arr = [0,9,4,7]+1
~arr = [0,9,4,7]+2
~arr = [0,9,4,7]+3
~arr = [0,9,4,7]+4

(
~arr = [0,9,4,7,5];
~resultado = [];
10.do({arg i;
	~resultado = ~resultado ++(~arr+i)});
~resultado
)
(
Pbind(
	\note, Pseq(~resultado,1),
	\dur, 0.2,
).play
)
//retrógrado: reverse

(
Pbind(
	\note, Pseq(~resultado.reverse,1),
	\dur, 0.2,
).play
)

//inversión
//invesrión de una nota con respecto a un eje:
//inv = -x + n
//Función que genera invesrión de una misma:
~notas= [0,4,7]
(
~inv = {|list, n=0|
	var ret = list.collect({|elem|((-1)*elem+n)
	});
	ret;
};
)
~inv.value(~notas, 10).plot(discrete:true);

~arr = [0,5,9,2,4,7,0,\r]
//grafica discreta para ver los puntos
//vemos que son espejos el uno del otro
~arr.plot(discrete:true);
~inv.(~arr).plot(discrete:true);
//melodía primera parte original segunda concatenada con la inv: concatenar es ++
(
Pbind(
	\note, Pseq(~arr, 1)++Pseq(~inv.value(~arr,3),1),
	\dur, 0.2,
).play;
)

//-------------------------
//permutaciones: n! diferentes permutaciones
//--------------------
~lista = [0,1,2];
//entre paréntesis cuál es la permutación que deseamos, supercollider usa un orden de mayor a menor orgen en complejidad
~lista.permute(0);
~lista.permute(1);
~lista.permute(2);
~lista.permute(3);
~lista.permute(4);
~lista.permute(5);
//permutaciones en ciclos
(
~lista = [0,1,2];
24.do({arg i;
	~lista.permute(i).postln;
})
)
(
~lista = [0,1,2,3,4,5,6,7];
~listalarga = [];
24.do({arg i;
	~listalarga = ~listalarga ++ ~lista.permute(i)++[\r];
});
~listalarga.postln;
)
//lo escuchamos
(
Pbind(
	\note, Pseq(~listalarga,1),
	\dur, 0.1,
).play;
)
// cuando en Pbind metemos scale, los elementos de pseq ya no representan semitonos sino grados de la escala y por tanto ya no usamos el notes sino el degrees.
//escala mayor

(
Pbind(
	\scale, Scale.major,
	\degree, Pseq(~listalarga,1),
	\dur, 0.2
).play;
)
//escala menor
(
Pbind(
	\scale, Scale.minor,
	\degree, Pseq(~listalarga,1),
	\dur, 0.2
).play;
)

//metemos inv a una menor

(
~inv = {|list, n=2|
	var ret = list.collect({|elem|((-1)*elem+n)
	});
	ret;
};
)
(
Pbind(
	\scale, Scale.minor,
	\degree, Pseq(~inv.(~listalarga),1),
	\dur, 0.2
).play;
)
//otras escalas


