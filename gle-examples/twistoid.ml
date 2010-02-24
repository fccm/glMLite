(* 
 * twistoid.ml
 *
 * FUNCTION:
 * Show extrusion of open contours. Also, show how torsion is applied.
 *
 * HISTORY:
 * -- linas Vepstas October 1991
 * -- heavily modified to draw corrugated surface, Feb 1993, Linas
 * -- modified to demo twistoid March 1993
 * -- port to glut Linas Vepstas March 1995
 * -- ocaml version Florent Monnier October 2008
 * Copyright (c) 1991, 1993, 1995 Linas Vepstas <linas@linas.org>
 *)

(* required modules *)
open GL
open Glut
open GLE

open Mainvar

(* =========================================================== *)

let mono_color = false

let tscale = 6.0

let pi = 4.0 *. atan 1.0


let toid1_points = 
  let arr = [|
    (-1.1, 0.0);
    (-1.0, 0.0);
    ( 0.0, 0.0);
    ( 1.0, 0.0);
    ( 1.1, 0.0);
  |] in
  let arr = Array.map
    (fun (x,y) ->
      [| tscale *. (x);
         tscale *. (y);
         tscale *. (0.0) |]) arr
  in
  (ba2_glefloat_of_array arr)


let toid1_colors = ba2_float32_of_array [|
    [| 0.8; 0.8; 0.5 |];
    [| 0.8; 0.4; 0.5 |];
    [| 0.8; 0.8; 0.3 |];
    [| 0.4; 0.4; 0.5 |];
    [| 0.8; 0.8; 0.5 |];
  |]


let toid1_twists = ba1_glefloat_of_array
  [| 0.0; 0.0; 0.0; 0.0; 0.0 |]


let tpts i (x,y) =
  toid1_points.{i, 0} <- tscale *. (x);
  toid1_points.{i, 1} <- tscale *. (y);
  toid1_points.{i, 2} <- tscale *. (0.0);
;;



(* =========================================================== *)

let num_twis_pts = 20

let twistation   = ba2_glefloat_create num_twis_pts 2
let twist_normal = ba2_glefloat_create num_twis_pts 2

let scale = 0.6

let twist i (x,y) =
  twistation.{i,0} <- scale *. (x);
  twistation.{i,1} <- scale *. (y);
  if i <> 0 then begin
    let ax = twistation.{i,0} -. twistation.{i-1, 0}
    and ay = twistation.{i,1} -. twistation.{i-1, 1} in
    let alen = 1.0 /. sqrt (ax*.ax +. ay*.ay) in
    let ax = ax *. alen
    and ay = ay *. alen in
    twist_normal.{i-1, 0} <- -. ay;
    twist_normal.{i-1, 1} <- ax;
  end;
;;


let init_tripples () =
  (* outline of extrusion *)

  for i = 0 to pred num_twis_pts do
    if i < 11 then begin
    (* first, draw a semi-curcular "hump" *)
      let angle = pi *. (float i) /. 10.0 in
      let co = cos angle
      and si = sin angle in
      twist i ((-7.0 -. 3.0 *. co), 1.8 *. si);
    end
    else begin
    (* now, a zig-zag corrugation *)
      twist i ((-10.0 +.(float i)), 0.0);
      twist i (( -9.5 +.(float i)), 1.0);
    end;
  done;
;;

   
(* =========================================================== *)

let draw_stuff () =

  toid1_twists.{2} <- (float !lastx -. 121.0) /. 8.0;

(*
  tpts 3 (1.0, float !lasty /. 400.0);
  tpts 4 (1.1, 1.1 *. float !lasty /. 400.0);
*)
  tpts 3 (1.0, -. (float !lasty -. 121.0) /. 200.0);
  tpts 4 (1.1, -1.1 *. (float !lasty -. 121.0) /. 200.0);

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* set up some matrices so that the object spins with the mouse *)
  glPushMatrix ();
  glTranslatev (0.0, 0.0, -80.0);
  glRotatev 43.0 (1.0, 0.0, 0.0);
  glRotatev 43.0 (0.0, 1.0, 0.0);
  glScalev (1.8, 1.8, 1.8);

  if mono_color then begin
    glColor3c '\178' '\178' '\204';
    gleTwistExtrusion  twistation twist_normal None
                       toid1_points colors_none toid1_twists;
  end
  else begin
    gleTwistExtrusion  twistation twist_normal None
                       toid1_points toid1_colors toid1_twists;
  end;

  glPopMatrix ();
  glutSwapBuffers ();
;;

(* =========================================================== *)

let exclude v li =
  let rec aux acc = function
  | [] -> List.rev acc
  | x::xs when x = v -> aux acc xs
  | x::xs -> aux (x::acc) xs
  in
  aux [] li
;;

let init_stuff () =
  init_tripples ();

  (*
  let js = gleGetJoinStyle () in
  let js = exclude TUBE_CONTOUR_CLOSED js in
  gleSetJoinStyle js;
  *)
;;

(* ------------------ end of file -------------------- *)
