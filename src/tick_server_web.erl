%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc Web server for tick_server.

-module(tick_server_web).
-author("Mochi Media <dev@mochimedia.com>").

-export([start/1, stop/0, loop/2, unix_time/0]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
	try
    	case Req:get(method) of
        	Method when Method =:= 'GET'; Method =:= 'HEAD' ->
            	case Path of
                	"tick/" ++ Id ->
				    	Response = Req:ok({"text/html; charset=utf-8",
                        	              [{"Server","Tick server"}],
                            	          chunked}),
                    	Response:write_chunk("Tick server v.0.1 for " ++ Id ++ "<br>\n"),

						%send tick
						tick(Response, Id, 1);
					
                	_ ->
                    	Req:not_found()
            	end;
        	'POST' ->
            	case Path of
                	_ ->
                    	Req:not_found()
            	end;
        _ ->
            Req:respond({501, [], []})
    end
	catch
		_ ->
			ok
	end.

%% Internal API

unix_time() ->
	{M, S, _} = now(), M*1000000 + S.

tick(Response, Path, N) ->
    receive		
    after 1000 ->
		Time = unix_time(),
		%erlang:display(Time),
		Msg = io_lib:format("~w ~w\n", [Time, N]),
	    Response:write_chunk(Msg)
    end,
    tick(Response, Path, N+1).


get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.