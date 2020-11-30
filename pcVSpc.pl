:-use_module(library(random)).
%:-include('game.pl').

pc_pc:-
    initial(GameState-Player-GreenSkull),nl,
    write('               Choose Orcs level:     '),nl,nl,
    get_level(LevelO),
    write('               Choose Goblins level:     '),nl,nl,
    get_level(LevelG),
    play_game(GameState-[0,0,0],Player,GreenSkull,LevelO-LevelG).

get_level(Level):-
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
    choose_move(GameState, Player,Level,Move),
    move(GameState-[PO,PG,PZ]-Player,Move, NewGameState-[PO1,PG1,PZ1]-_),
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

next(_,_-_,_,_,_).
%using random:
choose_move(GameState,Player,1,Move):-
    find_piece(GameState,Player,RowPiece-ColumnPiece),
    find_move(GameState,RowPiece-ColumnPiece,Row-Column),
    Move=RowPiece-ColumnPiece-Row-Column.

find_piece(GameState,Player,RowPiece-ColumnPiece):-
    %encontrar lista onde estão as peças ou as peças disponiveis para usar
    valid_pieces(GameState,Player,List),
    length(List,N),
    %fazer random para fazer escolher peça a mover
    get_random(N,R),
    nth1(R,List,Piece),
    Piece=[RowPiece,ColumnPiece],
    valid_piece(GameState,Player,RowPiece,ColumnPiece),!.

%Return all coordenates of Player
valid_pieces(GameState,Player,List):-
    find_pieces(GameState,Player,1,[],List).

%muda as linhas
find_pieces(GameState,Player,NRow,List,FinalList):-
    nth1(NRow,GameState,Row), 
    member(Player,Row),
    getCoordinates(Row,NRow-1,Player,[],List2),
    NewNRow is NRow+1,
    find_pieces(GameState,Player,NewNRow,List,AlmostList),
    append(List2,AlmostList,FinalList).

find_pieces(_,_,11,_,[]).

find_pieces(GameState,Player,NRow,List,FinalList):- 
    NewNRow is NRow+1,
    find_pieces(GameState,Player,NewNRow,List,FinalList).

%muda as colunas
getCoordinates(Row,NRow-NColumn,Player,List,FinalList):-
    NColumn=<NRow,
    nth1(NColumn,Row,Elem),
    Elem==Player,!,
    append(List,[[NRow,NColumn]],NewList),
    NewNColumn is NColumn+1,
    getCoordinates(Row,NRow-NewNColumn,Player,List2,AlmostList),
    append(NewList,AlmostList,FinalList).

getCoordinates(_,NRow-NColumn,_,_,[]):-
    NextNRow is NRow+1,
    NColumn==NextNRow.

getCoordinates(Row,NRow-NColumn,Player,List,FinalList):-
    NewNColumn is NColumn+1,
    getCoordinates(Row,NRow-NewNColumn,Player,List,FinalList).




find_move(GameState,RowPiece-ColumnPiece,Row-Column):-
    valid_moves(GameState, _-RowPiece-ColumnPiece, ListAdjacentMoves-ListEatMoves),
    random(1,2,RList),
    choose_list(ListAdjacentMoves-ListEatMoves,RList,List),
    length(List,N),
    get_random(N,R),
    nth1(R,List,Move),
    Move=[Row,Column].

choose_list(ListAdjacentMoves-_,1,ListAdjacentMoves).
choose_list(_-ListEatMoves,2,ListEatMoves).
choose_list([]-ListEatMoves,1,ListEatMoves).
choose_list(ListAdjacentMoves-[],2,ListAdjacentMoves).

get_random(N,R):-random(1,N,R).
get_random(1,1).
    

%using greedy algorithm:
choose_move(GameState,Player,2,Move).
    %https://www.cs.unm.edu/~luger/ai-final/code/PROLOG.best.html