(* {{{ COPYING *(

  This file belongs to glMLite, an OCaml binding to the OpenGL API.

  Copyright (C) 2006 - 2011  Florent Monnier

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

(** Glu interface *)

external gluPerspective: fovy:float -> aspect:float -> zNear:float -> zFar:float -> unit = "ml_gluperspective"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluPerspective.xml}
    manual page} *)

external gluLookAt: eyeX:float -> eyeY:float -> eyeZ:float ->
                    centerX:float -> centerY:float -> centerZ:float ->
                    upX:float -> upY:float -> upZ:float -> unit
                    = "ml_glulookat_bytecode"
                      "ml_glulookat_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluLookAt.xml}
    manual page} *)

external gluOrtho2D: left:float -> right:float -> bottom:float -> top:float -> unit = "ml_gluortho2d"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluOrtho2D.xml}
    manual page} *)


external gluErrorString: error:GL.gl_error -> string = "ml_gluerrorstring"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluErrorString.xml}
    manual page} *)


external gluPickMatrix: x:float -> y:float -> width:float -> height:float ->
                        viewport:int * int * int * int -> unit = "ml_glupickmatrix"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluPickMatrix.xml}
    manual page} *)


external gluUnProject: win_x:float -> win_y:float -> win_z:float ->
            model:float array array -> proj:float array array -> viewport:int array ->
            float * float * float
            = "ml_gluunproject_bytecode"
              "ml_gluunproject_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluUnProject.xml}
    manual page} *)

external gluUnProjectFlat: win_x:float -> win_y:float -> win_z:float ->
            model:float array -> proj:float array -> viewport:int array ->
            float * float * float
            = "ml_gluunproject_flat_bytecode"
              "ml_gluunproject_flat_native"
(** same than [gluUnProject] but optimised *)

external gluUnProjectUtil: x:int -> y:int -> float * float * float = "ml_util_gluunproject"
(** {b Utility} provides a classic use of [gluUnProject] with default parameters,
    the modelview matrix, the projection matrix, and the current viewport. *)

external gluUnProjectPixel: x:int -> y:int -> float * float * float = "ml_gluunproject_pixel"
(** {b Utility} Same as [gluUnProjectUtil] but also checks the depth of the pixel. *)

external gluProject: win_x:float -> win_y:float -> win_z:float ->
            model:float array array -> proj:float array array -> viewport:int array ->
            float * float * float
            = "ml_gluproject_bytecode"
              "ml_gluproject_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluProject.xml}
    manual page} *)

external gluProjectFlat: win_x:float -> win_y:float -> win_z:float ->
            model:float array -> proj:float array -> viewport:int array ->
            float * float * float
            = "ml_gluproject_flat_bytecode"
              "ml_gluproject_flat_native"
(** same than [gluProject] but optimised *)

external gluProjectUtil: obj_x:float -> obj_y:float -> obj_z:float -> float * float * float = "ml_gluproject_util"
(** {b Utility} provides a classic use of [gluProject] with default parameters,
    the modelview matrix, the projection matrix, and the current viewport. *)


type glu_desc =
  | GLU_VERSION
  | GLU_EXTENSIONS

external gluGetString: name:glu_desc -> string = "ml_glugetstring"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluGetString.xml}
    manual page} *)



(** {3 Mipmaps} *)

external gluBuild2DMipmaps:
            (* target:GL.TexTarget.target_2d -> *)
            internal_format:GL.InternalFormat.internal_format ->
            width:int -> height:int ->
            format_:GL.pixel_data_format ->
            type_:GL.pixel_data_type -> pixels:GL.image_data -> unit
            = "ml_glubuild2dmipmaps_bytecode"
              "ml_glubuild2dmipmaps_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluBuild2DMipmaps.xml}
    manual page} *)


external gluBuild1DMipmaps:
            (* target:GL.TexTarget.target_1d -> *)
            internal_format:GL.InternalFormat.internal_format ->
            width:int ->
            format_:GL.pixel_data_format ->
            type_:GL.pixel_data_type -> pixels:GL.image_data -> unit
            = "ml_glubuild1dmipmaps"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluBuild1DMipmaps.xml}
    manual page} *)


external gluBuild3DMipmaps:
            (* target:GL.TexTarget.target_3d -> *)
            internal_format:GL.InternalFormat.internal_format ->
            width:int -> height:int -> depth:int ->
            format_:GL.pixel_data_format ->
            type_:GL.pixel_data_type -> pixels:GL.image_data -> unit
            = "ml_glubuild3dmipmaps_bytecode"
              "ml_glubuild3dmipmaps_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluBuild3DMipmaps.xml}
    manual page} *)




(** {3 Quadric Functions} *)

type glu_quadric
external gluNewQuadric: unit -> glu_quadric = "ml_glunewquadric"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluNewQuadric.xml}
    manual page} *)

external gluDeleteQuadric: quad:glu_quadric -> unit = "ml_gludeletequadric"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluDeleteQuadric.xml}
    manual page} *)

type draw_style =
  | GLU_POINT
  | GLU_LINE
  | GLU_FILL
  | GLU_SILHOUETTE

external gluQuadricDrawStyle: quad:glu_quadric -> draw_style:draw_style -> unit = "ml_gluquadricdrawstyle"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluQuadricDrawStyle.xml}
    manual page} *)

external gluQuadricTexture: quad:glu_quadric -> texture:bool -> unit = "ml_gluquadrictexture"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluQuadricTexture.xml}
    manual page} *)

external gluSphere: quad:glu_quadric -> radius:float -> slices:int -> stacks:int -> unit = "ml_glusphere"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluSphere.xml}
    manual page} *)

external gluCylinder: quad:glu_quadric -> base:float -> top:float -> height:float ->
                      slices:int -> stacks:int -> unit
                      = "ml_glucylinder_bytecode"
                        "ml_glucylinder_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluCylinder.xml}
    manual page} *)

external gluDisk: quad:glu_quadric -> inner:float -> outer:float -> slices:int -> loops:int -> unit = "ml_gludisk"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluDisk.xml}
    manual page} *)

external gluPartialDisk: quad:glu_quadric -> inner:float -> outer:float -> slices:int ->
                         loops:int -> start:float -> sweep:float -> unit
                         = "ml_glupartialdisk_bytecode"
                           "ml_glupartialdisk_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluPartialDisk.xml}
    manual page} *)

type orientation =
  | GLU_OUTSIDE
  | GLU_INSIDE

external gluQuadricOrientation: quad:glu_quadric -> orientation:orientation -> unit = "ml_gluquadricorientation"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluQuadricOrientation.xml}
    manual page} *)

type normal =
  | GLU_NONE
  | GLU_FLAT
  | GLU_SMOOTH

external gluQuadricNormals: quad:glu_quadric -> normal:normal -> unit = "ml_gluquadricnormals"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluQuadricNormals.xml}
    manual page} *)

(* TODO
gluQuadricCallback
*)



(** {3 Tesselation} *)

type glu_tesselator
external gluNewTess: unit -> glu_tesselator = "ml_glunewtess"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluNewTess.xml}
    manual page} *)

external gluDeleteTess: tess:glu_tesselator -> unit = "ml_gludeletetess"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluDeleteTess.xml}
    manual page} *)

external gluBeginPolygon: tess:glu_tesselator -> unit = "ml_glubeginpolygon"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluBeginPolygon.xml}
    manual page} *)
external gluEndPolygon: tess:glu_tesselator -> unit = "ml_gluendpolygon"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluEndPolygon.xml}
    manual page} *)

external gluTessBeginPolygon: tess:glu_tesselator -> unit = "ml_glutessbeginpolygon"
external gluTessBeginPolygonData: tess:glu_tesselator -> data:'a -> unit = "ml_glutessbeginpolygon_data"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessBeginPolygon.xml}
    manual page} *)

external gluTessEndPolygon: tess:glu_tesselator -> unit = "ml_glutessendpolygon"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessEndPolygon.xml}
    manual page} *)

external gluTessBeginContour: tess:glu_tesselator -> unit = "ml_glutessbegincontour"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessBeginContour.xml}
    manual page} *)
external gluTessEndContour: tess:glu_tesselator -> unit = "ml_glutessendcontour"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessEndContour.xml}
    manual page} *)

type tess_contour =
  | GLU_CW
  | GLU_CCW
  | GLU_INTERIOR
  | GLU_EXTERIOR
  | GLU_UNKNOWN

external gluNextContour: tess:glu_tesselator -> contour:tess_contour -> unit = "ml_glunextcontour"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluNextContour.xml}
    manual page} *)

external gluTessVertex: tess:glu_tesselator -> x:float -> y:float -> z:float -> unit = "ml_glutessvertex"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessVertex.xml}
    manual page} *)

external gluTessNormal: tess:glu_tesselator -> x:float -> y:float -> z:float -> unit = "ml_glutessnormal"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessNormal.xml}
    manual page} *)

external gluTesselate: glu_tesselator -> (float * float * float) array -> unit = "tesselate_points"
(** Is equivalent to:{[
    gluTessBeginPolygon ~tess;
      gluTessBeginContour ~tess;
        Array.iter (fun (x,y,z) -> gluTessVertex ~tess ~x ~y ~z) points;
      gluTessEndContour ~tess;
    gluTessEndPolygon ~tess;]}
*)


#ifdef MLI
val gluTesselateIter: tess:glu_tesselator -> data:(float * float * float) array list -> unit
#else // ML
external gluTesselateIter: tess:glu_tesselator -> data:(float * float * float) array list -> len:int -> unit = "tesselate_iter_points"
let gluTesselateIter ~tess ~data =
  gluTesselateIter ~tess ~data ~len:(List.length data);
;;
#endif
(** Is equivalent to:{[
    gluTessBeginPolygon ~tess;
      List.iter (fun points ->
          gluTessBeginContour ~tess;
            Array.iter (fun (x,y,z) -> gluTessVertex ~tess ~x ~y ~z) points;
          gluTessEndContour ~tess;
        ) datas;
    gluTessEndPolygon ~tess;]}
*)


type tess_winding =
  | GLU_TESS_WINDING_ODD
  | GLU_TESS_WINDING_NONZERO
  | GLU_TESS_WINDING_POSITIVE
  | GLU_TESS_WINDING_NEGATIVE
  | GLU_TESS_WINDING_ABS_GEQ_TWO

type tess_property =
  | GLU_TESS_WINDING_RULE of tess_winding
  | GLU_TESS_BOUNDARY_ONLY of bool
  | GLU_TESS_TOLERANCE of float


external gluGetTessWindingRule: tess:glu_tesselator -> winding:tess_winding -> unit = "ml_glugettesswindingrule"
external gluGetTessBoundaryOnly: tess:glu_tesselator -> boundary_only:bool -> unit = "ml_glugettessboundaryonly"
external gluGetTessTolerance: tess:glu_tesselator -> tolerance:float -> unit = "ml_glugettesstolerance"

(* TODO
void gluGetTessProperty (GLUtesselator* tess, GLenum which, GLdouble* data);
*)

#ifdef MLI
val gluTessProperty: tess:glu_tesselator -> prop:tess_property -> unit
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessProperty.xml}
    manual page} *)

#else // ML
let gluTessProperty ~tess ~prop =
  match prop with
  | GLU_TESS_WINDING_RULE  winding       -> gluGetTessWindingRule ~tess ~winding
  | GLU_TESS_BOUNDARY_ONLY boundary_only -> gluGetTessBoundaryOnly ~tess ~boundary_only
  | GLU_TESS_TOLERANCE     tolerance     -> gluGetTessTolerance ~tess ~tolerance
;;
#endif


type tess_callback =
  | GLU_TESS_BEGIN
  | GLU_TESS_BEGIN_DATA
  | GLU_TESS_EDGE_FLAG
  | GLU_TESS_EDGE_FLAG_DATA
  | GLU_TESS_VERTEX
  | GLU_TESS_VERTEX_DATA
  | GLU_TESS_END
  | GLU_TESS_END_DATA
  | GLU_TESS_COMBINE
  | GLU_TESS_COMBINE_DATA
  | GLU_TESS_ERROR
  | GLU_TESS_ERROR_DATA
  (*
  | GLU_BEGIN
  | GLU_VERTEX
  | GLU_END
  | GLU_EDGE_FLAG
  *)

(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluTessCallback.xml}
    manual page} *)

external gluTessDefaultCallback: tess:glu_tesselator -> cb:tess_callback -> unit = "ml_glutesscallback_default"
(** Sets default callbacks for a classic use.
    [GLU_TESS_BEGIN] and [GLU_TESS_END] callbacks are set to [glBegin] and [glEnd].
    [GLU_TESS_VERTEX] callback calls [glVertex3] preceded by a call to
    [glTexCoord2] with the x and y components
    (the size of the texture mapping can by scaled with [glMatrixMode
    GL_TEXTURE;] and [glScale]).
    [GLU_TESS_COMBINE] callback makes the alloc of the new vertex,
    and a caml Failure with the Glu error message is raised for the
    [GLU_TESS_ERROR] callback.
*)


type tess_error =
  | GLU_TESS_MISSING_BEGIN_POLYGON
  | GLU_TESS_MISSING_BEGIN_CONTOUR
  | GLU_TESS_MISSING_END_POLYGON
  | GLU_TESS_MISSING_END_CONTOUR
  | GLU_TESS_COORD_TOO_LARGE
  | GLU_TESS_NEED_COMBINE_CALLBACK
  | GLU_OUT_OF_MEMORY
  | GLU_TESS_ERROR7
  | GLU_TESS_ERROR8


#ifdef MLI
val gluCallbackTessVertex: tess:glu_tesselator -> tess_vertex:(x:float -> y:float -> z:float -> unit) -> unit
#else // ML
external gluCallbackTessVertex: tess:glu_tesselator -> unit = "ml_glutess_cb_vertex"
let gluCallbackTessVertex ~tess ~tess_vertex =
  Callback.register "GLU callback tess vertex" tess_vertex;
  gluCallbackTessVertex ~tess;
;;
#endif


#ifdef MLI
val gluCallbackTessBegin: tess:glu_tesselator -> tess_begin:(prim:GL.primitive -> unit) -> unit
#else // ML
external gluCallbackTessBegin: tess:glu_tesselator -> unit = "ml_glutess_cb_begin"
let gluCallbackTessBegin ~tess ~tess_begin =
  Callback.register "GLU callback tess begin" tess_begin;
  gluCallbackTessBegin ~tess;
;;
#endif


#ifdef MLI
val gluCallbackTessEnd: tess:glu_tesselator -> tess_end:(unit -> unit) -> unit
#else // ML
external gluCallbackTessEnd: tess:glu_tesselator -> unit = "ml_glutess_cb_end"
let gluCallbackTessEnd ~tess ~tess_end =
  Callback.register "GLU callback tess end" tess_end;
  gluCallbackTessEnd ~tess;
;;
#endif


#ifdef MLI
val gluCallbackTessError: tess:glu_tesselator -> tess_error:(error:tess_error -> unit) -> unit
#else // ML
external gluCallbackTessError: tess:glu_tesselator -> unit = "ml_glutess_cb_error"
let gluCallbackTessError ~tess ~tess_error =
  Callback.register "GLU callback tess error" tess_error;
  gluCallbackTessError ~tess;
;;
#endif

external gluTessErrorString: error:tess_error -> string = "ml_glutesserrorstring"
(** same than [gluErrorString] but for type [tess_error] *)


(** {3 Nurbs Surfaces} *)

type glu_nurbs

external gluNewNurbsRenderer: unit -> glu_nurbs = "ml_glunewnurbsrenderer"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluNewNurbsRenderer.xml}
    manual page} *)

external gluBeginSurface: nurb:glu_nurbs -> unit = "ml_glubeginsurface"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluBeginSurface.xml}
    manual page} *)

external gluEndSurface: nurb:glu_nurbs -> unit = "ml_gluendsurface"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluEndSurface.xml}
    manual page} *)

type nurbs_mode =
  | GLU_NURBS_RENDERER
  | GLU_NURBS_TESSELLATOR

type sampling_method =
  | GLU_PATH_LENGTH
  | GLU_PARAMETRIC_ERROR
  | GLU_DOMAIN_DISTANCE
  | GLU_OBJECT_PATH_LENGTH
  | GLU_OBJECT_PARAMETRIC_ERROR

module Disp = struct
type display_mode =
  | GLU_OUTLINE_POLYGON
  | GLU_FILL
  | GLU_OUTLINE_PATCH
end

type nurbs_property =
  | GLU_SAMPLING_TOLERANCE of float
  | GLU_DISPLAY_MODE of Disp.display_mode
  | GLU_CULLING of bool
  | GLU_AUTO_LOAD_MATRIX of bool
  | GLU_PARAMETRIC_TOLERANCE of float
  | GLU_SAMPLING_METHOD of sampling_method
  | GLU_U_STEP of int
  | GLU_V_STEP of int
  | GLU_NURBS_MODE of nurbs_mode

#ifdef MLI
val gluNurbsProperty: nurb:glu_nurbs -> property:nurbs_property -> unit
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluNurbsProperty.xml}
    manual page} *)
#else // ML
external _gluNurbsProperty1: glu_nurbs -> int -> unit = "ml_glunurbsproperty1"
external _gluNurbsProperty2: glu_nurbs -> int -> float -> unit = "ml_glunurbsproperty2"

let gluNurbsProperty ~nurb ~property =
  match property with
  | GLU_SAMPLING_TOLERANCE v ->   _gluNurbsProperty2 nurb 0 v
  | GLU_PARAMETRIC_TOLERANCE v -> _gluNurbsProperty2 nurb 1 v
  | GLU_U_STEP v -> _gluNurbsProperty2 nurb 2 (float v)
  | GLU_V_STEP v -> _gluNurbsProperty2 nurb 3 (float v)

  | GLU_CULLING true ->  _gluNurbsProperty1 nurb 0
  | GLU_CULLING false -> _gluNurbsProperty1 nurb 1
  | GLU_AUTO_LOAD_MATRIX true ->  _gluNurbsProperty1 nurb 2
  | GLU_AUTO_LOAD_MATRIX false -> _gluNurbsProperty1 nurb 3

  | GLU_DISPLAY_MODE Disp.GLU_OUTLINE_POLYGON -> _gluNurbsProperty1 nurb 4
  | GLU_DISPLAY_MODE Disp.GLU_FILL ->            _gluNurbsProperty1 nurb 5
  | GLU_DISPLAY_MODE Disp.GLU_OUTLINE_PATCH ->   _gluNurbsProperty1 nurb 6

  | GLU_SAMPLING_METHOD GLU_PATH_LENGTH ->             _gluNurbsProperty1 nurb 7
  | GLU_SAMPLING_METHOD GLU_PARAMETRIC_ERROR ->        _gluNurbsProperty1 nurb 8
  | GLU_SAMPLING_METHOD GLU_DOMAIN_DISTANCE ->         _gluNurbsProperty1 nurb 9
  | GLU_SAMPLING_METHOD GLU_OBJECT_PATH_LENGTH ->      _gluNurbsProperty1 nurb 10
  | GLU_SAMPLING_METHOD GLU_OBJECT_PARAMETRIC_ERROR -> _gluNurbsProperty1 nurb 11

  | GLU_NURBS_MODE GLU_NURBS_RENDERER ->    _gluNurbsProperty1 nurb 12
  | GLU_NURBS_MODE GLU_NURBS_TESSELLATOR -> _gluNurbsProperty1 nurb 13
;;
#endif


type surface_type =
  | GLU_MAP2_VERTEX_3
  | GLU_MAP2_VERTEX_4

external gluNurbsSurface: nurb:glu_nurbs ->
    sKnots:float array ->
    tKnots:float array ->
    sStride:int ->
    tStride:int ->
    control:float array ->
    sOrder:int ->
    tOrder:int ->
    surface_type:surface_type -> unit
    = "ml_glunurbssurface_bytecode"
      "ml_glunurbssurface_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluNurbsSurface.xml}
    manual page} *)

(* TODO - there is a bug somewhere below:

(** {3 Trimming} *)

external gluBeginTrim: nurb:glu_nurbs -> unit = "ml_glubegintrim"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluBeginTrim.xml}
    manual page} *)

external gluEndTrim: nurb:glu_nurbs -> unit = "ml_gluendtrim"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluEndTrim.xml}
    manual page} *)

type pwl_curve_type = GLU_MAP1_TRIM_2 | GLU_MAP1_TRIM_3

external gluPwlCurve: nurb:glu_nurbs -> count:int -> data:float array -> stride:int -> curve_type:pwl_curve_type -> unit = "ml_glupwlcurve"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluPwlCurve.xml}
    manual page} *)

module N = struct
type nurbs_curve_type =
  | GLU_MAP1_VERTEX_3
  | GLU_MAP1_VERTEX_4
  | GLU_MAP1_TRIM_2
  | GLU_MAP1_TRIM_3
end
external gluNurbsCurve: nurb:glu_nurbs -> knots:float array -> stride:int ->
    control:float array -> order:int -> curve_type:N.nurbs_curve_type -> unit
    = "ml_glunurbscurve_bytecode"
      "ml_glunurbscurve_native"
(** {{:https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/gluNurbsCurve.xml}
    manual page} *)
*)

(* vim: sw=2 sts=2 ts=2 et nowrap fdm=marker filetype=ocaml
 *)
