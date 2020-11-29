:-include('utils.pl').



% Player makes a move
move(GameState,Player,FinalGameState):- 
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    valid_moves(GameState, Player-RowPiece-ColumnPiece, LAM-LEM),
    % TO DO - Return list ElemEaten to update the score
    choose_move(GameState, LAM-LEM, [Row, Column], ElemEaten),
    change_board(GameState, RowPiece-ColumnPiece, Row-Column, NewGameState),
    get_move_eat(Row, Column, ListEat, NewGameState),
    play_again(NewGameState, ListEat, Player-[Row, Column], FinalGameState).

    

% Choose piece you want to move and sees if is valid-------------------------------------
choose_piece(GameState,Player,Row,Column):-
    repeat,
    input_play('Which piece:',Row,Column),
    validPiece(GameState,Player,Row,Column),
    !, 
    write('valid'),nl.


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

% --------------------------------------------------------------------------------

play_again(GameState, [], Player-[Row, Column], FinalGameState) :-
    FinalGameState = GameState.

play_again(GameState, ListEat, Player-[Row, Column], FinalGameState) :-
    input_message('Play again? [y/n]', Response),
    checks_play_again(GameState, ListEat, Player-[Row, Column], FinalGameState, Response).



checks_play_again(GameState, ListEat, Player-[Row, Column], FinalGameState, y) :-
    input_play('Where to:',RowInput,ColumnInput),
    is_member([RowInput, ColumnInput], ListEat),
    !, 
    write('valid'), nl,
    write(Row), nl, write(Column), nl,
    change_board(GameState, Row-Column, RowInput-ColumnInput, NewGameState),
    get_move_eat(RowInput, ColumnInput, NewListEat, NewGameState),
    play_again(NewGameState, NewListEat, Player-[RowInput, ColumnInput], FinalGameState).


checks_play_again(GameState, ListEat, Player-[Row, Column], FinalGameState, n) :-
    FinalGameState = GameState.

%----------------------------------------------------------------------------------------

% For a piece [Row/Column], get its valid moves
valid_moves(GameState, Player-Row-Column, ListAdjacentMoves-ListEatMoves) :-
    get_adjacent_move(Row, Column, ListAdjacentMoves, GameState),
    write('Adjacent: '), write(ListAdjacentMoves), nl,

    get_move_eat(Row, Column, ListEatMoves, GameState),
    write('Eats: '), write(ListEatMoves), nl.


% ----------------------------------------------------------------------------------




%choose where you want to move the piece and sees if is valid----------------------------
choose_move(GameState, LAM-LEM, [Row, Column], ElemEaten) :-
    repeat,
    input_play('Where to:',Row,Column),
    is_valid_move(GameState, LAM-LEM, [Row, Column], ElemEaten), !.
    % valid_move(Player,RowPiece,ColumnPiece,Row, Column, GameState, NewGameState).
    % change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState).


is_valid_move(GameState, LAM-LEM, Position, ElemEaten) :-
    write(Position), nl,
    is_member(Position, LAM), 
    write('IS MEMBER OF ADJACENT MOVES LIST'), nl.

% Only this one changes ElemEaten
is_valid_move(GameState, LAM-LEM, Position, ElemEaten) :-
    nl, 
    write('is_valid_move:'), nl,
    write(Position), nl,
    write(LEM), nl,
    is_member(Position, LEM),
    write('IS MEMBER OF EAT MOVES LIST'), nl, nl.

% ==================================================================


% --------------------------------------------------------------------------------------

change_board(GameState, RowPiece-ColumnPiece, Row-Column, NewGameState) :-
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column),
    R=<1,
    C=<1,
    change_board_aux(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState).

change_board(GameState, RowPiece-ColumnPiece, Row-Column, NewGameState) :-
    RowTest is (Row-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (Column-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, 
    ColumnFood is ColumnPiece + C,
    change_board_aux(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState).

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
change_board_aux(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState) :-
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
    write('Replace: '), write(IntermidiateRow), write(' with '), write(FoodRow), nl,
    write('Game State: '), nl,
    write(FoodGameState), nl,
    % Putting end element in end place
    replace(FoodRow, Column, ElemStart, FinalRow),
    replace(FoodGameState, Row, FinalRow, NewGameState),
    write('Replace: '), write(IntermidiateRow), write(' with '), write(FinalRow), nl,
    write('Game State: '), nl,
    write(NewGameState), nl.


% Falta incrementar a pontuação
change_board_aux(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState) :-
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
get_move_eat(RowPiece, ColumnPiece, L6, GameState) :-
    nl, write('get_move_eat beginning list: '), write([]), nl,
    get_move_left(RowPiece, ColumnPiece, [], L1, GameState),
    write('Left: '), write(L0), nl, write(L1), nl, 
    get_move_right(RowPiece, ColumnPiece, L1, L2, GameState),
    write('Right: '), write(L1), nl, write(L2), nl, 
    get_move_upper_right(RowPiece, ColumnPiece, L2, L3, GameState),
    write('Upper Right: '), write(L2), nl, write(L3), nl, 
    get_move_lower_left(RowPiece, ColumnPiece, L3, L4, GameState),
    write('Lower left: '), write(L3), nl, write(L4), nl, 
    get_move_upper_left(RowPiece, ColumnPiece, L4, L5, GameState),
    write('Upper Left: '), write(L4), nl, write(L5), nl, 
    get_move_lower_right(RowPiece, ColumnPiece, L5, L6, GameState),
    write('Lower right: '), write(L5), nl, write(L6), nl, 
    % FinalList2 =  
    %append([], L6, FinalList),
    write('get_move_eat final list: '), write(L6), nl, !.


% Choose move eat
% Horizontal
get_move_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
   %  write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece - 2,
    % write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    % write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece + 2,
    % write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Same column
get_move_upper_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    % write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece - 2,
    ColumnEnd = ColumnPiece,
    % write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    % write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece + 2,
    ColumnEnd = ColumnPiece,
    %write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_lower_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Other 2 hypothesis
get_move_upper_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    % write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece - 2,
    ColumnEnd is ColumnPiece - 2,
    % write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
   %  write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece + 2,
    ColumnEnd is ColumnPiece + 2,
    % write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_lower_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.
    

% Gets list of moves a player can make when he want to eat a piece
get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState):-
    trace,
    RowEnd > 0,
    RowEnd =< 10,
    ColumnEnd > 0,
    ColumnEnd =< RowEnd,
    write('Start - End: '), write('['), write(RowPiece), write('/'), write(ColumnPiece), write(']'),   write(' - '), write('['),  write(RowEnd), write('/'), write(ColumnEnd), write(']'),  nl,
    % Checks end cell to see if it's empty
    % trace,
    nth1(RowEnd, GameState, RowEndResult),
    nth1(ColumnEnd, RowEndResult, ElemEnd),
    ElemEnd == e,
    % notrace,
    % Calculates the position of food element
    RowTest is (RowEnd-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (ColumnEnd-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, ColumnFood is ColumnPiece + C,
    % trace,
    % Gets food element
    nth1(RowFood, GameState, RowFoodResult),
    nth1(ColumnFood, RowFoodResult, Elem),
    Elem \== e,
    % Appends it to the list of plays - PlaysList
    append(PlaysList, [[RowEnd, ColumnEnd]], NewPlaysList).


get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewerPlaysList, GameState) :- 
    write('Error in first get_individual_move'), nl,
    write('Updating list: '), write(NewerPlaysList), nl, write('with: '), write(PlaysList), nl,
    NewerPlaysList = PlaysList,
    write(NewerPlaysList), nl.








% -----------------------------------------------------------------

get_adjacent_move(RowPiece, ColumnPiece, ListOfMoves, GameState) :-
    get_adjacent_move_left(RowPiece, ColumnPiece, L0, L1, GameState),
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


get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState):-
    RowEnd > 0,
    RowEnd =< 10,
    ColumnEnd > 0,
    ColumnEnd =< RowEnd,
    % Checks end cell to see if it's empty
    nth1(RowEnd, GameState, RowEndResult),
    nth1(ColumnEnd, RowEndResult, ElemEnd),
    ElemEnd == e,
    % Appends it to the list of plays - PlaysList
    write(PlaysList), nl,
    append(PlaysList, [[RowEnd, ColumnEnd]], NewPlaysList),
    write('List of plays: '), write(NewPlaysList), nl.













% ===============================================================

/*

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
    check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState, Player).

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
check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewGameState, Player):-
    R is abs(RowPiece-Row),
    C is abs(ColumnPiece-Column),
    R=<1, C=<1,
    check_adjacent_movement(RowPiece, ColumnPiece, Row, Column),
    change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState),
    set_next_player(Player, NextPlayer),
    move(GameState,NewPlayer,NewGameState).

% If player wants to eat something
% Checks if what's between current position and destination is something edible (not white space)
check_surroundings(RowPiece, ColumnPiece, Row, Column, GameState, NewerGameState, Player):-
    RowTest is (Row-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (Column-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, ColumnFood is ColumnPiece + C,
    nth1(RowFood, GameState, L),
    nth1(ColumnFood, L, Elem),
    Elem \== e, !,
    % chama change board diferente que substitui a peça do meio (a "comida") por um white space tambem
    change_board(RowPiece, ColumnPiece, Row, Column, RowFood, ColumnFood, GameState, NewGameState),
    get_move_eat(Row, Column, AllPlaysList, NewGameState),
    eats_again(Row, Column, RowInput, ColumnInput, AllPlaysList, NewGameState, NewerGameState).


eats_again(RowPiece, ColumnPiece, Row, Column, AllPlaysList, GameState, NewGameState) :-
    length(AllPlaysList, Length),
    Length == 0,
    write('eats_again 0 length - Game State: '), write(GameState), nl, 
    write('eats_again 0 length - New Game State: '), write(NewGameState), nl,
    NewGameState = GameState.

eats_again(RowPiece, ColumnPiece, RowInput, ColumnInput, AllPlaysList, GameState, NewGameState) :-
    write('LISTA DE JOGADAS POSSIVEIS'), write(AllPlaysList), nl,
    \+ is_empty(AllPlaysList),
    repeat,
    % gets play, checks play, changes board

    display_board(GameState),
    
    input_play('You can jump again, if you want to finish your play here insert 0, 0.', RowInput, ColumnInput),
    write('Start: ['), write(RowPiece), write('/'), write(ColumnPiece), write(']'), nl,
    write('End: ['), write(RowInput), write('/'), write(ColumnInput), write(']'), nl,
    write('GAME STATE: '), write(GameState), nl,
    write('NEW GAME STATE: '), write(NewGameState), nl,
    validate_play(RowPiece, ColumnPiece, [RowInput, ColumnInput], AllPlaysList, GameState, NewGameState),

    write('BOARD AFTER PLAYING GOING TO '), write([RowInput, ColumnInput]), nl,nl,
    display_board(NewGameState), nl, nl,
    get_move_eat(RowInput, ColumnInput, AnotherPlaysList, NewGameState),
    eats_again(RowInput, ColumnInput, RowNew, ColumnNew, AnotherPlaysList, NewGameState, NewerGameState)
    .


validate_play(_, _, [0, 0] , _, GameState, NewGameState) :- 
    !,
    write('Player stops here.'), nl, NewGameState = GameState.

validate_play(RowPiece, ColumnPiece, [RowInput, ColumnInput], AllPlaysList, GameState, NewGameState) :-
    write('All plays list: '), write(AllPlaysList), nl,
    write('Member: '), write([RowInput, ColumnInput]), nl,
    member([RowInput, ColumnInput], AllPlaysList),
    !,
    RowTest is (RowInput-RowPiece)/2, is_int(RowTest), R is ceiling(RowTest),
    ColumnTest is (ColumnInput-ColumnPiece)/2, is_int(ColumnTest), C is round(ColumnTest), 
    RowFood is RowPiece + R, ColumnFood is ColumnPiece + C,
    change_board(RowPiece, ColumnPiece, RowInput, ColumnInput, RowFood, ColumnFood, GameState, NewGameState).




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
    write(FoodGameState), nl,
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
get_move_eat(RowPiece, ColumnPiece, L6, GameState) :-
    write('get_move_eat list: '), write(L6), nl,
    get_move_left(RowPiece, ColumnPiece, L0, L1, GameState),
    get_move_right(RowPiece, ColumnPiece, L1, L2, GameState),
    get_move_upper_right(RowPiece, ColumnPiece, L2, L3, GameState),
    get_move_lower_left(RowPiece, ColumnPiece, L3, L4, GameState),
    get_move_upper_left(RowPiece, ColumnPiece, L4, L5, GameState),
    get_move_lower_right(RowPiece, ColumnPiece, L5, L6, GameState),
    % trace,
    write('Full plays list: '), write(L6), nl.


% Choose move eat
% Horizontal
get_move_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece - 2,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece + 2,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Same column
get_move_upper_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece - 2,
    ColumnEnd = ColumnPiece,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece + 2,
    ColumnEnd = ColumnPiece,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_lower_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Other 2 hypothesis
get_move_upper_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece - 2,
    ColumnEnd is ColumnPiece - 2,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_move_upper_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece + 2,
    ColumnEnd is ColumnPiece + 2,
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


% -----------------------------------------------------------------

get_adjacent_move(RowPiece, ColumnPiece, ListOfMoves, GameState) :-
    write('get_adjacent_move list: '), write(ListOfMoves), nl,
    get_adjacent_move_left(RowPiece, ColumnPiece, L0, L1, GameState),
    get_adjacent_move_right(RowPiece, ColumnPiece, L1, L2, GameState),
    get_adjacent_move_upper_right(RowPiece, ColumnPiece, L2, L3, GameState),
    get_adjacent_move_lower_left(RowPiece, ColumnPiece, L3, L4, GameState),
    get_adjacent_move_upper_left(RowPiece, ColumnPiece, L4, L5, GameState),
    get_adjacent_move_lower_right(RowPiece, ColumnPiece, L5, ListOfMoves, GameState),
    % trace,
    write('Full plays list: '), write(ListOfMoves), nl.


% Choose move eat
% Horizontal
get_adjacent_move_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece - 1,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_adjacent_move_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd = RowPiece,
    ColumnEnd is ColumnPiece + 1,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Same column
get_adjacent_move_upper_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece - 1,
    ColumnEnd = ColumnPiece,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_upper_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_move_lower_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece + 1,
    ColumnEnd = ColumnPiece,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_lower_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

% Other 2 hypothesis
get_adjacent_move_upper_left(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece - 1,
    ColumnEnd is ColumnPiece - 1,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_upper_left(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.

get_adjacent_move_lower_right(RowPiece, ColumnPiece, PlaysList, NewPlaysList, GameState) :-
    write('Start: '), write(RowPiece), write('/'), write(ColumnPiece), nl,
    RowEnd is RowPiece + 1,
    ColumnEnd is ColumnPiece + 1,
    write('Destiny: '), write(RowEnd), write('/'), write(ColumnEnd), nl,
    get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState).
get_adjacent_move_lower_right(_, _, PlaysList, NewPlaysList, _) :- NewPlaysList = PlaysList.


get_individual_move_2(RowPiece, ColumnPiece, RowEnd, ColumnEnd, PlaysList, NewPlaysList, GameState):-
    RowEnd =< 10,
    ColumnEnd =< RowEnd,
    % Checks end cell to see if it's empty
    nth1(RowEnd, GameState, RowEndResult),
    nth1(ColumnEnd, RowEndResult, ElemEnd),
    ElemEnd == e,
    % Appends it to the list of plays - PlaysList
    append(PlaysList, [[RowEnd, ColumnEnd]], NewPlaysList),
    write('List of plays: '), write(NewPlaysList), nl.

    */