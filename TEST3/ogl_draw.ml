open GL
open VertArray
open VBO

type vertex3 = float * float * float
type rgb = float * float * float

type characterised_vertices =
  | PlainColor3_Vertices3 of rgb * vertex3 array
  | Vertices3 of vertex3 array
  | RGB_Vertices3 of (rgb * vertex3) array


type shading =
  | Base of
      (GL.shader_program * GL.shader_object * GL.shader_object *
       int * int)
  | Color of
      (GL.shader_program * GL.shader_object * GL.shader_object *
       int * int * int)
  | ColorAttrib of
      (GL.shader_program * GL.shader_object * GL.shader_object *
       int * int * int)
  | ColorNormalAttrib of
      (GL.shader_program * GL.shader_object * GL.shader_object *
       int * int * int * int)

type mesh =
  VBO.vbo_id array * int * shading


(* ==== load shaders ==== *)
let compile_shaders (vertexShader, fragmentShader) =
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

  ( shaderProgram,
    vertexShaderID,
    fragmentShaderID )

let load_shaders_base shaders =
  let shaderProgram, vertexShaderID, fragmentShaderID = compile_shaders shaders in

  let uniformMatrix = glGetUniformLocation shaderProgram "ModelViewProjectionMatrix"
  and vertexPositionAttrib = glGetAttribLocation shaderProgram "VertexPosition" in

  Base
  ( shaderProgram,
    vertexShaderID,
    fragmentShaderID,
    uniformMatrix,
    vertexPositionAttrib )
;;

let load_shaders_color shaders =
  let shaderProgram, vertexShaderID, fragmentShaderID = compile_shaders shaders in

  let uniformMatrix = glGetUniformLocation shaderProgram "ModelViewProjectionMatrix"
  and vertexPositionAttrib = glGetAttribLocation shaderProgram "VertexPosition"
  and plainColorAttrib = glGetUniformLocation shaderProgram "PlainColor" in

  Color
  ( shaderProgram,
    vertexShaderID,
    fragmentShaderID,
    uniformMatrix,
    vertexPositionAttrib,
    plainColorAttrib )
;;

let load_shaders_color_attrib shaders =
  let shaderProgram, vertexShaderID, fragmentShaderID = compile_shaders shaders in

  let uniformMatrix = glGetUniformLocation shaderProgram "ModelViewProjectionMatrix"
  and vertexPositionAttrib = glGetAttribLocation shaderProgram "VertexPosition"
  and vertexColorAttrib = glGetAttribLocation shaderProgram "VertexColor" in

  ColorAttrib
  ( shaderProgram,
    vertexShaderID,
    fragmentShaderID,
    uniformMatrix,
    vertexPositionAttrib,
    vertexColorAttrib )
;;

let load_shaders_normal shaders =
  let shaderProgram, vertexShaderID, fragmentShaderID = compile_shaders shaders in

  let uniformMatrix = glGetUniformLocation shaderProgram "ModelViewProjectionMatrix"
  and vertexPositionAttrib = glGetAttribLocation shaderProgram "VertexPosition"
  and vertexNormalAttrib = glGetAttribLocation shaderProgram "VertexNormal"
  and vertexColorAttrib = glGetAttribLocation shaderProgram "VertexColor" in

  ColorNormalAttrib
  ( shaderProgram,
    vertexShaderID,
    fragmentShaderID,
    uniformMatrix,
    vertexPositionAttrib,
    vertexColorAttrib,
    vertexNormalAttrib )
;;


(* ==== make mesh ==== *)

let vertices_nb = function
  | Vertices3 data -> (Array.length data)
  | RGB_Vertices3 data -> (Array.length data)
  | PlainColor3_Vertices3(_,data) -> (Array.length data)
;;


let make_vertices_ba ba1_set = function
  | PlainColor3_Vertices3(color,data) ->
      let len = 3 * (Array.length data) in
      let vert_ba = Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout len in
      let vert_set = ba1_set vert_ba in
      Array.iteri (fun i (x,y,z) ->
        let j = i * 3 in
        vert_set (j  ) x;
        vert_set (j+1) y;
        vert_set (j+2) z;
      ) data;
      let shading =
        load_shaders_base (Shaders.plain_color3 color)
      in
      (vert_ba, shading)

  | Vertices3 data ->
      let len = 3 * (Array.length data) in
      let vert_ba = Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout len in
      let vert_set = ba1_set vert_ba in
      Array.iteri (fun i (x,y,z) ->
        let j = i * 3 in
        vert_set (j  ) x;
        vert_set (j+1) y;
        vert_set (j+2) z;
      ) data;
      let shading =
        load_shaders_color Shaders.plain_varying_color
      in
      (vert_ba, shading)

  | RGB_Vertices3 data ->
      let len = 6 * (Array.length data) in
      let vert_ba = Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout len in
      let vert_set = ba1_set vert_ba in
      Array.iteri (fun i ((r,g,b), (x,y,z)) ->
        let j = i * 6 in
        vert_set (j  ) r;    vert_set (j+3) x;
        vert_set (j+1) g;    vert_set (j+4) y;
        vert_set (j+2) b;    vert_set (j+5) z;
      ) data;
      let shading =
        load_shaders_color_attrib Shaders.interpolate_rgb
      in
      (vert_ba, shading)
;;


let make_indices_ba ~indices =
  let ndx_len = 3 * (Array.length indices) in
  let indices_ba = Bigarray.Array1.create Bigarray.int Bigarray.c_layout ndx_len in
  let ndx_set = Bigarray.Array1.unsafe_set indices_ba in
  Array.iteri (fun i (a,b,c) ->
    let j = i * 3 in
    ndx_set (j  ) a;
    ndx_set (j+1) b;
    ndx_set (j+2) c;
  ) indices;
  (indices_ba, ndx_len)


(* check if one of the indices is out of the bounds of the vertices array *)
let bounds_check ~indices ~vertices =
  let max_index = ref 0 in
  Array.iter (fun (a,b,c) ->
    let this = max a (max b c) in
    max_index := max this !max_index) indices;
  if !max_index >= (vertices_nb vertices)
  then invalid_arg "index out of bounds"


(* create the buffers and the shaders *)
let _make_mesh ba1_set ~indices ~vertices =
  let indices_ba, ndx_len = make_indices_ba ~indices in
  let vertices_ba, shading = make_vertices_ba ba1_set vertices in
  let mesh_buffers = glGenBuffers 2 in
  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  glBufferData GL_ARRAY_BUFFER (ba_sizeof vertices_ba) vertices_ba GL_STATIC_DRAW;
  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  glBufferData GL_ELEMENT_ARRAY_BUFFER (ba_sizeof indices_ba) indices_ba GL_STATIC_DRAW;
  (mesh_buffers, ndx_len, shading)
;;

let make_mesh_unsafe = _make_mesh Bigarray.Array1.unsafe_set ;;
let make_mesh ~indices ~vertices =
  bounds_check ~indices ~vertices;
  _make_mesh Bigarray.Array1.set ~indices ~vertices;
;;


(* ==== draw ==== *)
let draw_mesh world_proj_matrix ?color = function
      (mesh_buffers, ndx_len,
       ColorAttrib
       (shader_prog, _, _,
        uniformMatrix,
        vertexPositionAttrib,
        vertexColorAttrib)) ->

  if color <> None then invalid_arg "draw_mesh: color (a)";

  glUseProgram shader_prog;
  glUniformMatrix4fv uniformMatrix 1 false world_proj_matrix;

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

    | (mesh_buffers, ndx_len,
       ColorNormalAttrib
       (shader_prog, _, _,
        uniformMatrix,
        vertexPositionAttrib,
        vertexColorAttrib,
        vertexNormalAttrib)) ->

  if color <> None then invalid_arg "draw_mesh: color (b)";

  glUseProgram shader_prog;
  glUniformMatrix4fv uniformMatrix 1 false world_proj_matrix;

  glEnableVertexAttribArray vertexNormalAttrib;
  glEnableVertexAttribArray vertexColorAttrib;
  glEnableVertexAttribArray vertexPositionAttrib;

  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  glVertexAttribPointerOfs32 vertexNormalAttrib 3 VAttr.GL_FLOAT false 9 0;
  glVertexAttribPointerOfs32 vertexColorAttrib 3 VAttr.GL_FLOAT false 9 3;
  glVertexAttribPointerOfs32 vertexPositionAttrib 3 VAttr.GL_FLOAT false 9 6;

  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  glDrawElements0 GL_TRIANGLES ndx_len Elem.GL_UNSIGNED_INT;

  glDisableVertexAttribArray vertexNormalAttrib;
  glDisableVertexAttribArray vertexColorAttrib;
  glDisableVertexAttribArray vertexPositionAttrib;

  glUnuseProgram();

    | (mesh_buffers, ndx_len,
       Base
       (shader_prog, _, _,
        uniformMatrix,
        vertexPositionAttrib)) ->

  if color <> None then invalid_arg "draw_mesh: color (c)";

  glUseProgram shader_prog;
  glUniformMatrix4fv uniformMatrix 1 false world_proj_matrix;

  glEnableVertexAttribArray vertexPositionAttrib;

  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  glVertexAttribPointerOfs32 vertexPositionAttrib 3 VAttr.GL_FLOAT false 3 0;

  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  glDrawElements0 GL_TRIANGLES ndx_len Elem.GL_UNSIGNED_INT;

  glDisableVertexAttribArray vertexPositionAttrib;

  glUnuseProgram();

    | (mesh_buffers, ndx_len,
       Color
       (shader_prog, _, _,
        uniformMatrix,
        vertexPositionAttrib,
        plainColorAttrib)) ->

  let r, g, b =
    match color with
    | None -> invalid_arg "draw_mesh: color (d)"
    | Some c -> c
  in

  glUseProgram shader_prog;
  glUniformMatrix4fv uniformMatrix 1 false world_proj_matrix;
  glUniform3f plainColorAttrib r g b;

  glEnableVertexAttribArray vertexPositionAttrib;

  glBindBuffer GL_ARRAY_BUFFER mesh_buffers.(0);
  glVertexAttribPointerOfs32 vertexPositionAttrib 3 VAttr.GL_FLOAT false 3 0;

  glBindBuffer GL_ELEMENT_ARRAY_BUFFER mesh_buffers.(1);
  glDrawElements0 GL_TRIANGLES ndx_len Elem.GL_UNSIGNED_INT;

  glDisableVertexAttribArray vertexPositionAttrib;

  glUnuseProgram();
;;


(* ==== delete ==== *)
let delete_mesh = function
    | (mesh_buffers, _,
       Base
       (shaderProgram,
        vertexShaderID,
        fragmentShaderID,
        _, _))

    | (mesh_buffers, _,
       Color
       (shaderProgram,
        vertexShaderID,
        fragmentShaderID,
        _, _, _))

    | (mesh_buffers, _,
       ColorAttrib
       (shaderProgram,
        vertexShaderID,
        fragmentShaderID,
        _, _, _))

    | (mesh_buffers, _,
       ColorNormalAttrib
       (shaderProgram,
        vertexShaderID,
        fragmentShaderID,
        _, _, _, _)) ->

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

