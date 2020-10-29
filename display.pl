:-include('data.pl').

% z -> Zombies -> verdes
% g -> Globin -> roxos
% o -> Orc -> brancos
% 0 -> Empty space


initial(GameState):- initialBoard(GameState).

display_game(GameState,Player):-nl,nl,print_board(GameState,0),nl,display_columns.

%display players turn
round(Player):- 
    Player='orc',
    nl, write('                 TURN TO PLAY, ORC!'),nl,nl.
round(Player):- 
    Player='globin', 
    nl, write('                 TURN TO PLAY, Globin!'),nl,nl.
round(Player):-
    Player='zombies',
    nl, write('                 TURN TO PLAY, Zombies!'),nl,nl.

%prints the full board
print_board([],N).
print_board([H|T],N) :-
    space(N,S),write(S),
    write('|'), print_row(H),
    N1 is N+1,
    nl,nl,
    print_board(T,N1).
    
%prints a single row
print_row([]).
print_row([H|T]):-
    code(H,P),   
    write(P),
    write('|'),
    print_row(T).

%prints column numbers
display_columns:-
    write('        1   2   3   4   5   6   7   8   9   10').
    
 %display game over message
 display_game_over:- write('                 GAME OVER').
