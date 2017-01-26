%%%-------------------------------------------------------------------
%% @doc yatm top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(yatm_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%% Helper macro for declaring children of supervisor
%% Child :: {Id,{M, F, A},Restart,Shutdown,Type,Modules}
-define(CHILD(I, Type, Args), {I, {I, start_link, Args},
                               permanent, 5000, Type, [I]}).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
     Childrens = [
                 ?CHILD(db_server, worker, []),
                 ?CHILD(cowboy_server, worker, [])
     ],
    {ok, { {one_for_all, 0, 1}, Childrens} }.

%%====================================================================
%% Internal functions
%%====================================================================
