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

//#define CAML_NAME_SPACE

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

#define MESA_DEBUG

//define ret  return Val_unit;
#define ret return ((intnat)1);
// Val_unit is equivalent to (((intnat)(0) << 1) + 1)

#define t_val  CAMLprim value

#include "gl.wrap.h"

//define Val_VBOID(v) ((value)(v))
//define VBOID_val(v) ((GLuint)(v))

#define Val_VBOID Val_long
#define VBOID_val Long_val

t_val ml_glgenbuffer(value unit)
{
    GLuint vboId = 0;
    glGenBuffersARB(1, &vboId);
    if (vboId == 0) caml_failwith("glGenBuffer");
    return Val_VBOID(vboId);
}

t_val ml_glgenbuffers(value _n)
{
    CAMLparam1(_n);
    CAMLlocal1(mlids);
    int i, n;
    n = Int_val(_n);
    GLuint *vboIds;
    vboIds = malloc(n * sizeof(GLuint));
    for (i=0; i<n; i++) vboIds[i] = 0;
    glGenBuffersARB(n, vboIds);
    // TODO: is it possible that only one fail?
    //       if so what to do with the other id's ?
    for (i=0; i<n; i++)
      if (vboIds[i] == 0)
      { if (i >= 1) glDeleteBuffersARB(i, vboIds);
        free(vboIds);
        caml_failwith("glGenBuffers");
      }
    mlids = caml_alloc(n, 0);
    for (i=0; i<n; i++)
      Store_field(mlids, i, Val_VBOID(vboIds[i]));
    free(vboIds);
    CAMLreturn(mlids);
}

t_val ml_gldeletebuffer(value id)
{
    GLuint vboId = VBOID_val(id);
    glDeleteBuffersARB(1, &vboId);
    return Val_unit;
}

t_val ml_glbindbuffer(value _buffer_object_target_arb, value id)
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    glBindBufferARB( buffer_object_target_arb, VBOID_val(id) ); ret
}

t_val ml_glunbindbuffer(value _buffer_object_target_arb)
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    glBindBufferARB( buffer_object_target_arb, 0 ); ret
}


t_val ml_glbufferdata(value _buffer_object_target_arb, value size, value data, value _vbo_usage_pattern_arb)
{
    GLenum buffer_object_target_arb;
    GLenum vbo_usage_pattern_arb;
#include "enums/buffer_object_target_arb.inc.c"
#include "enums/vbo_usage_pattern_arb.inc.c"
#if 0
    // {{{ TODO Checks 
    switch (Bigarray_val(data)->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_UINT8:
            break;

        case BIGARRAY_UINT16:
            break;

        case BIGARRAY_CAML_INT:    // 31- or 63-bit signed integers
        case BIGARRAY_NATIVE_INT:  // 32- or 64-bit (platform-native) integers
            break;

        case BIGARRAY_INT32:   // 32-bit signed integers
            break;

        case BIGARRAY_INT64:   // 64-bit signed integers
            break;
    }
    int dim = Bigarray_val(data)->dim[0];
    printf("glBufferData::dim = %d\n", dim);
    {
      struct caml_ba_array * my_ba;
      my_ba = Caml_ba_array_val(data);
      printf("sizeof(ba->data) = %d\n", sizeof(my_ba->data) );
      printf("caml_ba_byte_size(my_ba) = %d\n", caml_ba_byte_size(my_ba) );
    }
    // }}}
#endif
    glBufferDataARB( buffer_object_target_arb,
                     Int_val(size),
                     (GLvoid *) Data_bigarray_val(data),
                     vbo_usage_pattern_arb ); ret
}

t_val ml_glbufferdata_null(value _buffer_object_target_arb, value size, value _vbo_usage_pattern_arb)
{
    GLenum buffer_object_target_arb;
    GLenum vbo_usage_pattern_arb;
#include "enums/buffer_object_target_arb.inc.c"
#include "enums/vbo_usage_pattern_arb.inc.c"
    glBufferDataARB( buffer_object_target_arb,
                     Int_val(size),
                     (GLvoid *) NULL,
                     vbo_usage_pattern_arb ); ret
}


t_val ml_glbuffersubdata(value _buffer_object_target_arb, value offset, value size, value data )
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"

    glBufferSubDataARB(
        buffer_object_target_arb,
        Int_val(offset),
        Int_val(size),
        (GLvoid *) Data_bigarray_val(data) ); ret
}


static const GLenum access_policy_table[] = {
    GL_READ_ONLY,
    GL_WRITE_ONLY,
    GL_READ_WRITE
};

t_val ml_glmapbuffer( value _buffer_object_target_arb, value ap )
{
    CAMLlocal1(bo_ba);
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    float *ptr = (float*) glMapBufferARB( buffer_object_target_arb,
                                          access_policy_table[Long_val(ap)] );
    if (ptr == NULL) {
        caml_failwith("glMapBuffer");
    }
    {
        GLint size;
        glGetBufferParameteriv( buffer_object_target_arb, GL_BUFFER_SIZE, &size );

        long dims[1];
        dims[0] = size / 4;

        bo_ba = alloc_bigarray( BIGARRAY_FLOAT32 | BIGARRAY_C_LAYOUT | BIGARRAY_EXTERNAL,
                                1, ptr, dims);
        /*
        switch (Int_val(sw))
        {
            CAML_BA_EXTERNAL
            CAML_BA_MANAGED
        }
        */

        /*
        bo_ba = alloc_bigarray( BIGARRAY_FLOAT32 | BIGARRAY_C_LAYOUT, 1, NULL, dims);
        float * baptr = Data_bigarray_val(bo_ba);
        unsigned int i;
        for (i=0; i<size; i++) {
            baptr[i] = ptr[i];
        }
        */
    }
    return bo_ba;
}

t_val ml_glmapbuffer_abs( value _buffer_object_target_arb, value ap )
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    float *ptr = (float*) glMapBufferARB( buffer_object_target_arb,
                                          access_policy_table[Long_val(ap)] );
    if (ptr == NULL) caml_failwith("glMapBufferAbs");
    return (value) ptr;
}
#include <string.h>
t_val mapped_buffer_blit( value ptr, value ba, value len )
{
    memcpy( (void *)ptr, (void *)Data_bigarray_val(ba), Long_val(len) );
    return Val_unit;
}
t_val mapped_buffer_blit_ofs( value ptr, value ba, value ofs, value len )
{
    unsigned int offset = Long_val(ofs);
    memcpy( ((void *)ptr) + offset, ((void *)Data_bigarray_val(ba)) + offset, Long_val(len) );
    return Val_unit;
}

t_val ml_glunmapbuffer( value _buffer_object_target_arb )
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    GLboolean r = glUnmapBufferARB( buffer_object_target_arb );
    if (r == GL_FALSE) caml_failwith("glUnmapBuffer");
    return Val_unit;
}


t_val ml_glGetBufferParameter_ACCESS( value _buffer_object_target_arb )
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    GLint access;
    glGetBufferParameteriv( buffer_object_target_arb, GL_BUFFER_ACCESS, &access );
    switch (access)
    {
      case GL_READ_ONLY : return Val_int(0); break;
      case GL_WRITE_ONLY: return Val_int(1); break;
      case GL_READ_WRITE: return Val_int(2); break;
    }
    caml_failwith("glGetBufferAccess");
    return Val_int(0);
}

t_val ml_glGetBufferParameter_MAPPED( value _buffer_object_target_arb )
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    GLint mapped;
    glGetBufferParameteriv( buffer_object_target_arb, GL_BUFFER_MAPPED, &mapped );
    return Val_int(mapped);
}

t_val ml_glGetBufferParameter_SIZE( value _buffer_object_target_arb )
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    GLint size;
    glGetBufferParameteriv( buffer_object_target_arb, GL_BUFFER_SIZE, &size );
    return Val_int(size);
}

t_val ml_glGetBufferParameter_USAGE( value _buffer_object_target_arb )
{
    GLenum buffer_object_target_arb;
#include "enums/buffer_object_target_arb.inc.c"
    GLint _vbo_usage_pattern_arb;
    int vbo_usage_pattern_arb;
    glGetBufferParameteriv( buffer_object_target_arb, GL_BUFFER_USAGE, &_vbo_usage_pattern_arb );
#include "enums/vbo_usage_pattern_arb.inc-r.c"
    return Val_int(vbo_usage_pattern_arb);
}

t_val ml_ba_elem_size( value _ba )
{
    struct caml_bigarray * ba = Bigarray_val(_ba);
    int size;
    switch (ba->flags & BIGARRAY_KIND_MASK)
    {
        case BIGARRAY_SINT8:
        case BIGARRAY_UINT8:
            size = 1; break;

        case BIGARRAY_SINT16:
        case BIGARRAY_UINT16:
            size = 2; break;

        case BIGARRAY_INT32:
        case BIGARRAY_FLOAT32:
        case BIGARRAY_COMPLEX32:
            size = 4; break;

        case BIGARRAY_INT64:
        case BIGARRAY_FLOAT64:
        case BIGARRAY_COMPLEX64:
            size = 8; break;

        case BIGARRAY_CAML_INT:
        case BIGARRAY_NATIVE_INT:
            size = 1 * sizeof(value); break;
    }
    return Val_int(size);
}

/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
