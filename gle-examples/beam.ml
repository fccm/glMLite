(* 
 * beam.ml
 *
 * FUNCTION:
 * Show how twisting is applied.
 *
 * HISTORY:
 * -- linas Vepstas October 1991
 * -- heavily modified to draw corrugated surface, Feb 1993, Linas
 * -- modified to demo twistoid March 1993
 * -- port to glut Linas Vepstas March 1995
 * -- port to caml Florent Monnier October 2008
 * Copyright (c) 1991, 1993, 1995 Linas Vepstas <linas@linas.org>
 *)

(* required include files *)
open GL
open Glut
open GLE

open Mainvar

(* =========================================================== *)

let num_beam_pts = 22 
let beam_spine  = ba2_glefloat_create num_beam_pts 3
let beam_twists = ba1_glefloat_create num_beam_pts

let tscale = 6.0


(* =========================================================== *)

let num_xsection_pts = 12

let xsection = ba2_glefloat_create num_xsection_pts 2
let xnormal  = ba2_glefloat_create num_xsection_pts 2

let scale = 0.1
let xsection_fun i (x,y) =
  xsection.{i,0} <- scale *. (x);
  xsection.{i,1} <- scale *. (y);
  if i<>0 then begin
    let ax = xsection.{i,0} -. xsection.{i-1, 0}
    and ay = xsection.{i,1} -. xsection.{i-1, 1} in
    let alen = 1.0 /. sqrt (ax*.ax +. ay*.ay) in
    let ax = ax *. alen
    and ay = ay *. alen in
    xnormal.{i-1, 0} <- -. ay;
    xnormal.{i-1, 1} <- ax;
  end;
;;

(* =========================================================== *)

let init_stuff () =

  for i = 0 to pred 22 do
    beam_twists.{i} <- 0.0;
    let x, y, z = (-1.1 +. (float i) /. 10.0), 0.0, 0.0 in
    beam_spine.{i,0} <- tscale *. (x);
    beam_spine.{i,1} <- tscale *. (y);
    beam_spine.{i,2} <- tscale *. (z);
  done;

  let arr = [|
    (-6.0,  6.0);
    ( 6.0,  6.0);
    ( 6.0,  5.0);
    ( 1.0,  5.0);
    ( 1.0, -5.0);
    ( 6.0, -5.0);
    ( 6.0, -6.0);
    (-6.0, -6.0);
    (-6.0, -5.0);
    (-1.0, -5.0);
    (-1.0,  5.0);
    (-6.0,  5.0);
  |] in
  Array.iteri xsection_fun arr;
;;

let twist_beam howmuch =
  for i=0 to pred 22 do
    let z = (float (i-14)) /. 10.0 in
    beam_twists.{i} <- howmuch *. exp (-3.0 *. z *. z);
  done;
;;

(* =========================================================== *)

let draw_stuff () =

  twist_beam (float (!lastx - 121) /. 6.0);

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* set up some matrices so that the object spins with the mouse *)
  glPushMatrix ();
  glTranslatev (0.0, 0.0, -80.0);
  glRotatev 43.0 (1.0, 0.0, 0.0);
  glRotatev 43.0 (0.0, 1.0, 0.0);
  glScalev (1.8, 1.8, 1.8);
  gleTwistExtrusion  xsection xnormal None
                     beam_spine colors_none beam_twists;
  glPopMatrix ();
  glutSwapBuffers ();
;;

(* ------------------ end of file -------------------- *)
