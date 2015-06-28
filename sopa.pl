%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Pueden probar las funciones principales con estos predicados:			 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%horizontalesOeste( [i,h],[[a,b,c], [d,e,f],[g,h,i]], A).
%horizontalesEste( [e,f],[[a,b,c], [d,e,f],[g,h,i]], A).
%verticalesNorte( [g,d],[[a,b,c], [d,e,f],[g,h,i]], A).
%verticalesSur( [c,f],[[a,b,c], [d,e,f],[g,h,i]], A).

empezarBien :-
write('Ingrese la sopa de letras en forma de lista de listas.Debe ser cuadrada'),
SOPA1 = [[h,o,l,a,r,q,d],[a,f,g,h,q,x,y],[m,m,a,f,f,f,q],[f,q,r,g,u,k,l],[r,f,q,f,v,x,g],[r,f,j,a,x,z,q],[b,c,q,c,x,h,e]],
tab(20),
print(SOPA1),
matrizCuadrada(SOPA1),
tab(20),
write('ingrese la palabra a buscar'),
read(Palabra).
%faltan:
%string_to_list
%buscarpalabra

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Funciones principales													 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%matrizCuadrada(+Lista)
matrizCuadrada([]).
matrizCuadrada([A|[]]).
matrizCuadrada([A,B|T]):-
length(A,LENGTH1),
length(B,LENGTH2),
LENGTH1==LENGTH2,
matrizCuadrada([B|T]).

%horizontalesEste(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Horizontal
% Sentido Oeste-->Este
horizontalesEste(_,[],_).
horizontalesEste(X,A,C) :-  encontrar(X,A,C), subconjunto(C,A).

%horizontalesOeste(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Horizontal
% Sentido Este-->Oeste
horizontalesOeste(_,[],_).
horizontalesOeste(X,A,C) :- invertir(X,Z), encontrar(Z,A,C), subconjunto(C,A).

%verticalesSur(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Vertical
% Sentido Norte-->Sur
verticalesSur(_,[],_).
verticalesSur(X,A,C) :- getVerticales(A,V), encontrar(X,V,C), subconjunto(C,V).

%verticalesNorte(+lpalabra,+Sopa,subconjuto de sopa que contiene "palabra")
% Direccion Vertical
% Sentido Sur-->Norte
verticalesNorte(_,[],_).
verticalesNorte(X,A,C) :- invertir(X,Z), getVerticales(A,V) , encontrar(Z,V,C), subconjunto(C,V).

%Busca en una fila en sentido --> si encuentra la palabra dada
%encontrar(+lpalabra,+Sopa,-listas que contienen la palabra)
encontrar(_,[],_).
encontrar(X,[A|AS],C):- sublist(X, A), contienelista(A,C), encontrar(X,AS,C).
encontrar(X,[_|AS],C):- encontrar(X,AS,C).


find(_,[],_).
find(X,[A|AS],C):- sublist(X, A), contienelista(A,C), find(X,AS,C).
find(X,[_|AS],C):- find(X,AS,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Funciones auxiliares													 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Invierte la lista que recibe en el primer nivel
invertir([X],[X]).
invertir([X|M],Z):-invertir(M,S), concatenar(S,[X],Z).

%Concatena dos listas
concatenar([],L,L).
concatenar([X|M],L,[X|Z]):-concatenar(M,L,Z).

%subconjunto(subconjunto, conjunto) ambas son listas de listas
subconjunto([],_).
subconjunto([A|AS] , B):- contienelista(A,B), subconjunto(AS,B).

% Verifica si la primer lista se encuentra en la segunda lista
%contienelista(lista, listadeLista)
contienelista([],_):-!.
contienelista(L,[L|_]).
contienelista(L,[_|M]):-contienelista(L,M).
    
%Determina si la primera es sublista de la segunda
sublist( [], _ ).
sublist( [X|XS], [X|XSS] ) :- sublist( XS, XSS ).
sublist( [X|XS], [_|XSS] ) :- sublist( [X|XS], XSS ).

% getVertical(+Sopa, -Columna, +Filas)
%   Obtiene una columna de la sopa de letras.
getVertical([], [], []).
getVertical([[S|Opitas]|Resto], [S|Columna], [Opitas|Filas]) :-  getVertical(Resto, Columna, Filas).

% getVerticales(+Sopa, -Verticales)
%   Obtiene la lista con todas las columnas de la sopa de letras.
getVerticales([[]|_], []).
getVerticales(Sopa, [Vertical|Resto]) :- getVertical(Sopa, Vertical, Opa),  getVerticales(Opa, Resto).
