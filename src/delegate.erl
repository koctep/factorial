-module(delegate).

-export([calc/2]).

calc(RespondTo, N) ->
    NumWorkers = erlang:system_info(schedulers_online),
    Step = NumWorkers,
    logger:notice("starting ~p workers", [NumWorkers]),
    start_workers(RespondTo, NumWorkers, Step, N),
    NumWorkers.

start_workers(_RespondTo, _Step, 0, _Start) ->
    ok;
start_workers(RespondTo, Step, NumWorkers, Start) ->
    spawn(worker, start, [RespondTo, Start, Step]),
    start_workers(RespondTo, Step, NumWorkers - 1, Start - 1).
