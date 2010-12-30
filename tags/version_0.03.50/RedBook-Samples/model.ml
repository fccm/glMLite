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

(*  model.ml
 *  This program demonstrates modeling transformations
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glu
open Glut

let init() =
  glClearColor 0.0 0.0 0.0 0.0;
  glShadeModel GL_FLAT;
;;


let draw_triangle() =
  glBegin GL_LINE_LOOP;
  glVertex2 (  0.0) ( 25.0);
  glVertex2 ( 25.0) (-25.0);
  glVertex2 (-25.0) (-25.0);
  glEnd();
;;


let display() =
  glClear [GL_COLOR_BUFFER_BIT];
  glColor3 1.0 1.0 1.0;

  glLoadIdentity();
  glColor3 1.0 1.0 1.0;
  draw_triangle();

  glEnable GL_LINE_STIPPLE;

  glLineStipple 1  0xF0F0;
  glLoadIdentity();
  glTranslate (-20.0) 0.0 0.0;
  draw_triangle();

  glLineStipple 1  0xF00F;
  glLoadIdentity();
  glScale 1.5 0.5 1.0;
  draw_triangle();

  glLineStipple 1  0x8888;
  glLoadIdentity();
  glRotate 90.0  0.0 0.0 1.0;
  draw_triangle();

  glDisable GL_LINE_STIPPLE;

  glFlush ();
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if (w <= h) then
    glOrtho (-50.0) (50.0) (-50.0 *. (float h) /. (float w))
                           ( 50.0 *. (float h) /. (float w)) (-1.0) (1.0)
  else
    glOrtho (-50.0 *. (float w) /. (float h))
            ( 50.0 *. (float w) /. (float h)) (-50.0) (50.0) (-1.0) (1.0);

  glMatrixMode GL_MODELVIEW;
;;


let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0;
  | _ -> ()
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 500 500;
  glutInitWindowPosition 100 100;
  ignore(glutCreateWindow Sys.argv.(0));
  init();
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

