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

(* picksquare.ml
 * Use of multiple names and picking are demonstrated.  
 * A 3x3 grid of squares is drawn.  When the left mouse 
 * button is pressed, all squares under the cursor position 
 * have their color changed.
 *)

(* OCaml version by Florent Monnier
 *
 * This file was converted from C, the original file is available here:
 * http://www.opengl.org/resources/code/samples/redbook/picksquare.c
 *)

open GL
open Glu
open Glut

let board = Array.make_matrix 3 3 0 ;;   (* amount of color for each square *)


(*  The nine squares are drawn.  In selection mode, each 
 *  square is given two names:  one for the row and the 
 *  other for the column on the grid.  The color of each 
 *  square is determined by its position on the grid, and 
 *  the value in the board array.
 *)
let drawSquares ~mode =
  for i = 0 to pred 3 do
    if mode = GL_SELECT then
      glLoadName i;

    for j = 0 to pred 3 do
      if mode = GL_SELECT then
        glPushName j;

      glColor3 ((float i) /. 3.0) ((float j) /. 3.0)
               ((float board.(i).(j)) /. 3.0);

      glRecti i j (i+1) (j+1);

      if mode = GL_SELECT then
        glPopName ();
    done;
  done;
;;


(*  processHits prints out the contents of the 
 *  selection array.
 *)
let processHits ~hits ~buffer =
  let ii, jj = ref 0, ref 0 in
  let c = ref 0 in
  Printf.printf "hits = %d\n" hits;
  for i = 0 to pred hits do	  (*  for each hit  *)
    let names = select_buffer_get buffer !c in
    Printf.printf " number of names for this hit = %d\n" names; incr c;
    incr c;  (* z1 *)
    incr c;  (* z2 *)
    Printf.printf "   names are ";
    for j = 0 to pred names do    (*  for each name *)
      Printf.printf "%d " (select_buffer_get buffer !c);
      if j = 0 then  (*  set row and column  *)
        ii := (select_buffer_get buffer !c)
      else if j = 1 then
        jj := (select_buffer_get buffer !c);
        incr c;
    done;
    print_newline();
    board.(!ii).(!jj) <- (board.(!ii).(!jj) + 1) mod 3;
  done;
;;


(*  pickSquares sets up selection mode, name stack, 
 *  and projection matrix for picking.  Then the 
 *  objects are drawn.
 *)
let buffer_size = 512 ;;

let pickSquares ~button ~state ~x ~y =

  if button = GLUT_LEFT_BUTTON && state = GLUT_DOWN
  then begin
    let select_buffer = new_select_buffer buffer_size in
    at_exit(fun () -> free_select_buffer select_buffer);

    let viewport = glGetInteger4 Get.GL_VIEWPORT in
    let _,_,_, viewport_h = viewport in

    glSelectBuffer buffer_size select_buffer;
    ignore(glRenderMode GL_SELECT);

    glInitNames();
    glPushName 0;

    glMatrixMode GL_PROJECTION;
    glPushMatrix();
    glLoadIdentity();
    (* create 5x5 pixel picking region near cursor location *)
    gluPickMatrix (float x) (float(viewport_h - y)) 5.0 5.0 viewport;
    gluOrtho2D 0.0 3.0 0.0 3.0;
    drawSquares GL_SELECT;

    glMatrixMode GL_PROJECTION;
    glPopMatrix();
    glFlush();

    let hits = glRenderMode GL_RENDER in
    processHits ~hits ~buffer:select_buffer;
    glutPostRedisplay();
  end
;;


let display() =
  glClear [GL_COLOR_BUFFER_BIT];
  drawSquares GL_RENDER;
  glFlush();
;;


let reshape ~width ~height =
  glViewport 0 0 width height;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluOrtho2D 0.0 3.0 0.0 3.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0
  | _ -> ()
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 100 100;
  glutInitWindowPosition 100 100;
  ignore(glutCreateWindow Sys.argv.(0));
  (* Clear color value for every square on the board *)
  glClearColor 0.0 0.0 0.0 0.0;
  glutReshapeFunc ~reshape;
  glutDisplayFunc ~display; 
  glutMouseFunc ~mouse:pickSquares;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

