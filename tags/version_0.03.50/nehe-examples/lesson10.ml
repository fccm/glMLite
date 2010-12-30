(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=10

 (OCaml version by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)


let light = ref false    (* lighting on/off *)
let blend = ref false    (* blending on/off *)

let yrot = ref 0.0       (* y rotation *)

let walkbias = ref 0.0
let walkbiasangle = ref 0.0

let lookupdown = ref 0.0
let piover180 = 0.0174532925

let xpos = ref 0.0
let zpos = ref 0.0

let z = ref 0.0          (* depth into the screen. *)

let lightAmbient  = (0.5, 0.5, 0.5, 1.0)
let lightDiffuse  = (1.0, 1.0, 1.0, 1.0)
let lightPosition = (0.0, 0.0, 2.0, 1.0)

let filter = ref 0       (* texture filtering method to use (nearest, linear, linear + mipmaps) *)


(* Structures: *)

type vertex =            (* vertex coordinates - 3d and texture *)
  { x:float;             (* 3d coords. *)
    y:float;
    z:float;
    u:float; v:float;    (* texture coords. *)
  }

type triangle = vertex * vertex * vertex    (* 3 vertices *)

type sector =            (* sector of a 3d environment *)
  { numtriangles:int;    (* number of triangles in the sector *)
    triangles: triangle array;  (* pointer to array of triangles. *)
  }


let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;


(* removes white chars from the beginning and the end of a string *)
let strip str =
  let len = String.length str in
  let rec aux i =
    if i >= len then i else
    match str.[i] with
    | ' ' | '\t' -> aux (succ i)
    | _ -> i
  in
  let left = aux 0 in
  let rec aux i =
    if i <= left then i else
    match str.[i] with
    | ' ' | '\t' -> aux (pred i)
    | _ -> i
  in
  let right = aux (pred len) in
  (String.sub str left (right - left + 1))
;;

(* helper for setupWorld.  reads a file into a string until a nonblank, non-comment line
   is found ("/" at the start indicating a comment); *)
let readstr ~ic =
  let rec aux() =
    let line = input_line ic in
    if line = "" then aux()
    else if line.[0] = '/' then aux()
    else (strip line)
  in
  aux()
;;


(* loads the world from a text file. *)
let setupWorld() =
  let ic = open_in "Data/lesson10/world.txt" in

  let line = readstr ~ic in
  let numtriangles = Scanf.sscanf line "NUMPOLLIES %d" (fun d -> d) in

  let triangles =
    Array.init numtriangles (fun i ->
      let input_vert() =
        let line = readstr ~ic in
        let x, y, z, u, v =
          Scanf.sscanf line "%f %f %f %f %f" (fun a b c d e -> a,b,c,d,e)
        in
        { x=x; y=y; z=z; u=u; v=v }
      in
      let vert1 = input_vert() in
      let vert2 = input_vert() in
      let vert3 = input_vert() in
      (vert1, vert2, vert3)
    )
  in

  close_in ic;

  let sector1 =
    { numtriangles = numtriangles;
      triangles = triangles; }
  in
  (sector1)
;;
    

open TexParam
(* Load Bitmaps And Convert To Textures *)
let loadGLTextures() =
  (* Load Texture *)
  let image_data, sizeX, sizeY, tex_internal_fmt, pixel_data_fmt =
    Png_loader.load_img (Filename "Data/lesson10/mud.png")
  in

  (* Create Textures *)
  let texture = glGenTextures 3 in  (* storage for 3 textures *)

  (* nearest filtered texture *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(0);   (* 2d texture (x and y size) *)
  glTexParameter GL_TEXTURE_2D (GL_TEXTURE_MAG_FILTER Mag.GL_NEAREST); (* scale cheaply when image bigger than texture *)
  glTexParameter GL_TEXTURE_2D (GL_TEXTURE_MIN_FILTER Min.GL_NEAREST); (* scale cheaply when image smalled than texture *)
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (* linear filtered texture *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(1);   (* 2d texture (x and y size) *)
  glTexParameter GL_TEXTURE_2D (GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR); (* scale linearly when image bigger than texture *)
  glTexParameter GL_TEXTURE_2D (GL_TEXTURE_MIN_FILTER Min.GL_LINEAR); (* scale linearly when image smaller than texture *)
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (* mipmapped texture *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(2);   (* 2d texture (x and y size) *)
  glTexParameter GL_TEXTURE_2D (GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR); (* scale linearly when image bigger than texture *)
  glTexParameter GL_TEXTURE_2D (GL_TEXTURE_MIN_FILTER Min.GL_LINEAR_MIPMAP_NEAREST); (* scale mipmap when image smaller than texture *)
  gluBuild2DMipmaps InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (texture)
;;


(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                  (* We call this right after our OpenGL window is created. *)
  let texture = loadGLTextures() in          (* load the textures. *)

  glEnable GL.GL_TEXTURE_2D;                 (* Enable texture mapping. *)

  glBlendFunc Sfactor.GL_SRC_ALPHA Dfactor.GL_ONE;  (* Set the blending function for translucency (note off at init time) *)
  glClearColor 0.0 0.0 0.0 0.0;              (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                          (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                       (* type of depth test to do. *)
  glEnable GL_DEPTH_TEST;                    (* enables depth testing. *)
  glShadeModel GL_SMOOTH;                    (* Enables Smooth Color Shading *)
  
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                          (* Reset The Projection Matrix *)
  
  gluPerspective 45.0 ((float width) /. (float height)) 0.1 100.0;  (* Calculate The Aspect Ratio Of The Window *)
  
  glMatrixMode GL_MODELVIEW;

  (* set up lights. *)
  glLight (GL_LIGHT 1) (Light.GL_AMBIENT lightAmbient);
  glLight (GL_LIGHT 1) (Light.GL_DIFFUSE lightDiffuse);
  glLight (GL_LIGHT 1) (Light.GL_POSITION lightPosition);
  glEnable GL_LIGHT1;

  (texture)
;;


(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reshape ~width ~height =
  let height =
    if height = 0                            (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in

  glViewport 0 0 width height;               (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0 ((float width) /. (float height)) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The main drawing function. *)
let display ~sector1 ~texture () =
  (* calculate translations and rotations. *)
  let xtrans = -. !xpos
  and ztrans = -. !zpos
  and ytrans = -. !walkbias -. 0.25
  and sceneroty = 360.0 -. !yrot in
      
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];      (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();

  glRotate !lookupdown 1.0 0.0 0.0;
  glRotate sceneroty 0.0 1.0 0.0;

  glTranslate xtrans ytrans ztrans;

  glBindTexture BindTex.GL_TEXTURE_2D texture.(!filter);    (* pick the texture. *)

  Array.iter (fun (vert1, vert2, vert3) ->    (* iter over all the triangles *)
    glBegin GL_TRIANGLES;
    glNormal3 0.0 0.0 1.0;

    glTexCoord2 vert1.u vert1.v;
    glVertex3 vert1.x vert1.y vert1.z;

    glTexCoord2 vert2.u vert2.v;
    glVertex3 vert2.x vert2.y vert2.z;

    glTexCoord2 vert3.u vert3.v;
    glVertex3 vert3.x vert3.y vert3.z;

    glEnd();
  ) sector1.triangles;

  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glutSwapBuffers();
;;


(* The function called whenever a normal key is pressed. *)
let keyboard ~key ~x ~y =
  match key with
  | 'q' | 'Q'
  | '\027' ->  (* Escape: kill everything. *)
      (* exit the program...normal termination. *)
      exit(1);

  | 'b' | 'B' ->  (* switch the blending *)
      Printf.printf "B/b pressed; blending is: %b\n%!" !blend;
      blend := not(!blend);                 (* switch the current value of blend, between 0 and 1. *)
        if !blend then begin
          glEnable GL_BLEND;
          glDisable GL_DEPTH_TEST;
        end else begin
          glDisable GL_BLEND;
          glEnable GL_DEPTH_TEST;
        end;
        Printf.printf "Blending is now: %b\n%!" !blend;

  | 'f' | 'F' ->  (* switch the filter *)
      Printf.printf "F/f pressed; filter is: %d\n%!" !filter;
      incr filter;                          (* switch the current value of filter, between 0/1/2; *)
      if !filter > 2 then
        filter := 0;
      Printf.printf "Filter is now: %d\n%!" !filter;

  | 'l' | 'L' ->  (* switch the lighting *)
      Printf.printf "L/l pressed; lighting is: %b\n%!" !light;
      light := not(!light);                 (* switch the current value of light, between 0 and 1. *)
      if !light
      then glEnable GL_LIGHTING
      else glDisable GL_LIGHTING;
      Printf.printf "Lighting is now: %b\n%!" !light;

  | _ ->
      Printf.printf "Key '%c' pressed. No action there yet.\n%!" key;
;;


(* The function called whenever a normal key is pressed. *)
let special ~key ~x ~y =
  match key with
  | GLUT_KEY_PAGE_UP ->  (* tilt up *)
      z -= 0.2;
      lookupdown -= 0.2;

  | GLUT_KEY_PAGE_DOWN ->  (* tilt down *)
      z += 0.2;
      lookupdown += 1.0;

  | GLUT_KEY_UP ->  (* walk forward (bob head) *)
      xpos -= sin(!yrot *. piover180) *. 0.05;
      zpos -= cos(!yrot *. piover180) *. 0.05;     
      if !walkbiasangle >= 359.0
      then walkbiasangle := 0.0
      else walkbiasangle += 10.0;
      walkbias := sin(!walkbiasangle *. piover180) /. 20.0;

  | GLUT_KEY_DOWN ->  (* walk back (bob head) *)
      xpos += sin(!yrot *. piover180) *. 0.05;
      zpos += cos(!yrot *. piover180) *. 0.05;     
      if !walkbiasangle <= 1.0
      then walkbiasangle := 359.0
      else walkbiasangle -= 10.0;
      walkbias := sin(!walkbiasangle *. piover180) /. 20.0;

  | GLUT_KEY_LEFT ->  (* look left *)
      yrot += 1.5;
    
  | GLUT_KEY_RIGHT ->  (* look right *)
      yrot -= 1.5;

  | _ ->
      Printf.printf "Special key %d pressed. No action there yet.\n" (Obj.magic key : int);
;;


let () =
  (* load our world from disk *)
  let sector1 = setupWorld() in

  (* Initialize GLUT state - glut will take any command line arguments that
     pertain to it or X Windows - look at its documentation at:
     http://www.opengl.org/resources/libraries/glut/spec3/node10.html *)
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
  let _ = glutCreateWindow "Jeff Molofee's GL Code Tutorial ... NeHe '99" in

  (* Initialize our window. *)
  let texture = initGL 640 480 in

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc ~display:(display ~sector1 ~texture);

  (* Go fullscreen.  This is as soon as possible. *)
  glutFullScreen();

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc ~idle:(display ~sector1 ~texture);

  (* Register the function called when our window is resized. *)
  glutReshapeFunc ~reshape;

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc ~keyboard;

  (* Register the function called when special keys (arrows, page down, etc) are pressed. *)
  glutSpecialFunc ~special;

  (* Start Event Processing Engine *)  
  glutMainLoop();  
;;

