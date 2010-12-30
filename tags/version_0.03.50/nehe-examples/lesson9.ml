(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=09

 (OCaml version by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)

(* number of stars to have *)
let star_num = 50

(* twinkle on/off (true = on, false = off) *)
let twinkle = ref false

type stars = {                  (* type stars *)
  r:float; g:float; b:float;    (* stars' color *)
  mutable dist:float;           (* stars' distance from center *)
  mutable angle:float;          (* stars' current angle *)
}

let () = Random.self_init() ;;  (* Initialise the random generator *)

(* make 'star' array of star_num size using info from the structure 'stars' *)
let star = Array.init star_num (fun loop ->
    { (* set up the stars *)

      r = Random.float 1.0;     (* random red intensity; *)
      g = Random.float 1.0;     (* random green intensity; *)
      b = Random.float 1.0;     (* random blue intensity; *)

      angle = 0.0;              (* initially no rotation. *)
      
      dist = (float loop) *. 1.0 /. (float star_num) *. 5.0;  (* calculate distance form the center *)
    }
  )
;;

let zoom = ref (-15.0)          (* viewing distance from stars. *)
let tilt = ref 90.0             (* tilt the view *)
let spin = ref 0.0              (* spin twinkling stars *)


let ( += ) a b =
  a := !a +. b
;;

let ( -= ) a b =
  a := !a -. b
;;


(* Load Bitmaps And Convert To Textures *)
let loadGLTextures() =
  let image_data, width, height, tex_internal_fmt, pixel_data_fmt =
    Png_loader.load_img (Filename "Data/lesson9/Star.png")
  in

  (* Create Textures *)
  let texture = glGenTexture() in

  (* linear filtered texture *)
  glBindTexture BindTex.GL_TEXTURE_2D texture;   (* 2d texture (x and y size) *)

  (* scale linearly when image bigger than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR);
  (* scale linearly when image smalled than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR);

  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB width height GL_RGB GL_UNSIGNED_BYTE image_data;

  (texture)
;;


(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                (* We call this right after our OpenGL window is created. *)

  glEnable GL_TEXTURE_2D;                (* Enable texture mapping. *)

  glClearColor 0.0 0.0 0.0 0.0;          (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                      (* Enables Clearing Of The Depth Buffer *)

  glShadeModel GL_SMOOTH;                (* Enables Smooth Color Shading *)
  
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                      (* Reset The Projection Matrix *)
  
  gluPerspective 45.0 ((float width)/.(float height)) 0.1 100.0;  (* Calculate The Aspect Ratio Of The Window *)
  
  glMatrixMode GL_MODELVIEW;

  (* setup blending *)
  glBlendFunc Sfactor.GL_SRC_ALPHA Dfactor.GL_ONE;       (* Set The Blending Function For Translucency *)
  glEnable GL_BLEND;                     (* Enable Blending *)
;;

(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reSizeGLScene ~width ~height =
  let height =
    if height = 0                          (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in

  glViewport 0 0 width height;             (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0 ((float width)/.(float height)) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The main drawing function. *)
let drawGLScene texture () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];   (* Clear The Screen And The Depth Buffer *)
  
  glBindTexture BindTex.GL_TEXTURE_2D texture;   (* pick the texture. *)

  for loop=0 to pred star_num do               (* loop through all the stars. *)
      glLoadIdentity();                        (* reset the view before we draw each star. *)
      glTranslate 0.0 0.0 !zoom;               (* zoom into the screen. *)
      glRotate !tilt 1.0 0.0 0.0;              (* tilt the view. *)
      
      glRotate star.(loop).angle 0.0 1.0 0.0;  (* rotate to the current star's angle. *)
      glTranslate star.(loop).dist 0.0 0.0;    (* move forward on the X plane (the star's x plane). *)

      glRotate (-. star.(loop).angle) 0.0 1.0 0.0; (* cancel the current star's angle. *)
      glRotate (-. !tilt) 1.0 0.0 0.0;         (* cancel the screen tilt. *)

      if !twinkle then begin                   (* twinkling stars enabled ... draw an additional star. *)
        (* assign a color using bytes *)
        glColor3  star.(star_num - loop).r
                  star.(star_num - loop).g
                  star.(star_num - loop).b;

        glBegin GL_QUADS;                    (* begin drawing the textured quad. *)
        glTexCoord2 0.0 0.0; glVertex3 (-1.0) (-1.0) (0.0);
        glTexCoord2 1.0 0.0; glVertex3 ( 1.0) (-1.0) (0.0);
        glTexCoord2 1.0 1.0; glVertex3 ( 1.0) ( 1.0) (0.0);
        glTexCoord2 0.0 1.0; glVertex3 (-1.0) ( 1.0) (0.0);
        glEnd();                             (* done drawing the textured quad. *)
      end;

      (* main star *)
      glRotate !spin 0.0 0.0 1.0;       (* rotate the star on the z axis. *)

      (* Assign The Color Of The Current Star *)
      glColor3  star.(loop).r  star.(loop).g  star.(loop).b;
      glBegin GL_QUADS;                       (* Begin Drawing The Textured Quad *)
      glTexCoord2 0.0 0.0;  glVertex3 (-1.0) (-1.0) (0.0);
      glTexCoord2 1.0 0.0;  glVertex3 ( 1.0) (-1.0) (0.0);
      glTexCoord2 1.0 1.0;  glVertex3 ( 1.0) ( 1.0) (0.0);
      glTexCoord2 0.0 1.0;  glVertex3 (-1.0) ( 1.0) (0.0);
      glEnd();                                (* Done Drawing The Textured Quad *)

      spin += 0.01;                           (* used to spin the stars. *)
      star.(loop).angle <- star.(loop).angle +. (float loop) *. 1.0 /. (float star_num) *. 1.0;  (* change star angle. *)
      star.(loop).dist  <- star.(loop).dist  -. 0.01;              (* bring back to center. *)

      if star.(loop).dist < 0.0 then          (* star hit the center *)
        star.(loop) <- {
          angle = star.(loop).angle;
          dist = star.(loop).dist +. 5.0;     (* move 5 units from the center. *)

          r = Random.float 1.0;               (* new red color. *)
          g = Random.float 1.0;               (* new green color. *)
          b = Random.float 1.0;               (* new blue color. *)
        };
  done;
  
  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glutSwapBuffers();
;;


(* The function called whenever a normal key is pressed. *)
let keyPressed ~key ~x ~y =
  match key with
  | '\027' ->    (* kill everything. *)
      (* exit the program...normal termination. *)
      exit(1);

  | 't' | 'T' ->  (* switch the twinkling. *)
      Printf.printf "T/t pressed; twinkle is: %b\n" !twinkle;
      twinkle := not !twinkle;          (* switch the current value of twinkle, between 0 and 1. *)
      Printf.printf "Twinkle is now: %b\n%!" !twinkle;

  | _ ->
      Printf.printf "Key %c pressed. No action there yet.\n%!" key;
;;


(* The function called whenever a normal key is pressed. *)
let specialKeyPressed ~key ~x ~y =
  match key with
  | GLUT_KEY_PAGE_UP ->    (* zoom out *)
      zoom -= 0.2;
    
  | GLUT_KEY_PAGE_DOWN ->  (* zoom in *)
      zoom += 0.2;

  | GLUT_KEY_UP ->         (* tilt up *)
      tilt -= 0.5;

  | GLUT_KEY_DOWN ->       (* tilt down *)
      tilt += 0.5;

  | _ ->
      Printf.printf "Special key %d pressed. No action there yet.\n%!" (Obj.magic key : int);
;;


let () =
  (* Initialize GLUT state - glut will take any command line arguments that
     pertain to it or X Windows - look at its documentation at:
     http://www.opengl.org/resources/libraries/glut/spec3/node10.html *)
  ignore(glutInit Sys.argv);  

  (* Select type of Display mode:   
   Double buffer 
   RGBA color
   Depth buffer *)
  glutInitDisplayMode [GLUT_RGBA; GLUT_DOUBLE; GLUT_DEPTH];

  (* get a 640 x 480 window *)
  glutInitWindowSize 640 480;

  (* the window starts at the upper left corner of the screen *)
  glutInitWindowPosition 0 0;

  (* Open a window *)  
  let window = glutCreateWindow "Jeff Molofee's GL Code Tutorial ... NeHe '99" in
  ignore(window);

  (* Initialize our window. *)
  initGL 640 480;
  let texture = loadGLTextures() in       (* load the textures. *)

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc (drawGLScene texture);

  (* Go fullscreen.  This is as soon as possible. *)
  glutFullScreen();

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc (drawGLScene texture);

  (* Register the function called when our window is resized. *)
  glutReshapeFunc reSizeGLScene;

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc keyPressed;

  (* Register the function called when special keys (arrows, page down, etc) are pressed. *)
  glutSpecialFunc specialKeyPressed;
  
  (* Start Event Processing Engine *)
  glutMainLoop();
;;

