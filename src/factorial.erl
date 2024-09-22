-module(factorial).

-export([calc/1]).
-export([measure/1]).

calc(0) ->
    1;
calc(N) when is_integer(N) andalso N > 0 ->
    N * calc(N - 1);
calc(_) ->
    {error, badarg}.

measure(N) ->
  element(1, timer:tc(?MODULE, calc, [N])).
