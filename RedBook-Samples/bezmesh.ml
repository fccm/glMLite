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

(*  bezmesh.ml
 *  This program renders a lighted, filled Bezier surface,
 *  using two-dimensional evaluators.
 *)

(* OCaml version by Florent Monnier
 *
 * This file was converted from C, the original file is available here:
 * http://www.opengl.org/resources/code/samples/redbook/bezmesh.c
 *)

open GL ;;
open Glu ;;
open Glut ;;

let ctrlpoints = [|
  [| [| -1.5; -1.5;  4.0; |];
     [| -0.5; -1.5;  2.0; |];
     [|  0.5; -1.5; -1.0; |];
     [|  1.5; -1.5;  2.0; |] |];
    
  [| [| -1.5; -0.5;  1.0; |];
     [| -0.5; -0.5;  3.0; |];
     [|  0.5; -0.5;  0.0; |];
     [|  1.5; -0.5; -1.0; |] |];
    
  [| [| -1.5;  0.5;  4.0; |];
     [| -0.5;  0.5;  0.0; |];
     [|  0.5;  0.5;  3.0; |];
     [|  1.5;  0.5;  4.0; |] |];
    
  [| [| -1.5;  1.5; -2.0; |];
     [| -0.5;  1.5; -2.0; |];
     [|  0.5;  1.5;  0.0; |];
     [|  1.5;  1.5; -1.0; |] |];
|]
;;


let initlights() =
  let ambient = (0.2, 0.2, 0.2, 1.0)
  and position = (0.0, 0.0, 2.0, 1.0)
  and mat_diffuse = (0.6, 0.6, 0.6, 1.0)
  and mat_specular = (1.0, 1.0, 1.0, 1.0)
  and mat_shininess = (50.0)
  in
  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;

  glLight (GL_LIGHT 0) (Light.GL_AMBIENT ambient);
  glLight (GL_LIGHT 0) (Light.GL_POSITION position);

  glMaterial GL_FRONT (Material.GL_DIFFUSE mat_diffuse);
  glMaterial GL_FRONT (Material.GL_SPECULAR mat_specular);
  glMaterial GL_FRONT (Material.GL_SHININESS mat_shininess);
;;


let display() =
  glClear[GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glPushMatrix();
  glRotate  85.0  1.0  1.0  1.0;
  glEvalMesh2 EvalMesh2.GL_FILL 0 20  0 20;
  glPopMatrix();
  glFlush();
;;


let init() =
  glClearColor 0.0 0.0 0.0 0.0;
  glEnable GL_DEPTH_TEST;
  glMap2 Map2.GL_MAP2_VERTEX_3  0.0 1.0  3 4
          0.0 1.0  12 4  ctrlpoints;
  glEnable GL_MAP2_VERTEX_3;
  glEnable GL_AUTO_NORMAL;
  glMapGrid2 20  0.0 1.0  20  0.0 1.0;
  initlights();       (* for lighted version only *)
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  if w <= h then
    glOrtho (-4.0) (4.0)
            (-4.0 *. (float h) /. (float w))
            (4.0 *. (float h) /. (float w)) (-4.0) (4.0)
  else
    glOrtho (-4.0 *. (float w) /. (float h))
            (4.0 *. (float w) /. (float h)) (-4.0) (4.0) (-4.0) (4.0);

  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let keyboard ~key ~x ~y =
  match key with '\027' -> exit 0 | _ -> ()
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode[GLUT_SINGLE; GLUT_RGB; GLUT_DEPTH];
  glutInitWindowSize 500 500;
  glutInitWindowPosition 100 100;
  ignore(glutCreateWindow Sys.argv.(0));
  init();
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;


