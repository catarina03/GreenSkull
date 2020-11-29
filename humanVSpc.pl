human_pc:-
    initial(GameState-Player-GreenSkull),
    write('                   Choose Goblins level:     '),nl,
    get_level(LevelG),
    play_human_pc_game(GameState-[0,0,0],Player,GreenSkull,LevelG).

levelPlayer(Level):-
    write('                  |         L E V E L       |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |         1. Easy         |'),nl,
    write('                  |         2. Hard         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,
    write('               Option: '),read(Level),nl,nl.

%Turn: Orcs==HUMAN
play_human_pc_game(GameState-[PO,PG,PZ],o,GreenSkull,LevelG):-
    display_game(GameState-GreenSkull,Player),
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    move_human_piece(GameState-[PO,PG,PZ]-Player,RowPiece-ColumnPiece,NewGameState-[PO1,PG1,PZ1]),
    next(Player,NewGameState-[PO1,PG1,PZ1],GreenSkull,LevelG).
    
%Turn: Zombies -> Orcs have the GreenSkull
play_human_pc_game(GameState-[PO,PG,PZ],z,o,LevelG):-
    display_game(GameState-GreenSkull,Player),
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    move_human_piece(GameState-[PO,PG,PZ]-Player,RowPiece-ColumnPiece,NewGameState-[PO1,PG1,PZ1]),
    next(Player,NewGameState-[PO1,PG1,PZ1],GreenSkull,LevelG).

%Turn: Goblins==PC
play_human_pc_game(GameState-[PO,PG,PZ],g,GreenSkull,LevelG):-
    display_game(GameState-GreenSkull,Player),
    choose_level_round(Player,GreenSkull,LevelO-LevelG,Level),
    choose_move(GameState, Player,Level,Move)​,
    move(GameState-[PO,PG,PZ]-Player,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),
    next(Player,NewGameState-[PO1,PG1,PZ1],GreenSkull).

%Turn: Zombies -> Goblins have the GreenSkull
play_human_pc_game(GameState-[PO,PG,PZ],z,g,LevelG):-
    display_game(GameState-GreenSkull,Player),
    choose_level_round(Player,GreenSkull,LevelO-LevelG,Level),
    choose_move(GameState, Player,Level,Move)​,
    move(GameState-[PO,PG,PZ]-Player,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),
    next(Player,NewGameState-[PO1,PG1,PZ1],GreenSkull).

%função com argumento extra.
next(Player,GameState-[PO1,PG1,PZ1],GreenSkull,Level):-
    \+ game_over(GameState-[PO1,PG1,PZ1], _),!,
    display_scores(PO1-PG1-PZ1),
    set_next_player(Player, NextPlayer),
    play_human_pc_game(GameState-[PO1,PG1,PZ1], NextPlayer, GreenSkull,Level).
