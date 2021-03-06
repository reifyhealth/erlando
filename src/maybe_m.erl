%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License
%% at http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and
%% limitations under the License.
%%
%% The Original Code is Erlando.
%%
%% The Initial Developer of the Original Code is VMware, Inc.
%% Copyright (c) 2011-2011 VMware, Inc.  All rights reserved.
%%

-module(maybe_m).
-author('Joseph Abrahamson <me@jspha.com>').

-export_type([t/1]).
-export([just/1, nothing/0]).
-export([okjust/1, justok/1]).
-export([default/2]).

-behaviour(monad).
-export(['>>='/2, return/1, fail/1]).

-behaviour(monad_plus).
-export([mzero/0, mplus/2]).


-type(t(A) :: {'just', A} | nothing).
%% The quintessential Maybe (maybe_m:t) type. It can be deconstructed
%% manually in a pattern matching bind, but also other functions
%% exposed here will help to manipulate it.

-type(monad(A) :: t(A)).
-include("monad_specs.hrl").
-include("monad_plus_specs.hrl").


%% @doc Wraps an object into a Maybe type.
just(X) -> {just, X}.

%% @doc Wraps a "failure" into a Maybe type.
nothing() -> nothing.


%% Constructors

-spec
%% @doc Interprets an `{ok, X}' as `{just, X}' and everything else as
%% `nothing'.
okjust({ok, T}) -> t(T)
 ;    (_) -> t(_).
okjust({ok, X}) -> just(X);
okjust({ok, X, _Info}) -> just(X);
okjust(_Else) -> nothing().

justok({just, X}) -> {ok, X};
justok(nothing) -> {error, nothing}.

%% Handlers

-spec
%% @doc Returns a default value if Nothing.
default(Maybe :: t(T), Default :: T) -> T.
default({just, X}, _) -> X;
default(nothing, X) -> X.

%% Monad interface

'>>='({just, X}, F) -> F(X);
'>>='(nothing, _F) -> nothing.

return(X) -> just(X).
fail(_X)  -> nothing().

mzero() -> nothing.
mplus(nothing, Y) -> Y;
mplus(X,      _Y) -> X.
