%Scores ORCS:
change_score([PO,PG,PZ]-o-Elem,[PO1,PG1,PZ1]):-
    Elem \== e, 
    Elem \== o, 
    PO1 is PO+1,
    PG1 is PG,
    PZ1 is PZ.


%Scores GOBLINS:
change_score([PO,PG,PZ]-g-Elem,[PO1,PG1,PZ1]):-
    Elem \== e, 
    Elem \== g, 
    PO1 is PO,
    PG1 is PG+1,
    PZ1 is PZ.

%Scores ZOMBIES:
change_score([PO,PG,PZ]-z-Elem,[PO1,PG1,PZ1]):-
    Elem \== e, 
    Elem \== z, 
    PO1 is PO,
    PG1 is PG,
    PZ1 is PZ+1.

%if ELem=e, then scores stays the same
change_score([PO,PG,PZ]-_-_,[PO1,PG1,PZ1]):-
    PO1 is PO,
    PG1 is PG,
    PZ1 is PZ. 

%Final scores, depending on the number of the elements in their correspondent lines
final_scores(GameState-[PO,PG,PZ],[PO1,PG1,PZ1]):-
    orcs_final_score(GameState,PO,PO1),
    goblins_final_score(GameState,PG,PG1),    
    zombies_final_score(GameState,PZ,PZ1).
    
orcs_final_score(GameState,PO,PO1):-
    get_left_diagonal(GameState,1,1,L),
    orcs_in_line(L,N),
    PO1 is PO+(2*N).

goblins_final_score(GameState,PG,PG1):-
    goblins_line(GameState,1,L),
    goblins_in_line(L,N),
    PG1 is PG+(2*N).

goblins_line(GameState,Indice,[L1|R]):-
    Indice=<10,
    nth1(Indice,GameState,L),
    nth1(Indice,L,L1),
    Indice1 is Indice+1,
    goblins_line(GameState,Indice1,R).

goblins_line(_,11,[]).

zombies_final_score(GameState,PZ,PZ1):-
    nth1(10,GameState,L),
    zombies_in_line(L,N),
    PZ1 is PZ+(2*N).

%sees how many orcs are in their line
orcs_in_line([],0).
orcs_in_line([E|R],N):-
    E==o,
    orcs_in_line(R,N1),
    N is N1+1.

orcs_in_line([_|R],N):-
    orcs_in_line(R,N).

%sees how many goblins are in their line
goblins_in_line([],0).
goblins_in_line([E|R],N):-
    E==g,
    goblins_in_line(R,N1),
    N is N1+1.

goblins_in_line([_|R],N):-
    goblins_in_line(R,N).

%sees how many zombies are in their line
zombies_in_line([],0).
zombies_in_line([E|R],N):-
    E==z,
    zombies_in_line(R,N1),
    N is N1+1.

zombies_in_line([_|R],N):-
    zombies_in_line(R,N).