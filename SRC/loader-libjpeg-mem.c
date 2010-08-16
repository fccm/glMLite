/* jpeg texture loader from memory
 * last modification: feb. 9, 2006
 *
 * Copyright (c) 2005-2006 David HENRY
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>

#include <jpeglib.h>

/* Microsoft Visual C++ */
#ifdef _MSC_VER
#pragma comment (lib, "libjpeg.lib")
#endif /* _MSC_VER */

#include "loader-texure.h"

static void
mem_init_source (j_decompress_ptr cinfo)
{
    /* nothing to do */
}

static boolean
mem_fill_input_buffer (j_decompress_ptr cinfo)
{
    JOCTET eoi_buffer[2] = { 0xFF, JPEG_EOI };
    struct jpeg_source_mgr *jsrc = cinfo->src;

    /* create a fake EOI marker */
    jsrc->next_input_byte = eoi_buffer;
    jsrc->bytes_in_buffer = 2;

    return TRUE;
}

static void
mem_skip_input_data (j_decompress_ptr cinfo, long num_bytes)
{
  struct jpeg_source_mgr *jsrc = cinfo->src;

  if (num_bytes > 0)
    {
      while (num_bytes > (long)jsrc->bytes_in_buffer)
        {
          num_bytes -= (long)jsrc->bytes_in_buffer;
          mem_fill_input_buffer (cinfo);
        }

      jsrc->next_input_byte += num_bytes;
      jsrc->bytes_in_buffer -= num_bytes;
    }
}

static void
mem_term_source (j_decompress_ptr cinfo)
{
    /* nothing to do */
}

static void
err_exit (j_common_ptr cinfo)
{
    /* get error manager */
    my_error_ptr jerr = (my_error_ptr)(cinfo->err);

    /* display error message */
    (*cinfo->err->output_message) (cinfo);

    /* return control to the setjmp point */
    longjmp (jerr->setjmp_buffer, 1);
}


static value
read_jpeg_from_memory (value buffer)
{
    CAMLparam1(buffer);
    CAMLlocal2(ret, img_ba);

    struct jpeg_decompress_struct cinfo;
    struct my_error_mgr jerr;
    struct jpeg_source_mgr jsrc;
    int output_color_space;
    GLenum format;
    int format_err;

    /* create and configure decompress object */
    jpeg_create_decompress (&cinfo);
    cinfo.err = jpeg_std_error (&jerr.pub);
    cinfo.src = &jsrc;

    /* configure error manager */
    jerr.pub.error_exit = err_exit;

    if (setjmp (jerr.setjmp_buffer))
    {
        jpeg_destroy_decompress (&cinfo);
        caml_failwith("Error while loading jpeg from buffer");
    }

    /* configure source manager */
    jsrc.next_input_byte = (JOCTET *) String_val(buffer);
    jsrc.bytes_in_buffer = caml_string_length(buffer);
    jsrc.init_source = mem_init_source;
    jsrc.fill_input_buffer = mem_fill_input_buffer;
    jsrc.skip_input_data = mem_skip_input_data;
    jsrc.resync_to_restart = jpeg_resync_to_restart;
    jsrc.term_source = mem_term_source;

    jpeg_read_header (&cinfo, TRUE);

    switch (cinfo.out_color_space) {
        case JCS_RGB:       output_color_space = 0; format_err = 0; format = GL_RGB; break;
        case JCS_GRAYSCALE: output_color_space = 1; format_err = 0; format = GL_LUMINANCE; break;
        case JCS_CMYK:      output_color_space = 2; format_err = 1; break;
        case JCS_YCbCr:     output_color_space = 3; format_err = 1; break;
        case JCS_YCCK:      output_color_space = 4; format_err = 1; break;
        case JCS_UNKNOWN:   output_color_space = 5; format_err = 1; break;
        default:            output_color_space = 5; format_err = 1; break;
    }

    jpeg_start_decompress (&cinfo);

    {
        unsigned char *image;
        unsigned char *line;
        long dims[3];
        dims[0] = cinfo.output_width;
        dims[1] = cinfo.output_height;
        dims[2] = cinfo.output_components;
        img_ba = alloc_bigarray(BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT, 3, NULL, dims);
        image = Data_bigarray_val(img_ba);
        line = image;

        while (cinfo.output_scanline < cinfo.output_height) {
            line = image + cinfo.output_components * cinfo.output_width * cinfo.output_scanline;
            (void) jpeg_read_scanlines(&cinfo, &line, 1);
        }
    }

    /* finish decompression and release memory */
    jpeg_finish_decompress (&cinfo);
    jpeg_destroy_decompress (&cinfo);

    ret = caml_alloc(5, 0);

    Store_field( ret, 0, img_ba );
    Store_field( ret, 1, Val_int(cinfo.output_width) );
    Store_field( ret, 2, Val_int(cinfo.output_height) );
    Store_field( ret, 3, Val_internal_format(cinfo.output_components) );
    Store_field( ret, 4, Val_pixel_data_format(format) );

    jpeg_destroy_decompress(&cinfo);

    CAMLreturn( ret );
}

// vim: sw=4 sts=4 ts=4 et fdm=marker
