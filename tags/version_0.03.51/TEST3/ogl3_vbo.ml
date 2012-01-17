(* Using VBO's with OpenGL 3.X *)
(* The code of this file was converted and adapted from C to OCaml
   from a tutorial by Michael Gallego, which is there :
   http://bakura.developpez.com/tutoriels/jeux/utilisation-vbo-avec-opengl-3-x/
   You can reuse this code (with Ogl_matrix) without restrictions.
*)

open GL          (* the base functions of OpenGL *)
open VertArray   (* Vertex-Array, needed by VBO, VBO are build on top of VA's *)
open VBO         (* Vertex Buffer Object, the most efficient drawing method
                                   and the base drawing method in OpenGL 3.X *)
open Glut        (* windowing with Glut *)
open Ogl_matrix  (* matrix utils, in OGL 3 the user has to manage it himself *)


let msecs = 5000  (* print fps every 5 seconds *)

(* product of the modelview (world) matrix and the projection matrix *)
let worldViewProjectionMatrix = ref [| |]


let cube_vertices =
  Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout [|
    (* RGB colors *)  (* XYZ coords *)
    0.0; 1.0; 0.0;    -1.0;  1.0; -1.0;
    0.0; 0.0; 0.0;    -1.0; -1.0; -1.0;
    1.0; 1.0; 0.0;    -1.0;  1.0;  1.0;
    1.0; 0.0; 0.0;    -1.0; -1.0;  1.0;
    1.0; 1.0; 1.0;     1.0;  1.0;  1.0;
    1.0; 0.0; 1.0;     1.0; -1.0;  1.0;
    0.0; 1.0; 1.0;     1.0;  1.0; -1.0;
    0.0; 0.0; 1.0;     1.0; -1.0; -1.0;
  |]

let cube_indices =
  Bigarray.Array1.of_array Bigarray.int32 Bigarray.c_layout (
    Array.map Int32.of_int [|
      (* 6 squares, each square made of 2 triangles,
         quad faces don't exist anymore in OGL 3.X *)
      0;1;3;  3;2;0;
      4;5;7;  7;6;4;
      3;1;7;  7;5;3;
      0;2;4;  4;6;0;
      6;7;1;  1;0;6;
      2;3;5;  5;4;2;
    |]
  )


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

let display
      (mesh_buffers, ndx_len,
       (shader_prog,
        uniformID,
        vertexPositionAttrib,
        vertexColorAttrib, _, _)) = function () ->

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  let now = Unix.gettimeofday() in
  let x = cos now
  and y = sin now in

  let rotation = Quaternions.quaternion_of_axis (0.0, x, y) (now *. 0.8) in
  let m = Quaternions.matrix_of_quaternion rotation in
  let world_proj_matrix = mult_matrix !worldViewProjectionMatrix m in

  glUseProgram shader_prog;
  glUniformMatrix4fv uniformID 1 false world_proj_matrix;

  (* activate the 2 generic arrays *)
  glEnableVertexAttribArray vertexColorAttrib;
  glEnableVertexAttribArray vertexPositionAttrib;

  (* bind the vertices buffer *)
  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  (* and link the buffer data with the shader program *)
  glVertexAttribPointerOfs32 vertexColorAttrib 3 VAttr.GL_FLOAT false 6 0;
  glVertexAttribPointerOfs32 vertexPositionAttrib 3 VAttr.GL_FLOAT false 6 3;

  (* active the indices buffer *)
  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  (* and render the mesh *)
  glDrawElements0 GL_TRIANGLES ndx_len Elem.GL_UNSIGNED_INT;

  (* desactivate the generique arrays *)
  glDisableVertexAttribArray vertexColorAttrib;
  glDisableVertexAttribArray vertexPositionAttrib;

  glUnuseProgram();

  incr frame_count;
  glutSwapBuffers();
;;


let delete_mesh
      (mesh_buffers, _,
       (shaderProgram,
        _, _, _,
        vertexShaderID,
        fragmentShaderID)) =

  glDeleteShader vertexShaderID;
  glDeleteShader fragmentShaderID;
  glDeleteProgram shaderProgram;
  glDeleteBuffers mesh_buffers;
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



let vertex_shader = "
#version 130
in vec3 VertexColor;
in vec3 VertexPosition;
uniform mat4 ModelViewProjectionMatrix;
invariant gl_Position;
smooth out vec3 InterpolatedColor;

void main () {
    InterpolatedColor = VertexColor;
    gl_Position = ModelViewProjectionMatrix * vec4 (VertexPosition, 1.0);
}"

let fragment_shader = "
#version 130
precision highp float;
smooth in vec3 InterpolatedColor;
out vec4 Color;
void main() {
    Color = vec4 (InterpolatedColor, 1.0);
}"


let load_shaders vertexShader fragmentShader =
  let vertexShaderID = glCreateShader GL_VERTEX_SHADER in
  let fragmentShaderID = glCreateShader GL_FRAGMENT_SHADER in

  glShaderSource vertexShaderID vertexShader;
  glShaderSource fragmentShaderID fragmentShader;

  glCompileShader vertexShaderID;
  glCompileShader fragmentShaderID;

  glGetShaderCompileStatus_exn vertexShaderID;
  glGetShaderCompileStatus_exn fragmentShaderID;

  let shaderProgram = glCreateProgram () in
  glAttachShader shaderProgram vertexShaderID;
  glAttachShader shaderProgram fragmentShaderID;

  glLinkProgram shaderProgram;

  let uniformMatrix = glGetUniformLocation shaderProgram "ModelViewProjectionMatrix"
  and vertexPositionAttrib = glGetAttribLocation shaderProgram "VertexPosition"
  and vertexColorAttrib = glGetAttribLocation shaderProgram "VertexColor" in

  ( shaderProgram,
    uniformMatrix,
    vertexPositionAttrib,
    vertexColorAttrib,
    vertexShaderID,
    fragmentShaderID )
;;


let make_mesh ~indices:ba_indices ~vertices:ba_vertices =
  let ndx_len = Bigarray.Array1.dim ba_indices in
  let shading = load_shaders vertex_shader fragment_shader in
  let mesh_buffers = glGenBuffers 2 in
  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  glBufferData GL_ARRAY_BUFFER (ba_sizeof ba_vertices) ba_vertices GL_STATIC_DRAW;
  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  glBufferData GL_ELEMENT_ARRAY_BUFFER (ba_sizeof ba_indices) ba_indices GL_STATIC_DRAW;
  (mesh_buffers, ndx_len, shading)
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
  let mesh_with_shaders = make_mesh cube_indices cube_vertices in

  glutDisplayFunc ~display:(display mesh_with_shaders);
  glutKeyboardFunc ~keyboard:(keyboard mesh_with_shaders);
  glutIdleFunc ~idle:glutPostRedisplay;
  glutTimerFunc ~msecs ~timer ~value:msecs;

  glutMainLoop();
;;

