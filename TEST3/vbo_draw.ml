open GL
open VertArray
open VBO

type vertex3 = float * float * float
type rgb = float * float * float

type defined_vertices =
  | RGB_Vertices3 of (rgb * vertex3) array

type mesh =
  VBO.vbo_id array * (GL.shader_program * int * int * int *
                      GL.shader_object * GL.shader_object)


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
  and vertexPositionLocation = glGetAttribLocation shaderProgram "VertexPosition"
  and vertexColorLocation = glGetAttribLocation shaderProgram "VertexColor" in

  ( shaderProgram,
    uniformMatrix,
    vertexPositionLocation,
    vertexColorLocation,
    vertexShaderID,
    fragmentShaderID )
;;


let vertexShader_interRGB = "
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

let fragmentShader_interRGB = "
#version 130
precision highp float;
smooth in vec3 InterpolatedColor;
out vec4 Color;
void main() {
  Color = vec4 (InterpolatedColor, 1.0);
}"


let make_mesh ba1_set ~indices ~vertices =
  let ndx_len = 3 * (Array.length indices) in
  let indices_ba = Bigarray.Array1.create Bigarray.int Bigarray.c_layout ndx_len in
  let ndx_set = Bigarray.Array1.unsafe_set indices_ba in
  Array.iteri (fun i (a,b,c) ->
    let j = i * 3 in
    ndx_set (j  ) a;
    ndx_set (j+1) b;
    ndx_set (j+2) c;
  ) indices;
  let vertices_ba, shading =
    match vertices with
    | RGB_Vertices3 data ->
        let len = 6 * (Array.length data) in
        let vert_ba = Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout len in
        let vert_set = ba1_set vert_ba in
        Array.iteri (fun i ((r,g,b), (x,y,z)) ->
          let j = i * 6 in
          vert_set (j  ) r;
          vert_set (j+1) g;
          vert_set (j+2) b;
          vert_set (j+3) x;
          vert_set (j+4) y;
          vert_set (j+5) z;
        ) data;
        let shading =
          load_shaders vertexShader_interRGB
                       fragmentShader_interRGB
        in
        (vert_ba, shading)
  in
  let mesh_buffers = glGenBuffers 2 in
  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  glBufferData GL_ARRAY_BUFFER (ba_sizeof vertices_ba) vertices_ba GL_STATIC_DRAW;
  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  glBufferData GL_ELEMENT_ARRAY_BUFFER (ba_sizeof indices_ba) indices_ba GL_STATIC_DRAW;
  (mesh_buffers, shading)
;;

let make_mesh_unsafe = make_mesh Bigarray.Array1.unsafe_set ;;
let make_mesh = make_mesh Bigarray.Array1.set ;;


let draw_mesh world_proj_matrix
      (mesh_buffers,
       (shader_prog,
        uniformID,
        vertexPositionAttrib,
        vertexColorAttrib, _, _)) =

  glUseProgram shader_prog;
  glUniformMatrix4fv uniformID 1 false world_proj_matrix;

  (* activate the 2 generic arrays *)
  glEnableVertexAttribArray vertexPositionAttrib;
  glEnableVertexAttribArray vertexColorAttrib;

  (* bind the vertices buffer *)
  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  (* and link the buffer data with the shader program *)
  glVertexAttribPointerOfs32 vertexColorAttrib 3 Color.GL_FLOAT false (4 * 6) 0;
  glVertexAttribPointerOfs32 vertexPositionAttrib 3 Color.GL_FLOAT false (4 * 6) 3;

  (* active the indices buffer *)
  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  (* and render the mesh *)
  glDrawElements0 GL_TRIANGLES 36 Elem.GL_UNSIGNED_INT;

  (* desactivate the generique arrays *)
  glDisableVertexAttribArray vertexPositionAttrib;
  glDisableVertexAttribArray vertexColorAttrib;

  glUnuseProgram();
;;

let delete_mesh
      (mesh_buffers,
       (shaderProgram,
        _, _, _,
        vertexShaderID,
        fragmentShaderID)) =

  glDeleteShader vertexShaderID;
  glDeleteShader fragmentShaderID;

  glDeleteProgram shaderProgram;

  glDeleteBuffers mesh_buffers;
;;

let tris_of_quads indices =
  let len = 2 * (Array.length indices) in
  Array.init len (fun i ->
    let a,b,c,d = indices.(i/2) in
    if (i mod 2) = 0
    then (a,b,c)
    else (c,d,a))
;;

