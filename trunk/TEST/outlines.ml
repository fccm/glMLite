(* Copyright (c) 2005-2007 David HENRY
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *)

(* outline.ml -- object outlining demo
 * last modification: aug. 14, 2007
 *
 * This demo illustrates four polygon outlining techniques.
 *
 * OCaml version by Florent Monnier
 *)
open GL
open Glu
open Glut

(* Mouse Buttons *)
type mouse_buttons_t =
{
  mutable left   : Glut.mouse_button_state;
  mutable middle : Glut.mouse_button_state;
  mutable right  : Glut.mouse_button_state;
}

(* Mouse *)
type mouse_t =
{
  mutable buttons : mouse_buttons_t;

  mutable _x : int;
  mutable _y : int;

  mutable modifiers : Glut.active_modifier list;
}

(* Init mouse *)
let mouse =
{
  buttons = {
    left   = GLUT_UP;
    middle = GLUT_UP;
    right  = GLUT_UP;
  };
  _x = 0;
  _y = 0;
  modifiers = []
}


(* Camera vectors *)
type vector_3d =
{
  mutable x : float;
  mutable y : float;
  mutable z : float;
}

(* Init camera input *)
let rot = {
  x = 0.0;
  y = 0.0;
  z = 0.0;
}

let eye = {
  x = 0.0;
  y = 0.0;
  z = 4.5;
}

type outline_mode_t =
  | MODE_OUTLINE
  | MODE_OUTLINE_ONLY
  | MODE_SILHOUETTE
  | MODE_SILHOUETTE_ONLY

let outlineMode = ref MODE_OUTLINE

type object_type =
  | OBJ_TEAPOT
  | OBJ_SPHERE
  | OBJ_CUBE
  | OBJ_TORUS
  | OBJ_QUAD

let objectType = ref OBJ_TEAPOT


(* Application initialisation.
 * Setup keyboard input, mouse input, timer, camera and OpenGL.
 *)
let init() =
  (* OpenGL initialization *)
  glClearColor 0.5 0.5 0.5 1.0;
  glShadeModel GL_SMOOTH;
  glEnable GL_DEPTH_TEST;
;;


(* GLUT's reshape callback function.
 * Update the viewport and the projection matrix.
 *)
let reshape ~width:w ~height:h =
  let h =
    if h = 0 then 1 else h
  in

  glViewport 0 0 w h;

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 45.0 (float w /. float h) 0.1  1000.0;

  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();

  glutPostRedisplay();
;;


(* Draw the current object selected *)
let drawObject () =
  match !objectType with
  | OBJ_TEAPOT ->
      glFrontFace GL_CW;
      glutSolidTeapot 1.0;

  | OBJ_SPHERE ->
      glFrontFace GL_CCW;
      glutSolidSphere 1.0 50 50;

  | OBJ_CUBE ->
      glFrontFace GL_CW;
      glutSolidCube 1.5;

  | OBJ_TORUS ->
      glFrontFace GL_CCW;
      glutSolidTorus 0.3 1.0 10 50;

  | OBJ_QUAD ->
      glBegin GL_QUADS;
        glNormal3 0.0 0.0 1.0;

        glVertex3 (-1.0) (-1.0) (0.0);
        glVertex3 ( 1.0) (-1.0) (0.0);
        glVertex3 ( 1.0) ( 1.0) (0.0);
        glVertex3 (-1.0) ( 1.0) (0.0);

        glNormal3 (0.0) (0.0) (-1.0);

        glVertex3 (-1.0) ( 1.0) (0.0);
        glVertex3 ( 1.0) ( 1.0) (0.0);
        glVertex3 ( 1.0) (-1.0) (0.0);
        glVertex3 (-1.0) (-1.0) (0.0);
      glEnd();
;;


(* GLUT's display callback function.
 * Render the main OpenGL scene.
 *)
let display() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glLoadIdentity ();

  (* Camera rotation *)
  glTranslate (-. eye.x) (-. eye.y) (-. eye.z);
  glRotate rot.x 1.0 0.0 0.0;
  glRotate rot.y 0.0 1.0 0.0;
  glRotate rot.z 0.0 0.0 1.0;

  (* Draw scene *)
  begin match !outlineMode with
  | MODE_OUTLINE ->
      glPushAttrib [Attrib.GL_POLYGON_BIT];
      glEnable GL_CULL_FACE;

      (* Draw front-facing polygons as filled *)
      glPolygonMode GL_FRONT GL_FILL;
      glCullFace GL_BACK;

      (* Draw solid object *)
      glColor3 1.0 1.0 1.0;
      drawObject();

      (*
       * Draw back-facing polygons as red lines
       *)

      (* Disable lighting for outlining *)
      glPushAttrib [Attrib.GL_LIGHTING_BIT;
                    Attrib.GL_LINE_BIT;
                    Attrib.GL_DEPTH_BUFFER_BIT];
      glDisable GL_LIGHTING;

      glPolygonMode GL_BACK GL_LINE;
      glCullFace GL_FRONT;

      glDepthFunc GL_LEQUAL;
      glLineWidth 5.0;

      (* Draw wire object *)
      glColor3 1.0 0.0 0.0;
      drawObject();

      (* [GL_LIGHTING_BIT; GL_LINE_BIT; GL_DEPTH_BUFFER_BIT] *)
      glPopAttrib();

      (* GL_POLYGON_BIT *)
      glPopAttrib();


  | MODE_OUTLINE_ONLY ->
      glPushAttrib [Attrib.GL_POLYGON_BIT];
      glEnable GL_CULL_FACE;

      (*
       * Draw front-facing polygons as filled
       *)

      (* Disable color buffer *)
      glColorMask false false false false;

      glPolygonMode GL_FRONT GL_FILL;
      glCullFace GL_BACK;

      (* Draw solid object *)
      glColor3 1.0 1.0 1.0;
      drawObject();

      (*
       * Draw back-facing polygons as red lines
       *)

      (* Enable color buffer *)
      glColorMask true true true true;

      (* Disable lighting for outlining *)
      glPushAttrib [Attrib.GL_LIGHTING_BIT;
                    Attrib.GL_LINE_BIT;
                    Attrib.GL_DEPTH_BUFFER_BIT];
      glDisable GL_LIGHTING;

      glPolygonMode GL_BACK GL_LINE;
      glCullFace GL_FRONT;

      glDepthFunc GL_LEQUAL;
      glLineWidth 5.0;

      (* Draw wire object *)
      glColor3 1.0 0.0 0.0;
      drawObject();

      (* GL_LIGHTING_BIT | GL_LINE_BIT | GL_DEPTH_BUFFER_BIT *)
      glPopAttrib();

      (* GL_POLYGON_BIT *)
      glPopAttrib();


  | MODE_SILHOUETTE ->
      glPushAttrib [Attrib.GL_POLYGON_BIT];
      glEnable GL_CULL_FACE;

      (*
       * Draw back-facing polygons as red lines
       *)

      (* Disable lighting for outlining *)
      glPushAttrib [Attrib.GL_LIGHTING_BIT;
                    Attrib.GL_LINE_BIT;
                    Attrib.GL_DEPTH_BUFFER_BIT];
      glDisable GL_LIGHTING;

      glPolygonMode GL_BACK GL_LINE;
      glCullFace GL_FRONT;

      glDisable GL_DEPTH_TEST;
      glLineWidth 5.0;

      (* Draw wire object *)
      glColor3 1.0 0.0 0.0;
      drawObject();

      (* GL_LIGHTING_BIT | GL_LINE_BIT | GL_DEPTH_BUFFER_BIT *)
      glPopAttrib();

      (*
       * Draw front-facing polygons as filled
       *)

      glPolygonMode GL_FRONT GL_FILL;
      glCullFace GL_BACK;

      (* Draw solid object *)
      glColor3 1.0 1.0 1.0;
      drawObject();

      (* GL_POLYGON_BIT *)
      glPopAttrib();


  | MODE_SILHOUETTE_ONLY ->
      (* Clear stencil buffer *)
      glClearStencil 0;
      glClear [GL_STENCIL_BUFFER_BIT];

      (*
       * Draw front-facing polygons as filled
       *)

      (* Disable color and depth buffers *)
      glColorMask false false false false;
      glDepthMask false;

      (* Setup stencil buffer. Draw always in it *)
      glEnable GL_STENCIL_TEST;
      glStencilFuncn  GL_ALWAYS  1  0xFFFFFFFFn;
      glStencilOp GL_REPLACE GL_REPLACE GL_REPLACE;

      (* Draw solid object to create a mask *)
      glColor3 1.0 1.0 1.0;
      drawObject();

      (*
       * Draw back-facing polygons as red lines
       *)

      (* Enable color and depth buffers *)
      glColorMask true true true true;
      glDepthMask true;

      (* Setup stencil buffer. We don't draw inside the mask *)
      glStencilFuncn GL_NOTEQUAL  1  0xFFFFFFFFn;

      (* Disable lighting for outlining *)
      glPushAttrib [Attrib.GL_LIGHTING_BIT;
                    Attrib.GL_LINE_BIT;
                    Attrib.GL_POLYGON_BIT];
      glDisable GL_LIGHTING;

      glEnable GL_CULL_FACE;

      glPolygonMode GL_BACK GL_LINE;
      glCullFace GL_FRONT;

      glLineWidth 5.0;

      (* Draw wire object *)
      glColor3 1.0 0.0 0.0;
      drawObject();

      (* GL_LIGHTING_BIT | GL_LINE_BIT | GL_POLYGON_BIT *)
      glPopAttrib();

      glDisable GL_STENCIL_TEST;
  end;

  glutSwapBuffers ();
;;


(* GLUT's Key press callback function.
 * Called when user press a key.
 *)
let keyboard ~key ~x ~y =
  match key with
  | '\027' -> (* Escape *)
      exit 0;
  | _ -> ()
;;


(* GLUT's mouse motion callback function.
 * Called when the user move the mouse. Update the
 * camera.
 *)
let motion ~x ~y =

  if mouse.buttons.right = GLUT_DOWN then
    eye.z <- eye.z +. float(x - mouse._x) *. 0.1  (* Zoom *)
  else
  if mouse.buttons.left = GLUT_DOWN then
    begin
      if (List.mem GLUT_ACTIVE_SHIFT mouse.modifiers) then
        begin
          (* Translation *)
          eye.x <- eye.x -. float(x - mouse._x) *. 0.02;
          eye.y <- eye.y +. float(y - mouse._y) *. 0.02;
        end
      else
        begin
          (* Rotation *)
          rot.x <- rot.x +. float(y - mouse._y);
          rot.y <- rot.y +. float(x - mouse._x);
        end
    end;

  mouse._x <- x;
  mouse._y <- y;

  glutPostRedisplay();
;;


(* GLUT's mouse button callback function.
 * Called when the user press a mouse button. Update mouse
 * state and keyboard modifiers.
 *)
let mouse ~button ~state ~x ~y =

  (* Update key modifiers *)
  mouse.modifiers <- glutGetModifiers();

  (* Update mouse state *)
  mouse._x <- x;
  mouse._y <- y;

  begin match button with
  | GLUT_LEFT_BUTTON   -> mouse.buttons.left <- state;
  | GLUT_MIDDLE_BUTTON -> mouse.buttons.middle <- state;
  | GLUT_RIGHT_BUTTON  -> mouse.buttons.right <- state;
  | GLUT_WHEEL_DOWN
  | GLUT_WHEEL_UP -> ()
  end;
;;


(* GLUT's menu callback function. Handle the menu.
 * Select the outline mode to use and redraw the scene.
 *)
let menu ~value =
  begin match value with
  | 1 -> outlineMode := MODE_OUTLINE
  | 2 -> outlineMode := MODE_OUTLINE_ONLY
  | 3 -> outlineMode := MODE_SILHOUETTE
  | 4 -> outlineMode := MODE_SILHOUETTE_ONLY

  | 5 -> objectType := OBJ_TEAPOT
  | 6 -> objectType := OBJ_SPHERE
  | 7 -> objectType := OBJ_CUBE
  | 8 -> objectType := OBJ_TORUS
  | 9 -> objectType := OBJ_QUAD

  | _ -> ()
  end;

  glutPostRedisplay ();
;;


(* his is the main program. *)
let () =

  (* Initialize GLUT *)
  ignore(glutInit Sys.argv);

  (* Create an OpenGL window *)
  glutInitDisplayMode [GLUT_RGBA; GLUT_DOUBLE; GLUT_DEPTH; GLUT_STENCIL];
  glutInitWindowSize 640 480;
  ignore(glutCreateWindow "Object outlining demo");

  (* Initialize application *)
  init();

  (* Create glut menu *)
  let outlineModeId = glutCreateMenu ~menu in
  glutAddMenuEntry "Outline"         1;  (* MODE_OUTLINE *)
  glutAddMenuEntry "Outline only"    2;  (* MODE_OUTLINE_ONLY *)
  glutAddMenuEntry "Silhouette"      3;  (* MODE_SILHOUETTE *)
  glutAddMenuEntry "Silhouette only" 4;  (* MODE_SILHOUETTE_ONLY *)

  let objectTypeId = glutCreateMenu ~menu in
  glutAddMenuEntry "Teapot" 5;  (* OBJ_TEAPOT *)
  glutAddMenuEntry "Sphere" 6;  (* OBJ_SPHERE *)
  glutAddMenuEntry "Cube"   7;  (* OBJ_CUBE *)
  glutAddMenuEntry "Torus"  8;  (* OBJ_TORUS *)
  glutAddMenuEntry "Quad"   9;  (* OBJ_QUAD *)

  ignore(glutCreateMenu ~menu);
  glutAddSubMenu "Outline mode"  outlineModeId;
  glutAddSubMenu "Object"  objectTypeId;
  glutAttachMenu GLUT_RIGHT_BUTTON;

  (* Setup glut callback functions *)
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display;
  glutKeyboardFunc ~keyboard;
  glutMotionFunc ~motion;
  glutMouseFunc ~mouse;

  (* Enter the main loop *)
  glutMainLoop ();
;;

