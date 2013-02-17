-module(tcp_echo).
-export([listen/0, send/1]).

-define(TCP_OPTIONS, [binary, {packet, 2}, {active, false}, {reuseaddr, true}]).
-define(TCP_PORT, 5000).

% Call echo:listen() to start the server.
listen() ->
    {ok, LSocket} = gen_tcp:listen(?TCP_PORT, ?TCP_OPTIONS),
    spawn(fun() -> accept(LSocket) end).

% Wait for incoming connections and spawn a process that will process incoming packets.
accept(LSocket) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    Pid = spawn(fun() ->
        io:format("Connection accept on socket ~p~n", [Socket]),
        loop(Socket)
    end),
    gen_tcp:controlling_process(Socket, Pid),
    io:format("Accepted ~p~n", [Socket]),
    accept(LSocket).

% Echo back whatever data we receive on Socket.
loop(Sock) ->
    inet:setopts(Sock, [{active, true}]),
    receive
        {tcp, Socket, Data} ->
            io:format("Got packet: ~p~n", [Data]),
            % gen_tcp:send(Socket, Data),
            loop(Socket);
        {tcp_closed, Socket}->
            io:format("Socket ~p closed~n", [Socket]);
        {tcp_error, Socket, Reason} ->
            io:format("Error on socket ~p reason: ~p~n", [Socket, Reason])
    end.

send(Data) ->
    {ok, Socket} = gen_tcp:connect("localhost", ?TCP_PORT, [binary, {packet, 2}]),
    gen_tcp:send(Socket, Data),
    gen_tcp:close(Socket).

% close() ->
%     {ok, Socket} = socketConexion,
%     gen_tcp:close(socketConexion).