(* Copyright (c) 1993-1997, Silicon Graphics, Inc.
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
 * OpenGL(R) is a registered trademark of Silicon Graphics, Inc.
 *)

(*  double.ml
 *  This is a simple double buffered program.
 *  Pressing the left mouse button rotates the rectangle.
 *  Pressing the middle mouse button stops the rotation.
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glu
open Glut

let spin = ref 0.0
let t0 = ref 0.0

let display() =
  glClear [GL_COLOR_BUFFER_BIT];
  glPushMatrix();
  glRotate !spin  0.0 0.0 1.0;
  glColor3 1.0 1.0 1.0;
  glRect (-25.0) (-25.0) (25.0) (25.0);
  glPopMatrix();

  glutSwapBuffers();
;;


let gettime() =
  (float (glutGet GLUT_ELAPSED_TIME)) /. 1000.
;;


let spinDisplay() =
  let t = gettime() in
  let dt = t -. !t0 in
  t0 := t;
  spin := !spin +. 120.0 *. dt;
  if !spin > 360.0 then
    spin := !spin -. 360.0;
  glutPostRedisplay();
;;


let init() =
  glClearColor 0.0 0.0 0.0 0.0;
  glShadeModel GL_FLAT;
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glOrtho (-50.0) (50.0) (-50.0) (50.0) (-1.0) (1.0);
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let mouse ~button ~state ~x ~y =
  match button, state with
  | GLUT_LEFT_BUTTON, GLUT_DOWN ->
      t0 := gettime();
      glutIdleFunc spinDisplay;

  | GLUT_MIDDLE_BUTTON, GLUT_DOWN ->
      glutRemoveIdleFunc();
  | _ -> ()
;;


let keyboard ~key ~x ~y =
  begin match key with
  | '\027' ->  (* Escape *)
      exit 0;
  | _ -> ()
  end;
  glutPostRedisplay();
;;


(*  Request double buffer display mode.
 *  Register mouse input callback functions
 *)
let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_DOUBLE; GLUT_RGB];
  glutInitWindowSize 250 250;
  glutInitWindowPosition 100 100;
  ignore(glutCreateWindow Sys.argv.(0));
  init();
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutMouseFunc ~mouse;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

