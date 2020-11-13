:-use_module(library(lists)).

% Reads input from user
input_play(Message,Row,Column) :-
    write(Message),nl,
    write('Row: '), read(Row),
    write('Column: '), read(Column),nl.



% This section is still a work in progress

% Player makes a move
move(GameState,Player,NewGameState):- 
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    choose_move(Player,GameState,RowPiece,ColumnPiece,NewGameState).



% Choose piece you want to move and sees if is valid
choose_piece(GameState,Player,Row,Column):-
    input_play('Which piece:',Row,Column),
    validPiece(GameState,Player,Row,Column),!, write('valid'),nl.

choose_piece(GameState,Player,Row,Column):-
    move(GameState,Player,NewGameState).


% Sees if the piece chosen is valid
validPiece(GameState,o,Row,Column) :- 
    nth1(Row,GameState,L),
    write(Row),
    nth1(Column,L,Elem),
    write(Column),
    write(Elem),
    Elem==o,!,
    write('validoooo').


validPiece(GameState,g,Row,Column) :- 
    nth1(Row,GameSatate,L),
    nth1(Column,L,Elem),
    Elem==g.


validPiece(GameState,z,Row,Column):-
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==z.


%choose where you want to move the piece and sees if is valid
choose_move(Player,GameState,RowPiece,ColumnPiece,NewGameState):-
    input_play('Where to:',Row,Column),
    valid_move(Player,RowPiece,ColumnPiece,Row, Column),
    change_board(RowPiece,ColumnPiece, Row, Column, NewGameState).

valid_move(Player,RowPiece,ColumnPiece,Row,Column):-
    nth1(Row,GameSatate,L),
    nth1(Column,L,Elem),
    Elem==e,
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column),
    R=<2,C=<2,!, sub_move(RowPiece,ColumnPiece,Row,Column) .

valid_move(Player,RowPiece,ColumnPiece,Row,Column):-
    move(GameState,Player,NewGameState).

sub_move(RowPiece,ColumnPiece,Row,Column):-
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column),
    R=<1, C=<1,!.

sub_move(RowPiece,ColumnPiece,Row,Column):-
    R is (Row-RowPiece)/2,
    C is (Column-ColumnPiece)/2,
    RM is RowPiece+R,CM is ColumnPiece+C.

