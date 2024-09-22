-module(factorial_tests).

-include_lib("eunit/include/eunit.hrl").

calc_test() ->
  [?assertEqual(1, factorial:calc(0)),
   ?assertEqual(1, factorial:calc(1)),
   ?assertEqual(2, factorial:calc(2)),
   ?assertEqual(6, factorial:calc(3)),
   ?assertEqual(120, factorial:calc(5)),
   ?assertEqual(126886932185884164103433389335161480802865516174545192198801894375214704230400000000000000, factorial:calc(64))
  ].

type_test() ->
  [?assertEqual({error, badarg}, factorial:calc(-1)),
   ?assertEqual({error, badarg}, factorial:calc(atop))
  ].
