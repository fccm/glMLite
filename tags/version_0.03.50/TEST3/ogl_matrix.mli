
val get_identity_matrix: unit -> float array

val perspective_projection:
  fov:float -> ratio:float -> near:float -> far:float -> float array
(** replaces [gluPerspective] *)

val ortho_projection: left:float -> right:float ->
  bottom:float -> top:float -> near:float -> far:float -> float array
(** replaces [glOrtho] *)

val translation_matrix: float * float * float -> float array

val mult_matrix4: mat1:float array -> mat2:float array -> float array

val matrix_translate: matrix:float array -> float * float * float -> unit

