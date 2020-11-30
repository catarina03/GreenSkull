:-include('display.pl').
:-include('moves.pl').

play:-
    display_menu(C),
    option(C).

option(1):-
    display_instructions,
    play.

option(2):-
    display_play(C),
    play_game(C).

play_game(1):-
    display_play_mode(1),
    human_human.

play_game(2):-
    display_play_mode(2).
    %human_pc.

play_game(3):-
    display_play_mode(3).
    %pc_human.

play_game(3):-
    display_play_mode(4).
    %pc_pc.

%------------ H U M A N   VS   H U M A N -----------------------------
% Starts the game
human_human:- 
    initial(GameState-Player-GreenSkull),
    play_round(GameState-[0,0,0], Player, GreenSkull).


% Initializes the game
initial(GameState-Player-GreenSkull) :-
    initial_board(GameState),
    initial_player(Player),
    initial_green_skull(GreenSkull).
   
   
% Plays one round of game
play_round(GameState-[PO,PG,PZ], Player, GreenSkull):- 
    display_game(GameState-GreenSkull,Player),
    choose_piece(GameState,Player,RowPiece,ColumnPiece),
    move_human_piece(GameState-[PO,PG,PZ]-Player-GreenSkull,RowPiece-ColumnPiece,NewGameState-[PO1,PG1,PZ1]-NewGreenSkull),
    next(Player,NewGameState-[PO1,PG1,PZ1],NewGreenSkull).
    
next(Player,GameState-[PO1,PG1,PZ1],GreenSkull):-
    \+ game_over(GameState-[PO1,PG1,PZ1], _),!,
    display_scores(PO1-PG1-PZ1),
    set_next_player(Player, NextPlayer),
    play_round(GameState-[PO1,PG1,PZ1], NextPlayer, GreenSkull).

game_over(GameState-[PO,PG,PZ],Winner):-
    is_over(GameState),!,
    display_game_over,
    final_scores(GameState-[PO,PG,PZ],[PO1,PG1,PZ1]),
    display_final_scores(PO1-PG1-PZ1),
    get_winner(PO1-PG1-PZ1,Winner),
    display_winner(Winner).

% Checks if game is over 
is_over(GameState) :- 
    pieces_out(GameState).

is_over(GameState):-
    color_in_line(GameState).

%Verifies if there's any player out
%verifica se Z está em jogo
pieces_out(GameState) :- 
    allElemetsOut(GameState,z,1).

%verifica se O está em jogo
pieces_out(GameState) :- 
    allElemetsOut(GameState,o,1).

%verifica se G está em jogo
pieces_out(GameState) :- 
    allElemetsOut(GameState,g,1).


allElemetsOut(_,_,11).
allElemetsOut(GameState,Player,N):-
    N=<10,
    nth1(N,GameState,L),
    \+ member(Player,L),
    N1 is N+1,
    allElemetsOut(GameState,Player,N1).



%verifica se todas as peças Z estão na ultima linha.
color_in_line(GameState) :-
    zombies_spread(GameState,1).

%verifica se O está nos primeiros elementos de linha.
color_in_line(GameState) :- 
    orcs_spread(GameState,10).

%verifica se G está nos primeiros elementos de linha.
color_in_line(GameState) :- 
    goblins_spread(GameState,2).


zombies_spread(GameState,Indice):-
    Indice<10,
    nth1(Indice,GameState,L),
    \+ member(z,L),
    NewIndice is Indice+1,
    zombies_spread(GameState,NewIndice).
zombies_spread(_,10).
    
    
orcs_spread(GameState,Indice):-
    Indice>1,
    get_left_diagonal(GameState,Indice,Indice,L),
    \+ member(o,L),
    NewIndice is Indice-1,
    orcs_spread(GameState,NewIndice).
orcs_spread(_,1).

goblins_spread(GameState,Indice):-
    Indice<10,
    get_right_diagonal(GameState,Indice,Indice,L),
    \+ member(g,L),
    NewIndice is Indice+1,
    goblins_spread(GameState,NewIndice).
goblins_spread(_,10).

get_left_diagonal(GameState,Indice,N,[L1|R]):-
    nth1(N,GameState,L),
    nth1(Indice,L,L1),
    N1 is N+1,
    get_left_diagonal(GameState,Indice,N1,R).

get_left_diagonal(_,_,11,[]).


get_right_diagonal(GameState,Indice,N,[L1|R]):-
    nth1(N,GameState,L),
    NewIndice is N-Indice+1,
    nth1(NewIndice,L,L1),
    N1 is N+1,
    get_right_diagonal(GameState,Indice,N1,R).

get_right_diagonal(_,_,11,[]).



% Defines the next player according to who played before
% set_next_player(Player, NextPlayer)
set_next_player(o, g).
set_next_player(g, o).

%Winner is Orcs
get_winner(PO1-PG1-PZ1,Player):-
    PO1>PG1,
    PO1>PZ1,
    Player=o.

%Winner is Goblins
get_winner(PO1-PG1-PZ1,Player):-
    PG1>PO1,
    PG1>PZ1,
    Player=g.

%Winner is Zombies
get_winner(PO1-PG1-PZ1,Player):-
    PZ1>PG1,
    PZ1>PO1,
    Player=z.

%No winners
get_winner(PO1-PG1-PZ1,Player):-
    PO1==PG1,
    PZ1==PO1,
    Player=t.

%Winners are Orcs and Globins
get_winner(PO1-PG1-PZ1,Player):-
    PO1==PG1,
    PO1>PZ1,
    Player=o-g.

%Winners are Orcs and Zombies
get_winner(PO1-PG1-PZ1,Player):-
    PO1==PZ1,
    PO1>PG1,
    Player=o-z.

%Winners are Zombies and Globins
get_winner(PO1-PG1-PZ1,Player):-
    PZ1==PG1,
    PZ1>PO1,
    Player=g-z.

%------------ P C  VS   P C -----------------------------
% Starts the game
pc_pc:- 
    initial(GameState-Player-GreenSkull),
    play_round(GameState-[0,0,0], Player, GreenSkull).
