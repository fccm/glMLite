/* {{{ COPYING 

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
