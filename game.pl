:-include('display.pl').
:-include('moves.pl').

play:-
    write('                  |   G R E E N  S K U L L  |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |     1. Instructions     |'),nl,
    write('                  |     2. Play             |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,
    write('               Option: '),read(C),nl,nl,
    option(C).

option(1):-
    write('                  | I N S T R U C T I O N S |'),nl,
    write('               ---------------------------------'),nl,
    write('                  | Try to get your pieces  |'),nl,
    write('                  | across the field while  |'),nl,
    write('                  | eating as many enimies  |'),nl,
    write('                  | as you can!             |'),nl,
    write('                  |                         |'),nl,
    write('                  | Whoever holds the Green |'),nl,
    write('                  | Skull, is in charge of  |'),nl,
    write('                  | the Zombienation!       |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,nl,nl,
    play.

option(2):-
    write('                  |         P L A Y         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |     1. Human VS Human   |'),nl,
    write('                  |     2. Human Starts     |'),nl,
    write('                  |     3. Pc Starts        |'),nl,
    write('                  |     4. Pc VS Pc         |'),nl,
    write('               ---------------------------------'),nl,
    write('                  |                         |'),nl,nl,
    write('                Option: '),read(C),nl,nl,
    play_game(C).

play_game(1):-
    write('                   H U M A N   VS   H U M A N   '),nl,
    write('               ---------------------------------'),nl,nl,
    human_human.

play_game(2):-
    write('                      H U M A N   VS   P C      '),nl,
    write('               ---------------------------------'),nl,nl.
    %human_pc.

play_game(3):-
    write('                      P C   VS   H U M A N      '),nl,
    write('               ---------------------------------'),nl,nl.
    %pc_human.

play_game(3):-
    write('                         P C   VS   P C         '),nl,
    write('               ---------------------------------'),nl,nl.
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
    move(GameState-[PO,PG,PZ],Player,NewGameState-[PO1,PG1,PZ1]),
    set_next_player(Player, NextPlayer),
    \+ is_over(NewGameState,1),!,
    play_round(NewGameState-[PO1,PG1,PZ1], NextPlayer, GreenSkull).

% Displays a message when the game ends.
/*
play(Player):-
    isOver(GameState),!,
    display_game_over.
    */

% Checks if game is over (placeholder)
is_over(GameState,[O,G,Z]) :- 
   pieces_out(GameState,1),
   write('pieces out').

is_over(GameState,[O,G,Z]):-
    color_in_line(GameState,[O,G,Z]),
    write('color in line').


pieces_out(GameState,11).
%verifica se Z está em jogo
pieces_out(GameState,N):-
    N=<10,
    nth1(N,GameState,L),
    \+ member(z,L),
    N1 is N+1,
    pieces_out(GameState,N1).

%verifica se O está em jogo
pieces_out(GameState,N) :- 
    N=<10,
    nth1(N,GameState,L),
    \+ member(o,L),
    N1 is N+1,
    pieces_out(GameState,N1).

%verifica se G está em jogo
pieces_out(GameState,N) :- 
    N=<10,
    nth1(N,GameState,L),
    \+member(g,L),
    N1 is N+1,
    pieces_out(GameState,N1).

%verifica se Z está na ultima linha.
color_in_line(GameState,[O,G,Z]) :- 
    nth1(10,GameState,L),
    count(z,L,N),
    N==Z.
    
%verifica se O está nos primeiros elementos de linha.
color_in_line(GameState,[O,G,Z]) :- 
    get_orcs_line(GameState,L,1),
    count(o,L,N),
    N==O.

get_orcs_line(GameState,[],11).
get_orcs_line(GameState,[T1|T2],N):-
    N=<10,
    nth1(N,GameState,L1),
    nth1(1,L1,T1),
    N1 is N+1,
    get_orcs_line(GameState,T2,N1).
    
%verifica se G está nos primeiros elementos de linha.
color_in_line(GameState,[O,G,Z]) :- 
    get_goblins_line(GameState,L,1),
    count(g,L,N),
    N==G.

get_goblins_line(GameState,[],11).
get_goblins_line(GameState,[T1|T2],N):-
    N=<10,
    nth1(N,GameState,L1),
    nth1(N,L1,T1),
    N1 is N+1,
    get_goblins_line(GameState,T2,N1).


% Defines the next player according to who played before
% set_next_player(Player, NextPlayer)
set_next_player(o, g).
set_next_player(g, o).
