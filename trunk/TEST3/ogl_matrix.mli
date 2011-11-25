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

type t = float array

val get_identity: unit -> t


(** {3 projection matrices} *)

val perspective_projection:
  fov:float -> ratio:float -> near:float -> far:float -> t
(** replaces [gluPerspective] *)

val ortho_projection: left:float -> right:float ->
  bottom:float -> top:float -> near:float -> far:float -> t
(** replaces [glOrtho] *)

val frustum:
  left:float -> right:float ->
  bottom:float -> top:float ->
  near:float -> far:float -> t
(** replaces [glFrustum] *)


(** {3 transformation matrices} *)

val translation_matrix: float * float * float -> t
val scale_matrix: float * float * float -> t

val x_rotation_matrix: angle:float -> t
val y_rotation_matrix: angle:float -> t
val z_rotation_matrix: angle:float -> t

(** the following:
{[
  let scale = Ogl_matrix.scale_matrix (0.1, 0.1, 0.1)
  and rot   = Ogl_matrix.x_rotation_matrix 20.0
  and trans = Ogl_matrix.translation_matrix (3.0, 4.0, 5.0)
  in
  let m = Ogl_matrix.get_identity() in
  let m = Ogl_matrix.mult_matrix m scale in
  let m = Ogl_matrix.mult_matrix m rot in
  let m = Ogl_matrix.mult_matrix m trans in
  (m)
]}
  is equivalent to:
{[
  glScale 0.1 0.1 0.1;
  glRotate (20.0) 1.0 0.0 0.0;
  glTranslate 3.0 4.0 5.0;
]}
*)

val mult_matrix: m1:t -> m2:t -> t

val matrix_translate: matrix:t -> float * float * float -> unit
(** imperative, modifies the matrix parameter *)

