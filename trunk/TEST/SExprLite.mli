(** This module is a very simple parsing library for S-expressions. *)
(*
  Copyright (C) 2009  Florent Monnier, Some rights reserved
  Contact:  <fmonnier@linux-nantes.org>

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.
*)

type sexpr = Atom of string | Expr of sexpr list
(** the type of S-expressions *)

val parse_string : string -> sexpr list
(** parse from a string *)

val parse_ic : in_channel -> sexpr list
(** parse from an input channel *)

val parse_file : string -> sexpr list
(** parse from a file *)

val parse : (unit -> char option) -> sexpr list
(** parse from a custom function, [None] indicates the end of the flux *)

val print_sexpr : sexpr list -> unit
(** a dump function for the type [sexpr] *)

