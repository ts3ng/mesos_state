%%%-------------------------------------------------------------------
%% @doc mesos_state public API
%% @end
%%%-------------------------------------------------------------------

-module(mesos_state_app).

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    ok.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
