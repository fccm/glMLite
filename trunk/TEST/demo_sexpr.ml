(* Copyright (C) 2009 Florent Monnier
 * You can use this file under the terms of the MIT license:
 * http://en.wikipedia.org/wiki/MIT_License
 *)
open GL
open Glu
open Glut

let b_down = ref false
let anglex = ref (-46)
let angley = ref (-32)
let xold = ref 0
let yold = ref 0
let list_id = ref 0

(* {{{ load datas from file *)

open SExprLite

let map_colors = function
  | (Atom "colors")::lst ->
      let f = float_of_string in
      List.map (function 
          Expr [Atom r; Atom g; Atom b] -> (f r, f g, f b)
        | _ -> failwith "wrong data format"
      ) lst
  | _ -> failwith "wrong data format"
;;

let map_points = function
  | (Atom "points")::lst ->
      let f = float_of_string in
      List.map (function
          Expr [Atom x; Atom y; Atom z] -> (f x, f y, f z)
        | _ -> failwith "wrong data format"
      ) lst
  | _ -> failwith "wrong data format"
;;

let map_faces = function
  | (Atom "faces")::lst ->
      let i = int_of_string in
      List.map (function
          Expr [Atom a; Atom b; Atom c; Atom d] -> (i a, i b, i c, i d)
        | _ -> failwith "wrong data format"
      ) lst
  | _ -> failwith "wrong data format"
;;

let map_contents = function
  [Expr
    [Atom "obj";
     Expr colors;
     Expr points;
     Expr faces]] ->
       let c = map_colors colors
       and p = map_points points
       and f = map_faces faces in
       (Array.of_list c,
        Array.of_list p,
        Array.of_list f)
  | _ ->
      failwith "wrong data format"
;;


let compile_list ~filename =
  let colors, points, faces = map_contents(parse_file filename) in

  let put_point i =
    glColor3v  colors.(i);
    glVertex3v  points.(i);
  in

  glNewList !list_id GL_COMPILE;
    glBegin GL_QUADS;
      Array.iter (fun (a,b,c,d) ->
        put_point a;
        put_point b;
        put_point c;
        put_point d;
      ) faces;
    glEnd();
  glEndList();
;;

(* }}} *)
(* {{{ callback display *)

let display () =
  glClear ~mask:[GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  glLoadIdentity();
  glTranslate ~x:(0.5) ~y:(-0.5) ~z:(-12.0);

  glRotate ~angle:(float(- !angley)) ~x:1.0 ~y:0.0 ~z:0.0;
  glRotate ~angle:(float(- !anglex)) ~x:0.0 ~y:1.0 ~z:0.0;

  glScale ~x:(0.1) ~y:(0.1) ~z:(0.1);

  glCallList !list_id;

  glFlush();
  glutSwapBuffers();
;;
(* }}} *)
(* {{{ callback reshape *)

let reshape ~width ~height =
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 30. (float width /. float height) 2. 30.;
  glViewport 0 0 width height;
  glMatrixMode GL_MODELVIEW;
  glutPostRedisplay();
;;
(* }}} *)
(* {{{ callback keyboard *)

let keyboard ~key ~x ~y =
  match key with
  | 'e' -> Printf.printf " %d %d\n%!" !anglex !angley;
  | 'p' -> glPolygonMode GL_FRONT_AND_BACK  GL_FILL;  glutPostRedisplay();
  | 'f' -> glPolygonMode GL_FRONT_AND_BACK  GL_LINE;  glutPostRedisplay();
  | 's' -> glPolygonMode GL_FRONT_AND_BACK  GL_POINT; glutPostRedisplay();
  | 'd' -> glEnable GL_DEPTH_TEST; glutPostRedisplay();
  | 'D' -> glDisable GL_DEPTH_TEST; glutPostRedisplay();
  | 'm' -> 
        (*
        let m = glGetMatrix Get.GL_PROJECTION_MATRIX in
        glLoadIdentity();
        *)
        let m = glGetMatrix Get.GL_MODELVIEW_MATRIX in
        Printf.printf
          " %f  %f  %f  %f\n \
            %f  %f  %f  %f\n \
            %f  %f  %f  %f\n \
            %f  %f  %f  %f\n%!" 
            m.(0).(0)  m.(0).(1)  m.(0).(2)  m.(0).(3)
            m.(1).(0)  m.(1).(1)  m.(1).(2)  m.(1).(3)
            m.(2).(0)  m.(2).(1)  m.(2).(2)  m.(2).(3)
            m.(3).(0)  m.(3).(1)  m.(3).(2)  m.(3).(3);
      (*
      let mats = [
        Get.GL_COLOR_MATRIX;
        Get.GL_MODELVIEW_MATRIX;
        Get.GL_PROJECTION_MATRIX;
        Get.GL_TEXTURE_MATRIX ] in
      List.iter (fun _m ->
        let m = glGetMatrix _m in
        Printf.printf
          " %f  %f  %f  %f\n \
            %f  %f  %f  %f\n \
            %f  %f  %f  %f\n \
            %f  %f  %f  %f\n%!" 
            m.(0).(0)  m.(0).(1)  m.(0).(2)  m.(0).(3)
            m.(1).(0)  m.(1).(1)  m.(1).(2)  m.(1).(3)
            m.(2).(0)  m.(2).(1)  m.(2).(2)  m.(2).(3)
            m.(3).(0)  m.(3).(1)  m.(3).(2)  m.(3).(3);
        ) mats;
      *)
  | '\027'
  | 'q' -> exit(0)
  | _ -> ()
;;
(* }}} *)
(* {{{ callback mouse *)

let mouse ~button ~state ~x ~y =
  match button, state with
  (* if we press the left button *)
  | GLUT_LEFT_BUTTON, GLUT_DOWN ->
      b_down := true;
      xold := x;  (* save mouse position *)
      yold := y;
  (* if we release the left button *)
  | GLUT_LEFT_BUTTON, GLUT_UP ->
      b_down := false;
  | _ -> ()
;;
(* }}} *)
(* {{{ callback motion *)

let motion ~x ~y =
  if !b_down then  (* if the left button is down *)
  begin
 (* change the rotation angles according to the last position
    of the mouse and the new one *)
    anglex := !anglex + (!xold - x);
    angley := !angley + (!yold - y);
    glutPostRedisplay();
  end;
  
  xold := x;
  yold := y;
;;
(* }}} *)
(* {{{ main init of GL & Glut *)

let () =
  ignore(glutInit Sys.argv);

  glutInitDisplayMode[GLUT_RGBA; GLUT_DOUBLE; GLUT_DEPTH];
  glutInitWindowPosition ~x:200 ~y:200;
  glutInitWindowSize ~width:640 ~height:480;

  ignore(glutCreateWindow ~title:"demo");

  (* init openGL *)
  glEnable GL_DEPTH_TEST;

  glPointSize ~size:2.0;
  glClearColor ~r:0.2 ~g:0.3 ~b:0.5 ~a:0.0;

  list_id := glGenLists 1;
  compile_list ~filename:"sixa.se";

  (* callback functions *)
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMouseFunc ~mouse;
  glutMotionFunc ~motion;

  (* enter the main loop *)
  glutMainLoop();
;;
(* }}} *)

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
