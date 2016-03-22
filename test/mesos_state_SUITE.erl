%%%-------------------------------------------------------------------
%%% @author sdhillon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Mar 2016 10:43 AM
%%%-------------------------------------------------------------------
-module(mesos_state_SUITE).
-author("sdhillon").

-include("mesos_state.hrl").

-include_lib("common_test/include/ct.hrl").

%% API
-export([all/0, parse_json/1, test_lashup_publisher/1, parse_all/1]).


all() ->
  [parse_json, test_lashup_publisher, parse_all].

parse_json(Config) ->
  DataDir = ?config(data_dir, Config),
  State1Json = filename:join(DataDir, "state1.json"),
  {ok, State1JsonData} = file:read_file(State1Json),
  {ok, ParsedBody} = mesos_state_client:parse_response(State1JsonData),
  Tasks = mesos_state_client:tasks(ParsedBody),
  HealthyTask = lists:keyfind(<<"sleep.85df5710-e493-11e5-b2f1-0242816970c9">>, #task.id, Tasks),
  #task{statuses = [#task_status{healthy = true}|_]} = HealthyTask,
  UndefinedHealthTask = lists:keyfind(<<"sleep10.4bfae841-e496-11e5-b2f1-0242816970c9">>, #task.id, Tasks),
  #task{statuses = [#task_status{healthy = undefined}|_]} = UndefinedHealthTask,
  <<"e4c1a425-6478-4d51-99ae-5820fa6ffd3b-S0">> = mesos_state_client:id(ParsedBody),
  ok.

test_lashup_publisher(Config) ->
  DataDir = ?config(data_dir, Config),
  State2Json = filename:join(DataDir, "state2.json"),
  {ok, State2JsonData} = file:read_file(State2Json),
  {ok, ParsedBody} = mesos_state_client:parse_response(State2JsonData),
  Tasks = mesos_state_client:tasks(ParsedBody),
  ct:pal("Tasks: ~p", [Tasks]),
  DITask = lists:keyfind(<<"sleep.bf108244-ec7f-11e5-b98e-82ce0fb60967">>, #task.id, Tasks),
  ct:pal("Task: ~p", [DITask]),
  ok.

parse_all(Config) ->
  DataDir = ?config(data_dir, Config),
  GlobPattern =  filename:join(DataDir, "*.json"),
  Filenames = filelib:wildcard(GlobPattern),
  lists:foreach(fun parse/1, Filenames).

parse(Filename) ->
  ct:pal("Trying to parse: ~p", [Filename]),
  {ok, StateJson} = file:read_file(Filename),
  {ok, ParsedBody} = mesos_state_client:parse_response(StateJson),
  mesos_state_client:tasks(ParsedBody).




