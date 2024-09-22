-module(factorial).

-export([calc/1]).
-export([measure/1]).

calc(N) when is_integer(N) andalso N >= 0 ->
    Cores = erlang:system_info(schedulers_online),
    logger:notice("starting ~p workers", [Cores]),
    start_workers(Cores, Cores, N),
    recv_parts(Cores, 1);
calc(_) ->
    {error, badarg}.

start_workers(_Step, 0, _Start) ->
    ok;
start_workers(Step, WorkersN, Start) ->
    RespondTo = self(),
    spawn(worker, start, [RespondTo, Start, Step]),
    start_workers(Step, WorkersN - 1, Start - 1).

recv_parts(0, Acc) ->
    Acc;
recv_parts(N, Acc) ->
    logger:notice("waiting for ~p results", [N]),
    receive
        Result ->
            recv_parts(N - 1, Acc * Result)
    end.

measure(N) ->
  element(1, timer:tc(?MODULE, calc, [N])).
