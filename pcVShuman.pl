pc_human:-
    initial(GameState-Player-GreenSkull),
    write('               Choose Orcs level:     '),nl,
    get_level(LevelO),
    play_pc_human_game(GameState-[0,0,0],Player,GreenSkull,LevelO).



%Turn: Goblins==HUMAN
play_pc_human_game(GameState-[PO,PG,PZ],g,GreenSkull,LevelO):-
    display_game(GameState-GreenSkull,o),
    choose_piece(GameState,o,RowPiece,ColumnPiece),
    move_human_piece(GameState-[PO,PG,PZ]-o-GreenSkull,RowPiece-ColumnPiece,NewGameState-[PO1,PG1,PZ1]-NewGreenSkull),
    nextPH(Player,NewGameState-[PO1,PG1,PZ1],NewGreenSkull,LevelO).
    

%Turn: Zombies -> Goblins have the GreenSkull
play_pc_human_game(GameState-[PO,PG,PZ],z,g,LevelO):-
    display_game(GameState-g,z),
    choose_piece(GameState,z,RowPiece,ColumnPiece),
    move_human_piece(GameState-[PO,PG,PZ]-z-g,RowPiece-ColumnPiece,NewGameState-[PO1,PG1,PZ1]-NewGreenSkull),
    nextPH(o,NewGameState-[PO1,PG1,PZ1],NewGreenSkull,LevelO).

%Turn: Orcs==PC
play_pc_human_game(GameState-[PO,PG,PZ],o,GreenSkull,LevelO):-
    display_game(GameState-GreenSkull,o),
    trace,
    choose_move(GameState,o,LevelG,Move),
    move(GameState-[PO,PG,PZ]-o,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),   
    nextPH(o,NewGameState-[PO1,PG1,PZ1],GreenSkull,LevelG).
    

%Turn: Zombies -> Goblins have the GreenSkull
play_pc_human_game(GameState-[PO,PG,PZ],z,o,LevelO):-
    display_game(GameState-o,z),
    choose_move(GameState, z,LevelG,Move),
    move(GameState-[PO,PG,PZ]-z,Move, NewGameState-[PO1,PG1,PZ1]-ListEat),
    nextPH(z,NewGameState-[PO1,PG1,PZ1],o,LevelO).

%função com argumento extra.
nextPH(Player,GameState-[PO1,PG1,PZ1],GreenSkull,Level):-
    \+ game_over(GameState-[PO1,PG1,PZ1], _),!,
    display_scores(PO1-PG1-PZ1),
    set_next_player(Player, NextPlayer),
    write(NextPlayer),
    play_pc_human_game(GameState-[PO1,PG1,PZ1], NextPlayer, GreenSkull,Level).

nextPH(_,_-_,_,_).
