(*
 * (c) Copyright 1993, Silicon Graphics, Inc.
 *               1993-1995 Microsoft Corporation
 *
 * ALL RIGHTS RESERVED
 *
 *)

(*
 - Bitmap test.

 - RGBA/CI (RGBA default), SB/DB (SB default).

 - Command line options:
   -rgb  RGBA mode.
   -ci  Color index mode.
   -sb  Single buffer mode.
   -db  Double buffer mode.
   Using CVI, in the project window use the "Options/Command Line..." option to type in
   "-db" or "-sb" for example:
 - Keys:
   ESC  Quit.
*)

(* converted to OCaml by F. Monnier *)

open GL
open Glu
open Glut

let opengl_width  = 24
let opengl_height = 13

(* enum *)
let util_white  = 0
let util_yellow = 1
let util_purple = 2
let util_red    = 3

let rgbMap = [| ( 1.0, 1.0, 1.0 );  (* WHITE  *)
                ( 1.0, 1.0, 0.0 );  (* YELLOW *)
                ( 1.0, 0.0, 1.0 );  (* PURPLE *)
                ( 1.0, 0.0, 0.0 );  (* RED    *)
             |] ;;

let util_setColor (x, y) =
  if glutGet(GLUT_WINDOW_RGBA) = 1
  then (glColor3v rgbMap.(y))
  else (glIndexi y)
;;


(* ------------------------------------------------------------------------- *)

let rgb = ref true ;;
let doubleBuffer = ref false ;;
let windType = ref [] ;;

let boxA = (0.,    0., 0.)
let boxB = (-100., 0., 0.)
let boxC = ( 100., 0., 0.)
let boxD = (0.,   95., 0.)
let boxE = (0., -105., 0.)

let openGL_bits1 = Bigarray.Array1.of_array
  Bigarray.int8_unsigned Bigarray.c_layout [|
   0x00; 0x03; 0x00;
   0x7f; 0xfb; 0xff;
   0x7f; 0xfb; 0xff;
   0x00; 0x03; 0x00;
   0x3e; 0x8f; 0xb7;
   0x63; 0xdb; 0xb0;
   0x63; 0xdb; 0xb7;
   0x63; 0xdb; 0xb6;
   0x63; 0x8f; 0xf3;
   0x63; 0x00; 0x00;
   0x63; 0x00; 0x00;
   0x63; 0x00; 0x00;
   0x3e; 0x00; 0x00;
 |]

let openGL_bits2 = Bigarray.Array1.of_array
  Bigarray.int8_unsigned Bigarray.c_layout [|
   0x00; 0x00; 0x00;
   0xff; 0xff; 0x01;
   0xff; 0xff; 0x01;
   0x00; 0x00; 0x00;
   0xf9; 0xfc; 0x01;
   0x8d; 0x0d; 0x00;
   0x8d; 0x0d; 0x00;
   0x8d; 0x0d; 0x00;
   0xcc; 0x0d; 0x00;
   0x0c; 0x4c; 0x0a;
   0x0c; 0x4c; 0x0e;
   0x8c; 0xed; 0x0e;
   0xf8; 0x0c; 0x00;
 |]

let logo_bits = Bigarray.Array1.of_array
  Bigarray.int8_unsigned Bigarray.c_layout [|
   0x00; 0x66; 0x66;
   0xff; 0x66; 0x66;
   0x00; 0x00; 0x00;
   0xff; 0x3c; 0x3c;
   0x00; 0x42; 0x40;
   0xff; 0x42; 0x40;
   0x00; 0x41; 0x40;
   0xff; 0x21; 0x20;
   0x00; 0x2f; 0x20;
   0xff; 0x20; 0x20;
   0x00; 0x10; 0x90;
   0xff; 0x10; 0x90;
   0x00; 0x0f; 0x10;
   0xff; 0x00; 0x00;
   0x00; 0x66; 0x66;
   0xff; 0x66; 0x66;
 |]

let glRasterPos3v ~v =
  let x, y, z = v in
  glRasterPos3 ~x ~y ~z;
;;

(* ------------------------------------------------------------------------- *)
let init() =
  glClearColor 0.0 0.0 0.0 0.0;
  glClearIndex 0.0;
;;

(* ------------------------------------------------------------------------- *)
let reshape ~width ~height =
  glViewport 0 0 width height;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluOrtho2D (-175.) (175.) (-175.) (175.);
  glMatrixMode GL_MODELVIEW;
;;


(* ------------------------------------------------------------------------- *)
let display() =

  glClear [GL_COLOR_BUFFER_BIT];

  let mapI  = [| 0.0; 1.0 |]
  and mapIR = [| 0.0; 0.0 |]
  and mapIA = [| 1.0; 1.0 |] in
  
  glPixelMapfv GL_PIXEL_MAP_I_TO_R mapIR;
  glPixelMapfv GL_PIXEL_MAP_I_TO_G mapI;
  glPixelMapfv GL_PIXEL_MAP_I_TO_B mapI;
  glPixelMapfv GL_PIXEL_MAP_I_TO_A mapIA;
  glPixelTransferb GL_MAP_COLOR true;

  util_setColor(windType, util_white);
  glRasterPos3v boxA;
  glPixelStorei GL_UNPACK_ROW_LENGTH 24;
  glPixelStorei GL_UNPACK_SKIP_PIXELS 8;
  glPixelStorei GL_UNPACK_SKIP_ROWS 2;
  glPixelStoreb GL_UNPACK_LSB_FIRST false;
  glPixelStorei GL_UNPACK_ALIGNMENT 1;
  glBitmap 16 12 8.0 0.0 0.0 0.0 logo_bits;

  glPixelStorei GL_UNPACK_ROW_LENGTH 0;
  glPixelStorei GL_UNPACK_SKIP_PIXELS 0;
  glPixelStorei GL_UNPACK_SKIP_ROWS 0;
  glPixelStoreb GL_UNPACK_LSB_FIRST true;
  glPixelStorei GL_UNPACK_ALIGNMENT 1;

  util_setColor(windType, util_white);
  glRasterPos3v boxB;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits1;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits2;

  util_setColor(windType, util_yellow);
  glRasterPos3v boxC;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits1;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits2;

  util_setColor(windType, util_purple);
  glRasterPos3v boxD;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits1;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits2;

  util_setColor(windType, util_red);
  glRasterPos3v boxE;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits1;
  glBitmap opengl_width opengl_height (float opengl_width) 0.0 (float opengl_width) 0.0 openGL_bits2;

  glFlush();

  if !doubleBuffer then
    glutSwapBuffers();
;;


(* ------------------------------------------------------------------------- *)
let keyboard ~key ~x ~y =
  match key with
  | '\027' -> exit(0);  (* Escape key *)
  | _ -> ()
;;


(* ------------------------------------------------------------------------- *)
let args() =
  let argc = Array.length Sys.argv in
  let argv = Array.sub Sys.argv 1 (argc - 1) in

  Array.iter (fun arg ->
    match arg with
    | "-ci"  -> rgb := false;
    | "-rgb" -> rgb := true;
    | "-sb"  -> doubleBuffer := false;
    | "-db"  -> doubleBuffer := true;
    | _ -> failwith "unrecognised argument"
  ) argv;
;;


(* ------------------------------------------------------------------------- *)
let () =
  args();

  ignore(glutInit Sys.argv);
  glutInitWindowSize 800 800;
 
  windType :=
    (if !rgb then GLUT_RGB else GLUT_INDEX) ::
    (if !doubleBuffer then GLUT_DOUBLE else GLUT_SINGLE) ::
    !windType;

  glutInitDisplayMode !windType;
  ignore(glutCreateWindow Sys.argv.(0));
  
  init();

  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutDisplayFunc ~display;
  glutMainLoop();
;;

