(* GL_ARB_multitexture demo
 *
 * Command line options:
 *    -info      print GL implementation information
 *
 * Brian Paul  November 1998  This program is in the public domain.
 * Modified on 12 Feb 2002 for > 2 texture units.
 *
 * OCaml version by Florent Monnier
 *)

open GL
open Glu
open Glut

let texture_1_file = "./ladybird.jpg"
let texture_2_file = "./wall-rgb.jpg"

let tex0 = 1
let tex7 = 8
let animate_e = 10
let quit = 100

let animate = ref true
let num_units = ref 1
let tex_enabled = Array.make 8 true

let drift = ref 0.0
let drift_increment = ref 0.005

let x_rot = ref 20.0
and y_rot = ref 30.0
and z_rot = ref 0.0 ;;


let idle() =
  if (!animate) then
  begin
    drift := !drift +. !drift_increment;
    if (!drift >= 1.0) then
      drift := 0.0;

    for i = 0 to pred !num_units do
      glActiveTexturei i;
      glMatrixMode GL_TEXTURE;
      glLoadIdentity();
      match i with
      | 0 ->
          glTranslate !drift 0.0 0.0;
          glScale 2. 2. 1.;
      | 1 ->
          glTranslate 0.0 !drift 0.0;
      | _ ->
          glTranslate 0.5 0.5 0.0;
          glRotate (180.0 *. !drift) 0. 0. 1.;
          let s = float i in
          glScale (1.0/.s) (1.0/.s) (1.0/.s);
          glTranslate (-0.5) (-0.5) (0.0);
    done;
    glMatrixMode GL_MODELVIEW;

    glutPostRedisplay();
  end;
;;


let draw_object() =
  let tex_coords = [|  0.0;  0.0;  1.0;  1.0;  0.0 |]
  and vtx_coords = [| -1.0; -1.0;  1.0;  1.0; -1.0 |]
  in

  if (not tex_enabled.(0)) && (not tex_enabled.(1))
  then glColor3 0.1 0.1 0.1   (* add onto this *)
  else glColor3 1.0 1.0 1.0;  (* modulate this *)

  glBegin GL_QUADS;

  (* Toggle between the vector and scalar entry points.
   * This is done purely to hit multiple paths in the driver.
   *)
  if !drift > 0.49 then
    for j = 0 to pred 4 do
      for i = 0 to pred !num_units do
        glMultiTexCoord2i i tex_coords.(j) tex_coords.(j+1);
      done;
      glVertex2 vtx_coords.(j) vtx_coords.(j+1);
    done
  else 
    for j = 0 to pred 4 do
      for i = 0 to pred !num_units do
        glMultiTexCoord2i i tex_coords.(j) tex_coords.(j+1);
      done;
      glVertex2 vtx_coords.(j) vtx_coords.(j+1);
    done;

  glEnd();
;;



let frames = ref 0
let t0 = ref 0

let display() =
  glClear [GL_COLOR_BUFFER_BIT];

  glPushMatrix();
    glRotate !x_rot 1.0 0.0 0.0;
    glRotate !y_rot 0.0 1.0 0.0;
    glRotate !z_rot 0.0 0.0 1.0;
    glScale 5.0 5.0 5.0;
    draw_object();
  glPopMatrix();

  glutSwapBuffers();

  incr frames;

  let t = glutGet GLUT_ELAPSED_TIME in
  let t_diff = t - !t0 in
  if (t_diff >= 250) then begin
    let seconds = (float t_diff) /. 1000.0 in
    drift_increment := 2.2 *. seconds /. (float !frames);
    t0 := t;
    frames := 0;
  end;
;;


let reshape ~width ~height =
  glViewport 0 0 width height;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glFrustum (-1.0) (1.0) (-1.0) (1.0) (10.0) (100.0);
  (*glOrtho( -6.0, 6.0, -6.0, 6.0, 10.0, 100.0 );*)
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
  glTranslate 0.0 0.0 (-70.0);
;;


let mode_menu ~value:entry =
  if (entry >= tex0 && entry <= tex7) then
  begin
    (* toggle *)
    let i = entry - tex0 in
    tex_enabled.(i) <- not tex_enabled.(i);
    glActiveTexturei i;
    if tex_enabled.(i)
    then glEnable GL_TEXTURE_2D
    else glDisable GL_TEXTURE_2D;
    Printf.printf "Enabled: ";
    for i = 0 to pred !num_units do
      Printf.printf "%b " tex_enabled.(i);
    done;
    Printf.printf "\n";
  end
  else if (entry = animate_e) then
    animate := not !animate
  else if (entry = quit) then
    exit 0;

  glutPostRedisplay();
;;


let key ~key ~x ~y =
  begin match key with
  | 'q' | '\027' -> exit 0;
  | _ -> ()
  end;
  glutPostRedisplay();
;;


let special_key ~key ~x ~y =
  let step = 3.0 in
  begin match key with
  | GLUT_KEY_UP    -> x_rot := !x_rot +. step;
  | GLUT_KEY_DOWN  -> x_rot := !x_rot -. step;
  | GLUT_KEY_LEFT  -> y_rot := !y_rot +. step;
  | GLUT_KEY_RIGHT -> y_rot := !y_rot -. step;
  | _ -> ()
  end;
  glutPostRedisplay();
;;


let strstr str sub =
  let sub_len = String.length sub
  and str_len = String.length str
  and c = sub.[0]
  in
  let rec aux i =
    if i >= str_len then (false) else
    if str.[i] <> c
    then aux (succ i) else
      try
        let comp = String.sub str i sub_len in
        if sub = comp
        then (true)
        else aux (succ i)
      with
        Invalid_argument "String.sub" -> (false)
  in
  aux 0
;;


let load_texture ~filename =
  let texture, width, height, internal_format, pixel_data_format =
    Jpeg_loader.load_img (Filename filename)
  in
  gluBuild2DMipmaps
            internal_format
            width height
            pixel_data_format
            GL_UNSIGNED_BYTE
            texture;
;;


let init() =
  let exten = glGetString GL_EXTENSIONS in

  if (not (strstr exten "GL_ARB_multitexture")) then begin
    Printf.printf "Sorry, GL_ARB_multitexture not supported by this renderer.\n";
    exit 1;
  end;

  num_units := max (glGetInteger1 Get.GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS)
                   (glGetInteger1 Get.GL_MAX_TEXTURE_UNITS);
  Printf.printf "%d texture units supported\n" !num_units;
  if (!num_units > 8) then
    num_units := 8;

  let size = glGetInteger1 Get.GL_MAX_TEXTURE_SIZE in
  Printf.printf "%d x %d max texture size\n" size size;
  Printf.printf "%!";

  glPixelStorei GL_UNPACK_ALIGNMENT 1;

  for i = 0 to pred !num_units do
    if (i < 2)
    then tex_enabled.(i) <- true
    else tex_enabled.(i) <- false;
  done;

  (* allocate two texture objects *)
  let texObj = glGenTextures !num_units in

  (* setup the texture objects *)
  for i = 0 to pred !num_units do

    glActiveTexturei i;
    glBindTexture BindTex.GL_TEXTURE_2D texObj.(i);

    glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER  Min.GL_NEAREST);
    glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER  Mag.GL_NEAREST);

    if (i == 0) then
      load_texture texture_1_file
    else if (i == 1) then
      load_texture texture_2_file
    else
    begin
      (* checker *)
      (*
      GLubyte image[8][8][3];
      for i = 0 to pred 8 do
        for j = 0 to pred 8 do
          if ((i + j) & 1) then begin
            image[i][j][0] = 50;
            image[i][j][1] = 50;
            image[i][j][2] = 50;
          end
          else begin
            image[i][j][0] = 25;
            image[i][j][1] = 25;
            image[i][j][2] = 25;
          end
        done;
      done;
      glTexImage2D GL_TEXTURE_2D  0  GL_RGB  8  8
                   GL_RGB  GL_UNSIGNED_BYTE  image;
      *)

      (*
      glTexImage2D TexTarget.GL_TEXTURE_2D  0  internal_format  width height
                   pixel_data_format  GL_UNSIGNED_BYTE  texture;
      *)
      ()
    end;

    (* Bind texObj[i] to ith texture unit *)
    if (i < 2)
    then glTexEnv  TexEnv.GL_TEXTURE_ENV  TexEnv.GL_TEXTURE_ENV_MODE  TexEnv.GL_MODULATE
    else glTexEnv  TexEnv.GL_TEXTURE_ENV  TexEnv.GL_TEXTURE_ENV_MODE  TexEnv.GL_ADD;

    if tex_enabled.(i) then
      glEnable GL_TEXTURE_2D;

  done;

  glShadeModel GL_FLAT;
  glClearColor 0.3 0.3 0.4 1.0;

  let argc = Array.length Sys.argv in
  if (argc > 1 && (Sys.argv.(1) = "-info")) then begin
    Printf.printf "GL_RENDERER   = %s\n" (glGetString GL_RENDERER);
    Printf.printf "GL_VERSION    = %s\n" (glGetString GL_VERSION);
    Printf.printf "GL_VENDOR     = %s\n" (glGetString GL_VENDOR);
    Printf.printf "GL_EXTENSIONS = %s\n" (glGetString GL_EXTENSIONS);
    Printf.printf "%!";
  end;
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitWindowSize 300 300;
  glutInitWindowPosition 0 0;
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE];
  ignore(glutCreateWindow Sys.argv.(0));

  init();

  glutReshapeFunc reshape;
  glutKeyboardFunc key;
  glutSpecialFunc special_key;
  glutDisplayFunc display;
  glutIdleFunc idle;

  ignore(glutCreateMenu mode_menu);

  for i = 0 to pred !num_units do
    let s = Printf.sprintf "Toggle Texture %d" i in
    glutAddMenuEntry s (tex0 + i);
  done;
  glutAddMenuEntry "Toggle Animation" animate_e;
  glutAddMenuEntry "Quit" quit;
  glutAttachMenu GLUT_RIGHT_BUTTON ;

  glutMainLoop();
;;

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
