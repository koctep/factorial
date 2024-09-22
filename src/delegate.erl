-module(delegate).

-export([calc/2]).

calc(RespondTo, N) ->
    Cores = erlang:system_info(schedulers_online),
    Step = Cores,
    logger:notice("starting ~p workers", [Cores]),
    start_workers(RespondTo, Cores, Step, N),
    Cores.

start_workers(_RespondTo, _Step, 0, _Start) ->
    ok;
start_workers(RespondTo, Step, WorkerId, Start) ->
    spawn(worker, start, [RespondTo, Start, Step]),
    start_workers(RespondTo, Step, WorkerId - 1, Start - 1).
