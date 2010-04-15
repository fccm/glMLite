
type vertex3 = float * float * float
type rgb = float * float * float

type defined_vertices =
  | RGB_Vertices3 of (rgb * vertex3) array

type mesh

val make_mesh_unsafe:
  indices:(int * int * int) array ->
  vertices:defined_vertices ->
  mesh

val make_mesh:
  indices:(int * int * int) array ->
  vertices:defined_vertices ->
  mesh

val draw_mesh: float array -> mesh -> unit

val delete_mesh: mesh -> unit

val tris_of_quads:
  (int * int * int * int) array ->
  (int * int * int) array

