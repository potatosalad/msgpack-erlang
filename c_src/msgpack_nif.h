#ifndef MSGPACK_NIF
#define MSGPACK_NIF

/**
 * MessagePack for Erlang
 *
 * Copyright (C) 2013 UENISHI Kota
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 **/

#include "erl_nif.h"
#include "msgpack.h"

ERL_NIF_TERM msgpack_object2erlang_term(ErlNifEnv*,
                                        const msgpack_object*);

bool msgpack_pack_erl_nif_term(msgpack_packer*,
                               ErlNifEnv*,
                               ERL_NIF_TERM);

ERL_NIF_TERM msgpack_error_reason(ErlNifEnv* env,
                                  ERL_NIF_TERM reason);

ERL_NIF_TERM msgpack_error_tuple(ErlNifEnv* env, const char* atom);

ERL_NIF_TERM msgpack_make_badarg(ErlNifEnv* env,
                                 ERL_NIF_TERM badarg);

ERL_NIF_TERM msgpack_nif_empty_binary(ErlNifEnv* env);

ERL_NIF_TERM msgpack_nif_binary(ErlNifEnv* env, size_t s,
                                const char* bin);

#endif
