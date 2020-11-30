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
    write('                          z o m b i e s'),nl,
    display_column_numbers,
    display_green_skull(GreenSkull), 
    display_player_turn(Player),
    nl, nl.


display_board(GameState) :-
    nl,nl,print_board(GameState,0),
    hex_code(10,C),write(C),nl,nl,
    write('                         z o m b i e s'),nl,
    display_column_numbers,
    nl, nl.

% Display who plays this round
display_player_turn(o):- 
    nl, write('                     TURN TO PLAY, ORCS!').
display_player_turn(g):-  
    nl, write('                    TURN TO PLAY, GOBLINS!').
display_player_turn(z):-
    nl, write('                    TURN TO PLAY, ZOMBIES!').

% Display who has the Green Skull
display_green_skull(o) :-
    nl, write('                  ORCS HAVE THE GREEN SKULL!').
display_green_skull(g) :-
    nl, write('                 GOBLINS HAVE THE GREEN SKULL!').

% Prints the full board
print_board([],_).
print_board([H|T],N) :- 
    hex_code(N,C),write(C),nl,
    space(N,S),write(S),
    write('|'), print_row(H), write('     | '),
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
    write('        - - - - - - - - - - - - - - - - - - - - - - - -   '), nl, nl,
    write('       1   2   3   4   5   6   7   8   9   10'),
    nl.
    
% Displays game over message
display_game_over :- 
    nl, 
    write('                        G A M E  O V E R'),nl,nl.

%Display game menus:
display_menu(C):-
    write('                  |   G R E E N  S K U L L  |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |     1. Instructions     |'),nl,
    write('                  |     2. Play             |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,
    write('               Option: '),read(C),nl,nl.

display_instructions:-
    write('                  | I N S T R U C T I O N S |'),nl,
    write('               ---------------------------------'),nl,
    write('                  | Try to get your pieces  |'),nl,
    write('                  | across the field while  |'),nl,
    write('                  | eating as many enimies  |'),nl,
    write('                  | as you can!             |'),nl,
    write('                  |                         |'),nl,
    write('                  | Whoever holds the Green |'),nl,
    write('                  | Skull, is in charge of  |'),nl,
    write('                  | the Zombienation!       |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,nl,nl.

display_play(C):-
    write('                  |         P L A Y         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |     1. Human VS Human   |'),nl,
    write('                  |     2. Human Starts     |'),nl,
    write('                  |     3. Pc Starts        |'),nl,
    write('                  |     4. Pc VS Pc         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,nl,
    write('                Option: '),read(C),nl,nl.

display_play_mode(1):-
    write('                   H U M A N   VS   H U M A N   '),nl,
    write('               ---------------------------------'),nl,nl.

display_play_mode(2):-
    write('                      H U M A N   VS   P C      '),nl,
    write('               ---------------------------------'),nl,nl.

display_play_mode(3):-
    write('                      P C   VS   H U M A N      '),nl,
    write('               ---------------------------------'),nl,nl.

display_play_mode(4):-
    write('                         P C   VS   P C         '),nl,
    write('               ---------------------------------'),nl,nl.
        
display_scores(O-G-Z):-
    nl,nl,
    write('                          S C O R E S       '),nl,
    write('               ---------------------------------'),nl,
    write('                        ORCS: '), write(O),nl,
    write('                        GOBLINS: '), write(G),nl,
    write('                        ZOMBIES: '), write(Z),nl,
    write('               ---------------------------------'),nl,
    nl,nl.

display_final_scores(O-G-Z):-
    write('                     F I N A L  S C O R E S     '),nl,
    write('               ---------------------------------'),nl,
    write('                        ORCS: '), write(O),nl,
    write('                        GOBLINS: '), write(G),nl,
    write('                        ZOMBIES: '), write(Z),nl,
    write('               ---------------------------------'),nl.
   

display_winner(o):-
    write('                     W I N N E R:  O R C S     '),nl,
    nl,nl,nl.

display_winner(g):-
    write('                   W I N N E R:  G O B L I N S     '),nl,
    nl,nl,nl.

display_winner(z):-
    write('                   W I N N E R:  Z O M B I E S     '),nl,
    nl,nl,nl.

display_winner(t):-
    write('                       A L L  W I N N E R S     '),nl,
    nl,nl,nl.

display_winner(o-g):-
    write('            W I N N E R:  O R C S  &  G O B L I N S     '),nl,
    nl,nl,nl.

display_winner(o-z):-
    write('            W I N N E R:  O R C S  &  Z O M B I E S     '),nl,
    nl,nl,nl.


display_winner(g-z):-
    write('          W I N N E R:  G O B L I N S  &  Z O M B I E S     '),nl,
    nl,nl,nl.

display_level:-
    write('                  |         L E V E L       |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |         1. Easy         |'),nl,
    write('                  |         2. Hard         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,
    write('               Option: ').
