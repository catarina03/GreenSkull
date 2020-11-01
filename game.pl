:-include('display.pl').
:-include('moves.pl').

% Starts the game
play :- 
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
    \+ is_over(GameState),!,
    play_round(GameState, NextPlayer, GreenSkull).

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
