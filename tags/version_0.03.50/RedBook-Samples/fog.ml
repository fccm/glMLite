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

(*  fog.ml
 *  This program draws 5 red teapots, each at a different
 *  z distance from the eye, in different types of fog.
 *  Pressing the left mouse button chooses between 3 types of
 *  fog:  exponential, exponential squared, and linear.
 *  In this program, there is a fixed density value, as well
 *  as fixed start and end values for the linear fog.
 *)

(* Ported from C to OCaml by Florent Monnier *)

open GL
open Glu
open Glut

let selectFog ~value =
  match value with
  | 2 ->
      glFog (GL_FOG_MODE GL_LINEAR);
      glFog (GL_FOG_START 1.0);
      glFog (GL_FOG_END 5.0);
  | 0 ->
      glFog (GL_FOG_MODE GL_EXP);
      glutPostRedisplay();
  | 1 ->
      glFog (GL_FOG_MODE GL_EXP2);
      glutPostRedisplay();
  | 3 ->
      exit(0);
  | _ -> ()
;;

(*  Initialize z-buffer, projection matrix, light source,
 *  and lighting model.  Do not specify a material property here.
 *)
let myinit() =
  let position = (0.0, 3.0, 3.0, 0.0)
  and local_view = false in

  glEnable GL_DEPTH_TEST;
  glDepthFunc GL_LESS;

  glLight (GL_LIGHT 0) (Light.GL_POSITION position);
  glLightModel (GL_LIGHT_MODEL_LOCAL_VIEWER local_view);

  glFrontFace GL_CW;
  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;
  glEnable GL_AUTO_NORMAL;
  glEnable GL_NORMALIZE;
  glEnable GL_FOG;
  begin
    let fogColor = (0.5, 0.5, 0.5, 1.0) in

    let fogMode = GL_EXP in
    glFog (GL_FOG_MODE fogMode);
    glFog (GL_FOG_COLOR fogColor);
    glFog (GL_FOG_DENSITY 0.35);
    glHint GL_FOG_HINT GL_DONT_CARE;
    glClearColor 0.5 0.5 0.5 1.0;
  end;
;;


let renderRedTeapot ~x ~y ~z =
  glPushMatrix();
  glTranslate x y z;
  let mat = (0.1745, 0.01175, 0.01175, 1.0) in
  glMaterial GL_FRONT (Material.GL_AMBIENT mat);
  let mat = (0.61424, 0.04136, 0.04136, 1.0) in
  glMaterial GL_FRONT (Material.GL_DIFFUSE mat);
  let mat = (0.727811, 0.626959, 0.626959, 1.0) in
  glMaterial GL_FRONT (Material.GL_SPECULAR mat);
  glMaterial GL_FRONT (Material.GL_SHININESS (0.6 *. 128.0));
  glutSolidTeapot(1.0);
  glPopMatrix();
;;

(*  display() draws 5 teapots at different z positions.
 *)
let display() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  renderRedTeapot (-4.0) (-0.5) (-1.0);
  renderRedTeapot (-2.0) (-0.5) (-2.0);
  renderRedTeapot ( 0.0) (-0.5) (-3.0);
  renderRedTeapot ( 2.0) (-0.5) (-4.0);
  renderRedTeapot ( 4.0) (-0.5) (-5.0);
  glFlush();
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if (w <= (h * 3)) then
      glOrtho (-6.0) 6.0 (-2.0 *. float(h * 3) /. float w)
              (2.0 *. float(h * 3) /. float w) 0.0 10.0
  else
      glOrtho ((-6.0) *. float w /. float(h * 3))
              (6.0 *. float w /. float(h * 3)) (-2.0) 2.0 0.0 10.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0
  | _ -> ()
;;


(*  Main Loop
 *  Open window with initial window size, title bar,
 *  RGBA display mode, depth buffer, and handle input events.
 *)
let () =
  let _ = glutInit Sys.argv in
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB; GLUT_DEPTH];
  glutInitWindowSize 450 150;
  let _ = glutCreateWindow Sys.argv.(0) in
  myinit();
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display;
  let _ = glutCreateMenu selectFog in
  glutAddMenuEntry "Fog EXP" 0;
  glutAddMenuEntry "Fog EXP2" 1;
  glutAddMenuEntry "Fog LINEAR" 2;
  glutAddMenuEntry "Quit" 3;
  glutAttachMenu GLUT_RIGHT_BUTTON;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

