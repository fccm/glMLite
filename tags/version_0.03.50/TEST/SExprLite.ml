(*
   This file is a very simple parsing library for S-expressions.

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

type state =
  | Parse_root of sexpr list
  | Parse_content of sexpr list
  | Parse_word of string * sexpr list

let mkstr c = String.make 1 c ;;

let parse pop_char =
  let rec aux st =
    match pop_char() with
    | None ->
        begin match st with
        | Parse_root sl -> (List.rev sl)
        | Parse_content _
        | Parse_word _ ->
            failwith "Parsing error: content not closed by parenthesis"
        end
    | Some c ->
        match c with
        | '(' ->
            begin match st with
            | Parse_root sl ->
                let this = aux(Parse_content []) in
                aux(Parse_root((Expr this)::sl))
            | Parse_content sl ->
                let this = aux(Parse_content []) in
                aux(Parse_content((Expr this)::sl))
            | Parse_word(w, sl) ->
                let this = aux(Parse_content []) in
                aux(Parse_content((Expr this)::(Atom w)::sl))
            end
        | ')' ->
            begin match st with
            | Parse_root sl ->
                failwith "Parsing error: closing parenthesis without openning"
            | Parse_content sl -> (List.rev sl)
            | Parse_word(w, sl) -> List.rev((Atom w)::sl)
            end
        | 'a'..'z' | 'A'..'Z'
        | '0'..'9' | '-' | '_' | '.' ->
            begin match st with
            | Parse_root _ ->
                failwith(Printf.sprintf "Parsing error: char '%c' at root level" c)
            | Parse_content sl -> aux(Parse_word((mkstr c), sl))
            | Parse_word(w, sl) -> aux(Parse_word(w ^ (mkstr c), sl))
            end
        | ' ' | '\n' | '\r' | '\t' ->
            begin match st with
            | Parse_root sl -> aux(Parse_root sl)
            | Parse_content sl -> aux(Parse_content sl)
            | Parse_word(w, sl) -> aux(Parse_content((Atom w)::sl))
            end
        | _ ->
            failwith(Printf.sprintf "char '%c' not handled" c)
  in
  aux (Parse_root [])
;;

let string_pop_char str =
  let len = String.length str in
  let i = ref(-1) in
  (function () -> incr i; if !i >= len then None else Some(str.[!i]))
;;

let parse_string str =
  parse (string_pop_char str)
;;

let ic_pop_char ic =
  (function () ->
     try Some(input_char ic)
     with End_of_file -> (None))
;;

let parse_ic ic =
  parse (ic_pop_char ic)
;;

let parse_file filename =
  let ic = open_in filename in
  let res = parse_ic ic in
  close_in ic;
  (res)
;;

let print_sexpr s =
  let rec aux acc = function
  | (Atom tag)::tl -> aux (tag::acc) tl
  | (Expr e)::tl ->
      let s =
        "(" ^
        (String.concat " " (aux [] e))
        ^ ")"
      in
      aux (s::acc) tl
  | [] -> (List.rev acc)
  in
  print_endline(
    String.concat " " (aux [] s));
;;

