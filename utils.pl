:-use_module(library(lists)).

% Checks if value of a number is a integer (ex: 7.0 -> true)
is_int(Number) :-
    % Intermidiate is Number mod 1
    Intermidiate is abs(Number - round(Number)),
    \+ Intermidiate > 0.