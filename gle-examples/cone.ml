(* 
 * FILE:
 * cone.ml
 *
 * FUNCTION:
 * Baisc demo illustrating how to write code to draw
 * the most basic cone shape.
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

(*
 * Initialize a bent shape with three segments. 
 * The data format is a polyline.
 *
 * NOTE that neither the first, nor the last segment are drawn.
 * The first & last segment serve only to determine that angle 
 * at which the endcaps are drawn.
 *)

(* arrays which define the polyline *)

let points = ba2_glefloat_of_array [|
    [| -6.0;  6.0; 0.0 |];
    [|  6.0;  6.0; 0.0 |];
    [|  6.0; -6.0; 0.0 |];
    [| -6.0; -6.0; 0.0 |];
    [| -6.0;  6.0; 0.0 |];
    [|  6.0;  6.0; 0.0 |];
  |]

let colors = ba2_float32_of_array [|
    [| 0.0; 0.0; 0.0 |];
    [| 0.0; 0.8; 0.3 |];
    [| 0.8; 0.3; 0.0 |];
    [| 0.2; 0.3; 0.9 |];
    [| 0.2; 0.8; 0.5 |];
    [| 0.0; 0.0; 0.0 |];
  |]

let radii = ba1_glefloat_of_array [|
    1.0;
    1.0;
    3.0;
    0.5;
    2.0;
    1.0;
  |]


let init_stuff () =
  (* initialize the join style here *)
  gleSetJoinStyle [TUBE_NORM_EDGE; TUBE_JN_ANGLE; TUBE_JN_CAP];
;;

(* draw the polycone shape *)
let draw_stuff () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* set up some matrices so that the object spins with the mouse *)
  glPushMatrix ();
  glTranslate 0.0 0.0 (-80.0);
  glRotate (float !lastx) 0.0 1.0 0.0;
  glRotate (float !lasty) 1.0 0.0 0.0;

  (* Phew. FINALLY, Draw the polycone  -- *)
  glePolyCone ~points ~colors ~radii;

  glPopMatrix ();

  glutSwapBuffers ();
;;

(* --------------------------- end of file ------------------- *)
