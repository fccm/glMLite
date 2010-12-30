(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=12

 (Ported from C to OCaml by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)


let xrot = ref 0.0       (* rotates cube on the x axis. *)
let yrot = ref 0.0       (* rotates cube on the y axis. *)


(* colors for boxes. *)
let boxcol = [|
  (1.0,0.0,0.0); (1.0,0.5,0.0); (1.0,1.0,0.0); (0.0,1.0,0.0); (0.0,1.0,1.0)
|]

(* colors for tops of boxes. *)
let topcol = [|
  (0.5,0.0,0.0); (0.5,0.25,0.0); (0.5,0.5,0.0); (0.0,0.5,0.0); (0.0,0.5,0.5)
|]

let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;


(* build the display list. *)
let buildList() =
  let cube = glGenLists 2 in          (* generate storage for 2 lists, and return a pointer to the first. *)
  glNewList cube GL_COMPILE;          (* store this list at location cube, and compile it once. *)

  (* cube without the top; *)
  glBegin GL_QUADS;

  (* Bottom Face *)
  glTexCoord2 1.0 1.0;  glVertex3(-1.0) (-1.0) (-1.0);    (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0;  glVertex3( 1.0) (-1.0) (-1.0);    (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0;  glVertex3( 1.0) (-1.0) ( 1.0);    (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0;  glVertex3(-1.0) (-1.0) ( 1.0);    (* Bottom Right Of The Texture and Quad *)
  
  (* Front Face *)
  glTexCoord2 0.0 0.0;  glVertex3(-1.0) (-1.0) ( 1.0);    (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0;  glVertex3( 1.0) (-1.0) ( 1.0);    (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0;  glVertex3( 1.0) ( 1.0) ( 1.0);    (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0;  glVertex3(-1.0) ( 1.0) ( 1.0);    (* Top Left Of The Texture and Quad *)
  
  (* Back Face *)
  glTexCoord2 1.0 0.0;  glVertex3(-1.0) (-1.0) (-1.0);    (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0;  glVertex3(-1.0) ( 1.0) (-1.0);    (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0;  glVertex3( 1.0) ( 1.0) (-1.0);    (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0;  glVertex3( 1.0) (-1.0) (-1.0);    (* Bottom Left Of The Texture and Quad *)
  
  (* Right face *)
  glTexCoord2 1.0 0.0;  glVertex3( 1.0) (-1.0) (-1.0);    (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0;  glVertex3( 1.0) ( 1.0) (-1.0);    (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0;  glVertex3( 1.0) ( 1.0) ( 1.0);    (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0;  glVertex3( 1.0) (-1.0) ( 1.0);    (* Bottom Left Of The Texture and Quad *)
  
  (* Left Face *)
  glTexCoord2 0.0 0.0;  glVertex3(-1.0) (-1.0) (-1.0);    (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0;  glVertex3(-1.0) (-1.0) ( 1.0);    (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0;  glVertex3(-1.0) ( 1.0) ( 1.0);    (* Top Right Of The Texture and Quad *)
  glTexCoord2 0.0 1.0;  glVertex3(-1.0) ( 1.0) (-1.0);    (* Top Left Of The Texture and Quad *)
  
  glEnd();
  glEndList();

  let top = cube + 1 in               (* since we generated 2 lists, this is where the second is...1 GLuint up from cube. *)
  glNewList top GL_COMPILE;           (* generate 2nd list (top of box). *)

  glBegin GL_QUADS;
  (* Top Face *)
  glTexCoord2 0.0 1.0;  glVertex3(-1.0) ( 1.0) (-1.0);    (* Top Left Of The Texture and Quad *)
  glTexCoord2 0.0 0.0;  glVertex3(-1.0) ( 1.0) ( 1.0);    (* Bottom Left Of The Texture and Quad *)
  glTexCoord2 1.0 0.0;  glVertex3( 1.0) ( 1.0) ( 1.0);    (* Bottom Right Of The Texture and Quad *)
  glTexCoord2 1.0 1.0;  glVertex3( 1.0) ( 1.0) (-1.0);    (* Top Right Of The Texture and Quad *)
  glEnd();

  glEndList();

  (cube, top)
;;


(* Load Bitmaps And Convert To Textures *)
let loadGLTextures() =
  (* Load Texture *)
  let image_data, sizeX, sizeY, tex_internal_fmt, pixel_data_fmt =
    Png_loader.load_img (Filename "Data/lesson12/cube.png")
  in

  (* Create Texture *)
  let texture =  glGenTexture() in
  glBindTexture BindTex.GL_TEXTURE_2D texture;   (* 2d texture (x and y size) *)

  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR); (* scale linearly when image bigger than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR_MIPMAP_NEAREST); (* scale linearly (use mipmaps) when image smaller than texture *)

  (* 2d texture, 3 components (red, green, blue), x size from image, y size from image, 
     rgb color data, unsigned byte data, and finally the data itself. *)
  gluBuild2DMipmaps InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (texture)
;;


(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                   (* We call this right after our OpenGL window is created. *)
  let texture = loadGLTextures() in           (* Load The Texture(s) *)
  let cube, top = buildList() in              (* set up our display lists. *)
  glEnable GL_TEXTURE_2D;                     (* Enable Texture Mapping *)

  glClearColor 0.1 0.2 0.9 0.0;               (* Clear The Background Color To Blue  *)
  glClearDepth 1.0;                           (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                        (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;                     (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;                     (* Enables Smooth Color Shading *)
  
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                           (* Reset The Projection Matrix *)
  
  gluPerspective 45.0  (float width /. float height) 0.1 100.0;    (* Calculate The Aspect Ratio Of The Window *)
  
  glMatrixMode GL_MODELVIEW;

  glEnable GL_LIGHT0;
  glEnable GL_LIGHTING;
  glEnable GL_COLOR_MATERIAL;

  (texture, cube, top)
;;


(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reshape ~width ~height =
  let height =
    if height = 0                             (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in

  glViewport 0 0 width height;                (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0  (float width /. float height) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The main drawing function. *)
let display ~texture ~cube ~top () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];         (* Clear The Screen And The Depth Buffer *)

  glBindTexture BindTex.GL_TEXTURE_2D texture;

  for yloop = 1 to 5 do  (* 5 rows of cubes. *)
    for xloop = 0 to pred yloop do
      glLoadIdentity();

      glTranslate (1.4 +. ((float xloop) *. 2.8) -. ((float yloop) *. 1.4))
                  (((6.0 -. (float yloop)) *. 2.4) -. 7.0)
                  (-20.0);

      glRotate (45.0 -. (2.0 *. float yloop) +. !xrot) 1.0 0.0 0.0;
      glRotate (45.0 +. !yrot) 0.0 1.0 0.0;

      glColor3v boxcol.(yloop-1);
      glCallList cube;
      
      glColor3v topcol.(yloop-1);
      glCallList top;
    done;
  done;

  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glutSwapBuffers();
;;


(* The function called whenever a key is pressed. *)
let keypressed ~window ~key ~x ~y =
  (* If escape is pressed, kill everything. *)
  if key = '\027' then
  begin
    (* shut down our window *)
    glutDestroyWindow window;

    (* exit the program...normal termination. *)
    exit(0);
  end;
;;


(* The function called whenever a normal key is pressed. *)
let special ~key ~x ~y =
  match key with
  | GLUT_KEY_UP ->    xrot -= 0.4;
  | GLUT_KEY_DOWN ->  xrot += 0.4;
  | GLUT_KEY_LEFT ->  yrot += 0.4;
  | GLUT_KEY_RIGHT -> yrot -= 0.4;
  | _ ->
      Printf.printf "Special key %d pressed. No action there yet.\n%!" (Obj.magic key : int);
;;


(* main *) 
let () =
  (* Initialize GLUT state - glut will take any command line arguments that pertain to it or X Windows 
     look at its documentation at http://www.opengl.org/resources/libraries/glut/spec3/node10.html *)
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

  (* Initialize our window. *)
  let texture, cube, top = initGL 640 480 in

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc ~display:(display ~texture ~cube ~top);

  (* Go fullscreen.  This is as soon as possible. *)
  glutFullScreen();

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc ~idle:(display ~texture ~cube ~top);

  (* Register the function called when our window is resized. *)
  glutReshapeFunc ~reshape;

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc ~keyboard:(keypressed ~window);

  (* Register the function called when special keys (arrows, page down, etc) are pressed. *)
  glutSpecialFunc ~special;

  (* Start Event Processing Engine *)  
  glutMainLoop();  
;;

