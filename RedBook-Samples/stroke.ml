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

(*  stroke.ml
 *  This program demonstrates some characters of a
 *  stroke (vector) font.  The characters are represented
 *  by display lists, which are given numbers which
 *  correspond to the ASCII values of the characters.
 *  Use of glCallLists() is demonstrated.
 *)
open GL
open Glu
open Glut

type t =
  | PT
  | STROKE
  | END

let a_data = [
  (0, 0, PT); (0, 9, PT); (1, 10, PT); (4, 10, PT);
  (5, 9, PT); (5, 0, STROKE); (0, 5, PT); (5, 5, END)
]

let e_data = [
  (5, 0, PT); (0, 0, PT); (0, 10, PT); (5, 10, STROKE);
  (0, 5, PT); (4, 5, END)
]

let p_data = [
  (0, 0, PT); (0, 10, PT);  (4, 10, PT); (5, 9, PT); (5, 6, PT);
  (4, 5, PT); (0, 5, END)
]

let r_data = [
 (0, 0, PT); (0, 10, PT);  (4, 10, PT); (5, 9, PT); (5, 6, PT);
 (4, 5, PT); (0, 5, STROKE); (3, 5, PT); (5, 0, END)
]

let s_data = [
  (0, 1, PT); (1, 0, PT); (4, 0, PT); (5, 1, PT); (5, 4, PT);
  (4, 5, PT); (1, 5, PT); (0, 6, PT); (0, 9, PT); (1, 10, PT);
  (4, 10, PT); (5, 9, END)
]

(*  drawLetter() interprets the instructions from the array
 *  for that letter and renders the letter with line segments.
 *)
let drawLetter li =
  glBegin GL_LINE_STRIP;
  List.iter (function
  | (x, y, PT) ->
      let x, y = float x, float y in
      glVertex2 ~x ~y;
  | (x, y, STROKE) ->
      let x, y = float x, float y in
      glVertex2 ~x ~y;
      glEnd();
      glBegin GL_LINE_STRIP;
  | (x, y, END) ->
      let x, y = float x, float y in
      glVertex2 ~x ~y;
      glEnd();
      glTranslate 8.0 0.0 0.0;
  ) li
;;

(* Create a display list for each of 6 characters *)
let myinit () =
  glShadeModel GL_FLAT;

  let base = glGenLists 128 in
  glListBase base;
  glNewList (base + Char.code 'A') GL_COMPILE;  drawLetter a_data; glEndList();
  glNewList (base + Char.code 'E') GL_COMPILE;  drawLetter e_data; glEndList();
  glNewList (base + Char.code 'P') GL_COMPILE;  drawLetter p_data; glEndList();
  glNewList (base + Char.code 'R') GL_COMPILE;  drawLetter r_data; glEndList();
  glNewList (base + Char.code 'S') GL_COMPILE;  drawLetter s_data; glEndList();
  glNewList (base + Char.code ' ') GL_COMPILE;  glTranslate 8.0 0.0 0.0; glEndList();
;;

let test1 = "A SPARE SERAPE APPEARS AS"
let test2 = "APES PREPARE RARE PEPPERS"

let explode s =
  Array.init (String.length s) (fun i -> s.[i])

let printStrokedString s =
  glCallLists (Array.map Char.code (explode s));
;;

let display() =
  glClear [GL_COLOR_BUFFER_BIT];
  glColor3 1.0 1.0 1.0;
  glPushMatrix();
  glScale 2.0 2.0 2.0;
  glTranslate 10.0 30.0 0.0;
  printStrokedString test1;
  glPopMatrix();
  glPushMatrix();
  glScale 2.0 2.0 2.0;
  glTranslate 10.0 13.0 0.0;
  printStrokedString test2;
  glPopMatrix();
  glFlush();
;;

let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glOrtho 0.0 (float w) 0.0 (float h) (-1.0) (1.0);
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
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
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 440 120;
  let _ = glutCreateWindow Sys.argv.(0) in
  myinit ();
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

