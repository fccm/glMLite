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

(*  drawf.ml
 *  Draws the bitmapped letter F on the screen (several times).
 *  This demonstrates use of the glBitmap() call.
 *)
open GL
open Glu
open Glut

let rasters =
  Bigarray.Array1.of_array Bigarray.int8_unsigned Bigarray.c_layout [|
    0xc0; 0x00; 0xc0; 0x00; 0xc0; 0x00; 0xc0; 0x00; 0xc0; 0x00;
    0xff; 0x00; 0xff; 0x00; 0xc0; 0x00; 0xc0; 0x00; 0xc0; 0x00;
    0xff; 0xc0; 0xff; 0xc0 |]

let init() =
  glPixelStorei GL_UNPACK_ALIGNMENT 1;
  glClearColor 0.0 0.0 0.0 0.0;
;;

let display() =
  glClear [GL_COLOR_BUFFER_BIT];
  glColor3 1.0 1.0 1.0;
  glRasterPos2i 20 20;
  glBitmap 10 12 0.0 0.0 11.0 0.0 rasters;
  glBitmap 10 12 0.0 0.0 11.0 0.0 rasters;
  glBitmap 10 12 0.0 0.0 11.0 0.0 rasters;
  glFlush();
;;

let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glOrtho 0.0 (float w) 0.0 (float h) (-1.0) (1.0);
  glMatrixMode GL_MODELVIEW;
;;

let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit 0
  | _ -> ()

(*  Main Loop
 *  Open window with initial window size, title bar, 
 *  RGBA display mode, and handle input events.
 *)
let () =
  let _ = glutInit Sys.argv in
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 100 100;
  glutInitWindowPosition 100 100;
  let _ = glutCreateWindow Sys.argv.(0) in
  init();
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutDisplayFunc ~display;
  glutMainLoop();
;;

