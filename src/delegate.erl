-module(delegate).

-export([calc/2]).

calc(RespondTo, N) ->
    NumWorkers = erlang:system_info(schedulers_online),
    Nodes = application:get_env(kernel, nodes, [node()]),
    Step = NumWorkers * length(Nodes),
    start_workers(RespondTo, NumWorkers, Step, N, Nodes),
    Step.

start_workers(_RespondTo, _NumWorkers, _Step, _N, []) ->
    ok;
start_workers(RespondTo, NumWorkers, Step, N, [Node | Nodes]) ->
    start_workers_at_node(RespondTo, NumWorkers, Step, N, Node),
    start_workers(RespondTo, NumWorkers, Step, N - NumWorkers, Nodes).

start_workers_at_node(_RespondTo, _Step, 0, _Start, _Node) ->
    ok;
start_workers_at_node(RespondTo, Step, NumWorkers, Start, Node) ->
    spawn(Node, worker, start, [RespondTo, Start, Step]),
    start_workers_at_node(RespondTo, Step, NumWorkers - 1, Start - 1, Node).
