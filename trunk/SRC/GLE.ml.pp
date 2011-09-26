(* {{{ COPYING *(

  This file belongs to glMLite, an OCaml binding to the OpenGL API.

  Copyright (C) 2006 - 2011  Florent Monnier, Some rights reserved
  Contact:  <fmonnier@linux-nantes.org>

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

)* }}} *)

(** Bindings to the GLE library. A set of functions to make extrusions. *)

(** GLE is a library that draws extruded surfaces, including surfaces of
    revolution, sweeps, tubes, polycones, polycylinders and helicoids.
    Generically, the extruded surface is specified with a 2D polyline that
    is extruded along a 3D path.  A local coordinate system allows for
    additional flexibility in the primitives drawn.  Extrusions may be
    texture mapped in a variety of ways.  The GLE library generates 3D
    triangle coordinates, lighting normal vectors and texture coordinates
    as output. *)

type join_style =
  | TUBE_JN_RAW
  | TUBE_JN_ANGLE
  | TUBE_JN_CUT
  | TUBE_JN_ROUND
  | TUBE_JN_CAP
  | TUBE_NORM_FACET
  | TUBE_NORM_EDGE
  | TUBE_NORM_PATH_EDGE
  | TUBE_CONTOUR_CLOSED

external gleSetJoinStyle: join_style list -> unit = "ml_glesetjoinstyle"
external gleGetJoinStyle: unit -> join_style list = "ml_glegetjoinstyle"
(** control join style of the tubes *)

external gleDestroyGC : unit -> unit = "ml_gledestroygc"
(** clean up global memory usage *)


#ifdef MLI
#else
(* ML *)
(** Depending on how the lib-gle was compiled, to use C floats or doubles,
    you will have to adapt the [Bigarray.kind] to [Bigarray.float32] or
    [Bigarray.float64] for the point coordinates.
    The function [which_float] will tell you which one to use. *)
type which_ba =
  | BA_float32  (** you have to use [Bigarray.float32] *)
  | BA_float64  (** you have to use [Bigarray.float64] *)
#endif


#ifdef MLI
(*
val which_float: unit -> which_ba
(** This function tells you which kind of bigarray to use. *)
*)
#else
(* ML *)
external sizeof_gleDouble: unit -> int = "sizeof_gledouble"
let which_float () =
  match sizeof_gleDouble() with
  | 4 -> BA_float32
  | 8 -> BA_float64
  | _ -> assert(false)
#endif


type gle_float
#ifdef MLI
(*
val cast_ba1:
      (float, 'a, Bigarray.c_layout) Bigarray.Array1.t ->
      (float, gle_float, Bigarray.c_layout) Bigarray.Array1.t
val cast_ba2:
      (float, 'a, Bigarray.c_layout) Bigarray.Array2.t ->
      (float, gle_float, Bigarray.c_layout) Bigarray.Array2.t
(** Provides a way to keep the code generic for any kind of floats. *)
*)
#else
(* ML *)
let cast_ba1
      (a :( (float, 'a, Bigarray.c_layout) Bigarray.Array1.t) ) =
      (Obj.magic a :( (float, gle_float, Bigarray.c_layout) Bigarray.Array1.t) )
let cast_ba2
      (a :( (float, 'a, Bigarray.c_layout) Bigarray.Array2.t) ) =
      (Obj.magic a :( (float, gle_float, Bigarray.c_layout) Bigarray.Array2.t) )
#endif




#ifdef MLI

val ba2_float32_of_array :
      float array array ->
      (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t
(** identical to [Bigarray.Array2.of_array Bigarray.float32 Bigarray.c_layout array] *)

val ba2_float32_create :
      int -> int ->
      (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t
(** identical to [Bigarray.Array2.create Bigarray.float32 Bigarray.c_layout dim1 dim2] *)

val ba2_glefloat_of_array :
      float array array ->
      (float, gle_float, Bigarray.c_layout) Bigarray.Array2.t
(** identical to [ba2_float32_of_array] but with [gle_float] *)

val ba2_glefloat_create :
      int -> int ->
      (float, gle_float, Bigarray.c_layout) Bigarray.Array2.t
(** identical to [ba2_float32_create] but with [gle_float] *)

val ba1_glefloat_of_array :
      float array ->
      (float, gle_float, Bigarray.c_layout) Bigarray.Array1.t

val ba1_glefloat_create :
      int ->
      (float, gle_float, Bigarray.c_layout) Bigarray.Array1.t

#else
(* ML *)

let ba2_float32_of_array =
  Bigarray.Array2.of_array Bigarray.float32 Bigarray.c_layout ;;

let ba2_float32_create =
  Bigarray.Array2.create Bigarray.float32 Bigarray.c_layout ;;

let ba2_glefloat_of_array arr =
  match which_float() with
  | BA_float32 -> cast_ba2(Bigarray.Array2.of_array Bigarray.float32 Bigarray.c_layout arr)
  | BA_float64 -> cast_ba2(Bigarray.Array2.of_array Bigarray.float64 Bigarray.c_layout arr)

let ba2_glefloat_create dim1 dim2 =
  match which_float() with
  | BA_float32 -> cast_ba2(Bigarray.Array2.create Bigarray.float32 Bigarray.c_layout dim1 dim2)
  | BA_float64 -> cast_ba2(Bigarray.Array2.create Bigarray.float64 Bigarray.c_layout dim1 dim2)

let ba1_glefloat_of_array arr =
  match which_float() with
  | BA_float32 -> cast_ba1(Bigarray.Array1.of_array Bigarray.float32 Bigarray.c_layout arr)
  | BA_float64 -> cast_ba1(Bigarray.Array1.of_array Bigarray.float64 Bigarray.c_layout arr)

let ba1_glefloat_create dim =
  match which_float() with
  | BA_float32 -> cast_ba1(Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout dim)
  | BA_float64 -> cast_ba1(Bigarray.Array1.create Bigarray.float64 Bigarray.c_layout dim)

#endif



#ifdef MLI
val colors_none : (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t
#else
(* ML *)
let colors_none = Bigarray.Array2.create Bigarray.float32 Bigarray.c_layout 0 3
#endif



#ifdef MLI
val glePolyCylinder: 
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        radius:float -> unit
(** draw polyclinder, specified as a polyline
    @param  points  polyline vertices
    @param  colors  colors at polyline verts
    @param  radius       radius of polycylinder
*)
#else
(* ML *)

external glePolyCylinder: npoints:int ->
    points:(float, 'a, Bigarray.c_layout) Bigarray.Array2.t ->
    colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
    radius:float -> unit = "ml_glepolycylinder"

let glePolyCylinder ~points ~colors ~radius =
  let point_components = Bigarray.Array2.dim2 points in
  if point_components <> 3 then
    invalid_arg "glePolyCylinder: should be 3 coordinates per point";
  let color_components = Bigarray.Array2.dim2 colors in
  if color_components <> 3 then
    invalid_arg "glePolyCylinder: should be 3 components per color";
  let npoints = Bigarray.Array2.dim1 points
  and ncolors = Bigarray.Array2.dim1 colors in
  if npoints <> ncolors then
    invalid_arg "glePolyCylinder: should have the same number of points and colors";
  glePolyCylinder ~npoints ~points ~colors ~radius;
;;

#endif




#ifdef MLI
val glePolyCone:
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        radii:(float, gle_float, Bigarray.c_layout) Bigarray.Array1.t ->
        unit
(** draw polycone, specified as a polyline with radii
    @param  points   polyline vertices
    @param  colors   colors at polyline verts
    @param  radii  cone radii at polyline verts
*)
#else
(* ML *)

external glePolyCone: npoints:int ->
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        radii:(float, gle_float, Bigarray.c_layout) Bigarray.Array1.t ->
        unit = "ml_glepolycone"

let glePolyCone ~points ~colors ~radii =
  let point_components = Bigarray.Array2.dim2 points in
  if point_components <> 3 then
    invalid_arg "glePolyCone: should be 3 coordinates per point";
  let color_components = Bigarray.Array2.dim2 colors in
  if color_components <> 3 then
    invalid_arg "glePolyCone: should be 3 components per color";
  let npoints = Bigarray.Array2.dim1 points
  and ncolors = Bigarray.Array2.dim1 colors
  and nradius = Bigarray.Array1.dim radii in
  if npoints <> ncolors && ncolors <> 0 then
    invalid_arg "glePolyCone: should have the same number of points and colors";
  if npoints <> nradius then
    invalid_arg "glePolyCone: should have the same number of points and radius";
  glePolyCone ~npoints ~points ~colors ~radii;
;;

#endif



#ifdef MLI
val glePolyCone_c4f:
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        radii:(float, gle_float, Bigarray.c_layout) Bigarray.Array1.t ->
        unit
(** same than [glePolyCone] but with RGBA colors *)
#else
(* ML *)

external glePolyCone_c4f: npoints:int ->
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        radii:(float, gle_float, Bigarray.c_layout) Bigarray.Array1.t ->
        unit = "ml_glepolycone_c4f"

let glePolyCone_c4f ~points ~colors ~radii =
  let point_components = Bigarray.Array2.dim2 points in
  if point_components <> 3 then
    invalid_arg "glePolyCone_c4f: should be 3 coordinates per point";
  let color_components = Bigarray.Array2.dim2 colors in
  if color_components <> 4 then
    invalid_arg "glePolyCone_c4f: should be 4 components per color";
  let npoints = Bigarray.Array2.dim1 points
  and ncolors = Bigarray.Array2.dim1 colors
  and nradius = Bigarray.Array1.dim radii in
  if npoints <> ncolors && ncolors <> 0 then
    invalid_arg "glePolyCone_c4f: should have the same number of points and colors";
  if npoints <> nradius then
    invalid_arg "glePolyCone_c4f: should have the same number of points and radius";
  glePolyCone_c4f ~npoints ~points ~colors ~radii;
;;

#endif





#ifdef MLI

val gleExtrusion:
        contour:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        cont_normals:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        up:(float * float * float) option ->
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        unit
(** extrude arbitrary 2D contour along arbitrary 3D path
   @param  contour       2D contour
   @param  cont_normals  2D contour normals
   @param  up            up vector for contour
   @param  points        polyline vertices
   @param  colors        colors at polyline verts
*)
#else
(* ML *)

external gleExtrusion:
        ncp:int ->
        contour:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        cont_normals:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        up:(float * float * float) option ->
        npoints:int ->
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t -> unit
        = "ml_gleextrusion_bytecode"
          "ml_gleextrusion"

let gleExtrusion ~contour ~cont_normals ~up ~points ~colors =

  let contour_components = Bigarray.Array2.dim2 contour in
  if contour_components <> 2 then
    invalid_arg "gleExtrusion: should be 2 components per contour";

  let contnorm_components = Bigarray.Array2.dim2 cont_normals in
  if contnorm_components <> 2 then
    invalid_arg "gleExtrusion: should be 2 components per contour normal";

  let point_components = Bigarray.Array2.dim2 points in
  if point_components <> 3 then
    invalid_arg "gleExtrusion: should be 3 coordinates per point";

  let color_components = Bigarray.Array2.dim2 colors in
  if color_components <> 3 then
    invalid_arg "gleExtrusion: should be 3 components per color";

  let ncp = Bigarray.Array2.dim1 contour
  and ncontnm = Bigarray.Array2.dim1 cont_normals
  and npoints = Bigarray.Array2.dim1 points
  and ncolors = Bigarray.Array2.dim1 colors
  in
  if ncp <> ncontnm then
    invalid_arg "gleExtrusion: bigarrays should contain the same number of coordinates";

  if npoints <> ncolors && ncolors <> 0 then
    invalid_arg "gleExtrusion: should have the same number of points and colors";

  gleExtrusion ~ncp ~contour ~cont_normals ~up ~npoints ~points ~colors;
;;

#endif




#ifdef MLI

val gleTwistExtrusion:
        contour:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        cont_normals:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        up:(float * float * float) option ->
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        twist:(float, gle_float, Bigarray.c_layout) Bigarray.Array1.t ->
        unit
(** extrude 2D contour, specifying local rotations (twists)

    @param  contour       2D contour
    @param  cont_normal   2D contour normals
    @param  up            up vector for contour 
    @param  point_array   polyline vertices
    @param  color_array   color at polyline verts
    @param  twist_array   countour twists (in degrees)
*)
#else
(* ML *)

external gleTwistExtrusion:
        ncp:int ->
        contour:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        cont_normals:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        up:(float * float * float) option ->
        npoints:int ->
        points:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        colors:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array2.t ->
        twist:(float, gle_float, Bigarray.c_layout) Bigarray.Array1.t ->
        unit
        = "ml_gletwistextrusion_bytecode"
          "ml_gletwistextrusion"

let gleTwistExtrusion ~contour ~cont_normals ~up ~points ~colors ~twist =

  let contour_components = Bigarray.Array2.dim2 contour in
  if contour_components <> 2 then
    invalid_arg "gleExtrusion: should be 2 components per contour";

  let contnorm_components = Bigarray.Array2.dim2 cont_normals in
  if contnorm_components <> 2 then
    invalid_arg "gleExtrusion: should be 2 components per contour normal";

  let point_components = Bigarray.Array2.dim2 points in
  if point_components <> 3 then
    invalid_arg "gleExtrusion: should be 3 coordinates per point";

  let color_components = Bigarray.Array2.dim2 colors in
  if color_components <> 3 then
    invalid_arg "gleExtrusion: should be 3 components per color";

  let ncp = Bigarray.Array2.dim1 contour
  and ncontnm = Bigarray.Array2.dim1 cont_normals
  and npoints = Bigarray.Array2.dim1 points
  and ncolors = Bigarray.Array2.dim1 colors
  and ntwists = Bigarray.Array1.dim twist
  in
  if ncp <> ncontnm then
    invalid_arg "gleExtrusion: bigarrays should contain the same number of coordinates";

  if npoints <> ncolors && ncolors <> 0 then
    invalid_arg "gleExtrusion: should have the same number of points and colors";

  if npoints <> ntwists then
    invalid_arg "gleExtrusion: should have the same number of points and twists";

  gleTwistExtrusion ~ncp ~contour ~cont_normals ~up ~npoints ~points ~colors ~twist;
;;

#endif




#ifdef MLI

val gleSpiral:
        contour:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        cont_normals:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        up:(float * float * float) option ->
        start_radius:float ->
        drd_theta:float ->
        start_z:float ->
        dzd_theta:float ->
        start_xform:((float * float * float) * (float * float * float)) option ->
        dx_formd_theta:((float * float * float) * (float * float * float)) option ->
        start_theta:float ->
        sweep_theta:float ->
        unit
(** sweep an arbitrary contour along a helical path
    @param  contour         2D contour
    @param  cont_normal     2D contour normals
    @param  up              up vector for contour 
    @param  start_radius    spiral starts in x-y plane
    @param  drd_theta       change in radius per revolution
    @param  start_z         starting z value
    @param  dzd_theta       change in z per revolution
    @param  start_xform     starting contour affine transform
    @param  dx_formd_theta  tangent change transform per revolution
    @param  start_theta     start angle in x-y plane
    @param  sweep_theta     degrees to spiral around
*)
#else
(* ML *)

external gleSpiral:
        ncp:int ->
        contour:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        cont_normals:(float, gle_float, Bigarray.c_layout) Bigarray.Array2.t ->
        up:(float * float * float) option ->
        start_radius:float ->
        drd_theta:float ->
        start_z:float ->
        dzd_theta:float ->
        start_xform:((float * float * float) * (float * float * float)) option ->
        dx_formd_theta:((float * float * float) * (float * float * float)) option ->
        start_theta:float ->
        sweep_theta:float ->
        unit
        = "ml_glespiral_bytecode"
          "ml_glespiral"

let gleSpiral ~contour ~cont_normals ~up ~start_radius ~drd_theta ~start_z
              ~dzd_theta ~start_xform ~dx_formd_theta ~start_theta ~sweep_theta =

  let contour_components = Bigarray.Array2.dim2 contour in
  if contour_components <> 2 then
    invalid_arg "gleSpiral: should be 2 components per contour";

  let contnorm_components = Bigarray.Array2.dim2 cont_normals in
  if contnorm_components <> 2 then
    invalid_arg "gleSpiral: should be 2 components per contour normal";

  let ncp = Bigarray.Array2.dim1 contour
  and ncontnm = Bigarray.Array2.dim1 cont_normals
  in
  if ncp <> ncontnm then
    invalid_arg "gleSpiral: bigarrays should contain the same number of coordinates";

  gleSpiral ~ncp ~contour ~cont_normals ~up ~start_radius ~drd_theta ~start_z
            ~dzd_theta ~start_xform ~dx_formd_theta ~start_theta ~sweep_theta;
;;

#endif




#ifdef MLI

val gleHelicoid:
        torus_radius:float ->
        start_radius:float ->
        drd_theta:float ->
        start_z:float ->
        dzd_theta:float ->
        start_xform:((float * float * float) * (float * float * float)) option ->
        dx_formd_theta:((float * float * float) * (float * float * float)) option ->
        start_theta:float ->
        sweep_theta:float ->
        unit
(** Generalized Torus. Similar to gleSpiral, except contour is a circle.
    @param  torus_radius    circle contour (torus) radius
    @param  start_radius    spiral starts in x-y plane
    @param  drd_theta       change in radius per revolution
    @param  start_z         starting z value
    @param  dzd_theta       change in z per revolution
    @param  start_xform     starting contour affine transform
    @param  dx_formd_theta  tangent change transform per revolution
    @param  start_theta     start angle in x-y plane
    @param  sweep_theta     degrees to spiral around
*)
#else
(* ML *)

external gleHelicoid:
        torus_radius:float ->
        start_radius:float ->
        drd_theta:float ->
        start_z:float ->
        dzd_theta:float ->
        start_xform:((float * float * float) * (float * float * float)) option ->
        dx_formd_theta:((float * float * float) * (float * float * float)) option ->
        start_theta:float ->
        sweep_theta:float ->
        unit
        = "ml_glehelicoid_bytecode"
          "ml_glehelicoid"

let gleHelicoid ~torus_radius ~start_radius ~drd_theta ~start_z ~dzd_theta
                ~start_xform ~dx_formd_theta ~start_theta ~sweep_theta =

  gleHelicoid ~torus_radius ~start_radius ~drd_theta ~start_z ~dzd_theta
              ~start_xform ~dx_formd_theta ~start_theta ~sweep_theta;
;;

#endif



(* vim: sw=2 sts=2 ts=2 et fdm=marker filetype=ocaml
 *)
