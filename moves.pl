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
    change_board(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState),

    nl,nl,print_board(NewGameState,0), nl,

    get_move_eat(Row, Column, AllPlaysList, NewGameState),

    input_play.


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
    % Putting start element in end place
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
    % Putting start element in end place
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
    write(NewGameState), nl.


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
    write(NewGameState), nl.

% ---------------------------------------------------------------------------------------------------

% Gets a list of places a player can jump to after jumping once
% RowPiece - row of piece playing
% ColumnPiece - column of piece playing
% AllPlaysList - list of all plays a player can make, if empty the next player takes the turn
% GameState - Current game state
get_move_eat(RowPiece, ColumnPiece, AllPlaysList, GameState) :-
    get_move_left(RowPiece, ColumnPiece, L0, L1, GameState),
    get_move_right(RowPiece, ColumnPiece, L1, L2, GameState),
    get_move_upper_right(RowPiece, ColumnPiece, L2, L3, GameState),
    get_move_lower_left(RowPiece, ColumnPiece, L3, L4, GameState),
    get_move_upper_left(RowPiece, ColumnPiece, L4, L5, GameState),
    get_move_lower_right(RowPiece, ColumnPiece, L5, AllPlaysList, GameState),
    write('Full plays list: '), write(L6), nl.




% Choose move eat
% Horizontal
get_move_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece - 2,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece + 2,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Same column
get_move_upper_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece - 2,
    ColumnEnd = ColumnPiece,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece + 2,
    ColumnEnd = ColumnPiece,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_lower_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Other 2 hypothesis
get_move_upper_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece - 2,
    ColumnEnd is ColumnPiece + 2,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece + 2,
    ColumnEnd is ColumnPiece - 2,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_lower_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.
    


% Gets list of moves a player can make when he want to eat a piece
get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState):-
    RowEnd =< 10,
    ColumnEnd =< RowEnd,
    % Checks end cell to see if it's empty
    nth1(RowEnd, GameState, RowEndResult),
    nth1(ColumnEnd, RowEndResult, ElemEnd),
    ElemEnd == e,
    % Calculates the position of food element
    RowTest is (RowEnd-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (ColumnEnd-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, ColumnFood is ColumnPiece + C,
    % Gets food element
    nth1(RowFood, GameState, RowFoodResult),
    nth1(ColumnFood, RowFoodResult, Elem),
    Elem \== e,
    % Appends it to the list of plays - PlaysList
    append(PlaysList, [[RowEnd, ColumnEnd]], NewPlaysList),
    write('List of plays: '), write(NewPlaysList), nl.