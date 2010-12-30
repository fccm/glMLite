(*
ocamlopt.opt  -o time.opt  -ccopt -L../SRC -I ../SRC GL.cmxa Glu.cmxa Glut.cmxa timer.ml
*)

open GL
open Glu
open Glut

let t = ref 0.0
let col = ref 1

let display_color = function
  | 1 -> glColor3 ~r:1.0 ~g:0.0 ~b:0.0;
  | 2 -> glColor3 ~r:0.0 ~g:1.0 ~b:0.0;
  | 3 -> glColor3 ~r:0.0 ~g:0.0 ~b:1.0;
  | 4 -> glColor3 ~r:1.0 ~g:0.0 ~b:1.0;
  | 5 -> glColor3 ~r:1.0 ~g:1.0 ~b:0.0;
  | _ -> ()
;;

let display () =
  glClear ~mask:[GL_COLOR_BUFFER_BIT];
  glLoadIdentity();
  glRotate ~angle:(!t) ~x:0. ~y:0. ~z:1.;
  display_color !col;
  glBegin ~primitive:GL_TRIANGLES;
  glVertex2 ~x:(-1.) ~y:(-1.);
  glVertex2 ~x:( 0.) ~y:( 1.);
  glVertex2 ~x:( 1.) ~y:(-1.);
  glEnd();
  glutSwapBuffers();
;;

let rec timer ~value =
  t := !t +. 1.0;
  glutPostRedisplay();
  glutTimerFunc ~msecs:40 ~timer ~value:();
;;

let rec switch_color ~value =
  begin match !col with
  | 1 -> col := 2;
  | 2 -> col := 3;
  | 3 -> col := 4;
  | 4 -> col := 5;
  | 5 -> col := 1;
  | _ -> ()
  end;
  glutTimerFunc ~msecs:1200 ~timer:switch_color ~value:();
;;

let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode[GLUT_DOUBLE;];
  glutInitWindowSize ~width:200 ~height:200;
  ignore(glutCreateWindow ~title:"OpenGL Timer Demo");
  glMatrixMode ~mode:GL_MODELVIEW;
  glutDisplayFunc ~display;
  glutIdleFunc ~idle:(glutPostRedisplay);
  glutTimerFunc ~msecs:40 ~timer ~value:();
  glutTimerFunc ~msecs:1200 ~timer:switch_color ~value:();
  glutKeyboardFunc (fun ~key ~x ~y -> if key = '\027' then exit 0);
  glutMainLoop();
;;

