:-include('utils.pl').

% Reads input from user
input_play(Message,Row,Column) :-
    write(Message),nl,
    write('  Row: '), read(Row),
    write('  Column: '), read(Column),nl.


% Player makes a move
move(GameState-[PO,PG,PZ],Player,NewGameState-[PO1,PG1,PZ1]):- 
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    choose_move(Player,GameState,RowPiece,ColumnPiece,NewGameState-Elem),
    change_pontuation([PO,PG,PZ]-Player-Elem,[PO1,PG1,PZ1]),
    write(Elem),
    write([PO,PG,PZ]),
    write([PO1,PG1,PZ1]).
    

% Choose piece you want to move and sees if is valid-------------------------------------
choose_piece(GameState,Player,Row,Column):-
    repeat,
    input_play('  Which piece:',Row,Column),
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
choose_move(Player, GameState, RowPiece, ColumnPiece, NewGameState-Elem):-
    repeat,
    input_play('  Where to:',Row,Column),
    valid_move(Player,RowPiece,ColumnPiece,Row, Column, GameState, NewGameState-Elem).
    % change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState).

%
%RowPiece - piece we're moving
%Row - row we're going to
valid_move(Player, RowPiece, ColumnPiece, Row, Column, GameState, NewGameState-Elem):-
    nth1(Row,GameState,L),
    nth1(Column,L,ElemEnd),
    ElemEnd==e,
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column), 
    R=<2,C=<2, 
    write('hello1'),
    check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState-Elem),
    write('hello2').

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
check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState,NewGameState-Elem):-
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column),
    R=<1, C=<1,
    check_adjacent_movement(RowPiece, ColumnPiece, Row, Column),
    change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState),
    Elem=e.

% If player wants to eat something
% Checks if what's between current position and destination is something edible (not white space)
check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState-Elem):-
    RowTest is (Row-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (Column-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, ColumnFood is ColumnPiece + C,
    nth1(RowFood, GameState, L),
    nth1(ColumnFood, L, Elem),
    Elem \== e, !,
    % chama change board diferente que substitui a peça do meio (a "comida") por um white space tambem
    change_board(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState).


%----------------------------------------------------------------------------------------


% Changes the board by simulating the movement of a piece
% The piece starts at position [RowPiece, ColumnPiece] and goes to [Row, Column]
% The final board is placed in variable NewGameState

% Works for movement in the same row
change_board(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    % Value of place piece is jumping to - end
    nth1(Row,GameState,ResultRowEnd),
    nth1(Column, ResultRowEnd,ElemEnd),
    % Switching places
    % Putting end element in starting place
    ResultRowStart == ResultRowEnd, !,
    replace(ResultRowStart, ColumnPiece, ElemEnd, IntermidiateRow),
    replace(GameState, RowPiece, IntermidiateRow, IntermidiateGameState),
    % Putting end element in end place
    replace(IntermidiateRow, Column, ElemStart, FinalRow),
    replace(IntermidiateGameState, Row, FinalRow, NewGameState).

% Works for movement across different rows
change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    % Value of place piece is jumping to - end
    nth1(Row,GameState,ResultRowEnd),
    nth1(Column, ResultRowEnd,ElemEnd),
    % Switching places
    % Putting end element in starting place
    replace(ResultRowStart, ColumnPiece, ElemEnd, FinalRowStart),
    replace(GameState, RowPiece, FinalRowStart, IntermidiateGameState),
    % Putting end element in end place
    replace(ResultRowEnd, Column, ElemStart, FinalRowEnd),
    replace(IntermidiateGameState, Row, FinalRowEnd, NewGameState).


% Falta incrementar a pontuação
change_board(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    write('Start piece: '), write(ElemStart), nl,
    % Value of food piece 
    nth1(RowFood,GameState,ResultRowFood),
    nth1(ColumnFood, ResultRowFood,ElemFood),
    write('Food piece: '), write(ElemFood), nl,
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
    % Replacing food element with empty space
    replace(IntermidiateRow, ColumnFood, e, FoodRow),
    replace(IntermidiateGameState, RowFood, FoodRow, FoodGameState),
    write('Replace: '), write(IntermidiateRow), write(' with '), write(FoodRow), nl,
    write('Game State: '), nl,
    write(FoodGameState),
    % Putting end element in end place
    replace(FoodRow, Column, ElemStart, FinalRow),
    replace(FoodGameState, Row, FinalRow, NewGameState),
    write('Replace: '), write(IntermidiateRow), write(' with '), write(FinalRow), nl,
    write('Game State: '), nl,
    write(NewGameState).


% Falta incrementar a pontuação
change_board(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    write('Start piece: '), write(ElemStart), nl,
    % Value of food piece 
    nth1(RowFood,GameState,ResultRowFood),
    nth1(ColumnFood, ResultRowFood,ElemFood),
    write('Food piece: '), write(ElemFood), nl,
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
    % Putting space in food element
    replace(ResultRowFood, ColumnFood, e, FinalRowFood),
    replace(IntermidiateGameState, RowFood, FinalRowFood, FoodGameState),
    write('Replace: '), write(ResultRowFood), write(' with '), write(FinalRowFood), nl,
    write('Game State: '), nl,
    write(FoodGameState), nl, nl,
    % Putting end element in end place
    replace(ResultRowEnd, Column, ElemStart, FinalRowEnd),
    replace(FoodGameState, Row, FinalRowEnd, NewGameState),
    write('Replace: '), write(ResultRowEnd), write(' with '), write(FinalRowEnd), nl,
    write('Game State: '), nl,
    write(NewGameState).

%Pontuation ORCS:
change_pontuation([PO,PG,PZ]-o-Elem,[PO1,PG1,PZ1]):-
    Elem \== e, 
    Elem \== o, 
    PO1 is PO+1,
    PG1 is PG,
    PZ1 is PZ.


%Pontuation GOBLINS:
change_pontuation([PO,PG,PZ]-g-Elem,[PO1,PG1,PZ1]):-
    Elem \== e, 
    Elem \== g, 
    PO1 is PO,
    PG1 is PG+1,
    PZ1 is PZ.

%Pontuation ZOMBIES:
change_pontuation([PO,PG,PZ]-z-Elem,[PO1,PG1,PZ1]):-
    Elem \== e, 
    Elem \== z, 
    PO1 is PO,
    PG1 is PG,
    PZ1 is PZ+1.

%if ELem=e, then pontuation stays the same
change_pontuation([PO,PG,PZ]-Player-Elem,[PO1,PG1,PZ1]):-
    PO1 is PO,
    PG1 is PG,
    PZ1 is PZ. 