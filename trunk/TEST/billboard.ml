(*
  Demonstration of billboards
  Copyright (C) 2005  Julien Guertault

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 3
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>
*)

open GL
open Glu
open Glut

let left_click = ref GLUT_UP ;;
let right_click = ref GLUT_UP ;;
let xold = ref 0 ;;
let yold = ref 0 ;;
let rotate_x = ref 30. ;;
let rotate_y = ref 15. ;;
let rotate_z = ref(-5.);;


(*
 * Just a square
 *)
let square () =
  glBegin GL_QUADS;
  glTexCoord2 0. 0.; glVertex3 ( 0.2) ( 0.2) (0.);
  glTexCoord2 1. 0.; glVertex3 (-0.2) ( 0.2) (0.);
  glTexCoord2 1. 1.; glVertex3 (-0.2) (-0.2) (0.);
  glTexCoord2 0. 1.; glVertex3 ( 0.2) (-0.2) (0.);
  glEnd();
;;


(*
 * Axis aligned billboard (trees)
 *)
let axis_billboard() =
  glPushMatrix();
  glRotate !rotate_x 0. (-1.) 0.;
  square();
  glPopMatrix();
;;


(*
 * World aligned billboard (particules)
 *)
let world_billboard() =
  glPushMatrix();
  glRotate !rotate_x 0. (-1.) 0.;
  glRotate !rotate_y (-1.) 0. 0.;
  square();
  glPopMatrix();
;;


(*
 * Screen aligned billboard (text)
 *)
let screen_billboard() =
  glPushMatrix();
  glRotate !rotate_x 0. (-1.) 0.;
  glRotate !rotate_y (-1.) 0. 0.;
  glRotate !rotate_z 0. 0. (-1.);
  square();
  glPopMatrix();
;;


(*
 * Function called to update rendering
 *)
let display() =
  glClear [GL_COLOR_BUFFER_BIT];
  glLoadIdentity();
  glTranslate 0. 0. (-8.);

  glRotate !rotate_z 0. 0. 1.;
  glRotate !rotate_y 1. 0. 0.;
  glRotate !rotate_x 0. 1. 0.;

  (* A cube made of 9 billboards *)
  for i=0 to pred 3 do
    for j=0 to pred 3 do
      for k=0 to pred 3 do
        glPushMatrix();
        glTranslate (float(i - 1)) (float(j - 1)) (float(k - 1));
        glColor3 (0.2 +. float i *. 0.4)
                 (0.2 +. float j *. 0.4)
                 (0.2 +. float k *. 0.4);

        (* The bottom rows are axis aligned billboards *)
        if 0 = j then
          axis_billboard();

        (* The middle rows are world aligned billboards *)
        if 1 = j then
          world_billboard();

        (* The top rows are screen aligned billboards *)
        if 2 = j then
          screen_billboard();

        glPopMatrix();
      done;
    done;
  done;

  (* End *)
  glFlush();
  glutSwapBuffers();
;;


(*
 * Function called when the window is created or resized
 *)
let reshape  ~width ~height =
  glMatrixMode GL_PROJECTION;

  glLoadIdentity();
  gluPerspective 30. (float width /. float height) 5. 15.;
  glViewport 0 0 width height;

  glMatrixMode GL_MODELVIEW;
  glutPostRedisplay();
;;


(*
 * Function called when a key is hit
 *)
let keyboard ~key ~x ~y =
  match key with
  | 'q' | 'Q' | '\027' -> exit 0;
  | _ -> ()
;;


(*
 * Function called when a mouse button is hit
 *)
let mouse ~button ~state ~x ~y =
  xold := x;
  yold := y;
  match button with
  | GLUT_LEFT_BUTTON -> left_click := state;
  | GLUT_RIGHT_BUTTON -> right_click := state;
  | _ -> ()
;;


(*
 * Function called when the mouse is moved
 *)
let motion ~x ~y =
  if GLUT_DOWN = !left_click then
    begin
      rotate_y := !rotate_y +. float(y - !yold) /. 5.0;
      rotate_x := !rotate_x +. float(x - !xold) /. 5.0;
      if !rotate_y > 90. then
        rotate_y := 90.;
      if !rotate_y < -90. then
        rotate_y := -90.;
      glutPostRedisplay();
    end;
  if GLUT_DOWN = !right_click then
    begin
      rotate_z := !rotate_z +. float(x - !xold) /. 5.0;
      glutPostRedisplay();
    end;
  xold := x;
  yold := y;
;;


(*
 * Load the texture
 *)
let load_texture ~filename =
  let texture_data, width, height, _, color_space =
    Jpeg_loader.load_img (Filename filename)
  in
  if color_space <> GL_LUMINANCE then
    invalid_arg "Error: texture is not grayscale";
  (texture_data, width, height)
;;


(*
 * main
 *)
let () =
  (* Creation of the window *)
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE];
  glutInitWindowSize 500 500;
  ignore(glutCreateWindow "Billboard");

  (* OpenGL settings *)
  glClearColor 0. 0. 0. 0.;
  glEnable GL_BLEND;
  glBlendFunc Sfactor.GL_SRC_ALPHA  Dfactor.GL_ONE;
  glEnable GL_TEXTURE_2D;
  glTexEnv TexEnv.GL_TEXTURE_ENV  TexEnv.GL_TEXTURE_ENV_MODE  TexEnv.GL_REPLACE;

  (* Texture loading  *)
  let texture_data, width, height = load_texture "square.jpg" in
  let texture = glGenTexture() in
  glBindTexture BindTex.GL_TEXTURE_2D texture;

  glTexImage2D TexTarget.GL_TEXTURE_2D  0  InternalFormat.GL_ALPHA
               width height  GL_ALPHA  GL_UNSIGNED_BYTE  texture_data;

  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER  Min.GL_LINEAR);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER  Mag.GL_LINEAR);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_S  GL_REPEAT);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_T  GL_REPEAT);

  (* Declaration of the callbacks *)
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMouseFunc ~mouse;
  glutMotionFunc ~motion;

  (* Loop *)
  glutMainLoop ();
;;

