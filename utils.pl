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


is_empty([]).



is_member(_, []) :- fail.
is_member(Element, [Element | _]).
is_member(Element, [_ | Rest]) :- is_member(Element, Rest).



% Reads input from user
input_play(Message,Row,Column) :-
    write(Message),nl,
    write('Row: '), read(Row),
    write('Column: '), read(Column),nl.

input_message(Message,Response) :-
    write(Message),nl, read(Response), nl.


