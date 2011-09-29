(*
  Copyright (C) 2010 Florent Monnier

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.
*)
(** a module to manage opengl matrices *)

(** matrices handling by opengl is now deprecated,
    programmers are now supposed to handle matrices themselves,
    so here is a module to do so *)

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

