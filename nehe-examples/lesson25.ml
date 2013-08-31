(*
 *  This Code Was Created By Pet & Commented/Cleaned Up By Jeff Molofee
 *  If You've Found This Code Useful, Please Let Me Know.
 *  Visit NeHe Productions At http://nehe.gamedev.net
 *
 *  The full tutorial associated with this file is available here:
 *  http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=25
 *
 *  glut port by tsuraan
 *  ocaml port by Florent Monnier
 *)

open GL                                                 (* Module For The OpenGL Library *)
open Glu                                                (* Module For The GLu Library *)
open Glut                                               (* Module For The Glut Library *)

let xrot, yrot, zrot = ref 0., ref 0., ref 0. ;;        (* X, Y & Z Rotation *)
let xspeed, yspeed, zspeed = ref 0., ref 0., ref 0. ;;  (* X, Y & Z Spin Speed *)
let cx, cy, cz = ref 0.0, ref 0.0, ref(-15.0) ;;        (* X, Y & Z Position *)

let key = ref 1                                         (* Used To Make Sure Same Morph Key Is Not Pressed *)
let step = ref 0 ;; let steps = 300                     (* Step Counter And Maximum Number Of Steps *)
let morph = ref false                                   (* Default morph To False (Not Morphing) *)

type vertex = {                                         (* Structure Called VERTEX For 3D Points *)
  mutable x: float;
  mutable y: float;                                     (* X, Y & Z Points *)
  mutable z: float;
}

type object_ = {                                        (* Structure Called OBJECT For An Object *)
  verts: int;                                           (* Number Of Vertices For The Object *)
  points: vertex array;                                 (* One Vertice (Vertex x,y & z) *)
}

let sour = ref { verts=0; points=[| |] }                (* Helper Object, Source Object, Destination Object *)
let dest = ref { verts=0; points=[| |] }
let helper = ref { verts=0; points=[| |] }

let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;


let objload ~name =                                     (* Loads Object From File (name) *)
  let ic = open_in name in
  let line = input_line ic in
  (* Scans Text For "Vertices: ".  Number After Is Stored In ver *)
  let nverts = Scanf.sscanf line "Vertices: %d" (fun n -> n) in
  let obj =
    { verts = nverts;
      points = Array.init nverts (fun _ ->
        let line = input_line ic in
        (* Searches For 3 Floating Point Numbers, Store In x,y & z *)
        let x, y, z = Scanf.sscanf line "%f %f %f" (fun x y z -> x,y,z) in
        { x=x; y=y; z=z; }
      );
    }
  in
  close_in ic;
  (obj)
;;


let calculate ~i =                                    (* Calculates Movement Of Points During Morphing *)
  { x = (!sour.points.(i).x -. !dest.points.(i).x) /. float steps;
    y = (!sour.points.(i).y -. !dest.points.(i).y) /. float steps;
    z = (!sour.points.(i).z -. !dest.points.(i).z) /. float steps; }
;;                                                    (* This Makes Points Move At A Speed So They All Get To Their *)
                                                      (* Destination At The Same Time *)

let resize ~width ~height =                           (* Resize And Initialize The GL Window *)
  let height =
    if height = 0                                     (* Prevent A Divide By Zero By *)
    then 1                                            (* Making Height Equal One *)
    else height                                       (* Keep It Unchanged *)
  in

  glViewport 0 0 width height;                        (* Reset The Current Viewport *)

  glMatrixMode GL_PROJECTION;                         (* Select The Projection Matrix *)
  glLoadIdentity();                                   (* Reset The Projection Matrix *)

  (* Calculate The Aspect Ratio Of The Window *)
  gluPerspective 45.0 (float width /. float height) 0.1 100.0;

  glMatrixMode GL_MODELVIEW;                          (* Select The Modelview Matrix *)
  glLoadIdentity();                                   (* Reset The Modelview Matrix *)
;;


let initGL() =                                        (* All Setup For OpenGL Goes Here *)
  glBlendFunc Sfactor.GL_SRC_ALPHA  Dfactor.GL_ONE;   (* Set The Blending Function For Translucency *)
  glClearColor 0.0 0.0 0.0 0.0;                       (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                                   (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                                (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;                             (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;                             (* Enables Smooth Color Shading *)
  glHint GL_PERSPECTIVE_CORRECTION_HINT  GL_NICEST;   (* Really Nice Perspective Calculations *)

  let morph1 = objload "Data/lesson25/Sphere.txt" in  (* Load The First Object Into morph1 From File sphere.txt *)
  let morph2 = objload "Data/lesson25/Torus.txt" in   (* Load The Second Object Into morph2 From File torus.txt *)
  let morph3 = objload "Data/lesson25/Tube.txt" in    (* Load The Third Object Into morph3 From File tube.txt *)

  let morph4 = {
    verts = 486;
    points =
      Array.init 486 (fun _ ->                        (* Loop Through All 468 Vertices *)
        { x = (Random.float 14.0) -. 7.0;             (* morph4 x Point Becomes A Random Float Value From -7 to 7 *)
          y = (Random.float 14.0) -. 7.0;             (* morph4 y Point Becomes A Random Float Value From -7 to 7 *)
          z = (Random.float 14.0) -. 7.0; }           (* morph4 z Point Becomes A Random Float Value From -7 to 7 *)
      );
  } in

  helper := objload "Data/lesson25/Sphere.txt";       (* Load sphere.txt Object Into Helper (Used As Starting Point) *)
  sour := morph1;                                     (* Source & Destination Are Set To Equal First Object (morph1) *)
  dest := morph1;

  (morph1, morph2, morph3, morph4)
;;

let ( <-= ) v1 v2 =
  v1.x <- v1.x -. v2.x;
  v1.y <- v1.y -. v2.y;
  v1.z <- v1.z -. v2.z;
;;

let drawGLScene (morph1, _, _, _) () =                (* Here's Where We Do All The Drawing *)
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT]; (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                                   (* Reset The View *)
  glTranslate !cx !cy !cz;                            (* Translate The The Current Position To Start Drawing *)
  glRotate !xrot 1.0 0.0 0.0;                         (* Rotate On The X Axis By xrot *)
  glRotate !yrot 0.0 1.0 0.0;                         (* Rotate On The Y Axis By yrot *)
  glRotate !zrot 0.0 0.0 1.0;                         (* Rotate On The Z Axis By zrot *)

  xrot += !xspeed; yrot += !yspeed; zrot += !zspeed;  (* Increase xrot,yrot & zrot by xspeed, yspeed & zspeed *)

  glBegin GL_POINTS;                                  (* Begin Drawing Points *)
    for i = 0 to pred morph1.verts do                 (* Loop Through All The Verts Of morph1 (All Objects Have *)
                                                      (* The Same Amount Of Verts For Simplicity *)
      let q = if !morph then calculate i
                        else { x=0.; y=0.; z=0.; } in (* If morph Is True Calculate Movement Otherwise Movement=0 *)
      !helper.points.(i).x <- !helper.points.(i).x -. q.x;  (* Subtract q.x Units From helper.points[i].x (Move On X Axis) *)
      !helper.points.(i).y <- !helper.points.(i).y -. q.y;  (* Subtract q.y Units From helper.points[i].y (Move On Y Axis) *)
      !helper.points.(i).z <- !helper.points.(i).z -. q.z;  (* Subtract q.z Units From helper.points[i].z (Move On Z Axis) *)
      let tx = ref !helper.points.(i).x in            (* Make Temp X Variable Equal To Helper's X Variable *)
      let ty = ref !helper.points.(i).y in            (* Make Temp Y Variable Equal To Helper's Y Variable *)
      let tz = ref !helper.points.(i).z in            (* Make Temp Z Variable Equal To Helper's Z Variable *)

      glColor3 0. 1. 1.;                              (* Set Color To A Bright Shade Of Off Blue *)
      glVertex3 !tx !ty !tz;                          (* Draw A Point At The Current Temp Values (Vertex) *)
      glColor3 0. 0.5 1.;                             (* Darken Color A Bit *)
      tx-=2.*.q.x; ty-=2.*.q.y; ty-=2.*.q.y;          (* Calculate Two Positions Ahead *)
      glVertex3 !tx !ty !tz;                          (* Draw A Second Point At The Newly Calculate Position *)
      glColor3 0. 0. 1.;                              (* Set Color To A Very Dark Blue *)
      tx-=2.*.q.x; ty-=2.*.q.y; ty-=2.*.q.y;          (* Calculate Two More Positions Ahead *)
      glVertex3 !tx !ty !tz;                          (* Draw A Third Point At The Second New Position *)
    done;                                             (* This Creates A Ghostly Tail As Points Move *)
  glEnd();                                            (* Done Drawing Points *)

  (* If We're Morphing And We Haven't Gone Through All 200 Steps Increase Our Step Counter
     Otherwise Set Morphing To False, Make Source=Destination And Set The Step Counter Back To Zero. *)
  if (!morph && !step <= steps)
  then incr step
  else ( morph := false;  sour := !dest;  step := 0 );

  glutSwapBuffers();
;;


let specialFunc ~key ~x ~y =
  match key with
  | GLUT_KEY_PAGE_UP ->                       (* Is Page Up Being Pressed? *)
      zspeed += 0.01;                         (* Increase zspeed *)

  | GLUT_KEY_PAGE_DOWN ->                     (* Is Page Down Being Pressed? *)
      zspeed -= 0.01;                         (* Decrease zspeed *)

  | GLUT_KEY_DOWN ->                          (* Is Down Being Pressed? *)
      xspeed += 0.01;                         (* Increase xspeed *)

  | GLUT_KEY_UP ->                            (* Is Up Being Pressed? *)
      xspeed -= 0.01;                         (* Decrease xspeed *)

  | GLUT_KEY_RIGHT ->                         (* Is Right Being Pressed? *)
      yspeed += 0.01;                         (* Increase yspeed *)

  | GLUT_KEY_LEFT ->                          (* Is Left Being Pressed? *)
      yspeed -= 0.01;                         (* Decrease yspeed *)
  | _ -> ()
;;


let keyFunc (morph1, morph2, morph3, morph4) ~key:k ~x ~y =
  match k with
  | 'Q' | 'q' ->                              (* Is Q Key Being Pressed? *)
      cz -= 0.01;                             (* Move Object Away From Viewer *)

  | 'Z' | 'z' ->                              (* Is Z Key Being Pressed? *)
      cz += 0.01;                             (* Move Object Towards Viewer *)

  | 'W' | 'w' ->                              (* Is W Key Being Pressed? *)
      cy += 0.01;                             (* Move Object Up *)

  | 'S' | 's' ->                              (* Is S Key Being Pressed? *)
      cy -= 0.01;                             (* Move Object Down *)

  | 'D' | 'd' ->                              (* Is D Key Being Pressed? *)
      cx += 0.01;                             (* Move Object Right *)

  | 'A' | 'a' ->                              (* Is A Key Being Pressed? *)
      cx -= 0.01;                             (* Move Object Left *)

  | '1' -> 
      if !key<>1 && not !morph then     (* Is 1 Pressed, key Not Equal To 1 And Morph False? *)
      begin
        key := 1;                             (* Sets key To 1 (To Prevent Pressing 1 2x In A Row) *)
        morph := true;                        (* Set morph To True (Starts Morphing Process) *)
        dest := morph1;                       (* Destination Object To Morph To Becomes morph1 *)
      end

  | '2' ->
      if !key<>2 && not !morph then     (* Is 2 Pressed, key Not Equal To 2 And Morph False? *)
      begin
        key := 2;                             (* Sets key To 2 (To Prevent Pressing 2 2x In A Row) *)
        morph := true;                        (* Set morph To True (Starts Morphing Process) *)
        dest := morph2;                       (* Destination Object To Morph To Becomes morph2 *)
      end

  | '3' ->
      if !key<>3 && not !morph then     (* Is 3 Pressed, key Not Equal To 3 And Morph False? *)
      begin
        key := 3;                             (* Sets key To 3 (To Prevent Pressing 3 2x In A Row) *)
        morph := true;                        (* Set morph To True (Starts Morphing Process) *)
        dest := morph3;                       (* Destination Object To Morph To Becomes morph3 *)
      end

  | '4' ->
      if !key<>4 && not !morph then     (* Is 4 Pressed, key Not Equal To 4 And Morph False? *)
      begin
        key := 4;                             (* Sets key To 4 (To Prevent Pressing 4 2x In A Row) *)
        morph := true;                        (* Set morph To True (Starts Morphing Process) *)
        dest := morph4;                       (* Destination Object To Morph To Becomes morph4 *)
      end

  | '\027' ->                           (* Escape key is pressed *)
      exit(0);

  | _ -> ()
;;


(* main *)
let () =
  let _ = glutInit Sys.argv in
  glutInitWindowSize 640 480;
  glutInitDisplayMode [GLUT_DOUBLE; GLUT_RGB; GLUT_DEPTH];
  let _ = glutCreateWindow "Piotr Cieslak & NeHe's Morphing Points Tutorial" in
  let morphs = initGL() in
  glutDisplayFunc (drawGLScene morphs);
  glutIdleFunc (drawGLScene morphs);
  glutKeyboardFunc (keyFunc morphs);
  glutSpecialFunc (specialFunc);
  glutReshapeFunc (resize);
  glutMainLoop();
;;

