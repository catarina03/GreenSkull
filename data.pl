% z -> Zombies -> verdes
% g -> Globin -> roxos
% o -> Orc -> brancos
% 0 -> Empty space

%players
player(orc).
player(globin).
player(zombies).

%replaces number with string with spaces and row number.
space(0,' 1                      ').
space(1,' 2                    ').
space(2,' 3                  ').
space(3,' 4                ').
space(4,' 5              ').
space(5,' 6            ').
space(6,' 7          ').
space(7,' 8        ').
space(8,' 9      ').
space(9,'10    ').


% replaces symbols with characters for easier display
code(0,'   ').
code(z,' Z ').
code(g,' G ').
code(o,' O ').


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

initialPlayer(orc).

%globin has the greenSkull first
greenSkull(globin).