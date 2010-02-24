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

(*  polyoff.ml
 *  This program demonstrates polygon offset to draw a shaded
 *  polygon and its wireframe counterpart without ugly visual
 *  artifacts ("stitching").
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glu
open Glut

let li = ref 0
let fill = ref true
let spin_x = ref 0.0
let spin_y = ref 0.0
let t_dist = ref 0.0
let polyfactor = ref 1.0
let polyunits  = ref 1.0
let doubleBuffer = ref true ;;

let ( += ) a b = (a := !a +. b) ;;
let ( -= ) a b = (a := !a -. b) ;;


(*  display() draws two spheres, one with a gray, diffuse material,
 *  the other sphere with a magenta material with a specular highlight.
 *)
let display () =
  let gray = (0.8, 0.8, 0.8, 1.0)
  and black = (0.0, 0.0, 0.0, 1.0) in

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glPushMatrix();
  glTranslate 0.0 0.0 !t_dist;
  glRotate !spin_x 1.0 0.0 0.0;
  glRotate !spin_y 0.0 1.0 0.0;

  glMaterial GL_FRONT (Material.GL_AMBIENT_AND_DIFFUSE gray);
  glMaterial GL_FRONT (Material.GL_SPECULAR black);
  glMaterial GL_FRONT (Material.GL_SHININESS 0.0);
  if (!fill) then begin
    glEnable GL_LIGHTING;
    glEnable GL_LIGHT0;
    glEnable GL_POLYGON_OFFSET_FILL;
    glPolygonOffset !polyfactor !polyunits;
    glCallList !li;
    glDisable GL_POLYGON_OFFSET_FILL;
  end;

  glDisable GL_LIGHTING;
  glDisable GL_LIGHT0;
  glColor3  0.0 0.0 1.0;
  glPolygonMode GL_FRONT_AND_BACK GL_LINE;
  glPolygonOffset (-. !polyfactor) (-. !polyunits);
  if not(!fill) then glEnable GL_POLYGON_OFFSET_LINE;
  glCallList !li;
  glDisable GL_POLYGON_OFFSET_LINE;
  glPolygonMode GL_FRONT_AND_BACK GL_FILL;

  if not(!fill) then begin 
    glEnable GL_LIGHTING;
    glEnable GL_LIGHT0;
    glCallList !li;
  end;

  glPopMatrix();
  glFlush();
  if (!doubleBuffer) then glutSwapBuffers();
;;


(*  specify initial properties
 *  create display list with sphere
 *  initialize lighting and depth buffer
 *)
let gfxinit () =
  let light_ambient = (0.0, 0.0, 0.0, 1.0)
  and light_diffuse = (1.0, 1.0, 1.0, 1.0)
  and light_specular = (1.0, 1.0, 1.0, 1.0)
  and light_position = (1.0, 1.0, 1.0, 0.0)

  and global_ambient = (0.2, 0.2, 0.2, 1.0) in

  glClearColor 0.6 0.6 0.6 1.0;

  li := glGenLists 1;
  glNewList !li GL_COMPILE;
    glutSolidSphere 1.0 20 12;
  glEndList();

  glEnable GL_DEPTH_TEST;

  glLight (GL_LIGHT 0) (Light.GL_AMBIENT light_ambient);
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE light_diffuse);
  glLight (GL_LIGHT 0) (Light.GL_SPECULAR light_specular);
  glLight (GL_LIGHT 0) (Light.GL_POSITION light_position);
  glLightModel (GL_LIGHT_MODEL_AMBIENT global_ambient);
;;


(*  call when window is resized  *)
let reshape ~width ~height =
  glViewport 0 0 width height;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 45.0 ((float width) /. (float height)) 1.0 10.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
  gluLookAt 0.0 0.0 5.0  0.0 0.0 0.0  0.0 1.0 0.0;
;;


let benchmark ~xdiff ~ydiff =
  Printf.printf "Benchmarking...\n";

  let draws = ref 0 in
  let startTime = glutGet GLUT_ELAPSED_TIME in
  spin_x := 0.0;
  spin_y := 0.0;
  let diffTime = ref 0 in
  let stop = ref false in
  while not(!stop) do
    spin_x += xdiff;
    spin_y += ydiff;
    display();
    incr draws;
    let endTime = glutGet GLUT_ELAPSED_TIME in
    (* 5 seconds *)
    diffTime := endTime - startTime;
    if (!diffTime > 5000)
    then stop := true;
  done;

  (* Results *)
  let seconds = (float !diffTime) /. 1000.0 in
  let fps = (float !draws) /. seconds in
  Printf.printf "Result:  fps: %g\n%!" fps;
;;


(*  call when mouse button is pressed  *)
let mouse ~button ~state ~x ~y =
  match button, state with
  | GLUT_LEFT_BUTTON, GLUT_DOWN ->
      spin_x += 5.0;
      glutPostRedisplay();
  | GLUT_MIDDLE_BUTTON, GLUT_DOWN ->
      spin_y += 5.0;
      glutPostRedisplay();
  | GLUT_RIGHT_BUTTON, GLUT_UP ->
      exit 0;
  | _ -> ()
;;

let special ~key ~x ~y =
  match key with
  | GLUT_KEY_LEFT ->
      spin_y -= 5.0;
      glutPostRedisplay();
  | GLUT_KEY_RIGHT ->
      spin_y += 5.0;
      glutPostRedisplay();
  | GLUT_KEY_UP ->
      spin_x -= 5.0;
      glutPostRedisplay();
  | GLUT_KEY_DOWN ->
      spin_x += 5.0;
      glutPostRedisplay();
  | _ -> ()
;;


let keyboard ~key ~x ~y =
  match key with
  | 't' ->
      if (!t_dist < 4.0) then begin
        t_dist := (!t_dist +. 0.5);
        glutPostRedisplay();
      end;
  | 'T' ->
      if (!t_dist > -5.0) then begin
        t_dist := (!t_dist -. 0.5);
        glutPostRedisplay();
      end;
  | 'F' ->
      polyfactor := !polyfactor +. 0.1;
      Printf.printf "polyfactor is %f\n%!" !polyfactor;
      glutPostRedisplay();
  | 'f' ->
      polyfactor := !polyfactor -. 0.1;
      Printf.printf "polyfactor is %f\n%!" !polyfactor;
      glutPostRedisplay();
  | 'U' ->
      polyunits := !polyunits +. 1.0;
      Printf.printf "polyunits is %f\n%!" !polyunits;
      glutPostRedisplay();
  | 'u' ->
      polyunits := !polyunits -. 1.0;
      Printf.printf "polyunits is %f\n%!" !polyunits;
      glutPostRedisplay();
  | 'b' ->
      benchmark 5.0 0.0;
  | 'B' ->
      benchmark 0.0 5.0;
  | ' ' ->
      fill := not(!fill);
      Printf.printf "fill/line: %b\n%!" !fill;
      glutPostRedisplay();
  | '\027' ->  (* Escape *)
      exit(0);
  | _ -> ()
;;



let args(argv) =
  let argc = Array.length argv in

  for i = 1 to pred argc do
    if argv.(i) = "-sb" then
      doubleBuffer := false
    else if argv.(i) = "-db" then
      doubleBuffer := true
    else
      invalid_arg(Printf.sprintf "%s (Bad option).\n" Sys.argv.(i));
  done;
;;


(*  Main Loop
 *  Open window with initial window size, title bar,
 *  RGBA display mode, and handle input events.
 *)
let () =
  let argv = glutInit Sys.argv in
  (* arguments on command line intended for openGL are removed,
     see glutInit manual page for more informations *)

  args(argv);

  let type_ = [GLUT_DEPTH; GLUT_RGB] in
  let type_ =
    if (!doubleBuffer)
    then GLUT_DOUBLE::type_
    else GLUT_SINGLE::type_
  in

  glutInitDisplayMode type_;
  ignore(glutCreateWindow "polyoff");

  let gl_version = glGetString GL_VERSION in
  if gl_version < "1.1" then begin
    Printf.eprintf
        "This program demonstrates a feature which is not in OpenGL Version 1.0.\n\
         If your implementation of OpenGL Version 1.0 has the right extensions,\n\
         you may be able to modify this program to make it run.\n";
    exit 1;
  end;

  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display;
  glutMouseFunc ~mouse;
  glutKeyboardFunc ~keyboard;
  glutSpecialFunc ~special;
  gfxinit();
  glutMainLoop();
;;

