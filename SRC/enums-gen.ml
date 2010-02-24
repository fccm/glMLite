(* {{{ COPYING *(

  +-----------------------------------------------------------------------+
  |  This file belongs to glMLite, an OCaml binding to the OpenGL API.    |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2006, 2007, 2008  Florent Monnier                      |
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
