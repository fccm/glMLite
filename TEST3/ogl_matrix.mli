
val get_matrix4_identity: unit -> float array

val projection_matrix:
  fov:float ->
  aspect:float -> near_plane:float -> far_plane:float -> float array

val transformation_matrix: float * float * float -> float array

val mult_matrix4: mat1:float array -> mat2:float array -> float array

