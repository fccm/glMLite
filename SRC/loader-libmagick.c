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

#include <string.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

/* ImageMagick <= 6.0.1 */
/* #include <magick/api.h> */

/* ImageMagick >= 6.2.4 */
#include <magick/ImageMagick.h>

#if (MaxMap == 65535UL)
  #define SCALE 257UL
#else
  #define SCALE 1UL
#endif

#if defined(__APPLE__) && !defined (VMDMESA)
  #include <OpenGL/gl.h>
  #include <OpenGL/glext.h>
#else
  #include <GL/gl.h>
  #include <GL/glext.h>
#endif

#include "loader-texure.h"

static int
Val_ImageType(ImageType image_type, int *components)
{
    switch (image_type)
    {
        case UndefinedType:            *components = 1; return 0;
        case BilevelType:              *components = 1; return 1;
        case GrayscaleType:            *components = 1; return 2;
        case GrayscaleMatteType:       *components = 2; return 3;
        case PaletteType:              *components = 3; return 4;
        case PaletteMatteType:         *components = 4; return 5;
        case TrueColorType:            *components = 3; return 6;
        case TrueColorMatteType:       *components = 4; return 7;
        case ColorSeparationType:      *components = 3; return 8;
        case ColorSeparationMatteType: *components = 4; return 9;
        case OptimizeType:             *components = 1; return 10;
        default:    *components = 0; return 11;  /* Error */
    }
}

CAMLprim value
magick_loader(value input)
{
    CAMLparam1(input);
    CAMLlocal2(pixel_matrix, res);
    Image *image_bloc;
    int image_type_code;
    int components;
    GLenum format;
    ExceptionInfo exception;
    GetExceptionInfo(&exception);
    {
        if (IsMagickInstantiated() == MagickFalse) {
            InitializeMagick(getenv("PWD"));
        }

        {
            ImageInfo *image_info;
            image_info = CloneImageInfo((ImageInfo *) NULL);
            switch (Tag_val(input))
            {
                /* given a filename of an image */
                case 0:
                    (void) strcpy(image_info->filename, String_val(Field(input,0)));
                    image_bloc = ReadImage(image_info, &exception);
                    break;

                /* given the image data in a buffer */
                case 1:
                    image_bloc = BlobToImage(
                        image_info,
                        (void *)String_val(Field(input,0)),
                        caml_string_length(Field(input,0)),
                        &exception);
                    break;
            }
            DestroyImageInfo(image_info);
        }

        if (exception.severity != UndefinedException) {
            if (image_bloc != (Image *) NULL) {
                DestroyImage(image_bloc);
            }
            DestroyExceptionInfo(&exception);
            caml_failwith( exception.reason );
            /* @TODO  exception.description */
        }

        if (image_bloc == (Image *) NULL) {
            DestroyExceptionInfo(&exception);
            caml_failwith("read image failed");
        }
    }
    {
        ImageType image_type;
        image_type = GetImageType( image_bloc, &exception );

        if (exception.severity != UndefinedException)
            caml_failwith( exception.reason );

        image_type_code = Val_ImageType(image_type, &components);

        if ( image_type_code == 11 )
            caml_failwith("getting image type failed");
    }
    {
        unsigned long x, y;
        unsigned long columns, rows;

        PixelPacket pixel;

        columns = image_bloc->columns;
        rows    = image_bloc->rows;

        const PixelPacket * pixel_packet_array;

        pixel_packet_array =
                AcquireImagePixels(
                         image_bloc,
                         0, 0, columns, rows,
                         &exception );

        if (exception.severity != UndefinedException) {
            caml_failwith(exception.reason);
        }

        {
            unsigned char *image;
            long ndx;
            long dims[3];
            dims[0] = columns;
            dims[1] = rows;
            dims[2] = components;
            pixel_matrix = alloc_bigarray(BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT, 3, NULL, dims);
            image = Data_bigarray_val(pixel_matrix);
            for (x=0; x < columns; ++x) {
                for (y=0; y < rows; ++y) {
                    pixel = pixel_packet_array[(columns * y) + x];

                    ndx = (columns * y * components) + (x * components);
                    switch (components) {
                        case 1:
                            image[ndx + 0] = pixel.red   / SCALE;
                            break;
                        case 2:
                            image[ndx + 0] = pixel.red   / SCALE;
                            image[ndx + 1] = ( MaxMap - pixel.opacity ) / SCALE;
                            break;
                        case 3:
                            image[ndx + 0] = pixel.red   / SCALE;
                            image[ndx + 1] = pixel.green / SCALE;
                            image[ndx + 2] = pixel.blue  / SCALE;
                            break;
                        case 4:
                            image[ndx + 0] = pixel.red   / SCALE;
                            image[ndx + 1] = pixel.green / SCALE;
                            image[ndx + 2] = pixel.blue  / SCALE;
                            image[ndx + 3] = ( MaxMap - pixel.opacity ) / SCALE;
                            break;
                    }
                }
            }
        }

        switch (components) {
            case 1: format = GL_LUMINANCE; break;
            case 2: format = GL_LUMINANCE_ALPHA; break;
            case 3: format = GL_RGB; break;
            case 4: format = GL_RGBA; break;
        }

        res = alloc_tuple(5);
        Store_field(res, 0, pixel_matrix );
        Store_field(res, 1, Val_long(columns) );
        Store_field(res, 2, Val_long(rows) );
        Store_field(res, 3, Val_internal_format(components) );
        Store_field(res, 4, Val_pixel_data_format(format) );
    }
    DestroyExceptionInfo(&exception);
    DestroyImage(image_bloc);
    CAMLreturn(res);
}

// vim: sw=4 sts=4 ts=4 et fdm=marker
