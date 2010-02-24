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

(*  aapoly.ml
 *  This program draws filled polygons with antialiased
 *  edges.  The special GL_SRC_ALPHA_SATURATE blending 
 *  function is used.
 *  Pressing the 't' key turns the antialiasing on and off.
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glu
open Glut

open VertArray

let polySmooth = ref true

let init() =
  glCullFace GL_BACK;
  glEnable GL_CULL_FACE;
  glBlendFunc Sfactor.GL_SRC_ALPHA_SATURATE  Dfactor.GL_ONE;
  glClearColor 0.0 0.0 0.0 0.0;
;;


let nface = 6
let nvert = 8

let ba2_to_ba1 b =
  let g = Bigarray.genarray_of_array2 b
  and d1 = Bigarray.Array2.dim1 b
  and d2 = Bigarray.Array2.dim2 b in
  Bigarray.reshape_1 g (d1 * d2)
;;

let drawCube ~x0 ~x1 ~y0 ~y1 ~z0 ~z1 =
  let c = Bigarray.Array2.of_array Bigarray.float32 Bigarray.c_layout
    [|
      [| 0.0; 0.0; 0.0; 1.0 |];  [| 1.0; 0.0; 0.0; 1.0 |];
      [| 0.0; 1.0; 0.0; 1.0 |];  [| 1.0; 1.0; 0.0; 1.0 |];
      [| 0.0; 0.0; 1.0; 1.0 |];  [| 1.0; 0.0; 1.0; 1.0 |];
      [| 0.0; 1.0; 1.0; 1.0 |];  [| 1.0; 1.0; 1.0; 1.0 |];
    |] in
  let colors = ba2_to_ba1 c in

  (* indices of front, top, left, bottom, right, back faces *)
  let ndx = Bigarray.Array2.of_array Bigarray.int16_unsigned Bigarray.c_layout
    [|
      [| 4; 5; 6; 7 |];  [| 2; 3; 7; 6 |];  [| 0; 4; 7; 3 |];
      [| 0; 1; 5; 4 |];  [| 1; 5; 6; 2 |];  [| 0; 3; 2; 1 |];
    |] in
  let indices = ba2_to_ba1 ndx in

  let v = Bigarray.Array2.create Bigarray.float32 Bigarray.c_layout 8 3 in

  (*
  let ba2_set ba i j v = Bigarray.Array2.set ba i j v in

  List.iter (fun (i,j) -> ba2_set v i j  x0)  [(0,0); (3,0); (4,0); (7,0)];
  List.iter (fun (i,j) -> ba2_set v i j  x1)  [(1,0); (2,0); (5,0); (6,0)];
  List.iter (fun (i,j) -> ba2_set v i j  y0)  [(0,1); (1,1); (4,1); (5,1)];
  List.iter (fun (i,j) -> ba2_set v i j  y1)  [(2,1); (3,1); (6,1); (7,1)];
  List.iter (fun (i,j) -> ba2_set v i j  z0)  [(0,2); (1,2); (2,2); (3,2)];
  List.iter (fun (i,j) -> ba2_set v i j  z1)  [(4,2); (5,2); (6,2); (7,2)];
  *)

  v.{0,0} <- x0;  v.{3,0} <- x0;  v.{4,0} <- x0;  v.{7,0} <- x0;
  v.{1,0} <- x1;  v.{2,0} <- x1;  v.{5,0} <- x1;  v.{6,0} <- x1;
  v.{0,1} <- y0;  v.{1,1} <- y0;  v.{4,1} <- y0;  v.{5,1} <- y0;
  v.{2,1} <- y1;  v.{3,1} <- y1;  v.{6,1} <- y1;  v.{7,1} <- y1;
  v.{0,2} <- z0;  v.{1,2} <- z0;  v.{2,2} <- z0;  v.{3,2} <- z0;
  v.{4,2} <- z1;  v.{5,2} <- z1;  v.{6,2} <- z1;  v.{7,2} <- z1;

  let vertices = ba2_to_ba1 v in

  glEnableClientState GL_VERTEX_ARRAY;
  glEnableClientState GL_COLOR_ARRAY;

    glVertexPointer 3  Coord.GL_FLOAT 0 vertices;
    glColorPointer 4  Color.GL_FLOAT 0 colors;

    (*
    use  Bigarray.int16_unsigned  with  Elem.GL_UNSIGNED_SHORT
    or   Bigarray.int8_unsigned   with  Elem.GL_UNSIGNED_BYTE
    *)
    glDrawElements GL_QUADS (nface * 4) Elem.GL_UNSIGNED_SHORT indices;

  glDisableClientState GL_VERTEX_ARRAY;
  glDisableClientState GL_COLOR_ARRAY;
;;


(*  Note:  polygons must be drawn from front to back
 *  for proper blending.
 *)
let display() =
  if (!polySmooth) then begin
    glClear [GL_COLOR_BUFFER_BIT];
    glEnable GL_BLEND;
    glEnable GL_POLYGON_SMOOTH;
    glDisable GL_DEPTH_TEST;
  end
  else begin
    glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
    glDisable GL_BLEND;
    glDisable GL_POLYGON_SMOOTH;
    glEnable GL_DEPTH_TEST;
  end;

  glPushMatrix();
    glTranslate 0.0 0.0 (-8.0);    
    glRotate 30.0 1.0 0.0 0.0;
    glRotate 60.0 0.0 1.0 0.0; 
    drawCube (-0.5) (0.5) (-0.5) (0.5) (-0.5) (0.5);
  glPopMatrix();

  glFlush ();
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 30.0 ((float w) /. (float h)) 1.0 20.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let keyboard ~key ~x ~y =
  match key with
  | 'T' | 't' ->
      polySmooth := not(!polySmooth);
      glutPostRedisplay();
  | '\027' ->
      exit 0;  (*  Escape key  *)
  | _ -> ()
;;


(* Main Loop *)
let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB;
                       GLUT_ALPHA; GLUT_DEPTH];
  glutInitWindowSize 200 200;
  ignore(glutCreateWindow Sys.argv.(0));

  let gl_version = glGetString GL_VERSION in
  if gl_version < "1.1" then begin
    Printf.eprintf "If this is GL Version 1.0, \
                    vertex arrays are not supported.\n%!";
    exit 1;
  end;

  init();
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutDisplayFunc ~display;
  glutMainLoop();
;;

