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

(** Mesa Off-Screen rendering interface *)

(** This is an operating system and window system independent interface to
    Mesa which allows one to render images into a client-supplied buffer in
    main memory.  Such images may manipulated or saved in whatever way the
    client wants. *)
(* {{{ ? 
  These are the API functions:
    OSMesaCreateContext - create a new Off-Screen Mesa rendering context
    OSMesaMakeCurrent - bind an OSMesaContext to a client's image buffer
                        and make the specified context the current one.
    OSMesaDestroyContext - destroy an OSMesaContext
    OSMesaGetCurrentContext - return thread's current context ID
    OSMesaPixelStore - controls how pixels are stored in image buffer
    OSMesaGetIntegerv - return OSMesa state parameters


  The limits on the width and height of an image buffer are MAX_WIDTH and
  MAX_HEIGHT as defined in Mesa/src/config.h.  Defaults are 1280 and 1024.
  You can increase them as needed but beware that many temporary arrays in
  Mesa are dimensioned by MAX_WIDTH or MAX_HEIGHT.
}}} *)

type osmesa_context

type osmesa_format =
  | OSMESA_COLOR_INDEX
  | OSMESA_RGBA
  | OSMESA_BGRA
  | OSMESA_ARGB
  | OSMESA_RGB
  | OSMESA_BGR

external osMesaCreateContextExt:
    format:osmesa_format ->
    depth_bits:int -> stencil_bits:int -> accum_bits:int ->
    sharelist:osmesa_context option -> osmesa_context
    = "ml_osmesacreatecontextext"
(** Create an Off-Screen Mesa rendering context and specify desired
    size of depth buffer, stencil buffer and accumulation buffer.
    If you specify zero for [depth_bits], [stencil_bits], [accum_bits]
    you can save some memory.
  
    (New in Mesa 3.5)  *)


external osMesaCreateContext:
    format_:osmesa_format ->
    sharelist:osmesa_context option -> osmesa_context
    = "ml_osmesacreatecontext"
(** Create an Off-Screen Mesa rendering context.
    The only attribute needed is an RGBA vs Color-Index mode flag.
   
    [sharelist] specifies another OSMesaContext with which to share
                display lists.  [None] indicates no sharing.
*)


type buffer_type = OSM_UNSIGNED_BYTE

external osMesaMakeCurrent:
    ctx:osmesa_context -> buffer:
    (nativeint, Bigarray.nativeint_elt, Bigarray.c_layout) Bigarray.Array1.t ->
    type_:buffer_type -> width:int -> height:int -> unit
    = "ml_osmesamakecurrent"
(**
   Bind an [osmesa_context] to an image buffer.  The image buffer is provided
   as a bigarray which the client provides.  Its size must be at least
   as large as width * height * sizeof(type).
  
   Image data is stored in the order of glDrawPixels:  row-major order
   with the lower-left image pixel stored in the first array position
   (ie. bottom-to-top).
  
   Since the only type initially supported is GL_UNSIGNED_BYTE, if the
   context is in RGBA mode, each pixel will be stored as a 4-byte RGBA
   value.  If the context is in color indexed mode, each pixel will be
   stored as a 1-byte value.
  
   If the context's viewport hasn't been initialized yet, it will now be
   initialized to (0,0,width,height).
*)


external osMesaDestroyContext: ctx:osmesa_context -> unit = "ml_osmesadestroycontext"
(** Destroy an Off-Screen Mesa rendering context. *)


external major_version: unit -> int = "ml_osmesa_major_version"
external minor_version: unit -> int = "ml_osmesa_minor_version"
external patch_version: unit -> int = "ml_osmesa_patch_version"

(* TODO
0 osMesaColorClamp
1 osMesaCreateContext
1 osMesaCreateContextExt
1 osMesaDestroyContext
0 osMesaGetColorBuffer
0 osMesaGetCurrentContext
0 osMesaGetDepthBuffer
0 osMesaGetIntegerv
0 osMesaGetProcAddress
1 osMesaMakeCurrent
0 osMesaPixelStore
*)

(* vim: sw=2 sts=2 ts=2 et fdm=marker filetype=ocaml
 *)
