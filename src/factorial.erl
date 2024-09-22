-module(factorial).

-export([calc/1]).
-export([measure/1]).

calc(N) when is_integer(N) andalso N >= 0 ->
    RespondTo = self(),
    Works = delegate:calc(RespondTo, N),
    recv_parts(Works, 1);
calc(_) ->
    {error, badarg}.

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
