-module(comm_sup_tests).
-define(DEBUG,true).
-include_lib("eunit/include/eunit.hrl").



%==================
% handle_call_test() ->
{ok, Pid} = users:start_link(user),
users:send_message(user, user2)
users:handle_call({message, user, "a"}, _From, #state{inbox = Inbox} = State)
NewInbox = Inbox ++ [#message{from = Adresat, body = Message}],
{reply, ok, State#state{inbox = NewInbox}};