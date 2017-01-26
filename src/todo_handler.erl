-module(todo_handler).
-behaviour(cowboy_rest).

-export([init/2, terminate/3]).
-export([
    content_types_accepted/2,
    content_types_provided/2,
    allowed_methods/2
    ]).

-export([
    handle_todo/2,
    get_todo/2
]).

init(Req, State) -> {cowboy_rest, Req, State}.

allowed_methods(Req, State) -> 
    {[<<"GET">>, <<"POST">>], Req, State}.

content_types_accepted(Req, State) ->
    {
        [{{<<"application">>, <<"json">>, []}, handle_todo}],
        Req, State
    }.

content_types_provided(Req, State) -> 
    {
        [{{<<"application">>,<<"json">>, []}, get_todo}],
        Req, State
    }.

get_todo(Req, State) -> 
    Body = #{message => <<"List of todos">>},
    {jsx:encode(Body), Req, State}.

terminate(_Reason, _Req, _State) -> ok.

handle_todo(Req0, State) ->
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    #{<<"content">> := Content} = jsx:decode(Data, [return_maps]),

    Query = <<"INSERT INTO todo (content) VALUES (?)">>,
    gen_server:call(db_server, {Query, [Content]}),

    Resp = #{done => <<"Todo Added">>},
    Req2 = cowboy_req:set_resp_body(jsx:encode(Resp), Req1),
    {true, Req2, State}.