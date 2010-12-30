(* vertex_array.ml
   ========
   tutorial about this program:
   http://www.linux-nantes.org/~fmonnier/OCaml/GL/vertex_array.php
   ========
   testing vertex array (glDrawElements, glDrawArray)
  
    AUTHOR: Song Ho Ahn (song.ahn@gmail.com)
   CREATED: 2005-10-04
   UPDATED: 2005-10-28

   OCaml version by Florent Monnier (fmonnier@linux-nantes.org)
*)

open GL
open Glu
open Glut

open VertArray

(* global variables *)
let font = GLUT_BITMAP_8_BY_13
let mouseLeftDown = ref false
let mouseRightDown = ref false
let mouseMiddleDown = ref false
let mouseX = ref 0.0
let mouseY = ref 0.0
let cameraAngleX = ref 0.0
let cameraAngleY = ref 0.0
let cameraDistance = ref 0.0
let drawMode = ref 0
let maxVertices = ref 0
let maxIndices = ref 0

let ( += ) a b = (a := !a +. b) ;;

(* function pointer to OpenGL extensions *)


(* cube
      v6----- v5
     /|      /|
    v1------v0|
    | |     | |
    | |v7---|-|v4
    |/      |/
    v2------v3
*)


(* the type Bigarray.float32 will map the datas to the OpenGL C type (GLfloat) *)

(* vertex coords array *)
let vertices = Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
              [| 1.; 1.; 1.; -1.;1.;1.;   -1.;-1.;1.;   1.;-1.;1.;    (* v0-v1-v2-v3 *)
                 1.; 1.; 1.;  1.;-1.;1.;   1.;-1.;-1.;  1.;1.;-1.;    (* v0-v3-v4-v5 *)
                 1.; 1.; 1.;  1.;1.;-1.;  -1.;1.;-1.;  -1.;1.;1.;     (* v0-v5-v6-v1 *)
                -1.; 1.; 1.; -1.;1.;-1.;  -1.;-1.;-1.; -1.;-1.;1.;    (* v1-v6-v7-v2 *)
                -1.;-1.;-1.;  1.;-1.;-1.;  1.;-1.;1.;  -1.;-1.;1.;    (* v7-v4-v3-v2 *)
                 1.;-1.;-1.; -1.;-1.;-1.; -1.;1.;-1.;   1.;1.;-1. |]  (* v4-v7-v6-v5 *)

(* normal array *)
let normals = Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
              [| 0.;0.;1.;   0.;0.;1.;  0.;0.;1.;   0.;0.;1.;         (* v0-v1-v2-v3 *)
                 1.;0.;0.;   1.;0.;0.;  1.;0.;0.;   1.;0.;0.;         (* v0-v3-v4-v5 *)
                 0.;1.;0.;   0.;1.;0.;  0.;1.;0.;   0.;1.;0.;         (* v0-v5-v6-v1 *)
                -1.;0.;0.;  -1.;0.;0.; -1.;0.;0.;  -1.;0.;0.;         (* v1-v6-v7-v2 *)
                 0.;-1.;0.;  0.;-1.;0.; 0.;-1.;0.;  0.;-1.;0.;        (* v7-v4-v3-v2 *)
                 0.;0.;-1.;  0.;0.;-1.; 0.;0.;-1.;  0.;0.;-1. |]      (* v4-v7-v6-v5 *)

(* color array *)
let colors = Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
              [| 1.;1.;1.;  1.;1.;0.;  1.;0.;0.;  1.;0.;1.;           (* v0-v1-v2-v3 *)
                 1.;1.;1.;  1.;0.;1.;  0.;0.;1.;  0.;1.;1.;           (* v0-v3-v4-v5 *)
                 1.;1.;1.;  0.;1.;1.;  0.;1.;0.;  1.;1.;0.;           (* v0-v5-v6-v1 *)
                 1.;1.;0.;  0.;1.;0.;  0.;0.;0.;  1.;0.;0.;           (* v1-v6-v7-v2 *)
                 0.;0.;0.;  0.;0.;1.;  1.;0.;1.;  1.;0.;0.;           (* v7-v4-v3-v2 *)
                 0.;0.;1.;  0.;0.;0.;  0.;1.;0.;  0.;1.;1. |]         (* v4-v7-v6-v5 *)

(* index array of vertex array for glDrawElements()
   Notice the indices are listed straight from beginning to end as exactly
   same order of vertex array without hopping, because of different normals at
   a shared vertex. For this case, glDrawArrays() and glDrawElements() have no
   difference. *)
(*
let indices = Bigarray.Array1.of_array Bigarray.int8_unsigned Bigarray.c_layout
*)
let indices = Bigarray.Array1.of_array Bigarray.int16_unsigned Bigarray.c_layout
                  [|  0;  1;  2;  3;
                      4;  5;  6;  7;
                      8;  9; 10; 11;
                     12; 13; 14; 15;
                     16; 17; 18; 19;
                     20; 21; 22; 23 |]

(* the type Bigarray.int8_unsigned will map the datas to the openGL C type (GLubyte) *)


(* draw 1, immediate mode
   54 calls = 24 glVertex3 calls + 24 glColor3 calls + 6 glNormal3 calls *)
let draw1() =
  glPushMatrix();
  glTranslate (-2.) (2.) (0.);  (* move to upper left corner *)

  glBegin GL_QUADS;

    (* face v0-v1-v2-v3 *)
    glNormal3 0. 0. 1.;
    glColor3 1. 1. 1.;    glVertex3 1. 1. 1.;
    glColor3 1. 1. 0.;    glVertex3(-1.)1. 1.;
    glColor3 1. 0. 0.;    glVertex3(-1.)(-1.)1.;
    glColor3 1. 0. 1.;    glVertex3 1.(-1.)1. ;

    (* face v0-v3-v4-v6 *)
    glNormal3 1. 0. 0.;
    glColor3 1. 1. 1.;    glVertex3 1. 1. 1.;
    glColor3 1. 0. 1.;    glVertex3 1.(-1.)1.;
    glColor3 0. 0. 1.;    glVertex3 1.(-1.)(-1.);
    glColor3 0. 1. 1.;    glVertex3 1. 1.(-1.);

    (* face v0-v5-v6-v1 *)
    glNormal3 0. 1. 0.;
    glColor3 1. 1. 1.;    glVertex3 1. 1. 1.;
    glColor3 0. 1. 1.;    glVertex3 1. 1.(-1.);
    glColor3 0. 1. 0.;    glVertex3(-1.)1.(-1.);
    glColor3 1. 1. 0.;    glVertex3(-1.)1. 1.;

    (* face  v1-v6-v7-v2 *)
    glNormal3(-1.)0. 0.;
    glColor3 1. 1. 0.;    glVertex3(-1.)1. 1.;
    glColor3 0. 1. 0.;    glVertex3(-1.)1.(-1.);
    glColor3 0. 0. 0.;    glVertex3(-1.)(-1.)(-1.);
    glColor3 1. 0. 0.;    glVertex3(-1.)(-1.)1.;

    (* face v7-v4-v3-v2 *)
    glNormal3 0.(-1.)0.;
    glColor3 0. 0. 0.;    glVertex3(-1.)(-1.)(-1.);
    glColor3 0. 0. 1.;    glVertex3 1.(-1.)(-1.);
    glColor3 1. 0. 1.;    glVertex3 1.(-1.)1.;
    glColor3 1. 0. 0.;    glVertex3(-1.)(-1.)1.;

    (* face v4-v7-v6-v5 *)
    glNormal3 0. 0.(-1.);
    glColor3 0. 0. 1.;    glVertex3 1.(-1.)(-1.);
    glColor3 0. 0. 0.;    glVertex3(-1.)(-1.)(-1.);
    glColor3 0. 1. 0.;    glVertex3(-1.)1.(-1.);
    glColor3 0. 1. 1.;    glVertex3 1. 1.(-1.);

  glEnd();

  glPopMatrix();
;;


(* draw cube at upper-right corner with glDrawArrays *)
let draw2() =
  (* enble and specify pointers to vertex arrays *)
  glEnableClientState GL_NORMAL_ARRAY;
  glEnableClientState GL_COLOR_ARRAY;
  glEnableClientState GL_VERTEX_ARRAY;
  glNormalPointer  Norm.GL_FLOAT 0 normals;
  glColorPointer 3  Color.GL_FLOAT 0 colors;
  glVertexPointer 3  Coord.GL_FLOAT 0 vertices;

  glPushMatrix();
  glTranslate 2. 2. 0.;                  (* move to upper-right *)

  glDrawArrays GL_QUADS  0  24;

  glPopMatrix();

  glDisableClientState GL_VERTEX_ARRAY;  (* disable vertex arrays *)
  glDisableClientState GL_COLOR_ARRAY;
  glDisableClientState GL_NORMAL_ARRAY;
;;


(* draw cube at bottom-left corner with glDrawElements
   In this example, glDrawElements() has no advantage over glDrawArrays(),
   because the shared vertices cannot share normals, so they must be duplicated
   once per face. Look at the index array defined earlier in this file. The
   indices are marching straight from 0 to 23 without hopping.
*)
let draw3() =
  (* enable and specify pointers to vertex arrays *)
  glEnableClientState GL_NORMAL_ARRAY;
  glEnableClientState GL_COLOR_ARRAY;
  glEnableClientState GL_VERTEX_ARRAY;
  glNormalPointer  Norm.GL_FLOAT 0 normals;
  glColorPointer 3  Color.GL_FLOAT 0 colors;
  glVertexPointer 3  Coord.GL_FLOAT 0 vertices;

  glPushMatrix();
  glTranslate (-2.) (-2.) (0.);          (* move to bottom-left *)

  (*
  glDrawElements GL_QUADS  24  Elem.GL_UNSIGNED_BYTE  indices;
  *)
  glDrawElements GL_QUADS  24  Elem.GL_UNSIGNED_SHORT  indices;

  glPopMatrix();

  glDisableClientState GL_VERTEX_ARRAY;  (* disable vertex arrays *)
  glDisableClientState GL_COLOR_ARRAY;
  glDisableClientState GL_NORMAL_ARRAY;
;;


(* draw cube at bottom-right corner with glDrawRangeElements()
   glDrawRangeElements() has two more parameters compared with glDrawElements(),
   start and end index. The values in index array must lie in between start and
   end. Note that not all vertices in range (start, end) must be referenced.
   But, if you specify a sparsely used range, it causes unnecessary process for
   many unused vertices in that range.
*)
let draw4() =
  (* enable and specify pointers to vertex arrays *)
  glEnableClientState GL_NORMAL_ARRAY;
  glEnableClientState GL_COLOR_ARRAY;
  glEnableClientState GL_VERTEX_ARRAY;
  glNormalPointer  Norm.GL_FLOAT  0 normals;
  glColorPointer 3  Color.GL_FLOAT  0 colors;
  glVertexPointer 3  Coord.GL_FLOAT  0 vertices;

  glPushMatrix();
  glTranslate (2.) (-2.) (0.);           (* move to bottom-right *)

  (* draw first half (12 elements) {0,1,2,3, 4,5,6,7, 8,9,10,11}
     tell the driver we use vertices from index 0 to index 11, which means 11-0+1 = 12 vertices
     So, the driver can prefetch an amount of 12 vertex data prior to rendering *)
  (*
  glDrawRangeElements GL_QUADS 0 11 12 Elem.GL_UNSIGNED_BYTE indices;
  *)
  glDrawRangeElements GL_QUADS 0 11 12 Elem.GL_UNSIGNED_SHORT indices;

  (* draw last half (12 elements) {12,13,14,15, 16,17,18,19, 20,21,22,23}
     tell the driver we use vertices from index 12 to index 23, which means 23-12+1 = 12 vertices
     So, the driver can prefetch an amount of 12 vertex data prior to rendering *)
  (*
  glDrawRangeElements GL_QUADS 12 23 12 Elem.GL_UNSIGNED_BYTE (Bigarray.Array1.sub indices 12 12);
  *)
  glDrawRangeElements GL_QUADS 12 23 12 Elem.GL_UNSIGNED_SHORT (Bigarray.Array1.sub indices 12 12);

  glPopMatrix();

  glDisableClientState GL_VERTEX_ARRAY;  (* disable vertex arrays *)
  glDisableClientState GL_COLOR_ARRAY;
  glDisableClientState GL_NORMAL_ARRAY;
;;



(* write 2d text using GLUT
   The projection matrix must be set to orthogonal before call this function. *)
let draw_string str x y (r,g,b,a) font =

  glPushAttrib [Attrib.GL_LIGHTING_BIT; Attrib.GL_CURRENT_BIT];  (* lighting and color mask *)
  glDisable GL_LIGHTING;             (* need to disable lighting for proper text color *)

  glColor4 r g b a;                  (* set text color *)
  glRasterPos2 (float x) (float y);  (* place text position *)

  (* loop all characters in the string *)
  let len = String.length str in
  for i = 0 to pred len do
    glutBitmapCharacter font str.[i];
  done;

  glEnable GL_LIGHTING;
  glPopAttrib();
;;



(* draw a string in 3D space *)
let draw_string_3D str (x,y,z) (r,g,b,a) font =

  glPushAttrib [Attrib.GL_LIGHTING_BIT; Attrib.GL_CURRENT_BIT]; (* lighting and color mask *)
  glDisable GL_LIGHTING;      (* need to disable lighting for proper text color *)

  glColor4 r g b a;           (* set text color *)
  glRasterPos3 x y z;         (* place text position *)

  (* loop all characters in the string *)
  let len = String.length str in
  for i = 0 to pred len do
    glutBitmapCharacter font str.[i];
  done;

  glEnable GL_LIGHTING;
  glPopAttrib();
;;




(* display info messages *)
let show_info() =

  (* backup current model-view matrix *)
  glPushMatrix();                    (* save current modelview matrix *)
  glLoadIdentity();                  (* reset modelview matrix *)

  (* set to 2D orthogonal projection *)
  glMatrixMode GL_PROJECTION;        (* switch to projection matrix *)
  glPushMatrix();                    (* save current projection matrix *)
  glLoadIdentity();                  (* reset projection matrix *)
  gluOrtho2D 0. 400. 0. 300.;        (* set to orthogonal projection *)

  let color = (1., 1., 1., 1.) in

  let str = Printf.sprintf "Max Elements Vertices: %d" !maxVertices in
  draw_string str 1 286 color font;

  let str = Printf.sprintf "Max Elements Indices: %d" !maxIndices in
  draw_string str 1 272 color font;

  (* restore projection matrix *)
  glPopMatrix();                     (* restore to previous projection matrix *)

  (* restore modelview matrix *)
  glMatrixMode GL_MODELVIEW;         (* switch to modelview matrix *)
  glPopMatrix();                     (* restore to previous modelview matrix *)
;;



(* CALLBACKS *)

let display() =
  (* clear buffer *)
  glClear[GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT; GL_STENCIL_BUFFER_BIT];

  (* save the initial ModelView matrix before modifying ModelView matrix *)
  glPushMatrix();

  (* tramsform camera *)
  glTranslate 0. 0. !cameraDistance;
  glRotate !cameraAngleX 1. 0. 0.;   (* pitch *)
  glRotate !cameraAngleY 0. 1. 0.;   (* heading *)

  draw1();        (* with immediate mode, glBegin()-glEnd() block *)
  draw2();        (* with glDrawArrays() *)
  draw3();        (* with glDrawElements() *)
  draw4();        (* with glDrawRangeElements() *)


  (* print 2D text *)
  let color = (1. , 1., 1., 1.) in

  let pos = (-4.0, 3.5, 0.0) in
  draw_string_3D "Immediate" pos color font;

  let pos = (1.0, 0.6, 0.0) in
  draw_string_3D "glDrawArrays()" pos color font;

  let pos = (-4.0, -0.8, 0.0) in
  draw_string_3D "glDrawElements()" pos color font;

  let pos = (1.0, -3.8, 0.0) in
  draw_string_3D "glDrawRangeElements()" pos color font;

  show_info();     (* print max range of glDrawRangeElements *)

  glPopMatrix();
  glutSwapBuffers();
;;



let reshape ~width:w ~height:h =

  (* set viewport to be the entire window *)
  glViewport 0 0 w h;

  (* aspect ratio of the window *)
  let aspect = (float w) /. (float h) in

  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  (* set the projection matrix,
     in other words: define the perspective view *)
  (*
  glFrustum (-.aspectRatio) aspectRatio (-1.) 1. 1. 60.;
  gluPerspective 60.0 aspectRatio 1.0 1000.0;  (* FOV, aspectRatio, nearClip, farClip *)
  *)
   
  gluPerspective ~fovy:60.0 ~aspect ~zNear:0.5 ~zFar:80.0;

  (* switch to modelview matrix in order to set scene *)
  glMatrixMode GL_MODELVIEW;
;;



let rec timer ~value:millisec =
  glutTimerFunc ~msecs:millisec ~timer ~value:millisec;
  glutPostRedisplay();
;;



let motion ~x ~y =
  if(!mouseLeftDown) then
  begin
    cameraAngleY += (float x -. !mouseX);
    cameraAngleX += (float y -. !mouseY);
    mouseX := float x;
    mouseY := float y;
  end;

  if(!mouseRightDown) then
  begin
    cameraDistance += (float y -. !mouseY) *. 0.2;
    mouseY := float y;
  end;

  glutPostRedisplay();
;;



let mouse ~button ~state ~x ~y =

  mouseX := float x;
  mouseY := float y;

  match button, state with
  | GLUT_LEFT_BUTTON, GLUT_DOWN -> mouseLeftDown := true;
  | GLUT_LEFT_BUTTON, GLUT_UP   -> mouseLeftDown := false;

  | GLUT_RIGHT_BUTTON, GLUT_DOWN -> mouseRightDown := true;
  | GLUT_RIGHT_BUTTON, GLUT_UP   -> mouseRightDown := false;

  | GLUT_MIDDLE_BUTTON, GLUT_DOWN -> mouseMiddleDown := true;
  | GLUT_MIDDLE_BUTTON, GLUT_UP   -> mouseMiddleDown := false;
  
  | _ -> ()
;;


let keyboard ~key ~x ~y =
  begin match key with
  | '\027' ->  (* ESCAPE *)
      exit 0;

  | 'D' | 'd' ->
      (* switch rendering modes (fill -> wire -> point) *)
      drawMode := (!drawMode + 1) mod 3;
      if (!drawMode = 0) then       (* fill mode *)
      begin
        glPolygonMode GL_FRONT_AND_BACK  GL_FILL;
        glEnable GL_DEPTH_TEST;
        glEnable GL_CULL_FACE;
      end
      else if (!drawMode = 1) then  (* wireframe mode *)
      begin
        glPolygonMode GL_FRONT_AND_BACK  GL_LINE;
        glDisable GL_DEPTH_TEST;
        glDisable GL_CULL_FACE;
      end
      else                          (* point mode *)
      begin
        glPolygonMode GL_FRONT_AND_BACK  GL_POINT;
        glDisable GL_DEPTH_TEST;
        glDisable GL_CULL_FACE;
      end;
  | _ -> ()
  end;

  glutPostRedisplay();
;;



(* initialize lights *)
let init_lights() =
  (* set up light colors (ambient, diffuse, specular) *)
  let lightKa = (0.2, 0.2, 0.2, 1.0)    (* ambient light *)
  and lightKd = (0.7, 0.7, 0.7, 1.0)    (* diffuse light *)
  and lightKs = (1.0, 1.0, 1.0, 1.0)    (* specular light *)
  in
  glLight (GL_LIGHT 0) (Light.GL_AMBIENT  lightKa);
  glLight (GL_LIGHT 0) (Light.GL_DIFFUSE  lightKd);
  glLight (GL_LIGHT 0) (Light.GL_SPECULAR lightKs);

  (* position the light *)
  let lightPos = (0., 0., 20., 1.) in   (* positional light *)
  glLight (GL_LIGHT 0) (Light.GL_POSITION lightPos);

  glEnable GL_LIGHT0;                       (* MUST enable each light source after configuration *)
;;



(* set camera position and lookat direction *)
let set_camera ~posX ~posY ~posZ ~targetX ~targetY ~targetZ =
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
  gluLookAt posX posY posZ  targetX targetY targetZ  0. 1. 0.; (* eye(x,y,z), focal(x,y,z), up(x,y,z) *)
;;



(* initialize GLUT for windowing *)
let initGLUT() =
  (* GLUT stuff for windowing
     initialization openGL window.
     it is called before any other GLUT routine *)
  ignore(glutInit Sys.argv);

  glutInitDisplayMode[GLUT_RGB; GLUT_DOUBLE; GLUT_DEPTH; GLUT_STENCIL];

  glutInitWindowSize 400 300;
  glutInitWindowPosition 100 100;

  (* finally, create a window with openGL context
     Window will not displayed until glutMainLoop() is called
     it returns a unique ID *)
  let handle = glutCreateWindow Sys.argv.(0) in     (* param is the title of window *)

  (* register GLUT callback functions *)
  glutDisplayFunc ~display;
  glutTimerFunc ~msecs:100 ~timer ~value:100;        (* redraw only every given millisec *)
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutMouseFunc ~mouse;
  glutMotionFunc ~motion;

  (handle)
;;



(* initialize OpenGL
   disable unused features *)
let initGL() =
  glShadeModel GL_SMOOTH;                    (* shading mathod: GL_SMOOTH or GL_FLAT *)
  glPixelStorei GL_UNPACK_ALIGNMENT  4;      (* 4-byte pixel alignment *)

  (* enable /disable features *)
  glHint GL_PERSPECTIVE_CORRECTION_HINT  GL_NICEST;
  (*
  glHint GL_LINE_SMOOTH_HINT  GL_NICEST;
  glHint GL_POLYGON_SMOOTH_HINT  GL_NICEST;
  *)
  glEnable GL_DEPTH_TEST;
  glEnable GL_LIGHTING;
  glEnable GL_TEXTURE_2D;
  glEnable GL_CULL_FACE;

   (* track material ambient and diffuse from surface color, call it before glEnable(GL_COLOR_MATERIAL) *)
  glColorMaterial GL_FRONT_AND_BACK  GL_AMBIENT_AND_DIFFUSE;
  glEnable GL_COLOR_MATERIAL;

  glClearColor 0. 0. 0. 0.;               (* background color *)
  glClearStencil 0;                       (* clear stencil buffer *)
  glClearDepth 1.0;                       (* 0 is near, 1 is far *)
  glDepthFunc GL_LEQUAL;

  init_lights();
  set_camera 0. 0. 10.  0. 0. 0.;
;;



let () =
  (* init GLUT and GL *)
  let _ = initGLUT() in
  initGL();

  (* check max of elements vertices and elements indices that your video card supports
     Use these values to determine the range of glDrawRangeElements()
     The constants are defined in glext.h *)
  maxVertices := glGetInteger1 Get.GL_MAX_ELEMENTS_VERTICES;
  maxIndices  := glGetInteger1 Get.GL_MAX_ELEMENTS_INDICES;

  (* the last GLUT call (LOOP)
     window will be shown and display callback is triggered by events
     NOTE: this call never return. *)
  glutMainLoop(); (* Start GLUT event-processing loop *)
;;


