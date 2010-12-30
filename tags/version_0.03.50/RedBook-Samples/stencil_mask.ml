(* Copyright (c) 1991, 1992, 1993 Silicon Graphics, Inc.
 *
 * Permission to use, copy, modify, distribute, and sell this software and
 * its documentation for any purpose is hereby granted without fee, provided
 * that (i) the above copyright notices and this permission notice appear in
 * all copies of the software and related documentation, and (ii) the name of
 * Silicon Graphics may not be used in any advertising or
 * publicity relating to the software without the specific, prior written
 * permission of Silicon Graphics.
 *
 * THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF
 * ANY KIND,
 * EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY
 * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
 *
 * IN NO EVENT SHALL SILICON GRAPHICS BE LIABLE FOR
 * ANY SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND,
 * OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
 * WHETHER OR NOT ADVISED OF THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF
 * LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
 * OF THIS SOFTWARE.
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glu
open Glut

let init() =
  glShadeModel GL_FLAT;
  glClearColor 0.0 0.0 0.0 0.0;

  glClearStencil 0;
  glStencilMask 1;
  glEnable GL_STENCIL_TEST;
;;


let reshape ~width ~height =
  glViewport 0 0 width height;

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glOrtho (-5.0) (5.0) (-5.0) (5.0) (-5.0) (5.0);
  glMatrixMode GL_MODELVIEW;
;;


let keyboard ~key ~x ~y =
  match key with '\027' -> exit 0 | _ -> ()
;;


let display () =
  glClear [GL_COLOR_BUFFER_BIT; GL_STENCIL_BUFFER_BIT];

  glStencilFunc GL_ALWAYS  1 1;
  glStencilOp GL_KEEP  GL_KEEP  GL_REPLACE;

  glColor3c '\200' '\000' '\000';
  glBegin GL_POLYGON;
    glVertex3 (-4.) (-4.) (0.);
    glVertex3 ( 4.) (-4.) (0.);
    glVertex3 ( 0.) ( 4.) (0.);
  glEnd();

  glStencilFunc GL_EQUAL  1  1;
  glStencilOp GL_INCR  GL_KEEP  GL_DECR;

  glColor3c '\000' '\200' '\000';
  glBegin GL_POLYGON;
    glVertex3 ( 3.) ( 3.) (0.);
    glVertex3 (-3.) ( 3.) (0.);
    glVertex3 (-3.) (-3.) (0.);
    glVertex3 ( 3.) (-3.) (0.);
  glEnd();

  glStencilFunc GL_EQUAL  1  1;
  glStencilOp GL_KEEP  GL_KEEP  GL_KEEP;

  glColor3c '\000' '\000' '\200';
  glBegin GL_POLYGON;
    glVertex3 ( 3.) ( 3.) (0.);
    glVertex3 (-3.) ( 3.) (0.);
    glVertex3 (-3.) (-3.) (0.);
    glVertex3 ( 3.) (-3.) (0.);
  glEnd();

  glFlush();
;;


let args ~argv =
  let argc = Array.length argv in
  for i = 1 to pred argc do
    if argv.(i) = "-dr" then ()
    else
      invalid_arg(Printf.sprintf "%s (Bad option)." argv.(i));
  done;
;;


let () =
  let argv = glutInit Sys.argv in
  args ~argv;

  glutInitWindowPosition 0 0;
  glutInitWindowSize 300 300;

  let type_ = [GLUT_RGB; GLUT_SINGLE; GLUT_STENCIL] in
  glutInitDisplayMode type_;

  ignore(glutCreateWindow "Stencil Test");

  init();

  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutDisplayFunc ~display;
  glutMainLoop();
;;

