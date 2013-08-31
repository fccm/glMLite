(* 
 * FILE:
 * alpha.ml
 * 
 * FUNCTION:
 * Alpha-blending/transparency demo 
 * Demo illustrates how to draw transparent shapes.
 * This demo is very similar to the cone.c demo, except
 * that it draws the basic shape twice: once fat and transparent, 
 * and once skiny but solid-colored.
 *
 * Note that this algoroithm is somewhat faulty: correct transparency
 * is acheived by drawing back-to-front, which can be done by using
 * the stencil planes.  This demo does not do this.
 *
 * HISTORY:
 * Linas Vepstas March 1995
 * March 2003, Derived from cone demo
 * Copyright (c) 1995,2003 Linas Vepstas <linas@linas.org>
 * 2008 - OCaml version by F. Monnier
 *)

(* required include files *)
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

(* the arrays in which we will store out polyline *)

let points = ba2_glefloat_of_array [|
    [| -6.0;  6.0; 0.0 |];
    [|  6.0;  6.0; 0.0 |];
    [|  6.0; -6.0; 0.0 |];
    [| -6.0; -6.0; 0.0 |];
    [| -6.0;  6.0; 0.0 |];
    [|  6.0;  6.0; 0.0 |];
  |]


let colors = ba2_float32_of_array [|
    [| 0.0; 0.0; 0.0; 1.0 |];
    [| 0.0; 0.8; 0.3; 1.0 |];
    [| 0.8; 0.3; 0.0; 1.0 |];
    [| 0.2; 0.3; 0.9; 1.0 |];
    [| 0.2; 0.8; 0.5; 1.0 |];
    [| 0.0; 0.0; 0.0; 1.0 |];
  |]


let colors_thin = ba2_float32_of_array [|
    [| 0.0; 0.0; 0.0; 0.5 |];
    [| 0.0; 0.8; 0.3; 0.5 |];
    [| 0.8; 0.3; 0.0; 0.5 |];
    [| 0.2; 0.3; 0.9; 0.5 |];
    [| 0.2; 0.8; 0.5; 0.5 |];
    [| 0.0; 0.0; 0.0; 0.5 |];
  |]


let radii, radii_small =
  let arr = [| 1.5; 1.5; 4.5; 0.75; 3.0; 1.5 |] in
  let arr_small = Array.map (( *. ) (0.4 /. 1.5)) arr in
  (ba1_glefloat_of_array arr,
   ba1_glefloat_of_array arr_small)



let init_stuff () =
  glEnable GL_BLEND;
  glBlendFunc Sfactor.GL_SRC_ALPHA  Dfactor.GL_ONE_MINUS_SRC_ALPHA;

  (* initialize the join style here *)
  gleSetJoinStyle [TUBE_NORM_EDGE; TUBE_JN_ANGLE; TUBE_JN_CAP];
;;


(* draw the polycone shape *)
let draw_stuff () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* set up some matrices so that the object spins with the mouse *)
  glPushMatrix ();
  glTranslatev (0.0, 0.0, -80.0);
  glRotate (float !lastx) 0.0 1.0 0.0;
  glRotate (float !lasty) 1.0 0.0 0.0;

  (* Phew. FINALLY, Draw the polycone  -- *)
  glePolyCone_c4f points colors radii_small;
  glePolyCone_c4f points colors_thin radii;
       
  glPopMatrix ();

  glutSwapBuffers ();
;;

(* --------------------------- end of file ------------------- *)
