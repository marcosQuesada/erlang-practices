-module(myRing).
-export([start/2, node/2, addNode/3]).

start(TotalNodes, Loops) ->
    Steps = TotalNodes*Loops,
    addNode(TotalNodes, Steps).

%Adds first ring node
addNode(TotalNodes, Steps) ->
    NewPid = spawn(myRing, node, [self(), []]),
    addNode(TotalNodes, NewPid, Steps).

%Adds last ring node
addNode(1, Pid, Steps)->
    Pid ! {message, Steps},
    node(Pid, []);

%Iterates adding nodes except first and last
addNode(TotalNodes, Pid, Steps)->
    NewPid = spawn(myRing, node, [Pid, []]),
    addNode(TotalNodes-1, NewPid, Steps).

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
