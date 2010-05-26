
val get_identity_matrix: unit -> float array

val projection_matrix:
  fov:float -> aspect:float -> near:float -> far:float -> float array
(** replaces gluPerspective *)

val translation_matrix: float * float * float -> float array

val mult_matrix4: mat1:float array -> mat2:float array -> float array

val matrix_translate: matrix:float array -> float * float * float -> unit

