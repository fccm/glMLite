(*
  Copyright (c) 1993-1997, Silicon Graphics, Inc.
  ALL RIGHTS RESERVED 
  Permission to use, copy, modify, and distribute this software for 
  any purpose and without fee is hereby granted, provided that the above
  copyright notice appear in all copies and that both the copyright notice
  and this permission notice appear in supporting documentation, and that 
  the name of Silicon Graphics, Inc. not be used in advertising
  or publicity pertaining to distribution of the software without specific,
  written prior permission. 

  THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"
  AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,
  INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR
  FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL SILICON
  GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,
  SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY
  KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,
  LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF
  THIRD PARTIES, WHETHER OR NOT SILICON GRAPHICS, INC.  HAS BEEN
  ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE
  POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.

  US Government Users Restricted Rights 
  Use, duplication, or disclosure by the Government is subject to
  restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
  (c)(1)(ii) of the Rights in Technical Data and Computer Software
  clause at DFARS 252.227-7013 and/or in similar or successor
  clauses in the FAR or the DOD or NASA FAR Supplement.
  Unpublished-- rights reserved under the copyright laws of the
  United States.  Contractor/manufacturer is Silicon Graphics,
  Inc., 2011 N.  Shoreline Blvd., Mountain View, CA 94039-7311.

  OpenGL(R) is a registered trademark of Silicon Graphics, Inc.
*)

(*  bezcurve.ml
 *  This program uses evaluators to draw a Bezier curve.
 *)

(* OCaml version by Florent Monnier *)

open GL ;;
open Glu ;;
open Glut ;;

let ctrlpoints = [|
    -4.0; -4.0; 0.0;
    -2.0;  4.0; 0.0; 
     2.0; -4.0; 0.0;
     4.0;  4.0; 0.0;
  |]
;;

let init() =
  glClearColor 0.0  0.0  0.0  0.0;
  glShadeModel GL_FLAT;
  glMap1 Map1.GL_MAP1_VERTEX_3  0.0  1.0  3  4  ctrlpoints;
  glEnable GL_MAP1_VERTEX_3;
;;


let display() =
  glClear[GL_COLOR_BUFFER_BIT];
  glColor3 1.0  1.0  1.0;
  glBegin GL_LINE_STRIP;
    for i = 0 to 30 do
      glEvalCoord1(float i /. 30.0);
    done;
  glEnd();
  (* The following code displays the control points as dots. *)
  glPointSize 5.0;
  glColor3  1.0  1.0  0.0;
  glBegin GL_POINTS;
    for i = 0 to pred 4 do
      glVertex3 ctrlpoints.(i*3+0) ctrlpoints.(i*3+1) ctrlpoints.(i*3+2);
    done;
  glEnd();
  glFlush();
;;


let reshape  ~width ~height =
  glViewport 0  0  width height;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if width <= height then
    glOrtho (-5.0) 5.0 (-5.0 *. float height /. float width)
            ( 5.0 *. float height /. float width) (-5.0) 5.0
  else
    glOrtho (-5.0 *. float width /. float height) 
            ( 5.0 *. float width /. float height) (-5.0) 5.0 (-5.0) 5.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let keyboard ~key ~x ~y =
  match key with 'q' | '\027' -> exit 0 | _ -> ()
;;


let main =
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

