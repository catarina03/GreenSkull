% z -> Zombies -> verdes
% g -> Globin -> roxos
% o -> Orc -> brancos
% 0 -> Empty space

display_game(GameState,Player):-round(Player),print_board(GameState,0),nl.

round(Player):- 
    Player='orc',
    nl, write('      TURN TO PLAY, ORC!'),nl,nl.
round(Player):- 
    Player='globin', 
    nl, write('      TURN TO PLAY, Globin!'),nl,nl.
round(Player):-
    Player='zombies',
    nl, write('      TURN TO PLAY, Zombies!'),nl,nl.

initialPlayer(orc).

% Inits the board
initialBoard([        
             [0],         
            [0,0],         
           [z,0,z],        
          [z,0,0,z],         
         [0,0,z,0,0],         
        [0,0,z,z,0,0],             
       [g,0,0,z,0,0,o],       
      [g,g,0,0,0,0,o,o],        
     [g,g,g,0,0,0,o,o,o],   
    [g,g,g,g,0,0,o,o,o,o] ]).


% prints the full board
print_board([],N).
print_board([H|T],N) :-
    space(N,S),write(S),
    write('|'), print_row(H),
    N1 is N+1,
    nl,
    print_board(T,N1).
    
% prints a single row
print_row([]).
print_row([H|T]):-
    code(H,P),   
    write(P),
    write('|'),
    print_row(T).

%replaces number with string with number spaces

space(0,'             ').
space(1,'            ').
space(2,'           ').
space(3,'          ').
space(4,'         ').
space(5,'        ').
space(6,'       ').
space(7,'      ').
space(8,'     ').
space(9,'    ').
space(10,'  ').


% replaces symbols with characters for easier display
code(0,' ').
code(z,'Z').
code(g,'G').
code(o,'O').