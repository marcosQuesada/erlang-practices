-module(myRing).
-export([start/2, nodeFoo/1, addNode/3]).

start(TotalNodes, Loops) ->
    Steps = TotalNodes*Loops,
    addNode(TotalNodes, Steps).

%Adds first ring node
addNode(TotalNodes, Steps) ->
    NewPid = spawn(myRing, nodeFoo, [self()]),
    addNode(TotalNodes, NewPid, Steps).

%Adds last ring node
addNode(1, Pid, Steps)->
    Pid ! {message, Steps},
    nodeFoo(Pid);

%Iterates adding nodes except first and last
addNode(TotalNodes, Pid, Steps)->
    NewPid = spawn(myRing, nodeFoo, [Pid]),
    addNode(TotalNodes-1, NewPid, Steps).

%Node Item
%OriginPid : Process Origin reference
nodeFoo(OriginPid) ->
    receive
        {message, 0} ->
            io:format("Exercise finished ~n", []),
            exit(normal);

        {message, Steps} ->
            NewSteps = Steps - 1,
            OriginPid ! {message, NewSteps},
            io:format("Sended message from ~p to: ~p ~n", [self(), OriginPid]),
            nodeFoo(OriginPid)
    end.
