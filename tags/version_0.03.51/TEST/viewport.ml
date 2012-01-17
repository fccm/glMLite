(*
  Demonstration of view-ports
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
(* Converted from C to OCaml by Florent Monnier *)

open GL ;;
open Glu ;;
open Glut ;;

let left_click = ref GLUT_UP ;;
let right_click = ref GLUT_UP ;;
let xold = ref 0 ;;
let yold = ref 0 ;;
let width = ref 0 ;;
let height = ref 0 ;;
let rotate_x = ref 30.0 ;;
let rotate_y = ref 15.0 ;;
let alpha = ref 0.0 ;;
let beta = ref 0.0 ;;


(* Just a teapot and its frame *)
let teapot () =
  glBegin (GL_LINES);
  glColor3 (1.0) (0.0) (0.0); glVertex3 (-1.0) (-1.0) (-1.0); glVertex3 ( 1.0) (-1.0) (-1.0);
  glColor3 (0.0) (1.0) (0.0); glVertex3 (-1.0) (-1.0) (-1.0); glVertex3 (-1.0) ( 1.0) (-1.0);
  glColor3 (0.0) (0.0) (1.0); glVertex3 (-1.0) (-1.0) (-1.0); glVertex3 (-1.0) (-1.0) ( 1.0);
  glEnd ();
  glRotate (!beta) (1.0) (0.0) (0.0);
  glRotate (!alpha) (0.0) (1.0) (0.0);
  glColor3 (1.0) (1.0) (1.0);
  glutWireTeapot (0.5);
;;

let a = ref 0.0 ;;
let b = ref 0.0 ;;

(* Function called to update rendering *)
let display () =
  a := float !height /. float !width;
  b := float !width  /. float !height;

  glClear [GL_COLOR_BUFFER_BIT];

  (* Perspective projection *)
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective (20.0 *. sqrt(1.0 +. !a *. !a)) (!b) (8.0) (12.0);
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();

  (* Perspective view *)
  glViewport (0) (0) (!width / 2) (!height / 2);
  glPushMatrix ();
  glTranslate 0.0  0.0 (-10.0);
  glRotate !rotate_y 1.0 0.0 0.0;
  glRotate !rotate_x 0.0 1.0 0.0;
  teapot ();
  glPopMatrix ();


  (* Orthogonal projection *)
  glMatrixMode GL_PROJECTION;
  glLoadIdentity ();
  if (!height > !width) then
    glOrtho (-1.2) (1.2) (-1.2 *. !a) (1.2 *. !a) (-1.2) (1.2)
  else
    glOrtho (-1.2 *. !b) (1.2 *. !b) (-1.2) (1.2) (-1.2) (1.2);
  glMatrixMode GL_MODELVIEW;

  (* Right view *)
  glViewport (0) (!height / 2 + 1) (!width / 2 + 1) (!height / 2);
  glPushMatrix ();
  glRotate (90.0) (0.0) (-1.0) (0.0);
  teapot ();
  glPopMatrix ();

  (* Face view *)
  glViewport (!width / 2 + 1) (!height / 2 + 1) (!width / 2) (!height / 2);
  glPushMatrix ();
  teapot ();
  glPopMatrix ();

  (* Top view *)
  glViewport (!width / 2 + 1) (0) (!width / 2) (!height / 2);
  glPushMatrix ();
  glRotate (90.0) (1.0) (0.0) (0.0);
  teapot ();
  glPopMatrix ();

  (* End *)
  glFlush ();
  glutSwapBuffers ();
;;


let reshape ~width:(new_width) ~height:(new_height) =
  width  := new_width;
  height := new_height;
  glutPostRedisplay();
;;


let keyboard ~key ~x ~y =
  match key with 'q' | 'Q' | '\027' -> exit 0 | _ -> ()
;;


let mouse ~button ~state ~x ~y =
  begin
    match button with
    | GLUT_LEFT_BUTTON  -> left_click  := state;
    | GLUT_RIGHT_BUTTON -> right_click := state;
    | _ -> ()
  end;
  xold := x;
  yold := y;
;;


let motion ~x ~y =
  if (GLUT_DOWN = !left_click) then
    begin
      rotate_y := !rotate_y +. float(y - !yold) /. 5.0;
      rotate_x := !rotate_x +. float(x - !xold) /. 5.0;
      if (!rotate_y >  90.0)  then rotate_y := 90.0;
      if (!rotate_y < (-90.)) then rotate_y := (-90.0);
      glutPostRedisplay ();
    end;

  if (GLUT_DOWN = !right_click) then
    begin
      beta  := !beta  +. float(y - !yold) /. 2.0;
      alpha := !alpha +. float(x - !xold) /. 2.0;
      glutPostRedisplay ();
    end;

  xold := x;
  yold := y;
;;


let () =
  (* Creation of the window *)
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE];
  glutInitWindowSize 500 500;
  ignore(glutCreateWindow "Viewport");

  (* OpenGL settings *)
  glClearColor 0.0 0.0 0.0 0.0;
  glEnable GL_CULL_FACE;
  (*
  glCullFace GL_BACK;
  *)
  glEnable GL_BLEND;
  (*
  glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA;
  *)

  (* Declaration of the callbacks *)
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMouseFunc ~mouse;
  glutMotionFunc ~motion;

  (* Loop *)
  glutMainLoop();
;;

