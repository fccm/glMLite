(* A small demo of the modules FunGL and FunGlut.
 * Copyright (C) 2009 Florent Monnier
 * You can use this file under the terms of the MIT license:
 * http://en.wikipedia.org/wiki/MIT_License
 *)
open GL
open FunGL
open Glut
open FunGlut

type pos = {x:float; y:float; z:float}
type color = FunGL.rgb
type cube = {size:float; pos:pos; color:color}
type obj = Cube of cube
type app = {loc:pos; cnt:obj list}

let () = Random.self_init()

let rand_color() =
  (Random.float 1.0,
   Random.float 1.0,
   Random.float 1.0)

let new_cube size ?(pos={x=0.; y=0.; z=0.}) color =
  Cube {size=size; pos=pos; color=color}

let init_app() =
  let init_pos = {x=0.; y=0.; z=0.} in
  {loc=init_pos; cnt=[]}

let draw_translated pos = draw_translated (pos.x, pos.y, pos.z) ;;

let display app =
  glClear [GL_COLOR_BUFFER_BIT];
  draw_as_identity (fun () ->
  draw_translated app.loc (fun () ->
    let display_item = function
    | Cube c ->
        draw_translated c.pos (fun () ->
        draw_with_rgb c.color (fun () ->
          glutWireCube c.size;
        ))
    in
    List.iter display_item app.cnt;
  ));
  glutSwapBuffers()

let app_add_x app step = {app with loc={app.loc with x= app.loc.x +. step}}
let app_add_y app step = {app with loc={app.loc with y= app.loc.y +. step}}
let app_add_z app step = {app with loc={app.loc with z= app.loc.z +. step}}

let app_sub_x app step = {app with loc={app.loc with x= app.loc.x -. step}}
let app_sub_y app step = {app with loc={app.loc with y= app.loc.y -. step}}
let app_sub_z app step = {app with loc={app.loc with z= app.loc.z -. step}}

let push_content app cnt = {app with cnt = cnt :: app.cnt}
let empty_content app = {app with cnt = []}

let inv p = { x= -. p.x; y= -. p.y; z= -. p.z -. 3.0 }

let push_cube app =
  let cube = new_cube 0.1 ~pos:(inv app.loc) (rand_color()) in
  push_content app cube

let _timer =
  let dir = ref(Random.int 4) in
  function app ->
  if (Random.int 8) = 0 then
    dir := (
      match !dir, Random.bool() with
      | 0, true  -> 2    | 2, true  -> 0
      | 1, true  -> 2    | 3, true  -> 0
      | 0, false -> 3    | 2, false -> 1
      | 1, false -> 3    | 3, false -> 1
      | _ -> assert false);
  if (Random.int 22) = 0 then
  ( match Random.bool() with
    | true  -> post_redisplay (app_sub_z app) (0.1 *. float(Random.int 12))
    | false -> post_redisplay (app_add_z app) (0.1 *. float(Random.int 8)) )
  else
  ( match !dir with
    | 0 -> post_redisplay push_cube (app_sub_y app 0.1)
    | 1 -> post_redisplay push_cube (app_add_y app 0.1)
    | 2 -> post_redisplay push_cube (app_add_x app 0.1)
    | 3 -> post_redisplay push_cube (app_sub_x app 0.1)
    | _ -> assert false )

let special app ~key ~x ~y =
  match key with
  | GLUT_KEY_F1 | GLUT_KEY_F2 | GLUT_KEY_F3 | GLUT_KEY_F4
  | GLUT_KEY_F5 | GLUT_KEY_F6 | GLUT_KEY_F7 | GLUT_KEY_F8
  | GLUT_KEY_F9 | GLUT_KEY_F10 | GLUT_KEY_F11 | GLUT_KEY_F12 -> app
  | GLUT_KEY_HOME | GLUT_KEY_END -> app
  | GLUT_KEY_UP    -> post_redisplay push_cube (app_sub_y app 0.1)
  | GLUT_KEY_DOWN  -> post_redisplay push_cube (app_add_y app 0.1)
  | GLUT_KEY_LEFT  -> post_redisplay push_cube (app_add_x app 0.1)
  | GLUT_KEY_RIGHT -> post_redisplay push_cube (app_sub_x app 0.1)
  | GLUT_KEY_PAGE_DOWN -> post_redisplay (app_sub_z app) 0.1
  | GLUT_KEY_PAGE_UP   -> post_redisplay (app_add_z app) 0.1
  | GLUT_KEY_INSERT -> app

let keyboard app ~key ~x ~y =
  match key with
  | 'q' | '\027' -> exit 0;
  | ' ' -> post_redisplay empty_content app
  | 'f' -> post_redisplay (   (* 'f' like further *)
             List.fold_left (fun app _ -> _timer app) app)
                            (Array.to_list(Array.make 400 0))
  | _ -> app

let reshape app ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  Glu.gluPerspective 60. ((float w)/.(float (max 1 h))) 0.1 1000.0;
  glMatrixMode GL_MODELVIEW;
  glutPostRedisplay();
  app

let special, timer =
  match Sys.argv with
  | [| _; "-user" |] -> Some special, None
  | _ -> None, Some [((_timer), 200)]

let () =
  FunGlut.fun_glut
      ~display_mode:[GLUT_RGB; GLUT_DOUBLE]
      ?timer ?special
      ~display ~reshape ~keyboard ~init:init_app ()

