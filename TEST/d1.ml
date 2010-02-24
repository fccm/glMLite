(* Copyright (C) 2009 Florent Monnier
 * You can use this file under the terms of the MIT license:
 * http://en.wikipedia.org/wiki/MIT_License
 *)
open GL
open Glu
open Glut

let anglex = ref 0.
let angley = ref 0.

(* {{{ display_z_sorted_cubes *)

let assoc_color =
  let tbl = Hashtbl.create 30 in
  let get = Hashtbl.find tbl in
  fun i j k ->
  let ndx = (i, j, k) in
  try get ndx
  with Not_found ->
    let r,g,b =
      match Random.int 4 with
      | 0 -> (1.0, 0.0, 0.0)
      | 1 -> (0.1, 0.8, 0.0)
      | 2 -> (0.1, 0.4, 1.0)
      | 3 -> (0.7, 0.0, 0.6)
      | _ -> raise Exit
    in
    Hashtbl.add tbl ndx (r,g,b);
    (r,g,b)
;;


let mat_get_z = function
    [| [| _; _; _; _ |];
       [| _; _; _; _ |];
       [| _; _; _; _ |];
       [| _; _; z; _ |]; |] ->
         z
  | _ ->
      invalid_arg "matrix"
;;

let mat_get_y = function
    [| [| _; _; _; _ |];
       [| _; _; _; _ |];
       [| _; _; _; _ |];
       [| _; y; _; _ |]; |] -> y
  | _ ->
      invalid_arg "matrix"
;;

let assoc_vis, step_vis =
  let tbl = Hashtbl.create 30 in
  let get = Hashtbl.find tbl in
  (fun i j k ->
     let ndx = (i, j, k) in
     try get ndx
     with Not_found ->
       let vis = Random.bool() in
       Hashtbl.add tbl ndx (vis);
       (vis)),
  (fun i j k ->
     if (Random.int 30000) < 10 then
       let ndx = (i, j, k)
       and vis = Random.bool() in
       Hashtbl.replace tbl ndx vis)
;;

let gradient_switch = ref true
let gradient_toggle () =
  if (Random.int 30_000_000) < 100_000 then
    gradient_switch := not(!gradient_switch);
;;

let display_z_sorted_cubes n () =
  if !gradient_switch
  then glClearColor 0.3 0.25 0.2  0.0
  else glClearColor 0.4 0.2 0.0  0.0;

  glClear [GL_COLOR_BUFFER_BIT];
  glLoadIdentity();

  glTranslate 0. 0. (-. 4.0);

  glRotate (!angley) 1.0 0.0 0.0;
  glRotate (!anglex) 0.0 1.0 0.0;

  glScale 0.5 0.5 0.5;

  let prop = ref [] in

  let step = 0.8 in
  let half = step *. (float(pred n)) /. 2.0 in

  for i=0 to pred n do
    for j=0 to pred n do
      for k=0 to pred n do
        let r,g,b = assoc_color i j k
        and vis = assoc_vis i j k
        and x = ((float i)*. step) -. half
        and y = ((float j)*. step) -. half
        and z = ((float k)*. step) -. half in

        step_vis i j k;

        prop := (x,y,z, r,g,b, vis) :: !prop;
      done;
    done;
  done;

  let item_get_mat (x,y,z, r,g,b, vis) =
    glPushMatrix();
      glTranslate x y z;
      let m = glGetMatrix Get.GL_MODELVIEW_MATRIX in
    glPopMatrix();
    (m, r,g,b, vis)
  in
  let items_prop = List.map (item_get_mat) !prop in

  (* sort the items along the Z axis *)
  let z_sort_vert (m1,_,_,_,_) (m2,_,_,_,_) =
    let z1 = mat_get_z m1
    and z2 = mat_get_z m2 in
    if z1 < z2 then -1 else 1
  in
  let sorted_items = List.sort z_sort_vert items_prop in

  let gradient (m, r,g,b, vis) =
    let y = mat_get_y m in
    let r = sqrt(half ** 2. *. 3.) *. 0.5 in
    let v = y +. r in
    let v = v /. r /. 2. in
    let v = v *. 1.4 in
    let r = v
    and b = 1.0 -. v
    and g = 0.0 in
    (m, r,g,b, vis)
  in
  let sorted_items =
    if !gradient_switch
    then List.map (gradient) sorted_items
    else sorted_items
  in
  gradient_toggle();

  let draw_item (m, r,g,b, vis) =
    if vis then
    begin
      glLoadIdentity();
      glMultMatrix m;

      glScale 0.5 0.5 0.5;
      glColor3 0.0 0.0 0.0;
      glutSolidCube 1.0;

      glColor3 r g b;
      glutSolidCube 0.89;
      glColor3 1.0 1.0 1.0;
      glutWireCube 0.89;
    end
  in
  List.iter (draw_item) sorted_items;

  glutSwapBuffers();
;;
(* }}} *)
(* {{{ timers *)

let sleep_ticks = 16 ;;

let rec rot_timer ~value =
  angley := !angley +. 0.2;
  anglex := !anglex +. 0.02;
  glutTimerFunc ~msecs:sleep_ticks ~timer:rot_timer ~value:0;
  glutPostRedisplay();
;;

let display = display_z_sorted_cubes 6 ;;

(* }}} *)
(* {{{ reshape *)

let field = 10. ;;

let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
;;

(* }}} *)
(* {{{ main *)

let keyboard ~key ~x ~y =
  match key with
  | 'q' | '\027' -> exit 0;
  | _ -> ()
;;

let gl_init() =
  glShadeModel GL_FLAT;
  glDisable GL_DEPTH_TEST;
  glClearColor 0.4 0.0 0.0  0.0;
;;

let () =
  Random.self_init();

  ignore(glutInit Sys.argv);

  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE]; (* dont use GLUT_DEPTH *)
  glutInitWindowSize 640 480;
  ignore(glutCreateWindow "demo");

  glutFullScreen();
  glutSetCursor GLUT_CURSOR_NONE;
  gl_init();

  (* Parameters of perspective projection *)
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective ~fovy:60.0 ~aspect:1.0 ~zNear:0.5 ~zFar:100.0;
  glMatrixMode GL_MODELVIEW;

  (* callbacks *)
  glutDisplayFunc ~display;
  glutKeyboardFunc ~keyboard;
  glutReshapeFunc ~reshape;
  glutTimerFunc ~msecs:sleep_ticks ~timer:rot_timer ~value:0;
  (*
  glutTimerFunc ~msecs:100 ~timer:time_tracker ~value:0;
  *)

  glutMainLoop();
;;

(* }}} *)

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
