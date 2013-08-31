open GL
open Glu
open Glut
open VertArray
open VBO

let vertexData =
  Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
      [|  0.0;  1.0; 0.0;
         -1.0; -1.0; 0.0;
          1.0; -1.0; 0.0; |]

let colourData =
  Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout
      [| 0.0; 0.0; 1.0;
         0.0; 1.0; 1.0;
         1.0; 0.5; 0.0; |]


let display (vertexBuffer, colourBuffer) = function () ->

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
  glTranslate 0. 0. (-5.0);

  glEnableClientState GL_VERTEX_ARRAY;
  glEnableClientState GL_COLOR_ARRAY;           (* --- VBO's in action. *)

    glBindBuffer GL_ARRAY_BUFFER vertexBuffer;  (* Set the vertexBuffer as the current buffer. *)
    begin
      (* update data *)
      let now = Unix.gettimeofday() in
      vertexData.{0} <- (cos (now /. 2.0));
      glBufferData GL_ARRAY_BUFFER (ba_sizeof vertexData) vertexData GL_DYNAMIC_DRAW;
    end;
    glVertexPointer0 3 Coord.GL_FLOAT 0;        (* Specify that its data is vertex data. *)

    glBindBuffer GL_ARRAY_BUFFER colourBuffer;  (* Set the colourBuffer as the current buffer. *)
    glColorPointer0 3 Color.GL_FLOAT 0;         (* Specify that its data is colour data. *)

    glDrawArrays GL_TRIANGLE_STRIP 0 3;         (* Tell OpenGL to draw what it sees. ;) *)

  glDisableClientState GL_VERTEX_ARRAY;         (* --- End VBO's in action. *)
  glDisableClientState GL_COLOR_ARRAY;

  glUnbindBuffer GL_ARRAY_BUFFER;

  glutSwapBuffers();
  glutPostRedisplay();
;;
 

let ini_gl() =
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  gluPerspective 45.0 (640.0 /. 480.0) 1.0 512.0;
  glClearColor 0.0 0.0 0.0 1.0;

  (* 1. Generate a buffer name for our vertex buffer, *)
  let vertexBuffer = glGenBuffer() in

  (* 2. Set our current 'in-use' buffer to our vertex buffer. *)
  glBindBuffer GL_ARRAY_BUFFER vertexBuffer;

  (* 3. Fill out the data buffer using our initialized values. *)
  glBufferData GL_ARRAY_BUFFER (ba_sizeof vertexData) vertexData GL_DYNAMIC_DRAW;

  (* Same as steps 1, 2 and 3 above, but using colour data. *)
  let colourBuffer = glGenBuffer() in
  glBindBuffer GL_ARRAY_BUFFER colourBuffer;
  glBufferData GL_ARRAY_BUFFER (ba_sizeof colourData) colourData GL_STATIC_DRAW;
  
  (vertexBuffer, colourBuffer)
;;


let keyboard (vertexBuffer, colourBuffer) = fun ~key ~x ~y ->
  match key with
  | '\027' ->
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

