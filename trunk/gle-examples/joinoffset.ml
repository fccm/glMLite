(*
 * FILE:
 * joinoffset.ml
 * 
 * FUNCTION:
 * this demo demonstrates the various join styles 
 *
 * HISTORY:
 * Copyright (c) 1995 Linas Vepstas <linas@linas.org>
 * 2008 - OCaml version by F. Monnier
 *)


(* required modules *)
open GL
open Glut
open GLE

open Mainvar

(* ------------------------------------------------------- *)
(* 
 * Initialize a bent shape with three segments. 
 * The data format is a polyline.
 *
 * NOTE that neither the first, nor the last segment are drawn.
 * The first & last segment serve only to determine that angle 
 * at which the endcaps are drawn.
 *)


(* the arrays in which we will store the polyline *)
let points = ba2_glefloat_of_array [|
    [|  8.0;  0.0; 0.0 |];
    [|  0.0; -8.0; 0.0 |];
    [| -8.0;  0.0; 0.0 |];
    [|  0.0;  8.0; 0.0 |];
    [|  8.0;  0.0; 0.0 |];
    [|  0.0; -8.0; 0.0 |];
    [| -8.0;  0.0; 0.0 |];
  |]

(* the arrays in which we will store the colors *)
let colors = ba2_float32_of_array [|
    [| 0.0; 0.0; 0.0 |];
    [| 0.2; 0.8; 0.5 |];
    [| 0.0; 0.8; 0.3 |];
    [| 0.8; 0.3; 0.0 |];
    [| 0.2; 0.3; 0.9 |];
    [| 0.2; 0.8; 0.5 |];
    [| 0.0; 0.0; 0.0 |];
  |]

(* the arrays in which we will store the contour *)
let cidx, contour_points =
  let arr = [|
    [| -0.8; -0.5 |];
    [| -1.8;  0.0 |];
    [| -1.2;  0.3 |];
    [| -0.7;  0.8 |];
    [| -0.2;  1.3 |];
    [|  0.0;  1.6 |];
    [|  0.2;  1.3 |];
    [|  0.7;  0.8 |];
    [|  1.2;  0.3 |];
    [|  1.8;  0.0 |];
    [|  0.8; -0.5 |];
  |] in
  (Array.length arr,
   ba2_glefloat_of_array arr)

let moved_contour =
  (ba2_glefloat_create cidx 2)


(* ------------------------------------------------------- *)

let init_stuff () = ()


let up_vector = (1.0, 0.0, 0.0)

(* ------------------------------------------------------- *)
(* draw the extrusion *)

let draw_stuff () =

  for i=0 to pred cidx do
    moved_contour.{i,0} <- contour_points.{i,0};
    moved_contour.{i,1} <- contour_points.{i,1} +. 0.05 *. (float !lasty -. 200.0);
  done;

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* set up some matrices so that the object spins with the mouse *)
  glPushMatrix ();
  glTranslate 0.0 4.0 (-80.0);
  glRotate (0.5 *. float !lastx) 0.0 1.0 0.0;

  gleSetJoinStyle [TUBE_JN_ANGLE; TUBE_CONTOUR_CLOSED; TUBE_JN_CAP];

  gleExtrusion moved_contour contour_points (Some up_vector) points colors;

  glPopMatrix ();


  (* draw a second copy, this time with the raw style, to compare
     things against *)
  glPushMatrix ();
  glTranslate 0.0 (-4.0) (-80.0);
  glRotate (0.5 *. float !lastx) 0.0 1.0 0.0;

  gleSetJoinStyle [TUBE_JN_RAW; TUBE_CONTOUR_CLOSED; TUBE_JN_CAP];

  gleExtrusion moved_contour contour_points (Some up_vector) points colors;

  glPopMatrix ();

  glutSwapBuffers ();
;;

(* ------------------ end of file ----------------------------- *)
