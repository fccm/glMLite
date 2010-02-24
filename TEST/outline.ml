(*
  Demonstration of outline rendering
  Copyright (C) 2005  Julien Guertault

  This program is free software: you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation, either version 3
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>
*)

(* OCaml version by Florent Monnier *)

open GL ;;
open Glu ;;
open Glut ;;

let left_click = ref GLUT_UP ;;
let xold = ref 0 ;;
let yold = ref 0 ;;
let rotation_x = ref (-30.0) ;;
let rotation_y = ref (15.0) ;;

(* Function called to update rendering *)
let display() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glLoadIdentity();
  glTranslate 0. 0. (-10.);

  glPushMatrix();
  glTranslate 0. 0. (-2.);
  glBegin GL_QUADS;
  glColor3 1. 0. 0.;
  glVertex3 0. 0. 0.;
  glVertex3 1. 0. 0.;
  glVertex3 1. 1. 0.;
  glVertex3 0. 1. 0.;

  glColor3 1. 1. 0.;
  glVertex3 (-2.) (-2.) 0.;
  glVertex3  0. (-2.) 0.;
  glVertex3  0. 0. 0.;
  glVertex3 (-2.) 0. 0.;

  glColor3 0. 0. 1.;
  glVertex3 0. (-0.5) 0.;
  glVertex3 2. (-0.5) 0.;
  glVertex3 2. 0. 0.;
  glVertex3 0. 0. 0.;

  glEnd();
  glPopMatrix();

  (* Transparent teapot body *)
  glPushMatrix();
  glRotate !rotation_y 1. 0. 0.;
  glRotate !rotation_x 0. 1. 0.;
  glColor4 0. 0. 0. 0.;
  glCullFace GL_FRONT;
  glEnable GL_BLEND;
  glutSolidTeapot 1.0;
  glDisable GL_BLEND;
  glPopMatrix();

  (* Black teapot outline *)
  glPushMatrix();
  glTranslate 0. 0. 0.1; (* Tiny z shift *)
  glRotate !rotation_y 1. 0. 0.;
  glRotate !rotation_x 0. 1. 0.;
  glColor3 0. 0. 0.;
  glCullFace GL_BACK;
  glutSolidTeapot 1.0;
  glPopMatrix();

  glFlush();
  glutSwapBuffers();
;;


(* Function called when the window is created or resized *)
let reshape ~width ~height =
  glMatrixMode GL_PROJECTION;

  glLoadIdentity();
  gluPerspective 20. (float width /. float height) 5. 15.;
  glViewport 0 0 width height;

  glMatrixMode GL_MODELVIEW;
  glutPostRedisplay();
;;


(* Function called when a key is hit *)
let keyboard ~key ~x ~y =
  match key with 'q' | 'Q' | '\027' -> exit 0 | _ -> ()
;;


(* Function called when a mouse button is hit *)
let mouse ~button ~state ~x ~y =
  if (GLUT_LEFT_BUTTON = button) then left_click := state;
  xold := x;
  yold := y;
;;


(* Function called when the mouse is moved *)
let motion ~x ~y =
  if (GLUT_DOWN = !left_click) then
    begin
      rotation_y := !rotation_y +. float(y - !yold) /. 5.0;
      rotation_x := !rotation_x +. float(x - !xold) /. 5.0;

      if (!rotation_y >  90.) then rotation_y := 90.;
      if (!rotation_y < -90.) then rotation_y := -90.;

      glutPostRedisplay();
    end;
  xold := x;
  yold := y;
;;


let () =
  (* Creation of the window *)
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE; GLUT_DEPTH];
  glutInitWindowSize 500 500;
  ignore(glutCreateWindow "Outlines");

  (* OpenGL settings *)
  glClearColor 1.0 1.0 1.0 0.0;
  glEnable GL_DEPTH_TEST;
  glBlendFunc Sfactor.GL_ZERO  Dfactor.GL_ONE;
  glPolygonMode GL_FRONT_AND_BACK  GL_FILL;
  glEnable GL_CULL_FACE;

  (* Declaration of the callbacks *)
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMouseFunc ~mouse;
  glutMotionFunc ~motion;

  (* Loop *)
  glutMainLoop ();
;;

