:-include('display.pl').
:-include('inputPlay.pl').

start_game:- 
    initial(GameState),
    initialPlayer(Player),
    display_game(GameState,Player),
    play(Player).

%play moves
play(Player):- 
    round(Player),
    input_play(GameState), 
    display_game(GameState,Player),
    set_next_player(Player, NextPlayer),
    not isOver(GameState),!
    play(NextPlayer).

%displays a message when the game ends.
play(Player):-
    isOver(GameState),!,
    display_game_over.

%see if we can have more moves (TO DO!)
%isOver(GameState).

%defines next player conform who has the greenSkull
set_next_player(Player,NextPlayer)