open GL
open Glu
open Glut

let b_down = ref false
let anglex = ref 0
let angley = ref 0
let xold = ref 0
let yold = ref 0

(* {{{ callback display *)

let display () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glLoadIdentity();

  gluLookAt 0.0 0.0 2.5 0.0 0.0 0.0 0.0 1.0 0.0;

  glRotate (float !angley) 1.0 0.0 0.0;
  glRotate (float !anglex) 0.0 1.0 0.0;

  (*
  glDisable GL_BLEND;
  glColor3v (0.2, 1.0, 0.0);
  glutWireTorus ~innerRadius:0.2 ~outerRadius:1.4 ~sides:12 ~rings:32;
  glPushMatrix();
  glRotate (90.0) 0.0 1.0 0.0;
  glutWireTorus ~innerRadius:0.2 ~outerRadius:1.4 ~sides:12 ~rings:32;
  glPopMatrix();
  *)

  glEnable GL_BLEND;
  glColor3v (1.0, 1.0, 1.0);

  glBegin GL_QUADS;
  glTexCoord2 0.0 0.0;   glVertex3 (-0.5) ( 0.5) (0.5);
  glTexCoord2 0.0 1.0;   glVertex3 (-0.5) (-0.5) (0.5);
  glTexCoord2 1.0 1.0;   glVertex3 ( 0.5) (-0.5) (0.5);
  glTexCoord2 1.0 0.0;   glVertex3 ( 0.5) ( 0.5) (0.5);

  glTexCoord2 0.0 0.0;   glVertex3 (0.5) ( 0.5) ( 0.5);
  glTexCoord2 0.0 1.0;   glVertex3 (0.5) (-0.5) ( 0.5);
  glTexCoord2 1.0 1.0;   glVertex3 (0.5) (-0.5) (-0.5);
  glTexCoord2 1.0 0.0;   glVertex3 (0.5) ( 0.5) (-0.5);

  glTexCoord2 0.0 0.0;   glVertex3 ( 0.5) ( 0.5) (-0.5);
  glTexCoord2 0.0 1.0;   glVertex3 ( 0.5) (-0.5) (-0.5);
  glTexCoord2 1.0 1.0;   glVertex3 (-0.5) (-0.5) (-0.5);
  glTexCoord2 1.0 0.0;   glVertex3 (-0.5) ( 0.5) (-0.5);

  glTexCoord2 0.0 0.0;   glVertex3 (-0.5) ( 0.5) (-0.5);
  glTexCoord2 0.0 1.0;   glVertex3 (-0.5) (-0.5) (-0.5);
  glTexCoord2 1.0 1.0;   glVertex3 (-0.5) (-0.5) ( 0.5);
  glTexCoord2 1.0 0.0;   glVertex3 (-0.5) ( 0.5) ( 0.5);

  glTexCoord2 0.0 0.0;   glVertex3 (-0.5) (0.5) (-0.5);
  glTexCoord2 0.0 1.0;   glVertex3 (-0.5) (0.5) ( 0.5);
  glTexCoord2 1.0 1.0;   glVertex3 ( 0.5) (0.5) ( 0.5);
  glTexCoord2 1.0 0.0;   glVertex3 ( 0.5) (0.5) (-0.5);

  glTexCoord2 0.0 0.0;   glVertex3 (-0.5) (-0.5) (-0.5);
  glTexCoord2 1.0 0.0;   glVertex3 (-0.5) (-0.5) ( 0.5);
  glTexCoord2 1.0 1.0;   glVertex3 ( 0.5) (-0.5) ( 0.5);
  glTexCoord2 0.0 1.0;   glVertex3 ( 0.5) (-0.5) (-0.5);
  glEnd();

  glutSwapBuffers();
;;
(* }}} *)
(* {{{ callback keyboard *)

let keyboard ~key ~x ~y =
  match key with
  | 'l' ->
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER  Mag.GL_LINEAR);
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER  Min.GL_LINEAR);
      glutPostRedisplay();
  | 'n' ->
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER  Mag.GL_NEAREST);
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER  Min.GL_NEAREST);
      glutPostRedisplay();
  | 'p' ->
      glPolygonMode GL_FRONT_AND_BACK  GL_FILL;
      glutPostRedisplay();
  | 'f' ->
      glPolygonMode GL_FRONT_AND_BACK  GL_LINE;
      glutPostRedisplay();
  | 's' ->
      glPolygonMode GL_FRONT_AND_BACK  GL_POINT;
      glutPostRedisplay();
  | 'd' ->
      glEnable GL_DEPTH_TEST;
      glutPostRedisplay();
  | 'D' ->
      glDisable GL_DEPTH_TEST;
      glutPostRedisplay();
  | '\027' (* ESC key *)
  | 'q' -> exit(0)
  | _ -> ()
;;

(* }}} *)
(* {{{ callback mouse *)

let mouse ~button ~state ~x ~y =
  begin
    match button, state with
    (* if we press the left button *)
    | GLUT_LEFT_BUTTON, GLUT_DOWN ->
        b_down := true;
        xold := x;  (* save mouse position *)
        yold := y;
    (* if we release the left button *)
    | GLUT_LEFT_BUTTON, GLUT_UP ->
        b_down := false;

    (*
    | GLUT_RIGHT_BUTTON, GLUT_DOWN ->
        glMatrixMode GL_TEXTURE;
          glLoadIdentity();
          glTranslate (float x) (*float y*) 0. 0.;
          Printf.printf " %d %d\n%!" x y;
        (*
        glMatrixMode GL_MODELVIEW;
        *)
    | GLUT_MIDDLE_BUTTON, GLUT_DOWN ->
        glMatrixMode GL_MODELVIEW;
    *)
    | _ -> ()
  end;
;;
(* }}} *)
(* {{{ callback motion *)

let motion ~x ~y =
  if !b_down then  (* if the left button is down *)
  begin
 (* change the rotation angles according to the last position
    of the mouse and the new one *)
    anglex := !anglex + (x - !xold); 
    angley := !angley + (y - !yold);
    glutPostRedisplay();
  end;
  
  xold := x;
  yold := y;
;;
(* }}} *)
(* {{{ callback reshape *)

let reshape ~width:w ~height:h =
  (* Parameters of perspective projection *)
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective ~fovy:60.0 ~aspect:((float w) /. (float h)) ~zNear:0.2 ~zFar:8.0;
  glMatrixMode GL_MODELVIEW;
;;

(* }}} *)
(* {{{ utils *)

(** load the file contents in a string buffer *)
let file_contents filename =
  let buf = Buffer.create 4096
  and ic = open_in filename in
  try while true do
    Buffer.add_char buf (input_char ic);
  done;
  assert(false)
  with End_of_file ->
    close_in ic;
    (Buffer.contents buf)
;;
(* }}} *)

(* {{{ main *)

let () =
  (* texture image to load *)
  let filename = Sys.argv.(1) in

  (* test loading from memroy, instead of from a file *)
  let use_buffer = List.mem "-buf" (Array.to_list Sys.argv) in

  (* Only use the generic loader in the last case,
     because the specialised loaders (as the jpeg one for example) are optimised.
  *)
  let texture_loader =
    if Filename.check_suffix filename ".jpg" ||
       Filename.check_suffix filename ".jpeg"
    then Jpeg_loader.load_img   (* load a JPEG texture *)
    else
    if Filename.check_suffix filename ".png"
    then Png_loader.load_img    (* load a PNG texture *)
    else
    if Filename.check_suffix filename ".svg"
    then Svg_loader.load_img    (* load a texture rastered from an SVG file *)
    else Genimg_loader.load_img (* load any kind of texture through the libmagick *)
  in

  let texture, width, height, internal_format, pixel_data_format =
    if use_buffer
    then texture_loader (Buffer(file_contents Sys.argv.(1)))  (* test the buffer input *)
    else texture_loader (Filename Sys.argv.(1))               (* load directly from the file *)
  in
  assert_size ~width ~height;

  (* create the OpenGL window *)
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGBA; GLUT_DOUBLE; GLUT_DEPTH];
  glutInitWindowSize ~width:640  ~height:480;
  ignore(glutCreateWindow ~title:"jpeg texture demo");

  (* initialise OpenGL *)
  glClearColor ~r:0.0 ~g:0.0 ~b:0.0 ~a:0.0;
  glShadeModel GL_FLAT;
  glEnable GL_DEPTH_TEST;

  (* for textures with alpha channel *)
  glEnable GL_BLEND;
  glBlendFunc Sfactor.GL_SRC_ALPHA  Dfactor.GL_ONE_MINUS_SRC_ALPHA;
  glPolygonMode GL_FRONT_AND_BACK  GL_FILL;

  (* assumes clean models *)
  glFrontFace GL_CCW;
  (*
  glCullFace GL_FRONT;
  *)
  glCullFace GL_FRONT_AND_BACK;  (* for alpha *)

  let texid = glGenTexture() in
  glBindTexture BindTex.GL_TEXTURE_2D texid;

  (* cleanup *)
  at_exit(fun () -> glDeleteTexture texid);

  (* Parameters for applying the textures *)
  glTexParameter TexParam.GL_TEXTURE_2D  (TexParam.GL_TEXTURE_MAG_FILTER  Mag.GL_NEAREST);
  glTexParameter TexParam.GL_TEXTURE_2D  (TexParam.GL_TEXTURE_MIN_FILTER  Min.GL_NEAREST);
  glTexImage2D TexTarget.GL_TEXTURE_2D  0  internal_format  width height
               pixel_data_format  GL_UNSIGNED_BYTE  texture;
  glEnable GL_TEXTURE_2D;

  (* Glut callback functions *)
  glutDisplayFunc ~display;
  glutKeyboardFunc ~keyboard;
  glutMouseFunc ~mouse;
  glutMotionFunc ~motion;
  glutReshapeFunc ~reshape;

  glutMainLoop();
;;
(* }}} *)

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
