(*
 This code was created by Jeff Molofee '99
 If you've found this code useful, please let me know.

 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=13

 (Ported from C to OCaml by Florent Monnier)
*)
open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLU Library *)
open Glut     (* Module For The GLUT Library *)
open Xlib     (* Module For The Xlib Library *)
open GLX      (* Module For The GLX Library *)

let cnt1 = ref 0.0       (* 1st counter used to move text & for coloring. *)
let cnt2 = ref 0.0       (* 2nd counter used to move text & for coloring. *)

let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;

let string_explode s =
  Array.init (String.length s) (fun i -> String.unsafe_get s i)
;;


let buildFont() =
  (* base display list for the font set. *)
  let base = glGenLists 96 in                   (* storage for 96 characters. *)

  (* load the font.  what fonts any of you have is going
     to be system dependent, but on my system they are
     in /usr/X11R6/lib/X11/fonts/*, with fonts.alias and
     fonts.dir explaining what fonts the .pcf.gz files
     are.  in any case, one of these 2 fonts should be
     on your system...or you won't see any text.

     get the current display.  This opens a second
     connection to the display in the DISPLAY environment
     value, and will be around only long enough to load 
     the font. *)
  let dpy = xOpenDisplay "" in  (* default to DISPLAY env. *)

  let fontInfo =
    try xLoadQueryFont dpy "-adobe-helvetica-medium-r-normal--34-*-*-*-p-*-iso8859-1"
    with _ ->
      try xLoadQueryFont dpy "fixed"
      with _ ->
        Printf.eprintf "no X font available?\n%!";
        exit(1)
  in

  (* after loading this font info, this would probably be the time
     to rotate, scale, or otherwise twink your fonts. *)

  (* start at character 32 (space), get 96 characters (a few characters past z),
     and store them starting at base. *)
  glXUseXFont (xFontStruct_font fontInfo) 32 96 base;

  (* free that font's info now that we've got the display lists. *)
  (*
  xFreeFont dpy fontInfo;
  *)

  (* close down the 2nd display connection. *)
  xCloseDisplay dpy;

  (base)
;;


let killFont ~base =                            (* delete the font. *)
  glDeleteLists base 96;                        (* delete all 96 characters. *)
;;


let glPrint ~base ~text =                       (* custom gl print routine. *)
  if text <> "" then                            (* if there's no text, do nothing. *)
  begin
    glPushAttrib [Attrib.GL_LIST_BIT];          (* alert that we're about to offset the display lists with glListBase *)
    glListBase(base - 32);                      (* sets the base character to 32. *)

    let lists = Array.map int_of_char (string_explode text) in
    glCallLists lists;                          (* draws the display list text. *)
    glPopAttrib();                              (* undoes the glPushAttrib(GL_LIST_BIT); *)
  end;
;;


(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                     (* We call this right after our OpenGL window is created. *)
  glClearColor 0.0 0.0 0.0 0.0;                 (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                             (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                          (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;                       (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;                       (* Enables Smooth Color Shading *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                             (* Reset The Projection Matrix *)

  gluPerspective 45.0 (float width /. float height) 0.1 100.0;   (* Calculate The Aspect Ratio Of The Window *)

  glMatrixMode GL_MODELVIEW;

  let base = buildFont() in
  (base)
;;


(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reshape ~width ~height =
  let height =
    if height = 0                               (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in

  glViewport 0 0 width height;                  (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0  (float width /. float height) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The main drawing function. *)
let display ~base () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];       (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                             (* Reset The View *)
  glTranslate 0.0 0.0 (-1.0);                   (* move 1 unit into the screen. *)

  (* Pulsing Colors Based On Text Position *)
  glColor3 (1.0 *. (cos !cnt1))
           (1.0 *. (sin !cnt2))
           (1.0 -. 0.5 *. (cos(!cnt1 +. !cnt2)));

  (* Position The Text On The Screen *)
  glRasterPos2 (-. 0.2 +. 0.35 *. (cos !cnt1))
               (0.35 *. (sin !cnt2));

  glPrint ~base ~text:"OpenGL With NeHe";       (* print gl text to the screen. *)

  (*
  cnt1 += 0.01;
  cnt2 += 0.0081;
  *)
  cnt1 += 0.006;
  cnt2 += 0.00486;

  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glutSwapBuffers();
;;


(* The function called whenever a key is pressed. *)
let keyboard ~window ~base ~key ~x ~y =
  (* If escape is pressed, kill everything. *)
  if key = '\027' then
  begin
    (* get rid of font display lists *)
    killFont ~base;

    (* shut down our window *)
    glutDestroyWindow window; 

    (* exit the program...normal termination. *)
    exit(0);
  end;
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
  let base = initGL 640 480 in

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc ~display:(display ~base);

  (* Go fullscreen.  This is as soon as possible. *)
  glutFullScreen();

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc ~idle:(display ~base);

  (* Register the function called when our window is resized. *)
  glutReshapeFunc ~reshape;

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc ~keyboard:(keyboard ~window ~base);

  (* Start Event Processing Engine *)
  glutMainLoop();
;;

