(* Copyright (c) Mark J. Kilgard, 1994, 1996. *)

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

(* sb2db.ml - This program demonstrates switching between single buffered
   and double buffered windows when using GLUT.  Use the pop-up menu to
   change the buffering style used.  On machine that split the screen's
   color resolution in half when double buffering, you should notice better
   coloration (less or no dithering) in single buffer mode (but flicker on
   redraws, particularly when rotation is toggled on).  *)

(* This program is based on the GLUT scene.c program. *)

(* This program originaly in C was converted in OCaml by F.Monnier *)

open GL ;;
open Glut ;;

let sbwin = ref None ;;
let dbwin = ref None ;;
let angle = ref 0 ;;

let win = function None -> invalid_arg "window id" | Some id -> id ;;


(*  Initialize material property and light source.  *)
let myinit() =
  glLight (GL_LIGHT 0) (Light.GL_AMBIENT (0.3, 0.3, 0.3, 1.0));
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE (6.0, 6.0, 6.0, 1.0));
  glLight (GL_LIGHT 0) (Light.GL_SPECULAR (1.0, 1.0, 1.0, 1.0));
  (* light_position is NOT default value *)
  glLight (GL_LIGHT 0) (Light.GL_POSITION (-1.0, 1.0, 1.0, 0.0));

  glEnable GL_LIGHT0;
  glDepthFunc GL_LESS;
  glEnable GL_DEPTH_TEST;
  glEnable GL_LIGHTING;
;;


let display() =
  let red    = (0.8, 0.0, 0.0, 1.0)
  and yellow = (0.8, 0.8, 0.0, 1.0)
  and green  = (0.0, 0.8, 0.0, 1.0) in

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  glPushMatrix();
  glRotate (float !angle) 1.0 0.0 0.0;
  glScale 1.3  1.3  1.3;
  glRotate 20.0  1.0  0.0  0.0;

  glPushMatrix();
  glTranslate (-0.75) 0.5  0.0;
  glRotate 90.0  1.0  0.0  0.0;
  glMaterial GL_FRONT_AND_BACK (Material.GL_DIFFUSE red);
  glutSolidTorus 0.275  0.85  10  15;
  glPopMatrix();

  glPushMatrix();
  glTranslate (-0.75) (-0.5) (0.0);
  glRotate 270.0  1.0  0.0  0.0;
  glMaterial GL_FRONT_AND_BACK (Material.GL_DIFFUSE yellow);
  glutSolidCone 1.0 1.0 40 40;
  glPopMatrix();

  glPushMatrix();
  glTranslate 0.75  0.0 (-1.0);
  glMaterial GL_FRONT_AND_BACK (Material.GL_DIFFUSE green);
  glutSolidIcosahedron();
  glPopMatrix();

  glPopMatrix();

  if glutGetWindow() = (win !sbwin)
  then glFlush()
  else glutSwapBuffers();
;;


(* Used by both windows, this routine setups the OpenGL context's
   projection matrix correctly.  Note that we call this routine for
   both contexts to keep them in sync after reshapes. *)
let reshapeOpenGLState ~w ~h =
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if w <= h then
    glOrtho (-2.5) (2.5) ((-2.5) *. (float h) /. (float w))
            (2.5 *. (float h) /. (float w)) (-10.0) (10.0)
  else
    glOrtho ((-2.5) *. (float w) /. (float h))
            (2.5 *. (float w) /. (float h)) (-2.5) (2.5) (-10.0) (10.0);
  glMatrixMode GL_MODELVIEW;
;;


(* When the single buffered (ie, the top window) gets resized, we
   need to resize the child double buffered window as well.  Hence
   the glutReshapeWindow on the child.  NOTE:  You want a separate
   resize callback for the double buffered window to set the viewport
   since the window's size won't really be changed until the double buffered
   gets its db_reshape callback.  Otherwise, you could trick OpenGL intop
   clipping based on the old window size. *)
let sb_reshape ~width:w ~height:h =
  glutSetWindow(win !sbwin);
  glViewport 0 0 w h;
  reshapeOpenGLState w h;
  glutSetWindow(win !dbwin);
  glutReshapeWindow w h;
;;


let db_reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  reshapeOpenGLState w h;
;;


let rotation() =
  angle := !angle + 2;
  angle := !angle mod 360;
  glutPostRedisplay();
;;


let animation = ref false ;;  (* If there is an animated rotation currently *)


let main_menu ~value =
  match value with
  | 1 ->
      (* Smart toggle rotation ensures we switch to double buffered when
         animating and single buffered when not animating. *)
      animation := not !animation;  (* Toggle. *)
      if !animation then begin
        glutIdleFunc(rotation);
        glutSetWindow(win !sbwin);
        glutSetWindowTitle("sb2db - double buffer mode");
        glutSetWindow(win !dbwin);
        glutShowWindow();   (* Show the double buffered window. *)
      end
      else begin
        glutRemoveIdleFunc();
        glutSetWindow(win !sbwin);
        glutSetWindowTitle("sb2db - single buffer mode");
        glutSetWindow(win !dbwin);
        glutHideWindow();   (* Hide the double buffered window. *)
      end;
  | 2 ->
      glutSetWindow(win !dbwin);
      glutHideWindow();   (* Hide the double buffered window. *)
      glutSetWindow(win !sbwin);
      glutSetWindowTitle("sb2db - single buffer mode");
  | 3 ->
      glutSetWindow(win !sbwin);
      glutSetWindowTitle("sb2db - double buffer mode");
      glutSetWindow(win !dbwin);
      glutShowWindow();   (* Show the double buffered window. *)
  | 4 ->
      animation := not !animation;  (* Toggle. *)
      if (!animation)
      then glutIdleFunc rotation
      else glutRemoveIdleFunc();
  | 666 ->
      exit 0;
  | _ -> ()
;;


let sbvis = ref GLUT_NOT_VISIBLE ;;
let dbvis = ref GLUT_NOT_VISIBLE ;;

(* You have to track the visibility of both the single buffered
   and double buffered windows together. *)
let visibility ~state =

  if glutGetWindow() = (win !sbwin)
  then sbvis := state
  else dbvis := state;

  let eithervis = (!sbvis = GLUT_VISIBLE) || (!dbvis = GLUT_VISIBLE) in
  if eithervis then
    (* Resume rotating idle callback if we become visible and
       animation is enabled. *)
    if !animation then
      glutIdleFunc rotation
  else
    (* Disable animation when both windows are not visible. *)
    glutRemoveIdleFunc();
;;


let () =
  glutInitWindowSize 500 500;
  ignore(glutInit Sys.argv);
  glutInitDisplayMode[GLUT_RGB; GLUT_DEPTH; GLUT_SINGLE];

  (* The top window is single buffered. *)
  sbwin := Some(glutCreateWindow Sys.argv.(0));
  glutReshapeFunc ~reshape:sb_reshape;
  glutDisplayFunc ~display;
  glutVisibilityFunc ~visibility;
  myinit();

  (* The child window is double buffered.  We show this window
     when displaying double buffered and hide it to show the
     single buffered window. *)
  glutInitDisplayMode[GLUT_RGB; GLUT_DEPTH; GLUT_DOUBLE];
  let wid = glutCreateSubWindow (glutGetWindow()) 0 0
                                (glutGet GLUT_WINDOW_WIDTH)
                                (glutGet GLUT_WINDOW_HEIGHT) in
  dbwin := Some wid;

  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape:db_reshape;
  glutVisibilityFunc ~visibility;
  glutKeyboardFunc ~keyboard:(fun ~key ~x ~y ->
        match key with '\027' -> exit 0 | _ -> ());

  (* Call myinit for both the single buffered window and the
     double buffered window.  We must mirror the same OpenGL
     state in both window's OpenGL contexts.  If you make this
     program more complicated, remember to keep the window's
     context state in sync. *)
  myinit();

  (* Initially hide the double buffered window to start in
     single buffered mode. *)
  glutHideWindow();

  ignore(glutCreateMenu main_menu);
  glutAddMenuEntry "Smart rotation toggle"  1;
  glutAddMenuEntry "Single buffer"  2;
  glutAddMenuEntry "Double buffer"  3;
  glutAddMenuEntry "Toggle rotation"  4;
  glutAddMenuEntry "Quit"  666;
  glutAttachMenu GLUT_RIGHT_BUTTON;
  glutSetWindow(win !sbwin);
  glutAttachMenu GLUT_RIGHT_BUTTON;
  glutMainLoop();
;;

