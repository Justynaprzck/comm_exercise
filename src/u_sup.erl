-module(u_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, u_sup).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([]) ->
    SupFlags = #{strategy => simple_one_for_one},
    ChildSpecs = #{id => user,
	  start => {users, start_link, []},
      restart => permanent,
      shutdown => 2000,
      type => worker,
      modules => [users]
    },

    {ok, {SupFlags, [ChildSpecs]}}.