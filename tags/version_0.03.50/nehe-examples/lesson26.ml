(*  This code has been created by Banu Cosmin aka Choko - 20 may 2000
 *  and uses NeHe tutorials as a starting point (window initialization,
 *  texture loading, GL initialization and code for keypresses) - very good
 *  tutorials, Jeff. If anyone is interested about the presented algorithm
 *  please e-mail me at boct@romwest.ro
 *
 *  Code Commmenting And Clean Up By Jeff Molofee ( NeHe )
 *  NeHe Productions    ...     http://nehe.gamedev.net
 *
 *  The full tutorial associated with this file is available here:
 *  http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=25
 *)
(* Ported from C to OCaml by Florent Monnier *)

open GL                                               (* Module For The OpenGL Library *)
open Glu                                              (* Module For The GLu Library *)
open Glut                                             (* Module For The GLUT Library *)

(* Light Parameters *)
let lightAmb = (0.7, 0.7, 0.7, 1.0)                   (* Ambient Light *)
let lightDif = (1.0, 1.0, 1.0, 1.0)                   (* Diffuse Light *)
let lightPos = (4.0, 4.0, 6.0, 1.0)                   (* Light Position *)


let xrot      = ref  0.0                              (* X Rotation *)
let yrot      = ref  0.0                              (* Y Rotation *)
let xrotspeed = ref  0.0                              (* X Rotation Speed *)
let yrotspeed = ref  0.0                              (* Y Rotation Speed *)
let zoom      = ref(-7.0)                             (* Depth Into The Screen *)
let height    = ref  2.0                              (* Height Of Ball From Floor *)

let ( += ) a b = a := !a +. b
let ( -= ) a b = a := !a -. b


let reshape ~width ~height =                          (* Resize And Initialize The GL Window *)
  let height =
    if height = 0                                     (* Prevent A Divide By Zero By *)
    then 1                                            (* Making Height Equal One *)
    else height
  in
  glViewport 0 0 width height;                        (* Reset The Current Viewport *)

  glMatrixMode GL_PROJECTION;                         (* Select The Projection Matrix *)
  glLoadIdentity();                                   (* Reset The Projection Matrix *)

  (* Calculate The Aspect Ratio Of The Window *)
  gluPerspective 45.0 (float width /. float height) 0.1 100.0;

  glMatrixMode GL_MODELVIEW;                          (* Select The Modelview Matrix *)
  glLoadIdentity();                                   (* Reset The Modelview Matrix *)
;;


let loadGLTextures() =                                (* Load Bitmaps And Convert To Textures *)
  (* Load Texture *)
  let load_image filename =
    let image_data, sizeX, sizeY, _, _ = Png_loader.load_img (Filename filename) in
    (sizeX, sizeY, image_data)
  in
  let files = [|
    "Data/lesson26/Envwall.png";                      (* The Floor Texture *)
    "Data/lesson26/Ball.png";                         (* the Light Texture *)
    "Data/lesson26/Envroll.png";                      (* the Wall Texture *)
  |] in
  let img_textures = Array.map load_image files in

  let textures = glGenTextures 3 in                   (* Create 3 Textures *)

  Array.iteri (fun i (sizeX, sizeY, image_data) ->
      glBindTexture BindTex.GL_TEXTURE_2D textures.(i);
      glTexImage2D TexTarget.GL_TEXTURE_2D 0 InternalFormat.GL_RGB sizeX sizeY GL_RGB GL_UNSIGNED_BYTE image_data;
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MAG_FILTER Mag.GL_LINEAR);
      glTexParameter TexParam.GL_TEXTURE_2D (TexParam.GL_TEXTURE_MIN_FILTER Min.GL_LINEAR);
  ) img_textures;

  (textures)
;;


let initGL() =                                        (* All Setup For OpenGL Goes Here *)
  let texture = loadGLTextures() in                   (* If Loading The Textures Failed *)
  glShadeModel GL_SMOOTH;                             (* Enable Smooth Shading *)
  glClearColor 0.2 0.5 1.0 1.0;                       (* Background *)
  glClearDepth 1.0;                                   (* Depth Buffer Setup *)
  glClearStencil 0;                                   (* Clear The Stencil Buffer To 0 *)
  glEnable GL_DEPTH_TEST;                             (* Enables Depth Testing *)
  glDepthFunc GL_LEQUAL;                              (* The Type Of Depth Testing To Do *)
  glHint GL_PERSPECTIVE_CORRECTION_HINT  GL_NICEST;   (* Really Nice Perspective Calculations *)
  glEnable GL_TEXTURE_2D;                             (* Enable 2D Texture Mapping *)

  glLight (GL_LIGHT 0) (Light.GL_AMBIENT  lightAmb);  (* Set The Ambient Lighting For Light0 *)
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE  lightDif);  (* Set The Diffuse Lighting For Light0 *)
  glLight (GL_LIGHT 0) (Light.GL_POSITION lightPos);  (* Set The Position For Light0 *)

  glEnable GL_LIGHT0;                                 (* Enable Light 0 *)
  glEnable GL_LIGHTING;                               (* Enable Lighting *)

  let q = gluNewQuadric() in                          (* Create A New Quadratic For Drawing A Sphere *)
  gluQuadricNormals q GLU_SMOOTH;                     (* Generate Smooth Normals For The Quad *)
  gluQuadricTexture q true;                           (* Enable Texture Coords For The Quad *)

  glTexGen GL_S GL_TEXTURE_GEN_MODE GL_SPHERE_MAP;    (* Set Up Sphere Mapping *)
  glTexGen GL_T GL_TEXTURE_GEN_MODE GL_SPHERE_MAP;    (* Set Up Sphere Mapping *)

  (texture, q)
;;


let drawObject ~q ~texture =                          (* Draw Our Ball *)
  glColor3 1.0 1.0 1.0;                               (* Set Color To White *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(1);    (* Select Texture 2 (1) *)
  gluSphere q 0.35 32 16;                             (* Draw First Sphere *)

  glBindTexture BindTex.GL_TEXTURE_2D texture.(2);    (* Select Texture 3 (2) *)
  glColor4 1.0 1.0 1.0 0.4;                           (* Set Color To White With 40% Alpha *)
  glEnable GL_BLEND;                                  (* Enable Blending *)
  glBlendFunc Sfactor.GL_SRC_ALPHA Dfactor.GL_ONE;    (* Set Blending Mode To Mix Based On SRC Alpha *)
  glEnable GL_TEXTURE_GEN_S;                          (* Enable Sphere Mapping *)
  glEnable GL_TEXTURE_GEN_T;                          (* Enable Sphere Mapping *)

  gluSphere q 0.35 32 16;                             (* Draw Another Sphere Using New Texture *)
                                                      (* Textures Will Mix Creating A MultiTexture Effect (Reflection) *)
  glDisable GL_TEXTURE_GEN_S;                         (* Disable Sphere Mapping *)
  glDisable GL_TEXTURE_GEN_T;                         (* Disable Sphere Mapping *)
  glDisable GL_BLEND;                                 (* Disable Blending *)
;;


let drawFloor ~texture =                              (* Draws The Floor *)
  glBindTexture BindTex.GL_TEXTURE_2D texture.(0);    (* Select Texture 1 (0) *)
  glBegin GL_QUADS;                                   (* Begin Drawing A Quad *)
    glNormal3 0.0 1.0 0.0;                            (* Normal Pointing Up *)
      glTexCoord2 0.0 1.0;                            (* Bottom Left Of Texture *)
      glVertex3 (-2.0) 0.0 2.0;                       (* Bottom Left Corner Of Floor *)

      glTexCoord2 0.0 0.0;                            (* Top Left Of Texture *)
      glVertex3 (-2.0) 0.0 (-2.0);                    (* Top Left Corner Of Floor *)

      glTexCoord2 1.0 0.0;                            (* Top Right Of Texture *)
      glVertex3 2.0 0.0 (-2.0);                       (* Top Right Corner Of Floor *)

      glTexCoord2 1.0 1.0;                            (* Bottom Right Of Texture *)
      glVertex3 2.0 0.0 2.0;                          (* Bottom Right Corner Of Floor *)
  glEnd();                                            (* Done Drawing The Quad *)
;;


let display ~q ~texture () =                          (* Draw Everything *)
  (* Clear Screen, Depth Buffer & Stencil Buffer *)
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT; GL_STENCIL_BUFFER_BIT];

  (* Clip Plane Equations *)
  let eqr = [| 0.0; -1.0; 0.0; 0.0 |] in              (* Plane Equation To Use For The Reflected Objects *)

  glLoadIdentity();                                   (* Reset The Modelview Matrix *)
  glTranslate 0.0 (-0.6) !zoom;                       (* Zoom And Raise Camera Above The Floor (Up 0.6 Units) *)
  glColorMask false false false false;                (* Set Color Mask *)
  glEnable GL_STENCIL_TEST;                           (* Enable Stencil Buffer For "marking" The Floor *)
  glStencilFunc GL_ALWAYS 1 1;                        (* Always Passes, 1 Bit Plane, 1 As Mask *)
  glStencilOp GL_KEEP  GL_KEEP  GL_REPLACE;           (* We Set The Stencil Buffer To 1 Where We Draw Any Polygon *)
                                                      (* Keep If Test Fails, Keep If Test Passes But Buffer Test Fails *)
                                                      (* Replace If Test Passes *)
  glDisable GL_DEPTH_TEST;                            (* Disable Depth Testing *)
  drawFloor ~texture;                                 (* Draw The Floor (Draws To The Stencil Buffer) *)
                                                      (* We Only Want To Mark It In The Stencil Buffer *)
  glEnable GL_DEPTH_TEST;                             (* Enable Depth Testing *)
  glColorMask true true true true;                    (* Set Color Mask to true, true, true, true *)
  glStencilFunc GL_EQUAL 1 1;                         (* We Draw Only Where The Stencil Is 1 *)
                                                      (* (I.E. Where The Floor Was Drawn) *)
  glStencilOp GL_KEEP  GL_KEEP  GL_KEEP;              (* Don't Change The Stencil Buffer *)
  glEnable GL_CLIP_PLANE0;                            (* Enable Clip Plane For Removing Artifacts *)
                                                      (* (When The Object Crosses The Floor) *)
  glClipPlane Plane.GL_CLIP_PLANE0 eqr;               (* Equation For Reflected Objects *)
  glPushMatrix();                                     (* Push The Matrix Onto The Stack *)
    glScale 1.0 (-1.0) 1.0;                           (* Mirror Y Axis *)
    glLight (GL_LIGHT 0) (Light.GL_POSITION lightPos);(* Set Up Light0 *)
    glTranslate 0.0 !height 0.0;                      (* Position The Object *)
    glRotate !xrot 1.0 0.0 0.0;                       (* Rotate Local Coordinate System On X Axis *)
    glRotate !yrot 0.0 1.0 0.0;                       (* Rotate Local Coordinate System On Y Axis *)
    drawObject ~q ~texture;                           (* Draw The Sphere (Reflection) *)
  glPopMatrix();                                      (* Pop The Matrix Off The Stack *)
  glDisable GL_CLIP_PLANE0;                           (* Disable Clip Plane For Drawing The Floor *)
  glDisable GL_STENCIL_TEST;                          (* We Don't Need The Stencil Buffer Any More (Disable) *)
  glLight (GL_LIGHT 0) (Light.GL_POSITION lightPos);  (* Set Up Light0 Position *)
  glEnable GL_BLEND;                                  (* Enable Blending (Otherwise The Reflected Object Wont Show) *)
  glDisable GL_LIGHTING;                              (* Since We Use Blending, We Disable Lighting *)
  glColor4 1.0 1.0 1.0 0.8;                           (* Set Color To White With 80% Alpha *)
  glBlendFunc Sfactor.GL_SRC_ALPHA
              Dfactor.GL_ONE_MINUS_SRC_ALPHA;         (* Blending Based On Source Alpha And 1 Minus Dest Alpha *)
  drawFloor ~texture;                                 (* Draw The Floor To The Screen *)
  glEnable GL_LIGHTING;                               (* Enable Lighting *)
  glDisable GL_BLEND;                                 (* Disable Blending *)
  glTranslate 0.0 !height 0.0;                        (* Position The Ball At Proper Height *)
  glRotate !xrot 1.0 0.0 0.0;                         (* Rotate On The X Axis *)
  glRotate !yrot 0.0 1.0 0.0;                         (* Rotate On The Y Axis *)
  drawObject ~q ~texture;                             (* Draw The Ball *)
  xrot += !xrotspeed;                                 (* Update X Rotation Angle By xrotspeed *)
  yrot += !yrotspeed;                                 (* Update Y Rotation Angle By yrotspeed *)
  glFlush();                                          (* Flush The GL Pipeline *)

  glutSwapBuffers();
;;


let key ~key ~x ~y =
  begin match key with
  | '\027' | 'q' ->
      exit(0);

  | 'A' ->
      zoom += 0.05;

  | 'Z' ->
      zoom -= 0.05;
  | _ -> ()
  end;
  glutPostRedisplay();
;;


let specialKey ~key ~x ~y =
  begin match key with
  | GLUT_KEY_UP ->
      xrotspeed += 0.08;
  | GLUT_KEY_DOWN ->
      xrotspeed -= 0.08;
  | GLUT_KEY_LEFT ->
      yrotspeed -= 0.08;
  | GLUT_KEY_RIGHT ->
      yrotspeed += 0.08;
  | GLUT_KEY_PAGE_UP ->
      height += 0.03;
  | GLUT_KEY_PAGE_DOWN ->
      height -= 0.03;
  | _ -> ()
  end;
  glutPostRedisplay();
;;


(* main *)
let () =
  let _ = glutInit Sys.argv in
  glutInitWindowPosition 0 0;
  glutInitWindowSize 640 480;
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE; GLUT_DEPTH; GLUT_STENCIL];
  let _ = glutCreateWindow Sys.argv.(0) in
  let texture, q = initGL() in
  glutReshapeFunc ~reshape;
  glutKeyboardFunc (key);
  glutSpecialFunc (specialKey);
  glutDisplayFunc (display ~q ~texture);
  glutMainLoop();
;;

