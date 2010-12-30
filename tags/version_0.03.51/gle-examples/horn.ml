(* 
 * hron -- cone drawing demo 
 *
 * FUNCTION:
 * Baisc demo illustrating how to write code to draw
 * the a slightly fancier "polycone".
 *
 * HISTORY:
 * Linas Vepstas March 1995
 * Copyright (c) 1995 Linas Vepstas <linas@linas.org>
 * 2008 - OCaml version by F. Monnier
 *)

(* required include files *)
open GL
open Glut
open GLE

open Mainvar

(* the arrays in which we will store out polyline *)

(* 
 * Initialize a bent shape with three segments. 
 * The data format is a polyline.
 *
 * NOTE that neither the first, nor the last segment are drawn.
 * The first & last segment serve only to determine that angle 
 * at which the endcaps are drawn.
 *)

let points = ba2_glefloat_of_array [|
    [| -4.9;  6.0; 0.0 |];
    [| -4.8;  5.8; 0.0 |];
    [| -3.8;  5.8; 0.0 |];
    [| -3.5;  6.0; 0.0 |];
    [| -3.0;  7.0; 0.0 |];
    [| -2.4;  7.6; 0.0 |];
    [| -1.8;  7.6; 0.0 |];
    [| -1.2;  7.1; 0.0 |];
    [| -0.8;  5.1; 0.0 |];
    [| -0.3; -2.0; 0.0 |];
    [| -0.2; -7.0; 0.0 |];
    [|  0.3; -7.8; 0.0 |];
    [|  0.8; -8.2; 0.0 |];
    [|  1.8; -8.6; 0.0 |];
    [|  3.6; -8.6; 0.0 |];
    [|  4.5; -8.2; 0.0 |];
    [|  4.8; -7.5; 0.0 |];
    [|  5.0; -6.0; 0.0 |];
    [|  6.4; -2.0; 0.0 |];
    [|  6.9; -1.0; 0.0 |];
    [|  7.8;  0.5; 0.0 |];
  |]


let radii = ba1_glefloat_of_array [|
    0.3; 0.3; 0.3; 0.6; 0.8; 0.9; 1.0; 1.1; 1.2; 1.7; 1.8;
    2.0; 2.1; 2.25; 2.4; 2.5; 2.6; 2.7; 3.2; 4.1; 4.1;
  |]


let init_stuff () =
  (* initialize the join style here *)
  gleSetJoinStyle [TUBE_NORM_PATH_EDGE; TUBE_JN_ANGLE];
;;


(* draw the polycone shape *)
let draw_stuff () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* set up some matrices so that the object spins with the mouse *)
  glPushMatrix ();
  glTranslatev (0.0, 0.0, -80.0);
  glRotate (float !lastx) 0.0 1.0 0.0;
  glRotate (float !lasty) 1.0 0.0 0.0;
  glColor3v (0.5, 0.5, 0.2);

  (* Phew. FINALLY, Draw the polycone  -- *)
  glePolyCone points colors_none radii;

  glPopMatrix ();

  glutSwapBuffers ();
;;

(* --------------------------- end of file ------------------- *)
