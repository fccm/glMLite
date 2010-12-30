(* 
 * FUNCTION:
 * very minimal "main" for GL demos.
 *
 * HISTORY:
 * Linas Vepstas March 1995
 * Copyright (c) 1995 Linas Vepstas <linas@linas.org>
 * 2008 - OCaml version by F. Monnier
 *)

(* required include files *)
open GL
open Glut

open Mainvar
open Cylinder

(* get notified of mouse motions *)
let motion ~x ~y =
  lastx := x;
  lasty := y;
  glutPostRedisplay ();
;;

let join_style ~value =
  exit(0);
;;

let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0
  | _ -> ()
;;

(* set up a light *)
let lightOnePosition = (40.0, 40.0, 100.0, 0.0)
let lightOneColor = (0.99, 0.99, 0.99, 1.0)

let lightTwoPosition = (-40.0, 40.0, 100.0, 0.0)
let lightTwoColor = (0.99, 0.99, 0.99, 1.0)

(* main *)
let () =
  (* initialize glut *)
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_DOUBLE; GLUT_RGB; GLUT_DEPTH];
  ignore(glutCreateWindow "basic demo");
  glutDisplayFunc ~display:draw_stuff;
  glutMotionFunc ~motion;
  glutKeyboardFunc ~keyboard;

  (* create popup menu *)
  ignore(glutCreateMenu join_style);
  glutAddMenuEntry "Exit" 99;
  glutAttachMenu GLUT_MIDDLE_BUTTON;

  (* initialize GL *)
  glClearDepth 1.0;
  glEnable GL_DEPTH_TEST;
  glClearColor 0.0 0.0 0.0 0.0;
  glShadeModel GL_SMOOTH;

  glMatrixMode GL_PROJECTION;
  (* roughly, measured in centimeters *)
  glFrustum (-9.0) (9.0) (-9.0) (9.0) (50.0) (150.0);
  glMatrixMode GL_MODELVIEW;

  (* initialize lighting *)
  glLight (GL_LIGHT 0) (Light.GL_POSITION lightOnePosition);
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE lightOneColor);
  glEnable GL_LIGHT0;
  glLight (GL_LIGHT 1) (Light.GL_POSITION lightTwoPosition);
  glLight (GL_LIGHT 1) (Light.GL_DIFFUSE lightTwoColor);
  glEnable GL_LIGHT1;
  glEnable GL_LIGHTING;
  glColorMaterial GL_FRONT_AND_BACK  GL_DIFFUSE;
  glEnable GL_COLOR_MATERIAL;

  init_stuff ();

  glutMainLoop ();
;;

