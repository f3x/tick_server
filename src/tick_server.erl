%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc tick_server.

-module(tick_server).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the tick_server server.
start() ->
    tick_server_deps:ensure(),
    ensure_started(crypto),
    application:start(tick_server).


%% @spec stop() -> ok
%% @doc Stop the tick_server server.
stop() ->
    application:stop(tick_server).
