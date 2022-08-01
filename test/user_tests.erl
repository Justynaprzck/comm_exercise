-module(user_tests).
-include_lib("eunit/include/eunit.hrl").

start_link_test() ->
    {ok, _Pid3} = comm_sup:start_link(),
  {ok, _Pid} = users:start_link(user1),
  {ok, _Pid2} = users:start_link(user2).
    

send_message_test() ->
    ok = gen_server:call(user2, {message, user1, "a"}),
    ok = gen_server:call(comm, {message, user1, "a"}).

stop_test() ->
    stopped = users:stop(user1),
    stopped = users:stop(user2).
    %exit(comm_sup).





