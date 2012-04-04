%% @author Mochi Media <dev@mochimedia.com>
%% @copyright tick_server Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the tick_server application.

-module(tick_server_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for tick_server.
start(_Type, _StartArgs) ->
    tick_server_deps:ensure(),
    tick_server_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for tick_server.
stop(_State) ->
    ok.
