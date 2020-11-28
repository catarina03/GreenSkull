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
    orcs_in_line(GameState,10,N),
    PO1 is PO+(2*N).

goblins_final_score(GameState,PG,PG1):-
    goblins_in_line(GameState,10,N),
    PG1 is PG+(2*N).

zombies_final_score(GameState,PZ,PZ1):-
    zombies_in_line(GameState,10,N),
    PZ1 is Pz+(2*N).

%sees how many orcs are in their line
orcs_in_line(GameState,Indice,N):-
    nth1(Indice,GameState,L),
    nth1(1,GameState,E),
    E==o,
    N1 is N+1,
    NewIndice is Indice-1,
    orcs_in_line(GameState,NewIndice,N1).

orcs_in_line(GameState,Indice,N):-
    NewIndice is Indice-1,
    orcs_in_line(GameState,NewIndice,N).

orcs_in_line(GameState,0,N).

%sees how many goblins are in their line
goblins_in_line(GameState,Indice,N):-
    nth1(Indice,GameState,L),
    nth1(Indice,GameState,E),
    E==g,
    N1 is N+1,
    NewIndice is Indice-1,
    goblins_in_line(GameState,NewIndice,N1).

goblins_in_line(GameState,Indice,N):-
    NewIndice is Indice-1,
    goblins_in_line(GameState,NewIndice,N).

goblins_in_line(GameState,0,N).

%sees how many zombies are in their line
zombies_in_line(GameState,Indice,N):-
    nth1(Indice,GameState,L),
    nth1(Indice,GameState,E),
    E==z,
    N1 is N+1,
    NewIndice is Indice-1,
    zombies_in_line(GameState,NewIndice,N1).

zombies_in_line(GameState,Indice,N):-
    NewIndice is Indice-1,
    zombies_in_line(GameState,NewIndice,N).

zombies_in_line(GameState,0,N).