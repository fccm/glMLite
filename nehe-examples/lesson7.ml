(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=07

 (OCaml version by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)


(* lighting on/off (1 = on, 0 = off) *)
let light = ref false

let xrot = ref 0.0   (* x rotation *)
let yrot = ref 0.0   (* y rotation *)
let xspeed = ref 0.0 (* x rotation speed *)
let yspeed = ref 0.0 (* y rotation speed *)

let z = ref (-5.0)   (* depth into the screen. *)


(* white ambient light at half intensity (rgba) *)
let lightAmbient = (0.5, 0.5, 0.5, 1.0)

(* super bright, full intensity diffuse light. *)
let lightDiffuse = (1.0, 1.0, 1.0, 1.0)

(* position of light (x, y, z, (position of light)) *)
let lightPosition = (0.0, 0.0, 2.0, 1.0)

let filter = ref 0        (* Which Filter To Use (nearest/linear/mipmapped) *)

let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;


(* Load Bitmaps And Convert To Textures *)
let loadGLTextures() =
  (* Load Texture *)
  let image_data, sizeX, sizeY, tex_internal_fmt, pixel_data_fmt =
    Png_loader.load_img (Filename "Data/lesson7/crate.png")
  in

  (* Create Textures *)
  let texture = glGenTextures 3 in

  (* texture 1 (poor quality scaling) *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(0);   (* 2d texture (x and y size) *)

  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_NEAREST); (* cheap scaling when image bigger than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_NEAREST); (* cheap scaling when image smalled than texture *)

  (* 2d texture, level of detail 0 (normal), 3 components (red, green, blue), x size from image, y size from image,
     border 0 (normal), rgb color data, unsigned byte data, and finally the data itself. *)
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (* texture 2 (linear scaling) *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(1);   (* 2d texture (x and y size) *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR); (* scale linearly when image bigger than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR); (* scale linearly when image smalled than texture *)
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (* texture 3 (mipmapped scaling) *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(2);   (* 2d texture (x and y size) *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR); (* scale linearly when image bigger than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR_MIPMAP_NEAREST); (* scale linearly + mipmap when image smalled than texture *)
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (* 2d texture, 3 colors, width, height, RGB in that order, byte data, and the data. *)
  gluBuild2DMipmaps InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (texture)
;;



(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                   (* We call this right after our OpenGL window is created. *)
  let texture = loadGLTextures() in           (* load the textures. *)
  glEnable GL_TEXTURE_2D;                     (* Enable texture mapping. *)

  glClearColor 0.0 0.0 0.0 0.0;               (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                           (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                        (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;                     (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;                     (* Enables Smooth Color Shading *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                           (* Reset The Projection Matrix *)

  gluPerspective 45.0 ((float width)/.(float height)) 0.1 100.0;  (* Calculate The Aspect Ratio Of The Window *)

  glMatrixMode GL_MODELVIEW;

  (* set up light number 1. *)
  glLight (GL_LIGHT 1) (Light.GL_AMBIENT  lightAmbient);  (* add lighting (ambient). *)
  glLight (GL_LIGHT 1) (Light.GL_DIFFUSE  lightDiffuse);  (* add lighting (diffuse). *)
  glLight (GL_LIGHT 1) (Light.GL_POSITION lightPosition); (* set light position. *)
  glEnable GL_LIGHT1;                                     (* turn light 1 on. *)

  (texture)
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
let drawGLScene ~texture () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];  (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                           (* Reset The View *)

  glTranslate 0.0 0.0 !z;                     (* move z units out from the screen. *)
  
  glRotate !xrot 1.0 0.0 0.0;                 (* Rotate On The X Axis *)
  glRotate !yrot 0.0 1.0 0.0;                 (* Rotate On The Y Axis *)

  glBindTexture BindTex.GL_TEXTURE_2D texture.(!filter);   (* choose the texture to use. *)

  glBegin GL_QUADS;                           (* begin drawing a cube *)

  (* Front Face (note that the texture's corners have to match the quad's corners) *)
  glNormal3 (0.0) (0.0) (1.0);                          (* front face points out of the screen on z. *)
  glTexCoord2 0.0 0.0; glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Top Left Of The Texture and Quad *)

  (* Back Face *)
  glNormal3 (0.0) (0.0) (-1.0);                         (* back face points into the screen on z. *)
  glTexCoord2 1.0 0.0; glVertex3 (-1.0) (-1.0) (-1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 ( 1.0) (-1.0) (-1.0);  (* Bottom Left Of The Texture and Quad *)

  (* Top Face *)
  glNormal3 (0.0) (1.0) (0.0);                          (* top face points up on y. *)
  glTexCoord2 0.0 1.0; glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)

  (* Bottom Face *)
  glNormal3 (0.0) (-1.0) (0.0);                         (* bottom face points down on y.  *)
  glTexCoord2 1.0 1.0; glVertex3 (-1.0) (-1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 ( 1.0) (-1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)

  (* Right face *)
  glNormal3 ( 1.0) (0.0) (0.0);                         (* right face points right on x. *)
  glTexCoord2 1.0 0.0; glVertex3 ( 1.0) (-1.0) (-1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0; glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)

  (* Left Face *)
  glNormal3 (-1.0) (0.0) (0.0);                         (* left face points left on x. *)
  glTexCoord2 0.0 0.0; glVertex3 (-1.0) (-1.0) (-1.0);  (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0; glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0; glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0; glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)

  glEnd();                                    (* done with the polygon. *)

  xrot += !xspeed;                            (* X Axis Rotation *)
  yrot += !yspeed;                            (* Y Axis Rotation *)

  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glutSwapBuffers();
;;


(* The function called whenever a normal key is pressed. *)
let keyPressed ~window ~key ~x ~y =
  match key with
  | '\027' ->  (* escape, kill everything. *)
      (* shut down our window *)
      glutDestroyWindow window;

      (* exit the program...normal termination. *)
      exit 1;

  | 'L' | 'l' -> (* switch the lighting. *)
      Printf.printf "L/l pressed; light is: %b\n" !light;
      light := not(!light);               (* switch the current value of light, between 0 and 1. *)
      Printf.printf "Light is now: %b\n%!" !light;
      if not(!light)
      then glDisable GL_LIGHTING
      else glEnable GL_LIGHTING;

  | 'F' | 'f' -> (* switch the filter. *)
      Printf.printf "F/f pressed; filter is: %d\n" !filter;
      filter := !filter + 1;
      if !filter > 2 then
        filter := 0;
      Printf.printf "Filter is now: %d\n%!" !filter;

  | _ ->
      Printf.printf "Key %c pressed. No action there yet.\n%!" key;
;;


(* The function called whenever a special key is pressed. *)
let specialKeyPressed ~key ~x ~y =
  match key with
  | GLUT_KEY_PAGE_UP -> (* move the cube into the distance. *)
      z -= 0.02;

  | GLUT_KEY_PAGE_DOWN -> (* move the cube closer. *)
      z += 0.02;

  | GLUT_KEY_UP -> (* decrease x rotation speed; *)
      xspeed -= 0.01;

  | GLUT_KEY_DOWN -> (* increase x rotation speed; *)
      xspeed += 0.01;

  | GLUT_KEY_LEFT -> (* decrease y rotation speed; *)
      yspeed -= 0.01;

  | GLUT_KEY_RIGHT -> (* increase y rotation speed; *)
      yspeed += 0.01;

  | _ -> ()
;;


(* main *)
let () =
  (* Initialize GLUT state - glut will take any command line arguments that pertain to it or X Windows 
     look at its documentation at http://www.opengl.org/resources/libraries/glut/spec3/node10.html *)
  ignore(glutInit Sys.argv);

  (* Select type of Display mode:
   Double buffer
   RGBA color
   Depth buffer
   Alpha blending *)
  glutInitDisplayMode [GLUT_RGBA; GLUT_DOUBLE; GLUT_DEPTH; GLUT_ALPHA];

  (* get a 640 x 480 window *)
  glutInitWindowSize 640 480;

  (* the window starts at the upper left corner of the screen *)
  glutInitWindowPosition 0 0;

  (* Open a window *)
  let window = glutCreateWindow "Jeff Molofee's GL Code Tutorial ... NeHe '99" in

  (* Initialize OpenGL. *)
  let texture = initGL 640 480 in

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc (drawGLScene ~texture);

  (* Go fullscreen.  This is as soon as possible. *)
  glutFullScreen();

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc (drawGLScene ~texture);

  (* Register the function called when our window is resized. *)
  glutReshapeFunc reSizeGLScene;

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc (keyPressed ~window);

  (* Register the function called when special keys (arrows, page down, etc) are pressed. *)
  glutSpecialFunc specialKeyPressed;

  (* Start Event Processing Engine *)
  glutMainLoop();
;;

