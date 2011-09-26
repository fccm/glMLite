(*
  This file belongs to glMLite, an OCaml binding to the OpenGL API.

  Copyright (C) 2008  Florent Monnier, Some rights reserved
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

let deprecated = ref []

let xml_input i =
  if Xmlm.eoi i
  then raise End_of_file
  else Xmlm.input i

let tail = List.tl ;;

let error fmt =
  Printf.kprintf (fun s -> prerr_endline s; exit 1) fmt ;;

type tag = string * (string * string) list
type tree = E of Xmlm.tag * tree list | D of string

let in_tree i =
  let el tag childs = E (tag, childs) in
  let data d = D d in
  (Xmlm.input_tree ~el ~data i)

let enum_version attrs =
  (function (_, version) -> version)
    (List.find
      (function ((_,"version"), _) -> true | _ -> false)
      attrs)

let glenum_name attrs =
  (function ((_, _), glenum_name) -> glenum_name)
    (List.find
      (function ((_, "name"), _) -> true | _ -> false)
      attrs)

(* generic printer for debuging purpose *)
let rec print_rec = function
  | E(((_,name), attrs), childs) ->
      Printf.eprintf "attr(%s)\n" name;
      List.iter (fun ((_,n),v) -> Printf.eprintf " | (%s,%s)\n" n v) attrs;
      List.iter print_rec childs;

  | D str -> Printf.eprintf "data(%s)\n" str;
;;

(* print the caml varient *)

let enum_val_ml req_version = function
  | E(((_,"enum"), attrs), [(D glenum)])
    when (enum_version attrs) <= req_version ->
      if List.mem glenum !deprecated
      then Printf.printf "  | %s  (** deprecated in core OpenGL 3. *)\n" glenum
      else Printf.printf "  | %s\n" glenum;

  | E(((_,"enum"), _), _) -> ()
  | x -> print_rec x

let dump_ml glenum_req req_version = function
  | E(((_,"glenums"), attrs), childs) ->
      Printf.printf "type %s =\n" glenum_req;
      List.iter (enum_val_ml req_version) childs;

  | x -> print_rec x


(* print the C code to transform the ocaml glenum *)

let enum_val_c req_version = function
  | E(((_,"enum"), attrs), [(D glenum)])
    when (enum_version attrs) <= req_version ->
      Printf.printf "    %s,\n" glenum;

  | E(((_,"enum"), _), _) -> ()
  | x -> print_rec x

let dump_ml_to_c glenum_req req_version = function
  | E(((_,"glenums"), attrs), childs) ->

      Printf.printf
        "  static const GLenum conv_%s_table[] = {\n" glenum_req;
      List.iter (enum_val_c req_version) childs;
      Printf.printf
        "  };\n\
        \  %s = conv_%s_table[Int_val(_%s)];\n"
        glenum_req glenum_req glenum_req;

      Printf.printf
        "#if defined(USE_MY_GL3_CORE_PROFILE)\n\
        \  if (%s == 0x000A)\n\
        \    caml_failwith(\"using gl-enum deprecated in core OpenGL 3\");\n\
        #endif\n"
        glenum_req;

  | x -> print_rec x


(* return back a glenum from C to ocaml *)

let enum_val_c2ml i glenum_req req_version = function
  | E(((_,"enum"), attrs), [(D glenum)])
    when (enum_version attrs) <= req_version ->
      (*
      Printf.printf
        "    case %s:\t %s = %2d;\t break;\n" glenum glenum_req i;
      *)
      Printf.printf
        "    if (_%s == %s)\t %s = %2d;\n"  glenum_req glenum glenum_req i;

  | E(((_,"enum"), _), _) -> ()
  | x -> print_rec x

let dump_c_to_ml glenum_req req_version = function
  | E(((_,"glenums"), attrs), childs) ->
      (*
      Printf.printf "  switch (_%s)\n  {\n" glenum_req;
      *)
      Printf.printf "  {\n";
      ignore(
        List.fold_left (fun i v -> enum_val_c2ml i glenum_req req_version v; succ i) 0 childs
      );
      Printf.printf "  }\n";

  | x -> print_rec x


type output_kind =
  | Output_ml
  | Output_ml_to_c
  | Output_c_to_ml

let dump = function
  | Output_ml -> dump_ml
  | Output_ml_to_c -> dump_ml_to_c
  | Output_c_to_ml -> dump_c_to_ml
;;

let () =
  let gl_version =
    try Sys.argv.(1)
    with
      Invalid_argument "index out of bounds" ->
        error "Error: give the GL version as first argument, \
               example: GL_VERSION_1_4"
  in

  let input_file =
    try Sys.argv.(2)
    with
      Invalid_argument "index out of bounds" ->
        error "Usage: %s <gl-version> 'enums.list.xml'" Sys.argv.(0)
  in

  let output_kind =
    try
      match Sys.argv.(3) with
      | "-ml" -> Output_ml
      | "-c"  -> Output_ml_to_c
      | "-cr" -> Output_c_to_ml
      | r -> error "Wrong Request '%s', should be -c, -cr or -ml" r
    with
      Invalid_argument "index out of bounds" ->
        error "Error: give the requested language: -c, -cr or -ml"
  in

  let glenum_req =
    try Sys.argv.(4)
    with
      Invalid_argument "index out of bounds" ->
        error "Error: give the gl enum name to dump (example: color_material_mode)"
  in

  let ic = open_in input_file in
  let i = Xmlm.make_input ~strip:true (`Channel ic) in


  let grep req_version = function
    | E(((_,"enum"), attrs), [(D glenum)])
      (* TODO
      when (enum_version attrs) <= req_version *)
      -> Some glenum
    | E(((_,"enum"), _), _) -> None
    | x -> (* print_rec x; *) None
  in
  let depr req_version = function
    | E(((_,"deprecations"), attrs), childs) ->

        let acc =
          List.fold_left
            (fun acc this ->
               match grep req_version this with
               | Some e -> e::acc
               | None -> acc
            ) [] childs
        in
        deprecated := acc

    | x -> () (* XXX *)
  in

  let rec get_depr i d =
    match Xmlm.input i with
    | `El_start ((_, "enum"), _) ->
        get_depr i (succ d)
    | `Data s ->
        deprecated := s :: !deprecated;
        get_depr i d
    | `El_end ->
        if d > 0 then
          get_depr i (pred d)
    | _ -> assert false
  in

  let rec main parents i =
    match Xmlm.peek i with
    | `Dtd _ -> ignore(Xmlm.input i); main parents i
    | `Data _ -> ignore(Xmlm.input i); main parents i
    (* *)
    | `El_start (("", "__deprecations"), attrs) ->
        depr gl_version (in_tree i)
    (* *)
    | `El_start (("", "deprecations"), attrs) ->
        ignore(Xmlm.input i);
        get_depr i 0;
        main (parents) i
    | `El_start (("", "glenums"), attrs)
      when (glenum_name attrs) = glenum_req ->
        dump output_kind glenum_req gl_version (in_tree i)
    | `El_start ((_, tag_name), _) ->
        ignore(Xmlm.input i);
        main (tag_name::parents) i
    | `El_end ->
        ignore(Xmlm.input i);
        main (tail parents) i
  in
  main [] i

