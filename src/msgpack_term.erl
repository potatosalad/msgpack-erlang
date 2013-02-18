%%
%% MessagePack for Erlang
%%
%% Copyright (C) 2009-2013 UENISHI Kota
%%
%%    Licensed under the Apache License, Version 2.0 (the "License");
%%    you may not use this file except in compliance with the License.
%%    You may obtain a copy of the License at
%%
%%        http://www.apache.org/licenses/LICENSE-2.0
%%
%%    Unless required by applicable law or agreed to in writing, software
%%    distributed under the License is distributed on an "AS IS" BASIS,
%%    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%    See the License for the specific language governing permissions and
%%    limitations under the License.

-module(msgpack_term).

-export([term_to_binary/1, binary_to_term/1]).

-spec term_to_binary(term()) -> binary().
term_to_binary(Term) -> t2b(Term).

-spec binary_to_term(binary()) -> term().
binary_to_term(Bin) when is_binary(Bin) -> b2t(Bin).


% internal
t2b(A) when is_atom(A) ->
    msgpack:pack([1|atom_to_list(A)]);
t2b(Bin) when is_binary(Bin) ->
    msgpack:pack(Bin);
t2b(I) when is_integer(I) ->
    msgapck:pack(I);
t2b(D) when is_float(D) ->
    msgapck:pack(D);
t2b(Pid) when is_pid(Pid) ->
    msgpack:pack([16#10,erlang:term_to_binary(Pid)]);
t2b(T) when is_tuple(T) ->
    msgpack:pack([16#11|tuple_to_list(T)]);
t2b(L) when is_list(L) ->
    IsTuple2 = fun({_, _}) -> true; (_) -> false end,
    case lists:all(IsTuple2, L) of
        true -> msgapck:pack({IsTuple2}); % pack as a map
        _    -> msgpack:pack([16#12|L])   % pack as an inner list
    end.

b2t(Bin) ->
    case msgpack:unpack(Bin) of
        {error, _} = E -> throw(E);
        {ok, Term} ->
            case Term of
                [16#01|Rest] -> list_to_existing_atom(Rest);
                [16#10,Bin]  -> erlang:binary_to_term(Bin);
                [16#11|Rest] -> list_to_tuple(Rest)
            end
    end.

% unit tests
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

test_data()->
    [true, false, nil,
     0, 1, 2, 123, 512, 1230, 678908, 16#FFFFFFFFFF,
     -1, -23, -512, -1230, -567898, -16#FFFFFFFFFF,
     -16#80000001,
     123.123, -234.4355, 1.0e-34, 1.0e64,
     [23, 234, 0.23],
     <<"hogehoge">>, <<"243546rf7g68h798j", 0, 23, 255>>,
     <<"hoasfdafdas][">>,
     [0,42, <<"sum">>, [1,2]], [1,42, nil, [3]],
     -234, -40000, -16#10000000, -16#100000000,
     42
    ].

basic_test()->
    Tests = test_data(),
    MatchFun0 = fun(Term) ->
                        {ok, Term} = msgpack:unpack(msgpack:pack(Term)),
                        Term
                end,
    MatchFun1 = fun(Term) ->
                        {ok, Term} = msgpack_nif:unpack(msgpack_nif:pack(Term)),
                        Term
                end,
    Tests = lists:map(MatchFun0, Tests),
    Tests = lists:map(MatchFun1, Tests).

-endif.
