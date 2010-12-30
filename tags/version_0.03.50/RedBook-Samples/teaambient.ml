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

(*  teaambient.ml
 *  This program renders three lighted, shaded teapots, with
 *  different ambient values.
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glut

(* Initialize light source and lighting model. *)
let myinit() =
  let light_ambient = (0.0, 0.0, 0.0, 1.0)
  and light_diffuse = (1.0, 1.0, 1.0, 1.0)
  and light_specular = (1.0, 1.0, 1.0, 1.0)
  (* light_position is NOT default value *)
  and light_position = (1.0, 0.0, 0.0, 0.0)
  and global_ambient = (0.75, 0.75, 0.75, 1.0) in

  glLight (GL_LIGHT 0) (Light.GL_AMBIENT light_ambient);
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE light_diffuse);
  glLight (GL_LIGHT 0) (Light.GL_SPECULAR light_specular);
  glLight (GL_LIGHT 0) (Light.GL_POSITION light_position);

  glLightModel (GL_LIGHT_MODEL_AMBIENT global_ambient);

  glFrontFace GL_CW;
  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;
  glEnable GL_AUTO_NORMAL;
  glEnable GL_NORMALIZE;
  glDepthFunc GL_LESS;
  glEnable GL_DEPTH_TEST;
;;


let display() =
  let low_ambient = (0.1, 0.1, 0.1, 1.0)
  and more_ambient = (0.4, 0.4, 0.4, 1.0)
  and most_ambient = (1.0, 1.0, 1.0, 1.0) in

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (*  material has small ambient reflection *)
  glMaterial GL_FRONT (Material.GL_AMBIENT low_ambient);
  glMaterial GL_FRONT (Material.GL_SHININESS 40.0);
  glPushMatrix();
  glTranslate 0.0 2.0 0.0;
  glutSolidTeapot 1.0;
  glPopMatrix();

  (*  material has moderate ambient reflection *)
  glMaterial GL_FRONT (Material.GL_AMBIENT more_ambient);
  glPushMatrix();
  glTranslate 0.0 0.0 0.0;
  glutSolidTeapot 1.0;
  glPopMatrix();

  (*  material has large ambient reflection *)
  glMaterial GL_FRONT (Material.GL_AMBIENT most_ambient);
  glPushMatrix();
  glTranslate 0.0 (-2.0) 0.0;
  glutSolidTeapot 1.0;
  glPopMatrix();
  glFlush();
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if (w <= h) then
    glOrtho (-4.0) (4.0) (-4.0 *. (float h) /. (float w))
                         ( 4.0 *. (float h) /. (float w)) (-10.0) (10.0)
  else
    glOrtho (-4.0 *. (float w) /. (float h))
            ( 4.0 *. (float w) /. (float h)) (-4.0) (4.0) (-10.0) (10.0);

  glMatrixMode GL_MODELVIEW;
;;


let keyboard ~key ~x ~y =
  begin match key with
  | '\027' ->  (* Escape *)
      exit 0;
  | _ -> ()
  end;
  glutPostRedisplay();
;;


(*  Main Loop
 *  Open window with initial window size, title bar,
 *  RGBA display mode, and handle input events.
 *)
let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB; GLUT_DEPTH];
  glutInitWindowSize 500 500;
  ignore(glutCreateWindow Sys.argv.(0));
  myinit();
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

