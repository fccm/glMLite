(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=06

 (OCaml version by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)


(* floats for x rotation, y rotation, z rotation *)
let xrot = ref 0.0
let yrot = ref 0.0
let zrot = ref 0.0


(* storage for one texture  *)
let texture = ref None

let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;

let ( !! ) = function {contents = Some v} -> v | _ -> raise Exit ;;


(* Load Bitmaps And Convert To Textures *)
let loadGLTextures() =
  (* Load Texture *)
  let image_data, sizeX, sizeY, tex_internal_fmt, pixel_data_fmt =
    Png_loader.load_img (Filename "Data/lesson6/NeHe.png")
  in

  (* Create Texture  *)
  let _texture = glGenTexture() in
  glBindTexture BindTex.GL_TEXTURE_2D _texture;   (* 2d texture (x and y size) *)
  texture := Some _texture;

  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR); (* scale linearly when image bigger than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR); (* scale linearly when image smalled than texture *)

  (* 2d texture, level of detail 0 (normal), 3 components (red, green, blue), x size from image, y size from image, 
     border 0 (normal), rgb color data, unsigned byte data, and finally the data itself. *)
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;
;;

(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                   (* We call this right after our OpenGL window is created. *)
  loadGLTextures();                           (* Load The Texture(s) *)
  glEnable GL_TEXTURE_2D;                     (* Enable Texture Mapping *)
  glClearColor 0.1 0.2 0.7 0.0;               (* Clear The Background Color To Blue *)
  glClearDepth 1.0;                           (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                        (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;                     (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;                     (* Enables Smooth Color Shading *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                           (* Reset The Projection Matrix *)

  gluPerspective 45.0 ((float width) /. (float height)) 0.1 100.0;  (* Calculate The Aspect Ratio Of The Window *)

  glMatrixMode GL_MODELVIEW;
;;


(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reSizeGLScene ~width ~height =
  let height =
    if height = 0                             (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in

  glViewport 0 0 width height;                (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0 ((float width) /. (float height)) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The main drawing function. *)
let drawGLScene() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];  (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                           (* Reset The View *)

  glTranslate 0.0 0.0 (-5.0);                 (* move 5 units into the screen. *)

  glRotate !xrot 1.0 0.0 0.0;                 (* Rotate On The X Axis *)
  glRotate !yrot 0.0 1.0 0.0;                 (* Rotate On The Y Axis *)
  glRotate !zrot 0.0 0.0 1.0;                 (* Rotate On The Z Axis *)

  glBindTexture BindTex.GL_TEXTURE_2D !!texture;   (* choose the texture to use. *)

  glBegin GL_QUADS;                           (* begin drawing a cube *)

  (* Front Face (note that the texture's corners have to match the quad's corners) *)
  glTexCoord2 0.0 0.0; glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Top Left Of The Texture and Quad *)

  (* Back Face *)
  glTexCoord2 1.0 0.0; glVertex3 (-1.0) (-1.0) (-1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 ( 1.0) (-1.0) (-1.0);  (* Bottom Left Of The Texture and Quad *)

  (* Top Face *)
  glTexCoord2 0.0 1.0; glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)

  (* Bottom Face *)
  glTexCoord2 1.0 1.0; glVertex3 (-1.0) (-1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 ( 1.0) (-1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)

  (* Right face *)
  glTexCoord2 1.0 0.0; glVertex3 ( 1.0) (-1.0) (-1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)

  (* Left Face *)
  glTexCoord2 0.0 0.0; glVertex3 (-1.0) (-1.0) (-1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)

  glEnd();                                    (* done with the polygon. *)

  (* Now we increase the value of xrot, yrot and zrot.
     Try changing the number each variable increases by to make the cube spin faster
     or slower, or try changing a + to a - to make the cube spin the other direction. *)
  xrot += 0.2;                                (* X Axis Rotation *)
  yrot += 0.2;                                (* Y Axis Rotation *)
  zrot += 0.2;                                (* Z Axis Rotation *)

  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glutSwapBuffers();
;;


(* The function called whenever a key is pressed. *)
let keyPressed ~window ~key ~x ~y =
  (* If escape is pressed, kill everything. *)
  if (key = '\027') then
  begin
    (* shut down our window *)
    glutDestroyWindow window;
    
    (* exit the program...normal termination. *)
    exit(0);                   
  end;
;;


(* main *)
let () =
  (* Initialize GLUT state - glut will take any command line arguments that
     pertain to it or X Windows - look at its documentation at:
     http://www.opengl.org/resources/libraries/glut/spec3/node10.html *)
  ignore(glutInit Sys.argv);

  (* Select type of Display mode:   
   Double buffer 
   RGBA color
   Alpha components supported 
   Depth buffer *)  
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

