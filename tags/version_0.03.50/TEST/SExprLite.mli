(** This module is a very simple parsing library for S-expressions. *)
(*
   Copyright (C) 2009  Florent Monnier
   Contact:  <fmonnier@linux-nantes.org>

   This program is free software: you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>
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

