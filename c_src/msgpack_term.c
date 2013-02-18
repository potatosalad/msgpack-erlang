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

#include "msgpack_nif.h"

/*
  compatible API with term_to_binary / binary_to_term for msgpack_nif!!!
  
  it requires another spec defined on top of basic msgpack serialization
  
  Term := atom | binary | number
        | pid | tuple | list
  atom  := [0x01, ...] | [0x00](nil) | [0x02](ok) | [0x03](error) ... reserved for atoms
  pid   := [0x10, ...]
  tuple := [0x11, ...]
  list  := [0x12, ...]

  msgpack_map -> proplists
  proplists -> msgpack_map

  enif_is_atom()       => o
  enif_is_binary()     => o
  enif_is_empty_list() => o
  enif_is_exception()  => -
  enif_is_number()     => o
  enif_is_fun()        => -
  enif_is_identical()  => -
  enif_is_pid()        => o
  enif_is_port()       => -
  enif_is_ref()        => -
  enif_is_tuple()      => o
  enif_is_list()       => o

 */
