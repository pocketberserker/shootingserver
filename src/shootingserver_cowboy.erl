-module(shootingserver_cowboy).
-export([start/0]).

start() ->
    application:start(crypto),
    application:start(ranch),
    application:start(cowboy),
    application:start(jsonx),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"shooting", shooting_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(shooting_listener, 100, [{port, 19680}],
        [env, {dispatch, Dispatch}]
    ),
    ok.

