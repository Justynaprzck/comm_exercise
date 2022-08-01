-module(comm_sup).
-behaviour(supervisor).

%% API
-export([start_link/0]).
-export([init/1]).



start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    SupervisorSpecification = #{
        strategy => one_for_one, 
        intensity => 10,
        period => 60},
         

    ChildSpecifications = [
        #{
            id => comm,
            start => {comm, start_link, [u_sup]},
            restart => permanent,
            shutdown => 2000,
            type => worker,
            modules => [comm]
        },
        #{
            id => u_sup,
            start => {u_sup, start_link, []},
            restart => permanent, 
            shutdown => 2000,
            type => supervisor,
            modules => [u_sup]
        }
    ],

    {ok, {SupervisorSpecification, ChildSpecifications}}.
