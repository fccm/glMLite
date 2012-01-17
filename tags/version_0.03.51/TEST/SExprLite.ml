(*
  This file is a very simple parsing library for S-expressions.

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

