:-use_module(library(lists)).

% Checks if value of a number is a integer (ex: 7.0 -> true)
is_int(Number) :-
    % Intermidiate is Number mod 1
    Intermidiate is abs(Number - round(Number)),
    \+ Intermidiate > 0.


% replace(List, Index, Value, NewList)
% Replaces the element in the position Index of a list List by the value Value.
% Places the result in variable NewList
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):-
        I > -1, 
        NI is I-1,
        replace(T, NI, X, R), !.
replace(L, _, _, L).


