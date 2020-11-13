:-include('data.pl').

% z -> Zombies -> verdes
% g -> Globin -> roxos
% o -> Orc -> brancos
% 0 -> Empty space


% Display current state of the game
% GameState - current state of the board
% Player - who plays this turn
% GreenSkull - who has the Green Skull
display_game(GameState-GreenSkull, Player) :-
    nl,nl,print_board(GameState,0),
    hex_code(10,C),write(C),nl,nl,
    write('                          z o m b i e s'),nl,nl,
    display_column_numbers,
    display_green_skull(GreenSkull), 
    display_player_turn(Player),
    nl, nl.

% Display who plays this round
display_player_turn(o):- 
    nl, write('                 TURN TO PLAY, ORCS!').
display_player_turn(g):-  
    nl, write('                TURN TO PLAY, GOBLINS!').
display_player_turn(z):-
    nl, write('                TURN TO PLAY, ZOMBIES!').

% Display who has the Green Skull
display_green_skull(o) :-
    nl, write('              ORCS HAVE THE GREEN SKULL!').
display_green_skull(g) :-
    nl, write('             GOBLINS HAVE THE GREEN SKULL!').

% Prints the full board
print_board([],N).
print_board([H|T],N) :- 
    hex_code(N,C),write(C),nl,
    space(N,S),write(S),
    write('|'), print_row(H),
    N1 is N+1,
    nl,
    print_board(T,N1).

% Prints a single row
print_row([]).
print_row([H|T]):-
    code(H,P),   
    write(P),
    write('|'),
    print_row(T).

% Prints column numbers
display_column_numbers:-
    write('            1   2   3   4   5   6   7   8   9   10'),
    nl.
    
% Displays game over message
display_game_over :- 
    nl, 
    write('                       GAME OVER').
