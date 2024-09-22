-module(worker).

-export([start/3]).

start(RespondTo, Start, Step) ->
    logger:notice("worker start from ~p, step ~p", [Start, Step]),
    Result = calc_part(Start, Step, 1),
    RespondTo ! Result.

calc_part(N, _Step, Acc) when N =< 1 ->
    Acc;
calc_part(N, Step, Acc) ->
    calc_part(N - Step, Step, Acc * N).
