:-include('display.pl').
:-include('inputPlay.pl').

% Starts the game
play :- 
    finalBoard(GameState),
    initialPlayer(o),
    greenSkull(g),
    play_round(GameState, o, g).

% Plays one round of game
play_round(GameState, Player, GreenSkull):- 
    display_game(GameState, Player, GreenSkull),
    input_play(GameState, X),
    set_next_player(Player, NextPlayer),
    \+ isOver(GameState),!,
    play_round(GameState, NextPlayer, GreenSkull).

% Displays a message when the game ends.
/*
play(Player):-
    isOver(GameState),!,
    display_game_over.
    */

% Checks if game is over (placeholder)
isOver(GameState) :- false.

% Defines the next player according to who played before
% set_next_player(Player, NextPlayer)
set_next_player(o, g).
set_next_player(g, o).
