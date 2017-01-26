-module(db_server).
-behaviour(gen_server).

-export([start_link/0]).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         code_change/3,
         terminate/2]).

-record(state, {
    pid :: pid()
}).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Pid = start_server(),
    {ok, #state{pid = Pid}}.

handle_call({Query, Values}, _From, #state{pid = Pid} = State) ->
    ok = mysql:query(Pid, Query, Values),
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
    {ok, Pid} = mysql:start_link([{host, "localhost"}, {user, "root"},  
        {password, ""}, {database, "yatm"}]),
    ok = mysql:query(Pid, <<"CREATE TABLE IF NOT EXISTS todo (
        id INT AUTO_INCREMENT PRIMARY KEY,
        content VARCHAR(256))">>, []),
    Pid.