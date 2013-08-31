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

#include <stdlib.h>
#include <string.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

#include <librsvg/rsvg.h>

#if defined(__APPLE__) && !defined (VMDMESA)
  #include <OpenGL/gl.h>
  #include <OpenGL/glext.h>
#else
  #include <GL/gl.h>
  #include <GL/glext.h>
#endif

#include "loader-texure.h"

CAMLprim value ml_rsvg_loader( value input )
{
    CAMLparam1(input);
    CAMLlocal2(pixel_matrix, res);

    GdkPixbuf *pixbuf = NULL;
    GError *error = NULL;
    gboolean has_alpha;
    char err_buf[192];
    int width;
    int height;
    int components;

    GLenum format;

    rsvg_init();

    switch (Tag_val(input))
    {
        /* given a filename of a SVG file */
        case 0:
            pixbuf = rsvg_pixbuf_from_file( (gchar *) String_val(Field(input,0)), &error);
            break;

        /* given a SVG data in a buffer */
        case 1:
        {
            RsvgHandle * svg_handle;
            svg_handle = rsvg_handle_new();
            (void) rsvg_handle_write (svg_handle,
                            (guchar *)String_val(Field(input,0)),
                            caml_string_length(Field(input,0)),
                            &error);
            if (error != NULL)
            {
                snprintf(err_buf, 192, "SVG loader: Failed to write buffer: %s", error->message);
                g_error_free(error);
                error = NULL;
                caml_failwith(err_buf);
            }
            (void) rsvg_handle_close (svg_handle, &error);
            if (error != NULL)
            {
                snprintf(err_buf, 192, "SVG loader: Failed to close handle: %s", error->message);
                g_error_free(error);
                error = NULL;
                caml_failwith(err_buf);
            }
            pixbuf = rsvg_handle_get_pixbuf (svg_handle);
            rsvg_handle_free (svg_handle);
        }
        break;
    }

    if (error != NULL)
    {
        snprintf(err_buf, 192, "SVG loader: Error %s", error->message);
        if (pixbuf != NULL) gdk_pixbuf_unref(pixbuf);
        rsvg_term();
        caml_failwith(err_buf);
    }
    if (pixbuf == NULL) {
        rsvg_term();
        caml_failwith("SVG loader: Error empty pixbuf");
    }

    { GdkColorspace color_space;
      color_space = gdk_pixbuf_get_colorspace (pixbuf);
      if (color_space != GDK_COLORSPACE_RGB) {
        fprintf(stderr, "SVG loader: Warning, colorspace is not RGB\n");
      }
    }

    { int bits = gdk_pixbuf_get_bits_per_sample (pixbuf);
      if (bits != 8) {
        rsvg_term();
        caml_failwith("SVG loader: number of bits per sample does not match");
      }
    }

    width = gdk_pixbuf_get_width (pixbuf);
    height = gdk_pixbuf_get_height (pixbuf);

    components = gdk_pixbuf_get_n_channels (pixbuf);
    has_alpha = gdk_pixbuf_get_has_alpha (pixbuf);

    {
        //int x, y, i;
        long dims[3];
        unsigned char *image;
        guchar * data;
        data = gdk_pixbuf_get_pixels (pixbuf);

        dims[0] = width;
        dims[1] = height;
        dims[2] = components;
        pixel_matrix = alloc_bigarray(BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT, 3, NULL, dims);
        image = Data_bigarray_val(pixel_matrix);

        memcpy ( image, data, (width * height * components) );

        /*
        // TODO: we get alpha even with file which have the background filled
        //       so maybe we should add a parameter to strip the alpha ?
        for (y=0; y<height; ++y) {
            for (x=0; x<width; ++x) {
                int ndx;
                ndx = (y * width * components) + (x * components);
                if (has_alpha && do_strip_alpha)
                    for (i=0; i < (components - 1); ++i)
                        image[ndx + i] = data[ndx + i];
                else
                    for (i=0; i<components; ++i)
                        image[ndx + i] = data[ndx + i];
            }
        }
        */
    }

    gdk_pixbuf_unref(pixbuf);

    switch (components) {
        case 3: format = GL_RGB; break;
        case 4: format = GL_RGBA; break;
        case 2: format = GL_LUMINANCE_ALPHA; break;
        case 1: format = GL_LUMINANCE; break;
        default: caml_failwith("SVG loader: format error");
    }

    res = alloc_tuple(5);
    Store_field(res, 0, pixel_matrix );
    Store_field(res, 1, Val_long(width) );
    Store_field(res, 2, Val_long(height) );
    /*
    Store_field(res, 3, Val_long(components) );
    Store_field(res, 4, Val_bool(has_alpha) );
    */
    Store_field(res, 3, Val_internal_format(components) );
    Store_field(res, 4, Val_pixel_data_format(format) );

    CAMLreturn(res);
}

// vim: ts=4 sts=4 sw=4 et fdm=marker
