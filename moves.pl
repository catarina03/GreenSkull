%player makes a move
move(GameState,Player,NewGameState):- 
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    choose_move(GameState,RowPiece,ColumnPiece,NewGameState).

% Reads input from user
input_play(Message,Row,Column) :-
    write(Message),nl,
    write('Row: '), read(Row),
    write('Column: '), read(Column),nl.

%choose piece you want to move and sees if is valid
choose_piece(GameState,Player,Row,Column):-
    input_play('Which piece:',Row,Column),
    validPiece(GameState,Player,Row,Column),!.

choose_piece(GameState,Player,Row,Column):-
    input_play('Which piece:',Row,Column),
    \+ validPiece(GameState,Player,Row,Column),!,
    write('Not a valid piece!'),
    choose_piece(GameSatate,Player,Row,Column).

%sees if the piece chosen if valid
validPiece(GameState,Player,Row,Column):-Player=o,!.
    %nth(Row,GameState,L),
    %nth(Column,L,Elem),
    %Elem='o'.

validPiece(GameState,Player,Row,Column):-Player=g,!.
    %nth(Row,GameSatate,L),
    %nth(Column,L,Elem),
    %Elem='g'.

validPiece(GameState,Player,Row,Column):-Player=z,!.
    %nth(Row,GameState,L),
    %nth(Column,L,Elem),
    %Elem='z'.


%choose where you want to move the piece and sees if is valid
choose_move(GameState,RowPiece,ColumnPiece,NewGameState):-input_play('Where to:',Row,Column).

