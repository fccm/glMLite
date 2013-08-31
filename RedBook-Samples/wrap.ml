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

(*  wrap.ml
 *  This program texture maps a checkerboard image onto
 *  two rectangles.  This program demonstrates the wrapping
 *  modes, if the texture coordinates fall outside 0.0 and 1.0.
 *  Interaction: Pressing the 's' and 'S' keys switch the
 *  wrapping between clamping and repeating for the s parameter.
 *  The 't' and 'T' keys control the wrapping for the t parameter.
 *
 *  If running this program on OpenGL 1.0, texture objects are
 *  not used.
 *)
open GL
open Glu
open Glut

(*	Create checkerboard texture	*)
let checkImageWidth  = 64
let checkImageHeight = 64


let makeCheckImage() =
  let checkImage = Bigarray.Array3.create Bigarray.int8_unsigned Bigarray.c_layout
                       checkImageHeight checkImageWidth 4 in
    
  for i = 0 to pred checkImageHeight do
    for j = 0 to pred checkImageWidth do
      let ( = ) a b =
        if a = b then 1 else 0
      in
      let c = (((i land 0x8)=0) lxor ((j land 0x8)=0)) * 255 in
      checkImage.{i,j,0} <- c;
      checkImage.{i,j,1} <- c;
      checkImage.{i,j,2} <- c;
      checkImage.{i,j,3} <- 255;
    done;
  done;
  (Bigarray.genarray_of_array3 checkImage)
;;

let init() =
  glClearColor 0.0 0.0 0.0 0.0;
  glShadeModel GL_FLAT;
  glEnable GL_DEPTH_TEST;

  let checkImage = makeCheckImage() in
  glPixelStorei GL_UNPACK_ALIGNMENT 1;

  let texName = glGenTexture() in
  glBindTexture BindTex.GL_TEXTURE_2D texName;

  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_S  GL_REPEAT);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_T  GL_REPEAT);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER  Mag.GL_NEAREST);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER  Min.GL_NEAREST);

  glTexImage2D TexTarget.GL_TEXTURE_2D  0  InternalFormat.GL_RGBA
               checkImageWidth  checkImageHeight
               GL_RGBA GL_UNSIGNED_BYTE checkImage;
  (texName)
;;

let display texName () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glEnable GL_TEXTURE_2D;
  glTexEnv TexEnv.GL_TEXTURE_ENV  TexEnv.GL_TEXTURE_ENV_MODE  TexEnv.GL_DECAL;
  glBindTexture BindTex.GL_TEXTURE_2D texName;

  glBegin GL_QUADS;
  glTexCoord2 0.0 0.0;  glVertex3 (-2.0) (-1.0) (0.0);
  glTexCoord2 0.0 3.0;  glVertex3 (-2.0) ( 1.0) (0.0);
  glTexCoord2 3.0 3.0;  glVertex3 ( 0.0) ( 1.0) (0.0);
  glTexCoord2 3.0 0.0;  glVertex3 ( 0.0) (-1.0) (0.0);

  glTexCoord2 0.0 0.0;  glVertex3 (1.0) (-1.0) (0.0);
  glTexCoord2 0.0 3.0;  glVertex3 (1.0) ( 1.0) (0.0);
  glTexCoord2 3.0 3.0;  glVertex3 (2.41421) ( 1.0) (-1.41421);
  glTexCoord2 3.0 0.0;  glVertex3 (2.41421) (-1.0) (-1.41421);
  glEnd();
  glFlush();
  glDisable GL_TEXTURE_2D;
;;

let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 60.0 (float w /. float h) 1.0 30.0;
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
  glTranslate 0.0 0.0 (-3.6);
;;

(* ARGSUSED1 *)
let keyboard ~key ~x ~y =
  match key with
  | 's' ->
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_S  GL_CLAMP);
      glutPostRedisplay();
  | 'S' ->
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_S  GL_REPEAT);
      glutPostRedisplay();
  | 't' ->
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_T  GL_CLAMP);
      glutPostRedisplay();
  | 'T' ->
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_T  GL_REPEAT);
      glutPostRedisplay();
  | '\027' ->  (* escape *)
      exit(0);
  | _ -> ()
;;

let () =
  let _ = glutInit Sys.argv in
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB; GLUT_DEPTH];
  glutInitWindowSize 250 250;
  glutInitWindowPosition 100 100;
  let _ = glutCreateWindow Sys.argv.(0) in
  let texName = init() in
  glutDisplayFunc ~display:(display texName);
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMainLoop();
;;

