:-include('utils.pl').

% Reads input from user
input_play(Message,Row,Column) :-
    write(Message),nl,
    write('Row: '), read(Row),
    write('Column: '), read(Column),nl.


% Player makes a move
move(GameState,Player,NewGameState):- 
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    choose_move(Player,GameState,RowPiece,ColumnPiece,NewGameState).
    

% Choose piece you want to move and sees if is valid-------------------------------------
choose_piece(GameState,Player,Row,Column):-
    repeat,
    input_play('Which piece:',Row,Column),
    validPiece(GameState,Player,Row,Column),!, write('valid'),nl.


% Sees if the piece chosen is valid
validPiece(GameState,o,Row,Column) :- 
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==o.

validPiece(GameState,g,Row,Column) :- 
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==g.

validPiece(GameState,z,Row,Column):-
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==z.
%----------------------------------------------------------------------------------------


%choose where you want to move the piece and sees if is valid----------------------------
choose_move(Player, GameState, RowPiece, ColumnPiece, NewGameState):-
    repeat,
    input_play('Where to:',Row,Column),
    valid_move(Player,RowPiece,ColumnPiece,Row, Column, GameState, NewGameState).
    % change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState).

%
%RowPiece - piece we're moving
%Row - row we're going to
valid_move(Player, RowPiece, ColumnPiece, Row, Column, GameState, NewGameState):-
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==e,
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column), 
    R=<2,C=<2, 
    check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState).

% 
check_adjacent_movement(RowPiece, ColumnPiece, Row, Column) :-
    RowPiece == Row,  
    1 =< abs(ColumnPiece - Column).

check_adjacent_movement(RowPiece, ColumnPiece, Row, Column) :-
    RowPiece > Row,  
    ColumnPiece >= Column.

check_adjacent_movement(RowPiece, ColumnPiece, Row, Column) :-
    RowPiece < Row,  
    ColumnPiece =< Column.

% 7, 4
% 7,5;  6,4;  6,3;  7,3;  8,4;  8,5


% Verifies if destination cell is adjacent, if so it changes the board
check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState):-
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column),
    R=<1, C=<1,
    check_adjacent_movement(RowPiece, ColumnPiece, Row, Column),
    change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState).

% If player wants to eat something
% Checks if what's between current position and destination is something edible (not white space)
check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState):-
    RowTest is (Row-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (Column-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, ColumnFood is ColumnPiece + C,
    nth1(RowFood, GameState, L),
    nth1(ColumnFood, L, Elem),
    Elem \== e, !,
    % chama change board diferente que substitui a peça do meio (a "comida") por um white space tambem
    change_board(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState).


%----------------------------------------------------------------------------------------

change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    write('Start piece: '), write(ElemStart), nl,
    % Value of place piece is jumping to - end
    nth1(Row,GameState,ResultRowEnd),
    nth1(Column, ResultRowEnd,ElemEnd),
    write('End piece: '), write(ElemEnd), nl,
    % Switching places
    % Putting end element in starting place
    ResultRowStart == ResultRowEnd, !,
    replace(ResultRowStart, ColumnPiece, ElemEnd, IntermidiateRow),
    replace(GameState, RowPiece, IntermidiateRow, IntermidiateGameState),
    write('Replace: '), write(ResultRowStart), write(' with '), write(IntermidiateRow), nl,
    write('Game State: '), nl,
    write(IntermidiateGameState), nl, nl,
    % Putting end element in end place
    replace(IntermidiateRow, Column, ElemStart, FinalRow),
    replace(IntermidiateGameState, Row, FinalRow, NewGameState),
    write('Replace: '), write(IntermidiateRow), write(' with '), write(FinalRow), nl,
    write('Game State: '), nl,
    write(NewGameState).





change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    write('Start piece: '), write(ElemStart), nl,
    % Value of place piece is jumping to - end
    nth1(Row,GameState,ResultRowEnd),
    nth1(Column, ResultRowEnd,ElemEnd),
    write('End piece: '), write(ElemEnd), nl,
    % Switching places
    % Putting end element in starting place
    replace(ResultRowStart, ColumnPiece, ElemEnd, FinalRowStart),
    replace(GameState, RowPiece, FinalRowStart, IntermidiateGameState),
    write('Replace: '), write(ResultRowStart), write(' with '), write(FinalRowStart), nl,
    write('Game State: '), nl,
    write(IntermidiateGameState), nl, nl,
    % Putting end element in end place
    replace(ResultRowEnd, Column, ElemStart, FinalRowEnd),
    replace(IntermidiateGameState, Row, FinalRowEnd, NewGameState),
    write('Replace: '), write(ResultRowEnd), write(' with '), write(FinalRowEnd), nl,
    write('Game State: '), nl,
    write(NewGameState).

/*

% change elements from (RowPiece,ColumnPiece) para (Row, Column) 
change_board(RowPiece, ColumnPiece, Row, Column, GameState,NewGameState) :-
    write('Changes board!'), nl, 
    write('From [r/c]: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    write('To [r/c]: '), write(Row), write('/'), write(Column).


    */

% change elements from (RowPiece,ColumnPiece) para (Row, Column) 
change_board(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState) :-
    write('Changes board!'), nl, 
    write('From [r/c]: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    write('To [r/c]: '), write(Row), write('/'), write(Column), nl,
    write('And eats [r/c]: '), write(RowFood), write('/'), write(ColumnFood). 
