-module(comm).
-behaviour(gen_server).

%% API
-export([start_link/1]).
-export([add_user/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(client_sup, {sup_id}).


start_link(ClientSup_Id) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [ClientSup_Id], []).

init([ClientSup_Id]) ->
    {ok, #client_sup{sup_id = ClientSup_Id}}.

add_user(User_name) ->
    gen_server:call(?MODULE, {add_user, User_name}).


handle_call({add_user, User_name}, _From, State = #client_sup{sup_id = SupName}) ->

    case supervisor:start_child(SupName, [User_name]) of
        {ok, _} ->
            {reply, ok, State};

        {error, ErrMessage} ->
            io:format("~p~n", [ErrMessage]),
        {reply, ok, State}


    end;
    

handle_call({message, Adresat, Message}, _From, State = #client_sup{}) ->
    case Message of
        _ ->
            gen_server:call(Adresat, {message, comm, "Hi, try to send some message to your friend."})
    end,
    {reply, ok, State}.


handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
