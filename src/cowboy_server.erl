-module(cowboy_server).
-behaviour(gen_server).

-export([start_link/0]).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         code_change/3,
         terminate/2]).

start_link() ->
    io:fwrite("Starting cowboy server ~n"),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    start_server(),
    {ok, ok}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

start_server() ->
    Dispatch = cowboy_router:compile(
        [
            {'_', [
                {"/", todo_handler, []}
                ]
            }
        ]),
    {ok, _} = cowboy:start_clear(example, 100,
                                [{port, 8082}],
                                #{env => #{dispatch => Dispatch}}
                                ).