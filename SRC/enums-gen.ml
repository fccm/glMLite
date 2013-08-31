(* {{{ COPYING *(

  This file belongs to glMLite, an OCaml binding to the OpenGL API.

  Copyright (C) 2006 - 2008  Florent Monnier, Some rights reserved
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

)* }}} *)
(*
#directory "+xml-light/"
#load "xml-light.cma"
#load "str.cma"
*)

let () =
  (* {{{ gl-version *)
  let gl_version =
    try Sys.argv.(1)
    with Invalid_argument "index out of bounds" ->
      failwith "Error: give the GL version as first argument, example: GL_VERSION_1_4\n"
  in
  (* }}} *)
  (* {{{ load xml file *)
  let enli =
    try Xml.children(Xml.parse_file Sys.argv.(2))
    with
    | Xml.Error(err_msg, err_pos) ->
        Printf.eprintf "Error at line %d: %s\n%!"
                       (Xml.line err_pos)
                       (Xml.error_msg err_msg);
        exit 1
    | Invalid_argument "index out of bounds" ->
        failwith(Printf.sprintf
          "Usage: %s <gl-version> 'enums.list.xml' # enum XML input file"
            Sys.argv.(0));
  in
  (* }}} *)
  (* {{{ print *)

  let print ~gl_type ~fmt_decl ~fmt_gl_type ~fmt_end =
    let dump name i = function
      | Xml.Element("enum", attrs, [Xml.PCData enum]) ->
          let this_version = List.assoc "version" attrs in
          if String.compare gl_version this_version < 0
          then (i)
          else begin
            fmt_gl_type i name enum;
            (succ i)
          end
      | _ ->
          failwith "Dump Error"
    in
    let each = function
      | Xml.Element("glenums", attrs, glenums) ->
          let name = List.assoc "name" attrs in
          if name = gl_type then begin
            fmt_decl name;
            let _ = List.fold_left (dump name) 0 glenums in
            fmt_end name;
          end;
      | _ -> ()
    in
    List.iter each enli;
  in
  (* }}} *)
  (* {{{ get gl_type *)

  let t() =
    try Sys.argv.(4)
    with
      Invalid_argument "index out of bounds" ->
        failwith "Error: give the enum gl-type to dump (example: color_material_mode)\n";
  in
  (* }}} *)
  (* {{{ select the output *)
  begin
    let put = Printf.printf in
    try
      match Sys.argv.(3) with
      | "-ml" ->
          print ~gl_type:(t())
                ~fmt_decl:(put "type %s =\n")
                ~fmt_gl_type:(fun i name h -> put "  | %s\n" h)
                ~fmt_end: (fun _ -> put "");
      | "-c" ->
          print ~gl_type:(t())
                ~fmt_decl:(put "  static const GLenum conv_%s_table[] = {\n")
                ~fmt_gl_type:(fun i name h -> put "    %s,\n" h)
                ~fmt_end: (fun name -> put "  };\n  %s = conv_%s_table[Int_val(_%s)];\n" name name name);
      | "-cr" ->
          print ~gl_type:(t())
                ~fmt_decl:(put "  switch (_%s)\n  {\n")
                ~fmt_gl_type:(fun i name h -> put "    case %s:\t%s = %2d;\tbreak;\n" h name i)
                ~fmt_end: (fun _ -> put "  }\n");
      | r ->
          Printf.printf "Wrong Request '%s', should be -c, -cr or -ml\n" r
    with
      Invalid_argument "index out of bounds" ->
        Printf.printf "Error: give the requested language: -c, -cr or -ml\n"
  end;
  (* }}} *)
;;

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
