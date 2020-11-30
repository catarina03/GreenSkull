:-use_module(library(random)).

pc_pc:-
    initial(GameState-Player-GreenSkull),
    write('                   Choose Orcs level:     '),nl,
    get_level(LevelO),
    write('                   Choose Goblins level:     '),nl,
    get_level(LevelG),
    play_game(GameState-[0,0,0],Player,GreenSkull,LevelO-LevelG).

levelPlayer(Level):-
    write('                  |         L E V E L       |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |         1. Easy         |'),nl,
    write('                  |         2. Hard         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,
    write('               Option: '),read(Level),nl,nl.

play_game(GameState-[PO,PG,PZ],Player,GreenSkull,LevelO-LevelG):-
    display_game(GameState-GreenSkull,Player),
    choose_level_round(Player,GreenSkull,LevelO-LevelG,Level),
    choose_move(GameState, Player,Level,Move)​,
    move(GameState-[PO,PG,PZ]-Player,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),
    next(Player,NewGameState-[PO1,PG1,PZ1],GreenSkull,LevelO,LevelG).


choose_level_round(o,_,LO-_,Level):-Level=LO.
choose_level_round(g,_,_-LG,Level):-Level=LG.
choose_level_round(z,o,LO-_,Level):-Level=LO.
choose_level_round(z,g,_-LG,Level):-Level=LG.

%função com 2 argumento extra.
next(Player,GameState-[PO1,PG1,PZ1],GreenSkull,LevelO,LevelG):-
    \+ game_over(GameState-[PO1,PG1,PZ1], _),!,
    display_scores(PO1-PG1-PZ1),
    set_next_player(Player, NextPlayer),
    play_game(GameState-[PO1,PG1,PZ1], NextPlayer, GreenSkull,LevelO-LevelG).

%using random:
choose_move(GameState,Player,1,Move):-
    find_piece(GameState,Player,RowPiece-ColumnPiece),
    find_move(GameState,RowPiece-ColumnPiece,Row-Column),
    Move=RowPiece-ColumnPiece-Row-Column.

find_piece(GameState,Player,RowPiece-ColumnPiece):-
    %repeat?
    %encontrar lista onde estão as peças ou as peças disponiveis para usar
    valid_pieces(GameState,Player,List),
    length(List,N),
    %fazer random para fazer escolher peça a mover
    random_between(1,N,R),
    nth1(R,List,Piece),
    Piece=[RowPiece,ColumnPiece],
    valid_piece(GameState,Player,RowPiece,ColumnPiece),!.

%Return all coordenates of Player
valid_pieces(GameState,Player,List):-
    find_pieces(GameState,Player,1,List).

%muda as linhas
find_pieces(GameState,Player,NRow,[L1|R]):-
    NRow=<10,
    nth1(NRow,GameState,Row),
    member(Player,Row),
    getCoordenates(Row,NRow-1,Player,L1),
    NewNRow is NRow+1,
    find_pieces(GameState,Player,NewNRow,R).

find_pieces(_,_,11,[]).

find_pieces(_,_,NRow,[_|R]):- 
    NewNRow is NRow+1,
    find_pieces(GameState,Player,NewNRow,R)

%muda as colunas
getCoordenates(Row,NRow-NColumn,Player,[L1|R]):-
    NColumn=<NRow,
    nth1(NColumn,Row,Elem),
    Elem==Player,
    L1=[NRow,NColumn],
    NewNColumn is NColumn+1,
    getCoordenates(Row,NRow-NewNColumn,Player,R).

getCoordenates(_,NRow-NColumn,_,L):-
    NextNRow is NRow+1,
    NColumn==NextNRow,
    L=[].

getCoordenates(Row,NRow-NColumn,Player,[_|R]):-
    NewNColumn is NColumn+1,
    getCoordenates(Row,NRow-NewNColumn,Player,R).


find_move(GameState,RowPiece-ColumnPiece,Row-Column):-
    %fazer random para fazer escolher para onde mover
    valid_moves(GameState, _-RowPiece-ColumnPiece, ListAdjacentMoves-ListEatMoves),
    random_between(1,2,RList),
    choose_list(ListAdjacentMoves-ListEatMoves,RList,List),
    length(List,N),
    random_between(1,N,R),
    nth1(R,List,Move),
    Move=[Row,Column].

choose_list(ListAdjacentMoves-_,1,ListAdjacentMoves).
choose_list(_-ListEatMoves,2,ListEatMoves).





%using greedy algorithm:
choose_move(GameState,Player,2,Move):-
    %https://www.cs.unm.edu/~luger/ai-final/code/PROLOG.best.html