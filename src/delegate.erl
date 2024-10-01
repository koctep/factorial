-module(delegate).

-export([calc/2]).

calc(RespondTo, N) ->
    CoresPerNode = erlang:system_info(schedulers_online),
    Nodes = application:get_env(kernel, nodes, [node()]),
    NumberOfJobs = CoresPerNode * length(Nodes),
    delegate_to_nodes(RespondTo, CoresPerNode, NumberOfJobs, N, Nodes),
    NumberOfJobs.

delegate_to_nodes(_RespondTo, _CoresPerNode, _NumberOfJobs, _N, []) ->
    ok;
delegate_to_nodes(RespondTo, CoresPerNode, NumberOfJobs, N, [Node | Nodes]) ->
    start_workers(RespondTo, CoresPerNode, NumberOfJobs, N, Node),
    delegate_to_nodes(RespondTo, CoresPerNode, NumberOfJobs, N - CoresPerNode, Nodes).

start_workers(_RespondTo, 0, _NumberOfJobs, _Start, _Node) ->
    ok;
start_workers(RespondTo, WorkerId, NumberOfJobs, Start, Node) ->
    spawn(Node, worker, start, [RespondTo, Start, NumberOfJobs]),
    start_workers(RespondTo, WorkerId - 1, NumberOfJobs, Start - 1, Node).
