-module(shootingserver_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

start(_Types, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/shooting", shooting_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 19680}],
        [env, {dispatch, Dispatch}]
    ),
    shootingserver_sup:start_link().

stop(_State) ->
    ok.

