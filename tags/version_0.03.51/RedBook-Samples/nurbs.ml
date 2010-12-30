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

(*  nurbs.ml
 *  This program shows a NURBS (Non-uniform rational B-splines)
 *  surface, shaped like a heart.
 *)

(* Ported from C to OCaml by Florent Monnier *)

open GL
open Glu
open Glut

let s_numpoints = 13                       (* = List.length _ctlpoints *)
let s_order     = 3
let s_numknots  = (s_numpoints + s_order)  (* = Array.length sknots *)
let t_numpoints = 3                        (* = List.length(List.nth _ctlpoints X) *)
let t_order     = 3
let t_numknots  = (t_numpoints + t_order)  (* = Array.length tknots *)
let sqrt2 = 1.41421356237309504880

(* initialized local data *)

let sknots =
  [| -1.0; -1.0; -1.0; 0.0; 1.0; 2.0; 3.0; 4.0;
      4.0;  5.0;  6.0; 7.0; 8.0; 9.0; 9.0; 9.0 |]
let tknots = [| 1.0; 1.0; 1.0; 2.0; 2.0; 2.0 |]

let _ctlpoints = [
  [ [4.;2.;2.;1.];[4.;1.6;2.5;1.];[4.;2.;3.0;1.] ];
  [ [5.;4.;2.;1.];[5.;4.;2.5;1.];[5.;4.;3.0;1.] ];
  [ [6.;5.;2.;1.];[6.;5.;2.5;1.];[6.;5.;3.0;1.] ];
  [ [sqrt2*.6.;sqrt2*.6.;sqrt2*.2.;sqrt2];
    [sqrt2*.6.;sqrt2*.6.;sqrt2*.2.5;sqrt2];
    [sqrt2*.6.;sqrt2*.6.;sqrt2*.3.0;sqrt2] ];
  [ [5.2;6.7;2.;1.];[5.2;6.7;2.5;1.];[5.2;6.7;3.0;1.] ];
  [ [sqrt2*.4.;sqrt2*.6.;sqrt2*.2.;sqrt2];
    [sqrt2*.4.;sqrt2*.6.;sqrt2*.2.5;sqrt2];
    [sqrt2*.4.;sqrt2*.6.;sqrt2*.3.0;sqrt2] ];
  [ [4.;5.2;2.;1.];[4.;4.6;2.5;1.];[4.;5.2;3.0;1.] ];
  [ [sqrt2*.4.;sqrt2*.6.;sqrt2*.2.;sqrt2];
    [sqrt2*.4.;sqrt2*.6.;sqrt2*.2.5;sqrt2];
    [sqrt2*.4.;sqrt2*.6.;sqrt2*.3.0;sqrt2] ];
  [ [2.8;6.7;2.;1.];[2.8;6.7;2.5;1.];[2.8;6.7;3.0;1.] ];
  [ [sqrt2*.2.;sqrt2*.6.;sqrt2*.2.;sqrt2];
    [sqrt2*.2.;sqrt2*.6.;sqrt2*.2.5;sqrt2];
    [sqrt2*.2.;sqrt2*.6.;sqrt2*.3.0;sqrt2] ];
  [ [2.;5.;2.;1.];[2.;5.;2.5;1.];[2.;5.;3.0;1.] ];
  [ [3.;4.;2.;1.];[3.;4.;2.5;1.];[3.;4.;3.0;1.] ];
  [ [4.;2.;2.;1.];[4.;1.6;2.5;1.];[4.;2.;3.0;1.] ];
]

let ctlpoints = Array.of_list(List.flatten(List.flatten _ctlpoints))


(*  Initialize material property, light source, lighting model,
 *  and depth buffer.
 *)
let myinit() =
  let mat_ambient = (1.0, 1.0, 1.0, 1.0)
  and mat_diffuse = (1.0, 0.2, 1.0, 1.0)
  and mat_specular = (1.0, 1.0, 1.0, 1.0)
  and mat_shininess = (50.0) in

  let light0_position = ( 1.0, 0.1, 1.0, 0.0)
  and light1_position = (-1.0, 0.1, 1.0, 0.0) in

  let lmodel_ambient = (0.3, 0.3, 0.3, 1.0) in

  glMaterial GL_FRONT (Material.GL_AMBIENT mat_ambient);
  glMaterial GL_FRONT (Material.GL_DIFFUSE mat_diffuse);
  glMaterial GL_FRONT (Material.GL_SPECULAR mat_specular);
  glMaterial GL_FRONT (Material.GL_SHININESS mat_shininess);
  glLight (GL_LIGHT 0) (Light.GL_POSITION light0_position);
  glLight (GL_LIGHT 1) (Light.GL_POSITION light1_position);
  glLightModel (GL_LIGHT_MODEL_AMBIENT lmodel_ambient);

  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;
  glEnable GL_LIGHT1;
  glDepthFunc GL_LESS;
  glEnable GL_DEPTH_TEST;
  glEnable GL_AUTO_NORMAL;

  let theNurb = gluNewNurbsRenderer() in

  gluNurbsProperty theNurb (GLU_SAMPLING_TOLERANCE  25.0);
  gluNurbsProperty theNurb (GLU_DISPLAY_MODE  Disp.GLU_FILL);

  (theNurb)
;;

let display theNurb () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  glPushMatrix();
  glTranslate 4.0 4.5 2.5;
  glRotate 220.0  1.0 0.0 0.0;
  glRotate 115.0  0.0 1.0 0.0;
  glTranslate (-4.) (-4.5) (-2.5);

  gluBeginSurface theNurb;
  gluNurbsSurface theNurb
          sknots tknots
          (4 * t_numpoints)
          4
          ctlpoints
          s_order t_order
          GLU_MAP2_VERTEX_4;
  gluEndSurface theNurb;

  glPopMatrix();
  glFlush();
;;

let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glFrustum (-1.0) 1.0 (-1.5) 0.5 0.8 10.0;

  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
  gluLookAt 7.0 4.5 4.0  4.5 4.5 2.0  6.0 (-3.0) 2.0;
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
 *  RGBA display mode, and handle input events.
 *)
let () =
  let _ = glutInit Sys.argv in
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB; GLUT_DEPTH];
  let _ = glutCreateWindow Sys.argv.(0) in
  let theNurb = myinit() in
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display:(display theNurb);
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

