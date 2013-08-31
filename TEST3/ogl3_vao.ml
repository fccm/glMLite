(* by Michael Gallego, from tutorial:
http://bakura.developpez.com/tutoriels/jeux/utilisation-vertex-array-objects-avec-opengl-3-x/
converted from C to OCaml by Florent Monnier
*)
open GL
open Glut
open VertArray
open VBO
open Ogl_matrix

(* product of the modelview (world) matrix and the projection matrix *)
let worldViewProjectionMatrix = ref [| |]

let cubeArray =
  Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout [|
    (* Color RGB *) (* coords XYZ *)
    0.0; 1.0; 0.0;  -1.0;  1.0; -1.0;
    0.0; 0.0; 0.0;  -1.0; -1.0; -1.0;
    1.0; 1.0; 0.0;  -1.0;  1.0;  1.0;
    1.0; 0.0; 0.0;  -1.0; -1.0;  1.0;
    1.0; 1.0; 1.0;   1.0;  1.0;  1.0;
    1.0; 0.0; 1.0;   1.0; -1.0;  1.0;
    0.0; 1.0; 1.0;   1.0;  1.0; -1.0;
    0.0; 0.0; 1.0;   1.0; -1.0; -1.0;
  |]

(* indices of the vertices *)
let indiceArray =
  Bigarray.Array1.of_array Bigarray.int32 Bigarray.c_layout (
    Array.map Int32.of_int [|
    (* two triangles for each face of the cube *)
      0; 1; 2;  2; 1; 3;
      4; 5; 6;  6; 5; 7;
      3; 1; 5;  5; 1; 7;
      0; 2; 6;  6; 2; 4;
      6; 7; 0;  0; 7; 1;
      2; 3; 4;  4; 3; 5;
    |]
  )


let reshape ~width ~height =
  glViewport 0 0 width height;
  let height = max height 1 in
  let ratio = float width /. float height in
  let projectionMatrix = perspective_projection 60.0 ratio 1.0 50.0 in
  let worldMatrix = Ogl_matrix.get_identity() in
  matrix_translate worldMatrix (0.0, 0.0, -6.0);
  worldViewProjectionMatrix := mult_matrix projectionMatrix worldMatrix;
;;


let init_OpenGL ~width ~height =
  reshape ~width ~height;

  glEnable GL_DEPTH_TEST;
;;


let vertexShader = "
#version 130

// Attributs
in vec3 VertexColor;
in vec3 VertexPosition;

// Uniform
uniform mat4 ModelViewProjectionMatrix;

// gl_Position declared invariant
invariant gl_Position;

// interpolated color, provided to the fragment shader
smooth out vec3 InterpolatedColor;

void main ()
{
    InterpolatedColor = VertexColor;
    gl_Position = ModelViewProjectionMatrix * vec4 (VertexPosition, 1.0);
}"

let fragmentShader = "
#version 130

precision highp float;

smooth in vec3 InterpolatedColor;

// output of the fragment shader, will go into the main framebuffer
out vec4 Color;

void main()
{
    Color = vec4 (InterpolatedColor, 1.0);
}"

let load_shaders () =
  let vertexShaderID = glCreateShader GL_VERTEX_SHADER in
  let fragmentShaderID = glCreateShader GL_FRAGMENT_SHADER in
  
  glShaderSource vertexShaderID vertexShader;
  glShaderSource fragmentShaderID fragmentShader;

  glCompileShader vertexShaderID;
  glCompileShader fragmentShaderID;
  
  (* check that the shaders have been compiled right *)
  glGetShaderCompileStatus_exn vertexShaderID;
  glGetShaderCompileStatus_exn fragmentShaderID;

  (* create the program *)
  let shaderProgram = glCreateProgram () in
  glAttachShader shaderProgram vertexShaderID;
  glAttachShader shaderProgram fragmentShaderID;

  glLinkProgram shaderProgram;
  
  (* get the location of the uniform variable inside the shader *)
  let uniformID = glGetUniformLocation shaderProgram "ModelViewProjectionMatrix" in

  (* get the location of the 2 attributes inside the shader *)
  let vertexPositionAttrib = glGetAttribLocation shaderProgram "VertexPosition"
  and vertexColorAttrib = glGetAttribLocation shaderProgram "VertexColor" in

  (shaderProgram,
   uniformID,
   vertexPositionAttrib,
   vertexColorAttrib)
;;


let create_buffers () =
  let cubeBuffers = glGenBuffers 2 in

  glBindBuffer GL_ARRAY_BUFFER cubeBuffers.(0);
  glBufferData GL_ARRAY_BUFFER (ba_sizeof cubeArray) cubeArray GL_STATIC_DRAW;

  glBindBuffer GL_ELEMENT_ARRAY_BUFFER cubeBuffers.(1);
  glBufferData GL_ELEMENT_ARRAY_BUFFER (ba_sizeof indiceArray) indiceArray GL_STATIC_DRAW;

  (cubeBuffers)
;;


let create_vao cubeBuffers
      (_, _,
       vertexPositionAttrib,
       vertexColorAttrib) =

  let vertexArrayObject = glGenVertexArray() in

  glBindVertexArray vertexArrayObject;

  glEnableVertexAttribArray vertexPositionAttrib;
  glEnableVertexAttribArray vertexColorAttrib;
      
  glBindBuffer GL_ARRAY_BUFFER cubeBuffers.(0);

  (* link the data *)
  glVertexAttribPointerOfs32 vertexColorAttrib 3 VAttr.GL_FLOAT false 6 0;
  glVertexAttribPointerOfs32 vertexPositionAttrib 3 VAttr.GL_FLOAT false 6 3;

  (* activate the buffer of the indices *)
  glBindBuffer GL_ELEMENT_ARRAY_BUFFER cubeBuffers.(1);

  glBindVertexArray 0;

  (vertexArrayObject)
;;


let clean cubeBuffers vertexArrayObject (shaderProgram,_,_,_) =
  glDeleteProgram shaderProgram;
  glDeleteBuffers cubeBuffers;
  glDeleteVertexArray vertexArrayObject;
;;


let display vertexArrayObject
      (shaderProgram, uniformID,
       vertexPositionAttrib,
       vertexColorAttrib) = function () ->

  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];

  let now = Unix.gettimeofday() in
  let rotation = Quaternions.quaternion_of_axis (0.0, 1.0, 0.0) (now *. 0.8) in
  let m = Quaternions.matrix_of_quaternion rotation in
  let my_mat = mult_matrix !worldViewProjectionMatrix m in

  glUseProgram shaderProgram;
  glUniformMatrix4fv uniformID 1 false my_mat;
  glBindVertexArray vertexArrayObject;

  (* use:
   *  GL_UNSIGNED_BYTE  if indiceArray is of type  Bigarray.int8_unsigned
   *  GL_UNSIGNED_SHORT if indiceArray is of type  Bigarray.int16_unsigned
   *  GL_UNSIGNED_INT   if indiceArray is of type  Bigarray.int32
   *)
  glDrawElements0 GL_TRIANGLES 36 Elem.GL_UNSIGNED_INT;
  (*
   * Warning: Do not use Bigarray.int because it is not portable!
   *)

  glBindVertexArray 0;
  glUnuseProgram();

  glutSwapBuffers();
;;



(* main *)
let () =
  let width = 800 and height = 600 in
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE; GLUT_DEPTH];
  glutInitWindowPosition ~x:100 ~y:100;
  glutInitWindowSize ~width ~height;
  ignore(glutCreateWindow ~title:"Vertex Array Objects with OpenGL 3.X");

  init_OpenGL ~width ~height;

  let shading = load_shaders () in
  let cubeBuffers = create_buffers () in
  let vao = create_vao cubeBuffers shading in

  glutDisplayFunc ~display:(display vao shading);
  glutKeyboardFunc ~keyboard:(fun ~key ~x ~y -> if key = '\027' then exit 0);
  glutReshapeFunc ~reshape;
  let msecs = 20 in  (* 50 fps *)
  let rec timer ~value:msecs =
    glutPostRedisplay();
    glutTimerFunc ~msecs ~timer ~value:msecs;
  in
  glutTimerFunc ~msecs ~timer ~value:msecs;
  glutMainLoop();

  (* clean everything *)
  clean cubeBuffers vao shading;
;;

