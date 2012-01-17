(* Using some basic middleware to simplify the use of OpenGL 3.X *)

open GL
open Glut
open Ogl_draw
open Ogl_matrix

let msecs = 5000  (* display fps every 5 seconds *)

(* product of the modelview (world) matrix and the projection matrix *)
let worldViewProjectionMatrix = ref [| |]

let cubeArray =
  RGB_Vertices3 [|
    (* RGB colors *) (* XYZ coords *)
    (0.0, 1.0, 0.0), (-1.0,  1.0, -1.0);
    (0.0, 0.0, 0.0), (-1.0, -1.0, -1.0);
    (1.0, 1.0, 0.0), (-1.0,  1.0,  1.0);
    (1.0, 0.0, 0.0), (-1.0, -1.0,  1.0);
    (1.0, 1.0, 1.0), ( 1.0,  1.0,  1.0);
    (1.0, 0.0, 1.0), ( 1.0, -1.0,  1.0);
    (0.0, 1.0, 1.0), ( 1.0,  1.0, -1.0);
    (0.0, 0.0, 1.0), ( 1.0, -1.0, -1.0);
  |]

let indiceArray =
  tris_of_quads [|
    (0,1,3,2);
    (4,5,7,6);
    (3,1,7,5);
    (0,2,4,6);
    (6,7,1,0);
    (2,3,5,4);
  |]


let reshape ~width ~height =
  let height = max height 1 in
  glViewport 0 0 width height;
  let ratio = float width /. float height in

  (* creation of the matrices *)
  let projectionMatrix = perspective_projection 60.0 ratio 1.0 50.0 in
  let worldMatrix = Ogl_matrix.get_identity() in
  matrix_translate worldMatrix (0.0, 0.0, -6.0);
  worldViewProjectionMatrix := mult_matrix projectionMatrix worldMatrix;
;;


let frame_count = ref 0

let display mesh_with_shaders = function () ->
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  let now = Unix.gettimeofday() in
  let x = cos now
  and y = sin now in

  let rotation = Quaternions.quaternion_of_axis (0.0, x, y) (now *. 0.8) in
  let m = Quaternions.matrix_of_quaternion rotation in
  let my_mat = mult_matrix !worldViewProjectionMatrix m in

  draw_mesh my_mat mesh_with_shaders;

  incr frame_count;
  glutSwapBuffers();
;;


let keyboard mesh_with_shaders ~key ~x ~y =
  if key = '\027' then (delete_mesh mesh_with_shaders; exit 0);
;;


let last_time = ref(Unix.gettimeofday())

let rec timer ~value:msecs =
  glutTimerFunc ~msecs ~timer ~value:msecs;
  let now = Unix.gettimeofday() in
  let diff = (now -. !last_time) in
  Printf.printf " %d frames in %f seconds \t fps: %g\n%!"
                !frame_count diff (float !frame_count /. diff);
  frame_count := 0;
  last_time := now;
;;


let init_OpenGL ~width ~height =
  reshape ~width ~height;

  glEnable GL_DEPTH_TEST;
  glPolygonMode GL_FRONT GL_FILL;
  glFrontFace GL_CCW;    (* assume a clean model *)
  glEnable GL_CULL_FACE; (* activate elimination of polygons *)
  glCullFace GL_BACK;    (* remove back side of polygons *)
;;


(* main *)
let () =
  let width = 800 and height = 600 in
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE; GLUT_DEPTH];
  glutInitWindowPosition ~x:100 ~y:100;
  glutInitWindowSize ~width ~height;
  ignore(glutCreateWindow ~title:"VBO with OpenGL 3.X");

  init_OpenGL ~width ~height;

  (* make a mesh ready to be drawn *)
  let mesh_with_shaders = make_mesh indiceArray cubeArray in

  glutDisplayFunc ~display:(display mesh_with_shaders);
  glutKeyboardFunc ~keyboard:(keyboard mesh_with_shaders);
  glutIdleFunc ~idle:glutPostRedisplay;
  glutTimerFunc ~msecs ~timer ~value:msecs;

  glutMainLoop();
;;

