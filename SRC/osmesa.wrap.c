/* {{{ COPYING 

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

\* }}} */

#include <caml/mlvalues.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

#include <GL/osmesa.h>


CAMLprim value
ml_osmesacreatecontextext( value _format,
                           value depthBits,
                           value stencilBits,
                           value accumBits,
                           value ml_sharelist )
{
    OSMesaContext ctx;
    OSMesaContext sharelist;
    GLenum format;

    if (Is_long(ml_sharelist))
        sharelist = NULL;
    else
        sharelist = (OSMesaContext) Field(ml_sharelist,0);

    switch (Int_val(_format)) {
        case 0: format = OSMESA_COLOR_INDEX; break;
        case 1: format = OSMESA_RGBA; break;
        case 2: format = OSMESA_BGRA; break;
        case 3: format = OSMESA_ARGB; break;
        case 4: format = OSMESA_RGB; break;
        case 5: format = OSMESA_BGR; break;
    }

#if OSMESA_MAJOR_VERSION * 100 + OSMESA_MINOR_VERSION >= 305
    ctx = OSMesaCreateContextExt( format,
                                  Int_val(depthBits),
                                  Int_val(stencilBits),
                                  Int_val(accumBits),
                                  sharelist );
#else
    caml_failwith("function OSMesaCreateContextExt not available");
#endif

    if (!ctx) {
        caml_failwith("osMesaCreateContextExt");
    }

    return (value) ctx;
}


CAMLprim value
ml_osmesacreatecontext( value _format,
                        value ml_sharelist )
{
    OSMesaContext ctx;
    OSMesaContext sharelist;
    GLenum format;

    if (Is_long(ml_sharelist))
        sharelist = NULL;
    else
        sharelist = (OSMesaContext) Field(ml_sharelist,0);

    switch (Int_val(_format)) {
        case 0: format = OSMESA_COLOR_INDEX; break;
        case 1: format = OSMESA_RGBA; break;
        case 2: format = OSMESA_BGRA; break;
        case 3: format = OSMESA_ARGB; break;
        case 4: format = OSMESA_RGB; break;
        case 5: format = OSMESA_BGR; break;
    }

    ctx = OSMesaCreateContext( format, sharelist );

    if (!ctx)
        caml_failwith("osMesaCreateContext");

    return (value) ctx;
}



CAMLprim value
ml_osmesamakecurrent( value ctx, value buffer_ba, value _type,
                      value width, value height )
{
    GLenum type;
    GLboolean ret;
    void *buffer;
    buffer = (void *) Data_bigarray_val(buffer_ba);

    if (Int_val(_type) != 0) caml_invalid_argument("OSMesaMakeCurrent");
    type = GL_UNSIGNED_BYTE;

    ret = OSMesaMakeCurrent( (OSMesaContext) ctx, buffer, type,
                             Int_val(width), Int_val(height) );

    if (!ret) caml_failwith("OSMesaMakeCurrent");

    return Val_unit;
}


CAMLprim value
ml_osmesadestroycontext( value ctx )
{
    OSMesaDestroyContext( (OSMesaContext) ctx );
    return Val_unit;
}


CAMLprim value ml_osmesa_major_version(value u) { return Val_int(OSMESA_MAJOR_VERSION); }
CAMLprim value ml_osmesa_minor_version(value u) { return Val_int(OSMESA_MINOR_VERSION); }
CAMLprim value ml_osmesa_patch_version(value u) { return Val_int(OSMESA_PATCH_VERSION); }


/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
