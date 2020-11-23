:-use_module(library(lists)).

initial_board([       
             [e],         
            [e,e],         
           [z,e,z],        
          [z,e,e,z],         
         [e,e,z,e,e],         
        [e,e,z,z,e,e],             
       [g,e,e,z,e,e,o],       
      [g,g,e,e,e,e,o,o],        
     [g,g,g,e,e,e,o,o,o],   
    [g,g,g,g,e,e,o,o,o,o] ]).



%initial list

testing_list :-
    initial_list(X),
    test(X, 3, 'ola', Y).

initial_list([g,g,g,g,e,e,o,o,o,o]).
test(X, Index, Value,Y) :-
    replace(X, Index, Value, Y),
    write(Y).


testing_board :-
    initial_board(GameState),
    % [7, 1] (g) -> [10, 10] (o)
    change_board(7, 1, 10, 10, GameState,NewGameState).


%replace(List,Index,Value,NewList)
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):-
        I > -1, 
        NI is I-1,
        replace(T, NI, X, R), !.
replace(L, _, _, L).


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



change_board(RowPiece,ColumnPiece, Row, Column, GameState,NewGameState) :-
    Row==RowPiece,
    %faz append à NewGameState da lista 0 até lista Row.
    sub_append(1,Row,GameState,NewGameState),
    write('aqui'),
    %muda os valores da lista
    nth1(Row,GameState,L),
    nth1(ColumnPiece,L,Elem),
    replace(L,Column,Elem,L1),
    replace(L1,ColumnPiece,e,L2),
    append(NewGameState,L2).

    sub_append(Row+1,11,GameState,NewGameState).


change_board(RowPiece,ColumnPiece,Row,Column,GameState,NewGameState):-
    Row<RowPiece,
    
    % descobre qual o valor da peça a mover
    nth1(RowPiece,GameState,L),
    nth1(ColumnPiece,L,Elem),
    

    %faz append à NewGameState da lista 0 até lista Row.
    sub_append(1,Row,GameState,NewGameState),

    %muda em (Row,Column) o valor que lá estava pela peça que vai ser trocada
    nth1(Row,GameState,L1), 
    replace(L1,Column,Elem,L2),
    append(NewGameState,L2).

    sub_append(Row+1,RowPiece,GameState,NewGameState),

    replace(L,ColumnPiece,e,L3),
    append(NewGameState,L3).
        
    sub_append(RowPiece+1,11,GameState,NewGameState).



change_board(RowPiece,ColumnPiece,Row,Column,GameState,NewGameState):-
    RowPiece<Row,
    
    % descobre qual o valor da peça a mover
    nth1(RowPiece,GameState,L),
    nth1(ColumnPiece,L,Elem),

    %faz append à NewGameState da lista 0 até lista Row.
    sub_append(1,RowPiece,GameState,NewGameState),
    
    replace(L,ColumnPiece,e,L3),
    append(NewGameState,L3),
   
    sub_append(RowPiece+1,Row,GameState,NewGameState),
    
    %muda em (Row,Column) o valor que lá estava pela peça que vai ser trocada
    nth1(Row,GameState,L1), 
    replace(L1,Column,Elem,L2),
    append(NewGameState,L2).
           
    sub_append(Row+1,11,GameState,NewGameState).


%TO DO----------------------------------------------------------------------

sub_append(Row1,Row2,GameState,NewGameState):- 
    Row1<Row2,
    nth1(Row1,GameState,L),
    write(L),nl,
    append(NewGameState,[L],NewGameState1),
    NewGameState=NewGameState1,
    write(NewGameState),nl,
    Row is (Row1+1),
    write(Row),nl,
    sub_append(Row,Row2,GameState,NewGameState).

sub_append(Row1,Row2,GameState,NewGameState):- Row1==Row2. 

*/


play:-
    write('   |   G R E E N  S K U L L  |'),nl,
    write('---------------------------------'),nl,
    write('   |     1. Instructions     |'),nl,
    write('   |     2. Play             |'),nl,
    write('---------------------------------'),nl,
    write('   |                         |'),nl,
    write('Option: '),read(C),nl,nl,
    option(C).

option(1):-
    write('   | I N S T R U C T I O N S |'),nl,
    write('---------------------------------'),nl,
    write('   |     1. Instructions     |'),nl,
    write('   |     2. Play             |'),nl,
    write('---------------------------------'),nl,
    write('   |                         |'),nl,nl,
    play.

option(2):-
    write('   |         P L A Y         |'),nl,
    write('---------------------------------'),nl,
    write('   |     1. Human VS Human   |'),nl,
    write('   |     2. Human Starts     |'),nl,
    write('   |     3. Pc Starts        |'),nl,
    write('   |     4. Pc VS Pc         |'),nl,
    write('---------------------------------'),nl,
    write('   |                         |'),nl,
    write('Option: '),read(C),
    play_game(C).

play_game(1):-
    write('    H U M A N   VS   H U M A N   '),nl,
    write('---------------------------------'),nl,nl.
    %human_human.

play_game(2):-
    write('       H U M A N   VS   P C      '),nl,
    write('---------------------------------'),nl,nl.
    %human_pc.

play_game(3):-
    write('       P C   VS   H U M A N      '),nl,
    write('---------------------------------'),nl,nl.
    %pc_human.

play_game(3):-
    write('          P C   VS   P C         '),nl,
    write('---------------------------------'),nl,nl.
    %pc_pc.