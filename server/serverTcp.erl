-module(serverTcp).
-author('bombadil@bosqueviejo.net').

-behaviour(gen_server).

-define(SERVER, ?MODULE).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {lsocket, socket}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    Opts = [binary, {packet, 0}, {active, true}],
    case gen_tcp:listen(5000, Opts) of
        {ok, LSocket} ->
            {ok, #state{lsocket = LSocket}, 0};
        {error, Reason} ->
            {stop, Reason}
    end.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(timeout, State=#state{lsocket=LSocket}) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    {noreply, State#state{socket=Socket}};

handle_info(Info, State=#state{socket=Socket}) ->
    io:format("~p~n", [Info]),
    gen_tcp:send(Socket, io_lib:format("~p~n", [{date(),time()}])),
    gen_tcp:close(Socket),
    {noreply, State, 0}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.