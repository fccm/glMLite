(* Copyright (c) Mark J. Kilgard, 1994. *)

(* (c) Copyright 1993, Silicon Graphics, Inc.
 * ALL RIGHTS RESERVED
 * Permission to use, copy, modify, and distribute this software for
 * any purpose and without fee is hereby granted, provided that the above
 * copyright notice appear in all copies and that both the copyright notice
 * and this permission notice appear in supporting documentation, and that
 * the name of Silicon Graphics, Inc. not be used in advertising
 * or publicity pertaining to distribution of the software without specific,
 * written prior permission.
 *
 * THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"
 * AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR
 * FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL SILICON
 * GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,
 * SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY
 * KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,
 * LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF
 * THIRD PARTIES, WHETHER OR NOT SILICON GRAPHICS, INC.  HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE
 * POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * US Government Users Restricted Rights
 * Use, duplication, or disclosure by the Government is subject to
 * restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
 * (c)(1)(ii) of the Rights in Technical Data and Computer Software
 * clause at DFARS 252.227-7013 and/or in similar or successor
 * clauses in the FAR or the DOD or NASA FAR Supplement.
 * Unpublished-- rights reserved under the copyright laws of the
 * United States.  Contractor/manufacturer is Silicon Graphics,
 * Inc., 2011 N.  Shoreline Blvd., Mountain View, CA 94039-7311.
 *
 * OpenGL(TM) is a trademark of Silicon Graphics, Inc.
 *)

(*  dof.ml
 *  This program demonstrates use of the accumulation buffer to
 *  create an out-of-focus depth-of-field effect.  The teapots
 *  are drawn several times into the accumulation buffer.  The
 *  viewing volume is jittered, except at the focal point, where
 *  the viewing volume is at the same position, each time.  In
 *  this case, the gold teapot remains in focus.
 *)

(* Ported from C to OCaml by Florent Monnier *)

open GL
open Glu
open Glut

module Jitter = struct
(*
This module contains jitter point arrays for 2,3,4,8,15,24 and 66 jitters.

The arrays are named j2, j3, etc. Each element in the array has the form,
for example, let (x, y) = j8.(0)

Values are floating point in the range -.5 < x < .5, -.5 < y < .5, and
have a gaussian distribution around the origin.

Use these to do model jittering for scene anti-aliasing and view volume
jittering for depth of field effects. Use in conjunction with the 
accwindow() routine.
*)


let max_samples = 66


(* 2 jitter points *)
let j2 = [|
      (*   jitter-point:  *)
      (*       x,  y      *)
      ( 0.246490,  0.249999);
      (-0.246490, -0.249999);
  |]


(* 3 jitter points *)
let j3 = [|
      (-0.373411, -0.250550);
      ( 0.256263,  0.368119);
      ( 0.117148, -0.117570);
  |]


(* 4 jitter points *)
let j4 = [|
      (-0.208147,  0.353730);
      ( 0.203849, -0.353780);
      (-0.292626, -0.149945);
      ( 0.296924,  0.149994);
  |]


(* 8 jitter points *)
let j8 = [|
      (-0.334818,  0.435331);
      ( 0.286438, -0.393495);
      ( 0.459462,  0.141540);
      (-0.414498, -0.192829);
      (-0.183790,  0.082102);
      (-0.079263, -0.317383);
      ( 0.102254,  0.299133);
      ( 0.164216, -0.054399);
  |]


(* 15 jitter points *)
let j15 = [|
      ( 0.285561,  0.188437);
      ( 0.360176, -0.065688);
      (-0.111751,  0.275019);
      (-0.055918, -0.215197);
      (-0.080231, -0.470965);
      ( 0.138721,  0.409168);
      ( 0.384120,  0.458500);
      (-0.454968,  0.134088);
      ( 0.179271, -0.331196);
      (-0.307049, -0.364927);
      ( 0.105354, -0.010099);
      (-0.154180,  0.021794);
      (-0.370135, -0.116425);
      ( 0.451636, -0.300013);
      (-0.370610,  0.387504);
  |]


(* 24 jitter points *)
let j24 = [|
      ( 0.030245,  0.136384);
      ( 0.018865, -0.348867);
      (-0.350114, -0.472309);
      ( 0.222181,  0.149524);
      (-0.393670, -0.266873);
      ( 0.404568,  0.230436);
      ( 0.098381,  0.465337);
      ( 0.462671,  0.442116);
      ( 0.400373, -0.212720);
      (-0.409988,  0.263345);
      (-0.115878, -0.001981);
      ( 0.348425, -0.009237);
      (-0.464016,  0.066467);
      (-0.138674, -0.468006);
      ( 0.144932, -0.022780);
      (-0.250195,  0.150161);
      (-0.181400, -0.264219);
      ( 0.196097, -0.234139);
      (-0.311082, -0.078815);
      ( 0.268379,  0.366778);
      (-0.040601,  0.327109);
      (-0.234392,  0.354659);
      (-0.003102, -0.154402);
      ( 0.297997, -0.417965);
  |]


(* 66 jitter points *)
let j66 = [|
      ( 0.266377, -0.218171);
      (-0.170919, -0.429368);
      ( 0.047356, -0.387135);
      (-0.430063,  0.363413);
      (-0.221638, -0.313768);
      ( 0.124758, -0.197109);
      (-0.400021,  0.482195);
      ( 0.247882,  0.152010);
      (-0.286709, -0.470214);
      (-0.426790,  0.004977);
      (-0.361249, -0.104549);
      (-0.040643,  0.123453);
      (-0.189296,  0.438963);
      (-0.453521, -0.299889);
      ( 0.408216, -0.457699);
      ( 0.328973, -0.101914);
      (-0.055540, -0.477952);
      ( 0.194421,  0.453510);
      ( 0.404051,  0.224974);
      ( 0.310136,  0.419700);
      (-0.021743,  0.403898);
      (-0.466210,  0.248839);
      ( 0.341369,  0.081490);
      ( 0.124156, -0.016859);
      (-0.461321, -0.176661);
      ( 0.013210,  0.234401);
      ( 0.174258, -0.311854);
      ( 0.294061,  0.263364);
      (-0.114836,  0.328189);
      ( 0.041206, -0.106205);
      ( 0.079227,  0.345021);
      (-0.109319, -0.242380);
      ( 0.425005, -0.332397);
      ( 0.009146,  0.015098);
      (-0.339084, -0.355707);
      (-0.224596, -0.189548);
      ( 0.083475,  0.117028);
      ( 0.295962, -0.334699);
      ( 0.452998,  0.025397);
      ( 0.206511, -0.104668);
      ( 0.447544, -0.096004);
      (-0.108006, -0.002471);
      (-0.380810,  0.130036);
      (-0.242440,  0.186934);
      (-0.200363,  0.070863);
      (-0.344844, -0.230814);
      ( 0.408660,  0.345826);
      (-0.233016,  0.305203);
      ( 0.158475, -0.430762);
      ( 0.486972,  0.139163);
      (-0.301610,  0.009319);
      ( 0.282245, -0.458671);
      ( 0.482046,  0.443890);
      (-0.121527,  0.210223);
      (-0.477606, -0.424878);
      (-0.083941, -0.121440);
      (-0.345773,  0.253779);
      ( 0.234646,  0.034549);
      ( 0.394102, -0.210901);
      (-0.312571,  0.397656);
      ( 0.200906,  0.333293);
      ( 0.018703, -0.261792);
      (-0.209349, -0.065383);
      ( 0.076248,  0.478538);
      (-0.073036, -0.355064);
      ( 0.145087,  0.221726);
  |]

end


let pi = 3.14159265358979323846

(*      accFrustum()
 *  The first 6 arguments are identical to the glFrustum() call.
 *
 *  pixdx and pixdy are anti-alias jitter in pixels.
 *  Set both equal to 0.0 for no anti-alias jitter.
 *  eyedx and eyedy are depth-of field jitter in pixels.
 *  Set both equal to 0.0 for no depth of field effects.
 *
 *  focus is distance from eye to plane in focus.
 *  focus must be greater than, but not equal to 0.0.
 *
 *  Note that accFrustum() calls glTranslatef().  You will
 *  probably want to insure that your ModelView matrix has been
 *  initialized to identity before calling accFrustum().
 *)
let accFrustum ~left ~right ~bottom
      ~top ~nnear ~ffar ~pixdx
      ~pixdy ~eyedx ~eyedy ~focus =

  let _, _, viewport2, viewport3 = glGetInteger4 Get.GL_VIEWPORT in

  let xwsize = right -. left
  and ywsize = top -. bottom in

  let dx = -. (pixdx *. xwsize /. float viewport2 +. eyedx *. nnear /. focus)
  and dy = -. (pixdy *. ywsize /. float viewport3 +. eyedy *. nnear /. focus) in

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glFrustum (left +. dx) (right +. dx) (bottom +. dy) (top +. dy) nnear ffar;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
  glTranslate (-. eyedx) (-. eyedy) (0.0);
;;

(*  accPerspective()
 *
 *  The first 4 arguments are identical to the gluPerspective() call.
 *  pixdx and pixdy are anti-alias jitter in pixels.
 *  Set both equal to 0.0 for no anti-alias jitter.
 *  eyedx and eyedy are depth-of field jitter in pixels.
 *  Set both equal to 0.0 for no depth of field effects.
 *
 *  focus is distance from eye to plane in focus.
 *  focus must be greater than, but not equal to 0.0.
 *
 *  Note that accPerspective() calls accFrustum().
 *)
let accPerspective ~fovy ~aspect
      ~nnear ~ffar ~pixdx ~pixdy
      ~eyedx ~eyedy ~focus =

  let fov2 = ((fovy *. pi) /. 180.0) /. 2.0 in

  let top = nnear /. ((cos fov2) /. (sin fov2)) in
  let bottom = -. top in

  let right = top *. aspect in
  let left = -. right in

  accFrustum left right bottom top nnear ffar
      pixdx pixdy eyedx eyedy focus;
;;

let myinit() =
  let ambient  = (0.0, 0.0, 0.0, 1.0)
  and diffuse  = (1.0, 1.0, 1.0, 1.0)
  and position = (0.0, 3.0, 3.0, 0.0)

  and lmodel_ambient = (0.2, 0.2, 0.2, 1.0)
  and local_view = false in

  glEnable GL_DEPTH_TEST;
  glDepthFunc GL_LESS;

  glLight (GL_LIGHT 0) (Light.GL_AMBIENT ambient);
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE diffuse);
  glLight (GL_LIGHT 0) (Light.GL_POSITION position);

  glLightModel (GL_LIGHT_MODEL_AMBIENT lmodel_ambient);
  glLightModel (GL_LIGHT_MODEL_LOCAL_VIEWER local_view);

  glFrontFace GL_CW;
  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;
  glEnable GL_AUTO_NORMAL;
  glEnable GL_NORMALIZE;

  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();

  glClearColor 0.0 0.0 0.0 0.0;
  glClearAccum 0.0 0.0 0.0 0.0;
;;

let renderTeapot ~x ~y ~z
     ~ambr ~ambg ~ambb
     ~difr ~difg ~difb
     ~specr ~specg ~specb ~shine =

  glPushMatrix();
  glTranslate ~x ~y ~z;
  glMaterial GL_FRONT (Material.GL_AMBIENT (ambr, ambg, ambb, 1.0));
  glMaterial GL_FRONT (Material.GL_DIFFUSE (difr, difg, difb, 1.0));
  glMaterial GL_FRONT (Material.GL_SPECULAR (specr, specg, specb, 1.0));
  glMaterial GL_FRONT (Material.GL_SHININESS (shine *. 128.0));
  glutSolidTeapot 0.5;
  glPopMatrix();
;;

(*  display() draws 5 teapots into the accumulation buffer
 *  several times; each time with a jittered perspective.
 *  The focal point is at z = 5.0, so the gold teapot will
 *  stay in focus.  The amount of jitter is adjusted by the
 *  magnitude of the accPerspective() jitter; in this example, 0.33.
 *  In this example, the teapots are drawn 8 times.  See jitter.h
 *)
let display() =
  let _, _, viewport2, viewport3 = glGetInteger4 Get.GL_VIEWPORT in
  glClear [GL_ACCUM_BUFFER_BIT];

  Array.iter (fun (x,y) ->
    glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
    accPerspective 45.0
            (float viewport2 /. float viewport3)
            1.0 15.0 0.0 0.0
            (0.33 *. x) (0.33 *. y) 5.0;

    (* ruby, gold, silver, emerald, and cyan teapots *)
    renderTeapot (-1.1) (-0.5) (-4.5) 0.1745 0.01175 0.01175
        0.61424 0.04136 0.04136 0.727811 0.626959 0.626959 0.6;
    renderTeapot (-0.5) (-0.5) (-5.0) 0.24725 0.1995 0.0745
        0.75164 0.60648 0.22648 0.628281 0.555802 0.366065 0.4;
    renderTeapot (0.2) (-0.5) (-5.5) 0.19225 0.19225 0.19225
        0.50754 0.50754 0.50754 0.508273 0.508273 0.508273 0.4;
    renderTeapot (1.0) (-0.5) (-6.0) 0.0215 0.1745 0.0215
        0.07568 0.61424 0.07568 0.633 0.727811 0.633 0.6;
    renderTeapot (1.8) (-0.5) (-6.5) 0.0 0.1 0.06 0.0 0.50980392
        0.50980392 0.50196078 0.50196078 0.50196078 0.25;

    glAccum GL_ACCUM 0.125;
  ) Jitter.j8;

  glAccum GL_RETURN 1.0;
  glFlush();
;;

let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
;;

let keyboard ~key ~x ~y =
  begin match key with
  | '\027' ->  (* Escape *)
      exit(0);
  | _ -> ()
  end;
  glutPostRedisplay();
;;

(*  Main Loop
 *  Open window with initial window size, title bar,
 *  RGBA display mode, depth buffer, and handle input events.
 *)
let () =
  let _ = glutInit Sys.argv in
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB;
                       GLUT_ACCUM; GLUT_DEPTH];
  let _ = glutCreateWindow Sys.argv.(0) in
  myinit();
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

