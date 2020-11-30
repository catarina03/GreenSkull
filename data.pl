% z -> Zombies -> verdes
% g -> Globin -> roxos
% o -> Orc -> brancos
% e -> Empty space

% Players
player(o).
player(g).
player(z).

% Replaces number with string with spaces and row number.
space(0,'                      1 |     ').
space(1,'                    2 |     ').
space(2,'                  3 |     ').
space(3,'                4 |     ').
space(4,'              5 |     ').
space(5,'            6 |     ').
space(6,'          7 |     ').
space(7,'        8 |     ').
space(8,'      9 |     ').
space(9,'   10 |     ').


hex_code(0,'                         /     / \\     \\').
hex_code(1,'                       /     / \\ / \\     \\').
hex_code(2,'                     /     / \\ / \\ / \\   g \\').
hex_code(3,'                   / s   / \\ / \\ / \\ / \\   o \\').
hex_code(4,'                 / c   / \\ / \\ / \\ / \\ / \\   b \\').
hex_code(5,'               / r   / \\ / \\ / \\ / \\ / \\ / \\   l \\').
hex_code(6,'             / o   / \\ / \\ / \\ / \\ / \\ / \\ / \\   i \\').
hex_code(7,'           /     / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\   n \\').
hex_code(8,'         /     / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\   s \\').
hex_code(9,'       /     / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\     \\').
hex_code(10,'     /       \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ /       \\').


% Replaces symbols with characters for easier display
code(e,'   ').
code(z,' Z ').
code(g,' G ').
code(o,' O ').


% Inits the board
initial_board([       
             [e],         
            [e,e],         
           [e,e,z],        
          [e,z,e,z],         
         [e,e,e,e,e],         
        [e,e,z,z,e,e],             
       [g,e,e,z,e,z,o],       
      [g,g,e,e,z,e,o,o],        
     [g,g,g,e,e,e,o,o,o],   
    [g,g,g,g,e,e,o,o,o,o] ]).


final_board([       
             [e],         
            [e,e],         
           [e,e,e],        
          [e,e,e,e],         
         [o,e,e,e,e],         
        [o,e,z,e,e,g],             
       [o,e,e,g,e,e,g],       
      [o,e,e,e,e,e,e,g],        
     [o,e,e,e,e,e,e,e,e],   
    [o,z,z,z,e,e,e,e,e,e] ]).

error_board([      
             [e],         
            [g,e],         
           [e,g,z],        
          [e,e,e,z],         
         [e,e,e,e,e],         
        [e,e,z,z,e,e],             
       [e,o,e,z,e,e,e],       
      [e,e,e,e,z,e,e,e],        
     [e,e,e,e,e,e,e,e,e],   
    [e,e,e,e,e,e,e,e,e,e] 
]).

% The orcs start playing first
initial_player(o).
	
% The globins start with the Green Skull
initial_green_skull(g).

