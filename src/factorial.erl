-module(factorial).

-export([calc/1]).
-export([measure/1]).

calc(N) when is_integer(N) andalso N >= 0 ->
    calc(N, 1);
calc(_) ->
    {error, badarg}.

calc(0, Acc) ->
    Acc;
calc(N, Acc) ->
    calc(N - 1, Acc * N).

measure(N) ->
  element(1, timer:tc(?MODULE, calc, [N])).
