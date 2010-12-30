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

(*  aargb.ml
 *  This program draws shows how to draw anti-aliased lines. It draws
 *  two diagonal lines to form an X; when 'r' is typed in the window, 
 *  the lines are rotated in opposite directions.
 *)

(* Ported from C to OCaml by Florent Monnier *)

open GL
open Glu
open Glut

let rotAngle = ref 0.0

(*  Initialize antialiasing for RGBA mode, including alpha
 *  blending, hint, and line width.  Print out implementation
 *  specific info on line width granularity and width.
 *)
let init() =
  let v = glGetFloat1 Get.GL_LINE_WIDTH_GRANULARITY in
  Printf.printf "GL_LINE_WIDTH_GRANULARITY value is %3.1f\n%!" v;

  let v1, v2 = glGetFloat2 Get.GL_LINE_WIDTH_RANGE in
  Printf.printf "GL_LINE_WIDTH_RANGE values are %3.1f %3.1f\n%!" v1 v2;

  glEnable GL_LINE_SMOOTH;
  glEnable GL_BLEND;
  glBlendFunc Sfactor.GL_SRC_ALPHA  Dfactor.GL_ONE_MINUS_SRC_ALPHA;
  glHint GL_LINE_SMOOTH_HINT  GL_DONT_CARE;
  glLineWidth 1.5;

  glClearColor 0.0 0.0 0.0 0.0;
;;

(* Draw 2 diagonal lines to form an X *)
let display() =
  glClear[GL_COLOR_BUFFER_BIT];

  glColor3 0.0 1.0 0.0;
  glPushMatrix();
  glRotate (-. !rotAngle) 0.0 0.0 0.1;
  glBegin GL_LINES;
    glVertex2 (-0.5) ( 0.5);
    glVertex2 ( 0.5) (-0.5);
  glEnd();
  glPopMatrix();

  glColor3 0.0 0.0 1.0;
  glPushMatrix();
  glRotate !rotAngle 0.0 0.0 0.1;
  glBegin GL_LINES;
    glVertex2 ( 0.5) ( 0.5);
    glVertex2 (-0.5) (-0.5);
  glEnd ();
  glPopMatrix();

  glFlush();
;;

let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if (w <= h) then
     gluOrtho2D (-1.0) 1.0
                (-1.0 *. float h /. float w)
                ( 1.0 *. float h /. float w)
  else 
     gluOrtho2D (-1.0 *. float w /. float h)
                ( 1.0 *. float w /. float h) (-1.0) 1.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;

(* ARGSUSED1 *)
let keyboard ~key ~x ~y =
  match key with
  | 'r'
  | 'R' ->
      rotAngle := !rotAngle +. 10.;
      if (!rotAngle >= 360.) then rotAngle := 0.;
      glutPostRedisplay();	
  | '\027' ->  (*  Escape Key  *)
      exit(0);
  | _ -> ()
;;

(*  Main Loop
 *  Open window with initial window size, title bar, 
 *  RGBA display mode, and handle input events.
 *)
let () =
  let _ = glutInit Sys.argv in
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 200 200;
  let _ = glutCreateWindow Sys.argv.(0) in
  init();
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutDisplayFunc ~display;
  glutMainLoop();
;;

