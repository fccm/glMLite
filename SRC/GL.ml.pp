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

#define NOALLOC "noalloc"
(* http://camltastic.blogspot.com/2008/08/tip-calling-c-functions-directly-with.html
 *)

(** OpenGL functions *)

(**
{{:http://www.opengl.org/documentation/specs/version1.1/glspec1.1/}OpenGL Specifications}

{{:http://www.opengl.org/resources/faq/technical/}OpenGL FAQ}
*)

(*
http://www.opengl.org/code/
*)

(** {3 Drawing Functions} *)

#include "enums/primitive.inc.ml"

external glBegin: primitive:primitive -> unit = "ml_glbegin" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBegin.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glEnd: unit -> unit = "ml_glend" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEnd.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glVertex2: x:float -> y:float -> unit = "ml_glvertex2" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertex.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glVertex3: x:float -> y:float -> z:float -> unit = "ml_glvertex3" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertex.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glVertex4: x:float -> y:float -> z:float -> w:float -> unit = "ml_glvertex4" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertex.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glVertex2v: float * float -> unit = "ml_glvertex2v" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertex.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glVertex3v: float * float * float -> unit = "ml_glvertex3v" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertex.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glVertex4v: float * float * float * float -> unit = "ml_glvertex4v" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertex.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glNormal3: nx:float -> ny:float -> nz:float -> unit = "ml_glnormal3" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNormal.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glNormal3v: v:float * float * float -> unit = "ml_glnormal3v" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNormal.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glIndex: c:float -> unit = "ml_glindexd" NOALLOC
external glIndexi: c:int -> unit = "ml_glindexi" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIndex.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glColor3: r:float -> g:float -> b:float -> unit = "ml_glcolor3" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColor.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glColor4: r:float -> g:float -> b:float -> a:float -> unit = "ml_glcolor4" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColor.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glColor3v: v:float * float * float -> unit = "ml_glcolor3v" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColor.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glColor4v: v:float * float * float * float -> unit = "ml_glcolor4v" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColor.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glColor3c: r:char -> g:char -> b:char -> unit = "ml_glcolor3c" NOALLOC
external glColor4c: r:char -> g:char -> b:char -> a:char -> unit = "ml_glcolor4c" NOALLOC
(** not clamped to range [\[0.0 - 1.0\]] but [\['\000' - '\255'\]] *)

external glColor3cv: v:char * char * char -> unit = "ml_glcolor3cv" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColor.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glColor4cv: v:char * char * char * char -> unit = "ml_glcolor4cv" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColor.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glEdgeFlag: flag:bool -> unit = "ml_gledgeflag" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEdgeFlag.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glRasterPos2: x:float -> y:float -> unit = "ml_glrasterpos2d" NOALLOC
external glRasterPos3: x:float -> y:float -> z:float -> unit = "ml_glrasterpos3d" NOALLOC
external glRasterPos4: x:float -> y:float -> z:float -> w:float -> unit = "ml_glrasterpos4d" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRasterPos.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glRasterPos2i: x:int -> y:int -> unit = "ml_glrasterpos2i" NOALLOC
external glRasterPos3i: x:int -> y:int -> z:int -> unit = "ml_glrasterpos3i" NOALLOC
external glRasterPos4i: x:int -> y:int -> z:int -> w:int -> unit = "ml_glrasterpos4i" NOALLOC

external glRasterPos2v: v:float * float -> unit = "ml_glrasterpos2dv" NOALLOC
external glRasterPos3v: v:float * float * float -> unit = "ml_glrasterpos3dv" NOALLOC
external glRasterPos4v: v:float * float * float * float -> unit = "ml_glrasterpos4dv" NOALLOC
external glRasterPos2iv: v:int * int -> unit = "ml_glrasterpos2iv" NOALLOC
external glRasterPos3iv: v:int * int * int -> unit = "ml_glrasterpos3iv" NOALLOC
external glRasterPos4iv: v:int * int * int * int -> unit = "ml_glrasterpos4iv" NOALLOC

(** All glRasterPos* functions are deprecated in core OpenGL 3. *)

external glRecti: x1:int -> y1:int -> x2:int -> y2:int -> unit = "ml_glrecti" NOALLOC
external glRect: x1:float -> y1:float -> x2:float -> y2:float -> unit = "ml_glrect" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRect.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


(** {3 Transformations} *)

#include "enums/matrix_mode.inc.ml"
external glMatrixMode: mode:matrix_mode -> unit = "ml_glmatrixmode" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMatrixMode.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glViewport: x:int -> y:int -> width:int -> height:int -> unit = "ml_glviewport" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glViewport.xml}
    manual page on opengl.org} *)

external glOrtho: left:float -> right:float -> bottom:float ->
                  top:float -> near:float -> far:float -> unit
         = "ml_glortho_bytecode"
           "ml_glortho_native"
           NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glOrtho.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glFrustum: left:float -> right:float -> bottom:float ->
                    top:float -> near:float -> far:float -> unit
         = "ml_glfrustum_bytecode"
           "ml_glfrustum_native"
           NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFrustum.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glPushMatrix: unit -> unit = "ml_glpushmatrix" NOALLOC
external glPopMatrix: unit -> unit = "ml_glpopmatrix" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPushMatrix.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glLoadIdentity: unit -> unit = "ml_glloadidentity" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadIdentity.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


external glRotatev: angle:float -> vec:float * float * float -> unit = "ml_glrotatev" NOALLOC
external glRotate: angle:float -> x:float -> y:float -> z:float -> unit = "ml_glrotate" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRotate.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glTranslatev: float * float * float -> unit = "ml_gltranslatev" NOALLOC
external glTranslate: x:float -> y:float -> z:float -> unit = "ml_gltranslate" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTranslate.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glScalev: float * float * float -> unit = "ml_glscalev" NOALLOC
external glScale: x:float -> y:float -> z:float -> unit = "ml_glscale" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glScale.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

(* TODO
glMultTransposeMatrix
glLoadTransposeMatrix
*)

(* {{{ glMultMatrix *)
#ifdef MLI

val glMultMatrix: mat:float array array -> unit
(** checks the matrix given is 4x4 with assertions

    {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultMatrix.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

#else
(* ML *)

external _glMultMatrix: mat:float array array -> unit = "ml_glmultmatrixd" NOALLOC

let glMultMatrix ~mat =
  (*
  assert(Array.length mat = 4);
  for i = 0 to 3 do
    let line = Array.unsafe_get mat i in
    assert(Array.length line = 4);
  done;
  *)
  assert(Array.length mat = 4
     && (Array.length (Array.unsafe_get mat 0) = 4)
     && (Array.length (Array.unsafe_get mat 1) = 4)
     && (Array.length (Array.unsafe_get mat 2) = 4)
     && (Array.length (Array.unsafe_get mat 3) = 4)
    );
  _glMultMatrix ~mat
;;

#endif
(* }}} *)

external glMultMatrixFlat: float array -> unit = "ml_glmultmatrixd_flat" NOALLOC
(** same than [glMultMatrix] but with an array of length 16

    {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultMatrix.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glMultMatrixFlat_unsafe: float array -> unit = "ml_glmultmatrixd_flat_unsafe"
(** same than [glMultMatrixFlat] but doesn't make any checks.
    @deprecated in core OpenGL 3. *)


(* {{{ glLoadMatrix *)
#ifdef MLI

val glLoadMatrix: mat:float array array -> unit
(** checks the matrix given is 4x4 with assertions

    {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadMatrix.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

#else
(* ML *)

external _glLoadMatrix: mat:float array array -> unit = "ml_glloadmatrixd" NOALLOC

let glLoadMatrix ~mat =
  (*
  assert(Array.length mat = 4);
  for i = 0 to 3 do
    let line = Array.unsafe_get mat i in
    assert(Array.length line = 4);
  done;
  *)
  assert(Array.length mat = 4
     && (Array.length (Array.unsafe_get mat 0) = 4)
     && (Array.length (Array.unsafe_get mat 1) = 4)
     && (Array.length (Array.unsafe_get mat 2) = 4)
     && (Array.length (Array.unsafe_get mat 3) = 4)
    );
  _glLoadMatrix ~mat
;;

#endif
(* }}} *)

external glLoadMatrixFlat: float array -> unit = "ml_glloadmatrixd_flat" NOALLOC
(** as [glLoadMatrix] but with an array of length 16

    {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadMatrix.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glLoadMatrixFlat_unsafe: float array -> unit = "ml_glloadmatrixd_flat_unsafe" NOALLOC
(** same than [glLoadMatrixFlat] but doesn't make any checks
    @deprecated in core OpenGL 3. *)



(** {3 Miscellaneous} *)

external glFlush: unit -> unit = "ml_glflush" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFlush.xml}
    manual page on opengl.org} *)

#include "enums/orientation.inc.ml"
external glFrontFace: orientation:orientation -> unit = "ml_glfrontface" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFrontFace.xml}
    manual page on opengl.org} *)

external glScissor: x:int -> y:int -> width:int -> height:int -> unit = "ml_glscissor" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glScissor.xml}
    manual page on opengl.org} *)

external glFinish: unit -> unit = "ml_glfinish" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFinish.xml}
    manual page on opengl.org} *)


external glClearColor: r:float -> g:float -> b:float -> a:float -> unit = "ml_glclearcolor" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearColor.xml}
    manual page on opengl.org} *)

external glClearIndex: float -> unit = "ml_glclearindex" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearIndex.xml}
    manual page on opengl.org} *)

external glColorMask: r:bool -> g:bool -> b:bool -> a:bool -> unit = "ml_glcolormask" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColorMask.xml}
    manual page on opengl.org} *)


module Attrib = struct (* PACK_ENUM *)
#include "enums/attrib_bit.inc.ml"
end (* PACK_ENUM *)
external glPushAttrib: attrib:Attrib.attrib_bit list -> unit = "ml_glpushattrib" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPushAttrib.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glPopAttrib: unit -> unit = "ml_glpopattrib" NOALLOC
(** @deprecated in core OpenGL 3. *)


#include "enums/face_mode.inc.ml"
#include "enums/polygon_mode.inc.ml"
external glPolygonMode: face:face_mode -> mode:polygon_mode -> unit = "ml_glpolygonmode" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPolygonMode.xml}
    manual page on opengl.org} *)

external glGetPolygonMode: unit -> polygon_mode * polygon_mode = "ml_glgetpolygonmode"
(** glGet with argument GL_POLYGON_MODE
    {{:http://www.opengl.org/sdk/docs/man/xhtml/glGet.xml}
    manual page on opengl.org} *)

#include "enums/clear_mask.inc.ml"
external glClear: mask:clear_mask list -> unit = "ml_glclear" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClear.xml}
    manual page on opengl.org} *)


external glLineWidth: width:float -> unit = "ml_gllinewidth" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLineWidth.xml}
    manual page on opengl.org}.
    In OpenGL 3, this function does not support values greater than 1.0 anymore. *)

external glPointSize: size:float -> unit = "ml_glpointsize" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPointSize.xml}
    manual page on opengl.org} *)

(* {{{ glPointParameter *)

type sprite_coord_origin = GL_LOWER_LEFT | GL_UPPER_LEFT

type point_parameter =
  | GL_POINT_SIZE_MIN of float
  | GL_POINT_SIZE_MAX of float
  | GL_POINT_FADE_THRESHOLD_SIZE of float
  | GL_POINT_DISTANCE_ATTENUATION of float * float * float
  | GL_POINT_SPRITE_COORD_ORIGIN of sprite_coord_origin

#ifdef MLI

(* glext *)

val glPointParameter: point_parameter -> unit
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPointParameter.xml}
    manual page on opengl.org} *)

#else
(* ML *)

external glPointParameterf: int -> float -> unit = "ml_glpointparameterf" NOALLOC
external glPointParameterfv: float -> float -> float -> unit = "ml_glpointparameterfv" NOALLOC
external glPointParameteri: sprite_coord_origin -> unit = "ml_glpointparameteri" NOALLOC

let glPointParameter = function
  | GL_POINT_SIZE_MIN param -> glPointParameterf 0 param;
  | GL_POINT_SIZE_MAX param -> glPointParameterf 1 param;
  | GL_POINT_FADE_THRESHOLD_SIZE param -> glPointParameterf 2 param;
  | GL_POINT_DISTANCE_ATTENUATION(d1, d2, d3) -> glPointParameterfv d1 d2 d3;
  | GL_POINT_SPRITE_COORD_ORIGIN param -> glPointParameteri param;
;;

#endif
(* }}} *)


#include "enums/gl_func.inc.ml"

external glAlphaFunc: func:gl_func -> ref:float -> unit = "ml_glalphafunc" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glAlphaFunc.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

#include "enums/hint_target.inc.ml"
#include "enums/hint_mode.inc.ml"
external glHint: target:hint_target -> mode:hint_mode -> unit = "ml_glhint" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glHint.xml}
    manual page on opengl.org} *)

external glCullFace: mode:face_mode -> unit = "ml_glcullface" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCullFace.xml}
    manual page on opengl.org} *)

(* TODO
test this function:
*)
external glGetCullFaceMode: unit -> face_mode = "ml_glgetcullfacemode" NOALLOC
(** associated get for {!glCullFace} *)

external glLineStipple: factor:int -> pattern:int -> unit = "ml_gllinestipple" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLineStipple.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

type polygon_stipple_mask = (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
external glPolygonStipple: mask:polygon_stipple_mask -> unit = "ml_glpolygonstipple" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPolygonStipple.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glPolygonStipple_unsafe: mask:polygon_stipple_mask -> unit = "ml_glpolygonstipple_unsafe" NOALLOC
(** Same than [glPolygonStipple] but does not check the size of the big array.
    @deprecated in core OpenGL 3. *)

module DrawBuffer = struct (* PACK_ENUM *)
#include "enums/draw_buffer_mode.inc.ml"
end (* PACK_ENUM *)
external glDrawBuffer: mode:DrawBuffer.draw_buffer_mode -> unit = "ml_gldrawbuffer" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDrawBuffer.xml}
    manual page on opengl.org} *)

module ReadBuffer = struct (* PACK_ENUM *)
#include "enums/read_buffer_mode.inc.ml"
end (* PACK_ENUM *)
external glReadBuffer: mode:ReadBuffer.read_buffer_mode -> unit = "ml_glreadbuffer" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glReadBuffer.xml}
    manual page on opengl.org} *)


module Sfactor = struct (* PACK_ENUM *)
#include "enums/blend_sfactor.inc.ml"
end (* PACK_ENUM *)
module Dfactor = struct (* PACK_ENUM *)
#include "enums/blend_dfactor.inc.ml"
end (* PACK_ENUM *)
external glBlendFunc: sfactor:Sfactor.blend_sfactor -> dfactor:Dfactor.blend_dfactor -> unit = "ml_glblendfunc" NOALLOC
(**
  {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlendFunc.xml}
  manual page on opengl.org} ;
  {{:http://www.opengl.org/resources/faq/technical/transparency.htm}
  Transparency, Translucency, and Blending Chapter}
*)

(* TODO
glBlendFuncSeparate
http://www.opengl.org/sdk/docs/man/xhtml/glBlendFuncSeparate.xml
*)

#include "enums/blend_mode.inc.ml"
external glBlendEquation: mode:blend_mode -> unit = "ml_glblendequation" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBlendEquation.xml}
    manual page on opengl.org} *)

(*
#include "enums/blend_mode_ext.inc.ml"
external glBlendEquationEXT: mode:blend_mode_ext -> unit = "ml_glblendequationext"
(** {{:http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?db=man&fname=/usr/share/catman/g_man/cat3/OpenGL/glblendequationext.z}
    man page on sgi.com} *)
*)

module Op = struct (* PACK_ENUM *)
#include "enums/op_code.inc.ml"
end (* PACK_ENUM *)
external glLogicOp: opcode:Op.op_code -> unit = "ml_gllogicop" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLogicOp.xml}
    manual page on opengl.org} *)


(* TODO
glIndexMask
*)

external glPolygonOffset: factor:float -> units:float -> unit = "ml_glpolygonoffset" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPolygonOffset.xml}
    manual page on opengl.org} *)




(** {3 Lighting} *)

#include "enums/shade_mode.inc.ml"
external glShadeModel: shade_mode -> unit = "ml_glshademodel" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glShadeModel.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

(* TODO
glGet with argument GL_SHADE_MODEL
*)

(* {{{ glLight *)

module Light = struct (* _PACK_ENUM *)
type light_pname =
  | GL_SPOT_EXPONENT of float
  | GL_SPOT_CUTOFF of float
  | GL_CONSTANT_ATTENUATION of float
  | GL_LINEAR_ATTENUATION of float
  | GL_QUADRATIC_ATTENUATION of float
  | GL_SPOT_DIRECTION of (float * float * float)
  | GL_AMBIENT of (float * float * float * float)
  | GL_DIFFUSE of (float * float * float * float)
  | GL_SPECULAR of (float * float * float * float)
  | GL_POSITION of (float * float * float * float)
end (* _PACK_ENUM *)

type gl_light = GL_LIGHT of int

#ifdef MLI

val glLight: light:gl_light -> pname:Light.light_pname -> unit
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLight.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

#else
(* ML *)

external _glLight1: light_i:int -> pname:int -> param:float -> unit = "ml_gllight1" NOALLOC
external _glLight3: light_i:int -> float -> float -> float -> unit = "ml_gllight3" NOALLOC
external _glLight4: light_i:int -> pname:int -> float -> float -> float -> float -> unit
         = "ml_gllight4_bytecode"
           "ml_gllight4_native"
           NOALLOC

let glLight ~light ~pname =
  let light_i =
    match light with GL_LIGHT i -> i
  in
  match pname with
  | Light.GL_SPOT_EXPONENT param         -> _glLight1 light_i 0 param
  | Light.GL_SPOT_CUTOFF param           -> _glLight1 light_i 1 param
  | Light.GL_CONSTANT_ATTENUATION param  -> _glLight1 light_i 2 param
  | Light.GL_LINEAR_ATTENUATION param    -> _glLight1 light_i 3 param
  | Light.GL_QUADRATIC_ATTENUATION param -> _glLight1 light_i 4 param

  | Light.GL_SPOT_DIRECTION(p1, p2, p3) -> _glLight3 light_i p1 p2 p3

  | Light.GL_AMBIENT (p1, p2, p3, p4) -> _glLight4 light_i 0 p1 p2 p3 p4
  | Light.GL_DIFFUSE (p1, p2, p3, p4) -> _glLight4 light_i 1 p1 p2 p3 p4
  | Light.GL_SPECULAR(p1, p2, p3, p4) -> _glLight4 light_i 2 p1 p2 p3 p4
  | Light.GL_POSITION(p1, p2, p3, p4) -> _glLight4 light_i 3 p1 p2 p3 p4
;;

#endif
(* }}} *)
(* {{{ glLightModel *)

type color_control =
  | GL_SEPARATE_SPECULAR_COLOR
  | GL_SINGLE_COLOR

type light_model =
  | GL_LIGHT_MODEL_AMBIENT of (float * float * float * float)
  | GL_LIGHT_MODEL_COLOR_CONTROL of color_control
  | GL_LIGHT_MODEL_LOCAL_VIEWER of bool
  | GL_LIGHT_MODEL_TWO_SIDE of bool

#ifdef MLI

val glLightModel: light_model:light_model -> unit
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLightModel.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

(** See [glGetLight] for associated get. *)

#else
(* ML *)

external _glLightModel1: int -> unit = "ml_glLightModel1" NOALLOC
external _glLightModel2: int -> bool -> unit = "ml_glLightModel2" NOALLOC
external _glLightModel4: float -> float -> float -> float -> unit = "ml_glLightModel4" NOALLOC

let glLightModel ~light_model =
  match light_model with
  | GL_LIGHT_MODEL_COLOR_CONTROL  GL_SEPARATE_SPECULAR_COLOR -> _glLightModel1 0;
  | GL_LIGHT_MODEL_COLOR_CONTROL  GL_SINGLE_COLOR            -> _glLightModel1 1;
  | GL_LIGHT_MODEL_LOCAL_VIEWER p -> _glLightModel2 0 p;
  | GL_LIGHT_MODEL_TWO_SIDE p     -> _glLightModel2 1 p;
  | GL_LIGHT_MODEL_AMBIENT(r, g, b, a) -> _glLightModel4 r g b a;
;;

#endif
(* }}} *)


(* {{{ glMaterial *)

module Material = struct (* _PACK_ENUM *)
type material_mode =
  | GL_AMBIENT of (float * float * float * float)
  | GL_DIFFUSE of (float * float * float * float)
  | GL_SPECULAR of (float * float * float * float)
  | GL_EMISSION of (float * float * float * float)
  | GL_SHININESS of float
  | GL_AMBIENT_AND_DIFFUSE of (float * float * float * float)
  | GL_COLOR_INDEXES of (int * int * int)  (* TODO: check if these should be floats *)
end (* _PACK_ENUM *)

#ifdef MLI

val glMaterial: face:face_mode -> mode:Material.material_mode -> unit
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMaterial.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

#else
(* ML *)

external _glMaterial1: face_mode -> float -> unit = "ml_glmaterial1" NOALLOC
external _glMaterial3: face_mode -> int -> int -> int -> unit = "ml_glmaterial3i" NOALLOC
external _glMaterial4: face_mode -> int -> float -> float -> float -> float -> unit
    = "ml_glmaterial4_bytecode"
      "ml_glmaterial4_native"
      NOALLOC

let glMaterial ~face ~mode =
  match mode with
  | Material.GL_SHININESS p -> _glMaterial1 face p
  | Material.GL_AMBIENT  (p1, p2, p3, p4) -> _glMaterial4 face 0 p1 p2 p3 p4
  | Material.GL_DIFFUSE  (p1, p2, p3, p4) -> _glMaterial4 face 1 p1 p2 p3 p4
  | Material.GL_SPECULAR (p1, p2, p3, p4) -> _glMaterial4 face 2 p1 p2 p3 p4
  | Material.GL_EMISSION (p1, p2, p3, p4) -> _glMaterial4 face 3 p1 p2 p3 p4
  | Material.GL_AMBIENT_AND_DIFFUSE (p1, p2, p3, p4) -> _glMaterial4 face 4 p1 p2 p3 p4
  | Material.GL_COLOR_INDEXES (p1, p2, p3) -> _glMaterial3 face p1 p2 p3
;;

#endif

(* }}} *)


module GetMat = struct (* _PACK_ENUM *)
type face_mode = GL_FRONT | GL_BACK
type get_material_4f =
  | GL_AMBIENT
  | GL_DIFFUSE
  | GL_SPECULAR
  | GL_EMISSION
type get_material_1f =
  | GL_SHININESS
type get_material_3i =
  | GL_COLOR_INDEXES  (* TODO: check if these should be floats *)
end (* _PACK_ENUM *)

external glGetMaterial4f: GetMat.face_mode -> mode:GetMat.get_material_4f -> float * float * float * float = "ml_glgetmaterial4f"
external glGetMaterial1f: GetMat.face_mode -> mode:GetMat.get_material_1f -> float = "ml_glgetmaterial1f"
external glGetMaterial3i: GetMat.face_mode -> mode:GetMat.get_material_3i -> int * int * int = "ml_glgetmaterial3i"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetMaterial.xml}
    manual page on opengl.org} *)


#include "enums/color_material_mode.inc.ml"
external glColorMaterial: face:face_mode -> mode:color_material_mode -> unit = "ml_glcolormaterial" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glColorMaterial.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


external glSecondaryColor3: red:float -> green:float -> blue:float -> unit = "ml_glsecondarycolor3d" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSecondaryColor.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)
(* TODO
glSecondaryColor3c
glSecondaryColor3v
glSecondaryColor3cv
*)



(** {3 Stenciling} *)

external glStencilFunc: func:gl_func -> ref:int -> mask:int -> unit = "ml_glstencilfunc" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilFunc.xml}
    manual page on opengl.org} *)

external glStencilFuncn: func:gl_func -> ref:int -> mask:nativeint -> unit = "ml_glstencilfuncn" NOALLOC
(** OCaml standard ints have 1 bit missing from nativeint. *)

external glStencilMask: mask:int -> unit = "ml_glstencilmask" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilMask.xml}
    manual page on opengl.org} *)

(* TODO: get the full range of the GLuint
void glStencilMask( GLuint mask );
*)

#include "enums/stencil_op.inc.ml"
external glStencilOp: sfail:stencil_op -> dpfail:stencil_op -> dppass:stencil_op -> unit = "ml_glstencilop" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glStencilOp.xml}
    manual page on opengl.org} *)

external glClearStencil: s:int -> unit = "ml_glclearstencil" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearStencil.xml}
    manual page on opengl.org} *)





(** {3 Depth Buffer} *)

external glDepthRange: near:float -> far:float -> unit = "ml_gldepthrange" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDepthRange.xml}
    manual page on opengl.org} *)

external glClearDepth: depth:float -> unit = "ml_glcleardepth" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearDepth.xml}
    manual page on opengl.org} *)

external glDepthFunc: func:gl_func -> unit = "ml_gldepthfunc" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDepthFunc.xml}
    manual page on opengl.org} *)

external glDepthMask: bool -> unit = "ml_gldepthmask" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDepthMask.xml}
    manual page on opengl.org} *)



(** {3 Accumulation Buffer} *)

#include "enums/accum_op.inc.ml"
external glAccum: op:accum_op -> value:float -> unit = "ml_glaccum" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glAccum.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glClearAccum: r:float -> g:float -> b:float -> a:float -> unit = "ml_glclearaccum" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClearAccum.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)



(** {3 GL Capabilities} *)

#include "enums/gl_capability.inc.ml"
external glEnable: cap:gl_capability -> unit = "ml_glenable" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEnable.xml}
    manual page on opengl.org} *)
external glDisable: cap:gl_capability -> unit = "ml_gldisable" NOALLOC


module Enabled = struct (* PACK_ENUM *)
#include "enums/enabled_cap.inc.ml"
end (* PACK_ENUM *)
external glIsEnabled: Enabled.enabled_cap -> bool = "ml_glisenabled" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsEnabled.xml}
    manual page on opengl.org} *)



(** {3 Texture mapping} *)

type texture_id = private int
external glGenTextures: n:int -> texture_id array = "ml_glgentextures" (* DOES ALLOC *)
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenTextures.xml}
    manual page on opengl.org} *)

external glGenTexture: unit -> texture_id = "ml_glgentexture" NOALLOC

module BindTex = struct (* PACK_ENUM *)
#include "enums/texture_binding.inc.ml"
end (* PACK_ENUM *)
external glBindTexture: target:BindTex.texture_binding -> texture:texture_id -> unit = "ml_glbindtexture" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindTexture.xml}
    manual page on opengl.org} *)

external glUnbindTexture: target:BindTex.texture_binding -> unit = "ml_glunbindtexture" NOALLOC
(* deactive the previous active texture
   (is equivalent to the C call glBindTexture(target, 0)) *)

external glBindTexture2D: texture:texture_id -> unit = "ml_glbindtexture2d" NOALLOC
(** equivalent to [glBindTexture] with parameter [GL_TEXTURE_2D] *)

external glUnbindTexture2D: unit -> unit = "ml_glunbindtexture2d" NOALLOC
(* deactive the previous active texture
   (is equivalent to the C call glBindTexture(GL_TEXTURE_2D, 0)) *)

external glDeleteTextures: textures:texture_id array -> unit = "ml_gldeletetextures" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteTextures.xml}
    manual page on opengl.org} *)

external glDeleteTexture: texture:texture_id -> unit = "ml_gldeletetexture" NOALLOC

external glIsTexture: texture:texture_id -> bool = "ml_glistexture" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsTexture.xml}
    manual page on opengl.org} *)

external glPrioritizeTextures: textures:texture_id array -> priority:float array -> unit = "ml_glprioritizetextures" NOALLOC
external glPrioritizeTexture: texture:texture_id -> priority:float -> unit = "ml_glprioritizetexture" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPrioritizeTextures.xml}
    manual page on opengl.org} *)

external glPrioritizeTexturesp: prioritized_textures:(texture_id * float) array -> unit = "ml_glprioritizetexturesp" NOALLOC

(* TODO
type target = GL_TEXTURE_ENV | GL_TEXTURE_FILTER_CONTROL | GL_POINT_SPRITE
type pname =
    GL_TEXTURE_ENV_MODE
  | GL_TEXTURE_LOD_BIAS
  | GL_COMBINE_RGB
  | GL_COMBINE_ALPHA
  | GL_SRC0_RGB
  | GL_SRC1_RGB
  | GL_SRC2_RGB
  | GL_SRC0_ALPHA
  | GL_SRC1_ALPHA
  | GL_SRC2_ALPHA
  | GL_OPERAND0_RGB
  | GL_OPERAND1_RGB
  | GL_OPERAND2_RGB
  | GL_OPERAND0_ALPHA
  | GL_OPERAND1_ALPHA
  | GL_OPERAND2_ALPHA
  | GL_RGB_SCALE
  | GL_ALPHA_SCALE
  | GL_COORD_REPLACE
type param =
    GL_ADD
  | GL_ADD_SIGNED
  | GL_INTERPOLATE
  | GL_MODULATE
  | GL_DECAL
  | GL_BLEND
  | GL_REPLACE
  | GL_SUBTRACT
  | GL_COMBINE
  | GL_TEXTURE
  | GL_CONSTANT
  | GL_PRIMARY_COLOR
  | GL_PREVIOUS
  | GL_SRC_COLOR
  | GL_ONE_MINUS_SRC_COLOR
  | GL_SRC_ALPHA
  | GL_ONE_MINUS_SRC_ALPHA
  (* a single boolean value for the point sprite texture coordinate replacement,
     a single floating-point value for the texture level-of-detail bias, or 1.0,
     2.0, or 4.0 when specifying the GL_RGB_SCALE or GL_ALPHA_SCALE. *)

void glTexEnvfv( GLenum target, GLenum pname, const GLfloat * params);
void glTexEnviv( GLenum target, GLenum pname, const GLint * params);

void glTexEnvf( GLenum target, GLenum pname, GLfloat  param);
void glTexEnvi( GLenum target, GLenum pname, GLint  param);


type target = GL_TEXTURE_ENV | GL_TEXTURE_FILTER_CONTROL
type pname = GL_TEXTURE_ENV_MODE | GL_TEXTURE_ENV_COLOR of rgba | GL_TEXTURE_LOD_BIAS
type params = (* Specifies a pointer to a parameter array that contains either
     a single symbolic constant,
     single floating-point number,
     or an RGBA color. *)
*)
module TexEnv = struct (* PACK_ENUM *)
#include "enums/texenv_target.inc.ml"
#include "enums/texenv_pname.inc.ml"
#include "enums/texenv_param.inc.ml"
end (* PACK_ENUM *)
(*
type texenv_scale = SCALE_1 | SCALE_2 | SCALE_4
  | GL_RGB_SCALE of texenv_scale
  | GL_ALPHA_SCALE of texenv_scale
*)
external glTexEnv: TexEnv.texenv_target -> TexEnv.texenv_pname -> TexEnv.texenv_param -> unit = "ml_gltexenv" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexEnv.xml}
    manual page on opengl.org} *)

#include "enums/tex_coord.inc.ml"
#include "enums/tex_coord_gen_func.inc.ml"
#include "enums/tex_gen_param.inc.ml"
external glTexGen: tex_coord -> tex_coord_gen_func -> tex_gen_param -> unit = "ml_gltexgen" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexGen.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

#include "enums/tex_coord_fun_params.inc.ml"

external glTexGenv: tex_coord -> tex_coord_fun_params -> float * float * float * float -> unit = "ml_gltexgenv"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexGen.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glTexGenva: tex_coord -> tex_coord_fun_params -> float array -> unit = "ml_gltexgenva"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexGen.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


module TexTarget = struct (* _PACK_ENUM *)
#include "enums/target_2d.inc.ml"

type target_1d = GL_TEXTURE_1D | GL_PROXY_TEXTURE_1D
type target_3d = GL_TEXTURE_3D | GL_PROXY_TEXTURE_3D
end (* _PACK_ENUM *)

module InternalFormat = struct (* PACK_ENUM *)
#include "enums/internal_format.inc.ml"
end (* PACK_ENUM *)
#include "enums/pixel_data_format.inc.ml"
#include "enums/pixel_data_type.inc.ml"

(** input type to provide the textures *)
type img_input =
  | Filename of string  (** provide the filename of a texture *)
  | Buffer of string    (** provide the image data as a buffer *)

(*
type image_data
*)
type image_data =
  (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.(*Array3*)Genarray.t


#ifdef MLI
val assert_size : width:int -> height:int -> unit
(** utility function to check if the dimensions of the image are compatible with OpenGL textures. *)
#else
(* ML *)
let assert_size ~width ~height =
  let allowed = [64; 128; 256; 512; 1024; 2048] in
  if not(List.mem width allowed &&
         List.mem height allowed) then
    invalid_arg "image dimensions not compatible with OpenGL"
;;
#endif
 

(* TODO
 add all new type for recent GL versions
*)
external glTexImage2D:
    target:TexTarget.target_2d -> level:int ->
    internal_format:InternalFormat.internal_format ->
    width:int -> height:int ->
    format_:pixel_data_format ->
    type_:pixel_data_type ->
    pixels:image_data -> unit
    = "ml_glteximage2d_bytecode"
      "ml_glteximage2d_native"
      NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexImage2D.xml}
    manual page on opengl.org} *)

external glTexImage2D_str:
    target:TexTarget.target_2d -> level:int ->
    internal_format:InternalFormat.internal_format ->
    width:int -> height:int ->
    format_:pixel_data_format ->
    type_:pixel_data_type ->
    pixels:string -> unit
    = "ml_glteximage2d_str_bytecode"
      "ml_glteximage2d_str_native"
      NOALLOC

external glTexImage1D: target:TexTarget.target_1d -> level:int ->
    internal_format:InternalFormat.internal_format ->
    width:int ->
    format_:pixel_data_format ->
    type_:pixel_data_type ->
    pixels:image_data -> unit
    = "ml_glteximage1d_bytecode"
      "ml_glteximage1d_native"
      NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexImage1D.xml}
    manual page on opengl.org} *)

external glTexImage3D: target:TexTarget.target_3d -> level:int ->
    internal_format:InternalFormat.internal_format ->
    width:int -> height:int -> depth:int ->
    format_:pixel_data_format ->
    type_:pixel_data_type ->
    pixels:image_data -> unit
    = "ml_glteximage3d_bytecode"
      "ml_glteximage3d_native"
      NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexImage3D.xml}
    manual page on opengl.org} *)

external glTexCoord1: s:float -> unit = "ml_gltexcoord1" NOALLOC
external glTexCoord2: s:float -> t:float -> unit = "ml_gltexcoord2" NOALLOC
external glTexCoord3: s:float -> t:float -> r:float -> unit = "ml_gltexcoord3" NOALLOC
external glTexCoord4: s:float -> t:float -> r:float -> q:float -> unit = "ml_gltexcoord4" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexCoord.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glTexCoord2v: v:float * float -> unit = "ml_gltexcoord2v" NOALLOC
external glTexCoord3v: v:float * float * float -> unit = "ml_gltexcoord3v" NOALLOC
external glTexCoord4v: v:float * float * float * float -> unit = "ml_gltexcoord4v" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexCoord.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


(* {{{ glTexParameter *)

module Min = struct (* PACK_ENUM *)
#include "enums/min_filter.inc.ml"
end (* PACK_ENUM *)
module Mag = struct (* PACK_ENUM *)
#include "enums/mag_filter.inc.ml"
end (* PACK_ENUM *)

#include "enums/wrap_param.inc.ml"

module TexParam = struct (* _PACK_ENUM *)

#include "enums/tex_param_target.inc.ml"

type texture_compare_mode =
  (*
  | GL_VERSION_1_4::GL_COMPARE_R_TO_TEXTURE
  *)
  | GL_NONE

type depth_texture_mode =
  | GL_LUMINANCE
  | GL_INTENSITY
  | GL_ALPHA

(** parameter for [glTexParameter] *)
type tex_param =
  | GL_TEXTURE_MIN_FILTER of Min.min_filter
  | GL_TEXTURE_MAG_FILTER of Mag.mag_filter
  | GL_TEXTURE_MIN_LOD of float
  | GL_TEXTURE_MAX_LOD of float
  | GL_TEXTURE_BASE_LEVEL of int
  | GL_TEXTURE_MAX_LEVEL of int
  | GL_TEXTURE_WRAP_S of wrap_param
  | GL_TEXTURE_WRAP_T of wrap_param
  | GL_TEXTURE_WRAP_R of wrap_param
  | GL_TEXTURE_BORDER_COLOR of (float * float * float * float)
  | GL_TEXTURE_PRIORITY of float

  | GL_TEXTURE_COMPARE_MODE of texture_compare_mode  (** only in GL >= 1.4 *)
  | GL_TEXTURE_COMPARE_FUNC of gl_func               (** only in GL >= 1.4 *)
  | GL_DEPTH_TEXTURE_MODE of depth_texture_mode      (** only in GL >= 1.4 *)
  | GL_GENERATE_MIPMAP of bool                       (** only in GL >= 1.4 *)  (* GL_TRUE / GL_FALSE *)

end (* _PACK_ENUM *)

#ifdef MLI
val glTexParameter:
    target:TexParam.tex_param_target ->
    param:TexParam.tex_param -> unit
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glTexParameter.xml}
    manual page on opengl.org} *)
#else
(* ML *)

external glTexParameterMinFilter: TexParam.tex_param_target -> Min.min_filter -> unit = "ml_gltexparameter_minfilter"
external glTexParameterMagFilter: TexParam.tex_param_target -> Mag.mag_filter -> unit = "ml_gltexparameter_magfilter"
external glTexParameter1i: TexParam.tex_param_target -> int -> int -> unit = "ml_gltexparameter1i"
external glTexParameter1f: TexParam.tex_param_target -> int -> float -> unit = "ml_gltexparameter1f"
external glTexParameterWrap: TexParam.tex_param_target -> int -> wrap_param -> unit = "ml_gltexparameter_wrap"
external glTexParameter4f: TexParam.tex_param_target -> float * float * float * float -> unit = "ml_gltexparameter4f"
external glTexParameter_gen_mpmp: TexParam.tex_param_target -> bool -> unit = "ml_gltexparameter_gen_mpmp"

let glTexParameter ~target ~param =
  match param with
  | TexParam.GL_TEXTURE_MIN_FILTER min_filter -> glTexParameterMinFilter target min_filter
  | TexParam.GL_TEXTURE_MAG_FILTER mag_filter -> glTexParameterMagFilter target mag_filter
  | TexParam.GL_TEXTURE_MIN_LOD  d -> glTexParameter1f target 0 d
  | TexParam.GL_TEXTURE_MAX_LOD  d -> glTexParameter1f target 1 d
  | TexParam.GL_TEXTURE_PRIORITY d -> glTexParameter1f target 2 d
  | TexParam.GL_TEXTURE_BASE_LEVEL d -> glTexParameter1i target 0 d
  | TexParam.GL_TEXTURE_MAX_LEVEL  d -> glTexParameter1i target 1 d
  | TexParam.GL_TEXTURE_WRAP_S wrap_param -> glTexParameterWrap target 0 wrap_param
  | TexParam.GL_TEXTURE_WRAP_T wrap_param -> glTexParameterWrap target 1 wrap_param
  | TexParam.GL_TEXTURE_WRAP_R wrap_param -> glTexParameterWrap target 2 wrap_param
  | TexParam.GL_TEXTURE_BORDER_COLOR color -> glTexParameter4f target color

  | TexParam.GL_TEXTURE_COMPARE_MODE tex_comp_mode -> assert(false) (** TODO switch GL_VERSION_1_4 *)
  | TexParam.GL_TEXTURE_COMPARE_FUNC gl_func -> assert(false)       (** TODO switch GL_VERSION_1_4 *)
  | TexParam.GL_DEPTH_TEXTURE_MODE dtexmode -> assert(false)        (** TODO switch GL_VERSION_1_4 *)
  | TexParam.GL_GENERATE_MIPMAP gm -> glTexParameter_gen_mpmp target gm
;;

#endif

(* }}} *)

(* TODO
http://www.opengl.org/sdk/docs/man/xhtml/glGetTexParameter.xml
*)

module CopyTex = struct (* PACK_ENUM *)
#include "enums/copy_tex_target.inc.ml"
end (* PACK_ENUM *)

external glCopyTexImage2D:
    target:CopyTex.copy_tex_target ->
    level:int ->
    internal_format:InternalFormat.internal_format ->
    x:int ->
    y:int ->
    width:int ->
    height:int ->
    border:int -> unit
    = "ml_glcopyteximage2d_bytecode"
      "ml_glcopyteximage2d_native"
      NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyTexImage2D.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glSampleCoverage: value:float -> invert:bool -> unit = "ml_glsamplecoverage" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSampleCoverage.xml}
    manual page on opengl.org} *)


(** {3 Raster functions} *)

#include "enums/pixel_packing_b.inc.ml"
external glPixelStoreb: pixel_packing:pixel_packing_b -> param:bool -> unit = "ml_glpixelstoreb" NOALLOC

#include "enums/pixel_packing_i.inc.ml"
external glPixelStorei: pixel_packing:pixel_packing_i -> param:int -> unit = "ml_glpixelstorei" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelStore.xml}
    manual page on opengl.org} *)

external glPixelZoom: xfactor:float -> yfactor:float -> unit = "ml_glpixelzoom" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelZoom.xml}
    manual page on opengl.org} *)



#include "enums/pixel_map.inc.ml"
external glPixelMapfv: map:pixel_map -> v:float array -> unit = "ml_glpixelmapfv"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelMap.xml}
    manual page on opengl.org} *)


(*
void glPixelMapfv( GLenum map, GLsizei mapsize, const GLfloat *values );
void glPixelMapuiv( GLenum map, GLsizei mapsize, const GLuint *values );
void glPixelMapusv( GLenum map, GLsizei mapsize, const GLushort *values );
*)

(* TODO
void glGetPixelMapfv( GLenum map, GLfloat *values );
void glGetPixelMapuiv( GLenum map, GLuint *values );
void glGetPixelMapusv( GLenum map, GLushort *values );
*)

external glBitmap: width:int -> height:int -> xorig:float -> yorig:float ->
    xmove:float -> ymove:float -> bitmap:('a, 'b, 'c) Bigarray.Array1.t -> unit
    = "ml_glbitmap_bytecode"
      "ml_glbitmap_native"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBitmap.xml}
    manual page on opengl.org} *)


#include "enums/pixel_type.inc.ml"
external glCopyPixels: x:int -> y:int -> width:int -> height:int -> pixel_type:pixel_type -> unit = "ml_glcopypixels" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCopyPixels.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

(* TODO
void glPixelTransferf( GLenum pname, GLfloat param);
void glPixelTransferi( GLenum pname, GLint param);
http://www.opengl.org/sdk/docs/man/xhtml/glPixelTransfer.xml
http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/pixeltransfer.html
*)


#include "enums/pixel_transfer_i.inc.ml"
#include "enums/pixel_transfer_f.inc.ml"
#include "enums/pixel_transfer_b.inc.ml"

(** if the [ARB_imaging] extension is supported, these symbolic names are accepted *)
#include "enums/pixel_transfer_f_ARB.inc.ml"

external glPixelTransferi: pname:pixel_transfer_i -> param:int -> unit = "ml_glpixeltransferi"
external glPixelTransferf: pname:pixel_transfer_f -> param:float -> unit = "ml_glpixeltransferf"
external glPixelTransferb: pname:pixel_transfer_b -> param:bool -> unit = "ml_glpixeltransferb"
external glPixelTransferfARB: pname:pixel_transfer_f_ARB -> param:float -> unit = "ml_glpixeltransferfARB"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPixelTransfer.xml}
    manual page on opengl.org} *)



module Framebuffer = struct (* PACK_ENUM *)
#include "enums/pixel_buffer_format.inc.ml"
#include "enums/pixel_buffer_type.inc.ml"
end (* PACK_ENUM *)
external glReadPixelsBA_unsafe: x:int -> y:int -> width:int -> height:int ->
    Framebuffer.pixel_buffer_format -> Framebuffer.pixel_buffer_type -> image_data -> unit
    = "ml_glreadpixels_ba_unsafe_bytecode"
      "ml_glreadpixels_ba_unsafe_native"
      NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glReadPixels.xml}
    manual page on opengl.org} *)

external glReadPixelsBA: x:int -> y:int -> width:int -> height:int ->
    Framebuffer.pixel_buffer_format -> Framebuffer.pixel_buffer_type -> image_data -> unit
    = "ml_glreadpixels_ba_bytecode"
      "ml_glreadpixels_ba_native"
      NOALLOC
(** same than [glReadPixelsBA_unsafe] but checks the size of the big-array *)

external glDrawPixels_str:
  width: int -> height: int -> format_: pixel_data_format ->
  type_:pixel_data_type -> pixels:string -> unit
  = "ml_gldrawpixels_str"


(** {3 Clipping} *)

module Plane = struct (* PACK_ENUM *)
#include "enums/clip_plane.inc.ml"
end (* PACK_ENUM *)
external glClipPlane: plane:Plane.clip_plane -> equation:float array -> unit = "ml_glclipplane"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glClipPlane.xml}
    manual page on opengl.org} *)

external glClipPlane_unsafe: plane:Plane.clip_plane -> equation:float array -> unit = "ml_glclipplane_unsafe"
(** same than [glClipPlane] but doesn't check that [equation] contains 4 items. *)

type clip_plane_i = GL_CLIP_PLANE of int

#ifdef MLI

val glClipPlanei: plane:clip_plane_i -> equation:float array -> unit
val glClipPlanei_unsafe: plane:clip_plane_i -> equation:float array -> unit

#else
(* ML *)

external glClipPlanei: plane:int -> equation:float array -> unit = "ml_glclipplane_i"
external glClipPlanei_unsafe: plane:int -> equation:float array -> unit = "ml_glclipplane_i_unsafe"

let glClipPlanei ~plane ~equation =
  match plane with
  | GL_CLIP_PLANE i -> glClipPlanei ~plane:i ~equation ;;

let glClipPlanei_unsafe ~plane ~equation =
  match plane with
  | GL_CLIP_PLANE i -> glClipPlanei_unsafe ~plane:i ~equation ;;

#endif

(* TODO
http://www.opengl.org/sdk/docs/man/xhtml/glGetClipPlane.xml
*)

(** {3 Evaluators} *)

module Map1 = struct (* PACK_ENUM *)
#include "enums/map1_target.inc.ml"
end (* PACK_ENUM *)
external glMap1: target:Map1.map1_target -> u1:float -> u2:float -> stride:int -> order:int -> points:float array -> unit
         = "ml_glmap1d_bytecode"
           "ml_glmap1d_native"
           NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMap1.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


module Map2 = struct (* PACK_ENUM *)
#include "enums/map2_target.inc.ml"
end (* PACK_ENUM *)
external glMap2: target:Map2.map2_target ->
                 u1:float -> u2:float -> ustride:int -> uorder:int ->
                 v1:float -> v2:float -> vstride:int -> vorder:int ->
                 points:float array array array -> unit
         = "ml_glmap2d_bytecode"
           "ml_glmap2d_native"
           NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMap2.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glEvalCoord1: u:float -> unit = "ml_glevalcoord1d" NOALLOC
external glEvalCoord2: u:float -> v:float -> unit = "ml_glevalcoord2d" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEvalCoord.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

module EvalMesh1 = struct
type eval_mesh_1 = GL_POINT | GL_LINE
end

module EvalMesh2 = struct
type eval_mesh_2 = GL_POINT | GL_LINE | GL_FILL
end

external glEvalMesh1: mode:EvalMesh1.eval_mesh_1 -> i1:int -> i2:int -> unit = "ml_glevalmesh1" NOALLOC
external glEvalMesh2: mode:EvalMesh2.eval_mesh_2 -> i1:int -> i2:int -> j1:int -> j2:int -> unit = "ml_glevalmesh2" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEvalMesh.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glEvalPoint1: i:int -> unit = "ml_glevalpoint1" NOALLOC
external glEvalPoint2: i:int -> j:int -> unit = "ml_glevalpoint2" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEvalPoint.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


external glMapGrid1: un:int -> u1:float -> u2:float -> unit = "ml_glmapgrid1d" NOALLOC
external glMapGrid2: un:int -> u1:float -> u2:float -> vn:int -> v1:float -> v2:float -> unit
    = "ml_glmapgrid2d_bytecode"
      "ml_glmapgrid2d_native"
      NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMapGrid.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)



(** {3 Display Lists} *)

#include "enums/list_mode.inc.ml"
external glNewList: gl_list:int -> mode:list_mode -> unit = "ml_glnewlist" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glNewList.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glEndList: unit -> unit = "ml_glendlist" NOALLOC
(** @deprecated in core OpenGL 3. *)

external glGenList: unit -> int = "ml_glgenlist" NOALLOC
external glGenLists: range:int -> int = "ml_glgenlists" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGenLists.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glCallList: gl_list:int -> unit = "ml_glcalllist" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCallList.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glCallLists: gl_lists:int array -> unit = "ml_glcalllists" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCallLists.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glDeleteLists: gl_list:int -> range:int -> unit = "ml_gldeletelists" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteLists.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glListBase: base:int -> unit = "ml_gllistbase" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glListBase.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glIsList: gl_list:int -> bool = "ml_glislist" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsList.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glGetListMode: unit -> list_mode = "ml_glgetlistmode" NOALLOC
(** @deprecated in core OpenGL 3. *)
 


(** {3 Picking} *)

#include "enums/render_mode.inc.ml"
external glRenderMode: mode:render_mode -> int = "ml_glrendermode" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glRenderMode.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glInitNames: unit -> unit = "ml_glinitnames" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glInitNames.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glLoadName: name:int -> unit = "ml_glloadname" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLoadName.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glPushName: name:int -> unit = "ml_glpushname" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPushName.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glPopName: unit -> unit = "ml_glpopname" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glPopName.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)


(* WIP *)

type select_buffer
external new_select_buffer: buffer_size:int -> select_buffer = "ml_alloc_select_buffer" NOALLOC
external free_select_buffer: select_buffer:select_buffer -> unit = "ml_free_select_buffer" NOALLOC
external select_buffer_get: select_buffer:select_buffer -> index:int -> int = "ml_select_buffer_get" NOALLOC

external glSelectBuffer: buffer_size:int -> select_buffer:select_buffer -> unit = "ml_glselectbuffer" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glSelectBuffer.xml}
    manual page on opengl.org}
    @deprecated in core OpenGL 3. *)

external glSelectBufferBA: 
    (*
    ('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
    *)
    (nativeint, Bigarray.nativeint_elt, Bigarray.c_layout) Bigarray.Array1.t
    -> unit
    = "ml_glselectbuffer_ba" NOALLOC

(* TODO?
void glFeedbackBuffer( GLsizei size, GLenum type, GLfloat *buffer );  !!! deprecated in core OpenGL 3.2
void glPassThrough( GLfloat token );  !!! deprecated in core OpenGL 3.2
*)


(** {3 Fog} *)

(* {{{ glFog *)

type fog_mode =
  | GL_LINEAR
  | GL_EXP
  | GL_EXP2

type fog_coord_src =
  | GL_FOG_COORD
  | GL_FRAGMENT_DEPTH

type fog_param =
  | GL_FOG_MODE of fog_mode
  | GL_FOG_DENSITY of float
  | GL_FOG_START of float
  | GL_FOG_END of float
  | GL_FOG_INDEX of float
  | GL_FOG_COLOR of (float * float * float * float)
  | GL_FOG_COORD_SRC of fog_coord_src
;;

#ifdef MLI

val glFog: pname:fog_param -> unit
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glFog.xml}
    manual page on opengl.org} *)

#else
(* ML *)

external glFog2: pname:int -> param:float -> unit = "ml_glfog2" NOALLOC
external glFog1: i:int -> unit = "ml_glfog1" NOALLOC
external glFog4: float -> float -> float -> float -> unit = "ml_glfog4" NOALLOC

let glFog ~pname =
  match pname with
  | GL_FOG_DENSITY density -> glFog2 1 density
  | GL_FOG_START start     -> glFog2 2 start
  | GL_FOG_END _end        -> glFog2 3 _end
  | GL_FOG_INDEX index     -> glFog2 4 index
  | GL_FOG_COORD_SRC   GL_FOG_COORD      -> glFog1 1
  | GL_FOG_COORD_SRC   GL_FRAGMENT_DEPTH -> glFog1 2
  | GL_FOG_MODE   GL_LINEAR -> glFog1 3
  | GL_FOG_MODE   GL_EXP    -> glFog1 4
  | GL_FOG_MODE   GL_EXP2   -> glFog1 5
  | GL_FOG_COLOR(r, g, b, a) -> glFog4 r g b a
;;

#endif

(* }}} *)

(* glFogCoord() is deprecated in core OpenGL 3.2 *)


(** {3 GLSL Shaders} *)

type shader_object
type shader_program
type shader_type = GL_VERTEX_SHADER | GL_FRAGMENT_SHADER

external glCreateShader: shader_type:shader_type -> shader_object = "ml_glcreateshader"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCreateShader.xml}
    manual page on opengl.org} *)

external glDeleteShader: shader:shader_object -> unit = "ml_gldeleteshader"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteShader.xml}
    manual page on opengl.org} *)

external glIsShader: shader:shader_object -> bool = "ml_glisshader"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glIsShader.xml}
    manual page on opengl.org} *)

external glShaderSource: shader:shader_object  -> string -> unit = "ml_glshadersource"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glShaderSource.xml}
    manual page on opengl.org} *)

external glCompileShader: shader:shader_object -> unit = "ml_glcompileshader"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCompileShader.xml}
    manual page on opengl.org} *)

external glCreateProgram: unit -> shader_program = "ml_glcreateprogram"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glCreateProgram.xml}
    manual page on opengl.org} *)

external glDeleteProgram: program:shader_program -> unit = "ml_gldeleteprogram"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDeleteProgram.xml}
    manual page on opengl.org} *)

external glAttachShader: program:shader_program -> shader:shader_object  -> unit = "ml_glattachshader"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glAttachShader.xml}
    manual page on opengl.org} *)

external glDetachShader: program:shader_program -> shader:shader_object -> unit = "ml_gldetachshader"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDetachShader.xml}
    manual page on opengl.org} *)

external glLinkProgram: program:shader_program -> unit = "ml_gllinkprogram"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glLinkProgram.xml}
    manual page on opengl.org} *)

external glUseProgram: program:shader_program -> unit = "ml_gluseprogram"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glUseProgram.xml}
    manual page on opengl.org} *)

external glUnuseProgram: unit -> unit = "ml_glunuseprogram"
(** equivalent to the C call glUseProgram(0) that desactivates the program *)

external glGetShaderCompileStatus: shader:shader_object -> bool = "ml_glgetshadercompilestatus"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetShader.xml}
    manual page on opengl.org} *)

external glGetShaderCompileStatus_exn: shader:shader_object -> unit = "ml_glgetshadercompilestatus_exn"
(** same than [glGetShaderCompileStatus] but raises an exception instead of returning false *)

external glGetUniformLocation: program:shader_program -> name:string -> int = "ml_glgetuniformlocation"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetUniformLocation.xml}
    manual page on opengl.org} *)


type get_program_bool =
  | GL_DELETE_STATUS
  | GL_LINK_STATUS
  | GL_VALIDATE_STATUS

type get_program_int =
  | GL_INFO_LOG_LENGTH
  | GL_ATTACHED_SHADERS
  | GL_ACTIVE_ATTRIBUTES
  | GL_ACTIVE_ATTRIBUTE_MAX_LENGTH
  | GL_ACTIVE_UNIFORMS
  | GL_ACTIVE_UNIFORM_MAX_LENGTH

external glGetProgrami: program:shader_program -> pname:get_program_int -> int = "ml_glgetprogram_int"
external glGetProgramb: program:shader_program -> pname:get_program_bool -> bool = "ml_glgetprogram_bool"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetProgram.xml}
    manual page on opengl.org} *)


external glUniform1f: location:int -> v0:float -> unit = "ml_gluniform1f" NOALLOC
external glUniform2f: location:int -> v0:float -> v1:float -> unit = "ml_gluniform2f" NOALLOC
external glUniform3f: location:int -> v0:float -> v1:float -> v2:float -> unit = "ml_gluniform3f" NOALLOC
external glUniform4f: location:int -> v0:float -> v1:float -> v2:float -> v3:float -> unit = "ml_gluniform4f" NOALLOC
external glUniform1i: location:int -> v0:int -> unit = "ml_gluniform1i" NOALLOC
external glUniform2i: location:int -> v0:int -> v1:int -> unit = "ml_gluniform2i" NOALLOC
external glUniform3i: location:int -> v0:int -> v1:int -> v2:int -> unit = "ml_gluniform3i" NOALLOC
external glUniform4i: location:int -> v0:int -> v1:int -> v2:int -> v3:int -> unit = "ml_gluniform4i" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glUniform.xml}
    manual page on opengl.org} *)

external glUniform1fv: location:int -> value:float array -> unit = "ml_gluniform1fv"
external glUniform2fv: location:int -> count:int -> value:float array -> unit = "ml_gluniform2fv"
external glUniform3fv: location:int -> count:int -> value:float array -> unit = "ml_gluniform3fv"
external glUniform4fv: location:int -> count:int -> value:float array -> unit = "ml_gluniform4fv"
external glUniform1iv: location:int -> value:int array -> unit = "ml_gluniform1iv"
external glUniform2iv: location:int -> count:int -> value:int array -> unit = "ml_gluniform2iv"
external glUniform3iv: location:int -> count:int -> value:int array -> unit = "ml_gluniform3iv"
external glUniform4iv: location:int -> count:int -> value:int array -> unit = "ml_gluniform4iv"
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glUniform.xml}
    manual page on opengl.org} *)


external glUniformMatrix2f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix2f"
external glUniformMatrix3f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix3f"
external glUniformMatrix4f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix4f"

external glUniformMatrix2x3f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix2x3f"
external glUniformMatrix3x2f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix3x2f"

external glUniformMatrix2x4f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix2x4f"
external glUniformMatrix4x2f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix4x2f"

external glUniformMatrix3x4f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix3x4f"
external glUniformMatrix4x3f: location:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix4x3f"


external glUniformMatrix2fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix2fv"
external glUniformMatrix3fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix3fv"
external glUniformMatrix4fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix4fv"

external glUniformMatrix2x3fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix2x3fv"
external glUniformMatrix3x2fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix3x2fv"

external glUniformMatrix2x4fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix2x4fv"
external glUniformMatrix4x2fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix4x2fv"

external glUniformMatrix3x4fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix3x4fv"
external glUniformMatrix4x3fv: location:int -> count:int -> transpose:bool -> value:float array -> unit = "ml_gluniformmatrix4x3fv"



external glGetAttribLocation: program:shader_program -> name:string -> int = "ml_glgetattriblocation" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetAttribLocation.xml}
    manual page on opengl.org} *)

external glBindAttribLocation: program:shader_program -> index:int -> name:string -> unit = "ml_glbindattriblocation" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glBindAttribLocation.xml}
    manual page on opengl.org} *)


external glVertexAttrib1s: index:int -> v:int -> unit = "ml_glvertexattrib1s" NOALLOC
external glVertexAttrib1d: index:int -> v:float -> unit = "ml_glvertexattrib1d" NOALLOC

external glVertexAttrib2s: index:int -> v0:int -> v1:int -> unit = "ml_glvertexattrib2s" NOALLOC
external glVertexAttrib2d: index:int -> v0:float -> v1:float -> unit = "ml_glvertexattrib2d" NOALLOC

external glVertexAttrib3s: index:int -> v0:int -> v1:int -> v2:int -> unit = "ml_glvertexattrib3s" NOALLOC
external glVertexAttrib3d: index:int -> v0:float -> v1:float -> v2:float -> unit = "ml_glvertexattrib3d" NOALLOC

external glVertexAttrib4s: index:int -> v0:int -> v1:int -> v2:int -> v3:int -> unit = "ml_glvertexattrib4s" NOALLOC
external glVertexAttrib4d: index:int -> v0:float -> v1:float -> v2:float -> v3:float -> unit = "ml_glvertexattrib4d" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glVertexAttrib.xml}
    manual page on opengl.org} *)

external glGetShaderInfoLog: shader:shader_object -> string = "ml_glgetshaderinfolog" (* DOES ALLOC *)
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetShaderInfoLog.xml}
    manual page on opengl.org} *)

external glGetProgramInfoLog: program:shader_program -> string = "ml_glgetprograminfolog" (* DOES ALLOC *)
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetProgramInfoLog.xml}
    manual page on opengl.org} *)

external glEnableVertexAttribArray: index:int -> unit = "ml_glenablevertexattribarray" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glEnableVertexAttribArray.xml}
    manual page on opengl.org} *)

external glDisableVertexAttribArray: index:int -> unit = "ml_gldisablevertexattribarray" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glDisableVertexAttribArray.xml}
    manual page on opengl.org} *)


(** {3 Gets} *)

module Get = struct (* _PACK_ENUM *)
#include "enums/get_boolean_1.inc.ml"
#include "enums/get_boolean_4.inc.ml"
#include "enums/get_integer_4.inc.ml"
#include "enums/get_integer_2.inc.ml"
#include "enums/get_integer_1.inc.ml"
#include "enums/get_float_3.inc.ml"
#include "enums/get_float_4.inc.ml"
#include "enums/get_matrix.inc.ml"
#include "enums/get_float_1.inc.ml"
#include "enums/get_float_2.inc.ml"
#include "enums/get_texture_binding.inc.ml"

type get_light =
  | GL_SPOT_EXPONENT
  | GL_SPOT_CUTOFF
  | GL_CONSTANT_ATTENUATION
  | GL_LINEAR_ATTENUATION
  | GL_QUADRATIC_ATTENUATION
  | GL_SPOT_DIRECTION
  | GL_AMBIENT
  | GL_DIFFUSE
  | GL_SPECULAR
  | GL_POSITION
  | GL_LIGHT_MODEL_COLOR_CONTROL
end (* _PACK_ENUM *)

(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGet.xml}
    manual page on opengl.org} *)

external glGetBoolean1: Get.get_boolean_1 -> bool = "ml_glgetboolean1" NOALLOC
external glGetBoolean4: Get.get_boolean_4 -> bool * bool * bool * bool = "ml_glgetboolean4" (* DOES ALLOC *)
external glGetInteger4: Get.get_integer_4 -> int * int * int * int = "ml_glgetinteger4" (* DOES ALLOC *)
external glGetInteger1: Get.get_integer_1 -> int = "ml_glgetinteger1" NOALLOC
external glGetInteger2: Get.get_integer_2 -> int * int = "ml_glgetinteger2" (* DOES ALLOC *)
external glGetFloat4: Get.get_float_4 -> float * float * float * float = "ml_glgetfloat4" (* DOES ALLOC *)
external glGetFloat3: Get.get_float_3 -> float * float * float = "ml_glgetfloat3" (* DOES ALLOC *)
external glGetFloat2: Get.get_float_2 -> float * float = "ml_glgetfloat2" (* DOES ALLOC *)
external glGetFloat1: Get.get_float_1 -> float = "ml_glgetfloat1" (* DOES ALLOC *)
external glGetMatrix: Get.get_matrix -> float array array = "ml_glgetmatrix" (* DOES ALLOC *)
external glGetMatrixFlat: Get.get_matrix -> float array = "ml_glgetmatrix_flat" (* DOES ALLOC *)
external glGetTextureBinding: Get.get_texture_binding -> texture_id = "ml_glgettexturebinding" NOALLOC

#include "enums/get_string.inc.ml"
external glGetString: name:get_string -> string = "ml_glgetstring" (* DOES ALLOC *)
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetString.xml}
    manual page on opengl.org} *)

#include "enums/gl_error.inc.ml"
external glGetError: unit -> gl_error = "ml_glgeterror" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetError.xml}
    manual page on opengl.org} *)


(* perhaps remove tuple_params ? *)

(* {{{ glGetLight *)

type tuple_params =
  | P1 of float
  | P3 of float * float * float
  | P4 of float * float * float * float
  | PCC of color_control

#ifdef MLI

val glGetLight: light:gl_light -> pname:Get.get_light -> tuple_params
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glGetLight.xml}
    manual page on opengl.org} *)

#else
(* ML *)

external _glGetLight1: light_i:int -> int -> float = "ml_glgetlight1" (* DOES ALLOC *)
external _glGetLight3: light_i:int -> float * float * float = "ml_glgetlight3" (* DOES ALLOC *)
external _glGetLight4: light_i:int -> int -> float * float * float * float = "ml_glgetlight4" (* DOES ALLOC *)

external glGetLightModelColorControl: unit -> color_control = "ml_glgetlightmodelcolorcontrol"


let glGetLight ~light ~pname =
  let light_i =
    match light with GL_LIGHT i -> i
  in
  match pname with
  | Get.GL_SPOT_EXPONENT         -> P1(_glGetLight1 light_i 0)
  | Get.GL_SPOT_CUTOFF           -> P1(_glGetLight1 light_i 1)
  | Get.GL_CONSTANT_ATTENUATION  -> P1(_glGetLight1 light_i 2)
  | Get.GL_LINEAR_ATTENUATION    -> P1(_glGetLight1 light_i 3)
  | Get.GL_QUADRATIC_ATTENUATION -> P1(_glGetLight1 light_i 4)

  | Get.GL_SPOT_DIRECTION -> let p1, p2, p3 = _glGetLight3 light_i in P3(p1, p2, p3)

  | Get.GL_AMBIENT  -> let p1, p2, p3, p4 = _glGetLight4 light_i 0 in P4(p1, p2, p3, p4)
  | Get.GL_DIFFUSE  -> let p1, p2, p3, p4 = _glGetLight4 light_i 1 in P4(p1, p2, p3, p4)
  | Get.GL_SPECULAR -> let p1, p2, p3, p4 = _glGetLight4 light_i 2 in P4(p1, p2, p3, p4)
  | Get.GL_POSITION -> let p1, p2, p3, p4 = _glGetLight4 light_i 3 in P4(p1, p2, p3, p4)

  | Get.GL_LIGHT_MODEL_COLOR_CONTROL -> PCC(glGetLightModelColorControl())
;;

#endif
(* }}} *)


(* {{{ Multitexture *)
(** {3 Multitexture} *)

(** {{:http://www.opengl.org/resources/code/samples/sig99/advanced99/notes/node60.html}
    Multitexture Node},
    {{:http://www.opengl.org/wiki/GL_ARB_multitexture}
    ARB multitexture wiki}
*)

#include "enums/texture_i.inc.ml"
external glActiveTexture: texture:texture_i -> unit = "ml_glactivetexture" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glActiveTexture.xml}
    manual page on opengl.org} *)

external glActiveTexturei: texture:int -> unit = "ml_glactivetexture_i" NOALLOC
(** [glActiveTexturei i] is equivalent to [glActiveTexture GL_TEXTUREi] *)


external glMultiTexCoord2: texture:texture_i -> s:float -> t:float -> unit = "ml_glmultitexcoord2d" NOALLOC
(** {{:http://www.opengl.org/sdk/docs/man/xhtml/glMultiTexCoord.xml}
    manual page on opengl.org} *)

external glMultiTexCoord2i: texture:int -> s:float -> t:float -> unit = "ml_glmultitexcoord2f_i"

(* }}} *)
(* TODO glMultiTexCoord(3|4) *)

(** {3 Library Version} *)

#ifdef MLI
val glmlite_version : int * int * int
#else
(* ML *)
let glmlite_version = (0,0,0)
#endif

(* vim: sw=2 sts=2 ts=2 et fdm=marker filetype=ocaml nowrap
 *)
