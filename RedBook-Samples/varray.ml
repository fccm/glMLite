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

(*  varray.ml
 *  This program demonstrates vertex arrays.
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glu
open Glut
open VertArray

let pointer = 1
let interleaved = 2

let drawarray = 1
let arrayelement = 2
let drawelements = 3

let setupMethod = ref pointer
let derefMethod = ref drawarray


let setupPointers() =
  let vertices =
    Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
    [|  25.;  25.;
       100.; 325.;
       175.;  25.;
       175.; 325.;
       250.;  25.;
       325.; 325.; |]

  and colors =
    Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
    [| 1.0;  0.2;  0.2;
       0.2;  0.2;  1.0;
       0.8;  1.0;  0.2;
       0.75; 0.75; 0.75;
       0.35; 0.35; 0.35;
       0.5;  0.5;  0.5; |] in

  glEnableClientState GL_VERTEX_ARRAY;
  glEnableClientState GL_COLOR_ARRAY;

  glVertexPointer 2  Coord.GL_FLOAT  0  vertices;
  glColorPointer 3  Color.GL_FLOAT  0  colors;
;;


let setupInterleave() =
  let intertwined =
    Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
    [| 1.0; 0.2; 1.0;  100.0; 100.0; 0.0;
       1.0; 0.2; 0.2;    0.0; 200.0; 0.0;
       1.0; 1.0; 0.2;  100.0; 300.0; 0.0;
       0.2; 1.0; 0.2;  200.0; 300.0; 0.0;
       0.2; 1.0; 1.0;  300.0; 200.0; 0.0;
       0.2; 0.2; 1.0;  200.0; 100.0; 0.0; |] in
  
  glInterleavedArrays GL_C3F_V3F  0  intertwined;
;;


let init() =
  glClearColor 0.0 0.0 0.0 0.0;
  glShadeModel GL_SMOOTH;
  setupPointers();
;;


let display() =
  glClear [GL_COLOR_BUFFER_BIT];

  if (!derefMethod = drawarray) then
    glDrawArrays GL_TRIANGLES  0 6

  else if (!derefMethod = arrayelement) then begin
     glBegin GL_TRIANGLES;
     glArrayElement 2;
     glArrayElement 3;
     glArrayElement 5;
     glEnd();
  end
  else if (!derefMethod = drawelements) then begin
    let indices =
      Bigarray.Array1.of_array Bigarray.nativeint Bigarray.c_layout
      [| 0n; 1n; 3n; 4n |]
    in

    glDrawElements GL_POLYGON  4  Elem.GL_UNSIGNED_INT  indices;
  end;

  glFlush ();
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluOrtho2D 0.0 (float w) 0.0 (float h);
;;


let mouse ~button ~state ~x ~y =
  match button, state with
  | GLUT_LEFT_BUTTON, GLUT_DOWN ->
      if (!setupMethod = pointer) then begin
        setupMethod := interleaved;
        setupInterleave();
      end
      else if (!setupMethod = interleaved) then begin
        setupMethod := pointer;
        setupPointers();
      end;
      glutPostRedisplay();

  | GLUT_MIDDLE_BUTTON, GLUT_DOWN
  | GLUT_RIGHT_BUTTON, GLUT_DOWN ->
      if (!derefMethod = drawarray) then
        derefMethod := arrayelement
      else if (!derefMethod = arrayelement) then
        derefMethod := drawelements
      else if (!derefMethod = drawelements) then
        derefMethod := drawarray;
      glutPostRedisplay();
  | _ -> ()
;;


let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0;
  | _ -> ()
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 350 350;
  glutInitWindowPosition 100 100;
  ignore(glutCreateWindow Sys.argv.(0));

  let gl_version = glGetString GL_VERSION in
  if gl_version < "1.1" then begin
    Printf.eprintf
        "This program demonstrates a feature which is not in OpenGL Version 1.0.\n\
         If your implementation of OpenGL Version 1.0 has the right extensions,\n\
         you may be able to modify this program to make it run.\n%!";
    exit 1;
  end;

  init ();
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutMouseFunc ~mouse;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

