-module(tut10).
-export([convert_lenght/1]).

convert_lenght(Lenght) ->
    case Lenght of
	{centimeter, X} ->
	    {inch, X / 2.54};
	{inch, Y} ->
	    {centimeter, Y * 2.54}
    end.

