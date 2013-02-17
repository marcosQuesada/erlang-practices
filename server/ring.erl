-module(ring).
-export([ringtest/2, ringNode/1]).

ringNode(PPid) ->
    receive
        {exit} ->
            PPid!{exit},
            true;
        {0} ->
            PPid!{exit},
            true;
        {N} ->
            PPid!{(N-1)},
            ringNode(PPid)
    end.

ringtest(N, M) ->
    ringtest(N-2, self(), N*(M-1)).

ringtest(0, ThisPid, M) ->
    Pid = spawn(ring, ringNode, [ThisPid]),
    Pid!{M},
    ringNode(Pid);
ringtest(N, ThisPid, M) ->
    Pid = spawn(ring, ringNode, [ThisPid]),
    ringtest(N-1, Pid, M).