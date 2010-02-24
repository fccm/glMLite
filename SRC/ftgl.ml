(* {{{ COPYING 

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
