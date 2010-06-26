(*
 * Simon Werner, 23.07.2000
 *
 * OpenGL lesson 18. This lesson is the Linux version based on lesson 18
 * written by NeHe (Jeff Molofee):
 * http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=18
 * It is also based on other ports done by Richard Campbell.
 * This code includes snippets from lessons 5, 6, 7 and 8.
 *)

open GL                 (* Module For The OpenGL Library *)
open Glu                (* Module For The GLu Library *)
open Glut               (* Module for the GLUT library *)


let light = ref false   (* Lighting ON/OFF *)
let blend = ref false   (* Toggle blending *)

let part1 = ref 0       (* Start Of Disc  *)
let part2 = ref 0       (* End Of Disc *)
let p1 = ref 0          (* Increase 1 *)
let p2 = ref 1          (* Increase 2 *)

let filter = ref 0      (* Which Filter To Use (nearest/linear/mipmapped) *)
let object_ = ref 0     (* Which object to draw *)

let xrot = ref 0.0      (* X Rotation *)
let yrot = ref 0.0      (* Y Rotation *)
let xspeed = ref 0.0    (* x rotation speed *)
let yspeed = ref 0.0    (* y rotation speed *)
let z = ref(-5.0)       (* depth into the screen. *)


(* white ambient light at half intensity (rgba) *)
let lightAmbient = (0.5, 0.5, 0.5, 1.0)

(* super bright, full intensity diffuse light. *)
let lightDiffuse = (1.0, 1.0, 1.0, 1.0)

(* position of light (x, y, z, (position of light)) *)
let lightPosition = (0.0, 0.0, 2.0, 1.0)

let ( += ) a b =
  a := !a +. b;
;;

let ( -= ) a b =
  a := !a -. b;
;;


(* Draws the cube *)
let drawCube() =

  glBegin GL_QUADS;           (* begin drawing a cube *)
  
    (* Front Face (note that the texture's corners have to match the quad's corners) *)
    glNormal3 0.0 0.0 1.0;                                 (* front face points out of the screen on z. *)
    glTexCoord2 0.0 0.0;  glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
    glTexCoord2 1.0 0.0;  glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
    glTexCoord2 1.0 1.0;  glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Top Right Of The Texture and Quad *)
    glTexCoord2 0.0 1.0;  glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Top Left Of The Texture and Quad *)

    (* Back Face *)
    glNormal3 0.0 0.0 (-1.0);                              (* back face points into the screen on z. *)
    glTexCoord2 1.0 0.0;  glVertex3 (-1.0) (-1.0) (-1.0);  (* Bottom Right Of The Texture and Quad *)
    glTexCoord2 1.0 1.0;  glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
    glTexCoord2 0.0 1.0;  glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
    glTexCoord2 0.0 0.0;  glVertex3 ( 1.0) (-1.0) (-1.0);  (* Bottom Left Of The Texture and Quad *)

    (* Top Face *)
    glNormal3 0.0 1.0 0.0;                                 (* top face points up on y. *)
    glTexCoord2 0.0 1.0;  glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
    glTexCoord2 0.0 0.0;  glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
    glTexCoord2 1.0 0.0;  glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
    glTexCoord2 1.0 1.0;  glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)

    (* Bottom Face *)
    glNormal3 0.0 (-1.0) 0.0;                              (* bottom face points down on y. *)
    glTexCoord2 1.0 1.0;  glVertex3 (-1.0) (-1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
    glTexCoord2 0.0 1.0;  glVertex3 ( 1.0) (-1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
    glTexCoord2 0.0 0.0;  glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)
    glTexCoord2 1.0 0.0;  glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)

    (* Right face *)
    glNormal3 1.0 0.0 0.0;                                 (* right face points right on x. *)
    glTexCoord2 1.0 0.0;  glVertex3 ( 1.0) (-1.0) (-1.0);  (* Bottom Right Of The Texture and Quad *)
    glTexCoord2 1.0 1.0;  glVertex3 ( 1.0) ( 1.0) (-1.0);  (* Top Right Of The Texture and Quad *)
    glTexCoord2 0.0 1.0;  glVertex3 ( 1.0) ( 1.0) ( 1.0);  (* Top Left Of The Texture and Quad *)
    glTexCoord2 0.0 0.0;  glVertex3 ( 1.0) (-1.0) ( 1.0);  (* Bottom Left Of The Texture and Quad *)

    (* Left Face *)
    glNormal3 (-1.0) 0.0 0.0;                              (* left face points left on x. *)
    glTexCoord2 0.0 0.0;  glVertex3 (-1.0) (-1.0) (-1.0);  (* Bottom Left Of The Texture and Quad *)
    glTexCoord2 1.0 0.0;  glVertex3 (-1.0) (-1.0) ( 1.0);  (* Bottom Right Of The Texture and Quad *)
    glTexCoord2 1.0 1.0;  glVertex3 (-1.0) ( 1.0) ( 1.0);  (* Top Right Of The Texture and Quad *)
    glTexCoord2 0.0 1.0;  glVertex3 (-1.0) ( 1.0) (-1.0);  (* Top Left Of The Texture and Quad *)
    
  glEnd();                    (* done with the polygon. *)
;;


(* The main drawing function. *)
let drawGLScene quadratic texture () =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];  (* Clear The Screen And The Depth Buffer *)
  glLoadIdentity();                   (* Reset The View *)

  glTranslate 0.0 0.0 !z;             (* move 5 units into the screen. *)

  glRotate !xrot 1.0 0.0 0.0;         (* Rotate On The X Axis *)
  glRotate !yrot 0.0 1.0 0.0;         (* Rotate On The Y Axis *)

  glBindTexture BindTex.GL_TEXTURE_2D texture.(!filter);   (* choose the texture to use. *)

  begin match !object_ with           (* Check object To Find Out What To Draw *)
  | 0 ->                              (* Drawing object *)
      drawCube();                     (* Draw the cube *)

  | 1 ->                              (* Drawing object 2 *)
      glTranslate 0.0 0.0 (-1.5);     (* Center the cylinder *)
      gluCylinder quadratic 1.0 1.0 3.0 32 32;    (* Draw Our Cylinder *)

  | 2 ->                                          (* Drawing Object 3 *)
      gluDisk quadratic 0.5 1.5 32 32;            (* Draw A Disc (CD Shape) *)

  | 3 ->                                          (* Drawing Object 4 *)
      gluSphere quadratic 1.3 32 32;              (* Draw A Sphere *)

  | 4 ->                                          (* Drawing Object 5 *)
      glTranslate 0.0 0.0 (-1.5);                 (* Center The Cone *)
      gluCylinder quadratic 1.0 0.2 3.0 32 32;    (* A Cone With A Bottom Radius Of .5 And A Height Of 2 *)

  | 5 ->                                          (* Drawing Object 6 *)
      part1 := !part1 + !p1;                      (* Increase Start Angle *)
      part2 := !part2 + !p2;                      (* Increase Sweep Angle *)

      if !part1 > 359 then begin                  (* 360 Degrees *)
        p1 := 0;                                  (* Stop Increasing Start Angle *)
        part1 := 0;                               (* Set Start Angle To Zero *)
        p2 := 1;                                  (* Start Increasing Sweep Angle *)
        part2 := 0;                               (* Start Sweep Angle At Zero *)
      end;

      if !part2 > 359 then begin                  (* 360 Degrees *)
        p1 := 1;                                  (* Start Increasing Start Angle *)
        p2 := 0;                                  (* Stop Increasing Sweep Angle *)
      end;

      gluPartialDisk quadratic 0.5 1.5 32 32 (float !part1) (float(!part2 - !part1));  (* A Disk Like The One Before *)

  | _ -> ()
  end;

  xrot += !xspeed;                       (* X Axis Rotation *)
  yrot += !yspeed;                       (* Y Axis Rotation *)

  (* since this is double buffered, swap the buffers to display what just got drawn. *)
  glutSwapBuffers();
;;


(* Load texture *)
let loadGLTextures() =
  let image_data, sizeX, sizeY, tex_internal_fmt, pixel_data_fmt =
    Png_loader.load_img (Filename "./Data/lesson18/crate.png")
  in

  (* create Texture *)
  let texture = glGenTextures 3 in            (* Storage for 3 textures. *)

  (* texture 1 (poor quality scaling) *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(0);   (* 2d texture (x and y size) *)

  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_NEAREST); (* cheap scaling when image bigger than texture *)
  glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_NEAREST); (* cheap scaling when image smalled than texture *)

  (* 2d texture, level of detail 0 (normal), 3 components (red, green, blue), x size from image, y size from image, *)
  (* border 0 (normal), rgb color data, unsigned byte data, and finally the data itself. *)
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

  (* 2d texture, 3 colors, width, height, RGB in that order, byte data, and the data. *)
  gluBuild2DMipmaps InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;

  (texture)
;;


(* A general OpenGL initialization function.  Sets all of the initial parameters. *)
let initGL ~width ~height =  (* We call this right after our OpenGL window is created. *)

  let texture = loadGLTextures() in   (* Load the textures *)
  glEnable GL_TEXTURE_2D;             (* Enable texture mapping *)

  glClearColor 0.0 0.0 0.0 0.0;       (* This Will Clear The Background Color To Black *)
  glClearDepth 1.0;                   (* Enables Clearing Of The Depth Buffer *)
  glDepthFunc GL_LESS;                (* The Type Of Depth Test To Do *)
  glEnable GL_DEPTH_TEST;             (* Enables Depth Testing *)
  glShadeModel GL_SMOOTH;             (* Enables Smooth Color Shading *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();                   (* Reset The Projection Matrix *)
  gluPerspective 45.0 (float width /. float height) 0.1 100.0;   (* Calculate The Aspect Ratio Of The Window *)
  glMatrixMode GL_MODELVIEW;

  (* set up light number 1. *)
  glLight (GL_LIGHT 1) (Light.GL_AMBIENT  lightAmbient);   (* add lighting. (ambient) *)
  glLight (GL_LIGHT 1) (Light.GL_DIFFUSE  lightDiffuse);   (* add lighting. (diffuse). *)
  glLight (GL_LIGHT 1) (Light.GL_POSITION lightPosition);  (* set light position. *)
  glEnable GL_LIGHT1;                                      (* turn light 1 on. *)

  (* setup blending *)
  glBlendFunc Sfactor.GL_SRC_ALPHA Dfactor.GL_ONE;         (* Set The Blending Function For Translucency *)
  glColor4 1.0 1.0 1.0 0.5;

  let quadratic = gluNewQuadric() in        (* Create A Pointer To The Quadric Object ( NEW ) *)

  (* Can also use GLU_NONE, GLU_FLAT *)
  gluQuadricNormals quadratic GLU_SMOOTH;   (* Create Smooth Normals *)
  gluQuadricTexture quadratic true;         (* Create Texture Coords ( NEW ) *)

  (quadratic, texture)
;;


(* The function called when our window is resized (which shouldn't happen, because we're fullscreen) *)
let reSizeGLScene ~width ~height =
  let height =
    if height = 0                 (* Prevent A Divide By Zero If The Window Is Too Small *)
    then 1
    else height
  in

  glViewport 0 0 width height;    (* Reset The Current Viewport And Perspective Transformation *)

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();

  gluPerspective 45.0 (float width /. float height) 0.1 100.0;
  glMatrixMode GL_MODELVIEW;
;;


(* The function called whenever a key is pressed. *)
let keyPressed ~window ~key ~x ~y =
  match key with
  | 'Q'
  | 'q'
  | '\027' ->  (* kill everything. *)
      (* shut down our window *)
      glutDestroyWindow window;
    
      (* exit the program...normal termination. *)
      exit(1);                    

  | 'l'
  | 'L' ->  (* switch the lighting. *)
      Printf.printf "L/l pressed; light is: %b\n%!" !light;
      light := not !light;            (* switch the current value of light, between false and true. *)
      Printf.printf "Light is now: %b\n%!" !light;
      if !light
      then glEnable GL_LIGHTING
      else glDisable GL_LIGHTING;

  | 'F'
  | 'f' ->  (* switch the filter. *)
      Printf.printf "F/f pressed; filter is: %d\n%!" !filter;
      incr filter;
      if !filter > 2
      then filter := 0;       
      Printf.printf "Filter is now: %d\n%!" !filter;
    
  | 'b'
  | 'B' ->                            (* switch the blending. *)
      Printf.printf "B/b pressed; blending is: %b\n%!" !blend;
      blend := not !blend;            (* switch the current value of blend, between 0 and 1. *)
      Printf.printf "Blend is now: %b\n%!" !blend;
      if !blend then begin
        glEnable GL_BLEND;            (* Turn Blending On *)
        glDisable GL_DEPTH_TEST;      (* Turn Depth Testing Off *)
      end else begin
        glDisable GL_BLEND;           (* Turn Blending Off *)
        glEnable GL_DEPTH_TEST;       (* Turn Depth Testing On *)
      end

  | ' ' ->                            (* Is Spacebar Being Pressed? *)
      incr object_;                   (* Cycle Through The Objects *)
      if !object_ > 5 then            (* Is object Greater Than 5? *)
        object_ := 0;                 (* If So, Set To Zero *)

  | _ ->
      Printf.printf "Key %d pressed. No action there yet.\n%!" (Obj.magic key : int);
;;


(* The function called whenever a normal key is pressed. *)
let specialKeyPressed ~key ~x ~y =
  match key with
  | GLUT_KEY_PAGE_UP ->    (* move the cube into the distance. *)
      z -= 0.02;
    
  | GLUT_KEY_PAGE_DOWN ->  (* move the cube closer. *)
      z += 0.02;

  | GLUT_KEY_UP ->         (* decrease x rotation speed; *)
      xspeed -= 0.01;

  | GLUT_KEY_DOWN ->       (* increase x rotation speed; *)
      xspeed += 0.01;

  | GLUT_KEY_LEFT ->       (* decrease y rotation speed; *)
      yspeed -= 0.01;
    
  | GLUT_KEY_RIGHT ->      (* increase y rotation speed; *)
      yspeed += 0.01;

  | _ -> ()
;;


(* main *)
let () =
  (* Initialize GLUT state - glut will take any command line arguments that pertain to it or 
     X Windows - look at its documentation at http://reality.sgi.com/mjk/spec3/spec3.html *)  
  let _ = glutInit Sys.argv in

  (* Select type of Display mode:   
     Double buffer 
     RGBA color
     Alpha components supported (use GLUT_ALPHA)
     Depth buffer *)  
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE; GLUT_DEPTH];

  (* get a 640 x 480 window *)
  glutInitWindowSize 640 480;

  (* the window starts at the upper left corner of the screen *)
  glutInitWindowPosition 0 0;

  (* Open a window *)  
  let window = glutCreateWindow "My GL Tutorial" in

  (* Initialize our window. *)
  let quadratic, texture = initGL 640 480 in

  (* Register the function to do all our OpenGL drawing. *)
  glutDisplayFunc (drawGLScene quadratic texture);

  (* Go fullscreen.  This is as soon as possible. *)
(*  glutFullScreen(); *)

  (* Even if there are no events, redraw our gl scene. *)
  glutIdleFunc (drawGLScene quadratic texture);

  (* Register the function called when our window is resized. *)
  glutReshapeFunc (reSizeGLScene);

  (* Register the function called when the keyboard is pressed. *)
  glutKeyboardFunc (keyPressed ~window);

  (* Register the function called when special keys (arrows, page down, etc) are pressed. *)
  glutSpecialFunc (specialKeyPressed);
  
  (* Start Event Processing Engine *)  
  glutMainLoop();  
;;

