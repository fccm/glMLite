(* Demo of off-screen Mesa rendering
 *
 * See include/GL/osmesa.h for documentation of the osMesa functions,
 * or the ocamldoc from the .mli.
 *
 * If you want to render BIG images you'll probably have to increase
 * MAX_WIDTH and MAX_height in src/config.h.
 *
 * This program is in the public domain.
 *
 * by Brian Paul
 * OCaml version by F. Monnier
 *
 * PPM output provided by Joerg Schmalzl.
 * ASCII PPM output added by Brian Paul.
 *
 * Usage: osdemo filename [width height]
 *)

open GL
open Glu
open OSMesa


let draw_sphere ~radius ~slices ~stacks =
  let q = gluNewQuadric() in
  gluQuadricNormals q GLU_SMOOTH;
  gluSphere q radius slices stacks;
  gluDeleteQuadric q;
;;


let draw_cone ~base ~height ~slices ~stacks =
  let q = gluNewQuadric() in
  gluQuadricDrawStyle q GLU_FILL;
  gluQuadricNormals q GLU_SMOOTH;
  gluCylinder q base 0.0 height slices stacks;
  gluDeleteQuadric q;
;;


let m2PI = 8.0 *. atan 1.0 ;;

let draw_torus ~innerRadius ~outerRadius ~sides ~rings =
  (* from GLUT... *)
  let ringDelta = m2PI /. (float rings)
  and sideDelta = m2PI /. (float sides)
  in
  let theta = ref 0.0
  and cosTheta = ref 1.0
  and sinTheta = ref 0.0
  in
  for i = rings - 1 downto 0 do
    let theta1 = !theta +. ringDelta in
    let cosTheta1 = cos theta1
    and sinTheta1 = sin theta1 in
    glBegin GL_QUAD_STRIP;
    let phi = ref 0.0 in
    for j = sides downto 0 do

      phi := !phi +. sideDelta;
      let cosPhi = cos !phi
      and sinPhi = sin !phi in
      let dist = outerRadius +. innerRadius *. cosPhi in

      glNormal3 (cosTheta1 *. cosPhi) (-. sinTheta1 *. cosPhi) (sinPhi);
      glVertex3 (cosTheta1 *. dist)   (-. sinTheta1 *. dist)   (innerRadius *. sinPhi);
      glNormal3 (!cosTheta *. cosPhi) (-. !sinTheta *. cosPhi) (sinPhi);
      glVertex3 (!cosTheta *. dist)   (-. !sinTheta *. dist)   (innerRadius *. sinPhi);
    done;
    glEnd();
    theta := theta1;
    cosTheta := cosTheta1;
    sinTheta := sinTheta1;
  done;
;;


let render_image() =
  let light_ambient = (0.0, 0.0, 0.0, 1.0)
  and light_diffuse = (1.0, 1.0, 1.0, 1.0)
  and light_specular = (1.0, 1.0, 1.0, 1.0)
  and light_position = (1.0, 1.0, 1.0, 0.0)
  and red_mat   = (1.0, 0.2, 0.2, 1.0)
  and green_mat = (0.2, 1.0, 0.2, 1.0)
  and blue_mat  = (0.2, 0.2, 1.0, 1.0)
  in

  glLight (GL_LIGHT 0) (Light.GL_AMBIENT light_ambient);
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE light_diffuse);
  glLight (GL_LIGHT 0) (Light.GL_SPECULAR light_specular);
  glLight (GL_LIGHT 0) (Light.GL_POSITION light_position);
   
  glEnable GL_LIGHTING;
  glEnable GL_LIGHT0;
  glEnable GL_DEPTH_TEST;

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  glOrtho (-2.5) (2.5) (-2.5) (2.5) (-10.0) (10.0);
  glMatrixMode GL_MODELVIEW;

  glClearColor 0.2 0.3 0.5 0.0;

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  glPushMatrix();
  glRotate 20.0  1.0 0.0 0.0;

  glPushMatrix();
  glTranslate (-0.75) (0.5) (0.0); 
  glRotate 90.0  1.0 0.0 0.0;
  glMaterial GL_FRONT_AND_BACK (Material.GL_AMBIENT_AND_DIFFUSE red_mat);
    draw_torus 0.275 0.85 20 20;
  glPopMatrix();

  glPushMatrix();
  glTranslate (-0.75) (-0.5) (0.0); 
  glRotate 270.0  1.0 0.0 0.0;
  glMaterial GL_FRONT_AND_BACK (Material.GL_AMBIENT_AND_DIFFUSE green_mat);
    draw_cone 1.0 2.0 16 1;
  glPopMatrix();

  glPushMatrix();
  glTranslate (0.75) (0.0) (-1.0); 
  glMaterial GL_FRONT_AND_BACK (Material.GL_AMBIENT_AND_DIFFUSE blue_mat);
    draw_sphere 1.0 20 20;
  glPopMatrix();

  glPopMatrix();

  (* This is very important!!!
   * Make sure buffered commands are finished!!!
   *)
  glFinish();
;;


let nt = Nativeint.to_int ;;

let write_targa ~filename ~buffer ~width ~height =
  let f = open_out_bin filename in
  print_endline "osdemo, writing tga file";
  output_byte f 0x00;      (* ID Length, 0 => No ID      *)
  output_byte f 0x00;      (* Color Map Type, 0 => No color map included      *)
  output_byte f 0x02;      (* Image Type, 2 => Uncompressed, True-color Image *)
  output_byte f 0x00;      (* Next five bytes are about the color map entries *)
  output_byte f 0x00;      (* 2 bytes Index, 2 bytes length, 1 byte size *)
  output_byte f 0x00;
  output_byte f 0x00;
  output_byte f 0x00;
  output_byte f 0x00;      (* X-origin of Image      *)
  output_byte f 0x00;
  output_byte f 0x00;      (* Y-origin of Image      *)
  output_byte f 0x00;
  output_byte f (width land 0xff);      (* Image width      *)
  output_byte f ((width lsr 8) land 0xff);
  output_byte f (height land 0xff);     (* Image height      *)
  output_byte f ((height lsr 8) land 0xff);
  output_byte f 0x18;            (* Pixel Depth, 0x18 => 24 Bits      *)
  output_byte f 0x20;            (* Image Descriptor      *)
  for y=height-1 downto 0 do
    for x=0 to pred width do
      let i = (y*width + x) * 4 in
      output_byte f (nt buffer.{i+2});  (* write blue *)
      output_byte f (nt buffer.{i+1});  (* write green *)
      output_byte f (nt buffer.{i});    (* write red *)
    done;
  done;
;;



let write_ppm ~filename ~buffer ~width ~height ~binary =
  let f = open_out_bin filename in
  print_endline "osdemo, writing ppm file";
  if binary then begin
    output_string f "P6\n";
    output_string f "# ppm-file created by osdemo.ml\n";
    output_string f (Printf.sprintf "%i %i\n" width height);
    output_string f "255\n";
    for y = height-1 downto 0 do
      for x=0 to pred width do
        let i = (y*width + x) * 4 in
        output_byte f (nt buffer.{i});    (* write red *)
        output_byte f (nt buffer.{i+1});  (* write green *)
        output_byte f (nt buffer.{i+2});  (* write blue *)
      done;
    done;
  end
  else begin
    (*ASCII*)
    let counter = ref 0 in
    output_string f "P3\n";
    output_string f "# ascii ppm file created by osdemo.ml\n";
    output_string f (Printf.sprintf "%i %i\n" width height);
    output_string f "255\n";
    for y=height-1 downto 0 do
      for x=0 to pred width do
        let i = (y*width + x) * 4 in
        Printf.fprintf f " %3nd %3nd %3nd"
                       buffer.{i} buffer.{i+1} buffer.{i+2};
        incr counter;
        if (!counter mod 5) = 0 then
          output_string f "\n";
      done;
    done;
  end;
  close_out f;
;;


let write_debug ~filename ~buffer ~width ~height =
  let counter = ref 0 in
  for y=height-1 downto 0 do
    for x=0 to pred width do
      let i = (y*width + x) * 4 in
      Printf.printf " %nd %nd %nd"
                     buffer.{i} buffer.{i+1} buffer.{i+2};
      incr counter;
      if (!counter mod 8) = 0 then
        print_string "\n";
    done;
  done;
;;



let () =
  if Array.length Sys.argv < 2 then
    invalid_arg(Printf.sprintf "Usage: \
                  %s filename [width height]" Sys.argv.(0));

  let filename =
    try Sys.argv.(1)
    with _ ->
      invalid_arg "Specify a filename for the image"
  in

  let width, height =
    if Array.length Sys.argv = 4 then
      ( int_of_string Sys.argv.(2),
        int_of_string Sys.argv.(3) )
    else
      (400, 400)
  in

  (* Create an RGBA-mode context *)
  (*
  let ctx =
    if (100 * major_version()) + minor_version() >= 305 then
      (* specify Z, stencil, accum sizes *)
      osMesaCreateContextExt OSMESA_RGBA  16 0 0 None
    else
      osMesaCreateContext OSMESA_RGBA None;
  in
  *)
  let ctx = osMesaCreateContext OSMESA_RGBA None in

  (* Allocate the image buffer *)
  let buffer =
    Bigarray.Array1.create
          Bigarray.nativeint
          Bigarray.c_layout
          (width * height * 4)
  in

  (* Bind the buffer to the context and make it current *)
  osMesaMakeCurrent ctx buffer OSM_UNSIGNED_BYTE width height;

  begin
    let z = glGetInteger1 Get.GL_DEPTH_BITS
    and s = glGetInteger1 Get.GL_STENCIL_BITS
    and a = glGetInteger1 Get.GL_ACCUM_RED_BITS in
    Printf.printf "Depth=%d Stencil=%d Accum=%d\n%!" z s a;
  end;

  render_image();

  (*
  let save_targa = true in

  if save_targa
  then write_targa ~filename ~buffer ~width ~height
  else write_ppm  ~filename ~buffer ~width ~height ~binary:true;
  *)
  (*
  write_debug ~filename ~buffer ~width ~height;
  *)
  let ok = ref false in
  for i=0 to pred (width * height * 4) do
    if buffer.{i} <> 0n then ok := true;
  done;
  if !ok
  then Printf.printf "Buffer OK!\n%!"
  else Printf.printf "Empty buffer\n%!";

  Printf.printf "all done\n%!";

  (* destroy the context *)
  osMesaDestroyContext ~ctx;
;;

