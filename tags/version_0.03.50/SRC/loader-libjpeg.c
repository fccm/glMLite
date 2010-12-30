#include <stdio.h>
#include <string.h>
#include <setjmp.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

#if defined(__APPLE__) && !defined (VMDMESA)
  #include <OpenGL/gl.h>
  #include <OpenGL/glext.h>
#else
  #include <GL/gl.h>
  #include <GL/glext.h>
#endif

#include <jpeglib.h>

#include "loader-texure.h"

struct my_error_mgr {
    struct jpeg_error_mgr pub;    /* "public" fields */
    jmp_buf setjmp_buffer;        /* for return to caller */
};

typedef struct my_error_mgr * my_error_ptr;

#include "loader-libjpeg-mem.c"

/* Routine that replaces the standard error_exit method */
METHODDEF(void)
my_error_exit (j_common_ptr cinfo)
{
    my_error_ptr myerr = (my_error_ptr) cinfo->err;
    (*cinfo->err->output_message) (cinfo);
    longjmp(myerr->setjmp_buffer, 1);
}

/* JPEG decompression */
GLOBAL(value)
load_jpeg_from_file (value filename)
{
    CAMLparam1(filename);
    CAMLlocal2(ret, img_ba);

    struct jpeg_decompress_struct cinfo;
    struct my_error_mgr jerr;
    char err_buf[192];
    int output_color_space;
    FILE * infile;
    unsigned char *image;
    GLenum format;
    int format_err;

    if ((infile = fopen(String_val(filename), "rb")) == NULL) {
        snprintf(err_buf, 192, "Error: couldn't open jpeg file \"%s\"", String_val(filename));
        caml_failwith(err_buf);
    }

    cinfo.err = jpeg_std_error(&jerr.pub);
    jerr.pub.error_exit = my_error_exit;

    if (setjmp(jerr.setjmp_buffer)) {
        jpeg_destroy_decompress(&cinfo);
        fclose(infile);
        snprintf(err_buf, 192, "Error while loading jpeg file \"%s\"", String_val(filename));
        caml_failwith(err_buf);
    }

    jpeg_create_decompress(&cinfo);

    jpeg_stdio_src(&cinfo, infile);

    (void) jpeg_read_header(&cinfo, TRUE);


    switch (cinfo.out_color_space) {
        case JCS_RGB:       output_color_space = 0; format_err = 0; format = GL_RGB; break;
        case JCS_GRAYSCALE: output_color_space = 1; format_err = 0; format = GL_LUMINANCE; break;
        case JCS_CMYK:      output_color_space = 2; format_err = 1; break;
        case JCS_YCbCr:     output_color_space = 3; format_err = 1; break;
        case JCS_YCCK:      output_color_space = 4; format_err = 1; break;
        case JCS_UNKNOWN:   output_color_space = 5; format_err = 1; break;
        default:            output_color_space = 5; format_err = 1; break;
    }

    (void) jpeg_start_decompress(&cinfo);
    {
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

    (void) jpeg_finish_decompress(&cinfo);

    fclose(infile);

    ret = caml_alloc(5, 0);

    Store_field( ret, 0, img_ba );
    Store_field( ret, 1, Val_int(cinfo.output_width) );
    Store_field( ret, 2, Val_int(cinfo.output_height) );
    Store_field( ret, 3, Val_internal_format(cinfo.output_components) );
    Store_field( ret, 4, Val_pixel_data_format(format) );

    jpeg_destroy_decompress(&cinfo);

    CAMLreturn( ret );
}


CAMLprim value
caml_load_jpeg_file (value input)
{
    switch (Tag_val(input))
    {
        /* given a filename of an image */
        case 0:
            return load_jpeg_from_file (Field(input,0));
            break;

        /* given the image data in a buffer */
        case 1:
            return read_jpeg_from_memory (Field(input,0));
            break;
    }
    caml_failwith("BUG");
}

// vim: sw=4 sts=4 ts=4 et fdm=marker
