:-include('display.pl').
:-include('moves.pl').

play:-
    write('                  |   G R E E N  S K U L L  |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |     1. Instructions     |'),nl,
    write('                  |     2. Play             |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,
    write('               Option: '),read(C),nl,nl,
    option(C).

option(1):-
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
    write('                  |                         |'),nl,nl,nl,
    play.

option(2):-
    write('                  |         P L A Y         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |     1. Human VS Human   |'),nl,
    write('                  |     2. Human Starts     |'),nl,
    write('                  |     3. Pc Starts        |'),nl,
    write('                  |     4. Pc VS Pc         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,nl,
    write('                Option: '),read(C),nl,nl,
    play_game(C).

play_game(1):-
    write('                   H U M A N   VS   H U M A N   '),nl,
    write('               ---------------------------------'),nl,nl,
    human_human.

play_game(2):-
    write('                      H U M A N   VS   P C      '),nl,
    write('               ---------------------------------'),nl,nl.
    %human_pc.

play_game(3):-
    write('                      P C   VS   H U M A N      '),nl,
    write('               ---------------------------------'),nl,nl.
    %pc_human.

play_game(3):-
    write('                         P C   VS   P C         '),nl,
    write('               ---------------------------------'),nl,nl.
    %pc_pc.

%------------ H U M A N   VS   H U M A N -----------------------------
% Starts the game
human_human:- 
    initial(GameState-Player-GreenSkull),
    play_round(GameState, Player, GreenSkull).


% Initializes the game
initial(GameState-Player-GreenSkull) :-
    initial_board(GameState),
    initial_player(Player),
    initial_green_skull(GreenSkull).
   
   
% Plays one round of game
play_round(GameState, Player, GreenSkull):- 
    display_game(GameState-GreenSkull,Player),
    move(GameState,Player,NewGameState),
    set_next_player(Player, NextPlayer),
    \+ is_over(NewGameState),!,
    play_round(NewGameState, NextPlayer, GreenSkull).

% Displays a message when the game ends.
/*
play(Player):-
    isOver(GameState),!,
    display_game_over.
    */

% Checks if game is over (placeholder)
is_over(GameState) :- false.

% Defines the next player according to who played before
% set_next_player(Player, NextPlayer)
set_next_player(o, g).
set_next_player(g, o).
