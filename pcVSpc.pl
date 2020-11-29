pc_pc:-
    initial(GameState-Player-GreenSkull),
    write('                   Choose Orcs level:     '),nl,
    get_level(LevelO),
    write('                   Choose Goblins level:     '),nl,
    get_level(LevelG),
    play_game(GameState-[0,0,0],Player,GreenSkull,LevelO-LevelG).

levelPlayer(Level):-
    write('                  |         L E V E L       |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |         1. Easy         |'),nl,
    write('                  |         2. Hard         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,
    write('               Option: '),read(Level),nl,nl.

play_game(GameState-[PO,PG,PZ],Player,GreenSkull,LevelO-LevelG):-
    display_game(GameState-GreenSkull,Player),
    choose_level_round(Player,GreenSkull,LevelO-LevelG,Level),
    choose_move(GameState, Player,Level,Move)​,
    move(GameState-[PO,PG,PZ]-Player,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),
    next(Player,NewGameState-[PO1,PG1,PZ1],GreenSkull,LevelO,LevelG).


choose_level_round(o,_,LO-_,Level):-Level=LO.
choose_level_round(g,_,_-LG,Level):-Level=LG.
choose_level_round(z,o,LO-_,Level):-Level=LO.
choose_level_round(z,g,_-LG,Level):-Level=LG.

%função com 2 argumento extra.
next(Player,GameState-[PO1,PG1,PZ1],GreenSkull,LevelO,LevelG):-
    \+ game_over(GameState-[PO1,PG1,PZ1], _),!,
    display_scores(PO1-PG1-PZ1),
    set_next_player(Player, NextPlayer),
    play_game(GameState-[PO1,PG1,PZ1], NextPlayer, GreenSkull,LevelO-LevelG).

choose_move(GameState,Player,Level,Move):-
    