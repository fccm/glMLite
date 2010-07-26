/* {{{ COPYING 

  +-----------------------------------------------------------------------+
  |  This file belongs to glMLite, an OCaml binding to the OpenGL API.    |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2006 - 2010  Florent Monnier                           |
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

#define GL_GLEXT_PROTOTYPES

#if defined(__APPLE__) && !defined (VMDMESA)
  #include <OpenGL/gl.h>
  #include <OpenGL/glext.h>
#else
  #if defined(USE_MY_GL3_CORE_PROFILE)
    #define GL3_PROTOTYPES 1
    #include <GL3/gl3.h>
    #include "gl3_deprecations.h"
  #else
    #include <GL/gl.h>
    #include <GL/glext.h>
  #endif
#endif

#include <caml/mlvalues.h>
#include <caml/bigarray.h>
#include <caml/fail.h>
#include <caml/config.h>

#include <stdint.h>


#ifdef _WIN32
#include <windows.h>
#include <wtypes.h>

#define CHECK_FUNC(func, f_type) \
    static f_type func = NULL; \
    static unsigned int func##_is_loaded = 0; \
    if (!func##_is_loaded) { \
        func = (f_type) wglGetProcAddress(#func); \
        if (func == NULL) caml_failwith("Unable to load " #func); \
        else func##_is_loaded = 1; \
    }

#define LINUX_FUNC(func, f_type)

#else
#include <GL/glx.h>
#define CHECK_FUNC(func, f_type)
#define LINUX_FUNC(func, f_type) \
    static f_type func = NULL; \
    static unsigned int func##_is_loaded = 0; \
    if (!func##_is_loaded) { \
        func = (f_type) glXGetProcAddress((GLubyte *)#func); \
        if (func == NULL) caml_failwith("Unable to load " #func); \
        else func##_is_loaded = 1; \
    }

#endif



/* Vertex Arrays Bindings */


CAMLprim value
ml_glenableclientstate( value _cap )
{
    GLenum cap;
    switch (Int_val(_cap))
    {
        case 0: cap = GL_COLOR_ARRAY;           break;
        case 1: cap = GL_EDGE_FLAG_ARRAY;       break;
#if defined(GL_VERSION_1_5)
        case 2: cap = GL_FOG_COORD_ARRAY;       break;
#else
        case 2:
            caml_failwith("glEnableClientState: GL_FOG_COORD_ARRAY only since OpenGL 1.5");
            break;
#endif
        case 3: cap = GL_INDEX_ARRAY;           break;
        case 4: cap = GL_NORMAL_ARRAY;          break;
        case 5: cap = GL_SECONDARY_COLOR_ARRAY; break;
        case 6: cap = GL_TEXTURE_COORD_ARRAY;   break;
        case 7: cap = GL_VERTEX_ARRAY;          break;
    }
    glEnableClientState( cap );
    return Val_unit;
}


CAMLprim value
ml_gldisableclientstate( value _cap )
{
    GLenum cap;
    switch (Int_val(_cap))
    {
        case 0: cap = GL_COLOR_ARRAY;           break;
        case 1: cap = GL_EDGE_FLAG_ARRAY;       break;
#if defined(GL_VERSION_1_5)
        case 2: cap = GL_FOG_COORD_ARRAY;       break;
#else
        case 2:
            caml_failwith("glDisableClientState: GL_FOG_COORD_ARRAY only since OpenGL 1.5");
            break;
#endif
        case 3: cap = GL_INDEX_ARRAY;           break;
        case 4: cap = GL_NORMAL_ARRAY;          break;
        case 5: cap = GL_SECONDARY_COLOR_ARRAY; break;
        case 6: cap = GL_TEXTURE_COORD_ARRAY;   break;
        case 7: cap = GL_VERTEX_ARRAY;          break;
    }
    glDisableClientState( cap );
    return Val_unit;
}


CAMLprim value
ml_gldrawarrays( value mode, value first, value count )
{
    glDrawArrays( Int_val(mode), Int_val(first), Int_val(count) );
    return Val_unit;
}


CAMLprim value
ml_glarrayelement( value i )
{
    glArrayElement( Int_val(i) );
    return Val_unit;
}

#if defined(GL_VERSION_1_4) && defined(GL_GLEXT_PROTOTYPES)
CAMLprim value
ml_glmultidrawarrays( value mode, value ml_array )
{
    GLint * first;
    GLsizei * count;
    GLsizei primcount;

    int i, len;
    len = Wosize_val(ml_array);
    primcount = len;

    first = malloc(len * sizeof(GLint));
    count = malloc(len * sizeof(GLsizei));
 
    for (i=0; i < len; i++)
    {
        first[i] = Int_val(Field(Field(ml_array, i), 0));
        count[i] = Int_val(Field(Field(ml_array, i), 1));
    }

    glMultiDrawArrays( Int_val(mode), first, count, primcount );

    free(first);
    free(count);

    return Val_unit;
}
#else
CAMLprim value
ml_glmultidrawarrays( value mode, value ml_array )
{
    caml_failwith("glMultiDrawArrays: function not available");
    return Val_unit;
}
#endif

/* TODO
void glGetPointerv( GLenum pname, GLvoid **params );
*/

CAMLprim value
ml_glinterleavedarrays( value _interleaved_format, value stride, value pointer_array )
{
    GLenum interleaved_format;
    GLvoid * pointer;
    pointer = (GLvoid *) Data_bigarray_val(pointer_array);
#include "enums/interleaved_format.inc.c"
    glInterleavedArrays( interleaved_format, Int_val(stride), pointer );
    return Val_unit;
}


CAMLprim value
ml_gldrawelements(
        value mode,
        value count,
        value ndx_type,
        value indices_array )
{
    GLenum type;
    GLvoid * indices;
    indices = (GLvoid *) Data_bigarray_val(indices_array);

    switch (Int_val(ndx_type))
    {
        case 0: type = GL_UNSIGNED_BYTE;  break;
        case 1: type = GL_UNSIGNED_SHORT; break;
        case 2: type = GL_UNSIGNED_INT;   break;
    }

    switch (Bigarray_val(indices_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_UINT8:
            if (type != GL_UNSIGNED_BYTE)
                caml_failwith("glDrawElements: data type does not match");
            break;

        case BIGARRAY_UINT16:
            if (type != GL_UNSIGNED_SHORT)
                caml_failwith("glDrawElements: data type does not match");
            break;

        case BIGARRAY_CAML_INT:    // 31- or 63-bit signed integers
        case BIGARRAY_NATIVE_INT:  // 32- or 64-bit (platform-native) integers
            if (type != GL_UNSIGNED_INT)
                caml_failwith("glDrawElements: data type does not match");
            break;

        case BIGARRAY_INT32:   // 32-bit signed integers
            switch (type) {
                case GL_UNSIGNED_BYTE:
                    caml_failwith("glDrawElements: data type does not match");
                    break;
                case GL_UNSIGNED_SHORT:
                    if (SIZEOF_SHORT != 4)
                        caml_failwith("glDrawElements: data type does not match");
                    break;
                case GL_UNSIGNED_INT:
                    if (SIZEOF_INT != 4)
                        caml_failwith("glDrawElements: data type does not match");
                    break;
            }
            break;

        case BIGARRAY_INT64:   // 64-bit signed integers
            switch (type) {
                case GL_UNSIGNED_BYTE:
                    caml_failwith("glDrawElements: data type does not match");
                    break;
                case GL_UNSIGNED_SHORT:
                    if (SIZEOF_SHORT != 8)
                        caml_failwith("glDrawElements: data type does not match");
                    break;
                case GL_UNSIGNED_INT:
                    if (SIZEOF_INT != 8)
                        caml_failwith("glDrawElements: data type does not match");
                    break;
            }
            break;
    }

    glDrawElements(
            Int_val(mode),
            Int_val(count),
            type,
            indices );

    return Val_unit;
}


CAMLprim value
ml_gldrawrangeelements_native(
        value mode,
        value start,
        value end,
        value count,
        value ndx_type,
        value indices_array )
{
    GLenum type;
    GLvoid * indices;
    indices = (GLvoid *) Data_bigarray_val(indices_array);

    switch (Int_val(ndx_type))
    {
        case 0: type = GL_UNSIGNED_BYTE;  break;
        case 1: type = GL_UNSIGNED_SHORT; break;
        case 2: type = GL_UNSIGNED_INT;   break;
    }

    switch (Bigarray_val(indices_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_UINT8:
            if (type != GL_UNSIGNED_BYTE)
                caml_failwith("glDrawElements: data type does not match");
            break;

        case BIGARRAY_UINT16:
            if (type != GL_UNSIGNED_SHORT)
                caml_failwith("glDrawElements: data type does not match");
            break;

        case BIGARRAY_CAML_INT:    // 31- or 63-bit signed integers
        case BIGARRAY_NATIVE_INT:  // 32- or 64-bit (platform-native) integers
            if (type != GL_UNSIGNED_INT)
                caml_failwith("glDrawElements: data type does not match");
            break;

        /*
        BIGARRAY_INT32  32-bit signed integers
        BIGARRAY_INT64  64-bit signed integers
        */
    }

    CHECK_FUNC(glDrawRangeElements, PFNGLDRAWRANGEELEMENTSPROC)
    glDrawRangeElements(
            Int_val(mode),
            Int_val(start),
            Int_val(end),
            Int_val(count),
            type,
            indices );

    return Val_unit;
}
CAMLprim value
ml_gldrawrangeelements_bytecode( value * argv, int argn )
    { return ml_gldrawrangeelements_native( argv[0], argv[1], argv[2],
                                            argv[3], argv[4], argv[5] ); }




CAMLprim value
ml_glvertexpointer( value elem_size,
                    value _data_type,
                    value stride,
                    value vertex_array )
{
    int size, _size;
    intnat dim;
    GLvoid * pointer;
    GLenum data_type;

    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }

    switch (data_type)
    {
        case GL_SHORT:  _size = sizeof(GLshort);  break;
        case GL_INT:    _size = sizeof(GLint);    break;
        case GL_FLOAT:  _size = sizeof(GLfloat);  break;
        case GL_DOUBLE: _size = sizeof(GLdouble); break;
    }

    switch (Bigarray_val(vertex_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_SINT8:
        case BIGARRAY_UINT8:      size = 1; break;

        case BIGARRAY_SINT16:
        case BIGARRAY_UINT16:     size = 2; break;

        case BIGARRAY_FLOAT32:
        case BIGARRAY_INT32:      size = 4; break;

        case BIGARRAY_FLOAT64:
        case BIGARRAY_INT64:      size = 8; break;

        case BIGARRAY_CAML_INT:   size = sizeof(intnat) /* SIZEOF_LONG */; break;
        case BIGARRAY_NATIVE_INT: size = sizeof(intnat) /* SIZEOF_INT */; break;

        default:
            caml_failwith("Vertex array, unsupported data type");
    }

    if (size != _size)
        caml_failwith("Vertex array size of data does not match");

    if (Bigarray_val(vertex_array)->num_dims != 1)
        caml_failwith("Vertex array number of dimensions should be 1");

    dim = Bigarray_val(vertex_array)->dim[0];

    if (!dim) pointer = NULL;
    else pointer = (GLvoid *) Data_bigarray_val(vertex_array);

    glVertexPointer( Int_val(elem_size),
                     data_type,
                     Int_val(stride),
                     pointer );

    return Val_unit;
}

CAMLprim value
ml_glvertexpointer0( value elem_size, value _data_type, value stride )
{
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }

    glVertexPointer( Int_val(elem_size), data_type, Int_val(stride), 0 );
    return Val_unit;
}


CAMLprim value
ml_gltexcoordpointer( value elem_size,
                      value _data_type,
                      value stride,
                      value texcoord_array )
{
    int size, _size;
    intnat dim;
    GLvoid * pointer;
    GLenum data_type;

    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }

    switch (data_type)
    {
        case GL_SHORT:  _size = sizeof(GLshort);  break;
        case GL_INT:    _size = sizeof(GLint);    break;
        case GL_FLOAT:  _size = sizeof(GLfloat);  break;
        case GL_DOUBLE: _size = sizeof(GLdouble); break;
    }

    switch (Bigarray_val(texcoord_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_SINT8:
        case BIGARRAY_UINT8:      size = 1; break;

        case BIGARRAY_SINT16:
        case BIGARRAY_UINT16:     size = 2; break;

        case BIGARRAY_FLOAT32:
        case BIGARRAY_INT32:      size = 4; break;

        case BIGARRAY_FLOAT64:
        case BIGARRAY_INT64:      size = 8; break;

        case BIGARRAY_CAML_INT:   size = sizeof(intnat) /* SIZEOF_LONG */; break;
        case BIGARRAY_NATIVE_INT: size = sizeof(intnat) /* SIZEOF_INT */; break;

        default:
            caml_failwith("TexCoord array, unsupported data type");
    }

    if (size != _size)
        caml_failwith("TexCoord array size of data does not match");

    if (Bigarray_val(texcoord_array)->num_dims != 1)
        caml_failwith("TexCoord array number of dimensions should be 1");

    dim = Bigarray_val(texcoord_array)->dim[0];

    if (!dim) pointer = NULL;
    else pointer = (GLvoid *) Data_bigarray_val(texcoord_array);

    glTexCoordPointer( Int_val(elem_size),
                       data_type,
                       Int_val(stride),
                       pointer );

    return Val_unit;
}


CAMLprim value
ml_gltexcoordpointer0( value elem_size, value _data_type, value stride )
{
    GLenum data_type;
    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }

    glTexCoordPointer( Int_val(elem_size), data_type, Int_val(stride), 0 );
    return Val_unit;
}




CAMLprim value
ml_glnormalpointer( value _data_type,
                    value stride,
                    value normal_array )
{
    int size, _size;
    intnat dim;
    GLvoid * pointer;
    GLenum data_type;

    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_BYTE;   break;
        case 1: data_type = GL_SHORT;  break;
        case 2: data_type = GL_INT;    break;
        case 3: data_type = GL_FLOAT;  break;
        case 4: data_type = GL_DOUBLE; break;
    }

    switch (data_type)
    {
        case GL_BYTE:   _size = sizeof(GLbyte);   break;
        case GL_SHORT:  _size = sizeof(GLshort);  break;
        case GL_INT:    _size = sizeof(GLint);    break;
        case GL_FLOAT:  _size = sizeof(GLfloat);  break;
        case GL_DOUBLE: _size = sizeof(GLdouble); break;
    }

    switch (Bigarray_val(normal_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_SINT8:
        case BIGARRAY_UINT8:      size = 1; break;

        case BIGARRAY_SINT16:
        case BIGARRAY_UINT16:     size = 2; break;

        case BIGARRAY_FLOAT32:
        case BIGARRAY_INT32:      size = 4; break;

        case BIGARRAY_FLOAT64:
        case BIGARRAY_INT64:      size = 8; break;

        case BIGARRAY_CAML_INT:   size = sizeof(intnat) /* SIZEOF_LONG */; break;
        case BIGARRAY_NATIVE_INT: size = sizeof(intnat) /* SIZEOF_INT */; break;

        default:
            caml_failwith("Normal array, unsupported data type");
    }

    if (size != _size)
        caml_failwith("Normal array size of data does not match");

    if (Bigarray_val(normal_array)->num_dims != 1)
        caml_failwith("Normal array number of dimensions should be 1");

    dim = Bigarray_val(normal_array)->dim[0];

    if (!dim) pointer = NULL;
    else pointer = (GLvoid *) Data_bigarray_val(normal_array);

    glNormalPointer( data_type,
                     Int_val(stride),
                     pointer );

    return Val_unit;
}


CAMLprim value
ml_glnormalpointer0( value _data_type, value stride )
{
    GLenum data_type;
    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_BYTE;   break;
        case 1: data_type = GL_SHORT;  break;
        case 2: data_type = GL_INT;    break;
        case 3: data_type = GL_FLOAT;  break;
        case 4: data_type = GL_DOUBLE; break;
    }

    glNormalPointer( data_type, Int_val(stride), 0 );
    return Val_unit;
}



CAMLprim value
ml_glindexpointer( value _data_type,
                    value stride,
                    value index_array )
{
    int size, _size;
    intnat dim;
    GLvoid * pointer;
    GLenum data_type;

    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_UNSIGNED_BYTE; break;
        case 1: data_type = GL_SHORT;         break;
        case 2: data_type = GL_INT;           break;
        case 3: data_type = GL_FLOAT;         break;
        case 4: data_type = GL_DOUBLE;        break;
    }

    switch (data_type)
    {
        case GL_UNSIGNED_BYTE: _size = sizeof(GLubyte);  break;
        case GL_SHORT:         _size = sizeof(GLshort);  break;
        case GL_INT:           _size = sizeof(GLint);    break;
        case GL_FLOAT:         _size = sizeof(GLfloat);  break;
        case GL_DOUBLE:        _size = sizeof(GLdouble); break;
    }

    switch (Bigarray_val(index_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_SINT8:
        case BIGARRAY_UINT8:      size = 1; break;

        case BIGARRAY_SINT16:
        case BIGARRAY_UINT16:     size = 2; break;

        case BIGARRAY_FLOAT32:
        case BIGARRAY_INT32:      size = 4; break;

        case BIGARRAY_FLOAT64:
        case BIGARRAY_INT64:      size = 8; break;

        case BIGARRAY_CAML_INT:   size = sizeof(intnat) /* SIZEOF_LONG */; break;
        case BIGARRAY_NATIVE_INT: size = sizeof(intnat) /* SIZEOF_INT */; break;

        default:
            caml_failwith("Index array, unsupported data type");
    }

    if (size != _size)
        caml_failwith("Index array size of data does not match");

    if (Bigarray_val(index_array)->num_dims != 1)
        caml_failwith("Index array number of dimensions should be 1");

    dim = Bigarray_val(index_array)->dim[0];

    if (!dim) pointer = NULL;
    else pointer = (GLvoid *) Data_bigarray_val(index_array);

    glIndexPointer( data_type,
                    Int_val(stride),
                    pointer );

    return Val_unit;
}


CAMLprim value
ml_glindexpointer0( value _data_type, value stride )
{
    GLenum data_type;
    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_UNSIGNED_BYTE; break;
        case 1: data_type = GL_SHORT;         break;
        case 2: data_type = GL_INT;           break;
        case 3: data_type = GL_FLOAT;         break;
        case 4: data_type = GL_DOUBLE;        break;
    }

    glIndexPointer( data_type, Int_val(stride), 0 );
    return Val_unit;
}



CAMLprim value
ml_glcolorpointer( value elem_size,
                   value _data_type,
                   value stride,
                   value color_array )
{
    int size, _size;
    intnat dim;
    GLvoid * pointer;
    GLenum data_type;

    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }

    switch (data_type)
    {
        case GL_BYTE:           _size = sizeof(GLbyte);   break;
        case GL_UNSIGNED_BYTE:  _size = sizeof(GLubyte);  break;

        case GL_SHORT:          _size = sizeof(GLshort);  break;
        case GL_UNSIGNED_SHORT: _size = sizeof(GLushort); break;

        case GL_INT:            _size = sizeof(GLint);    break;
        case GL_UNSIGNED_INT:   _size = sizeof(GLuint);   break;

        case GL_FLOAT:          _size = sizeof(GLfloat);  break;
        case GL_DOUBLE:         _size = sizeof(GLdouble); break;
    }

    switch (Bigarray_val(color_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_SINT8:
        case BIGARRAY_UINT8:      size = 1; break;

        case BIGARRAY_SINT16:
        case BIGARRAY_UINT16:     size = 2; break;

        case BIGARRAY_FLOAT32:
        case BIGARRAY_INT32:      size = 4; break;

        case BIGARRAY_FLOAT64:
        case BIGARRAY_INT64:      size = 8; break;

        case BIGARRAY_CAML_INT:   size = sizeof(intnat) /* SIZEOF_LONG */; break;
        case BIGARRAY_NATIVE_INT: size = sizeof(intnat) /* SIZEOF_INT */; break;

        default:
            caml_failwith("Color array, unsupported data type");
    }

    if (size != _size)
        caml_failwith("Color array size of data does not match");

    if (Bigarray_val(color_array)->num_dims != 1)
        caml_failwith("Color array number of dimensions should be 1");

    dim = Bigarray_val(color_array)->dim[0];

    if (!dim) pointer = NULL;
    else pointer = (GLvoid *) Data_bigarray_val(color_array);

    glColorPointer( Int_val(elem_size),
                    data_type,
                    Int_val(stride),
                    pointer );

    return Val_unit;
}

CAMLprim value
ml_glsecondarycolorpointer( value elem_size,
                            value _data_type,
                            value stride,
                            value color_array )
{
    int size, _size;
    intnat dim;
    GLvoid * pointer;
    GLenum data_type;

    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }

    switch (data_type)
    {
        case GL_BYTE:           _size = sizeof(GLbyte);   break;
        case GL_UNSIGNED_BYTE:  _size = sizeof(GLubyte);  break;

        case GL_SHORT:          _size = sizeof(GLshort);  break;
        case GL_UNSIGNED_SHORT: _size = sizeof(GLushort); break;

        case GL_INT:            _size = sizeof(GLint);    break;
        case GL_UNSIGNED_INT:   _size = sizeof(GLuint);   break;

        case GL_FLOAT:          _size = sizeof(GLfloat);  break;
        case GL_DOUBLE:         _size = sizeof(GLdouble); break;
    }

    switch (Bigarray_val(color_array)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_SINT8:
        case BIGARRAY_UINT8:      size = 1; break;

        case BIGARRAY_SINT16:
        case BIGARRAY_UINT16:     size = 2; break;

        case BIGARRAY_FLOAT32:
        case BIGARRAY_INT32:      size = 4; break;

        case BIGARRAY_FLOAT64:
        case BIGARRAY_INT64:      size = 8; break;

        case BIGARRAY_CAML_INT:   size = sizeof(intnat) /* SIZEOF_LONG */; break;
        case BIGARRAY_NATIVE_INT: size = sizeof(intnat) /* SIZEOF_INT */; break;

        default:
            caml_failwith("Color array, unsupported data type");
    }

    if (size != _size)
        caml_failwith("Color array size of data does not match");

    if (Bigarray_val(color_array)->num_dims != 1)
        caml_failwith("Color array number of dimensions should be 1");

    dim = Bigarray_val(color_array)->dim[0];

    if (!dim) pointer = NULL;
    else pointer = (GLvoid *) Data_bigarray_val(color_array);

    glSecondaryColorPointer(
            Int_val(elem_size),
            data_type,
            Int_val(stride),
            pointer );

    return Val_unit;
}



CAMLprim value
ml_glvertexattribpointer_native(
            value index,
            value size,
            value _data_type,
            value normalized,
            value stride,
            value pointer )
{
    GLenum data_type;
    switch (Long_val(_data_type))
    {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }

    CHECK_FUNC(glVertexAttribPointer, PFNGLVERTEXATTRIBPOINTERPROC)
    glVertexAttribPointer( Long_val(index),
                           Int_val(size),
                           data_type,
                           Bool_val(normalized),
                           Int_val(stride),
                           (GLvoid *) Data_bigarray_val(pointer)
                           );
    return Val_unit;
}
CAMLprim value
ml_glvertexattribpointer_bytecode( value * argv, int argn )
    { return ml_glvertexattribpointer_native( argv[0], argv[1], argv[2],
                                              argv[3], argv[4], argv[5] ); }



CAMLprim value
ml_glcolorpointer0( value elem_size, value _data_type, value stride )
{
    GLenum data_type;
    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }

    glColorPointer( Int_val(elem_size), data_type, Int_val(stride), 0 );
    return Val_unit;
}

CAMLprim value
ml_glsecondarycolorpointer0( value elem_size, value _data_type, value stride )
{
    GLenum data_type;
    switch (Int_val(_data_type))
    {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }

    glSecondaryColorPointer( Int_val(elem_size), data_type, Int_val(stride), 0 );
    return Val_unit;
}



CAMLprim value
ml_gledgeflagpointer( value stride, value pointer )
{
    glEdgeFlagPointer( Int_val(stride), (GLvoid *) Data_bigarray_val(pointer) );
    return Val_unit;
}

CAMLprim value
ml_gledgeflagpointer0( value stride )
{
    glEdgeFlagPointer( Int_val(stride), 0 );
    return Val_unit;
}

CAMLprim value
ml_glvertexattribpointer0(
            value index,
            value size,
            value _data_type,
            value normalized,
            value stride )
{
    GLenum data_type;
    switch (Long_val(_data_type))
    {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }

    CHECK_FUNC(glVertexAttribPointer, PFNGLVERTEXATTRIBPOINTERPROC)
    glVertexAttribPointer( Long_val(index),
                           Int_val(size),
                           data_type,
                           Bool_val(normalized),
                           Int_val(stride),
                           (GLvoid *) NULL
                           );
    return Val_unit;
}

CAMLprim value
ml_gldrawelements0(
        value mode,
        value count,
        value ndx_type )
{
    GLenum type;
    switch (Int_val(ndx_type))
    {
        case 0: type = GL_UNSIGNED_BYTE;  break;
        case 1: type = GL_UNSIGNED_SHORT; break;
        case 2: type = GL_UNSIGNED_INT;   break;
    }
    glDrawElements(
            Int_val(mode),
            Int_val(count),
            type,
            (GLvoid *) NULL );
    return Val_unit;
}




CAMLprim value
ml_glvertexpointer_ofs8( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }
    glVertexPointer( Int_val(elem_size), data_type, Int_val(stride), ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glvertexpointer_ofs16( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }
    glVertexPointer( Int_val(elem_size), data_type, Int_val(stride), ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glvertexpointer_ofs32( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }
    glVertexPointer( Int_val(elem_size), data_type, Int_val(stride), ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}


CAMLprim value
ml_glindexpointer_ofs8( value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_UNSIGNED_BYTE; break;
        case 1: data_type = GL_SHORT;         break;
        case 2: data_type = GL_INT;           break;
        case 3: data_type = GL_FLOAT;         break;
        case 4: data_type = GL_DOUBLE;        break;
    }
    glIndexPointer( data_type, Int_val(stride), ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glindexpointer_ofs16( value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_UNSIGNED_BYTE; break;
        case 1: data_type = GL_SHORT;         break;
        case 2: data_type = GL_INT;           break;
        case 3: data_type = GL_FLOAT;         break;
        case 4: data_type = GL_DOUBLE;        break;
    }
    glIndexPointer( data_type, Int_val(stride), ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glindexpointer_ofs32( value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_UNSIGNED_BYTE; break;
        case 1: data_type = GL_SHORT;         break;
        case 2: data_type = GL_INT;           break;
        case 3: data_type = GL_FLOAT;         break;
        case 4: data_type = GL_DOUBLE;        break;
    }
    glIndexPointer( data_type, Int_val(stride), ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}


CAMLprim value
ml_gltexcoordpointer_ofs8( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }
    glTexCoordPointer( Int_val(elem_size), data_type, Int_val(stride), ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_gltexcoordpointer_ofs16( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }
    glTexCoordPointer( Int_val(elem_size), data_type, Int_val(stride), ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_gltexcoordpointer_ofs32( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_SHORT;  break;
        case 1: data_type = GL_INT;    break;
        case 2: data_type = GL_FLOAT;  break;
        case 3: data_type = GL_DOUBLE; break;
    }
    glTexCoordPointer( Int_val(elem_size), data_type, Int_val(stride), ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}



CAMLprim value
ml_glcolorpointer_ofs8( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    glColorPointer( Int_val(elem_size), data_type, Int_val(stride), ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glcolorpointer_ofs16( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    glColorPointer( Int_val(elem_size), data_type, Int_val(stride), ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glcolorpointer_ofs32( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    glColorPointer( Int_val(elem_size), data_type, Int_val(stride), ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}



CAMLprim value
ml_glsecondarycolorpointer_ofs8( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    glSecondaryColorPointer( Int_val(elem_size), data_type, Int_val(stride), ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glsecondarycolorpointer_ofs16( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    glSecondaryColorPointer( Int_val(elem_size), data_type, Int_val(stride), ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glsecondarycolorpointer_ofs32( value elem_size, value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    glSecondaryColorPointer( Int_val(elem_size), data_type, Int_val(stride), ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}



CAMLprim value
ml_glnormalpointer_ofs8( value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;   break;
        case 1: data_type = GL_SHORT;  break;
        case 2: data_type = GL_INT;    break;
        case 3: data_type = GL_FLOAT;  break;
        case 4: data_type = GL_DOUBLE; break;
    }
    glNormalPointer( data_type, Int_val(stride), ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glnormalpointer_ofs16( value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;   break;
        case 1: data_type = GL_SHORT;  break;
        case 2: data_type = GL_INT;    break;
        case 3: data_type = GL_FLOAT;  break;
        case 4: data_type = GL_DOUBLE; break;
    }
    glNormalPointer( data_type, Int_val(stride), ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glnormalpointer_ofs32( value _data_type, value stride, value ofs ) {
    GLenum data_type;
    switch (Int_val(_data_type)) {
        case 0: data_type = GL_BYTE;   break;
        case 1: data_type = GL_SHORT;  break;
        case 2: data_type = GL_INT;    break;
        case 3: data_type = GL_FLOAT;  break;
        case 4: data_type = GL_DOUBLE; break;
    }
    glNormalPointer( data_type, Int_val(stride), ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}



CAMLprim value
ml_gldrawelements_ofs8( value mode, value count, value ndx_type, value ofs )
{
    GLenum type;
    switch (Int_val(ndx_type)) {
        case 0: type = GL_UNSIGNED_BYTE;  break;
        case 1: type = GL_UNSIGNED_SHORT; break;
        case 2: type = GL_UNSIGNED_INT;   break;
    }
    glDrawElements( Int_val(mode), Int_val(count), type, (int8_t *)0 + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_gldrawelements_ofs16( value mode, value count, value ndx_type, value ofs )
{
    GLenum type;
    switch (Int_val(ndx_type)) {
        case 0: type = GL_UNSIGNED_BYTE;  break;
        case 1: type = GL_UNSIGNED_SHORT; break;
        case 2: type = GL_UNSIGNED_INT;   break;
    }
    glDrawElements( Int_val(mode), Int_val(count), type, (int16_t *)0 + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_gldrawelements_ofs32( value mode, value count, value ndx_type, value ofs )
{
    GLenum type;
    switch (Int_val(ndx_type)) {
        case 0: type = GL_UNSIGNED_BYTE;  break;
        case 1: type = GL_UNSIGNED_SHORT; break;
        case 2: type = GL_UNSIGNED_INT;   break;
    }
    glDrawElements( Int_val(mode), Int_val(count), type, (int32_t *)0 + Long_val(ofs) );
    return Val_unit;
}



CAMLprim value
ml_gledgeflagpointer_ofs8( value stride, value ofs ) {
    glEdgeFlagPointer( Int_val(stride), ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_gledgeflagpointer_ofs16( value stride, value ofs ) {
    glEdgeFlagPointer( Int_val(stride), ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_gledgeflagpointer_ofs32( value stride, value ofs ) {
    glEdgeFlagPointer( Int_val(stride), ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}



CAMLprim value
ml_glvertexattribpointer_ofs8_native(
            value index, value size, value _data_type,
            value normalized, value stride, value ofs ) {
    GLenum data_type;
    switch (Long_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    CHECK_FUNC(glVertexAttribPointer, PFNGLVERTEXATTRIBPOINTERPROC)
    glVertexAttribPointer( Long_val(index),
                           Int_val(size),
                           data_type,
                           Bool_val(normalized),
                           Int_val(stride),
                           ((int8_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glvertexattribpointer_ofs8_bytecode( value * argv, int argn )
    { return ml_glvertexattribpointer_ofs8_native( argv[0], argv[1], argv[2],
                                                   argv[3], argv[4], argv[5] ); }
CAMLprim value
ml_glvertexattribpointer_ofs16_native(
            value index, value size, value _data_type,
            value normalized, value stride, value ofs ) {
    GLenum data_type;
    switch (Long_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    CHECK_FUNC(glVertexAttribPointer, PFNGLVERTEXATTRIBPOINTERPROC)
    glVertexAttribPointer( Long_val(index),
                           Int_val(size),
                           data_type,
                           Bool_val(normalized),
                           sizeof(int16_t) * Int_val(stride),
                           ((int16_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glvertexattribpointer_ofs16_bytecode( value * argv, int argn )
    { return ml_glvertexattribpointer_ofs16_native( argv[0], argv[1], argv[2],
                                                    argv[3], argv[4], argv[5] ); }
CAMLprim value
ml_glvertexattribpointer_ofs32_native(
            value index, value size, value _data_type,
            value normalized, value stride, value ofs ) {
    GLenum data_type;
    switch (Long_val(_data_type)) {
        case 0: data_type = GL_BYTE;           break;
        case 1: data_type = GL_UNSIGNED_BYTE;  break;
        case 2: data_type = GL_SHORT;          break;
        case 3: data_type = GL_UNSIGNED_SHORT; break;
        case 4: data_type = GL_INT;            break;
        case 5: data_type = GL_UNSIGNED_INT;   break;
        case 6: data_type = GL_FLOAT;          break;
        case 7: data_type = GL_DOUBLE;         break;
    }
    CHECK_FUNC(glVertexAttribPointer, PFNGLVERTEXATTRIBPOINTERPROC)
    glVertexAttribPointer( Long_val(index),
                           Int_val(size),
                           data_type,
                           Bool_val(normalized),
                           sizeof(int32_t) * Int_val(stride),
                           ((int32_t *)NULL) + Long_val(ofs) );
    return Val_unit;
}
CAMLprim value
ml_glvertexattribpointer_ofs32_bytecode( value * argv, int argn )
    { return ml_glvertexattribpointer_ofs32_native( argv[0], argv[1], argv[2],
                                                    argv[3], argv[4], argv[5] ); }



/* ==== VAO's ==== / ================================ */

#if defined(GL_ARB_vertex_array_object)
//void glGenVertexArrays (GLsizei, GLuint *);

CAMLprim value ml_glgenvertexarray( value unit ) {
    GLuint vao_id;
    CHECK_FUNC(glGenVertexArrays, PFNGLGENVERTEXARRAYSPROC)
    LINUX_FUNC(glGenVertexArrays, PFNGLGENVERTEXARRAYSPROC)
    glGenVertexArrays(1, &vao_id);
    return Val_long(vao_id);
}

CAMLprim value ml_glbindvertexarray( GLuint id ) {
    CHECK_FUNC(glBindVertexArray, PFNGLBINDVERTEXARRAYPROC)
    LINUX_FUNC(glBindVertexArray, PFNGLBINDVERTEXARRAYPROC)
    glBindVertexArray( Long_val(id) );
    return Val_unit;
}

//void glDeleteVertexArrays (GLsizei, const GLuint *);

CAMLprim value ml_gldeletevertexarray( value ml_vao ) {
    GLuint vao_id = Long_val(ml_vao);
    CHECK_FUNC(glDeleteVertexArrays, PFNGLDELETEVERTEXARRAYSPROC)
    LINUX_FUNC(glDeleteVertexArrays, PFNGLDELETEVERTEXARRAYSPROC)
    glDeleteVertexArrays( 1, &vao_id );
    return Val_unit;
}

CAMLprim value ml_glisvertexarray( value ml_vao ) {
    CHECK_FUNC(glIsVertexArray, PFNGLISVERTEXARRAYPROC)
    LINUX_FUNC(glIsVertexArray, PFNGLISVERTEXARRAYPROC)
    return Val_long( glIsVertexArray( Long_val(ml_vao) ));
}

#else
CAMLprim value ml_glgenvertexarray( value unit ) {
    caml_failwith("glGenVertexArrays: the *vertex_array_object extension is not available");
    return Val_unit;
}
CAMLprim value ml_glbindvertexarray( GLuint id ) {
    caml_failwith("glBindVertexArray: the *vertex_array_object extension is not available");
    return Val_unit;
}
CAMLprim value ml_gldeletevertexarray( value ml_vao ) {
    caml_failwith("glDeleteVertexArrays: the *vertex_array_object extension is not available");
    return Val_unit;
}
CAMLprim value ml_glisvertexarray( value ml_vao ) {
    caml_failwith("glIsVertexArray: the *vertex_array_object extension is not available");
    return Val_unit;
}
#endif

/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
