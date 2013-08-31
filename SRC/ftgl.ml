(* {{{ COPYING 

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

 }}} *)

(** Bindings to the FTGL library. *)

(** FTGL is a library for rendering TrueType fonts in OpenGL. *)

type ftglFont

external ftglCreatePixmapFont: filename:string -> ftglFont = "ml_ftglCreatePixmapFont"
external ftglCreateBitmapFont: filename:string -> ftglFont = "ml_ftglCreateBitmapFont"
external ftglCreateBufferFont: filename:string -> ftglFont = "ml_ftglCreateBufferFont"
external ftglCreateTextureFont: filename:string -> ftglFont = "ml_ftglCreateTextureFont"
external ftglCreateOutlineFont: filename:string -> ftglFont = "ml_ftglCreateOutlineFont"
external ftglCreateExtrudeFont: filename:string -> ftglFont = "ml_ftglCreateExtrudeFont"
external ftglCreatePolygonFont: filename:string -> ftglFont = "ml_ftglCreatePolygonFont"

external ftglDestroyFont: font:ftglFont -> unit = "ml_ftglDestroyFont"

external ftglSetFontFaceSize: font:ftglFont -> size:int -> res:int -> unit = "ml_ftglSetFontFaceSize"

external ftglGetFontFaceSize:  font:ftglFont -> int = "ml_ftglGetFontFaceSize"

type render_mode =
  | FTGL_RENDER_FRONT
  | FTGL_RENDER_BACK
  | FTGL_RENDER_SIDE
  | FTGL_RENDER_ALL

external ftglRenderFont: font:ftglFont -> str:string -> mode:render_mode -> unit = "ml_ftglRenderFont"

external ftglSetFontDepth: font:ftglFont -> depth:float -> unit = "ml_ftglSetFontDepth"
external ftglSetFontOutset: font:ftglFont -> front:float -> back:float -> unit = "ml_ftglSetFontOutset"

external ftglGetFontAscender: font:ftglFont -> float = "ml_ftglGetFontAscender"
external ftglGetFontDescender : font:ftglFont -> float = "ml_ftglGetFontDescender"
external ftglGetFontLineHeight: font:ftglFont -> float = "ml_ftglGetFontLineHeight"

external ftglGetFontAdvance: font:ftglFont -> str:string -> float = "ml_ftglGetFontAdvance"


type ftglLayout

external ftglCreateSimpleLayout: unit -> ftglLayout = "ml_ftglCreateSimpleLayout"

external ftglSetLayoutFont: layout:ftglLayout -> font:ftglFont -> unit = "ml_ftglSetLayoutFont"
external ftglGetLayoutFont: layout:ftglLayout -> ftglFont = "ml_ftglGetLayoutFont"

external ftglSetLayoutLineLength: layout:ftglLayout -> lineLength:float -> unit = "ml_ftglSetLayoutLineLength"
external ftglGetLayoutLineLength: layout:ftglLayout -> float = "ml_ftglGetLayoutLineLength"

external ftglSetLayoutAlignment: layout:ftglLayout -> alignment:int -> unit = "ml_ftglSetLayoutAlignment"
external ftglGetLayoutAlignement: layout:ftglLayout -> int = "ml_ftglGetLayoutAlignement"

external ftglSetLayoutLineSpacing: layout:ftglLayout -> lineSpacing:float -> unit = "ml_ftglSetLayoutLineSpacing"
(* external ftglGetLayoutLineSpacing: layout:ftglLayout -> float = "ml_ftglGetLayoutLineSpacing" *)

external ftglDestroyLayout: layout:ftglLayout -> unit = "ml_ftglDestroyLayout"


(* vim: ts=2 sts=2 sw=2 et fdm=marker nowrap
 *)
