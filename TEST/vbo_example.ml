(* Vertex Buffer Objects (herein after referred to as VBOs) demo.
   Author: Eddie Parker
   This demo is a really simple example of how to use VBOs.
  
   Why would you use VBOs? Because the data is uploaded an manipulated
   on the graphics card RAM instead of system RAM, therefore it's faster,
   and doesn't clog up your BUS, and keeps your whites whiter. *)
open GL
open Glu
open Glut
open VertArray
open VBO

let ba0 = Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout 0 ;;


let display (vertexBuffer, colourBuffer) = function () ->

  (* Clear our depth buffer and color bit *)
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  (* Reset our view *)
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();

  (* Move back a bit to see our triangle in it's glory. *)
  glTranslate 0. 0. (-5.0);

  (* --- VBO's in action. *)
  (* Set the vertexBuffer as the current buffer. *)
  glBindBuffer GL_ARRAY_BUFFER vertexBuffer;

  (* Specify that its data is vertex data. *)
  (* glVertexPointer 3 Coord.GL_FLOAT 0 ba0; *)
  glVertexPointer0 3 Coord.GL_FLOAT 0;

  (* Set the colourBuffer as the current buffer. *)
  glBindBuffer GL_ARRAY_BUFFER colourBuffer;

  (* Specify that its data is colour data. *)
  (* glColorPointer 3 Color.GL_FLOAT 0 ba0; *)
  glColorPointer0 3 Color.GL_FLOAT 0;

  (* Tell OpenGL to draw what it sees. ;) *)
  glDrawArrays GL_TRIANGLE_STRIP 0 3;
  (* --- End VBO's in action. *)

  (* Swap buffers! *)
  glutSwapBuffers();
;;
 

let ini_gl() =
  (* Set up OpenGL *)
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 45.0 (640.0 /. 480.0) 1.0 512.0;
  glClearColor 0.0 0.0 0.0 1.0;

  (* Set up a purdy triangle as our vertex data. *)
  let vertexData =
    Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
        [|  0.0;  1.0; 0.0;
           -1.0; -1.0; 0.0;
            1.0; -1.0; 0.0; |] in

  (* Set a lovely teal with some Gouraud shading for our triangle. *)
  let colourData =
    Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
        [| 0.0; 0.0; 1.0;
           0.0; 1.0; 1.0;
           1.0; 1.0; 1.0; |] in

  (* 1.- Generated a buffer name for our vertex buffer, *)
  let vertexBuffer = glGenBuffer() in

  (* 2.- Set our current 'in-use' buffer to our vertex buffer. *)
  glBindBuffer GL_ARRAY_BUFFER vertexBuffer;

  (* 3.- Fill out the data buffer using our initialized values. *)
  glBufferData GL_ARRAY_BUFFER (ba_sizeof vertexData) vertexData GL_STATIC_DRAW;

  (* Same as steps 1, 2 and 3 above, but using colour data. *)
  let colourBuffer = glGenBuffer() in
  glBindBuffer GL_ARRAY_BUFFER colourBuffer;
  glBufferData GL_ARRAY_BUFFER (ba_sizeof colourData) colourData GL_STATIC_DRAW;
  
  (* Initialize the ability to use vertex arrays and colour arrays. *)
  (* I should really be making sure I have this capability and use *)
  (* glIsEnabled first. *)
  glEnableClientState GL_VERTEX_ARRAY;
  glEnableClientState GL_COLOR_ARRAY;

  (vertexBuffer, colourBuffer)
;;


let keyboard (vertexBuffer, colourBuffer) = fun ~key ~x ~y ->
  match key with
  | '\027' ->  (* Escape *)

      (* Disable the client states. *)
      glDisableClientState GL_VERTEX_ARRAY;
      glDisableClientState GL_COLOR_ARRAY;

      (* Free the buffers created in glBufferData *)
      glDeleteBuffer vertexBuffer;
      glDeleteBuffer colourBuffer;

      exit(0);

  | _ -> ()
;;

let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGB; GLUT_DEPTH; GLUT_DOUBLE];
  glutInitWindowSize 640 480;
  ignore(glutCreateWindow "VBO demo");

  let buffers = ini_gl() in

  glutDisplayFunc ~display:(display buffers);
  glutKeyboardFunc ~keyboard:(keyboard buffers);
  glutMainLoop();
;;

