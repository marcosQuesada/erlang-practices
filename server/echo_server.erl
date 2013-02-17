-module(echo_server).
-author('Jesse E.I. Farmer <jesse@20bits.com>').

-export([start/0, loop/1]).

% echo_server specific code
start() ->
    socket_server:start(?MODULE, 7000, {?MODULE, loop}).
loop(Socket) ->
    io:format("Starting Loop ~n", []),
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("case OK Data:~p ~n", [Data]),
            gen_tcp:send(Socket, Data),
            loop(Socket);
        {error, closed} ->
            ok
    end.