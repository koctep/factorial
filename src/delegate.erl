-module(delegate).

-export([start/0]).
-export([calc/2]).

start() ->
    register(?MODULE, self()),
    loop().

loop() ->
    receive
        {calc, RespondTo, N, NumberOfJobs, WorkersNumber} ->
            start_workers(RespondTo, NumberOfJobs, WorkersNumber, N),
            loop()
    end.

calc(RespondTo, N) ->
    CoresPerNode = erlang:system_info(schedulers_online),
    Nodes = application:get_env(kernel, nodes, [node()]),
    NumberOfJobs = CoresPerNode * length(Nodes),
    delegate_to_nodes(RespondTo, CoresPerNode, NumberOfJobs, N, Nodes),
    NumberOfJobs.

delegate_to_nodes(_RespondTo, _CoresPerNode, _NumberOfJobs, _N, []) ->
    ok;
delegate_to_nodes(RespondTo, CoresPerNode, NumberOfJobs, N, [Node | Nodes]) ->
    logger:notice("delegating ~p with step ~p to ~p", [N, NumberOfJobs, Node]),
    {?MODULE, Node} ! {calc, RespondTo, N, NumberOfJobs, CoresPerNode},
    delegate_to_nodes(RespondTo, CoresPerNode, NumberOfJobs, N - CoresPerNode, Nodes).

start_workers(_RespondTo, _NumberOfJobs, 0, _Start) ->
    ok;
start_workers(RespondTo, NumberOfJobs, WorkerId, Start) ->
    spawn(worker, start, [RespondTo, Start, NumberOfJobs]),
    start_workers(RespondTo, NumberOfJobs, WorkerId - 1, Start - 1).
