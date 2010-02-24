#ifndef LTEXCONV_H
#define LTEXCONV_H

static inline value Val_pixel_data_format(GLenum _pixel_data_format)
{
  int pixel_data_format;
#include "enums/pixel_data_format.inc-r.c"
  return Val_long(pixel_data_format);
}

static value Val_internal_format(int num_components)
{
    GLint _internal_format;
    int internal_format;
    switch (num_components)
    {
        case 1: _internal_format = GL_LUMINANCE; break;
        case 2: _internal_format = GL_LUMINANCE_ALPHA; break;
        case 3: _internal_format = GL_RGB; break;
        case 4: _internal_format = GL_RGBA; break;

        default: _internal_format = GL_LUMINANCE; break;
    }
#include "enums/internal_format.inc-r.c"
    return Val_int(internal_format);
}

#endif
