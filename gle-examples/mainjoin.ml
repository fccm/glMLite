(* 
 * main for exhibiting differnt join styles
 *
 * FUNCTION:
 * This demo demonstrates the various join styles,
 * and how they get applied.
 *
 * HISTORY:
 * Linas Vepstas March 1995
 * Copyright (c) 1995 Linas Vepstas <linas@linas.org>
 * 2008 - OCaml version by F. Monnier
 *)

(* required modules *)
open GL
open Glut
open GLE

open Mainvar
open Inc_demo

(* get notified of mouse motions *)
let motion ~x ~y =
  lastx := x;
  lasty := y;
  glutPostRedisplay ();
;;

let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0
  | _ -> ()
;;


let remove_all v li =
  let rec aux acc = function
  | hd::tl when hd = v -> aux acc tl
  | hd::tl -> aux (hd::acc) tl
  | [] -> (List.rev acc)
  in
  aux [] li
;;

let remove_items_all style =
  List.fold_left (fun style this -> remove_all this style) style ;;

let tube_jn_all = [TUBE_JN_RAW; TUBE_JN_ANGLE; TUBE_JN_CUT; TUBE_JN_ROUND]
let tube_norm_all = [TUBE_NORM_FACET; TUBE_NORM_EDGE; TUBE_NORM_PATH_EDGE]


let join_style ~value =
  (* get the current joint style *)
  let style = gleGetJoinStyle () in

  (* there are four different join styles, 
     and two different normal vector styles *)
  let style = match value with
  | 0 ->
      let style = remove_items_all style tube_jn_all in
      (TUBE_JN_RAW :: style)

  | 1 ->
      let style = remove_items_all style tube_jn_all in
      (TUBE_JN_ANGLE :: style)

  | 2 ->
      let style = remove_items_all style tube_jn_all in
      (TUBE_JN_CUT :: style)

  | 3 ->
      let style = remove_items_all style tube_jn_all in
      (TUBE_JN_ROUND :: style)

  | 20 ->
      let style = remove_items_all style tube_norm_all in
      (TUBE_NORM_FACET :: style)

  | 21 ->
      let style = remove_items_all style tube_norm_all in
      (TUBE_NORM_EDGE :: style)

  | 99 ->
        exit (0);

  | _ -> (style)
  in
  gleSetJoinStyle style;
  glutPostRedisplay ();
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
  ignore(glutCreateWindow "join styles");
  glutDisplayFunc draw_stuff;
  glutMotionFunc motion;
  glutKeyboardFunc keyboard;

  (* create popup menu *)
  ignore(glutCreateMenu join_style);
  glutAddMenuEntry "Raw Join Style"  0;
  glutAddMenuEntry "Angle Join Style"  1;
  glutAddMenuEntry "Cut Join Style"  2;
  glutAddMenuEntry "Round Join Style"  3;
  glutAddMenuEntry "------------------"  9999;
  glutAddMenuEntry "Facet Normal Vectors"  20;
  glutAddMenuEntry "Edge Normal Vectors"  21;
  glutAddMenuEntry "------------------"  9999;
  glutAddMenuEntry "Exit"  99;
  glutAttachMenu GLUT_MIDDLE_BUTTON;

  (* initialize GL *)
  glClearDepth 1.0;
  glEnable GL_DEPTH_TEST;
  glClearColor 0.0 0.0 0.0 0.0;
  glShadeModel GL_SMOOTH;

  glMatrixMode GL_PROJECTION;
  (* roughly, measured in centimeters *)
  glFrustum (-9.0) 9.0 (-9.0) 9.0 50.0 150.0;
  glMatrixMode(GL_MODELVIEW);

  (* initialize lighting *)
  glLight (GL_LIGHT 0) (Light.GL_POSITION lightOnePosition);
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE lightOneColor);
  glEnable GL_LIGHT0;
  glLight (GL_LIGHT 1) (Light.GL_POSITION lightTwoPosition);
  glLight (GL_LIGHT 1) (Light.GL_DIFFUSE lightTwoColor);
  glEnable GL_LIGHT1;
  glEnable GL_LIGHTING;
  glEnable GL_NORMALIZE;
  glColorMaterial GL_FRONT_AND_BACK  GL_DIFFUSE;
  glEnable GL_COLOR_MATERIAL;

  init_stuff ();

  glutMainLoop ();
;;

(* ------------------ end of file -------------------- *)
