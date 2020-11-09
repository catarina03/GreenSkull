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


hex_code(0,'                         /').
hex_code(1,'                       /   /').
hex_code(2,'                     /   /   /').
hex_code(3,'                   /   /   /   /').
hex_code(4,'                 /   /   /   /   /').
hex_code(5,'               /   /   /   /   /   /').
hex_code(6,'             /   /   /   /   /   /   /').
hex_code(7,'           /   /   /   /   /   /   /  /').
hex_code(8,'         /   /   /   /   /   /   /   /   /').
hex_code(9,'       /   /   /   /   /   /   /   /   /   /').
hex_code(10,'         /   /   /   /   /   /   /   /   /   /').


% Replaces symbols with characters for easier display
code(0,'   ').
code(z,' Z ').
code(g,' G ').
code(o,' O ').


% Inits the board
initial_board([       
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
intermediate_board([
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
final_board([
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
initial_player(o).
	
% The globins start with the Green Skull
initial_green_skull(g).

