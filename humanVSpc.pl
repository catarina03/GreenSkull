human_pc:-
    initial(GameState-Player-GreenSkull),
    write('               Choose Goblins level:     '),nl,
    get_level(LevelG),
    play_human_pc_game(GameState-[0,0,0],Player,GreenSkull,LevelG).



%Turn: Orcs==HUMAN
play_human_pc_game(GameState-[PO,PG,PZ],o,GreenSkull,LevelG):-
    display_game(GameState-GreenSkull,o),
    choose_piece(GameState,o,RowPiece,ColumnPiece),
    move_human_piece(GameState-[PO,PG,PZ]-o,RowPiece-ColumnPiece,NewGameState-[PO1,PG1,PZ1]),
    nextHP(o,NewGameState-[PO1,PG1,PZ1],GreenSkull,LevelG).
    

%Turn: Zombies -> Orcs have the GreenSkull
play_human_pc_game(GameState-[PO,PG,PZ],z,o,LevelG):-
    display_game(GameState-o,z),
    choose_piece(GameState,z,RowPiece,ColumnPiece),
    move_human_piece(GameState-[PO,PG,PZ]-z,RowPiece-ColumnPiece,NewGameState-[PO1,PG1,PZ1]),
    nextHP(z,NewGameState-[PO1,PG1,PZ1],o,LevelG).

%Turn: Goblins==PC
play_human_pc_game(GameState-[PO,PG,PZ],g,GreenSkull,LevelG):-
    display_game(GameState-GreenSkull,g),
    choose_move(GameState, g,LevelG,Move),
    move(GameState-[PO,PG,PZ]-g,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),   
    nextHP(g,NewGameState-[PO1,PG1,PZ1],GreenSkull,LevelG).

%Turn: Zombies -> Goblins have the GreenSkull
play_human_pc_game(GameState-[PO,PG,PZ],z,g,LevelG):-
    display_game(GameState-g,z),
    choose_move(GameState, z,LevelG,Move),
    move(GameState-[PO,PG,PZ]-z,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),
    nextHP(z,NewGameState-[PO1,PG1,PZ1],g,LevelG).

%função com argumento extra.
nextHP(Player,GameState-[PO1,PG1,PZ1],GreenSkull,Level):-
    \+ game_over(GameState-[PO1,PG1,PZ1], _),!,
    display_scores(PO1-PG1-PZ1),
    set_next_player(Player, NextPlayer),
    write(NextPlayer),
    play_human_pc_game(GameState-[PO1,PG1,PZ1], NextPlayer, GreenSkull,Level).

nextHP(_,_-_,_,_).
