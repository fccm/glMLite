
type vertex3 = float * float * float
type rgb = float * float * float
type uv = float * float

type characterised_vertices =
  | PlainColor3_Vertices3 of rgb * (vertex3 array)
  | Vertices3 of vertex3 array
  | RGB_Vertices3 of (rgb * vertex3) array
  | UV_Vertices3 of (uv * vertex3) array
  | UV_RGB_Vertices3 of (uv * rgb * vertex3) array

type mesh

val make_mesh_unsafe:
  indices:(int * int * int) array ->
  vertices:characterised_vertices ->
  mesh

val make_mesh:
  indices:(int * int * int) array ->
  vertices:characterised_vertices ->
  mesh

type texenv =
  | MODULATE
  (** multiply texture color and vertex color, the result is a nice mix *)
  | DECAL
  (** in the transparent part of the texture, use the vertex color *)
  | ADD
  | ADD_SIGNED
  | SUBTRACT

val draw_mesh: float array -> ?color:rgb -> ?texenv:texenv -> mesh -> unit
(** The first parameter is the product of the modelview matrix and the
    projection matrix. You can create these matrices with the module
    {!Ogl_matrix}.
    @param color provide this parameter only with [Vertices3] data.
    @param texenv provide this parameter only with [UV_RGB_Vertices3] data
    where it is used to select how to mix the vertex color with the texture
    texel.
*)

val delete_mesh: mesh -> unit

val tris_of_quads:
  (int * int * int * int) array ->
  (int * int * int) array

type face = Tri of (int * int * int) | Quad of (int * int * int * int)

val tris_of_mixed:
  face array -> (int * int * int) array

