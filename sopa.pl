%% TP PROLOG
%auxencontrarEnHorizontales(+lpalabra,+Sopa,-listas que contienen la palabra)
auxencontrarEnHorizontales(_,[],_).
auxencontrarEnHorizontales(X,[A|AS],C):- sublista(X, A), contienelista(A,C), auxencontrarEnHorizontales(X,AS,C).
auxencontrarEnHorizontales(X,[_|AS],C):- auxencontrarEnHorizontales(X,AS,C).

%encontrarEnHorizontales(+lpalabra,+Sopa,-listas que contienen la palabra)
encontrarEnHorizontales(_,[],_).
encontrarEnHorizontales(X,A,C) :-  auxencontrarEnHorizontales(X,A,C), subconjunto(C,A).

lista([]):-!.
lista([_|Y]):-lista(Y).

%subconjunto(subconjunto, conjunto) ambas son listas de listas
subconjunto([],_).
subconjunto([A|AS] , B):- contienelista(A,B), subconjunto(AS,B).

%*15-Determina si la primer lista es prefijo de la segunda*/

prefijo([],_):-!.
prefijo([X],[X|_]):-!.
prefijo([X|L],[X|M]):-prefijo(L,M).
prefijo([X|T],[L|M]):-lista(X),prefijo(X,L),prefijo(T,M).
/*------------------------------------------------------------------*/

%contienelista(lista, listadeLista)
contienelista([],_):-!.
contienelista(L,[L|_]).
contienelista(L,[_|M]):-contienelista(L,M).
    
%16-Determina si la primer lista es sublista de la segunda*/
sublista([],_):-!.
sublista(L,[X|M]):-prefijo(L,[X|M]).
sublista(L,[_|M]):-sublista(L,M).

%reverseall(+Normal, ?Raras)
%   Devuelve en Raras una lista con todas las palabras de Normal pero inversas.
reverseall([],[]).
reverseall([X|Xs], [Y|Ys]) :-
  reverse(X, Y),
  reverseall(Xs, Ys).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Funciones para obtener todas las palabras de la sopa de letra indicada  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getVertical(+Sopa, -Columna, +Filas)
%   Obtiene una columna de la sopa de letras.
getVertical([], [], []).
getVertical([[S|Opitas]|Resto], [S|Columna], [Opitas|Filas]) :-
  getVertical(Resto, Columna, Filas).

% getVerticales(+Sopa, -Verticales)
%   Obtiene la lista con todas las columnas de la sopa de letras.
getVerticales([[]|_], []).
getVerticales(Sopa, [Vertical|Resto]) :-
  getVertical(Sopa, Vertical, Opa),
  getVerticales(Opa, Resto).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% nVacias(?Num, -Vacias)
%   Crea una lista con un caracter "vacio" o no valido para la sopa de letras.
%   ($ en nuestro caso), utilizado para poder desfasar la matriz y obtener las
%   diagonales.
nVacias(0,[]).
nVacias(N, [$|Vacias]) :-
  N > 0,
  NResto is N - 1,
  nVacias(NResto, Vacias).

% quitarVacias(+Sucias, ?Diagonales)
%   Quita los caracteres "vacios" de las palabras obtenidas en Sucias que son
%   las palabras que corresponden a las diagonales de la matriz.
quitarVacias([], []).
quitarVacias([Verti|Cales], [Diago|Nales]) :-
  delete(Verti, $, Diago),
  quitarVacias(Cales, Nales).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getDiagPrinc(+Sopa, +Tam, -DiagPrinc)
%   Funcion que obtiene todas las palabras de la sopa de letras en direccion
%   NorOeste -> SurEste
getDiagPrinc(Sopa, Tam, DiagPrinc) :-
  N is Tam - 1,
  getDesfasadasPrinc(Sopa, N, 0, Defasadas),
  getVerticales(Defasadas, Verticales),
  quitarVacias(Verticales, DiagPrinc).

% getDesfasadasPrinc(+Sopa, ?Izq, ?Der, -Desfasadas)
%   Desfasa las filas de la sopa de letras para poder obtener las palabras
%   diagonales NorOeste -> SurEste
getDesfasadasPrinc([], -1, _, []).
getDesfasadasPrinc([Sopi|Tas], Izq, Der, [SopiDes|Fasadas]) :-
  Izq >= 0,
  IzqN is Izq - 1,
  DerN is Der + 1,
  nVacias(Izq, LIzq),
  nVacias(Der, LDer),
  append(LIzq, Sopi, IzqSopita),
  append(IzqSopita, LDer, SopiDes),
  getDesfasadasPrinc(Tas, IzqN, DerN, Fasadas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getDiagSecun(+Sopa, +Tam, -DiagSecun)
%   Funcion que obtiene todas las palabras de la sopa de letras en direccion
%   NorEste -> SurOeste
getDiagSecun(Sopa, Tam, DiagSecun) :-
  N is Tam - 1,
  getDesfasadasSecun(Sopa, 0, N, Defasadas),
  getVerticales(Defasadas, Verticales),
  quitarVacias(Verticales, DiagSecun).

% getDesfasadasSecun(+Sopa, ?Izq, ?Der, -Desfasadas)
%   Desfasa las filas de la sopa de letras para poder obtener las palabras
%   diagonales NorEste -> SurOeste
getDesfasadasSecun([], _, -1, []).
getDesfasadasSecun([Sopi|Tas], Izq, Der, [SopiDes|Fasadas]) :-
  Der >= 0,
  IzqN is Izq + 1,
  DerN is Der - 1,
  nVacias(Izq, LIzq),
  nVacias(Der, LDer),
  append(LIzq, Sopi, IzqSopita),
  append(IzqSopita, LDer, SopiDes),
  getDesfasadasSecun(Tas, IzqN, DerN, Fasadas).
