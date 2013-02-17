-module(tut15).
-export([start/0, ping/2, pong/0]).

ping(0, Pong_PID) ->
    Pong_PID ! finished,
    io:format("ping finished~n", []);
ping(N, Pong_PID) ->
    io:format("Ping Called N: ~p Times to PID: ~p~n", [N, Pong_PID]),
    Pong_PID ! {ping, self()},
    receive
	pong ->
	    io:format("Ping received pong~n", [])
    end,
    ping(N -1, Pong_PID).

pong() ->
    io:format("Pong process Up with PID: ~p~n", [self()]),
    receive
    finished ->
        io:format("Pong finished~n", []);
    {ping, Ping_PID} ->
        io:format("Pong received ping from process PID: ~p~n", [Ping_PID]),
        Ping_PID ! pong,
        pong()
    end.

start() ->
    Pong_PID = spawn(tut15, pong, []),
    spawn(tut15, ping, [3, Pong_PID]).
