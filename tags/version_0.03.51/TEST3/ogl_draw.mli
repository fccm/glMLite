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

