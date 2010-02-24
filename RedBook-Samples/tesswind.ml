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

(*  tesswind.ml
 *  This program demonstrates the winding rule polygon 
 *  tessellation property.  Four tessellated objects are drawn, 
 *  each with very different contours.  When the w key is pressed, 
 *  the objects are drawn with a different winding rule.
 *)

(* OCaml version by Florent Monnier *)

open GL
open Glu
open Glut

let currentWinding = ref GLU_TESS_WINDING_ODD
let dli = ref 0

(*  Make four display lists, 
 *  each with a different tessellated object. 
 *)
let makeNewLists =
  let tobj = gluNewTess() in
  gluTessDefaultCallback tobj GLU_TESS_VERTEX;
  gluTessDefaultCallback tobj GLU_TESS_BEGIN;
  gluTessDefaultCallback tobj GLU_TESS_END;
  gluTessDefaultCallback tobj GLU_TESS_ERROR;
  gluTessDefaultCallback tobj GLU_TESS_COMBINE;

  let rects =
   [| ( 50.0,  50.0, 0.0); (300.0,  50.0, 0.0);
      (300.0, 300.0, 0.0); ( 50.0, 300.0, 0.0);
      (100.0, 100.0, 0.0); (250.0, 100.0, 0.0);
      (250.0, 250.0, 0.0); (100.0, 250.0, 0.0);
      (150.0, 150.0, 0.0); (200.0, 150.0, 0.0);
      (200.0, 200.0, 0.0); (150.0, 200.0, 0.0); |]
  and spiral =
   [| (400.0, 250.0, 0.0); (400.0,  50.0, 0.0);
      ( 50.0,  50.0, 0.0); ( 50.0, 400.0, 0.0);
      (350.0, 400.0, 0.0); (350.0, 100.0, 0.0);
      (100.0, 100.0, 0.0); (100.0, 350.0, 0.0);
      (300.0, 350.0, 0.0); (300.0, 150.0, 0.0);
      (150.0, 150.0, 0.0); (150.0, 300.0, 0.0);
      (250.0, 300.0, 0.0); (250.0, 200.0, 0.0);
      (200.0, 200.0, 0.0); (200.0, 250.0, 0.0); |]
  and quad1 =
   [| ( 50.0, 150.0, 0.0); (350.0, 150.0, 0.0);
      (350.0, 200.0, 0.0); ( 50.0, 200.0, 0.0); |]
  and quad2 =
   [| (100.0, 100.0, 0.0); (300.0, 100.0, 0.0);
      (300.0, 350.0, 0.0); (100.0, 350.0, 0.0); |]
  and tri = 
   [| (200.0,  50.0, 0.0); (250.0, 300.0, 0.0);
      (150.0, 300.0, 0.0); |]
  in
  function () ->
 
  gluTessProperty tobj (GLU_TESS_WINDING_RULE !currentWinding);

  glNewList !dli GL_COMPILE;
    gluTessBeginPolygon tobj;
      gluTessBeginContour tobj;
      for i = 0 to pred 4 do
        let x, y, z = rects.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
      gluTessBeginContour tobj;
      for i = 4 to pred 8 do
        let x, y, z = rects.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
      gluTessBeginContour tobj;
      for i = 8 to pred 12 do
        let x, y, z = rects.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
    gluTessEndPolygon tobj;
  glEndList();

  glNewList (!dli+1) GL_COMPILE;
    gluTessBeginPolygon tobj;
      gluTessBeginContour tobj;
      for i = 0 to pred 4 do
        let x, y, z = rects.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
      gluTessBeginContour tobj;
      for i = 7 downto 4 do
        let x, y, z = rects.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
      gluTessBeginContour tobj;
      for i = 11 downto 8 do
        let x, y, z = rects.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
    gluTessEndPolygon tobj;
  glEndList();

  glNewList (!dli+2) GL_COMPILE;
    gluTessBeginPolygon tobj;
      gluTessBeginContour tobj;
      for i = 0 to pred 16 do
        let x, y, z = spiral.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
    gluTessEndPolygon tobj;
  glEndList();

  glNewList (!dli+3) GL_COMPILE;
    gluTessBeginPolygon tobj;
      gluTessBeginContour tobj;
      for i = 0 to pred 4 do
        let x, y, z = quad1.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
      gluTessBeginContour tobj;
      for i = 0 to pred 4 do
        let x, y, z = quad2.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
      gluTessBeginContour tobj;
      for i = 0 to pred 3 do
        let x, y, z = tri.(i) in
        gluTessVertex tobj x y z;
      done;
      gluTessEndContour tobj;
    gluTessEndPolygon tobj;
  glEndList();
;;


let display () =
  glClear [GL_COLOR_BUFFER_BIT];
  glColor3 1.0 1.0 1.0;
  glPushMatrix(); 
  glCallList (!dli);
  glTranslate 0.0 500.0 0.0;
  glCallList (!dli+1);
  glTranslate (500.0) (-500.0) (0.0);
  glCallList (!dli+2);
  glTranslate 0.0 500.0 0.0;
  glCallList (!dli+3);
  glPopMatrix(); 
  glFlush();
;;


let init() =
  glClearColor 0.0 0.0 0.0 0.0;
  glShadeModel GL_FLAT;

  dli := glGenLists 4;
  makeNewLists();
;;


let reshape ~width:w ~height:h =

  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if (w <= h) then
     gluOrtho2D 0.0 1000.0 0.0 (1000.0 *. (float h) /. (float w))
  else
     gluOrtho2D 0.0 (1000.0 *. (float w) /. (float h)) 0.0 1000.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let keyboard ~key ~x ~y =
  match key with
  | 'W' | 'w' ->
      begin match !currentWinding with
      | GLU_TESS_WINDING_ODD ->
          currentWinding := GLU_TESS_WINDING_NONZERO;
      | GLU_TESS_WINDING_NONZERO ->
          currentWinding := GLU_TESS_WINDING_POSITIVE;
      | GLU_TESS_WINDING_POSITIVE ->
          currentWinding := GLU_TESS_WINDING_NEGATIVE;
      | GLU_TESS_WINDING_NEGATIVE ->
          currentWinding := GLU_TESS_WINDING_ABS_GEQ_TWO;
      | GLU_TESS_WINDING_ABS_GEQ_TWO ->
          currentWinding := GLU_TESS_WINDING_ODD;
      end;
      makeNewLists();
      glutPostRedisplay();

  | 'Q' | 'q' | '\027' -> exit 0;
  | _ -> ()
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 500 500;
  ignore(glutCreateWindow Sys.argv.(0));

  let version = gluGetString GLU_VERSION in
  if version < "1.2" then begin
    Printf.eprintf
      "This program demonstrates the new tesselator API in GLU 1.2.\n\
       Your GLU library does not support this new interface, sorry.\n%!";
    exit 1;
  end;

  init();
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;


