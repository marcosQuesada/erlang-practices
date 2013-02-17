-module(chat).
-export([start/0, server/1, client/2, login/1, logoff/0, message/1, terminate/0]).

server_node() ->
    server@machine.

server(UserList) ->
    % io:format("Server with PID: ~p~n", [self()]),
    receive
        {login, CLientPID, Name} ->
            New_UserList = registerUser(CLientPID, Name, UserList),
            io:format("New User List ~p ~n", [New_UserList]),
            server(New_UserList);
        {logoff, CLientPID} ->
            New_UserList = unRegisterUser(CLientPID, UserList),
            io:format("Unregister User from List ~p ~n", [New_UserList]),
            server(New_UserList);
        terminate ->
            io:format("Terminate Server~n", []),
            exit(normal);
        {message, Message} ->
            io:format("Message: ~p ~n", [Message]),
            server(UserList)
    end.


%Adds User to User List
registerUser(CLientPID, UserName, UserList) ->
    case lists:keymember(UserName, 2, UserList) of
        true ->
            CLientPID ! logonKO,
            UserList;
        false ->
            CLientPID ! logonOK,
            [{CLientPID, UserName} | UserList]
    end.

unRegisterUser(CLientPID, UserList) ->
    io:format("Unregistering: ~p ~n", [CLientPID]),
    lists:keydelete(CLientPID, 1, UserList).

client(ServerNode, Username) ->
    {server_process, ServerNode}  ! {login, self(), Username},
    io:format("New User on server: ~p ~n", [Username]),
    client(Username).

client(Username) ->
    receive
        logoff ->
            {server_process, server_node()} ! {logoff, self()},
            io:format("Bye Bye ~n", []),
            exit(normal);
        logonOK ->
            io:format("User Loged in server as: ~p ~n", [Username]);
        logonKO ->
            io:format("User Is already Loged in server as: ~p ~n", [Username]),
            exit(normal)
        % {message_to, ToName, Message} ->
        %     {server_process, server_node()} ! {self(), message_to, ToName, Message},
        %     await_result();
        % {message_from, FromName, Message} ->
        %     io:format("Message from ~p: ~p~n", [FromName, Message])
    end,
    client(Username).

message(Message) ->
    {server_process, server_node()}  ! {message, Message}.

%Notify server to login user
login(Username) ->
    case whereis(clientPID) of
        undefined ->
            register(clientPID, spawn(chat, client, [server_node(), Username]));
        _ -> alreadyLogged
    end.

logoff() ->
    io:format("Logged Of from: ~p ~n", [self()]),
    clientPID ! logoff.

%Starts server
start() ->
    io:format("Starting sever~n", []),
    register(server_process, spawn(chat, server, [[]])).

%Kills Server
terminate() ->
    {server_process, server_node()} ! terminate.
