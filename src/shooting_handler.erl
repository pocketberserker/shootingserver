-module(shooting_handler).
-export([init/3]).

-export([websocket_init/3, websocket_handle/3,
         websocket_info/3, websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_Any, Req, _Opts) ->
    Interval = round(1000 / 30),
    timer:send_interval(Interval, tick),
    Req2 = cowboy_req:compact(Req),
    {ok, Req2, {{0, 0}, []}, hibernate}.

websocket_handle({text, Msg}, Req, {PlayerShip, Bullets}) ->
    case of_json(Msg) of
        {player, X, Y} ->
	    {ok, Req, {{X, Y}, Bullets}, hibernate};
        _Other ->
	    {ok, Req, {PlayerShip, Bullets}, hibernate}
    end;
websocket_handle(_Any, Req, State) ->
    {ok, Req, State}.

websocket_info(tick, Req, {{X, Y}, Bullets}) ->
    NewBullets = [{X, Y - 10} | update_bullets(Bullets)],
    Data = to_json({{X, Y}, NewBullets}),
    {reply, {text, Data}, Req, {{X, Y}, NewBullets}, hibernate};
websocket_info(_Info, Req, State) ->
    {ok, Req, State, hibernate}.

websocket_terminate(_Reason, _Req, _State) ->
    ok.

update_bullets(Bullets) ->
    Updated = lists:map(fun({X, Y}) -> {X, Y - 20} end, Bullets),
    lists:filter(fun({_X, Y}) -> Y > 0 end, Updated).

of_json(Msg) ->
    case jsonx:decode(Msg) of
        {[{_X, X}, {_Y, Y}]} -> {player, X, Y};
	Other -> Other
    end.

to_json({{X, Y}, Bullets}) ->
    jsonx:encode({[{playerShip, {[{x, X}, {y, Y}]}}, {bullets, format_bullets(Bullets)}]}).

format_bullets(Bullets) ->
    lists:map(fun({X, Y}) -> {[{x, X}, {y, Y}]} end, Bullets).

