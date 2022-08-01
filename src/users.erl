-module(users).
-behaviour(gen_server).

%% API
-export([start_link/1]).
-export([stop/1, send_message/2, send_message/1, get_message/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {inbox=[]}).
-record(message, {from, body}).



start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [], []).

init([]) ->
    {ok, #state{}}.

stop(Name) ->
    gen_server:call(Name, stop).

%===================================================================================

send_message(From, To) ->
    Message = io:get_line("> "),
    io:format("~p~n", [Message]),
    gen_server:call(To, {message, From, Message}). 

send_message(From) ->
    Message = io:get_line("> "),
    gen_server:call(comm, {message, From, Message}).

get_message(User) ->
    gen_server:call(User, {receive_next_message}).


%=====================================================================================

handle_call({message, Adresat, Message}, _From, #state{inbox = Inbox} = State) ->
    NewInbox = Inbox ++ [#message{from = Adresat, body = Message}],
    {reply, ok, State#state{inbox = NewInbox}};

handle_call({receive_next_message}, _From, #state{inbox = Inbox} = State) ->

    case Inbox of
        [Head | Tail] ->
            From = Head#message.from,
            Message = Head#message.body,
            io:format("From ~p: ~p~n", [From, Message]),
            {reply, Head, State#state{inbox = Tail}};
        _ ->
            io:format("Your mailbox is empty!~n"), 
            {reply, ok, State}
    end;

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.


handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

