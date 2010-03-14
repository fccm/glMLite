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

(** {3 Vertex Arrays} *)

(** {{:http://www.opengl.org/documentation/specs/version1.1/glspec1.1/node21.html}
    Vertex Array specs} *)


type client_state =
  | GL_COLOR_ARRAY
  | GL_EDGE_FLAG_ARRAY
  | GL_FOG_COORD_ARRAY
  | GL_INDEX_ARRAY
  | GL_NORMAL_ARRAY
  | GL_SECONDARY_COLOR_ARRAY
  | GL_TEXTURE_COORD_ARRAY
  | GL_VERTEX_ARRAY

external glEnableClientState: client_state:client_state -> unit = "ml_glenableclientstate"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEnableClientState.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glDisableClientState: client_state:client_state -> unit = "ml_gldisableclientstate"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDisableClientState.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)



external glDrawArrays: mode:GL.primitive -> first:int -> count:int -> unit = "ml_gldrawarrays"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawArrays.xml}
    manual page on opengl.org} *)

external glMultiDrawArrays: mode:int -> arr:(int * int) array -> unit = "ml_glmultidrawarrays"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultiDrawArrays.xml}
    manual page on opengl.org} *)

(* TODO
   glMultiDrawElements
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultiDrawElements.xml}
    manual page on opengl.org} *)
*)

external glArrayElement: i:int -> unit = "ml_glarrayelement"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glArrayElement.xml}
    manual page on opengl.org} *)


module Elem = struct
type elem_data_type =
  | GL_UNSIGNED_BYTE
  | GL_UNSIGNED_SHORT
  | GL_UNSIGNED_INT
end

external glDrawElements: mode:GL.primitive -> count:int -> data_type:Elem.elem_data_type ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    (*
    data:(int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
    *)
    -> unit = "ml_gldrawelements"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawElements.xml}
    manual page on opengl.org} *)


external glDrawRangeElements: mode:GL.primitive ->
    start:int -> end_:int ->
    count:int -> data_type:Elem.elem_data_type ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    (*
    data:(int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
    *)
    -> unit = "ml_gldrawrangeelements_bytecode"
              "ml_gldrawrangeelements_native"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawRangeElements.xml}
    manual page on opengl.org} *)


#include "enums/interleaved_format.inc.ml"
external glInterleavedArrays: fmt:interleaved_format -> stride:int -> pointer:
    ('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    -> unit = "ml_glinterleavedarrays"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glInterleavedArrays.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


module Coord = struct
type coord_data_type =
  | GL_SHORT
  | GL_INT
  | GL_FLOAT
  | GL_DOUBLE
end

external glVertexPointer: size:int -> data_type:Coord.coord_data_type -> stride:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    (*
    data:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
    *)
    -> unit = "ml_glvertexpointer"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertexPointer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


external glTexCoordPointer: size:int -> data_type:Coord.coord_data_type -> stride:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    (*
    data:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
    *)
    -> unit = "ml_gltexcoordpointer"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexCoordPointer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


module Norm = struct
type norm_data_type =
  | GL_BYTE
  | GL_SHORT
  | GL_INT
  | GL_FLOAT
  | GL_DOUBLE
end

external glNormalPointer: data_type:Norm.norm_data_type -> stride:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    (*
    data:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
    *)
    -> unit = "ml_glnormalpointer"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNormalPointer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


module Index = struct
type index_data_type =
  | GL_UNSIGNED_BYTE
  | GL_SHORT
  | GL_INT
  | GL_FLOAT
  | GL_DOUBLE
end

external glIndexPointer: data_type:Index.index_data_type -> stride:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    (*
    data:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
    *)
    -> unit = "ml_glindexpointer"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIndexPointer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


module Color = struct
type color_data_type =
  | GL_BYTE
  | GL_UNSIGNED_BYTE
  | GL_SHORT
  | GL_UNSIGNED_SHORT
  | GL_INT
  | GL_UNSIGNED_INT
  | GL_FLOAT
  | GL_DOUBLE
end

external glColorPointer: size:int -> data_type:Color.color_data_type -> stride:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    (*
    data:(float, Bigarray.float32_elt, Bigarray.c_layout) Bigarray.Array1.t
    *)
    -> unit = "ml_glcolorpointer"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColorPointer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)



external glEdgeFlagPointer: stride:int -> 
    data:('a, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
    -> unit = "ml_gledgeflagpointer"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEdgeFlagPointer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


external glSecondaryColorPointer:
    size:int ->
    data_type:Color.color_data_type ->
    stride:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "ml_glsecondarycolorpointer"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSecondaryColorPointer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

(* TODO
glFogCoordPointer  !!! deprecated in core OpenGL 3.2
*)

module VAttr = struct
type vertattr_data_type =
  | GL_BYTE
  | GL_UNSIGNED_BYTE
  | GL_SHORT
  | GL_UNSIGNED_SHORT
  | GL_INT
  | GL_UNSIGNED_INT
  | GL_FLOAT
  | GL_DOUBLE
end

external glVertexAttribPointer:
    index:int ->
    size:int ->
    data_type:VAttr.vertattr_data_type ->
    normalized:bool ->
    stride:int ->
    data:('a, 'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
    = "ml_glvertexattribpointer_bytecode"
      "ml_glvertexattribpointer_native"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertexAttribPointer.xml}
    manual page on opengl.org} *)



(* TODO

http://www.opengl.org/sdk/docs/man/xhtml/glBindAttribLocation.xml
*)


external glVertexPointer0: size:int -> data_type:Coord.coord_data_type -> stride:int -> unit = "ml_glvertexpointer0"
external glTexCoordPointer0: size:int -> data_type:Coord.coord_data_type -> stride:int -> unit = "ml_gltexcoordpointer0"
external glColorPointer0: size:int -> data_type:Color.color_data_type -> stride:int -> unit = "ml_glcolorpointer0"
external glSecondaryColorPointer0: size:int -> data_type:Color.color_data_type -> stride:int -> unit = "ml_glsecondarycolorpointer0"
external glIndexPointer0: data_type:Index.index_data_type -> stride:int -> unit = "ml_glindexpointer0"
external glNormalPointer0: data_type:Norm.norm_data_type -> stride:int -> unit = "ml_glnormalpointer0"
external glEdgeFlagPointer0: stride:int -> unit = "ml_gledgeflagpointer0"
external glVertexAttribPointer0: index:int -> size:int -> data_type:VAttr.vertattr_data_type -> normalized:bool ->
  stride:int -> unit = "ml_glvertexattribpointer0"

external glDrawElements0: mode:GL.primitive -> count:int -> data_type:Elem.elem_data_type -> unit = "ml_gldrawelements0"

(** All the gl*Pointer0 functions are the equivalent of the gl*Pointer
    functions except that the data argument is passed 0 to the C function,
    which is for use with VBOs.

    It is also possible to achieve the same effect by passing an empty bigarray
    to the gl*Pointer functions, but the gl*Pointer0 functions are probably
    more handy. *)


external glVertexPointerOfs8 : size:int -> data_type:Coord.coord_data_type -> stride:int -> ofs:int -> unit = "ml_glvertexpointer_ofs8"
external glVertexPointerOfs16: size:int -> data_type:Coord.coord_data_type -> stride:int -> ofs:int -> unit = "ml_glvertexpointer_ofs16"
external glVertexPointerOfs32: size:int -> data_type:Coord.coord_data_type -> stride:int -> ofs:int -> unit = "ml_glvertexpointer_ofs32"

external glIndexPointerOfs8 : data_type:Index.index_data_type -> stride:int -> ofs:int -> unit = "ml_glindexpointer_ofs8"
external glIndexPointerOfs16: data_type:Index.index_data_type -> stride:int -> ofs:int -> unit = "ml_glindexpointer_ofs16"
external glIndexPointerOfs32: data_type:Index.index_data_type -> stride:int -> ofs:int -> unit = "ml_glindexpointer_ofs32"

external glTexCoordPointerOfs8 : size:int -> data_type:Coord.coord_data_type -> stride:int -> ofs:int -> unit = "ml_gltexcoordpointer_ofs8"
external glTexCoordPointerOfs16: size:int -> data_type:Coord.coord_data_type -> stride:int -> ofs:int -> unit = "ml_gltexcoordpointer_ofs16"
external glTexCoordPointerOfs32: size:int -> data_type:Coord.coord_data_type -> stride:int -> ofs:int -> unit = "ml_gltexcoordpointer_ofs32"

external glColorPointerOfs8 : size:int -> data_type:Color.color_data_type -> stride:int -> ofs:int -> unit = "ml_glcolorpointer_ofs8"
external glColorPointerOfs16: size:int -> data_type:Color.color_data_type -> stride:int -> ofs:int -> unit = "ml_glcolorpointer_ofs16"
external glColorPointerOfs32: size:int -> data_type:Color.color_data_type -> stride:int -> ofs:int -> unit = "ml_glcolorpointer_ofs32"

external glSecondaryColorPointerOfs8 : size:int -> data_type:Color.color_data_type -> stride:int -> unit = "ml_glsecondarycolorpointer_ofs8"
external glSecondaryColorPointerOfs16: size:int -> data_type:Color.color_data_type -> stride:int -> unit = "ml_glsecondarycolorpointer_ofs16"
external glSecondaryColorPointerOfs32: size:int -> data_type:Color.color_data_type -> stride:int -> unit = "ml_glsecondarycolorpointer_ofs32"

external glNormalPointerOfs8 : data_type:Norm.norm_data_type -> stride:int -> ofs:int -> unit = "ml_glnormalpointer_ofs8"
external glNormalPointerOfs16: data_type:Norm.norm_data_type -> stride:int -> ofs:int -> unit = "ml_glnormalpointer_ofs16"
external glNormalPointerOfs32: data_type:Norm.norm_data_type -> stride:int -> ofs:int -> unit = "ml_glnormalpointer_ofs32"

external glEdgeFlagPointerOfs8 : stride:int -> ofs:int -> unit = "ml_gledgeflagpointer_ofs8"
external glEdgeFlagPointerOfs16: stride:int -> ofs:int -> unit = "ml_gledgeflagpointer_ofs16"
external glEdgeFlagPointerOfs32: stride:int -> ofs:int -> unit = "ml_gledgeflagpointer_ofs32"

external glVertexAttribPointerOfs8 : index:int -> size:int -> data_type:VAttr.vertattr_data_type -> normalized:bool -> stride:int -> ofs:int -> unit = "ml_glvertexattribpointer_ofs8_bytecode" "ml_glvertexattribpointer_ofs8_native"
external glVertexAttribPointerOfs16: index:int -> size:int -> data_type:VAttr.vertattr_data_type -> normalized:bool -> stride:int -> ofs:int -> unit = "ml_glvertexattribpointer_ofs16_bytecode" "ml_glvertexattribpointer_ofs16_native"
external glVertexAttribPointerOfs32: index:int -> size:int -> data_type:VAttr.vertattr_data_type -> normalized:bool -> stride:int -> ofs:int -> unit = "ml_glvertexattribpointer_ofs32_bytecode" "ml_glvertexattribpointer_ofs32_native"

(** All the gl*PointerOfs functions are the equivalent of the gl*Pointer0
    functions but with pointer arithmetic (NULL + ofs), (for use with VBOs)

    Pointer arithmetic depends of the size of the pointed data, so there are
    different versions of these functions for elements of size 8, 16 or 32 bits. *)


external glDrawElementsOfs8 : mode:GL.primitive -> count:int -> data_type:Elem.elem_data_type -> ofs:int -> unit = "ml_gldrawelements_ofs8"
external glDrawElementsOfs16: mode:GL.primitive -> count:int -> data_type:Elem.elem_data_type -> ofs:int -> unit = "ml_gldrawelements_ofs16"
external glDrawElementsOfs32: mode:GL.primitive -> count:int -> data_type:Elem.elem_data_type -> ofs:int -> unit = "ml_gldrawelements_ofs32"


(** {3 VAO's} *)

external glGenVertexArray: unit -> int = "ml_glgenvertexarray"
external glBindVertexArray: int -> unit = "ml_glbindvertexarray"
external glDeleteVertexArray: int -> unit = "ml_gldeletevertexarray"
external glIsVertexArray: int -> bool = "ml_glisvertexarray"


(* vim: sw=2 sts=2 ts=2 et fdm=marker filetype=ocaml nowrap
 *)
