#directory "../SRC/"
#load "GL.cma"
#load "Glut.cma"
open GL
open Glut

#load "str.cma"

let () =
  ignore(glutInit Sys.argv);
  glutInitWindowSize ~width:640 ~height:480;
  ignore(glutCreateWindow ~title:"test extensions");

  if (glutExtensionSupported "GL_ARB_texture_non_power_of_two")
  then ()
  else ();

  let ext = (glGetString GL_EXTENSIONS) in
  let sp = Str.split (Str.regexp " ") ext in
  List.iter (print_endline) sp;
;;

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
