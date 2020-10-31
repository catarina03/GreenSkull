:-include('display.pl').
:-include('inputPlay.pl').

start_game:- 
    initial(GameState),
    initialPlayer(o),
    display_game(GameState,o),
    input_play(GameState, X), 
    play(Gamestate, o).

% play moves
play(Gamestate, Player):- 
    display_game(GameState, Player),
    input_play(GameState, X),

    set_next_player(Player, NextPlayer),
    not(isOver(GameState)),!,
    play(Gamestate, NextPlayer).

% displays a message when the game ends.
play(Player):-
    isOver(GameState),!,
    display_game_over.

% see if we can have more moves (TO DO!)
% isOver(GameState).
isOver(GameState) :- false.

% defines next player conform who has the greenSkull (TO DO)
% set_next_player(Player,NextPlayer)
set_next_player(o, NextPlayer) :-
    NextPlayer is g.

set_next_player(g, NextPlayer) :-
    NextPlayer is o.
