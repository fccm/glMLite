(*
   This code was created by Jeff Molofee '99 (ported to Linux/GLUT by Richard Campbell '99)
  
   If you've found this code useful, please let me know.

   The full tutorial associated with this file is available here:
   http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=16
  
   Visit me at www.demonews.com/hosted/nehe
   (email Richard Campbell at ulmont@bellsouth.net)
  
   It was modified heavily by Daniel Davis to get rid of Glut (Blah!) and the Tab characters (double Blah!)
   Daniel (planetes@mediaone.net)
   I should note that this was completed on a custom Linux (see www.linuxfromscratch.org)
   using XFree86 4.0.1 with DRI cvs code and a 3dfx Voodoo3 card.
*)
(* Ported from C to OCaml by Florent Monnier *)

open GL                 (* Module For The OpenGL Library *)
open Glu                (* Module For The GLu Library *)
open Xlib               (* Standard X module for Xlib library *)
open Keysym_match       (* Module to provide keyboard functionality under X *)
open GLX                (* Module For The X library for OpenGL *)

(* Global variables *)

let fXRotation = ref 0.0
let fYRotation = ref 0.0
let fXSpeed = ref 0.0
let fYSpeed = ref 0.0
let z = ref(-5.0)

let lightAmbient =  (0.5, 0.5, 0.5, 1.0)
let lightDiffuse =  (1.0, 1.0, 1.0, 1.0)
let lightPosition = (0.0, 0.0, 2.0, 1.0)
let filter = ref 0                             (* Which Filter To Use *)
let light = ref false                          (* Light switch *)
let fogMode= [| GL_EXP; GL_EXP2; GL_LINEAR |]  (* Storage For Three Types Of Fog *)
let fogfilter = ref 0                          (* Which Fog Mode To Use *)
let fogColor = (0.5, 0.5, 0.5, 1.0)            (* Fog Color *)

let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;


(* Load Bitmaps And Convert To Textures *)
let loadGLTextures() =
  (* Load Texture *)
  let image_data, dimensionX, dimensionY, tex_internal_fmt, pixel_data_fmt =
    Png_loader.load_img (Filename "Data/lesson16/crate.png")
  in

  let iTexture = glGenTextures 3 in            (* Create Three Textures *)

  (* Create Nearest Filtered Texture *)
  glBindTexture BindTex.GL_TEXTURE_2D iTexture.(0);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_NEAREST);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_NEAREST);
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB dimensionX dimensionY GL_RGB GL_UNSIGNED_BYTE image_data;

  (* Create Linear Filtered Texture *)
  glBindTexture BindTex.GL_TEXTURE_2D iTexture.(1);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR);
  glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB dimensionX dimensionY GL_RGB GL_UNSIGNED_BYTE image_data;

  (* Create MipMapped Texture *)
  glBindTexture BindTex.GL_TEXTURE_2D iTexture.(2);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR);
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR_MIPMAP_NEAREST);
  gluBuild2DMipmaps InternalFormat.GL_RGB dimensionX dimensionY GL_RGB GL_UNSIGNED_BYTE image_data;

  (iTexture)
;;


(* Function to construct and initialize X-windows Window *)
let xInitWindow ~argv =
  (* Open the Display *)
  let dpDisplay = xOpenDisplay "" in

  (* Check for GLX extension to X-Windows *)
  glXQueryExtension dpDisplay;

  (* Buffer parameters for Double Buffering *)
  let dblBuf = [ Visual. GLX_RGBA;
                 Visual. GLX_RED_SIZE  1;
                 Visual. GLX_GREEN_SIZE  1;
                 Visual. GLX_BLUE_SIZE  1;
                 Visual. GLX_DEPTH_SIZE  12;
                 Visual. GLX_DOUBLEBUFFER; ] in

  (* Grab a doublebuffering RGBA visual as defined in dblBuf *)
  let xvVisualInfo = glXChooseVisual dpDisplay (xDefaultScreen dpDisplay) dblBuf in

  (* Create a window context *)
  let glXContext = glXCreateContext dpDisplay xvVisualInfo None true in

  let viscont = xVisualInfo_datas xvVisualInfo in

  (* Create the color map for the new window *)
  let cmColorMap = xCreateColormap dpDisplay
                                   (xRootWindow dpDisplay viscont.screen_number)
                                   viscont.visual AllocNone in

  let winAttributes = new_win_attr() in
  winAttributes.set_colormap cmColorMap;
  winAttributes.set_border_pixel (xBlackPixel dpDisplay (xDefaultScreen dpDisplay));
  winAttributes.set_event_mask [ ExposureMask; ButtonPressMask; StructureNotifyMask;
                                 KeyPressMask ];

  (* Create the actual window object *)
  let win = xCreateWindow dpDisplay
                          (xRootWindow dpDisplay viscont.screen_number)
                          0 0
                          640 480                   (* Horizontal /  Veritical Size *)
                          0
                          viscont.depth
                          InputOutput
                          viscont.visual
                          [CWBorderPixel; CWColormap; CWEventMask]
                          winAttributes.attr in

  (* Set the standard properties for the window. *)
  xSetStandardProperties dpDisplay
                         win
                         "Daniel Davis's Fog Tutorial ... NeHe '99"
                         "lesson16"
                         None
                         Sys.argv
                         (new_xSizeHints());

  (* Establish new event *)
  let wmDeleteWindow = xInternAtom dpDisplay "WM_DELETE_WINDOW" false in
  xSetWMProtocols dpDisplay win wmDeleteWindow 1;

  (* Convert to a glx drawable *)
  let dwin = glXDrawable_of_window win in

  (* Bind the OpenGL context to the newly created window. *)
  glXMakeCurrent dpDisplay dwin glXContext;

  (* Make the new window the active window. *)
  xMapWindow dpDisplay win;

  (dpDisplay, dwin, wmDeleteWindow)
;;


(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =                      (* We call this right after our OpenGL window is created. *)
  let iTexture = loadGLTextures() in             (* Load Texture from file. *)

  glEnable GL_TEXTURE_2D;                        (* Enable 2D texture matrix *)
  glShadeModel GL_SMOOTH;                        (* Set shading to smooth *)

  glClearColor 0.5 0.5 0.5 1.0;                  (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                              (* Enables Clearing Of The Depth Buffer *)
  glEnable GL_DEPTH_TEST;                        (* Enables Depth Testing *)
  glDepthFunc GL_LEQUAL;                         (* Type of Depth Test to perform *)
  glHint GL_PERSPECTIVE_CORRECTION_HINT  GL_NICEST; (* Really nice perspective calculations *)

  glLight (GL_LIGHT 1) (Light.GL_AMBIENT  lightAmbient);  (* Setup The Ambient Light *)
  glLight (GL_LIGHT 1) (Light.GL_DIFFUSE  lightDiffuse);  (* Setup The Diffuse Light *)
  glLight (GL_LIGHT 1) (Light.GL_POSITION lightPosition); (* Position The Light *)
  glEnable GL_LIGHT1;                            (* Enable Light One *)

  glFog (GL_FOG_MODE fogMode.(!fogfilter));      (* Fog Mode *)
  glFog (GL_FOG_COLOR fogColor);                 (* Set Fog Color *)
  glFog (GL_FOG_DENSITY 0.35);                   (* How Dense Will The Fog Be *)
  glHint GL_FOG_HINT  GL_DONT_CARE;              (* Fog Hint Value *)
  glFog (GL_FOG_START 1.0);                      (* Fog Start Depth *)
  glFog (GL_FOG_END 5.0);                        (* Fog End Depth *)
  glEnable GL_FOG;                               (* Enables GL_FOG *)

  (iTexture)
;;


(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reSizeGLScene ~width ~height =
  let height =
    if height = 0                                (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in
  glViewport 0 0 width height;                   (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0 (float width /. float height) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The function to draw the screendrawing function. *)
let drawGLScene dpDisplay dwin iTexture =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT]; (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                              (* Reset The View *)
  glTranslate 0.0 0.0 !z;

  glRotate !fXRotation 1.0 0.0 0.0;
  glRotate !fYRotation 0.0 1.0 0.0;

  glBindTexture BindTex.GL_TEXTURE_2D iTexture.(!filter);

  glBegin GL_QUADS;
    (* Front Face *)
    glNormal3 0.0 0.0 1.0;
    glTexCoord2 0.0 0.0;  glVertex3 (-1.0) (-1.0) ( 1.0);
    glTexCoord2 1.0 0.0;  glVertex3 ( 1.0) (-1.0) ( 1.0);
    glTexCoord2 1.0 1.0;  glVertex3 ( 1.0) ( 1.0) ( 1.0);
    glTexCoord2 0.0 1.0;  glVertex3 (-1.0) ( 1.0) ( 1.0);
    (* Back Face *)
    glNormal3 0.0 0.0 (-1.0);
    glTexCoord2 1.0 0.0;  glVertex3 (-1.0) (-1.0) (-1.0);
    glTexCoord2 1.0 1.0;  glVertex3 (-1.0) ( 1.0) (-1.0);
    glTexCoord2 0.0 1.0;  glVertex3 ( 1.0) ( 1.0) (-1.0);
    glTexCoord2 0.0 0.0;  glVertex3 ( 1.0) (-1.0) (-1.0);
    (* Top Face *)
    glNormal3 0.0 1.0 0.0;
    glTexCoord2 0.0 1.0;  glVertex3 (-1.0) ( 1.0) (-1.0);
    glTexCoord2 0.0 0.0;  glVertex3 (-1.0) ( 1.0) ( 1.0);
    glTexCoord2 1.0 0.0;  glVertex3 ( 1.0) ( 1.0) ( 1.0);
    glTexCoord2 1.0 1.0;  glVertex3 ( 1.0) ( 1.0) (-1.0);
    (* Bottom Face *)
    glNormal3 0.0 (-1.0) 0.0;
    glTexCoord2 1.0 1.0;  glVertex3 (-1.0) (-1.0) (-1.0);
    glTexCoord2 0.0 1.0;  glVertex3 ( 1.0) (-1.0) (-1.0);
    glTexCoord2 0.0 0.0;  glVertex3 ( 1.0) (-1.0) ( 1.0);
    glTexCoord2 1.0 0.0;  glVertex3 (-1.0) (-1.0) ( 1.0);
    (* Right face *)
    glNormal3 1.0 0.0 0.0;
    glTexCoord2 1.0 0.0;  glVertex3 ( 1.0) (-1.0) (-1.0);
    glTexCoord2 1.0 1.0;  glVertex3 ( 1.0) ( 1.0) (-1.0);
    glTexCoord2 0.0 1.0;  glVertex3 ( 1.0) ( 1.0) ( 1.0);
    glTexCoord2 0.0 0.0;  glVertex3 ( 1.0) (-1.0) ( 1.0);
    (* Left Face *)
    glNormal3 (-1.0) 0.0 0.0;
    glTexCoord2 0.0 0.0;  glVertex3 (-1.0) (-1.0) (-1.0);
    glTexCoord2 1.0 0.0;  glVertex3 (-1.0) (-1.0) ( 1.0);
    glTexCoord2 1.0 1.0;  glVertex3 (-1.0) ( 1.0) ( 1.0);
    glTexCoord2 0.0 1.0;  glVertex3 (-1.0) ( 1.0) (-1.0);
  glEnd();

  fXRotation += !fXSpeed;
  fYRotation += !fYSpeed;

  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glXSwapBuffers dpDisplay dwin;
;;


(* The function called whenever a key is pressed. *)
let keyPressed dpDisplay ~key =

  (* If escape is pressed, kill everything. *)
  match keysym_var key with
  | XK_Escape ->
      xCloseDisplay dpDisplay;

      (* exit the program...normal termination. *)
      exit(0);

  | XK_L
  | XK_l ->
      light := not !light;
      if !light
      then glEnable GL_LIGHTING
      else glDisable GL_LIGHTING;

  | XK_F
  | XK_f ->
      incr filter;
      if (!filter > 2)
      then filter := 0;

  | XK_G
  | XK_g ->
      incr fogfilter;
      if !fogfilter > 2 then
        fogfilter := 0;

      glFog (GL_FOG_MODE fogMode.(!fogfilter));

  | XK_Page_Up ->
      z -= 0.02;

  | XK_Page_Down ->
      z += 0.02;

  | XK_Up ->
      fXSpeed -= 0.01;

  | XK_Down ->
      fXSpeed += 0.01;

  | XK_Left ->
      fYSpeed -= 0.01;

  | XK_Right ->
      fYSpeed += 0.01;

  | _ -> ()
;;


let xMainLoop (dpDisplay, dwin, wmDeleteWindow) iTexture =
  let needRedraw = ref false in

  let event = new_xEvent() in
  while true do
    if xPending dpDisplay > 0 then  (* While more events are pending, continue processing. *)
    begin
      (* Get the current event from the system queue. *)
      xNextEvent dpDisplay event;

      (* Process the incoming event. *)
      begin match xEventType event with
      | Expose ->
          needRedraw := true;

      (* If window moves, redraw it. *)
      | MotionNotify ->
          needRedraw := true;

      (* If a key was pressed, get keystroke and called the processing function. *)
      | KeyPress ->
          let ks = xLookupKeysym (to_xKeyEvent event) 0 in
          keyPressed dpDisplay ks;

      (* If the screen was resized, call the appropriate function. *)
      | ConfigureNotify ->
          let d = xConfigureEvent_datas(to_xConfigureEvent event) in
          reSizeGLScene d.conf_width d.conf_height;

      | ButtonPress ->
          ()

      (* Process any custom messages. *)
      | ClientMessage ->
          if xEvent_xclient_data(to_xClientMessageEvent event) = wmDeleteWindow then
          begin
            xCloseDisplay dpDisplay;
            exit(0);
          end;

      | _ -> ()
      end;
    end;

    (* If redraw flag is set, redraw the window. *)
    (* if !needRedraw then *)
    begin
      drawGLScene dpDisplay dwin iTexture;
    end;
  done;
;;


(* main *)
let () =
  (* Initialize our window. *)
  let xStuff = xInitWindow Sys.argv in

  (* Initialize OpenGL routines *)
  let iTexture = initGL 640 480 in

  (* Start Event Processing Engine *)
  xMainLoop xStuff iTexture;
;;

