% z -> Zombies -> verdes
% g -> Globin -> roxos
% o -> Orc -> brancos
% 0 -> Empty space

% Players
player(o).
player(g).
player(z).

% Replaces number with string with spaces and row number.
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


% Replaces symbols with characters for easier display
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

% Intermediate Board
intermediateBoard([
             [0],
            [0,0],
           [z,0,0],
          [0,0,0,0],
         [0,z,z,0,0],
        [0,0,z,z,0,o],
       [g,0,0,0,0,0,0],
      [g,0,0,0,0,0,0,o],
     [g,g,0,0,0,z,0,0,o],
    [g,g,0,0,g,0,0,o,o,o] ]).

% Final Board
finalBoard([
             [0],
            [0,0],
           [0,0,g],
          [0,0,0,g],
         [0,0,0,0,g],
        [0,0,0,0,0,g],
       [o,0,0,0,0,0,g],
      [o,0,0,0,0,0,g,0],
     [o,0,0,0,0,0,0,0,g],
    [o,0,0,0,0,0,0,0,0,0] ]).

% The orcs start playing first
initialPlayer(o).
	
% The globins have the Green Skull
greenSkull(g).

% The orcs have the Green Skull
greenSkull(o).
