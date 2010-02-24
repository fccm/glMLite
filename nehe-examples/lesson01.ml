(*
 NeHe (nehe.gamedev.net) OpenGL tutorial series
 Most comments are from the original tutorials found in NeHe.
 The full tutorial associated with this file is available here:
 http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=01
 OCaml version by Florent Monnier.
*)
open GL    (* OpenGL main module *)
open Glu   (* OpenGL Utility Library *)
open Glut  (* The GL Utility Toolkit (GLUT) *)

(* Global Variables *)
let g_gamemode = ref false    (* GLUT GameMode *)
let g_fullscreen = ref false  (* Fullscreen Mode (When g_gamemode Is OFF) *)

(* Our GL Specific Initializations *)
let init() =
  glShadeModel GL_SMOOTH;              (* Enable Smooth Shading *)
  glClearColor 0.0 0.0 0.0 0.5;        (* Black Background *)
  glClearDepth 1.0;                    (* Depth Buffer Setup *)
  glEnable GL_DEPTH_TEST;              (* Enables Depth Testing *)
  glDepthFunc GL_LEQUAL;               (* The Type Of Depth Testing To Do *)
  glHint GL_PERSPECTIVE_CORRECTION_HINT GL_NICEST;  (* Really Nice Perspective Calculations *)
;;

(* Our Rendering Is Done Here *)
let display() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];  (* Clear Screen And Depth Buffer *)
  glLoadIdentity();                    (* Reset The Current Modelview Matrix *)

  (* Swap The Buffers To Become Our Rendering Visible *)
  glutSwapBuffers ( );
;;

(* Our Reshaping Handler (Required Even In Fullscreen-Only Modes) *)
let reshape ~width:w ~height:h =
  glViewport 0 0 w h;
  glMatrixMode GL_PROJECTION;      (* Select The Projection Matrix *)
  glLoadIdentity();                (* Reset The Projection Matrix *)
  (* Calculate The Aspect Ratio And Set The Clipping Volume *)
  let h =
    if (h == 0)
    then 1
    else h
  in
  gluPerspective 80. ((float w)/.(float h)) 1.0 5000.0;
  glMatrixMode GL_MODELVIEW;       (* Select The Modelview Matrix *)
  glLoadIdentity();                (* Reset The Modelview Matrix *)
;;

(* Our Keyboard Handler (Normal Keys) *)
let keyboard ~key ~x ~y =
  match key with
  | '\027' ->     (* When Escape Is Pressed... *)
      exit(0);    (* Exit The Program *)
  | _ -> ()       (* The Default Case *)
;;

(* Our Keyboard Handler For Special Keys (Like Arrow Keys And Function Keys) *)
let special_keys ~key ~x ~y =
  match key with
  | GLUT_KEY_F1 ->
      (* We Can Switch Between Windowed Mode And Fullscreen Mode Only *)
      if !g_gamemode then begin
        g_fullscreen := not !g_fullscreen;  (* Toggle g_fullscreen Flag *)
        if !g_fullscreen                    (* We Went In Fullscreen Mode *)
        then glutFullScreen()
        else glutReshapeWindow 500 500;     (* We Went In Windowed Mode *)
      end;
  | _ -> ()
;;

(* Parse The Command Line To Know If The User Wish To Enter GameMode Or Not *)
let ask_gamemode() =
  let usage = "To enter in game mode use --game-mode" in
  let speclist = [
    ("--game-mode", Arg.Unit (fun () -> g_gamemode := true), ": set somebool to true");
  ] in
  (* Read The Arguments *)
  Arg.parse
    speclist
    (fun x -> raise (Arg.Bad ("Bad argument : " ^ x)))
    usage;
;;

(* Main Function For Bringing It All Together. *)
let () =
  ask_gamemode();                                  (* Ask For Fullscreen Mode *)
  ignore(glutInit Sys.argv);                       (* GLUT Initializtion *)
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE];     (* Display Mode (Rgb And Double Buffered) *)
  if !g_gamemode then begin
    glutGameModeString "640x480:16";               (* Select The 640x480 In 16bpp Mode *)
    if (glutGameModeGet GLUT_GAME_MODE_POSSIBLE) = 1
    then glutEnterGameMode()                       (* Enter Full Screen *)
    else g_gamemode := false;                      (* Cannot Enter Game Mode, Switch To Windowed *)
  end;
  if not !g_gamemode then begin
    glutInitWindowSize 500 500;                    (* Window Size If We Start In Windowed Mode *)
    ignore(glutCreateWindow "NeHe's OpenGL Framework"); (* Window Title *)
  end;
  init();                                          (* Our Initialization *)
  glutDisplayFunc ~display;                        (* Register The Display Function *)
  glutReshapeFunc ~reshape;                        (* Register The Reshape Handler *)
  glutKeyboardFunc ~keyboard;                      (* Register The Keyboard Handler *)
  glutSpecialFunc ~special:special_keys;           (* Register Special Keys Handler *)
  glutMainLoop();                                  (* Go To GLUT Main Loop *)
;;

