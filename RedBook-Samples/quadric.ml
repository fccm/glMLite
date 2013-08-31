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

(*  quadric.ml
 *  This program demonstrates the use of some of the gluQuadric*
 *  routines. Quadric objects are created with some quadric
 *  properties and the callback routine to handle errors.
 *  Note that the cylinder has no top or bottom and the circle
 *  has a hole in it.
 *)

(* OCaml version by Florent Monnier
 *
 * This file was converted from C, the original file is available here:
 * http://www.opengl.org/resources/code/samples/redbook/quadric.c
 *)

open GL
open Glu
open Glut

(*
let errorCallback errorCode =
  let estring = gluErrorString errorCode in
  Printf.eprintf "Quadric Error: %s\n" estring;
  exit 0;
;;
*)

let init() =
  let mat_ambient = (0.5, 0.5, 0.5, 1.0)
  and mat_specular = (1.0, 1.0, 1.0, 1.0)
  and mat_shininess = (50.0)
  and light_position = (1.0, 1.0, 1.0, 0.0)
  and model_ambient = (0.5, 0.5, 0.5, 1.0)
  in
  glClearColor 0.0 0.0 0.0 0.0;

  glMaterial GL_FRONT (Material.GL_AMBIENT mat_ambient);
  glMaterial GL_FRONT (Material.GL_SPECULAR mat_specular);
  glMaterial GL_FRONT (Material.GL_SHININESS mat_shininess);
  glLight (GL_LIGHT 0) (Light.GL_POSITION light_position);
  glLightModel (GL_LIGHT_MODEL_AMBIENT model_ambient);

  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;
  glEnable GL_DEPTH_TEST;

(*  Create 4 display lists, each with a different quadric object.
 *  Different drawing styles and surface normal specifications
 *  are demonstrated.
 *)
  let startList = glGenLists ~range:4 in
  let qobj = gluNewQuadric() in
(*gluQuadricCallback qobj GLU_ERROR errorCallback; *)

  gluQuadricDrawStyle qobj GLU_FILL; (* smooth shaded *)
  gluQuadricNormals qobj GLU_SMOOTH;
  glNewList (startList) GL_COMPILE;
    gluSphere qobj 0.75 15 10;
  glEndList();

  gluQuadricDrawStyle qobj GLU_FILL; (* flat shaded *)
  gluQuadricNormals qobj GLU_FLAT;
  glNewList (startList+1) GL_COMPILE;
    gluCylinder qobj 0.5 0.3 1.0 15 5;
  glEndList();

  gluQuadricDrawStyle qobj GLU_LINE; (* all polygons wireframe *)
  gluQuadricNormals qobj GLU_NONE;
  glNewList (startList+2) GL_COMPILE;
    gluDisk qobj 0.25 1.0 20 4;
  glEndList();

  gluQuadricDrawStyle qobj GLU_SILHOUETTE; (* boundary only  *)
  gluQuadricNormals qobj GLU_NONE;
  glNewList (startList+3) GL_COMPILE;
    gluPartialDisk qobj 0.0 1.0 20 4 0.0 225.0;
  glEndList();

  (startList)
;;


let display startList () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glPushMatrix();

  glEnable GL_LIGHTING;
  glShadeModel GL_SMOOTH;
  glTranslate (-1.0) (-1.0) (0.0);
  glCallList(startList);

  glShadeModel GL_FLAT;
  glTranslate 0.0 2.0 0.0;
  glPushMatrix();
  glRotate 300.0 1.0 0.0 0.0;
  glCallList(startList+1);
  glPopMatrix();

  glDisable GL_LIGHTING;
  glColor3 0.0 1.0 1.0;
  glTranslate (2.0) (-2.0) (0.0);
  glCallList(startList+2);

  glColor3 1.0 1.0 0.0;
  glTranslate 0.0 2.0 0.0;
  glCallList(startList+3);

  glPopMatrix();
  glFlush();
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if (w <= h) then
    glOrtho (-2.5) (2.5) (-2.5 *. (float h) /. (float w))
            (2.5 *. (float h) /. (float w)) (-10.0) (10.0)
  else
    glOrtho (-2.5 *. (float w) /. (float h))
            (2.5 *. (float w) /. (float h)) (-2.5) (2.5) (-10.0) (10.0);

  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0;
  | _ -> ()
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode[GLUT_SINGLE; GLUT_RGB; GLUT_DEPTH];
  glutInitWindowSize 500 500;
  glutInitWindowPosition 100 100;
  ignore(glutCreateWindow Sys.argv.(0));
  let startList = init() in
  glutDisplayFunc ~display:(display startList);
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

