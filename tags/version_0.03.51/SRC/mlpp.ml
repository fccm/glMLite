(* {{{ COPYING *(

  +-----------------------------------------------------------------------+
  |  This is a minimal preprocessor for OCaml source files.               |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2008  Florent Monnier                                  |
  |  Contact:  <fmonnier@linux-nantes.org>                                |
  +-----------------------------------------------------------------------+
  |  This program is free software: you can redistribute it and/or        |
  |  modify it under the terms of the GNU General Public License          |
  |  as published by the Free Software Foundation, either version 3       |
  |  of the License, or (at your option) any later version.               |
  |                                                                       |
  |  This program is distributed in the hope that it will be useful,      |
  |  but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  |  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        |
  |  GNU General Public License for more details.                         |
  |                                                                       |
  |  You should have received a copy of the GNU General Public License    |
  |  along with this program.  If not, see <http://www.gnu.org/licenses/> |
  +-----------------------------------------------------------------------+

)* }}} *)
(*
   This is a minimal preprocessor similar to cpp for OCaml source files.
   It allows inclusions, definition of macros, and ifdef statments.
   These 3 functionalities are similar to cpp. This replacement for
   cpp is because cpp versions in different environments may have
   different behaviour with unexpected reactions which will break
   OCaml code.
*)
(* {{{ string utils *)

exception Invalid_string

let find str sub =
  let sublen = String.length sub in
  if sublen = 0 then
    0
  else
    let found = ref 0 in
    let len = String.length str in
    try
      for i = 0 to len - sublen do
        let j = ref 0 in
        while String.unsafe_get str (i + !j) =
              String.unsafe_get sub !j do
          incr j;
          if !j = sublen then
            begin found := i; raise Exit; end;
        done;
      done;
      raise Invalid_string
    with
      Exit -> !found
;;

let contains_string str sub =
  let sublen = String.length sub in
  if sublen = 0 then
    (false)
  else
    let found = ref 0 in
    let len = String.length str in
    try
      for i = 0 to len - sublen do
        let j = ref 0 in
        while String.unsafe_get str (i + !j) =
              String.unsafe_get sub !j do
          incr j;
          if !j = sublen then
            begin found := i; raise Exit; end;
        done;
      done;
      (false)
    with
      Exit -> (true)
;;

let strip ?(chars=" \t\r\n") s =
  let p = ref 0 in
  let l = String.length s in
  while !p < l && String.contains chars (String.unsafe_get s !p) do
    incr p;
  done;
  let p = !p in
  let l = ref (l - 1) in
  while !l >= p && String.contains chars (String.unsafe_get s !l) do
    decr l;
  done;
  String.sub s p (!l - p + 1)
;;

let slice ~first ~last str =
  String.sub str first (last - first)
;;

let clip_slice ?(first=0) ?(last=Sys.max_string_length) s =
  let clip _min _max x = max _min (min _max x)
  and len = String.length s in
  let i = clip 0 len
    (if (first<0) then len + first else first)
  and j = clip 0 len
    (if (last<0) then len + last else last)
  in
  if i>=j || i=len
  then String.create 0
  else String.sub s i (j-i)
;;

let replace ~str ~sub ~by =
  try
    let i = find str sub in
    (clip_slice ~last:i str) ^ by ^
    (clip_slice ~first:(i+(String.length sub)) str)
  with
    Invalid_string -> (str)
;;

let find_from str sub pos =
  let len = String.length str
  and sublen = String.length sub in
  if pos >= (len - sublen) then
    raise Not_found;
  if sublen = 0 then
    0
  else
    let found = ref 0 in
    try
      for i = pos to (len - sublen) do
        let j = ref 0 in
        while String.unsafe_get str (i + !j) =
              String.unsafe_get sub !j do
          incr j;
          if !j = sublen then begin
            found := i;
            raise Exit;
          end;
        done;
      done;
      raise Not_found
    with
      Exit -> !found
;;

let replace_all ~str ~sub ~by =
  let sublen = String.length sub in
  try
    if sublen = 0 then
      raise Invalid_string;
    let strlen = String.length str in
    let rec find_pos acc pos =
      try
        let i = find_from str sub pos in
        find_pos ((i + sublen)::i::acc) (i + sublen)
      with
        Not_found -> (strlen::acc)
    in
    let all_pos = (find_pos [0] 0) in
    if List.length all_pos = 2 then
      raise Invalid_string;
 
    let rec make_slices acc = function
      | [] -> acc
      | _::[] -> assert(false)
      | last::first::tl ->
          let this = slice ~first ~last str in
          make_slices (this::acc) tl
    in
    let slices = make_slices [] all_pos in
 
    let res = String.concat by slices in
    (res)
  with
    Invalid_string -> (str)
;;

(* }}} *)
(* {{{ read files utils *)

let file_content filename =
  let ic = open_in filename in
  let rec aux i acc =
    try
      let line = input_line ic in
      aux (succ i) ((i,line)::acc)
    with End_of_file ->
      close_in ic;
      (List.rev acc)
  in
  aux 1 []
;;

let rev_append_file filename acc =
  let ic = open_in filename in
  let rec aux i acc =
    try
      let line = input_line ic in
      aux (succ i) ((i,line)::acc)
    with End_of_file ->
      close_in ic;
      (acc)
  in
  aux 1 acc
;;

let string_of_file filename =
  let ic = open_in filename
  and buf = Buffer.create 4096 in
  let rec aux () =
    try
      let line = input_line ic in
      Buffer.add_string buf line;
      Buffer.add_char buf '\n';
      aux()
    with End_of_file ->
      close_in ic;
      (Buffer.contents buf)
  in
  aux()
;;

let cwd = Sys.getcwd()
let check_incfile_exists filename =
  let filename = Filename.concat cwd filename in
  if not(Sys.file_exists filename) then
    failwith(Printf.sprintf "include file '%s' doesn't exists" filename);
;;

(* }}} *)
(* {{{ pattern utils *)

let first_char line =
  let len = String.length line in
  let rec aux i =
    if i >= len then None else
    match line.[i] with
    | ' ' | '\t' -> aux (succ i)
    | c -> Some c
  in
  aux 0
;;

let match_key key =
  let reg = Printf.sprintf "[#]%s\\b" key in
  let pat = Str.regexp reg in
  function line ->
    try
      let _ = Str.search_forward pat line 0 in
      (true)
    with Not_found ->
      (false)
;;

let ifdef_key = match_key "ifdef" ;;
let define_key = match_key "define" ;;
let include_key = match_key "include" ;;

exception No_white
let white_search =
  let pat = Str.regexp "[ \t\n\r]" in
  function line ->
    try Str.search_forward pat line 0
    with Not_found -> raise No_white
;;

let not_white_search =
  let pat = Str.regexp "[^ \t\n\r]" in
  fun line from ->
    Str.search_forward pat line from
;;

let replacements repl line =
  if contains_string line "#ifdef" then
    (line)
  else
    List.fold_left (fun line (macro,def) ->
      replace_all line macro def
    ) line repl
;;

(* }}} *)
(* {{{ list utils *)

let list_rev2 (li1, li2) =
  (List.rev li1, List.rev li2)
;;

let rec tail_fold_left f acc =
  let rec aux acc = function
  | [] -> acc
  | v::tl ->
      let acc, tl = f acc v tl in
      aux acc tl
  in
  aux acc
;;

(* }}} *)

(* definition of a macro with the -D command line parameter *)
let macro_param str =
  try
    let pos = String.index str '=' in
    let len = String.length str in
    let macro = String.sub str 0 (pos)
    and mdef = String.sub str (pos+1) (len - pos - 1) in
    (macro, mdef)
  with Not_found ->
    (str, "")
;;

(* checks if a macro is bound in an #ifdef statment *)
let is_bound macro =
  List.exists (fun (m,_) -> m = macro)
;;

(* get the if and else pieces of code for an #ifdef statment *)
type parts = If | Else
let if_else_parts main_file tail =
  let rec parts if_acc else_acc part put_line = function
  | [] -> failwith "unterminated #if"
  | (i,line)::tail ->
      if not(first_char line = Some '#')
      then
        let _line = (i, Printf.sprintf "# %d \"%s\"" i main_file) in
        (match part, put_line with
         | If, false -> parts ((i,line)::if_acc) else_acc part false tail
         | Else, false -> parts if_acc ((i,line)::else_acc) part false tail
         | If, true -> parts ((i,line)::_line::if_acc) else_acc part false tail
         | Else, true -> parts if_acc ((i,line)::_line::else_acc) part false tail)
      else
      if contains_string line "#else"
      then
        (match part with
         | If -> parts if_acc else_acc Else true tail
         | Else -> failwith "double #else statement")
      else
      if contains_string line "#endif"
      then
        (tail, if_acc, else_acc)
      else
        failwith(Printf.sprintf "unrecognised command: '%s'" line)
  in
  parts [] [] If true tail
;;

(* prints the result *)
let print =
  List.iter (fun (i,line) -> print_string line; print_char '\n')
;;


(* main *)

let () =
  let argv = List.tl(Array.to_list Sys.argv) in
  let main_file =
    try List.find Sys.file_exists argv
    with Not_found ->
      failwith "no input file"
  in
  let repl =
    let rec aux acc = function
      | "-D" :: macro_def :: tl ->
          aux ((macro_param macro_def)::acc) tl
      | _ :: tl -> aux acc tl
      | [] -> acc
    in
    aux [] argv
  in

  let cont = file_content main_file in

  (* process the replacements defined with the keyword
     #define MY_MACRO macro_def
     (all have to be given on a single line)
  *)
  let cont, repl =
    list_rev2(
    List.fold_left
      (fun (acc, repl) (i,line) ->
        let line =
          replacements repl line
        in
        if not(first_char line = Some '#')
        then ((i,line)::acc), repl
        else
          if not(define_key line)
          then ((i,line)::acc), repl
          else begin
            let line = replace line "#define" "" in
            let line = strip line in
            let macro, def =
              try
                let pos = white_search line in
                let macro = String.sub line 0 pos in
                let pos2 = not_white_search line pos in
                let def = clip_slice ~first:pos2 line in
                let def = strip def in
                (macro, def)
              with No_white ->
                (strip line, "")
            in
            ((i,"")::acc), (macro,def)::repl
          end
      )
      ([],repl) cont)
  in

  (* process the includes defined with the keyword
     #include "my_incfile"
     (on one line)
  *)
  let cont =
    List.rev(fst(
    List.fold_left
      (fun (acc, do_rac) (i,line) ->
        let acc =
          if not(do_rac) then acc else
          let rac = Printf.sprintf "# %d \"%s\" 2" i main_file in
          (0,rac)::acc
        in
        if not(first_char line = Some '#')
        then ((i,line)::acc), false
        else
          if not(include_key line)
          then ((i,line)::acc), false
          else begin
            let line = replace line "#include" "" in
            let filename = strip line ~chars:" \t\"" in
            check_incfile_exists filename;
            let line = Printf.sprintf "# 1 \"%s\" 1" filename in
            (rev_append_file filename ((i,line)::acc)), true
          end
      )
      ([],false) cont))
  in

  (* process conditions of kind:
     #ifdef SOME_MACRO
     #else
     #endif
     (else and endif can be followed by (and only by) comment)
  *)
  let cont =
    List.rev(fst(
    tail_fold_left
      (fun (acc, do_rac) (i,line) tail ->
        let acc =
          if not(do_rac) then acc else
          let rac = Printf.sprintf "# %d \"%s\"" i main_file in
          (0,rac)::acc
        in
        if not(first_char line = Some '#')
        then ((i,line)::acc, false), tail
        else
          if not(ifdef_key line)
          then ((i,line)::acc, false), tail
          else begin
            let line = replace line "#ifdef" "" in
            let mdef = strip line in
 
            let tail, if_part, else_part = if_else_parts main_file tail in
 
            if is_bound mdef repl
            then (List.append if_part acc, true), tail
            else (List.append else_part acc, true), tail
          end
      )
      ([],false) cont))
  in

  print cont;
;;

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
