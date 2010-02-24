(* FTGL test *)
open GL
open Glu
open Glut
open Ftgl

let initGL ~width ~height =
  glClearColor 0.0 0.0 0.0 0.0;
  glClearDepth 1.0;
  glDepthFunc GL_LESS;
  glEnable GL_DEPTH_TEST;
  glShadeModel GL_SMOOTH;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 45.0 ((float width)/.(float height)) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;

let reshape ~width ~height =
  let height =
    if height = 0 then 1 else height  (* Prevent a divide by zero *)
  in
  glViewport 0 0 width height;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 45.0 ((float width)/.(float height)) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;

let display ~font () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glLoadIdentity();

  glTranslate (0.0) (0.0) (0.0);

  (* Set the font size and render a small text. *)
  ftglSetFontFaceSize font 72 72;
  ftglRenderFont font "Hello World!" FTGL_RENDER_ALL;

  glutSwapBuffers();
;;


let keyPressed ~window ~font ~key ~x ~y =
  match key with
  | 'q' | '\027' ->

      (* Destroy the font object. *)
      ftglDestroyFont ~font;

      glutDestroyWindow window;
      exit(0);                   

  | _ -> ()
;;

let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGBA; GLUT_DOUBLE; GLUT_ALPHA; GLUT_DEPTH];
  glutInitWindowSize 640 480;
  glutInitWindowPosition 0 0;

  let window =
    glutCreateWindow "FTGL Test"
  in

  (* Create a pixmap font from a TrueType file. *)
  let font = ftglCreatePixmapFont "/usr/share/fonts/ttf/western/Adventure.ttf" in

  glutDisplayFunc ~display:(display ~font);
  glutFullScreen();

  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard:(keyPressed ~window ~font);

  initGL 640 480;

  glutMainLoop();  
;;

