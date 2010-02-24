(* {{{ COPYING *(

  +-----------------------------------------------------------------------+
  |  This file belongs to glMLite, an OCaml binding to the OpenGL API.    |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2006, 2007, 2008, 2009  Florent Monnier                |
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

(** {3 VBO : Vertex Buffer Object} *)

(** {{:http://en.wikipedia.org/wiki/Vertex_Buffer_Object}Wikipedia article about
    Vertex Buffer Object} *)

#define NOALLOC "noalloc"
(* http://camltastic.blogspot.com/2008/08/tip-calling-c-functions-directly-with.html
 *)

type vbo_id

external glGenBuffer: unit -> vbo_id = "ml_glgenbuffer" NOALLOC
external glGenBuffers: n:int -> vbo_id array = "ml_glgenbuffers" (* DOES ALLOC *)
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenBuffers.xml}
    manual page} *)

external glDeleteBuffer: vbo:vbo_id -> unit = "ml_gldeletebuffer" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteBuffers.xml}
    manual page} *)

#ifdef MLI
val glDeleteBuffers: vbos:vbo_id array -> unit
#else
let glDeleteBuffers ~vbos = Array.iter (fun vbo -> glDeleteBuffer ~vbo) vbos ;;
#endif


#include "enums/buffer_object_target.inc.ml"

external glBindBuffer: target:buffer_object_target -> vbo:vbo_id -> unit = "ml_glbindbuffer" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindBuffer.xml}
    manual page} *)

external glUnbindBuffer: target:buffer_object_target -> unit = "ml_glunbindbuffer" NOALLOC
(** Equivalent to the function [glBindBuffer] with 0 as vbo_id, as tells
    {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindBuffer.xml}
    the manual} to unbind buffer objects. *)


#include "enums/vbo_usage_pattern.inc.ml"

external glBufferData:
    target:buffer_object_target ->
    size:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t ->
    usage:vbo_usage_pattern ->
    unit
    = "ml_glbufferdata"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBufferData.xml}
    manual page} *)

external glBufferDataNull:
    target:buffer_object_target ->
    size:int ->
    usage:vbo_usage_pattern ->
    unit
    = "ml_glbufferdata_null"
(** same than [glBufferData] but passes a NULL pointer to the data parameter of the C function *)

external glBufferSubData:
    target:buffer_object_target ->
    offset:int ->
    size:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t ->
    unit
    = "ml_glbuffersubdata"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBufferSubData.xml}
    manual page} *)

external elem_size: ba:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> int = "ml_ba_elem_size"
(** this function returns the size in octets of the elements of a bigarray *)

#ifdef MLI
val ba_sizeof: ba:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> int
(** you can use this function to provide the [size] argument of the function [glBufferData] *)
#else
let ba_sizeof ~ba =
  ((Bigarray.Array1.dim ba) * (elem_size ba)) ;;
#endif

type access_policy =
  | GL_READ_ONLY
  | GL_WRITE_ONLY
  | GL_READ_WRITE

type mapped_buffer

(*
  (* wrapping the mapped buffer as a big-array does a segfault
     (but curiously not immediatly, after a while) *)
external glMapBuffer: target:buffer_object_target -> access:access_policy ->
                      ('a, 'b, Bigarray.c_layout) Bigarray.Array1.t = "ml_glmapbuffer"
*)
external glMapBufferAbs: target:buffer_object_target -> access:access_policy -> mapped_buffer = "ml_glmapbuffer_abs"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMapBuffer.xml}
    manual page} *)

external glUnmapBuffer: target:buffer_object_target -> unit = "ml_glunmapbuffer"


external mapped_buffer_blit: mapped_buffer ->
    (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t ->
    len:int -> unit = "mapped_buffer_blit"

external mapped_buffer_blit_ofs: mapped_buffer ->
    (float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t ->
    ofs:int -> len:int -> unit = "mapped_buffer_blit_ofs"


(** params for [glGetBufferParameter], but not used *)
type bo_param =
  | GL_BUFFER_ACCESS
  | GL_BUFFER_MAPPED
  | GL_BUFFER_SIZE
  | GL_BUFFER_USAGE

(** in the C API [glGetBufferParameteriv] can be called with
    [GL_BUFFER_ACCESS], [GL_BUFFER_MAPPED], [GL_BUFFER_SIZE], or [GL_BUFFER_USAGE],
    each of these parameters return a different type, so glGetBufferParameter
    have been wrapped as follow:
     
{ul
    {- glGetBufferParameter [GL_BUFFER_ACCESS] => glGetBufferAccess}
    {- glGetBufferParameter [GL_BUFFER_MAPPED] => glGetBufferMapped}
    {- glGetBufferParameter [GL_BUFFER_SIZE]   => glGetBufferSize}
    {- glGetBufferParameter [GL_BUFFER_USAGE]  => glGetBufferUsage}
}
*)

external glGetBufferAccess: target:buffer_object_target -> access_policy     = "ml_glGetBufferParameter_ACCESS"
external glGetBufferMapped: target:buffer_object_target -> bool              = "ml_glGetBufferParameter_MAPPED"
external glGetBufferSize  : target:buffer_object_target -> int               = "ml_glGetBufferParameter_SIZE"
external glGetBufferUsage : target:buffer_object_target -> vbo_usage_pattern = "ml_glGetBufferParameter_USAGE"

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetBufferParameteriv.xml}
    manual page} *)

(* vim: sw=2 sts=2 ts=2 et fdm=marker filetype=ocaml
 *)
