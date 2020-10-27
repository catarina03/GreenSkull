:-include('display.pl').

play :- 
    initialBoard(GameState),
    initialPlayer(Player),
    display_game(GameState,Player)​.
