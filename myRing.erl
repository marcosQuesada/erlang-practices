-module(myRing).
-export([start/2, node/2, addNode/4]).

start(TotalNodes, Vueltas) ->
    Steps = TotalNodes*Vueltas,
    addNode(TotalNodes, Steps).

%Adds first ring node
addNode(TotalNodes, Steps) ->
    NewPid = spawn(myRing, node, [self(), []]),
    addNode(TotalNodes, NewPid, [NewPid], Steps).

%Adds last ring node
addNode(1, Pid, ListNodes, Steps)->
    io:format("List completed, all: ~p~n", [ListNodes]),
    Pid ! {message, Steps},
    node(Pid, []);

%Iterates adding nodes except first and last
addNode(TotalNodes, Pid, ListNodes, Steps)->
    io:format("Adding Node ~p~n", [TotalNodes]),
    NewPid = spawn(myRing, node, [Pid, []]),
    NewListNodes = [NewPid | ListNodes],
    addNode(TotalNodes-1, NewPid, NewListNodes, Steps).

%Node Item
%OriginPid : Process Origin reference
node(OriginPid, List) ->
    receive
        {message, 0} ->
            io:format("Exercise finished ~n", []),
            exit(normal);
        {message, Steps} ->
            NewSteps = Steps - 1,
            OriginPid ! {message, NewSteps},
            io:format("Sended message from ~p to: ~p ~n", [self(), OriginPid]),
            node(OriginPid, List)
    end.
