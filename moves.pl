:-include('utils.pl').
:-include('scores.pl').


% Player makes a move
move(GameState-[PO,PG,PZ]-Player-GreenSkull,RowPiece-ColumnPiece-Row-Column-MoveType, NewGameState-[PO1,PG1,PZ1]-ListEat-NewGreenSkull):- 
    valid_moves(GameState, Player-RowPiece-ColumnPiece, LAM-LEM),
    is_valid_move(GameState, LAM-LEM, [Row, Column], MoveType),
    change_green_skull(MoveType, Player, GreenSkull, NewGreenSkull),
    change_board(GameState, RowPiece-ColumnPiece, Row-Column, NewGameState, ElemEaten),
    change_score([PO,PG,PZ]-Player-ElemEaten,[PO1,PG1,PZ1]),
    get_move_eat(Row, Column, ListEat, NewGameState).

    

% Choose piece you want to move and sees if is valid-------------------------------------
choose_piece(GameState,Player,Row,Column):-
    repeat,
    input_play('  Which piece:',Row,Column),
    valid_piece(GameState,Player,Row,Column),!.


% Sees if the piece chosen is valid
valid_piece(GameState,o,Row,Column) :- 
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==o.

valid_piece(GameState,g,Row,Column) :- 
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==g.

valid_piece(GameState,z,Row,Column):-
    nth1(Row,GameState,L),
    nth1(Column,L,Elem),
    Elem==z.

% --------------------------------------------------------------------------------

play_again(GameState-[PO,PG,PZ], [], _, FinalGameState-[POF,PGF,PZ]) :-
    FinalGameState = GameState,
    [POF,PGF,PZ] = [PO,PG,PZ].

play_again(GameState-[PO,PG,PZ], ListEat, Player-[Row, Column]-e, FinalGameState-[POF,PGF,PZ]) :-
    input_message('Play again? [y/n]', Response),
    checks_play_again(GameState-[PO,PG,PZ], ListEat, Player-[Row, Column]-e, FinalGameState-[POF,PGF,PZ], Response).

play_again(GameState-[PO,PG,PZ], _, _, FinalGameState-[POF,PGF,PZ]) :-
    FinalGameState = GameState,
    [POF,PGF,PZ] = [PO,PG,PZ].



checks_play_again(GameState-[PO,PG,PZ], ListEat, Player-[Row, Column]-e, FinalGameState-[POF,PGF,PZ], y) :-
    input_play('Where to go:',RowInput,ColumnInput),
    is_member([RowInput, ColumnInput], ListEat),
    !, 
    write('Valid!'), nl,
    change_board(GameState, Row-Column, RowInput-ColumnInput, NewGameState, ElemEaten),
    change_score([PO,PG,PZ]-Player-ElemEaten,[PO1,PG1,PZ1]),
    get_move_eat(RowInput, ColumnInput, NewListEat, NewGameState),
    play_again(NewGameState-[PO1,PG1,PZ1], NewListEat, Player-[RowInput, ColumnInput]-e, FinalGameState-[POF,PGF,PZ]).


checks_play_again(GameState-[PO,PG,PZ], _, _, FinalGameState-[POF,PGF,PZ], n) :-
    FinalGameState = GameState,
    [POF,PGF,PZ] = [PO,PG,PZ].

%----------------------------------------------------------------------------------------

% For a piece [Row/Column], get its valid moves
valid_moves(GameState, _-Row-Column, ListAdjacentMoves-ListEatMoves) :-
    get_adjacent_move(Row, Column, ListAdjacentMoves, GameState),
    get_move_eat(Row, Column, ListEatMoves, GameState).


% ----------------------------------------------------------------------------------

change_green_skull(e, Player, GreenSkull, NewGreenSkull) :-
    Player == GreenSkull,
    green_skull(GreenSkull, NewGreenSkull).

change_green_skull(e, _, GreenSkull, NewGreenSkull) :-
    NewGreenSkull = GreenSkull.

change_green_skull(a, Player, GreenSkull, NewGreenSkull) :-
    NewGreenSkull = GreenSkull.

% --------------------------------------------------------------------------------------

%choose where you want to move the piece and sees if is valid----------------------------
move_human_piece(GameState-[PO,PG,PZ]-Player-GreenSkull,RowPiece-ColumnPiece,FinalGameState-[POF,PGF,PZF]-NewGreenSkull):-
    repeat,
    input_play('  Where to:',Row,Column),
    move(GameState-[PO,PG,PZ]-Player-GreenSkull, RowPiece-ColumnPiece-Row-Column-MoveType, NewGameState-[PO1,PG1,PZ1]-ListEat-NewGreenSkull),
    play_again(NewGameState-[PO1,PG1,PZ1], ListEat, Player-[Row, Column]-MoveType, FinalGameState-[POF,PGF,PZF]).



is_valid_move(_, LAM-_, Position, a) :-
    is_member(Position, LAM).

% Only this one changes ElemEaten
is_valid_move(_, _-LEM, Position, e) :-
    is_member(Position, LEM).

% ==================================================================



% --------------------------------------------------------------------------------------

change_board(GameState, RowPiece-ColumnPiece, Row-Column, NewGameState, e) :-
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column),
    R=<1,
    C=<1,
    change_board_aux(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState).

change_board(GameState, RowPiece-ColumnPiece, Row-Column, NewGameState, ElemEaten) :-
    RowTest is (Row-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (Column-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, 
    ColumnFood is ColumnPiece + C,
    change_board_aux(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState, ElemEaten).


% --------------------------------------------------------------------------------------


%----------------------------------------------------------------------------------------

% Changes the board by simulating the movement of a piece
% The piece starts at position [RowPiece, ColumnPiece] and goes to [Row, Column]
% The final board is placed in variable NewGameState

% Works for movement in the same row
change_board_aux(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState) :-
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
change_board_aux(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState) :-
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
change_board_aux(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState, ElemFood) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    % Value of food piece 
    nth1(RowFood,GameState,ResultRowFood),
    nth1(ColumnFood, ResultRowFood,ElemFood),
    % Value of place piece is jumping to - end
    nth1(Row,GameState,ResultRowEnd),
    nth1(Column, ResultRowEnd,ElemEnd),
    % Switching places
    % Putting end element in starting place
    ResultRowStart == ResultRowEnd, !,
    replace(ResultRowStart, ColumnPiece, ElemEnd, IntermidiateRow),
    replace(GameState, RowPiece, IntermidiateRow, IntermidiateGameState),
    % Replacing food element with empty space
    replace(IntermidiateRow, ColumnFood, e, FoodRow),
    replace(IntermidiateGameState, RowFood, FoodRow, FoodGameState),
    % Putting end element in end place
    replace(FoodRow, Column, ElemStart, FinalRow),
    replace(FoodGameState, Row, FinalRow, NewGameState).


% Falta incrementar a pontuação
change_board_aux(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState, ElemFood) :-
    % Value of place piece is jumping from - start
    nth1(RowPiece,GameState,ResultRowStart),
    nth1(ColumnPiece,ResultRowStart,ElemStart),
    % Value of food piece 
    nth1(RowFood,GameState,ResultRowFood),
    nth1(ColumnFood, ResultRowFood,ElemFood),
    % Value of place piece is jumping to - end
    nth1(Row,GameState,ResultRowEnd),
    nth1(Column, ResultRowEnd,ElemEnd),
    % Switching places
    % Putting end element in starting place
    replace(ResultRowStart, ColumnPiece, ElemEnd, FinalRowStart),
    replace(GameState, RowPiece, FinalRowStart, IntermidiateGameState),
    % Putting space in food element
    replace(ResultRowFood, ColumnFood, e, FinalRowFood),
    replace(IntermidiateGameState, RowFood, FinalRowFood, FoodGameState),
    % Putting end element in end place
    replace(ResultRowEnd, Column, ElemStart, FinalRowEnd),
    replace(FoodGameState, Row, FinalRowEnd, NewGameState).



% ---------------------------------------------------------------------------------------------------



% Gets a list of places a player can jump to after jumping once
% RowPiece - row of piece playing
% ColumnPiece - column of piece playing
% AllPlaysList - list of all plays a player can make, if empty the next player takes the turn
% GameState - Current game state
get_move_eat(RowPiece, ColumnPiece, L6, GameState) :-
    get_move_left(RowPiece, ColumnPiece, [], L1, GameState),
    get_move_right(RowPiece, ColumnPiece, L1, L2, GameState),
    get_move_upper_right(RowPiece, ColumnPiece, L2, L3, GameState),
    get_move_lower_left(RowPiece, ColumnPiece, L3, L4, GameState),
    get_move_upper_left(RowPiece, ColumnPiece, L4, L5, GameState),
    get_move_lower_right(RowPiece, ColumnPiece, L5, L6, GameState), !.


% Choose move eat
% Horizontal
get_move_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece - 2,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece + 2,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Same column
get_move_upper_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece - 2,
    ColumnEnd = ColumnPiece,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece + 2,
    ColumnEnd = ColumnPiece,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_lower_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Other 2 hypothesis
get_move_upper_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece - 2,
    ColumnEnd is ColumnPiece - 2,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece + 2,
    ColumnEnd is ColumnPiece + 2,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_lower_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.
    

% Gets list of moves a player can make when he want to eat a piece
get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState):-
    RowEnd > 0,
    RowEnd =< 10,
    ColumnEnd > 0,
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
    append(PlaysList, [[RowEnd, ColumnEnd]], NewPlaysList).


get_individual_move(_, _, _, _, PlaysList, NewerPlaysList, _) :- 
    NewerPlaysList = PlaysList.




% -----------------------------------------------------------------

get_adjacent_move(RowPiece, ColumnPiece, ListOfMoves, GameState) :-
    get_adjacent_move_left(RowPiece, ColumnPiece, [], L1, GameState),
    get_adjacent_move_right(RowPiece, ColumnPiece, L1, L2, GameState),
    get_adjacent_move_upper_right(RowPiece, ColumnPiece, L2, L3, GameState),
    get_adjacent_move_lower_left(RowPiece, ColumnPiece, L3, L4, GameState),
    get_adjacent_move_upper_left(RowPiece, ColumnPiece, L4, L5, GameState),
    get_adjacent_move_lower_right(RowPiece, ColumnPiece, L5, ListOfMoves, GameState).


% Choose move eat
% Horizontal
get_adjacent_move_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece - 1,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_adjacent_move_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece + 1,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Same column
get_adjacent_move_upper_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece - 1,
    ColumnEnd = ColumnPiece,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_upper_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_adjacent_move_lower_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece + 1,
    ColumnEnd = ColumnPiece,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_lower_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Other 2 hypothesis
get_adjacent_move_upper_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece - 1,
    ColumnEnd is ColumnPiece - 1,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_upper_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_adjacent_move_lower_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    RowEnd is RowPiece + 1,
    ColumnEnd is ColumnPiece + 1,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_lower_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.


get_individual_move_2(_, _, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState):-
    RowEnd > 0,
    RowEnd =< 10,
    ColumnEnd > 0,
    ColumnEnd =< RowEnd,
    % Checks end cell to see if it's empty
    nth1(RowEnd, GameState, RowEndResult),
    nth1(ColumnEnd, RowEndResult, ElemEnd),
    ElemEnd == e,
    % Appends it to the list of plays - PlaysList
    append(PlaysList, [[RowEnd, ColumnEnd]], NewPlaysList).

