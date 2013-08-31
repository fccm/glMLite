(* http://creativecommons.org/licenses/publicdomain/ *)

(* This OCaml-OpenGL script is made to display sky-boxes.
   You can find very nice sky-boxes that this script can display here:
   http://www.humus.name/index.php?page=Textures  *)

open GL
open Glu
open Glut

let usage() =
  Printf.printf "%s <skybox-directory>\n" Sys.argv.(0);
  exit 1
;;

(* give the directory where to find the sky-box images *)
let skybox_images_dir =
  if Array.length Sys.argv < 2 then usage();
  Sys.argv.(1)
;;

(* loading textures *)

type image_data = {
  width : int;
  height : int;
  pixels : GL.image_data;
  internal_format : GL.tex_internal_format;
  pixel_data_format : pixel_data_format;
}


let load_textures() =
  let src_img =
    (* images files *)
    [| Filename.concat skybox_images_dir "negz.jpg";
       Filename.concat skybox_images_dir "negx.jpg";
       Filename.concat skybox_images_dir "posz.jpg";
       Filename.concat skybox_images_dir "posx.jpg";
       Filename.concat skybox_images_dir "posy.jpg";
       Filename.concat skybox_images_dir "negy.jpg"; |]
  in
  let read_jpeg filename =
    (* load one texture *)
    let pixels, width, height, internal_format, pixel_data_format =
      Jpeg_loader.load_img (Filename filename)
    in
    {
      width = width;
      height = height;
      pixels = pixels;
      internal_format = internal_format;
      pixel_data_format = pixel_data_format;
    }
  in
  let image = Array.map read_jpeg src_img in  (* load images *)

  (* create OpenGL textures ids *)
  let textures = glGenTextures 6 in

  for i=0 to pred 6 do
    (* select the texture *)
    glBindTexture2D textures.(i);

    (* define the parameters of the textures *)
    (* how the texture should wrap in S direction *)
    glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_S  GL_CLAMP);
    (* how the texture should wrap in T direction *)
    glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_WRAP_T  GL_CLAMP);
    (* how the texture lookup should be interpolated when the face is smaller than the texture *)
    glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER  Min.GL_NEAREST);
    (* how the texture lookup should be interpolated when the face is bigger than the texture *)
    glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER  Mag.GL_NEAREST);

    (* send the texture image to the renderer *)
    glTexImage2D TexTarget.GL_TEXTURE_2D  0  image.(i).internal_format
                 image.(i).width  image.(i).height
                 image.(i).pixel_data_format  GL_UNSIGNED_BYTE  image.(i).pixels;
  done;
  (textures)
;;

(* display sky-box *)
let display_sky_box ~size ~textures =
  glEnable GL_TEXTURE_2D;
  glColor3 1.0 1.0 1.0;
  glPushMatrix();
  glScale (-1.0) 1.0 1.0;

    (* front face *)
    glBindTexture2D textures.(2);
    glBegin GL_QUADS;
    glNormal3 (0.0) (0.0) (-1.0);
    glTexCoord2 0.0 0.0; glVertex3 (-.size) (  size) (  size);
    glTexCoord2 1.0 0.0; glVertex3 (  size) (  size) (  size);
    glTexCoord2 1.0 1.0; glVertex3 (  size) (-.size) (  size);
    glTexCoord2 0.0 1.0; glVertex3 (-.size) (-.size) (  size);
    glEnd();

    (* right face *)
    glBindTexture2D textures.(3);
    glBegin GL_QUADS;
    glNormal3 (-1.0) (0.0) (0.0);
    glTexCoord2 0.0 0.0; glVertex3 (  size) (  size) (  size);
    glTexCoord2 1.0 0.0; glVertex3 (  size) (  size) (-.size);
    glTexCoord2 1.0 1.0; glVertex3 (  size) (-.size) (-.size);
    glTexCoord2 0.0 1.0; glVertex3 (  size) (-.size) (  size);
    glEnd();

    (* back face *)
    glBindTexture2D textures.(0);
    glBegin GL_QUADS;
    glNormal3 0.0 0.0 1.0;
    glTexCoord2 0.0 0.0; glVertex3 (  size) (  size) (-.size);
    glTexCoord2 1.0 0.0; glVertex3 (-.size) (  size) (-.size);
    glTexCoord2 1.0 1.0; glVertex3 (-.size) (-.size) (-.size);
    glTexCoord2 0.0 1.0; glVertex3 (  size) (-.size) (-.size);
    glEnd();

    (* left face *)
    glBindTexture2D textures.(1);
    glBegin GL_QUADS;
    glNormal3 1.0 0.0 0.0;
    glTexCoord2 0.0 0.0; glVertex3 (-.size) (  size) (-.size);
    glTexCoord2 1.0 0.0; glVertex3 (-.size) (  size) (  size);
    glTexCoord2 1.0 1.0; glVertex3 (-.size) (-.size) (  size);
    glTexCoord2 0.0 1.0; glVertex3 (-.size) (-.size) (-.size);
    glEnd();

    (* top face *)
    glBindTexture2D textures.(4);
    glBegin GL_QUADS;
    glNormal3 (0.0) (-1.0) (0.0);
    glTexCoord2 0.0 0.0; glVertex3 (-.size) (  size) (-.size);
    glTexCoord2 1.0 0.0; glVertex3 (  size) (  size) (-.size);
    glTexCoord2 1.0 1.0; glVertex3 (  size) (  size) (  size);
    glTexCoord2 0.0 1.0; glVertex3 (-.size) (  size) (  size);
    glEnd();

    (* bottom face *)
    glBindTexture2D textures.(5);
    glBegin GL_QUADS;
    glNormal3 0.0 1.0 0.0;
    glTexCoord2 0.0 0.0; glVertex3 (-.size) (-.size) (  size);
    glTexCoord2 1.0 0.0; glVertex3 (  size) (-.size) (  size);
    glTexCoord2 1.0 1.0; glVertex3 (  size) (-.size) (-.size);
    glTexCoord2 0.0 1.0; glVertex3 (-.size) (-.size) (-.size);
    glEnd();

  glPopMatrix();
;;

let b_down = ref false
let anglex = ref (0)
let angley = ref (0)
let xold = ref 0
let yold = ref 0
let list_id = ref 0

(* load datas *)
let compile_list ~dirname =

  let textures = load_textures() in

  glNewList !list_id GL_COMPILE;
    display_sky_box ~size:8. ~textures;
  glEndList();
;;

(* callback display *)
let display () =
  glClear ~mask:[GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  glLoadIdentity();

  glRotate ~angle:(float(- !angley)) ~x:1.0 ~y:0.0 ~z:0.0;
  glRotate ~angle:(float(- !anglex)) ~x:0.0 ~y:1.0 ~z:0.0;

  glCallList !list_id;

  glFlush();
  glutSwapBuffers();
;;

(* callback reshape *)
let reshape ~width ~height =
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective ~aspect:(float width /. float height)
                 ~fovy:80. ~zNear:0.2 ~zFar:60.;
  glViewport 0 0 width height;
  glMatrixMode GL_MODELVIEW;
  glutPostRedisplay();
;;

(* callback keyboard *)
let keyboard ~key ~x ~y =
  match key with
  | '\027'
  | 'q' -> exit(0)
  | _ -> ()
;;

(* callback mouse *)
let mouse ~button ~state ~x ~y =
  match button, state with
  (* if we press the left button *)
  | GLUT_LEFT_BUTTON, GLUT_DOWN ->
      b_down := true;
      xold := x;  (* save mouse position *)
      yold := y;
  (* if we release the left button *)
  | GLUT_LEFT_BUTTON, GLUT_UP ->
      b_down := false;
  | _ -> ()
;;

(* callback motion *)
let motion ~x ~y =
  if !b_down then  (* if the left button is down *)
  begin
 (* change the rotation angles according to the last position
    of the mouse and the new one *)
    anglex := !anglex + (!xold - x);
    angley := !angley + (!yold - y);
    glutPostRedisplay();
  end;

  xold := x;
  yold := y;
;;

(* main init of GL & Glut *)
let () =
  ignore(glutInit Sys.argv);

  glutInitDisplayMode[GLUT_RGB; GLUT_DOUBLE; GLUT_DEPTH];
  glutInitWindowPosition ~x:200 ~y:200;
  glutInitWindowSize ~width:800 ~height:600;

  ignore(glutCreateWindow ~title:("Fly-Box " ^ skybox_images_dir));

  glClearColor ~r:0.0 ~g:0.0 ~b:0.0 ~a:0.0;

  (* init openGL *)
  glEnable GL_DEPTH_TEST;

  list_id := glGenLists 1;
  compile_list ~dirname:skybox_images_dir;

  (* callback functions *)
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMouseFunc ~mouse;
  glutMotionFunc ~motion;

  (* enter the main loop *)
  glutMainLoop();
;;
