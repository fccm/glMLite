(* 
 * texas.ml
 * 
 * FUNCTION:
 * Draws a brand in the shape of Texas.  Both the handle, and the
 * cross-section of the brand are in the shape of Texas.
 *
 * Note that the contours are specified in clockwise order. 
 * Thus, enabling backfacing polygon removal will cause the front
 * polygons to disappear.
 *
 * HISTORY:
 * -- created by Linas Vepstas October 1991
 * -- heavily modified to draw more texas shapes, Feb 1993, Linas
 * -- converted to use GLUT -- December 1995, Linas
 * Copyright (c) 1991, 1993, 1995 Linas Vepstas <linas@linas.org>
 * -- converted to OCaml - 2008, F. Monnier
 *
 *)

(* required include files *)
open GL
open Glut
open GLE

open Mainvar

(* =========================================================== *)

let tscale = 4.0

let brand_points = ba2_glefloat_of_array [|
    [| 0.0; 0.0;  0.1 |];
    [| 0.0; 0.0;  0.0 |];
    [| 0.0; 0.0; -5.0 |];
    [| 0.0; 0.0; -5.1 |];
  |]

let brand_colors = ba2_float32_of_array [|
    [| 1.0; 0.3; 0.0 |];
    [| 1.0; 0.3; 0.0 |];
    [| 1.0; 0.3; 0.0 |];
    [| 1.0; 0.3; 0.0 |];
  |]

let tnum, tspine =
  let tcoords = [|
    (-1.5,   2.0);   (* panhandle *)
    (-0.75,  2.0);
    (-0.75,  1.38);
    (-0.5,   1.25);
    ( 0.88,  1.12);
    ( 1.0,   0.62);
    ( 1.12,  0.1);
    ( 0.5,  -0.5);
    ( 0.2,  -1.12);  (* corpus *)
    ( 0.3,  -1.5);   (* brownsville *)
    (-0.25, -1.45);
    (-1.06, -0.3);
    (-1.38, -0.3);
    (-1.65, -0.6);
    (-2.5,   0.5);   (* midland *)
    (-1.5,   0.5);
    (-1.5,   2.0);   (* panhandle *)
    (-0.75,  2.0);
  |] in
  let arr = Array.map (fun (x,y) -> [| tscale *. x; tscale *. y; 0.0 |]) tcoords in
  (Array.length arr,
   ba2_glefloat_of_array arr)


let tcolors = (ba2_float32_create tnum 3)


(* =========================================================== *)

let ( += ) a b = (a := !a + b)
let ( %= ) a b = (a := !a mod b)

let init_spine () =

  let ir = ref 0
  and ig = ref 0
  and ib = ref 0
  in
  for i=0 to pred tnum do
    ir += 33;  ig += 47;  ib += 89;
    ir %= 255; ig %= 255; ib %= 255;

    let r = (float !ir) /. 255.0
    and g = (float !ig) /. 255.0
    and b = (float !ib) /. 255.0 in
    
    tcolors.{i,0} <- (r);
    tcolors.{i,1} <- (g);
    tcolors.{i,2} <- (b);
  done;
;;

(* =========================================================== *)

let coords = [
  (-0.75,  2.0 );
  (-0.75,  1.38);
  (-0.5,   1.25);
  ( 0.88,  1.12);
  ( 1.0,   0.62);
  ( 1.12,  0.1 );
  ( 0.5,  -0.5 );
  ( 0.2,  -1.12);   (* corpus *)
  ( 0.3,  -1.5 );   (* brownsville *)
  (-0.25, -1.45);
  (-1.06, -0.3 );
  (-1.38, -0.3 );
  (-1.65, -0.6 );
  (-2.5,   0.5 );   (* midland *)
  (-1.5,   0.5 );
  (-1.5,   2.0 );   (* panhandle *)
  (-0.75,  2.0 );
]
let ncoords = List.length coords

let texas_xsection =
  (ba2_glefloat_create ncoords 2)

let texas_normal =
  (ba2_glefloat_create ncoords 2)


let scale = 0.8
let border i (x, y) =
  texas_xsection.{i,0} <- scale *. (x);
  texas_xsection.{i,1} <- scale *. (y);
  if i <> 0 then begin
    let ax = texas_xsection.{i,0} -. texas_xsection.{i-1, 0}
    and ay = texas_xsection.{i,1} -. texas_xsection.{i-1, 1} in
    let alen = 1.0 /. sqrt (ax*.ax +. ay*.ay) in
    let ax = ax *. alen and ay = ay *. alen in
    texas_normal.{i-1, 0} <- -. ay;
    texas_normal.{i-1, 1} <- ax;
  end;
  (succ i)
;;


let init_xsection () =
  (* outline of extrusion *)
  ignore(
    List.fold_left border 0 coords
  );
;;

   
(* =========================================================== *)

let init_stuff () =
  (* configure the pipeline *)
  init_spine ();
  init_xsection ();

  gleSetJoinStyle [TUBE_JN_CAP; TUBE_CONTOUR_CLOSED; TUBE_NORM_FACET; TUBE_JN_ANGLE];
;;

(* =========================================================== *)

let draw_stuff () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* set up some matrices so that the object spins with the mouse *)
  glPushMatrix ();
  glTranslatev (0.0, 0.0, -80.0);
  glRotate (float !lastx) 0.0 1.0 0.0;
  glRotate (float !lasty) 1.0 0.0 0.0;

  (* draw the brand and the handle *)
  gleExtrusion texas_xsection texas_normal None tspine tcolors;

  gleExtrusion texas_xsection texas_normal None brand_points brand_colors;

  glPopMatrix ();
  glutSwapBuffers ();
;;

(* ===================== END OF FILE ================== *)
