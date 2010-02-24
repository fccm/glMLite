(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=05

 (OCaml version by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)


(* rotation angle for the triangle. *)
let rtri = ref 0.0

(* rotation angle for the quadrilateral. *)
let rquad = ref 0.0


(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                     (* We call this right after our OpenGL window is created. *)
  glClearColor 0.0 0.0 0.0 0.0;                 (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                             (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                          (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;                       (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;                       (* Enables Smooth Color Shading *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                             (* Reset The Projection Matrix *)

  gluPerspective 45.0 ((float width) /. (float height)) 0.1 100.0;  (* Calculate The Aspect Ratio Of The Window *)

  glMatrixMode GL_MODELVIEW;
;;


(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reSizeGLScene ~width ~height =
  let height =
    if height=0 then 1                          (* Prevent A Divide By Zero If The Window Is Too Small *)
    else height
  in

  glViewport 0 0 width height;                  (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0 ((float width) /. (float height)) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The main drawing function. *)
let drawGLScene() =

  glClear [GL_DEPTH_BUFFER_BIT; GL_COLOR_BUFFER_BIT];   (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                             (* Reset The View *)

  glTranslate (-1.5) (0.0) (-6.0);              (* Move Left 1.5 Units And Into The Screen 6.0 *)

  glRotate !rtri 0.0 1.0 0.0;                   (* Rotate The Pyramid On The Y axis *)

  (* draw a pyramid (in smooth coloring mode) *)
  glBegin GL_POLYGON;                           (* start drawing a pyramid *)

  (* front face of pyramid *)
  glColor3 1.0 0.0 0.0;                         (* Set The Color To Red *)
  glVertex3 (0.0) (1.0) (0.0);                  (* Top of triangle (front) *)
  glColor3 0.0 1.0 0.0;                         (* Set The Color To Green *)
  glVertex3 (-1.0) (-1.0) (1.0);                (* left of triangle (front) *)
  glColor3 0.0 0.0 1.0;                         (* Set The Color To Blue *)
  glVertex3 (1.0) (-1.0) (1.0);                 (* right of traingle (front) *)

  (* right face of pyramid *)
  glColor3 1.0 0.0 0.0;                         (* Red *)
  glVertex3 (0.0) (1.0) (0.0);                  (* Top Of Triangle (Right) *)
  glColor3 0.0 0.0 1.0;                         (* Blue *)
  glVertex3 (1.0) (-1.0) (1.0);                 (* Left Of Triangle (Right) *)
  glColor3 0.0 1.0 0.0;                         (* Green *)
  glVertex3 (1.0) (-1.0) (-1.0);                (* Right Of Triangle (Right) *)

  (* back face of pyramid *)
  glColor3 1.0 0.0 0.0;                         (* Red *)
  glVertex3 (0.0) (1.0) (0.0);                  (* Top Of Triangle (Back) *)
  glColor3 0.0 1.0 0.0;                         (* Green *)
  glVertex3 (1.0) (-1.0) (-1.0);                (* Left Of Triangle (Back) *)
  glColor3 0.0 0.0 1.0;                         (* Blue *)
  glVertex3 (-1.0) (-1.0) (-1.0);               (* Right Of Triangle (Back) *)

  (* left face of pyramid. *)
  glColor3 1.0 0.0 0.0;                         (* Red *)
  glVertex3 (0.0) (1.0) (0.0);                  (* Top Of Triangle (Left) *)
  glColor3 0.0 0.0 1.0;                         (* Blue *)
  glVertex3 (-1.0) (-1.0) (-1.0);               (* Left Of Triangle (Left) *)
  glColor3 0.0 1.0 0.0;                         (* Green *)
  glVertex3 (-1.0) (-1.0) (1.0);                (* Right Of Triangle (Left) *)

  glEnd();                                      (* Done Drawing The Pyramid *)

  glLoadIdentity();                             (* make sure we're no longer rotated. *)
  glTranslate (1.5) (0.0) (-7.0);               (* Move Right 3 Units, and back into the screen 7 *)

  glRotate !rquad 1.0 1.0 1.0;                  (* Rotate The Cube On X, Y, and Z *)

  (* draw a cube (6 quadrilaterals) *)
  glBegin GL_QUADS;                             (* start drawing the cube. *)

  (* top of cube *)
  glColor3 0.0 1.0 0.0;                         (* Set The Color To Blue *)
  glVertex3 ( 1.0) (1.0) (-1.0);                (* Top Right Of The Quad (Top) *)
  glVertex3 (-1.0) (1.0) (-1.0);                (* Top Left Of The Quad (Top) *)
  glVertex3 (-1.0) (1.0) ( 1.0);                (* Bottom Left Of The Quad (Top) *)
  glVertex3 ( 1.0) (1.0) ( 1.0);                (* Bottom Right Of The Quad (Top) *)

  (* bottom of cube *)
  glColor3 1.0 0.5 0.0;                         (* Set The Color To Orange *)
  glVertex3 ( 1.0) (-1.0) ( 1.0);               (* Top Right Of The Quad (Bottom) *)
  glVertex3 (-1.0) (-1.0) ( 1.0);               (* Top Left Of The Quad (Bottom) *)
  glVertex3 (-1.0) (-1.0) (-1.0);               (* Bottom Left Of The Quad (Bottom) *)
  glVertex3 ( 1.0) (-1.0) (-1.0);               (* Bottom Right Of The Quad (Bottom) *)

  (* front of cube *)
  glColor3 1.0 0.0 0.0;                         (* Set The Color To Red *)
  glVertex3 ( 1.0) ( 1.0) (1.0);                (* Top Right Of The Quad (Front) *)
  glVertex3 (-1.0) ( 1.0) (1.0);                (* Top Left Of The Quad (Front) *)
  glVertex3 (-1.0) (-1.0) (1.0);                (* Bottom Left Of The Quad (Front) *)
  glVertex3 ( 1.0) (-1.0) (1.0);                (* Bottom Right Of The Quad (Front) *)

  (* back of cube *)
  glColor3 1.0 1.0 0.0;                         (* Set The Color To Yellow *)
  glVertex3 ( 1.0) (-1.0) (-1.0);               (* Top Right Of The Quad (Back) *)
  glVertex3 (-1.0) (-1.0) (-1.0);               (* Top Left Of The Quad (Back) *)
  glVertex3 (-1.0) ( 1.0) (-1.0);               (* Bottom Left Of The Quad (Back) *)
  glVertex3 ( 1.0) ( 1.0) (-1.0);               (* Bottom Right Of The Quad (Back) *)

  (* left of cube *)
  glColor3 0.0 0.0 1.0;                         (* Blue *)
  glVertex3 (-1.0) ( 1.0) ( 1.0);               (* Top Right Of The Quad (Left) *)
  glVertex3 (-1.0) ( 1.0) (-1.0);               (* Top Left Of The Quad (Left) *)
  glVertex3 (-1.0) (-1.0) (-1.0);               (* Bottom Left Of The Quad (Left) *)
  glVertex3 (-1.0) (-1.0) ( 1.0);               (* Bottom Right Of The Quad (Left) *)

  (* Right of cube *)
  glColor3 1.0 0.0 1.0;                         (* Set The Color To Violet *)
  glVertex3 ( 1.0) ( 1.0) (-1.0);               (* Top Right Of The Quad (Right) *)
  glVertex3 ( 1.0) ( 1.0) ( 1.0);               (* Top Left Of The Quad (Right) *)
  glVertex3 ( 1.0) (-1.0) ( 1.0);               (* Bottom Left Of The Quad (Right) *)
  glVertex3 ( 1.0) (-1.0) (-1.0);               (* Bottom Right Of The Quad (Right) *)
  glEnd();                                      (* Done Drawing The Cube *)

  rtri := !rtri +. 15.0;                        (* Increase The Rotation Variable For The Pyramid *)
  rquad := !rquad -. 15.0;                      (* Decrease The Rotation Variable For The Cube *)

  (* swap the buffers to display, since double buffering is used. *)
  glutSwapBuffers();
;;


(* The function called whenever a key is pressed. *)
let keyPressed ~window ~key ~x ~y =

  (* If escape is pressed, kill everything. *)
  if key = '\027' then
  begin
    (* shut down our window *)
    glutDestroyWindow window;

    (* exit the program...normal termination. *)
    exit 0;
  end;
;;


let () =
  (* Initialize GLUT state - glut will take any command line arguments that
     pertain to it or X Windows - look at its documentation at:
     http://www.opengl.org/resources/libraries/glut/spec3/node10.html *)
  ignore(glutInit Sys.argv);

  (* Select type of Display mode:
     Double buffer
     RGBA color
     Alpha components supported
     Depth buffered for automatic clipping *)
  glutInitDisplayMode [GLUT_RGBA; GLUT_DOUBLE; GLUT_ALPHA; GLUT_DEPTH];

  (* get a 640 x 480 window *)
  glutInitWindowSize 640 480;

  (* the window starts at the upper left corner of the screen *)
  glutInitWindowPosition 0 0;

  (* Open a window *)
  let window = glutCreateWindow "Jeff Molofee's GL Code Tutorial ... NeHe '99" in

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc drawGLScene;

  (* Go fullscreen.  This is as soon as possible. *)
  glutFullScreen();

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc drawGLScene;

  (* Register the function called when our window is resized. *)
  glutReshapeFunc reSizeGLScene;

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc (keyPressed ~window);

  (* Initialize our window. *)
  initGL 640 480;

  (* Start Event Processing Engine *)
  glutMainLoop();
;;

