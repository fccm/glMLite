(* {{{ COPYING *(

  +-----------------------------------------------------------------------+
  |  This file belongs to glMLite, an OCaml binding to the OpenGL API.    |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2006, 2007, 2008  Florent Monnier                      |
  |  Contact:  <fmonnier@linux-nantes.org>                                |
  +-----------------------------------------------------------------------+
  |  This program is free software: you can redistribute it and/or        |
  |  modify it under the terms of the GNU General Public License          |
  |  as published by the Free Software Foundation, either version 3       |
  |  of the License, or (at your option) any later version.               |
  |                                                                       |
  |  This program is distributed in the hope that it will be useful,      |
  |  but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  |  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        |
  |  GNU General Public License for more details.                         |
  |                                                                       |
  |  You should have received a copy of the GNU General Public License    |
  |  along with this program.  If not, see <http://www.gnu.org/licenses/> |
  +-----------------------------------------------------------------------+

)* }}} *)

(** An {i experimental} attempt at a functional interface to OpenGL. *)

(** This module tries to be a functional wrapper around OpenGL,
    so you don't have to think about the side effects and restoring
    the previous gl state when using these functions.
    You can set parameters for a local effect.
*)

(** {3 Types} *)

type vertex2 = float * float  (** (x,y) *)
type vertex3 = float * float * float  (** (x,y,z) *)
type vertex4 = float * float * float * float  (** (x,y,z,w) *)
type vector = float * float * float
type rgb = float * float * float
type rgba = float * float * float * float
type uv = float * float
type matrix4x4 = float array


(** {3 Replacement Functions} *)

#ifdef MLI

val draw_translated: vector -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glTranslate} *)

val draw_rotated: float -> vector -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glRotate} *)

val draw_scaled: vector -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glScale} *)

val draw_as_identity: (unit -> unit) -> unit
(** use this function as replacement of {!GL.glLoadIdentity} *)

val draw_with_matrix: matrix4x4 -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glMultMatrix}/Flat *)

#else
(* ML *)

external push_and_translate: vector -> unit = "c_push_and_translate" "noalloc"
external push_and_scale: vector -> unit = "c_push_and_scale" "noalloc"
external push_and_rotate: float -> vector -> unit = "c_push_and_rotate" "noalloc"
external push_and_loadIdentity: unit -> unit = "c_push_and_loadIdentity" "noalloc"
external push_and_multMatrix: matrix4x4 -> unit = "c_push_and_multMatrix" "noalloc"
external pop_matrix: unit -> unit = "c_pop_matrix" "noalloc"

(*
  The cost of an OCaml function call from C is more expensive than
  calling a C function from OCaml. The ratio of about (5.5).
  So it is cheaper to make 2 C from OCaml function calls as bellow
  than calling the parameter 'f' from C.
*)

let draw_translated vec f =
  push_and_translate vec;
  f ();
  pop_matrix()
;;

let draw_rotated angle vec f =
  push_and_rotate angle vec;
  f ();
  pop_matrix()
;;

let draw_scaled vec f =
  push_and_scale vec;
  f ();
  pop_matrix()
;;

let draw_as_identity f =
  push_and_loadIdentity();
  f ();
  pop_matrix()
;;

let draw_with_matrix mat f =
  push_and_multMatrix mat;
  f ();
  pop_matrix()
;;

#endif



#ifdef MLI

val draw_with_rgb: rgb -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glColor3} *)

val draw_with_rgba: rgba -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glColor4} *)

#else
(* ML *)

type color_state

external set_get_color3: rgb -> color_state = "c_set_get_color3" "noalloc"
external set_get_color4: rgba -> color_state = "c_set_get_color4" "noalloc"
external restore_color: color_state -> unit = "c_restore_color" "noalloc"

let draw_with_rgb rgb f =
  let cs = set_get_color3 rgb in
  f ();
  restore_color cs;
;;

let draw_with_rgba rgba f =
  let cs = set_get_color4 rgba in
  f ();
  restore_color cs;
;;

#endif



#ifdef MLI
val draw_with_material : face:GL.face_mode -> mode:GL.Material.material_mode -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glMaterial} *)
#else
(* ML *)
type material_state
external set_get_material: face:GL.face_mode -> mode:GL.Material.material_mode -> material_state = "c_set_get_material" "noalloc"
external restore_material: face:GL.face_mode -> mode:GL.Material.material_mode -> material_state -> unit = "c_restore_material" "noalloc"
let draw_with_material ~face ~mode f =
  let ms = set_get_material ~face ~mode in
  f ();
  restore_material ~face ~mode ms;
;;
#endif



#ifdef MLI
val draw_with_lightModel : light_model:GL.light_model -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glLightModel} *)
#else
(* ML *)
type lightModel_state
external set_get_lightModel : light_model:GL.light_model -> lightModel_state = "c_set_get_lightModel" "noalloc"
external restore_lightModel : light_model:GL.light_model -> lightModel_state -> unit = "c_restore_lightModel" "noalloc"
let draw_with_lightModel ~light_model f =
  let lms = set_get_lightModel ~light_model in
  f ();
  restore_lightModel ~light_model lms;
;;
#endif



#ifdef MLI
val draw_with_shadeModel : shade_mode:GL.shade_mode -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glShadeModel} *)
#else
(* ML *)
type shade_state
external set_get_shadeModel : GL.shade_mode -> shade_state = "c_set_get_shadeModel" "noalloc"
external restore_shadeModel : shade_state -> unit = "c_restore_shadeModel" "noalloc"
let draw_with_shadeModel ~shade_mode f =
  let sms = set_get_shadeModel shade_mode in
  f ();
  restore_shadeModel sms;
;;
#endif


(*
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/colormaterial.html
  glIsEnabled with argument GL_COLOR_MATERIAL
  glGet with argument GL_COLOR_MATERIAL_PARAMETER
  glGet with argument GL_COLOR_MATERIAL_FACE
  if (!glIsEnabled( GL_COLOR_MATERIAL )) {
      ptr = NULL;
    }
  if (ptr != NULL) {
      restore(face, material_param);
    }
*)



#ifdef MLI
val draw_with_frontFace : orientation:GL.orientation -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glFrontFace} *)
#else
(* ML *)
type orientation_state
external set_get_frontFace : orientation:GL.orientation -> orientation_state = "c_set_get_frontFace" "noalloc"
external restore_frontFace : orientation_state -> unit = "c_restore_frontFace" "noalloc"
let draw_with_frontFace ~orientation f =
  let ffos = set_get_frontFace ~orientation in
  f ();
  restore_frontFace ffos;
;;
#endif




#ifdef MLI
val draw_with_cullFace : mode:GL.face_mode -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glCullFace} *)
#else
(* ML *)
type face_mode_state
external set_get_cullFace : mode:GL.face_mode -> face_mode_state = "c_set_get_cullFace" "noalloc"
external restore_cullFace : face_mode_state -> unit = "c_restore_cullFace" "noalloc"
let draw_with_cullFace ~mode f =
  let fms = set_get_cullFace ~mode in
  f ();
  restore_cullFace fms;
;;
#endif



(*
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/frustum.html

   associated gets:
        glGet with argument GL_MATRIX_MODE (
          glGet with argument GL_MODELVIEW_MATRIX
          glGet with argument GL_PROJECTION_MATRIX
          glGet with argument GL_TEXTURE_MATRIX
        )

val glFrustum :
       left:float -> right:float ->
       bottom:float -> top:float ->
       near:float -> far:float -> unit
*)


(*
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/depthrange.html
glDepthRange ???

   associated gets:
        glGet with argument GL_DEPTH_RANGE

val glDepthRange : near_val:float -> far_val:float -> unit
*)

(*
glColorMask
*)



#ifdef MLI
val draw_enabled: cap:GL.gl_capability -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glEnable} *)
#else
(* ML *)
type enabled_state = bool
external set_get_enabled : GL.gl_capability -> enabled_state = "c_set_get_enabled" "noalloc"
external restore_enabled : GL.gl_capability -> unit = "c_restore_enabled" "noalloc"
let draw_enabled ~cap f =
  let es = set_get_enabled cap in
  f ();
  if es then restore_enabled cap;
;;
#endif



#ifdef MLI
val draw_disabled: cap:GL.gl_capability -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glDisable} *)
#else
(* ML *)
type disabled_state = bool
external set_get_disabled : GL.gl_capability -> disabled_state = "c_set_get_disabled" "noalloc"
external restore_disabled : GL.gl_capability -> unit = "c_restore_disabled" "noalloc"
let draw_disabled ~cap f =
  let ds = set_get_disabled cap in
  f ();
  if ds then restore_disabled cap;
;;
#endif



#ifdef MLI
val draw_with_viewport : viewport:int * int * int * int -> (unit -> unit) -> unit
(** use this function instead of {!GL.glViewport} when you use a local viewport *)
#else
(* ML *)
type viewport_state
external set_get_viewport : viewport:int * int * int * int -> viewport_state = "c_set_get_viewport" "noalloc"
external restore_viewport : viewport_state -> unit = "c_restore_viewport" "noalloc"
let draw_with_viewport ~viewport f =
  let vps = set_get_viewport ~viewport in
  f ();
  restore_viewport vps;
;;
#endif



#ifdef MLI
val draw_with_polygonMode : face:GL.face_mode -> mode:GL.polygon_mode -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glPolygonMode} *)
#else
(* ML *)
type polygonMode_state
external set_get_polygonMode : face:GL.face_mode -> mode:GL.polygon_mode -> polygonMode_state = "c_set_get_polygonMode" "noalloc"
external restore_polygonMode : polygonMode_state -> unit = "c_restore_polygonMode" "noalloc"
let draw_with_polygonMode ~face ~mode f =
  let pms = set_get_polygonMode ~face ~mode in
  f ();
  restore_polygonMode pms;
;;
#endif



#ifdef MLI
val draw_with_polygonMode2 : front:GL.polygon_mode -> back:GL.polygon_mode -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glPolygonMode} *)
#else
(* ML *)
type polygonMode2_state
external set_get_polygonMode2 : front:GL.polygon_mode -> back:GL.polygon_mode -> polygonMode2_state = "c_set_get_polygonMode2" "noalloc"
external restore_polygonMode2 : polygonMode2_state -> unit = "c_restore_polygonMode2" "noalloc"
let draw_with_polygonMode2 ~front ~back f =
  let pms = set_get_polygonMode2 ~front ~back in
  f ();
  restore_polygonMode2 pms;
;;
#endif



#ifdef MLI
val do_with_matrixMode : mode:GL.matrix_mode -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glMatrixMode} *)
#else
(* ML *)
type matrixMode_state
external set_get_matrixMode : mode:GL.matrix_mode -> matrixMode_state = "c_set_get_matrixMode" "noalloc"
external restore_matrixMode : matrixMode_state -> unit = "c_restore_matrixMode" "noalloc"
let do_with_matrixMode ~mode f =
  let mms = set_get_matrixMode ~mode in
  f ();
  restore_matrixMode mms;
;;
#endif



#ifdef MLI

val draw_with_lineWidth: width:float -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glLineWidth} *)

val draw_with_pointSize: size:float -> (unit -> unit) -> unit
(** use this function as replacement of {!GL.glPointSize} *)

#else
(* ML *)

type lineWidth_state
type pointSize_state

external set_get_lineWidth: float -> lineWidth_state = "c_set_get_lineWidth" "noalloc"
external set_get_pointSize: float -> pointSize_state = "c_set_get_pointSize" "noalloc"

external restore_lineWidth: lineWidth_state -> unit = "c_restore_lineWidth" "noalloc"
external restore_pointSize: pointSize_state -> unit = "c_restore_pointSize" "noalloc"

let draw_with_lineWidth ~width f =
  let lws = set_get_lineWidth width in
  f ();
  restore_lineWidth lws;
;;

let draw_with_pointSize ~size f =
  let pss = set_get_pointSize size in
  f ();
  restore_pointSize pss;
;;

#endif
(*
 glGet with argument GL_LINE_WIDTH
 glGet with argument GL_POINT_SIZE

http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/linewidth.html
val glLineWidth : width:float -> unit

http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/pointsize.html
val glPointSize : size:float -> unit
*)


(*
  http://www.opengl.org/sdk/docs/man/xhtml/glPolygonOffset.xml
  glIsEnabled with argument GL_POLYGON_OFFSET_FILL, GL_POLYGON_OFFSET_LINE,
  or GL_POLYGON_OFFSET_POINT.
  glGet with argument GL_POLYGON_OFFSET_FACTOR or GL_POLYGON_OFFSET_UNITS.
  val glPolygonOffset : factor:float -> units:float -> unit
*)


(*
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/texparameter.html
*)




(*
#ifdef MLI
val draw_with_texParameter : 
      target:GL.TexParam.tex_param_target ->
      pname:GL.TexParam.tex_param_pname ->
      param:GL.TexParam.tex_parameter ->
      (unit -> unit) -> unit
(** use this function as replacement of {!GL.glTexParameter} *)
#else
(* ML *)
type texParameter_state
external set_get_texParameter : face:GL.face_mode -> mode:GL.polygon_mode -> texParameter_state = "c_set_get_texParameter"
external restore_texParameter : texParameter_state -> unit = "c_restore_texParameter"
let draw_with_texParameter ~target ~pname ~param f =
  let tps = set_get_texParameter ~target ~pname ~param in
  f ();
  restore_texParameter tps;
;;
#endif
          glGetTexParameter
          glGetTexLevelParameter
      http://www.opengl.org/sdk/docs/man/xhtml/glGetTexParameter.xml
      http://www.opengl.org/sdk/docs/man/xhtml/glGetTexLevelParameter.xml
*)




(*
val glNewList: gl_list:int -> mode:list_mode -> unit
val glEndList: unit -> unit
val glGenLists: range:int -> int
val glCallList: gl_list:int -> unit
*)


(*
val glRenderMode : mode:render_mode -> int
val glInitNames : unit -> unit
val glLoadName : name:int -> unit
val glPushName : name:int -> unit
val glPopName : unit -> unit
val glSelectBufferBA
*)


(*
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/fog.html
val glFog : pname:fog_param -> unit
*)


(*
glClearStencil ???
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/clearstencil.html
*)


(*
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/ortho.html
glOrtho
 with check if matrix mode is the good one
*)


#ifdef MLI
val draw_using_program: program:GL.shader_program -> (unit -> unit) -> unit
(**  *)
#else
(* ML *)
type usedProgram_state
external set_get_programUse : program:GL.shader_program -> usedProgram_state = "c_set_get_programUse" "noalloc"
external restore_programUse : usedProgram_state -> unit = "c_restore_programUse" "noalloc"
let draw_using_program ~program f =
  let pus = set_get_programUse ~program in
  f ();
  restore_programUse pus;
;;
#endif


(** {3 Drawing} *)


type qualified_vertices =
  | Vertices2 of vertex2 list
  | Vertices3 of vertex3 list
  | Vertices4 of vertex4 list
  | Normal_Vertices2 of (vector * vertex2) list
  | Normal_Vertices3 of (vector * vertex3) list
  | Normal_Vertices4 of (vector * vertex4) list
 
  | RGB_Vertices2 of (rgb * vertex2) list
  | RGB_Vertices3 of (rgb * vertex3) list
  | RGB_Vertices4 of (rgb * vertex4) list
  | RGBA_Vertices2 of (rgba * vertex2) list
  | RGBA_Vertices3 of (rgba * vertex3) list
  | RGBA_Vertices4 of (rgba * vertex4) list
 
  | Normal_RGB_Vertices2 of (vector * rgb * vertex2) list
  | Normal_RGB_Vertices3 of (vector * rgb * vertex3) list
  | Normal_RGB_Vertices4 of (vector * rgb * vertex4) list
  | Normal_RGBA_Vertices2 of (vector * rgba * vertex2) list
  | Normal_RGBA_Vertices3 of (vector * rgba * vertex3) list
  | Normal_RGBA_Vertices4 of (vector * rgba * vertex4) list
 
  (* the same but with UV *)
  | UV_Vertices2 of (uv * vertex2) list
  | UV_Vertices3 of (uv * vertex3) list
  | UV_Vertices4 of (uv * vertex4) list
 
  | UV_Normal_Vertices2 of (uv * vector * vertex2) list
  | UV_Normal_Vertices3 of (uv * vector * vertex3) list
  | UV_Normal_Vertices4 of (uv * vector * vertex4) list
 
  | UV_RGB_Vertices2 of (uv * rgb * vertex2) list
  | UV_RGB_Vertices3 of (uv * rgb * vertex3) list
  | UV_RGB_Vertices4 of (uv * rgb * vertex4) list
  | UV_RGBA_Vertices2 of (uv * rgba * vertex2) list
  | UV_RGBA_Vertices3 of (uv * rgba * vertex3) list
  | UV_RGBA_Vertices4 of (uv * rgba * vertex4) list
 
  | UV_Normal_RGB_Vertices2 of (uv * vector * rgb * vertex2) list
  | UV_Normal_RGB_Vertices3 of (uv * vector * rgb * vertex3) list
  | UV_Normal_RGB_Vertices4 of (uv * vector * rgb * vertex4) list
  | UV_Normal_RGBA_Vertices2 of (uv * vector * rgba * vertex2) list
  | UV_Normal_RGBA_Vertices3 of (uv * vector * rgba * vertex3) list
  | UV_Normal_RGBA_Vertices4 of (uv * vector * rgba * vertex4) list

#ifdef MLI

val render_primitive: GL.primitive -> qualified_vertices -> unit
(** render the given list of qualified vertices as the required primitive *)

#else
(* ML *)

type primitive = GL.primitive

external render_verts2: primitive -> vertex2 list -> unit = "render_verts2"
external render_verts3: primitive -> vertex3 list -> unit = "render_verts3"
external render_verts4: primitive -> vertex4 list -> unit = "render_verts4"
 
external render_norm_verts2: primitive -> (vector * vertex2) list -> unit = "render_norm_verts2"
external render_norm_verts3: primitive -> (vector * vertex3) list -> unit = "render_norm_verts3"
external render_norm_verts4: primitive -> (vector * vertex4) list -> unit = "render_norm_verts4"
 
external render_rgb_verts2: primitive -> (rgb * vertex2) list -> unit = "render_rgb_verts2"
external render_rgb_verts3: primitive -> (rgb * vertex3) list -> unit = "render_rgb_verts3"
external render_rgb_verts4: primitive -> (rgb * vertex4) list -> unit = "render_rgb_verts4"
 
external render_rgba_verts2: primitive -> (rgba * vertex2) list -> unit = "render_rgba_verts2"
external render_rgba_verts3: primitive -> (rgba * vertex3) list -> unit = "render_rgba_verts3"
external render_rgba_verts4: primitive -> (rgba * vertex4) list -> unit = "render_rgba_verts4"
 
external render_norm_rgb_verts2: primitive -> (vector * rgb * vertex2) list -> unit = "render_norm_rgb_verts2"
external render_norm_rgb_verts3: primitive -> (vector * rgb * vertex3) list -> unit = "render_norm_rgb_verts3"
external render_norm_rgb_verts4: primitive -> (vector * rgb * vertex4) list -> unit = "render_norm_rgb_verts4"
external render_norm_rgba_verts2: primitive -> (vector * rgba * vertex2) list -> unit = "render_norm_rgba_verts2"
external render_norm_rgba_verts3: primitive -> (vector * rgba * vertex3) list -> unit = "render_norm_rgba_verts3"
external render_norm_rgba_verts4: primitive -> (vector * rgba * vertex4) list -> unit = "render_norm_rgba_verts4"


external render_uv_verts2: primitive -> (uv * vertex2) list -> unit = "render_uv_verts2"
external render_uv_verts3: primitive -> (uv * vertex3) list -> unit = "render_uv_verts3"
external render_uv_verts4: primitive -> (uv * vertex4) list -> unit = "render_uv_verts4"
 
external render_uv_norm_verts2: primitive -> (uv * vector * vertex2) list -> unit = "render_uv_norm_verts2"
external render_uv_norm_verts3: primitive -> (uv * vector * vertex3) list -> unit = "render_uv_norm_verts3"
external render_uv_norm_verts4: primitive -> (uv * vector * vertex4) list -> unit = "render_uv_norm_verts4"
 
external render_uv_rgb_verts2: primitive -> (uv * rgb * vertex2) list -> unit = "render_uv_rgb_verts2"
external render_uv_rgb_verts3: primitive -> (uv * rgb * vertex3) list -> unit = "render_uv_rgb_verts3"
external render_uv_rgb_verts4: primitive -> (uv * rgb * vertex4) list -> unit = "render_uv_rgb_verts4"
external render_uv_rgba_verts2: primitive -> (uv * rgba * vertex2) list -> unit = "render_uv_rgba_verts2"
external render_uv_rgba_verts3: primitive -> (uv * rgba * vertex3) list -> unit = "render_uv_rgba_verts3"
external render_uv_rgba_verts4: primitive -> (uv * rgba * vertex4) list -> unit = "render_uv_rgba_verts4"
 
external render_uv_norm_rgb_verts2: primitive -> (uv * vector * rgb * vertex2) list -> unit = "render_uv_norm_rgb_verts2"
external render_uv_norm_rgb_verts3: primitive -> (uv * vector * rgb * vertex3) list -> unit = "render_uv_norm_rgb_verts3"
external render_uv_norm_rgb_verts4: primitive -> (uv * vector * rgb * vertex4) list -> unit = "render_uv_norm_rgb_verts4"
external render_uv_norm_rgba_verts2: primitive -> (uv * vector * rgba * vertex2) list -> unit = "render_uv_norm_rgba_verts2"
external render_uv_norm_rgba_verts3: primitive -> (uv * vector * rgba * vertex3) list -> unit = "render_uv_norm_rgba_verts3"
external render_uv_norm_rgba_verts4: primitive -> (uv * vector * rgba * vertex4) list -> unit = "render_uv_norm_rgba_verts4"


let render_primitive prim = function
  | Vertices2 verts2 -> render_verts2  prim  verts2
  | Vertices3 verts3 -> render_verts3  prim  verts3
  | Vertices4 verts4 -> render_verts4  prim  verts4
  | Normal_Vertices2 norm_verts2 -> render_norm_verts2  prim  norm_verts2
  | Normal_Vertices3 norm_verts3 -> render_norm_verts3  prim  norm_verts3
  | Normal_Vertices4 norm_verts4 -> render_norm_verts4  prim  norm_verts4
 
  | RGB_Vertices2 rgb_verts2 -> render_rgb_verts2  prim  rgb_verts2
  | RGB_Vertices3 rgb_verts3 -> render_rgb_verts3  prim  rgb_verts3
  | RGB_Vertices4 rgb_verts4 -> render_rgb_verts4  prim  rgb_verts4
  | RGBA_Vertices2 rgba_verts2 -> render_rgba_verts2  prim  rgba_verts2
  | RGBA_Vertices3 rgba_verts3 -> render_rgba_verts3  prim  rgba_verts3
  | RGBA_Vertices4 rgba_verts4 -> render_rgba_verts4  prim  rgba_verts4
 
  | Normal_RGB_Vertices2 nc3_verts2 -> render_norm_rgb_verts2  prim  nc3_verts2
  | Normal_RGB_Vertices3 nc3_verts3 -> render_norm_rgb_verts3  prim  nc3_verts3
  | Normal_RGB_Vertices4 nc3_verts4 -> render_norm_rgb_verts4  prim  nc3_verts4
  | Normal_RGBA_Vertices2 nc4_verts2 -> render_norm_rgba_verts2  prim  nc4_verts2
  | Normal_RGBA_Vertices3 nc4_verts3 -> render_norm_rgba_verts3  prim  nc4_verts3
  | Normal_RGBA_Vertices4 nc4_verts4 -> render_norm_rgba_verts4  prim  nc4_verts4
 
  | UV_Vertices2 uv_verts2 -> render_uv_verts2  prim  uv_verts2
  | UV_Vertices3 uv_verts3 -> render_uv_verts3  prim  uv_verts3
  | UV_Vertices4 uv_verts4 -> render_uv_verts4  prim  uv_verts4
 
  | UV_Normal_Vertices2 uv_norm_verts2 -> render_uv_norm_verts2  prim  uv_norm_verts2
  | UV_Normal_Vertices3 uv_norm_verts3 -> render_uv_norm_verts3  prim  uv_norm_verts3
  | UV_Normal_Vertices4 uv_norm_verts4 -> render_uv_norm_verts4  prim  uv_norm_verts4
 
  | UV_RGB_Vertices2 uv_rgb_verts2 -> render_uv_rgb_verts2  prim  uv_rgb_verts2
  | UV_RGB_Vertices3 uv_rgb_verts3 -> render_uv_rgb_verts3  prim  uv_rgb_verts3
  | UV_RGB_Vertices4 uv_rgb_verts4 -> render_uv_rgb_verts4  prim  uv_rgb_verts4
  | UV_RGBA_Vertices2 uv_rgba_verts2 -> render_uv_rgba_verts2  prim  uv_rgba_verts2
  | UV_RGBA_Vertices3 uv_rgba_verts3 -> render_uv_rgba_verts3  prim  uv_rgba_verts3
  | UV_RGBA_Vertices4 uv_rgba_verts4 -> render_uv_rgba_verts4  prim  uv_rgba_verts4
 
  | UV_Normal_RGB_Vertices2 uv_norm_rgb_verts2 -> render_uv_norm_rgb_verts2  prim  uv_norm_rgb_verts2
  | UV_Normal_RGB_Vertices3 uv_norm_rgb_verts3 -> render_uv_norm_rgb_verts3  prim  uv_norm_rgb_verts3
  | UV_Normal_RGB_Vertices4 uv_norm_rgb_verts4 -> render_uv_norm_rgb_verts4  prim  uv_norm_rgb_verts4
  | UV_Normal_RGBA_Vertices2 uv_norm_rgba_verts2 -> render_uv_norm_rgba_verts2  prim  uv_norm_rgba_verts2
  | UV_Normal_RGBA_Vertices3 uv_norm_rgba_verts3 -> render_uv_norm_rgba_verts3  prim  uv_norm_rgba_verts3
  | UV_Normal_RGBA_Vertices4 uv_norm_rgba_verts4 -> render_uv_norm_rgba_verts4  prim  uv_norm_rgba_verts4

#endif




(* vim: sw=2 sts=2 ts=2 et fdm=marker filetype=ocaml nowrap
 *)
