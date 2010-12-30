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
(*  accanti.ml
 *)

open GL
open Glu
open Glut

(* jitter

This is jitter point array for 8 jitters.

Values are floating point in the range -.5 < x < .5, -.5 < y < .5, and
have a gaussian distribution around the origin.

This is used to do model jittering for scene anti-aliasing and view volume
jittering for depth of field effects. Use in conjunction with the 
accwindow() routine.
*)

type jitter_point = { x: float; y: float }

(* 8 jitter points *)
let j8 =
  [|
      {x = -0.334818; y =  0.435331};
      {x =  0.286438; y = -0.393495};
      {x =  0.459462; y =  0.141540};
      {x = -0.414498; y = -0.192829};
      {x = -0.183790; y =  0.082102};
      {x = -0.079263; y = -0.317383};
      {x =  0.102254; y =  0.299133};
      {x =  0.164216; y = -0.054399};
  |]
;;


(*  Initialize lighting and other values.
 *)
let myinit() =
  let mat_ambient    = (1.0, 1.0,  1.0, 1.0)
  and mat_specular   = (1.0, 1.0,  1.0, 1.0)
  and light_position = (0.0, 0.0, 10.0, 1.0)
  and lm_ambient     = (0.2, 0.2,  0.2, 1.0) in

  glMaterial GL_FRONT (Material.GL_AMBIENT mat_ambient);
  glMaterial GL_FRONT (Material.GL_SPECULAR mat_specular);
  glMaterial GL_FRONT (Material.GL_SHININESS 50.0);
  glLight (GL_LIGHT 0) (Light.GL_POSITION light_position);
  glLightModel (GL_LIGHT_MODEL_AMBIENT lm_ambient);

  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;
  glDepthFunc GL_LESS;
  glEnable GL_DEPTH_TEST;
  glShadeModel GL_FLAT;

  glClearColor 0.0 0.0 0.0 0.0;
  glClearAccum 0.0 0.0 0.0 0.0;
;;


let displayObjects() =
  let torus_diffuse  = (0.7, 0.7, 0.0, 1.0)
  and cube_diffuse   = (0.0, 0.7, 0.7, 1.0)
  and sphere_diffuse = (0.7, 0.0, 0.7, 1.0)
  and octa_diffuse   = (0.7, 0.4, 0.4, 1.0) in

  glPushMatrix ();
  glRotate 30.0 1.0 0.0 0.0;

  glPushMatrix ();
  glTranslate (-0.80) (0.35) (0.0);
  glRotate 100.0 1.0 0.0 0.0;
  glMaterial GL_FRONT (Material.GL_DIFFUSE torus_diffuse);
  glutSolidTorus 0.275 0.85 16 16;
  glPopMatrix ();

  glPushMatrix ();
  glTranslate (-0.75) (-0.50) (0.0);
  glRotate 45.0 0.0 0.0 1.0;
  glRotate 45.0 1.0 0.0 0.0;
  glMaterial GL_FRONT (Material.GL_DIFFUSE cube_diffuse);
  glutSolidCube 1.5;
  glPopMatrix ();

  glPushMatrix ();
  glTranslate 0.75 0.60 0.0;
  glRotate 30.0 1.0 0.0 0.0;
  glMaterial GL_FRONT (Material.GL_DIFFUSE sphere_diffuse);
  glutSolidSphere 1.0 16 16;
  glPopMatrix ();

  glPushMatrix ();
  glTranslate (0.70) (-0.90) (0.25);
  glMaterial GL_FRONT (Material.GL_DIFFUSE octa_diffuse);
  glutSolidOctahedron ();
  glPopMatrix ();

  glPopMatrix ();
;;


let display() =
  let _, _, viewport2, viewport3 = glGetInteger4 Get.GL_VIEWPORT in
  glClear [GL_ACCUM_BUFFER_BIT];

  Array.iter (fun j ->
    glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
    glPushMatrix ();
(*  Note that 4.5 is the distance in world space between
 *  left and right and bottom and top.
 *  This formula converts fractional pixel movement to
 *  world coordinates.
 *)
    glTranslate (j.x *. 4.5 /. float viewport2)
                (j.y *. 4.5 /. float viewport3) 0.0;
    displayObjects ();
    glPopMatrix ();
    glAccum GL_ACCUM (1.0 /. float(Array.length j8));
  ) j8;
  glAccum GL_RETURN 1.0;
  glFlush();
;;


let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  let w = float w and h = float h in
  if w <= h
  then glOrtho (-2.25) (2.25) (-2.25 *. h /. w) (2.25 *. h /. w) (-10.0) (10.0)
  else glOrtho (-2.25 *. w /. h) (2.25 *. w /. h) (-2.25) (2.25) (-10.0) (10.0);
  glMatrixMode GL_MODELVIEW;
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
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB;
                       GLUT_ACCUM; GLUT_DEPTH];
  glutInitWindowSize 250 250;
  let _ = glutCreateWindow Sys.argv.(0) in
  myinit();
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

