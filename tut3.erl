-module(tut3).
-export([convert_lenght/1]).

convert_lenght({centimeter, X}) ->
	{inch, X /2.54};
convert_lenght({inch, Y}) ->
	{centimeter, Y * 2.54}.

