-module(tut4).
-export([list_lenght/1]).

list_lenght([]) ->
	0;
list_lenght([First | Rest]) ->
	1 + list_lenght(Rest).

