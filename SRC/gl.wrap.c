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


t_val ml_glclearcolor( value r, value g, value b, value a ) { glClearColor( Double_val(r), Double_val(g), Double_val(b), Double_val(a) ); ret }
t_val ml_glclearindex( value c ) { glClearIndex( Double_val(c) ); ret }
t_val ml_glclearstencil( value s ) { glClearStencil( Int_val(s) ); ret }
t_val ml_glclearaccum( value r, value g, value b, value a ) { glClearAccum( Double_val(r), Double_val(g), Double_val(b), Double_val(a) ); ret }
t_val ml_glcolormask( value r, value g, value b, value a ) { glColorMask( Bool_val(r), Bool_val(g), Bool_val(b), Bool_val(a) ); ret }

t_val ml_glrotate( value angle, value x, value y, value z ) { glRotated( Double_val(angle), Double_val(x), Double_val(y), Double_val(z) ); ret }
t_val ml_gltranslate( value x, value y, value z ) { glTranslated( Double_val(x), Double_val(y), Double_val(z) ); ret }
t_val ml_glscale( value x, value y, value z ) { glScaled( Double_val(x), Double_val(y), Double_val(z) ); ret }

t_val ml_gltranslatev( value t_tuple ) {
    glTranslated(
        Double_val(Field(t_tuple, 0)),
        Double_val(Field(t_tuple, 1)),
        Double_val(Field(t_tuple, 2)) ); ret
}

t_val ml_glscalev( value s_tuple ) {
    glScaled(
        Double_val(Field(s_tuple, 0)),
        Double_val(Field(s_tuple, 1)),
        Double_val(Field(s_tuple, 2)) ); ret
}

t_val ml_glrotatev( value angle, value vec ) {
    glRotated(
        Double_val(angle),
        Double_val(Field(vec, 0)),
        Double_val(Field(vec, 1)),
        Double_val(Field(vec, 2)) ); ret
}

t_val ml_glpointsize( value size ) { glPointSize( Double_val(size) ); ret }

#ifdef GL_GLEXT_PROTOTYPES
t_val ml_glpointparameterf( value _pname, value param )  // glext.h
{
    GLenum pname;
    switch (Int_val(_pname)) {
        case 0: pname = GL_POINT_SIZE_MIN; break;
        case 1: pname = GL_POINT_SIZE_MAX; break;
        case 2: pname = GL_POINT_FADE_THRESHOLD_SIZE; break;
    }
    glPointParameterf( pname, Double_val(param) ); ret
}

t_val ml_glpointparameteri( value param )
{
#if GL_VERSION_2_0
    glPointParameteri( GL_POINT_SPRITE_COORD_ORIGIN,
                       (Int_val(param) ? GL_UPPER_LEFT : GL_LOWER_LEFT) ); ret
#else
    caml_failwith("glPointParameter: GL_POINT_SPRITE_COORD_ORIGIN available in OpenGL 2.0 and greater");
#endif
}

t_val ml_glpointparameterfv( value d1, value d2, value d3 )
{
    GLfloat params[3];
    params[0] = Double_val(d1);
    params[1] = Double_val(d2);
    params[2] = Double_val(d3);
    glPointParameterfv( GL_POINT_DISTANCE_ATTENUATION, params ); ret
}
#else
t_val ml_glpointparameterf( value _pname, value param )
{
    caml_failwith("glPointParameter: function not available");
    return Val_int(0);
}
t_val ml_glpointparameteri( value param )
{
    caml_failwith("glPointParameter: function not available");
    return Val_int(0);
}
t_val ml_glpointparameterfv( value d1, value d2, value d3 )
{
    caml_failwith("glPointParameter: function not available");
    return Val_int(0);
}
#endif


t_val ml_glmultmatrixd( value mat )
{
    GLdouble m[16];
 
    m[0] = Double_field(Field(mat, 0), 0);
    m[1] = Double_field(Field(mat, 0), 1);
    m[2] = Double_field(Field(mat, 0), 2);
    m[3] = Double_field(Field(mat, 0), 3);
 
    m[4] = Double_field(Field(mat, 1), 0);
    m[5] = Double_field(Field(mat, 1), 1);
    m[6] = Double_field(Field(mat, 1), 2);
    m[7] = Double_field(Field(mat, 1), 3);
 
    m[8] =  Double_field(Field(mat, 2), 0);
    m[9] =  Double_field(Field(mat, 2), 1);
    m[10] = Double_field(Field(mat, 2), 2);
    m[11] = Double_field(Field(mat, 2), 3);
 
    m[12] = Double_field(Field(mat, 3), 0);
    m[13] = Double_field(Field(mat, 3), 1);
    m[14] = Double_field(Field(mat, 3), 2);
    m[15] = Double_field(Field(mat, 3), 3);
 
    glMultMatrixd( m );  ret
}

t_val ml_glmultmatrixd_flat( value mat )
{
    int len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 16)
        caml_invalid_argument("glMultMatrixFlat: array length should be 16");
 
    glMultMatrixd( (double *)mat );  ret
}

t_val ml_glmultmatrixd_flat_unsafe( value mat )
{
    glMultMatrixd( (double *)mat );  ret
}


t_val ml_glloadmatrixd( value mat )
{
    GLdouble m[16];
 
    m[0] = Double_field(Field(mat, 0), 0);
    m[1] = Double_field(Field(mat, 0), 1);
    m[2] = Double_field(Field(mat, 0), 2);
    m[3] = Double_field(Field(mat, 0), 3);
 
    m[4] = Double_field(Field(mat, 1), 0);
    m[5] = Double_field(Field(mat, 1), 1);
    m[6] = Double_field(Field(mat, 1), 2);
    m[7] = Double_field(Field(mat, 1), 3);
 
    m[8] =  Double_field(Field(mat, 2), 0);
    m[9] =  Double_field(Field(mat, 2), 1);
    m[10] = Double_field(Field(mat, 2), 2);
    m[11] = Double_field(Field(mat, 2), 3);
 
    m[12] = Double_field(Field(mat, 3), 0);
    m[13] = Double_field(Field(mat, 3), 1);
    m[14] = Double_field(Field(mat, 3), 2);
    m[15] = Double_field(Field(mat, 3), 3);

    glLoadMatrixd( m );  ret
}

t_val ml_glloadmatrixd_flat( value mat )
{
    int len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 16)
        caml_invalid_argument("glLoadMatrixdFlat: array length should be 16");
 
    glLoadMatrixd( (double *)mat );  ret
}

t_val ml_glloadmatrixd_flat_unsafe( value mat )
{
    glLoadMatrixd( (double *)mat );  ret
}


t_val ml_glfrustum_native( value left, value right, value bottom, value top, value near, value far )
{
    glFrustum( Double_val(left), Double_val(right), Double_val(bottom),
               Double_val(top), Double_val(near), Double_val(far) ); ret
}
t_val ml_glfrustum_bytecode( value * argv, int argn )
          { return ml_glfrustum_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5] ); }


t_val ml_glvertex2( value x, value y ) { glVertex2d( Double_val(x), Double_val(y) ); ret }
t_val ml_glvertex3( value x, value y, value z ) { glVertex3d( Double_val(x), Double_val(y), Double_val(z) ); ret }
t_val ml_glvertex4( value x, value y, value z, value w ) { glVertex4d( Double_val(x), Double_val(y), Double_val(z), Double_val(w) ); ret }

t_val ml_glvertex2v( value v_tuple )
{
    glVertex2d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)) ); ret
}

t_val ml_glvertex3v( value v_tuple )
{
    glVertex3d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)) ); ret
}

t_val ml_glvertex4v( value v_tuple )
{
    glVertex4d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)),
        Double_val(Field(v_tuple, 3)) ); ret
}

t_val ml_glcolor3v( value v_tuple )
{
    glColor3d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)) ); ret
}

t_val ml_glcolor4v( value v_tuple )
{
    glColor4d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)),
        Double_val(Field(v_tuple, 3)) ); ret
}

t_val ml_glcolor3cv( value v_tuple )
{
    glColor3ub(
        Long_val(Field(v_tuple, 0)),
        Long_val(Field(v_tuple, 1)),
        Long_val(Field(v_tuple, 2)) ); ret
}

t_val ml_glcolor4cv( value v_tuple )
{
    glColor4ub(
        Long_val(Field(v_tuple, 0)),
        Long_val(Field(v_tuple, 1)),
        Long_val(Field(v_tuple, 2)),
        Long_val(Field(v_tuple, 3)) ); ret
}

t_val ml_glnormal3v( value v_tuple )
{
    glNormal3d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)) ); ret
}

t_val ml_gltexcoord2v( value v_tuple )
{
    glTexCoord2d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)) ); ret
}

t_val ml_gltexcoord3v( value v_tuple )
{
    glTexCoord3d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)) ); ret
}

t_val ml_gltexcoord4v( value v_tuple )
{
    glTexCoord4d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)),
        Double_val(Field(v_tuple, 3)) ); ret
}


t_val ml_glcolor3( value r, value g, value b ) { glColor3d( Double_val(r), Double_val(g), Double_val(b) ); ret }
t_val ml_glcolor4( value r, value g, value b, value a ) { glColor4d( Double_val(r), Double_val(g), Double_val(b), Double_val(a) ); ret }

t_val ml_glcolor3c( value r, value g, value b ) { glColor3ub( Long_val(r), Long_val(g), Long_val(b) ); ret }
t_val ml_glcolor4c( value r, value g, value b, value a ) { glColor4ub( Long_val(r), Long_val(g), Long_val(b), Long_val(a) ); ret }

t_val ml_glnormal3( value x, value y, value z ) { glNormal3d( Double_val(x), Double_val(y), Double_val(z) ); ret }

t_val ml_gledgeflag( value flag ) { glEdgeFlag( Long_val(flag) ); ret }

t_val ml_gltexcoord1( value s ) { glTexCoord1d( Double_val(s) ); ret }
t_val ml_gltexcoord2( value s, value t ) { glTexCoord2d( Double_val(s), Double_val(t) ); ret }
t_val ml_gltexcoord3( value s, value t, value r ) { glTexCoord3d( Double_val(s), Double_val(t), Double_val(r) ); ret }
t_val ml_gltexcoord4( value s, value t, value r, value q ) { glTexCoord4d( Double_val(s), Double_val(t), Double_val(r), Double_val(q) ); ret }

t_val ml_gllinewidth( value width ) { glLineWidth( Double_val(width) ); ret }

t_val ml_glrect( value x1, value y1, value x2, value y2 ) { glRectd( Double_val(x1), Double_val(y1), Double_val(x2), Double_val(y2) ); ret }
t_val ml_glrecti( value x1, value y1, value x2, value y2 ) { glRecti( Int_val(x1), Int_val(y1), Int_val(x2), Int_val(y2) ); ret }

t_val ml_gllinestipple( value factor, value pattern ) { glLineStipple( Int_val(factor), (GLushort) Long_val(pattern) ); ret }

t_val ml_glloadidentity( value unit ) { glLoadIdentity(); ret }

t_val ml_glpushmatrix( value unit ) { glPushMatrix(); ret }
t_val ml_glpopmatrix( value unit ) { glPopMatrix(); ret }

t_val ml_glbegin( value prim ) { glBegin( Long_val(prim) ); ret }
t_val ml_glend( value unit ) { glEnd(); ret }
t_val ml_glflush( value unit ) { glFlush(); ret }
t_val ml_glfinish( value unit ) { glFinish(); ret }

t_val ml_glfrontface( value _orientation )
{
    GLenum orientation;
#include "enums/orientation.inc.c"
    glFrontFace( orientation ); ret
}

/* Depth Buffer */

t_val ml_glcleardepth( value depth ) { glClearDepth( Double_val(depth) ); ret }

t_val ml_gldepthmask( value flag ) { glDepthMask( Bool_val(flag) ); ret }

t_val ml_gldepthrange( value near_val, value far_val ) { glDepthRange( Double_val( near_val ), Double_val( far_val ) ); ret }


t_val ml_glviewport( value x, value y, value width, value height ) { glViewport( Int_val(x), Int_val(y), Int_val(width), Int_val(height) ); ret }

t_val ml_glortho_native(
        value left, value right, value bottom,
        value top, value near_val, value far_val ) {
    glOrtho( Double_val(left), Double_val(right), Double_val(bottom),
             Double_val(top), Double_val(near_val), Double_val(far_val) );
    ret
}
t_val ml_glortho_bytecode( value * argv, int argn )
    { return ml_glortho_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5] ); }

t_val ml_glenable( value _gl_capability ) {
    GLenum gl_capability;
#include "enums/gl_capability.inc.c"
    glEnable( gl_capability );
    ret
}

t_val ml_gldisable( value _gl_capability ) {
    GLenum gl_capability;
#include "enums/gl_capability.inc.c"
    glDisable( gl_capability );
    ret
}

t_val ml_glisenabled( value _enabled_cap ) {
    GLenum enabled_cap;
#include "enums/enabled_cap.inc.c"
    if (glIsEnabled( enabled_cap ) == GL_TRUE) return Val_true; else return Val_false;
}

t_val ml_glshademodel( value _shade_mode ) {
    GLenum shade_mode;
#include "enums/shade_mode.inc.c"
    glShadeModel( shade_mode );
    ret
}

t_val ml_glmatrixmode( value _matrix_mode ) {
    GLenum matrix_mode;
#include "enums/matrix_mode.inc.c"
    glMatrixMode( matrix_mode );
    ret
}

t_val ml_glpolygonmode( value _face_mode, value _polygon_mode ) {
    GLenum face_mode, polygon_mode;
#include "enums/polygon_mode.inc.c"
#include "enums/face_mode.inc.c"
    glPolygonMode( face_mode, polygon_mode );
    ret
}
t_val ml_glgetpolygonmode( value unit )
{
    CAMLparam1( unit );
    CAMLlocal1( tuple );
    GLint polygonMode_state[2];
    glGetIntegerv( GL_POLYGON_MODE, polygonMode_state );
    tuple = caml_alloc(2, 0);
    { /* front facing */
      if (polygonMode_state[0] == GL_POINT) Store_field( tuple, 0, Val_long(0) );
      if (polygonMode_state[0] == GL_LINE)  Store_field( tuple, 0, Val_long(1) );
      if (polygonMode_state[0] == GL_FILL)  Store_field( tuple, 0, Val_long(2) );
    }
    { /* back facing */
      if (polygonMode_state[1] == GL_POINT) Store_field( tuple, 1, Val_long(0) );
      if (polygonMode_state[1] == GL_LINE)  Store_field( tuple, 1, Val_long(1) );
      if (polygonMode_state[1] == GL_FILL)  Store_field( tuple, 1, Val_long(2) );
    }
    CAMLreturn( tuple );
}


t_val ml_glclear( value mask_list ) {
    CAMLparam1( mask_list );
    CAMLlocal1( _clear_mask );

    GLbitfield mask = 0;
    GLbitfield clear_mask;

    while ( mask_list != Val_emptylist )
    {
        _clear_mask = Field(mask_list,0);
        {
#include "enums/clear_mask.inc.c"
        }
        mask |= clear_mask;
        mask_list = Field(mask_list,1);
    }

    glClear( mask );

    CAMLreturn( Val_unit );
}


t_val ml_glgeterror( value unit ) {
    CAMLparam1( unit );

    GLenum _gl_error = glGetError();

    int gl_error;
#include "enums/gl_error.inc-r.c"

    CAMLreturn( Val_int(gl_error) );
}


t_val ml_glgetstring( value _get_string )
{
    const GLubyte *res;
    GLenum get_string;
#include "enums/get_string.inc.c"
    res = glGetString( get_string );
    if (res) return caml_copy_string((char *)res);
    else return caml_copy_string("");
}

#if 0
t_val ml_glgetextensions( value unit )
{
#if defined(GL_VERSION_3_0)
    CAMLlocal1(ml_exts);
    GLint num_extensions;
    GLuint i;
    GLubyte * *extensions;
    glGetIntegerv(GL_NUM_EXTENSIONS, &num_extensions);
    extensions = malloc((num_extensions + 1) * sizeof(GLubyte *));
    for (i=0; i<num_extensions; i++)
        extensions[i] = glGetStringi(GL_EXTENSIONS, i);
    extensions[num_extensions] = NULL;
    ml_exts = caml_copy_string_array(extensions);
    free(extensions);
    return ml_exts;
#else
    caml_failwith("glGetExtensions: only for OpenGL >= 3.0"); ret
#endif
}
#endif


t_val ml_glrasterpos2d( value x, value y ) { glRasterPos2d( Double_val(x), Double_val(y) ); ret }
t_val ml_glrasterpos3d( value x, value y, value z ) { glRasterPos3d( Double_val(x), Double_val(y), Double_val(z) ); ret }
t_val ml_glrasterpos4d( value x, value y, value z, value w ) { glRasterPos4d( Double_val(x), Double_val(y), Double_val(z), Double_val(w) ); ret }

t_val ml_glrasterpos2i( value x, value y ) { glRasterPos2i( Int_val(x), Int_val(y) ); ret }
t_val ml_glrasterpos3i( value x, value y, value z ) { glRasterPos3i( Int_val(x), Int_val(y), Int_val(z) ); ret }
t_val ml_glrasterpos4i( value x, value y, value z, value w ) { glRasterPos4i( Int_val(x), Int_val(y), Int_val(z), Int_val(w) ); ret }


t_val ml_glrasterpos2dv( value v_tuple ) {
    glRasterPos2d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)) ); ret
}
t_val ml_glrasterpos3dv( value v_tuple ) {
    glRasterPos3d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)) ); ret
}
t_val ml_glrasterpos4dv( value v_tuple ) {
    glRasterPos4d(
        Double_val(Field(v_tuple, 0)),
        Double_val(Field(v_tuple, 1)),
        Double_val(Field(v_tuple, 2)),
        Double_val(Field(v_tuple, 3)) ); ret
}


t_val ml_glrasterpos2iv( value v_tuple ) {
    glRasterPos2i(
        Int_val(Field(v_tuple, 0)),
        Int_val(Field(v_tuple, 1)) ); ret
}
t_val ml_glrasterpos3iv( value v_tuple ) {
    glRasterPos3i(
        Int_val(Field(v_tuple, 0)),
        Int_val(Field(v_tuple, 1)),
        Int_val(Field(v_tuple, 2)) ); ret
}
t_val ml_glrasterpos4iv( value v_tuple ) {
    glRasterPos4i(
        Int_val(Field(v_tuple, 0)),
        Int_val(Field(v_tuple, 1)),
        Int_val(Field(v_tuple, 2)),
        Int_val(Field(v_tuple, 3)) ); ret
}




t_val ml_glpixelstorei( value _pixel_packing_i, value param )
{
    GLenum pixel_packing_i;
#include "enums/pixel_packing_i.inc.c"
    glPixelStorei( pixel_packing_i, Int_val(param) ); ret
}

t_val ml_glpixelstoreb( value _pixel_packing_b, value param )
{
    GLenum pixel_packing_b;
#include "enums/pixel_packing_b.inc.c"
    glPixelStorei( pixel_packing_b, Bool_val(param) ); ret
}

t_val ml_glpixelzoom( value xfactor, value yfactor ) { glPixelZoom( Double_val(xfactor), Double_val(yfactor) ); ret }


t_val ml_glscissor( value x, value y, value width, value height)
{
    glScissor( Int_val(x), Int_val(y), Int_val(width), Int_val(height) ); ret
}


t_val ml_glreadpixels_ba_unsafe_native(
            value x, value y,
            value width, value height,
            value _pixel_buffer_format,
            value _pixel_buffer_type,
            value ba_data )
{
    GLenum pixel_buffer_format;
    GLenum pixel_buffer_type;
#include "enums/pixel_buffer_format.inc.c"
#include "enums/pixel_buffer_type.inc.c"

    glReadPixels(
            Int_val(x),
            Int_val(y),
            Int_val(width),
            Int_val(height),
            pixel_buffer_format,
            pixel_buffer_type,
            (GLvoid *) Data_bigarray_val(ba_data) ); ret
}
t_val ml_glreadpixels_ba_unsafe_bytecode( value * argv, int argn )
          { return ml_glreadpixels_ba_unsafe_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6] ); }



t_val ml_glreadpixels_ba_native(
            value x, value y,
            value width, value height,
            value _pixel_buffer_format,
            value _pixel_buffer_type,
            value ba_data )
{
    GLenum pixel_buffer_format;
    GLenum pixel_buffer_type;
#include "enums/pixel_buffer_format.inc.c"
#include "enums/pixel_buffer_type.inc.c"

    {
        struct caml_bigarray * ba = Bigarray_val(ba_data);
        int pixel_size;
        int ba_size;
        int i;
        int c_size;

        // XXX GL3
#if 1
        if (pixel_buffer_format == GL_COLOR_INDEX ||
            pixel_buffer_format == GL_STENCIL_INDEX ||
            pixel_buffer_format == GL_DEPTH_COMPONENT ||
            pixel_buffer_format == GL_RED ||
            pixel_buffer_format == GL_GREEN ||
            pixel_buffer_format == GL_BLUE ||
            pixel_buffer_format == GL_ALPHA ||
            pixel_buffer_format == GL_LUMINANCE)
                pixel_size = 1;
        else 
        if (pixel_buffer_format == GL_LUMINANCE_ALPHA)
                pixel_size = 2;
        else 
        if (pixel_buffer_format == GL_RGB ||
            pixel_buffer_format == GL_BGR)
                pixel_size = 3;
        else 
        if (pixel_buffer_format == GL_RGBA ||
            pixel_buffer_format == GL_BGRA)
                pixel_size = 4;
#else
        switch (pixel_buffer_format) {
            case GL_COLOR_INDEX:
            case GL_STENCIL_INDEX:
            case GL_DEPTH_COMPONENT:
            case GL_RED:
            case GL_GREEN:
            case GL_BLUE:
            case GL_ALPHA:
            case GL_LUMINANCE:
                pixel_size = 1; break;
            case GL_LUMINANCE_ALPHA:
                pixel_size = 2; break;
            case GL_RGB:
            case GL_BGR:
                pixel_size = 3; break;
            case GL_RGBA:
            case GL_BGRA:
                pixel_size = 4; break;
        }
#endif
        c_size = pixel_size * Int_val(width) * Int_val(height);

        ba_size = 1;
        for (i=0; i < ba->num_dims; ++i)
        {
          ba_size *= ba->dim[i];
        }

        if (c_size != ba_size)
          caml_invalid_argument("glReadPixelsBA: wrong big-array size");
    }
    {
        int rsize, bsize;
        switch (pixel_buffer_type)
        {
            case GL_UNSIGNED_BYTE:
            case GL_BYTE:
                rsize = 8; break;
 
            case GL_BITMAP:      // XXX ?
                rsize = 1; break;
 
            case GL_UNSIGNED_SHORT:
            case GL_SHORT:       // XXX ?

            case GL_UNSIGNED_INT:
            case GL_INT:
            case GL_FLOAT:
                rsize = 4; break;
 
            case GL_UNSIGNED_BYTE_3_3_2:
            case GL_UNSIGNED_BYTE_2_3_3_REV:
                rsize = 8; break;
 
            case GL_UNSIGNED_SHORT_5_6_5:
            case GL_UNSIGNED_SHORT_5_6_5_REV:
            case GL_UNSIGNED_SHORT_4_4_4_4:
            case GL_UNSIGNED_SHORT_4_4_4_4_REV:
            case GL_UNSIGNED_SHORT_5_5_5_1:
            case GL_UNSIGNED_SHORT_1_5_5_5_REV:
                rsize = 16; break;
 
            case GL_UNSIGNED_INT_8_8_8_8:
            case GL_UNSIGNED_INT_8_8_8_8_REV:
            case GL_UNSIGNED_INT_10_10_10_2:
            case GL_UNSIGNED_INT_2_10_10_10_REV:
                rsize = 32; break;
        }

        switch (Bigarray_val(ba_data)->flags & BIGARRAY_KIND_MASK)
        {
            case BIGARRAY_SINT8:
            case BIGARRAY_UINT8:
                bsize = 8; break;

            case BIGARRAY_SINT16:
            case BIGARRAY_UINT16:
                bsize = 16; break;

            case BIGARRAY_INT32:
            case BIGARRAY_FLOAT32:
            case BIGARRAY_COMPLEX32:
                bsize = 32; break;

            case BIGARRAY_INT64:
            case BIGARRAY_FLOAT64:
            case BIGARRAY_COMPLEX64:
                bsize = 64; break;

            case BIGARRAY_CAML_INT:
            case BIGARRAY_NATIVE_INT:
                bsize = 8 * sizeof(value); break;
        }

        if (bsize != rsize)
          caml_invalid_argument("glReadPixelsBA: wrong big-array item bit size");
    }

    glReadPixels(
            Int_val(x),
            Int_val(y),
            Int_val(width),
            Int_val(height),
            pixel_buffer_format,
            pixel_buffer_type,
            (GLvoid *) Data_bigarray_val(ba_data) ); ret
}
t_val ml_glreadpixels_ba_bytecode( value * argv, int argn )
    { return ml_glreadpixels_ba_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6] ); }


t_val ml_glpixelmapfv( value _pixel_map, value v )
{
    CAMLparam2( _pixel_map, v );
    GLfloat *map_vals;
    int i, mapsize;
    GLenum pixel_map;
#include "enums/pixel_map.inc.c"
    mapsize = Wosize_val(v) / Double_wosize;
    map_vals = malloc(mapsize * sizeof(GLfloat));
    for (i=0; i < mapsize; i++) {
        map_vals[i] = Double_field(v, i);
    }
    glPixelMapfv( pixel_map, mapsize, map_vals );
    free(map_vals);
    CAMLreturn( Val_unit );
}


t_val ml_glbitmap_native( value width, value height, value xorig, value yorig,
                          value xmove, value ymove, value bitmap )
{
    glBitmap( Int_val(width), Int_val(height), Double_val(xorig), Double_val(yorig),
              Double_val(xmove), Double_val(ymove),
              (GLubyte *)Data_bigarray_val(bitmap) ); ret
}
t_val ml_glbitmap_bytecode( value * argv, int argn )
    { return ml_glbitmap_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6] ); }

t_val ml_glcopypixels( value x, value y, value width, value height, value _pixel_type )
{
    GLenum pixel_type;
#include "enums/pixel_type.inc.c"
    glCopyPixels( Int_val(x), Int_val(y), Int_val(width), Int_val(height), pixel_type ); ret
}

t_val ml_glpixeltransferi( value _pixel_transfer_i, value param ) {
    GLenum pixel_transfer_i;
#include "enums/pixel_transfer_i.inc.c"
    glPixelTransferi( pixel_transfer_i, Int_val(param) ); ret
}

t_val ml_glpixeltransferb( value _pixel_transfer_b, value param ) {
    GLenum pixel_transfer_b;
#include "enums/pixel_transfer_b.inc.c"
    glPixelTransferi( pixel_transfer_b, Bool_val(param) ); ret
}

t_val ml_glpixeltransferf( value _pixel_transfer_f, value param ) {
    GLenum pixel_transfer_f;
#include "enums/pixel_transfer_f.inc.c"
    glPixelTransferf( pixel_transfer_f, Double_val(param) ); ret
}

t_val ml_glpixeltransferfARB( value _pixel_transfer_f_ARB, value param ) {
    GLenum pixel_transfer_f_ARB;
#include "enums/pixel_transfer_f_ARB.inc.c"
    glPixelTransferf( pixel_transfer_f_ARB, Double_val(param) ); ret
}


t_val ml_gltexparameter_minfilter( value _tex_param_target, value _min_filter ) {
    GLenum tex_param_target;
    GLint min_filter;
#include "enums/tex_param_target.inc.c"
#include "enums/min_filter.inc.c"
    glTexParameteri( tex_param_target, GL_TEXTURE_MIN_FILTER, min_filter ); ret
}
t_val ml_gltexparameter_magfilter( value _tex_param_target, value _mag_filter ) {
    GLenum tex_param_target;
    GLint mag_filter;
#include "enums/tex_param_target.inc.c"
#include "enums/mag_filter.inc.c"
    glTexParameteri( tex_param_target, GL_TEXTURE_MAG_FILTER, mag_filter ); ret
}

t_val ml_gltexparameter1i( value _tex_param_target, value s, value d ) {
    GLenum tex_param_target;
    GLenum pname;
#include "enums/tex_param_target.inc.c"
    switch (Int_val(s)) {
        case 0: pname = GL_TEXTURE_BASE_LEVEL; break;
        case 1: pname = GL_TEXTURE_MAX_LEVEL; break;
    }
    glTexParameteri( tex_param_target, pname, Long_val(d) ); ret
}

t_val ml_gltexparameter1f( value _tex_param_target, value s, value d ) {
    GLenum tex_param_target;
    GLenum pname;
#include "enums/tex_param_target.inc.c"
    switch (Int_val(s)) {
        case 0: pname = GL_TEXTURE_MIN_LOD; break;
        case 1: pname = GL_TEXTURE_MAX_LOD; break;
        case 2: pname = GL_TEXTURE_PRIORITY; break;
    }
    glTexParameterf( tex_param_target, pname, Double_val(d) ); ret
}

t_val ml_gltexparameter_wrap( value _tex_param_target, value sw, value _wrap_param ) {
    GLenum tex_param_target;
    GLenum wrap_param;
    GLenum pname;
#include "enums/tex_param_target.inc.c"
#include "enums/wrap_param.inc.c"
    switch (Int_val(sw)) {
        case 0: pname = GL_TEXTURE_WRAP_S; break;
        case 1: pname = GL_TEXTURE_WRAP_T; break;
        case 2: pname = GL_TEXTURE_WRAP_R; break;
    }
    glTexParameteri( tex_param_target, pname, wrap_param ); ret
}

t_val ml_gltexparameter4f( value _tex_param_target, value color ) {
    GLenum tex_param_target;
    GLfloat params[4];
#include "enums/tex_param_target.inc.c"
    params[0] = Double_val(Field(color,0));
    params[1] = Double_val(Field(color,1));
    params[2] = Double_val(Field(color,2));
    params[3] = Double_val(Field(color,3));
    glTexParameterfv( tex_param_target, GL_TEXTURE_BORDER_COLOR, params ); ret
}

t_val ml_gltexparameter_gen_mpmp( value _tex_param_target, value gen_mpmp ) {
#if GL_VERSION_1_4
    GLenum tex_param_target;
#include "enums/tex_param_target.inc.c"
    glTexParameteri( tex_param_target, GL_GENERATE_MIPMAP, Long_val(gen_mpmp) ); ret
#else
    caml_failwith("glTexParameter: GL_GENERATE_MIPMAP only for OpenGL >= 1.4"); ret
#endif
}



t_val ml_gltexenv( value _texenv_target, value _texenv_pname, value _texenv_param )
{
    GLenum texenv_target;
    GLenum texenv_pname;
    GLint  texenv_param;
#include "enums/texenv_target.inc.c"
#include "enums/texenv_pname.inc.c"
#include "enums/texenv_param.inc.c"
    glTexEnvi( texenv_target, texenv_pname, texenv_param ); ret
}

t_val ml_gltexgen( value _tex_coord, value _tex_coord_gen_func, value _tex_gen_param )
{
    GLenum tex_coord;
    GLenum tex_coord_gen_func;
    GLint tex_gen_param;
#include "enums/tex_coord.inc.c"
#include "enums/tex_coord_gen_func.inc.c"
#include "enums/tex_gen_param.inc.c"
    glTexGeni( tex_coord, tex_coord_gen_func, tex_gen_param ); ret
}

t_val ml_gltexgenv( value _tex_coord, value _tex_coord_fun_params, value mlp )
{
    GLenum tex_coord;
    GLenum tex_coord_fun_params;
#include "enums/tex_coord.inc.c"
#include "enums/tex_coord_fun_params.inc.c"
    GLdouble params[4];
    params[0] = Double_val(Field(mlp, 0));
    params[1] = Double_val(Field(mlp, 1));
    params[2] = Double_val(Field(mlp, 2));
    params[3] = Double_val(Field(mlp, 3));
    glTexGendv( tex_coord, tex_coord_fun_params, params ); ret
}

t_val ml_gltexgenva( value _tex_coord, value _tex_coord_fun_params, value params )
{
    GLenum tex_coord;
    GLenum tex_coord_fun_params;
#include "enums/tex_coord.inc.c"
#include "enums/tex_coord_fun_params.inc.c"
    int len = Wosize_val(params) / Double_wosize;
    if (len != 4) caml_invalid_argument("glTexGenva: array length should be 4");
    glTexGendv( tex_coord, tex_coord_fun_params, (GLdouble *)params ); ret
}

t_val ml_glsamplecoverage( value val, value invert )
{
#if GL_VERSION_1_3
    glSampleCoverage( Double_val(val), (Long_val(invert) ? GL_TRUE : GL_FALSE) ); ret
#else
    caml_failwith("glSampleCoverage: function not available"); ret
#endif
}


t_val ml_gldepthfunc( value _gl_func ) {
    GLenum gl_func;
#include "enums/gl_func.inc.c"
    glDepthFunc( gl_func );
    ret
}


t_val ml_glalphafunc( value _gl_func, value ref ) {
    GLenum gl_func;
#include "enums/gl_func.inc.c"
    glAlphaFunc( gl_func, Double_val(ref) );
    ret
}


t_val ml_glstencilfunc( value _gl_func, value ref, value mask ) {
    GLenum gl_func;
#include "enums/gl_func.inc.c"
    glStencilFunc( gl_func, Int_val(ref), (GLuint) Long_val(mask) );
    ret
}

t_val ml_glstencilfuncn( value _gl_func, value ref, value mask ) {
    GLenum gl_func;
#include "enums/gl_func.inc.c"
    glStencilFunc( gl_func, Int_val(ref), (GLuint) Nativeint_val(mask) );
    ret
}


t_val ml_glstencilmask( value mask ) { glStencilMask( (GLuint) Long_val(mask) ); ret }


t_val ml_glstencilop( value _sfail, value _dpfail, value _dppass ) {
  GLenum sfail, dpfail, dppass, stencil_op;
  value _stencil_op;

  {
      _stencil_op = _sfail;
#include "enums/stencil_op.inc.c"
      sfail = stencil_op;
  }
  {
      _stencil_op = _dpfail;
#include "enums/stencil_op.inc.c"
      dpfail = stencil_op;
  }
  {
      _stencil_op = _dppass;
#include "enums/stencil_op.inc.c"
      dppass = stencil_op;
  }

  glStencilOp( sfail, dpfail, dppass ); ret
}


t_val ml_glhint( value _hint_target, value _hint_mode ) {
    GLenum hint_target, hint_mode;
#include "enums/hint_target.inc.c"
#include "enums/hint_mode.inc.c"
    glHint( hint_target, hint_mode );
    ret
}


t_val ml_glcullface( value _face_mode ) {
    GLenum face_mode;
#include "enums/face_mode.inc.c"
    glCullFace( face_mode );
    ret
}


t_val ml_gldrawbuffer( value _draw_buffer_mode ) {
    GLenum draw_buffer_mode;
#include "enums/draw_buffer_mode.inc.c"
    glDrawBuffer( draw_buffer_mode );
    ret
}


t_val ml_glreadbuffer( value _read_buffer_mode ) {
    GLenum read_buffer_mode;
#include "enums/read_buffer_mode.inc.c"
    glReadBuffer( read_buffer_mode );
    ret
}


t_val ml_glblendfunc( value _blend_sfactor, value _blend_dfactor ) {
    GLenum blend_sfactor, blend_dfactor;
#include "enums/blend_sfactor.inc.c"
#include "enums/blend_dfactor.inc.c"
    glBlendFunc( blend_sfactor, blend_dfactor );
    ret
}


t_val ml_glblendequation( value _blend_mode ) {
    GLenum blend_mode;
#include "enums/blend_mode.inc.c"
    glBlendEquation( blend_mode ); ret
}

/*
t_val ml_glblendequationext( value _blend_mode_ext ) {
    GLenum blend_mode_ext;
#include "enums/blend_mode_ext.inc.c"
    glBlendEquationEXT( blend_mode_ext ); ret
}
*/


t_val ml_glclipplane( value _clip_plane, value equation )
{
    GLenum clip_plane;
    int len;
    len = Wosize_val(equation) / Double_wosize;
    if (len != 4)
        caml_invalid_argument("glClipPlane: array length should be 4");
#include "enums/clip_plane.inc.c"
    glClipPlane( clip_plane, (GLdouble *)equation ); ret
}

t_val ml_glclipplane_unsafe( value _clip_plane, value equation )
{
    GLenum clip_plane;
#include "enums/clip_plane.inc.c"
    glClipPlane( clip_plane, (GLdouble *)equation ); ret
}

t_val ml_glclipplane_i( value i, value equation )
{
    int len;
    len = Wosize_val(equation) / Double_wosize;
    if (len != 4)
        caml_invalid_argument("glClipPlane: array length should be 4");
    glClipPlane( GL_CLIP_PLANE0 + Int_val(i), (GLdouble *)equation ); ret
}

t_val ml_glclipplane_i_unsafe( value i, value equation )
{
    glClipPlane( GL_CLIP_PLANE0 + Int_val(i), (GLdouble *)equation ); ret
}

/* TODO:
void glGetClipPlane( GLenum plane, GLdouble *equation );
*/

t_val ml_gllogicop( value _op_code )
{
    GLenum op_code;
#include "enums/op_code.inc.c"
    glLogicOp( op_code ); ret
}


t_val ml_glpolygonoffset( value factor, value units ) {
    glPolygonOffset( Double_val(factor), Double_val(units) ); ret
}


t_val ml_glmap1d_native( value _map1_target, value u1, value u2, value stride, value order, value points ) {
    GLenum map1_target;
#include "enums/map1_target.inc.c"
    // TODO: check the length of the points array
    glMap1d( map1_target, Double_val(u1), Double_val(u2),
             Int_val(stride), Int_val(order),
             (GLdouble *) (&Double_field(points, 0)) );
    ret
}

t_val ml_glmap1d_bytecode( value * argv, int argn )
    { return ml_glmap1d_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5] ); }


t_val ml_glmap2d_native( value _map2_target,
                         value u1, value u2, value ustride, value uorder,
                         value v1, value v2, value vstride, value vorder, value _points )
{
    CAMLparam1( _points );
    GLdouble *points;
    int i, j, k, c, len;
    value ar_i, ar_j;
    GLenum map2_target;
#include "enums/map2_target.inc.c"

    len = Int_val(ustride) * Int_val(uorder) * Int_val(vorder);
    points = malloc(sizeof(GLdouble) * len );

    c=0;
    for (i=0; i < Wosize_val(_points); i++) {
        ar_i = Field(_points, i);
        for (j=0; j < Wosize_val(ar_i); j++) {
            ar_j = Field(ar_i, j);
            for (k=0; k < Wosize_val(ar_j) / Double_wosize; k++) {
                points[c] = (GLdouble) Double_field(ar_j, k);
                c++;
            }
        }
    }
    // TODO: check the length of the points array

    glMap2d( map2_target,
             Double_val(u1), Double_val(u2), Int_val(ustride), Int_val(uorder),
             Double_val(v1), Double_val(v2), Int_val(vstride), Int_val(vorder),
             (GLdouble *) points );

    free(points);
    CAMLreturn(Val_unit);
}
t_val ml_glmap2d_bytecode( value * argv, int argn )
    { return ml_glmap2d_native( argv[0], argv[1], argv[2], argv[3], argv[4],
                                argv[5], argv[6], argv[7], argv[8], argv[9] ); }


t_val ml_glevalmesh1( value mode, value i1, value i2 )
{
    glEvalMesh1( (Int_val(mode) ? GL_LINE : GL_POINT ),
                  Int_val(i1),
                  Int_val(i2) ); ret
}

t_val ml_glevalmesh2( value _mode, value i1, value i2, value j1, value j2 )
{
    GLenum mode;
    switch (Int_val(_mode)) {
        case 0: mode = GL_POINT; break;
        case 1: mode = GL_LINE; break;
        case 2: mode = GL_FILL; break;
    }
    glEvalMesh2( mode,
                 Int_val(i1),
                 Int_val(i2),
                 Int_val(j1),
                 Int_val(j2) ); ret
}

t_val ml_glevalpoint1( value i ) { glEvalPoint1( Int_val(i) ); ret }
t_val ml_glevalpoint2( value i, value j ) { glEvalPoint2( Int_val(i), Int_val(j) ); ret }


t_val ml_glevalcoord1d( value u ) { glEvalCoord1d( Double_val(u) ); ret }
t_val ml_glevalcoord2d( value u, value v ) { glEvalCoord2d( Double_val(u), Double_val(v) ); ret }



t_val ml_gllight1( value light_i, value ml_pname, value param )
{
    GLenum pname;
    switch (Int_val(ml_pname))
    {
        case 0: pname = GL_SPOT_EXPONENT; break;
        case 1: pname = GL_SPOT_CUTOFF; break;
        case 2: pname = GL_CONSTANT_ATTENUATION; break;
        case 3: pname = GL_LINEAR_ATTENUATION; break;
        case 4: pname = GL_QUADRATIC_ATTENUATION; break;
    }
    glLightf( GL_LIGHT0 + Int_val(light_i), pname, Double_val(param) );
    return Val_unit;
}

t_val ml_gllight3( value light_i, value p1, value p2, value p3 )
{
    GLfloat params[3];
    params[0] = (GLfloat) Double_val(p1);
    params[1] = (GLfloat) Double_val(p2);
    params[2] = (GLfloat) Double_val(p3);

    glLightfv( GL_LIGHT0 + Int_val(light_i), GL_SPOT_DIRECTION, params );
    return Val_unit;
}

t_val ml_gllight4_native( value light_i, value ml_pname, value p1, value p2, value p3, value p4 )
{
    GLenum pname;
    GLfloat params[4];
    params[0] = (GLfloat) Double_val(p1);
    params[1] = (GLfloat) Double_val(p2);
    params[2] = (GLfloat) Double_val(p3);
    params[3] = (GLfloat) Double_val(p4);

    switch (Int_val(ml_pname))
    {
        case 0: pname = GL_AMBIENT; break;
        case 1: pname = GL_DIFFUSE; break;
        case 2: pname = GL_SPECULAR; break;
        case 3: pname = GL_POSITION; break;
    }
    glLightfv( GL_LIGHT0 + Int_val(light_i), pname, params );
    return Val_unit;
}
t_val ml_gllight4_bytecode( value * argv, int argn )
          { return ml_gllight4_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5] ); }



t_val ml_glgetlight1( value light_i, value ml_pname )
{
    GLfloat params;
    GLenum pname;
    switch (Int_val(ml_pname))
    {
        case 0: pname = GL_SPOT_EXPONENT; break;
        case 1: pname = GL_SPOT_CUTOFF; break;
        case 2: pname = GL_CONSTANT_ATTENUATION; break;
        case 3: pname = GL_LINEAR_ATTENUATION; break;
        case 4: pname = GL_QUADRATIC_ATTENUATION; break;
    }
    glGetLightfv( GL_LIGHT0 + Int_val(light_i), pname, &params );
    return caml_copy_double( params );
}

t_val ml_glgetlight3( value light_i )
{
    CAMLparam1( light_i );
    CAMLlocal1( tuple );

    GLfloat params[3];

    glGetLightfv( GL_LIGHT0 + Int_val(light_i), GL_SPOT_DIRECTION, params );

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(params[0]) );
    Store_field( tuple, 1, caml_copy_double(params[1]) );
    Store_field( tuple, 2, caml_copy_double(params[2]) );

    CAMLreturn( tuple );
}


t_val ml_glgetlight4( value light_i, value ml_pname )
{
    CAMLparam2( light_i, ml_pname );
    CAMLlocal1( tuple );

    GLfloat params[4];

    GLenum pname;
    switch (Int_val(ml_pname))
    {
        case 0: pname = GL_AMBIENT; break;
        case 1: pname = GL_DIFFUSE; break;
        case 2: pname = GL_SPECULAR; break;
        case 3: pname = GL_POSITION; break;
    }

    glGetLightfv( GL_LIGHT0 + Int_val(light_i), pname, params );

    tuple = caml_alloc(4, 0);

    Store_field( tuple, 0, caml_copy_double(params[0]) );
    Store_field( tuple, 1, caml_copy_double(params[1]) );
    Store_field( tuple, 2, caml_copy_double(params[2]) );
    Store_field( tuple, 3, caml_copy_double(params[3]) );

    CAMLreturn( tuple );
}


t_val ml_glgetlightmodelcolorcontrol( value unit )
{
#if defined(GL_VERSION_3_0)
    caml_failwith("GL_LIGHT_MODEL_COLOR_CONTROL: deprecated in OpenGL 3"); ret
#else
    GLint param;
    glGetIntegerv( GL_LIGHT_MODEL_COLOR_CONTROL, &param );

    switch (param)
    {
        case GL_SEPARATE_SPECULAR_COLOR: return Val_int(0);
        case GL_SINGLE_COLOR: return Val_int(1);
        default:
            caml_failwith("glGetLightModelColorControl");
    }
#endif
}


t_val ml_glLightModel1( value i )
{
    switch(Int_val(i))
    {
        case 0: glLightModeli( GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR ); break;
        case 1: glLightModeli( GL_LIGHT_MODEL_COLOR_CONTROL, GL_SINGLE_COLOR ); break;
    }
    return Val_unit;
}

t_val ml_glLightModel2( value i, value param )
{
    GLenum pname;
    switch(Int_val(i))
    {
        case 0: pname = GL_LIGHT_MODEL_LOCAL_VIEWER; break;
        case 1: pname = GL_LIGHT_MODEL_TWO_SIDE; break;
    }
    glLightModeli( pname, Bool_val(param) );
    return Val_unit;
}

t_val ml_glLightModel4( value r, value g, value b, value a )
{
    GLfloat params[4];

    params[0] = Double_val(r);
    params[1] = Double_val(g);
    params[2] = Double_val(b);
    params[3] = Double_val(a);

    glLightModelfv( GL_LIGHT_MODEL_AMBIENT, params );
    return Val_unit;
}


t_val ml_glcolormaterial( value _face_mode, value _color_material_mode )
{
    GLenum face_mode;
    GLenum color_material_mode;
#include "enums/face_mode.inc.c"
#include "enums/color_material_mode.inc.c"
    glColorMaterial( face_mode, color_material_mode );
    return Val_unit;
}


t_val ml_glsecondarycolor3d( value red, value green, value blue )
{
    glSecondaryColor3d( Double_val(red), Double_val(green), Double_val(blue) ); ret
}


t_val ml_glmaterial1( value _face_mode, value param )
{
    GLenum face_mode;
#include "enums/face_mode.inc.c"
    glMaterialf( face_mode, GL_SHININESS, Double_val(param) );
    return Val_unit;
}

t_val ml_glmaterial3i( value _face_mode, value p1, value p2, value p3 )
{
    GLfloat params[3];
    GLenum face_mode;
#include "enums/face_mode.inc.c"

    params[0] = Int_val(p1);
    params[1] = Int_val(p2);
    params[2] = Int_val(p3);

    glMaterialfv( face_mode, GL_COLOR_INDEXES, params );
    return Val_unit;
}

t_val ml_glmaterial4_native( value _face_mode, value _pname, value p1, value p2, value p3, value p4 )
{
    GLfloat params[4];
    GLenum pname;
    GLenum face_mode;
#include "enums/face_mode.inc.c"

    params[0] = Double_val(p1);
    params[1] = Double_val(p2);
    params[2] = Double_val(p3);
    params[3] = Double_val(p4);

    switch (Int_val(_pname))
    {
        case 0: pname = GL_AMBIENT; break;
        case 1: pname = GL_DIFFUSE; break;
        case 2: pname = GL_SPECULAR; break;
        case 3: pname = GL_EMISSION; break;
        case 4: pname = GL_AMBIENT_AND_DIFFUSE; break;
    }

    glMaterialfv( face_mode, pname, params );
    return Val_unit;
}
t_val ml_glmaterial4_bytecode( value * argv, int argn )
    { return ml_glmaterial4_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5] ); }



t_val ml_glgetmaterial4f( value face, value mat )
{
    CAMLparam2(face, mat);
    CAMLlocal1(tuple);

    GLfloat params[4];
    GLenum pname;
    switch (Int_val(mat))
    {
        case 0: pname = GL_AMBIENT; break;
        case 1: pname = GL_DIFFUSE; break;
        case 2: pname = GL_SPECULAR; break;
        case 3: pname = GL_EMISSION; break;
    }
    glGetMaterialfv( (face == Val_int(0) ? GL_FRONT : GL_BACK), pname, params );

    tuple = caml_alloc(4, 0);
    Store_field( tuple, 0, caml_copy_double(params[0]) );
    Store_field( tuple, 1, caml_copy_double(params[1]) );
    Store_field( tuple, 2, caml_copy_double(params[2]) );
    Store_field( tuple, 3, caml_copy_double(params[3]) );
    CAMLreturn(tuple);
}

t_val ml_glgetmaterial1f( value face, value mat )
{
    GLfloat params;
    glGetMaterialfv( (face == Val_int(0) ? GL_FRONT : GL_BACK), GL_SHININESS, &params );
    return caml_copy_double(params);
}

t_val ml_glgetmaterial3i( value face, value mat )
{
    CAMLparam2(face, mat);
    CAMLlocal1(tuple);

    GLint params[3];
    glGetMaterialiv( (face == Val_int(0) ? GL_FRONT : GL_BACK), GL_COLOR_INDEXES, params );

    tuple = caml_alloc(3, 0);
    Store_field( tuple, 0, Val_int(params[0]) );
    Store_field( tuple, 1, Val_int(params[1]) );
    Store_field( tuple, 2, Val_int(params[2]) );
    CAMLreturn(tuple);
}



t_val ml_glaccum( value _accum_op, value val )
{
    GLenum accum_op;
#include "enums/accum_op.inc.c"
    glAccum( accum_op, Double_val(val) ); ret
}


t_val ml_glmapgrid1d( value un, value u1, value u2 )
{
    glMapGrid1d( Int_val(un), Double_val(u1), Double_val(u2) ); ret
}

t_val ml_glmapgrid2d_native( value un, value u1, value u2, value vn, value v1, value v2 )
{
    glMapGrid2d( Int_val(un),Double_val(u1), Double_val(u2), Int_val(vn), Double_val(v1), Double_val(v2) ); ret
}
t_val ml_glmapgrid2d_bytecode( value * argv, int argn )
    { return ml_glmapgrid2d_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5] ); }



t_val ml_glpushattrib( value mask_list ) {
    CAMLparam1( mask_list );
    CAMLlocal1( _attrib_bit );

    GLbitfield mask = 0;
    GLbitfield attrib_bit;

    while ( mask_list != Val_emptylist )
    {
        _attrib_bit = Field(mask_list,0);
        {
#include "enums/attrib_bit.inc.c"
        }
        mask |= attrib_bit;
        mask_list = Field(mask_list,1);
    }

    glPushAttrib( mask );

    CAMLreturn( Val_unit );
}

t_val ml_glpopattrib( value unit ) { glPopAttrib(); ret }



t_val ml_glnewlist( value list, value _list_mode ) {
    GLenum list_mode;
#include "enums/list_mode.inc.c"
    glNewList( Int_val(list), list_mode );
    ret
}


t_val ml_glgenlists( value range )
{
    GLuint id = glGenLists( Int_val(range) );
    if (id == 0) caml_failwith("glGenLists");
    return Val_int(id);
}

t_val ml_glgenlist( value unit )
{
    GLuint id = glGenLists(1);
    if (id == 0) caml_failwith("glGenList");
    return Val_int(id);
}

t_val ml_glendlist( value unit ) { glEndList(); ret }

t_val ml_glcalllist( value list ) { glCallList( Int_val(list) ); ret }

t_val ml_gldeletelists( value list, value range ) { glDeleteLists( Int_val(list), Int_val(range) ); ret }

t_val ml_gllistbase( value base ) { glListBase( Int_val(base) ); ret }

t_val ml_glislist( value list ) { return Val_bool(glIsList( Int_val(list) )); }


t_val ml_glcalllists( value ml_lists )
{
    int i, len;
    GLint *lists;

    len = Wosize_val(ml_lists);
    lists = calloc( len, sizeof(GLint) );

    for (i=0; i < len; i++)
        lists[i] = Int_val(Field(ml_lists,i));

    glCallLists( len, GL_INT, lists );

    free(lists);
    return Val_unit;
}


t_val ml_glgetlistmode( value unit )
{
    GLint _list_mode;
    int list_mode;
    glGetIntegerv( GL_LIST_MODE, &_list_mode );
#include "enums/list_mode.inc-r.c"
    return Val_int(list_mode);
}

t_val ml_glgetcullfacemode( value unit )
{
    GLint _face_mode;
    int face_mode;
    glGetIntegerv( GL_CULL_FACE_MODE, &_face_mode );
#include "enums/face_mode.inc-r.c"
    return Val_int(face_mode);
}



t_val ml_glrendermode( value _render_mode )
{
    GLenum render_mode;
#include "enums/render_mode.inc.c"
    return Val_int( glRenderMode( render_mode ) );
}


t_val ml_glinitnames( value unit ) { glInitNames(); ret }
t_val ml_glloadname( value name ) { glLoadName( Int_val(name) ); ret }
t_val ml_glpushname( value name ) { glPushName( Int_val(name) ); ret }
t_val ml_glpopname( value unit ) { glPopName(); ret }


/* WIP */
t_val ml_alloc_select_buffer( value buffer_size )
{
    GLuint *select_buffer;
    select_buffer = malloc(Int_val(buffer_size) * sizeof(GLuint));
    return (value) select_buffer;
}

t_val ml_free_select_buffer( value ml_select_buffer )
{
    GLuint *select_buffer;
    select_buffer = (GLuint *) ml_select_buffer;
    free(select_buffer);
    return Val_unit;
}

t_val ml_select_buffer_get( value ml_select_buffer, value index )
{
    GLuint *select_buffer;
    select_buffer = (GLuint *) ml_select_buffer;
    return Val_int(select_buffer[Int_val(index)]);
}

t_val ml_glselectbuffer( value buffer_size, value ml_select_buffer )
{
    GLuint *select_buffer;
    select_buffer = (GLuint *) ml_select_buffer;
    glSelectBuffer( Int_val(buffer_size), select_buffer );
    ret
}


/* BA */

t_val ml_glselectbuffer_ba( value ba )
{
    GLuint *select_buffer;
    GLsizei size;
    select_buffer = (GLuint *) Data_bigarray_val(ba);
    size = Bigarray_val(ba)->dim[0];
    glSelectBuffer( size, select_buffer );
    ret
}

/* EOB */


t_val ml_glfog2( value ml_pname, value param )
{
    GLenum pname;
    switch (Int_val(ml_pname))
    {
        case 1: pname = GL_FOG_DENSITY; break;
        case 2: pname = GL_FOG_START; break;
        case 3: pname = GL_FOG_END; break;
        case 4: pname = GL_FOG_INDEX; break;
    }
    glFogf( pname, Double_val(param) );
    return Val_unit;
}

t_val ml_glfog1( value i )
{
    GLenum pname;
    GLint param;
    switch(Int_val(i))
    {
#if defined(GL_VERSION_1_5)
        case 1: pname = GL_FOG_COORD_SRC; param = GL_FOG_COORD; break;
        case 2: pname = GL_FOG_COORD_SRC; param = GL_FRAGMENT_DEPTH; break;
#else
        case 1:
        case 2:
            caml_failwith("glFog: GL_FOG_COORD_SRC only since OpenGL 1.5");
            break;
#endif
        case 3: pname = GL_FOG_MODE;      param = GL_LINEAR; break;
        case 4: pname = GL_FOG_MODE;      param = GL_EXP; break;
        case 5: pname = GL_FOG_MODE;      param = GL_EXP2; break;
    }
    glFogi( pname, param );
    return Val_unit;
}

t_val ml_glfog4( value r, value g, value b, value a )
{
      GLfloat params[4];

      params[0] = Double_val(r);
      params[1] = Double_val(g);
      params[2] = Double_val(b);
      params[3] = Double_val(a);

      glFogfv( GL_FOG_COLOR, params ); ret
}


t_val ml_glindexd( value c ) { glIndexd( Double_val(c) ); ret }
t_val ml_glindexi( value c ) { glIndexi( Int_val(c) ); ret }



t_val ml_glgentextures( value n )
{
    CAMLparam1(n);
    CAMLlocal1(tex);
    int i, len;
    GLuint *textures;
    len = Int_val(n);
    textures = malloc( len * sizeof(GLuint));
    glGenTextures( len, textures );

    tex = caml_alloc(len, 0);

    for (i=0; i < len; i++)
        Store_field( tex, i, Val_long(textures[i]) );

    free(textures);
    CAMLreturn(tex);
}


t_val ml_glgentexture( value unit )
{
    GLuint texture;
    glGenTextures( 1, &texture );
    return Val_int(texture);
}


t_val ml_glbindtexture( value _texture_binding, value texture )
{
    GLenum texture_binding;
#include "enums/texture_binding.inc.c"
    glBindTexture( texture_binding, Long_val(texture) ); ret
}

t_val ml_glunbindtexture( value _texture_binding )
{
    GLenum texture_binding;
#include "enums/texture_binding.inc.c"
    glBindTexture( texture_binding, 0 ); ret
}

t_val ml_glbindtexture2d( value texture )
{
    glBindTexture( GL_TEXTURE_2D, Long_val(texture) ); ret
}
t_val ml_glunbindtexture2d( value unit )
{
    /* deactive the previous active texture */
    glBindTexture(GL_TEXTURE_2D, 0); ret
}


t_val ml_gldeletetextures( value ml_textures )
{
    GLuint *textures;
    int i, len;
    len = Wosize_val(ml_textures);
    textures = malloc( len * sizeof(GLuint));
    for (i=0; i < len; i++)
        textures[i] = Long_val(Field(ml_textures, i));

    glDeleteTextures( len, textures );
    free(textures);
    ret
}

t_val ml_gldeletetexture( value ml_texture )
{
    GLuint texture = Long_val(ml_texture);
    glDeleteTextures( 1, &texture ); ret
}

t_val ml_glistexture( value texture )
{
    if (glIsTexture( Long_val(texture) )) { return Val_true; } else { return Val_false; }
}


t_val ml_glprioritizetexture( value ml_texture, value ml_priority )
{
    GLuint texture = Long_val(ml_texture);
    GLclampf priority = Double_val(ml_priority);
    glPrioritizeTextures( 1, &texture, &priority );
    ret
}

t_val ml_glprioritizetextures( value ml_textures, value ml_priorities )
{
    GLuint *textures;
    GLclampf *priorities;
    int i, tlen, plen;
    tlen = Wosize_val(ml_textures);
    plen = Wosize_val(ml_priorities) / Double_wosize;

    if (tlen != plen)
        caml_invalid_argument("glPrioritizeTextures: different array lengths");

    textures = malloc( tlen * sizeof(GLuint));
    priorities = malloc( plen * sizeof(GLclampf));

    for (i=0; i < tlen; i++)
        textures[i] = Long_val(Field(ml_textures, i));

    for (i=0; i < plen; i++)
        priorities[i] = Double_field(ml_priorities, i);

    glPrioritizeTextures( tlen, textures, priorities );
    free(textures);
    free(priorities);
    ret
}


t_val ml_glprioritizetexturesp( value ml_p_textures )
{
    GLuint *textures;
    GLclampf *priorities;
    int i, len;
    len = Wosize_val(ml_p_textures);

    textures = malloc( len * sizeof(GLuint));
    priorities = malloc( len * sizeof(GLclampf));

    for (i=0; i < len; i++)
    {
        textures[i] = Long_val( Field( Field(ml_p_textures, i), 0) );
        priorities[i] = Double_val( Field( Field(ml_p_textures, i), 1) );
    }

    glPrioritizeTextures( len, textures, priorities );
    free(textures);
    free(priorities);
    ret
}


t_val ml_glteximage2d_native(
                   value _target_2d,
                   value level,
                   value _internal_format,
                   value width,
                   value height,
                   value _pixel_data_format,
                   value _pixel_data_type,
                   value pixels )
{
    GLenum pixel_data_format;
    GLenum pixel_data_type;
    GLenum target_2d;
    GLint internal_format;
#include "enums/pixel_data_format.inc.c"
#include "enums/pixel_data_type.inc.c"
#include "enums/target_2d.inc.c"
#include "enums/internal_format.inc.c"
    glTexImage2D(
            target_2d,
            Int_val(level),
            internal_format,
            Int_val(width),
            Int_val(height),
            0,
            pixel_data_format,
            pixel_data_type,
            //(const GLvoid *) pixels ); ret
            (const GLvoid *) Data_bigarray_val(pixels) ); ret
}
t_val ml_glteximage2d_bytecode( value * argv, int argn )
    { return ml_glteximage2d_native( argv[0], argv[1], argv[2], argv[3],
                                     argv[4], argv[5], argv[6], argv[7] ); }


t_val ml_glteximage2d_str_native(
                   value _target_2d,
                   value level,
                   value internal_format,
                   value width,
                   value height,
                   value _pixel_data_format,
                   value _pixel_data_type,
                   value pixels )
{
    GLenum pixel_data_format;
    GLenum pixel_data_type;
    GLenum target_2d;
#include "enums/pixel_data_format.inc.c"
#include "enums/pixel_data_type.inc.c"
#include "enums/target_2d.inc.c"
    glTexImage2D(
            target_2d,
            Int_val(level),
            Internal_format_val(internal_format),
            Int_val(width),
            Int_val(height),
            0,
            pixel_data_format,
            pixel_data_type,
            //(const GLvoid *) pixels ); ret
            (const GLvoid *) String_val(pixels) ); ret
}
t_val ml_glteximage2d_str_bytecode( value * argv, int argn )
    { return ml_glteximage2d_str_native( argv[0], argv[1], argv[2], argv[3],
                                         argv[4], argv[5], argv[6], argv[7] ); }



t_val ml_glteximage1d_native(
                   value target,
                   value level,
                   value _internal_format,
                   value width,
                   value _pixel_data_format,
                   value _pixel_data_type,
                   value pixels )
{
    GLenum pixel_data_format;
    GLenum pixel_data_type;
    GLint internal_format;
#include "enums/pixel_data_format.inc.c"
#include "enums/pixel_data_type.inc.c"
#include "enums/internal_format.inc.c"
    glTexImage1D(
            (Int_val(target) ? GL_PROXY_TEXTURE_1D : GL_TEXTURE_1D),
            Int_val(level),
            internal_format,
            Int_val(width),
            0,
            pixel_data_format,
            pixel_data_type,
            //(const GLvoid *) pixels ); ret
            (const GLvoid *) Data_bigarray_val(pixels) ); ret
}
t_val ml_glteximage1d_bytecode( value * argv, int argn )
    { return ml_glteximage1d_native( argv[0], argv[1], argv[2],
                                     argv[3], argv[4], argv[5], argv[6] ); }




t_val ml_glteximage3d_native(
                   value target,
                   value level,
                   value _internal_format,
                   value width,
                   value height,
                   value depth,
                   value _pixel_data_format,
                   value _pixel_data_type,
                   value pixels )
{
    GLenum pixel_data_format;
    GLenum pixel_data_type;
    GLint internal_format;
#include "enums/pixel_data_format.inc.c"
#include "enums/pixel_data_type.inc.c"
#include "enums/internal_format.inc.c"
    glTexImage3D(
            (Int_val(target) ? GL_PROXY_TEXTURE_3D : GL_TEXTURE_3D),
            Int_val(level),
            internal_format,
            Int_val(width),
            Int_val(height),
            Int_val(depth),
            0,
            pixel_data_format,
            pixel_data_type,
            //(const GLvoid *) pixels ); ret
            (const GLvoid *) Data_bigarray_val(pixels) ); ret
}
t_val ml_glteximage3d_bytecode( value * argv, int argn )
    { return ml_glteximage3d_native( argv[0], argv[1], argv[2], argv[3],
                                     argv[4], argv[5], argv[6], argv[7], argv[8] ); }



t_val ml_glcopyteximage2d_native(
    value _copy_tex_target,
    value level,
    value _internal_format,
    value x,
    value y,
    value width,
    value height,
    value border)
{
    GLenum copy_tex_target;
    GLint internal_format;
#include "enums/copy_tex_target.inc.c"
#include "enums/internal_format.inc.c"
    glCopyTexImage2D(
        copy_tex_target,
        Int_val(level),
        internal_format,
        Int_val(x),
        Int_val(y),
        Int_val(width),
        Int_val(height),
        Int_val(border));
    return Val_unit;
}
t_val ml_glcopyteximage2d_bytecode( value * argv, int argn )
    { return ml_glcopyteximage2d_native( argv[0], argv[1], argv[2], argv[3],
                                         argv[4], argv[5], argv[6], argv[7] ); }

t_val ml_glpolygonstipple_unsafe( value mask )
{
    glPolygonStipple( (GLubyte *) Data_bigarray_val(mask) ); ret
}

t_val ml_glpolygonstipple( value mask )
{
    if (Bigarray_val(mask)->dim[0] != 128)
        caml_invalid_argument("glPolygonStipple: big array length should be 128");
    glPolygonStipple( (GLubyte *) Data_bigarray_val(mask) ); ret
}
// TODO:
//void glGetPolygonStipple( GLubyte *mask );


t_val ml_glgetinteger4( value _get_integer_4 )
{
    CAMLparam1( _get_integer_4 );
    CAMLlocal1( tuple );
    GLenum get_integer_4;

    GLint params[4];

#include "enums/get_integer_4.inc.c"

    glGetIntegerv( get_integer_4, params );

    tuple = caml_alloc(4, 0);

    Store_field( tuple, 0, Val_int(params[0]) );
    Store_field( tuple, 1, Val_int(params[1]) );
    Store_field( tuple, 2, Val_int(params[2]) );
    Store_field( tuple, 3, Val_int(params[3]) );

    CAMLreturn( tuple );
}


t_val ml_glgetinteger1( value _get_integer_1 )
{
    GLint param;
    GLenum get_integer_1;
#include "enums/get_integer_1.inc.c"
    glGetIntegerv( get_integer_1, &param );
    return Val_int(param);
}

t_val ml_glgettexturebinding( value _get_texture_binding )
{
    GLint param;
    GLenum get_texture_binding;
#include "enums/get_texture_binding.inc.c"
    glGetIntegerv( get_texture_binding, &param );
    return Val_int(param);
}


t_val ml_glgetboolean1( value _get_boolean_1 )
{
    GLboolean param;
    GLenum get_boolean_1;
#include "enums/get_boolean_1.inc.c"
    glGetBooleanv( get_boolean_1, &param );
    return Val_int(param);
}


t_val ml_glgetboolean4( value _get_boolean_4 )
{
    CAMLparam1( _get_boolean_4 );
    CAMLlocal1( tuple );
    GLenum get_boolean_4;

    GLboolean params[4];

#include "enums/get_boolean_4.inc.c"

    glGetBooleanv( get_boolean_4, params );

    tuple = caml_alloc(4, 0);

    Store_field( tuple, 0, Val_bool(params[0]) );
    Store_field( tuple, 1, Val_bool(params[1]) );
    Store_field( tuple, 2, Val_bool(params[2]) );
    Store_field( tuple, 3, Val_bool(params[3]) );

    CAMLreturn( tuple );
}


t_val ml_glgetmatrix( value _get_matrix )
{
    CAMLparam1( _get_matrix );
    CAMLlocal2( mat, _m );
    int i, j;
    GLdouble params[16];
    GLenum  get_matrix;
#include "enums/get_matrix.inc.c"

    glGetDoublev( get_matrix, params );

    mat = caml_alloc(4, 0);

    j=0;
    for (i=0; i < 4; i++)
    {
        _m = caml_alloc(4 * Double_wosize, Double_array_tag);

        Store_double_field( _m, 0, params[j] ); j++;
        Store_double_field( _m, 1, params[j] ); j++;
        Store_double_field( _m, 2, params[j] ); j++;
        Store_double_field( _m, 3, params[j] ); j++;

        Store_field( mat, i, _m );
    }

    CAMLreturn( mat );
}

t_val ml_glgetmatrix_flat( value _get_matrix )
{
    CAMLparam1( _get_matrix );
    CAMLlocal1( mat );
    int i;
    GLdouble params[16];
    GLenum  get_matrix;
#include "enums/get_matrix.inc.c"

    glGetDoublev( get_matrix, params );

    mat = caml_alloc(16 * Double_wosize, Double_array_tag);

    for (i=0; i < 16; i++)
    {
        Store_double_field( mat, i, params[i] );
    }

    CAMLreturn( mat );
}

t_val ml_glgetfloat1( value _get_float_1 )
{
    GLdouble params;
    GLenum get_float_1;
#include "enums/get_float_1.inc.c"
    glGetDoublev( get_float_1, &params );
    return caml_copy_double(params);
}


t_val ml_glgetfloat2( value _get_float_2 )
{
    CAMLparam1( _get_float_2 );
    CAMLlocal1( tuple );
    GLenum get_float_2;

    GLdouble params[2];

#include "enums/get_float_2.inc.c"

    glGetDoublev( get_float_2, params );

    tuple = caml_alloc(2, 0);

    Store_field( tuple, 0, caml_copy_double(params[0]) );
    Store_field( tuple, 1, caml_copy_double(params[1]) );

    CAMLreturn( tuple );
}


t_val ml_glgetfloat3( value _get_float_3 )
{
    CAMLparam1( _get_float_3 );
    CAMLlocal1( tuple );
    GLenum get_float_3;

    GLdouble params[3];

#include "enums/get_float_3.inc.c"

    glGetDoublev( get_float_3, params );

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(params[0]) );
    Store_field( tuple, 1, caml_copy_double(params[1]) );
    Store_field( tuple, 2, caml_copy_double(params[2]) );

    CAMLreturn( tuple );
}


t_val ml_glgetfloat4( value _get_float_4 )
{
    CAMLparam1( _get_float_4 );
    CAMLlocal1( tuple );
    GLenum get_float_4;

    GLdouble params[4];

#include "enums/get_float_4.inc.c"

    glGetDoublev( get_float_4, params );

    tuple = caml_alloc(4, 0);

    Store_field( tuple, 0, caml_copy_double(params[0]) );
    Store_field( tuple, 1, caml_copy_double(params[1]) );
    Store_field( tuple, 2, caml_copy_double(params[2]) );
    Store_field( tuple, 3, caml_copy_double(params[3]) );

    CAMLreturn( tuple );
}


/* {{{ Multitexture */

t_val ml_glactivetexture( value _texture_i )
{
    GLenum texture_i;
#include "enums/texture_i.inc.c"
    glActiveTexture( texture_i ); ret
}

t_val ml_glactivetexture_i( value texture )
{
    glActiveTexture( GL_TEXTURE0 + Int_val(texture)); ret
}

t_val ml_glmultitexcoord2d( value _texture_i, value s, value t )
{
    GLenum texture_i;
#include "enums/texture_i.inc.c"
    glMultiTexCoord2d( texture_i, Double_val(s), Double_val(t) ); ret
}

t_val ml_glmultitexcoord2f_i( value texture, value s, value t )
{
    glMultiTexCoord2d( GL_TEXTURE0 + Int_val(texture), Double_val(s), Double_val(t) ); ret
}

/* }}} */


/* GLSL Shaders */

#ifdef GL_VERSION_2_0

t_val ml_glcreateshader( value shaderType )
{
    GLuint s = glCreateShader(
        (shaderType == Val_int(0) ? GL_VERTEX_SHADER : GL_FRAGMENT_SHADER) );
    if (s == 0) caml_failwith("glCreateShader");
    return Val_shader_object(s);
}

t_val ml_gldeleteshader( value shader )
{
    glDeleteShader( Shader_object_val(shader) ); ret
}

t_val ml_glisshader( value shader )
{
    return (glIsShader( Shader_object_val(shader) ) == GL_TRUE ? Val_true : Val_false);
}
// TODO: 
// GLboolean glIsProgram (GLuint);

t_val ml_glshadersource( value shader, value str )
{
    const char * vp = String_val(str);
    glShaderSource(Shader_object_val(shader), 1, &vp, NULL); ret
}

t_val ml_glcompileshader( value shader )
{
    glCompileShader( Shader_object_val(shader) ); ret
}

t_val ml_glcreateprogram( value unit )
{
    GLuint p = glCreateProgram();
    if (p == 0) caml_failwith("glCreateProgram");
    return Val_shader_program(p);
}

t_val ml_gldeleteprogram( value program )
{
    glDeleteProgram( Shader_program_val(program) ); ret
}

t_val ml_glattachshader( value program, value shader )
{
    glAttachShader( Shader_program_val(program), Shader_object_val(shader) ); ret
}

t_val ml_gldetachshader( value program, value shader )
{
    glDetachShader( Shader_program_val(program), Shader_object_val(shader) ); ret
}

t_val ml_gllinkprogram( value program )
{
    glLinkProgram( Shader_program_val(program) ); ret
}

t_val ml_gluseprogram( value program )
{
    glUseProgram( Shader_program_val(program) ); ret
}
t_val ml_glunuseprogram( value unit )
{
    /* desactivate */
    glUseProgram(0); ret
}

t_val ml_glgetshadercompilestatus( value shader )
{
    GLint error;
    glGetShaderiv( Shader_object_val(shader), GL_COMPILE_STATUS, &error);
    if (error == GL_TRUE) return Val_true;
    else return Val_false;
}

t_val ml_glgetshadercompilestatus_exn( value shader )
{
    GLint error;
    glGetShaderiv( Shader_object_val(shader), GL_COMPILE_STATUS, &error);
    if (error != GL_TRUE)
        caml_failwith("Shader compile status: error");
    ret
}

t_val ml_glgetuniformlocation( value program, value name )
{
    return Val_int( glGetUniformLocation( Shader_program_val(program), String_val(name) ));
}

#else
t_val ml_glcreateshader( value shaderType )
{
    caml_failwith("glCreateShader function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_gldeleteshader( value shader )
{
    caml_failwith("glDeleteShader function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_glisshader( value shader )
{
    caml_failwith("glIsShader function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_glshadersource( value shader, value str )
{
    caml_failwith("glShaderSource function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_glcompileshader( value shader )
{
    caml_failwith("glCompileShader function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_glcreateprogram( value unit )
{
    caml_failwith("glCreateProgram function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_gldeleteprogram( value program )
{
    caml_failwith("glDeleteProgram function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_glattachshader( value program, value shader )
{
    caml_failwith("glAttachShader function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_gldetachshader( value program, value shader )
{
    caml_failwith("glDetachShader function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_gllinkprogram( value program )
{
    caml_failwith("glLinkProgram function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_gluseprogram( value program )
{
    caml_failwith("glUseProgram function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_glunuseprogram( value unit )
{
    caml_failwith("glUseProgram function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
t_val ml_glgetuniformlocation( value program, value name )
{
    caml_failwith("glGetUniformLocation function is available only if the GL version is 2.0 or greater");
    return Val_unit;
}
#endif


#ifdef GL_VERSION_2_0

t_val ml_gluniform1f( value location, value v0) {
    glUniform1f( Int_val(location), Double_val(v0)); ret
}

t_val ml_gluniform2f( value location, value v0, value v1) {
    glUniform2f( Int_val(location), Double_val(v0), Double_val(v1)); ret
}

t_val ml_gluniform3f( value location, value v0, value v1, value v2) {
    glUniform3f( Int_val(location), Double_val(v0), Double_val(v1), Double_val(v2)); ret
}

t_val ml_gluniform4f( value location, value v0, value v1, value v2, value v3) {
    glUniform4f( Int_val(location), Double_val(v0), Double_val(v1), Double_val(v2), Double_val(v3)); ret
}

t_val ml_gluniform1i( value location, value v0) {
    glUniform1i( Int_val(location), Int_val(v0)); ret
}

t_val ml_gluniform2i( value location, value v0, value v1) {
    glUniform2i( Int_val(location), Int_val(v0), Int_val(v1)); ret
}

t_val ml_gluniform3i( value location, value v0, value v1, value v2) {
    glUniform3i( Int_val(location), Int_val(v0), Int_val(v1), Int_val(v2)); ret
}

t_val ml_gluniform4i( value location, value v0, value v1, value v2, value v3) {
    glUniform4i( Int_val(location), Int_val(v0), Int_val(v1), Int_val(v2), Int_val(v3)); ret
}

#else

t_val ml_gluniform1f( value location, value v0) {
    caml_failwith("glUniform1f function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_gluniform2f( value location, value v0, value v1) {
    caml_failwith("glUniform2f function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_gluniform3f( value location, value v0, value v1, value v2) {
    caml_failwith("glUniform3f function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_gluniform4f( value location, value v0, value v1, value v2, value v3) {
    caml_failwith("glUniform4f function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_gluniform1i( value location, value v0) {
    caml_failwith("glUniform1i function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_gluniform2i( value location, value v0, value v1) {
    caml_failwith("glUniform2i function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_gluniform3i( value location, value v0, value v1, value v2) {
    caml_failwith("glUniform3i function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_gluniform4i( value location, value v0, value v1, value v2, value v3) {
    caml_failwith("glUniform4i function is available only if the GL version is 2.0 or greater"); ret
}

#endif


// {{{ glUniformMatrix* 

#ifdef GL_VERSION_2_1

t_val ml_gluniformmatrix2fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[4];
    int len = Wosize_val(mat) / Double_wosize;
    if (len != 4) caml_failwith("glUniformMatrix2fv: array should contain 4 floats");
    val[0] = Double_field(mat, 0);
    val[1] = Double_field(mat, 1);
    val[2] = Double_field(mat, 2);
    val[3] = Double_field(mat, 3);
    glUniformMatrix2fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix3fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[9];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 9) caml_failwith("glUniformMatrix3fv: array should contain 9 floats");
    for (i=0; i<9; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix3fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix4fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[16];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 16) caml_failwith("glUniformMatrix4fv: array should contain 16 floats");
    for (i=0; i<16; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix4fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix2x3fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[6];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 6) caml_failwith("glUniformMatrix2x3fv: array should contain 6 floats");
    for (i=0; i<6; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix2x3fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix3x2fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[6];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 6) caml_failwith("glUniformMatrix3x2fv: array should contain 6 floats");
    for (i=0; i<6; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix3x2fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix2x4fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[8];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 8) caml_failwith("glUniformMatrix2x4fv: array should contain 8 floats");
    for (i=0; i<8; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix2x4fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix4x2fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[8];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 8) caml_failwith("glUniformMatrix4x2fv: array should contain 8 floats");
    for (i=0; i<8; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix4x2fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix3x4fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[12];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 12) caml_failwith("glUniformMatrix3x4fv: array should contain 12 floats");
    for (i=0; i<12; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix3x4fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

t_val ml_gluniformmatrix4x3fv(
        value location,
        value count,
        value transpose,
        value mat )
{
    GLfloat val[12];
    int i, len;
    len = Wosize_val(mat) / Double_wosize;
    if (len != 12) caml_failwith("glUniformMatrix4x3fv: array should contain 12 floats");
    for (i=0; i<12; i++) {
        val[i] = Double_field(mat, i);
    }
    glUniformMatrix4x3fv(
        Int_val(location),
        Int_val(count),
        Bool_val(transpose),
        val ); ret
}

#else
t_val ml_gluniformmatrix2fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix2fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix3fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix3fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix4fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix4fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix2x3fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix2x3fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix3x2fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix3x2fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix2x4fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix2x4fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix4x2fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix4x2fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix3x4fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix3x4fv function is available only if the GL version is 2.1 or greater"); ret
}
t_val ml_gluniformmatrix4x3fv( value location, value count, value transpose, value mat ) {
    caml_failwith("glUniformMatrix4x3fv function is available only if the GL version is 2.1 or greater"); ret
}
#endif

// }}}


t_val ml_glgetattriblocation( value program, value name )
{
#ifdef GL_VERSION_2_0
    GLint attr_loc = glGetAttribLocation( Shader_program_val(program), String_val(name) );
    return Val_int(attr_loc);
#else
    caml_failwith("glGetAttribLocation function is available only if the GL version is 2.0 or greater"); ret
#endif
}


t_val ml_glbindattriblocation( value program, value index, value name )
{
#ifdef GL_VERSION_2_0
    glBindAttribLocation( Shader_program_val(program),  Int_val(index), String_val(name) ); ret
#else
    caml_failwith("glBindAttribLocation function is available only if the GL version is 2.0 or greater"); ret
#endif
}




#ifdef GL_VERSION_2_0

static const GLenum get_program_bool_table[] = {
    GL_DELETE_STATUS,
    GL_LINK_STATUS,
    GL_VALIDATE_STATUS
};

static const GLenum get_program_int_table[] = {
    GL_INFO_LOG_LENGTH,
    GL_ATTACHED_SHADERS,
    GL_ACTIVE_ATTRIBUTES,
    GL_ACTIVE_ATTRIBUTE_MAX_LENGTH,
    GL_ACTIVE_UNIFORMS,
    GL_ACTIVE_UNIFORM_MAX_LENGTH
};

t_val ml_glgetprogram_int( value program, value v )
{
    GLint params;
    glGetProgramiv( Shader_program_val(program), get_program_int_table[Long_val(v)], &params );
    return Val_int(params);
}
t_val ml_glgetprogram_bool( value program, value v )
{
    GLint params;
    glGetProgramiv( Shader_program_val(program), get_program_bool_table[Long_val(v)], &params );
    if (params == GL_TRUE) return Val_true; else return Val_false;
}

#else
t_val ml_glgetprogram_int( value program, value v ) {
    caml_failwith("glGetProgrami function is available only if the GL version is 2.0 or greater"); ret
}
t_val ml_glgetprogram_bool( value program, value v ) {
    caml_failwith("glGetProgramb function is available only if the GL version is 2.0 or greater"); ret
}
#endif




#ifdef GL_VERSION_2_0
t_val ml_glvertexattrib1s(value index, value v0) { glVertexAttrib1s(Int_val(index), Int_val(v0)); ret }
t_val ml_glvertexattrib1d(value index, value v0) { glVertexAttrib1d(Int_val(index), Double_val(v0)); ret }

t_val ml_glvertexattrib2s(value index, value v0, value v1) { glVertexAttrib2s(Int_val(index), Int_val(v0), Int_val(v1)); ret }
t_val ml_glvertexattrib2d(value index, value v0, value v1) { glVertexAttrib2d(Int_val(index), Double_val(v0), Double_val(v1)); ret }

t_val ml_glvertexattrib3s(value index, value v0, value v1, value v2) { glVertexAttrib3s(Int_val(index), Int_val(v0), Int_val(v1), Int_val(v2)); ret }
t_val ml_glvertexattrib3d(value index, value v0, value v1, value v2) { glVertexAttrib3d(Int_val(index), Double_val(v0), Double_val(v1), Double_val(v2)); ret }

t_val ml_glvertexattrib4s(value index, value v0, value v1, value v2, value v3) { glVertexAttrib4s(Int_val(index), Int_val(v0), Int_val(v1), Int_val(v2), Int_val(v3)); ret }
t_val ml_glvertexattrib4d(value index, value v0, value v1, value v2, value v3) { glVertexAttrib4d(Int_val(index), Double_val(v0), Double_val(v1), Double_val(v2), Double_val(v3)); ret }
#else

t_val ml_glvertexattrib1s(value index, value v0) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }
t_val ml_glvertexattrib1d(value index, value v0) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }
t_val ml_glvertexattrib2s(value index, value v0, value v1) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }
t_val ml_glvertexattrib2d(value index, value v0, value v1) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }
t_val ml_glvertexattrib3s(value index, value v0, value v1, value v2) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }
t_val ml_glvertexattrib3d(value index, value v0, value v1, value v2) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }
t_val ml_glvertexattrib4s(value index, value v0, value v1, value v2, value v3) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }
t_val ml_glvertexattrib4d(value index, value v0, value v1, value v2, value v3) { caml_failwith("glVertexAttrib function is available only if the GL version is 2.0 or greater"); ret }

#endif



t_val ml_glgetshaderinfolog(value shader)
{
#ifdef GL_VERSION_2_0
    int infologLength = 0;
    int charsWritten  = 0;

    glGetShaderiv(Shader_object_val(shader), GL_INFO_LOG_LENGTH, &infologLength);

    if (infologLength > 0)
    {
        value infoLog = caml_alloc_string(infologLength);
        glGetShaderInfoLog(Shader_object_val(shader), infologLength, &charsWritten, String_val(infoLog));
        return infoLog;
    } else {
        return caml_copy_string("");
    }
#else
    caml_failwith("glGetShaderInfoLog is available only if the GL version is 2.0 or greater"); ret
#endif
}

t_val ml_glgetprograminfolog(value program)
{
#ifdef GL_VERSION_2_0
    int infologLength = 0;
    int charsWritten  = 0;

    glGetProgramiv( Shader_program_val(program), GL_INFO_LOG_LENGTH, &infologLength);

    if (infologLength > 0)
    {
        value infoLog = caml_alloc_string(infologLength);
        glGetProgramInfoLog(Shader_program_val(program), infologLength, &charsWritten, String_val(infoLog));
        return infoLog;
    } else {
        return caml_copy_string("");
    }
#else
    caml_failwith("glGetProgramInfoLog is available only if the GL version is 2.0 or greater"); ret
#endif
}


#if defined(GL_VERSION_2_0) && defined(GL_GLEXT_PROTOTYPES)
t_val ml_glenablevertexattribarray( value index ) { glEnableVertexAttribArray( Long_val(index) ); ret }
t_val ml_gldisablevertexattribarray( value index ) { glDisableVertexAttribArray( Long_val(index) ); ret }
#else
t_val ml_glenablevertexattribarray( value index ) { caml_failwith("glEnableVertexAttribArray is available only if the GL version is 2.0 or greater"); ret }
t_val ml_gldisablevertexattribarray( value index ) { caml_failwith("glDisableVertexAttribArray is available only if the GL version is 2.0 or greater"); ret }
#endif


/* {{{ */
#if 0

/*
 * Miscellaneous
 */

void glIndexMask( GLuint mask );



void glPushClientAttrib( GLbitfield mask );  /* 1.1 */
void glPopClientAttrib( void );  /* 1.1 */


/*
 * Drawing Functions
 */

void glVertex2i( GLint x, GLint y );
void glVertex3i( GLint x, GLint y, GLint z );
void glVertex4i( GLint x, GLint y, GLint z, GLint w );


void glNormal3b( GLbyte nx, GLbyte ny, GLbyte nz );
void glNormal3d( GLdouble nx, GLdouble ny, GLdouble nz );
void glNormal3f( GLfloat nx, GLfloat ny, GLfloat nz );
void glNormal3i( GLint nx, GLint ny, GLint nz );
void glNormal3s( GLshort nx, GLshort ny, GLshort nz );

void glNormal3bv( const GLbyte *v );
void glNormal3dv( const GLdouble *v );
void glNormal3fv( const GLfloat *v );
void glNormal3iv( const GLint *v );
void glNormal3sv( const GLshort *v );


void glIndexd( GLdouble c );
void glIndexf( GLfloat c );
void glIndexi( GLint c );
void glIndexs( GLshort c );
void glIndexub( GLubyte c );  /* 1.1 */

void glIndexdv( const GLdouble *c );
void glIndexfv( const GLfloat *c );
void glIndexiv( const GLint *c );
void glIndexsv( const GLshort *c );
void glIndexubv( const GLubyte *c );  /* 1.1 */


void glTexCoord1d( GLdouble s );
void glTexCoord1f( GLfloat s );
void glTexCoord1i( GLint s );
void glTexCoord1s( GLshort s );

void glTexCoord2d( GLdouble s, GLdouble t );
void glTexCoord2f( GLfloat s, GLfloat t );
void glTexCoord2i( GLint s, GLint t );
void glTexCoord2s( GLshort s, GLshort t );

void glTexCoord3d( GLdouble s, GLdouble t, GLdouble r );
void glTexCoord3f( GLfloat s, GLfloat t, GLfloat r );
void glTexCoord3i( GLint s, GLint t, GLint r );
void glTexCoord3s( GLshort s, GLshort t, GLshort r );

void glTexCoord4d( GLdouble s, GLdouble t, GLdouble r, GLdouble q );
void glTexCoord4f( GLfloat s, GLfloat t, GLfloat r, GLfloat q );
void glTexCoord4i( GLint s, GLint t, GLint r, GLint q );
void glTexCoord4s( GLshort s, GLshort t, GLshort r, GLshort q );

void glTexCoord1dv( const GLdouble *v );
void glTexCoord1fv( const GLfloat *v );
void glTexCoord1iv( const GLint *v );
void glTexCoord1sv( const GLshort *v );

void glTexCoord2dv( const GLdouble *v );
void glTexCoord2fv( const GLfloat *v );
void glTexCoord2iv( const GLint *v );
void glTexCoord2sv( const GLshort *v );

void glTexCoord3dv( const GLdouble *v );
void glTexCoord3fv( const GLfloat *v );
void glTexCoord3iv( const GLint *v );
void glTexCoord3sv( const GLshort *v );

void glTexCoord4dv( const GLdouble *v );
void glTexCoord4fv( const GLfloat *v );
void glTexCoord4iv( const GLint *v );
void glTexCoord4sv( const GLshort *v );




void glRectd( GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2 );
void glRectf( GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2 );
void glRecti( GLint x1, GLint y1, GLint x2, GLint y2 );
void glRects( GLshort x1, GLshort y1, GLshort x2, GLshort y2 );


void glRectdv( const GLdouble *v1, const GLdouble *v2 );
void glRectfv( const GLfloat *v1, const GLfloat *v2 );
void glRectiv( const GLint *v1, const GLint *v2 );
void glRectsv( const GLshort *v1, const GLshort *v2 );


/*
 * Vertex Arrays  (1.1)
 */

void glVertexPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr );
void glNormalPointer( GLenum type, GLsizei stride, const GLvoid *ptr );
void glColorPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr );
void glIndexPointer( GLenum type, GLsizei stride, const GLvoid *ptr );
void glTexCoordPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr );
void glEdgeFlagPointer( GLsizei stride, const GLvoid *ptr );
void glGetPointerv( GLenum pname, GLvoid **params );
void glArrayElement( GLint i );
void glDrawArrays( GLenum mode, GLint first, GLsizei count );
void glDrawElements( GLenum mode, GLsizei count, GLenum type, const GLvoid *indices );
void glInterleavedArrays( GLenum format, GLsizei stride, const GLvoid *pointer );



/*
 * Raster functions
 */


void glPixelMapfv( GLenum map, GLsizei mapsize, const GLfloat *values );
void glPixelMapuiv( GLenum map, GLsizei mapsize, const GLuint *values );
void glPixelMapusv( GLenum map, GLsizei mapsize, const GLushort *values );

void glGetPixelMapfv( GLenum map, GLfloat *values );
void glGetPixelMapuiv( GLenum map, GLuint *values );
void glGetPixelMapusv( GLenum map, GLushort *values );


void glDrawPixels( GLsizei width, GLsizei height,
                                    GLenum format, GLenum type,
                                    const GLvoid *pixels );




/*
 * Texture mapping
 */

void glTexGend( GLenum coord, GLenum pname, GLdouble param );
void glTexGenf( GLenum coord, GLenum pname, GLfloat param );
void glTexGeni( GLenum coord, GLenum pname, GLint param );

void glTexGendv( GLenum coord, GLenum pname, const GLdouble *params );
void glTexGenfv( GLenum coord, GLenum pname, const GLfloat *params );
void glTexGeniv( GLenum coord, GLenum pname, const GLint *params );

void glGetTexGendv( GLenum coord, GLenum pname, GLdouble *params );
void glGetTexGenfv( GLenum coord, GLenum pname, GLfloat *params );
void glGetTexGeniv( GLenum coord, GLenum pname, GLint *params );


void glTexEnvf( GLenum target, GLenum pname, GLfloat param );
void glTexEnvi( GLenum target, GLenum pname, GLint param );

void glTexEnvfv( GLenum target, GLenum pname, const GLfloat *params );
void glTexEnviv( GLenum target, GLenum pname, const GLint *params );

void glGetTexEnvfv( GLenum target, GLenum pname, GLfloat *params );
void glGetTexEnviv( GLenum target, GLenum pname, GLint *params );


void glTexParameterf( GLenum target, GLenum pname, GLfloat param );
void glTexParameteri( GLenum target, GLenum pname, GLint param );

void glTexParameterfv( GLenum target, GLenum pname, const GLfloat *params );
void glTexParameteriv( GLenum target, GLenum pname, const GLint *params );

void glGetTexParameterfv( GLenum target, GLenum pname, GLfloat *params);
void glGetTexParameteriv( GLenum target, GLenum pname, GLint *params );

void glGetTexLevelParameterfv( GLenum target, GLint level, GLenum pname, GLfloat *params );
void glGetTexLevelParameteriv( GLenum target, GLint level, GLenum pname, GLint *params );


void glTexImage1D( GLenum target, GLint level,
                                    GLint internalFormat,
                                    GLsizei width, GLint border,
                                    GLenum format, GLenum type,
                                    const GLvoid *pixels );

void glTexImage2D( GLenum target, GLint level,
                                    GLint internalFormat,
                                    GLsizei width, GLsizei height,
                                    GLint border, GLenum format, GLenum type,
                                    const GLvoid *pixels );

void glGetTexImage( GLenum target, GLint level,
                                     GLenum format, GLenum type,
                                     GLvoid *pixels );


/* 1.1 functions */

void glGenTextures( GLsizei n, GLuint *textures );

void glDeleteTextures( GLsizei n, const GLuint *textures);

void glBindTexture( GLenum target, GLuint texture );

void glPrioritizeTextures( GLsizei n,
                                            const GLuint *textures,
                                            const GLclampf *priorities );

GLboolean glAreTexturesResident( GLsizei n,
                                                  const GLuint *textures,
                                                  GLboolean *residences );

GLboolean glIsTexture( GLuint texture );


void glTexSubImage1D( GLenum target, GLint level,
                                       GLint xoffset,
                                       GLsizei width, GLenum format,
                                       GLenum type, const GLvoid *pixels );


void glTexSubImage2D( GLenum target, GLint level,
                                       GLint xoffset, GLint yoffset,
                                       GLsizei width, GLsizei height,
                                       GLenum format, GLenum type,
                                       const GLvoid *pixels );


void glCopyTexImage1D( GLenum target, GLint level,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei width, GLint border );


void glCopyTexImage2D( GLenum target, GLint level,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei width, GLsizei height,
                                        GLint border );


void glCopyTexSubImage1D( GLenum target, GLint level,
                                           GLint xoffset, GLint x, GLint y,
                                           GLsizei width );


void glCopyTexSubImage2D( GLenum target, GLint level,
                                           GLint xoffset, GLint yoffset,
                                           GLint x, GLint y,
                                           GLsizei width, GLsizei height );


/*
 * Evaluators
 */

void glMap1d( GLenum target, GLdouble u1, GLdouble u2,
                               GLint stride,
                               GLint order, const GLdouble *points );

void glMap2d( GLenum target,
		     GLdouble u1, GLdouble u2, GLint ustride, GLint uorder,
		     GLdouble v1, GLdouble v2, GLint vstride, GLint vorder,
		     const GLdouble *points );

void glGetMapdv( GLenum target, GLenum query, GLdouble *v );
void glGetMapfv( GLenum target, GLenum query, GLfloat *v );
void glGetMapiv( GLenum target, GLenum query, GLint *v );

void glEvalCoord1d( GLdouble u );
void glEvalCoord1f( GLfloat u );

void glEvalCoord1dv( const GLdouble *u );
void glEvalCoord1fv( const GLfloat *u );

void glEvalCoord2d( GLdouble u, GLdouble v );
void glEvalCoord2f( GLfloat u, GLfloat v );

void glEvalCoord2dv( const GLdouble *u );
void glEvalCoord2fv( const GLfloat *u );

void glMapGrid1d( GLint un, GLdouble u1, GLdouble u2 );
void glMapGrid1f( GLint un, GLfloat u1, GLfloat u2 );

void glMapGrid2d( GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2 );
void glMapGrid2f( GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2 );

void glEvalPoint1( GLint i );
void glEvalPoint2( GLint i, GLint j );
void glEvalMesh1( GLenum mode, GLint i1, GLint i2 );
void glEvalMesh2( GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2 );


/*
 * Fog
 */

void glFogiv( GLenum pname, const GLint *params );  // ???


/*
 * Selection and Feedback
 */

void glFeedbackBuffer( GLsizei size, GLenum type, GLfloat *buffer );
void glPassThrough( GLfloat token );



/*
 * OpenGL 1.2
 */

void glDrawRangeElements( GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices );

void glTexImage3D( GLenum target, GLint level,
                                      GLint internalFormat,
                                      GLsizei width, GLsizei height,
                                      GLsizei depth, GLint border,
                                      GLenum format, GLenum type,
                                      const GLvoid *pixels );

void glTexSubImage3D( GLenum target, GLint level,
                                         GLint xoffset, GLint yoffset,
                                         GLint zoffset, GLsizei width,
                                         GLsizei height, GLsizei depth,
                                         GLenum format,
                                         GLenum type, const GLvoid *pixels);

void glCopyTexSubImage3D( GLenum target, GLint level,
                                             GLint xoffset, GLint yoffset,
                                             GLint zoffset, GLint x,
                                             GLint y, GLsizei width,
                                             GLsizei height );



/*
 * GL_ARB_imaging
 */


void glColorTable( GLenum target, GLenum internalformat,
                                    GLsizei width, GLenum format,
                                    GLenum type, const GLvoid *table );

void glColorSubTable( GLenum target,
                                       GLsizei start, GLsizei count,
                                       GLenum format, GLenum type,
                                       const GLvoid *data );

void glColorTableParameteriv(GLenum target, GLenum pname,
                                              const GLint *params);

void glColorTableParameterfv(GLenum target, GLenum pname,
                                              const GLfloat *params);

void glCopyColorSubTable( GLenum target, GLsizei start,
                                           GLint x, GLint y, GLsizei width );

void glCopyColorTable( GLenum target, GLenum internalformat,
                                        GLint x, GLint y, GLsizei width );

void glGetColorTable( GLenum target, GLenum format,
                                       GLenum type, GLvoid *table );

void glGetColorTableParameterfv( GLenum target, GLenum pname, GLfloat *params );
void glGetColorTableParameteriv( GLenum target, GLenum pname, GLint *params );

void glBlendEquation( GLenum mode );

void glBlendColor( GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha );

void glHistogram( GLenum target, GLsizei width, GLenum internalformat, GLboolean sink );

void glResetHistogram( GLenum target );

void glGetHistogram( GLenum target, GLboolean reset,
				      GLenum format, GLenum type,
				      GLvoid *values );

void glGetHistogramParameterfv( GLenum target, GLenum pname, GLfloat *params );

void glGetHistogramParameteriv( GLenum target, GLenum pname, GLint *params );

void glMinmax( GLenum target, GLenum internalformat, GLboolean sink );

void glResetMinmax( GLenum target );

void glGetMinmax( GLenum target, GLboolean reset,
                                   GLenum format, GLenum types,
                                   GLvoid *values );

void glGetMinmaxParameterfv( GLenum target, GLenum pname, GLfloat *params );
void glGetMinmaxParameteriv( GLenum target, GLenum pname, GLint *params );

void glConvolutionFilter1D( GLenum target,
	GLenum internalformat, GLsizei width, GLenum format, GLenum type,
	const GLvoid *image );

void glConvolutionFilter2D( GLenum target,
	GLenum internalformat, GLsizei width, GLsizei height, GLenum format,
	GLenum type, const GLvoid *image );

void glConvolutionParameterf( GLenum target, GLenum pname, GLfloat params );
void glConvolutionParameterfv( GLenum target, GLenum pname, const GLfloat *params );
void glConvolutionParameteri( GLenum target, GLenum pname, GLint params );
void glConvolutionParameteriv( GLenum target, GLenum pname, const GLint *params );

void glCopyConvolutionFilter1D( GLenum target,
	GLenum internalformat, GLint x, GLint y, GLsizei width );

void glCopyConvolutionFilter2D( GLenum target,
	GLenum internalformat, GLint x, GLint y, GLsizei width,
	GLsizei height);

void glGetConvolutionFilter( GLenum target, GLenum format,
	GLenum type, GLvoid *image );

void glGetConvolutionParameterfv( GLenum target, GLenum pname,
	GLfloat *params );

void glGetConvolutionParameteriv( GLenum target, GLenum pname,
	GLint *params );

void glSeparableFilter2D( GLenum target,
	GLenum internalformat, GLsizei width, GLsizei height, GLenum format,
	GLenum type, const GLvoid *row, const GLvoid *column );

void glGetSeparableFilter( GLenum target, GLenum format,
	GLenum type, GLvoid *row, GLvoid *column, GLvoid *span );



/*
 * OpenGL 1.3
 */


void glClientActiveTexture( GLenum texture );

void glCompressedTexImage1D( GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const GLvoid *data );
void glCompressedTexImage2D( GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid *data );
void glCompressedTexImage3D( GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const GLvoid *data );

void glCompressedTexSubImage1D( GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const GLvoid *data );
void glCompressedTexSubImage2D( GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid *data );
void glCompressedTexSubImage3D( GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const GLvoid *data );

void glGetCompressedTexImage( GLenum target, GLint lod, GLvoid *img );

void glMultiTexCoord1d( GLenum target, GLdouble s );
void glMultiTexCoord1dv( GLenum target, const GLdouble *v );
void glMultiTexCoord1f( GLenum target, GLfloat s );
void glMultiTexCoord1fv( GLenum target, const GLfloat *v );
void glMultiTexCoord1i( GLenum target, GLint s );
void glMultiTexCoord1iv( GLenum target, const GLint *v );
void glMultiTexCoord1s( GLenum target, GLshort s );
void glMultiTexCoord1sv( GLenum target, const GLshort *v );
void glMultiTexCoord2dv( GLenum target, const GLdouble *v );
void glMultiTexCoord2f( GLenum target, GLfloat s, GLfloat t );
void glMultiTexCoord2fv( GLenum target, const GLfloat *v );
void glMultiTexCoord2i( GLenum target, GLint s, GLint t );
void glMultiTexCoord2iv( GLenum target, const GLint *v );
void glMultiTexCoord2s( GLenum target, GLshort s, GLshort t );
void glMultiTexCoord2sv( GLenum target, const GLshort *v );
void glMultiTexCoord3d( GLenum target, GLdouble s, GLdouble t, GLdouble r );
void glMultiTexCoord3dv( GLenum target, const GLdouble *v );
void glMultiTexCoord3f( GLenum target, GLfloat s, GLfloat t, GLfloat r );
void glMultiTexCoord3fv( GLenum target, const GLfloat *v );
void glMultiTexCoord3i( GLenum target, GLint s, GLint t, GLint r );
void glMultiTexCoord3iv( GLenum target, const GLint *v );
void glMultiTexCoord3s( GLenum target, GLshort s, GLshort t, GLshort r );
void glMultiTexCoord3sv( GLenum target, const GLshort *v );
void glMultiTexCoord4d( GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q );
void glMultiTexCoord4dv( GLenum target, const GLdouble *v );
void glMultiTexCoord4f( GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q );
void glMultiTexCoord4fv( GLenum target, const GLfloat *v );
void glMultiTexCoord4i( GLenum target, GLint s, GLint t, GLint r, GLint q );
void glMultiTexCoord4iv( GLenum target, const GLint *v );
void glMultiTexCoord4s( GLenum target, GLshort s, GLshort t, GLshort r, GLshort q );
void glMultiTexCoord4sv( GLenum target, const GLshort *v );


void glLoadTransposeMatrixd( const GLdouble m[16] );
void glLoadTransposeMatrixf( const GLfloat m[16] );
void glMultTransposeMatrixd( const GLdouble m[16] );
void glMultTransposeMatrixf( const GLfloat m[16] );
void glSampleCoverage( GLclampf value, GLboolean invert );



/*
 * GL_ARB_multitexture (ARB extension 1 and OpenGL 1.2.1)
 */

void glActiveTextureARB(GLenum texture);
void glClientActiveTextureARB(GLenum texture);
void glMultiTexCoord1dARB(GLenum target, GLdouble s);
void glMultiTexCoord1dvARB(GLenum target, const GLdouble *v);
void glMultiTexCoord1fARB(GLenum target, GLfloat s);
void glMultiTexCoord1fvARB(GLenum target, const GLfloat *v);
void glMultiTexCoord1iARB(GLenum target, GLint s);
void glMultiTexCoord1ivARB(GLenum target, const GLint *v);
void glMultiTexCoord1sARB(GLenum target, GLshort s);
void glMultiTexCoord1svARB(GLenum target, const GLshort *v);
void glMultiTexCoord2dARB(GLenum target, GLdouble s, GLdouble t);
void glMultiTexCoord2dvARB(GLenum target, const GLdouble *v);
void glMultiTexCoord2fARB(GLenum target, GLfloat s, GLfloat t);
void glMultiTexCoord2fvARB(GLenum target, const GLfloat *v);
void glMultiTexCoord2iARB(GLenum target, GLint s, GLint t);
void glMultiTexCoord2ivARB(GLenum target, const GLint *v);
void glMultiTexCoord2sARB(GLenum target, GLshort s, GLshort t);
void glMultiTexCoord2svARB(GLenum target, const GLshort *v);
void glMultiTexCoord3dARB(GLenum target, GLdouble s, GLdouble t, GLdouble r);
void glMultiTexCoord3dvARB(GLenum target, const GLdouble *v);
void glMultiTexCoord3fARB(GLenum target, GLfloat s, GLfloat t, GLfloat r);
void glMultiTexCoord3fvARB(GLenum target, const GLfloat *v);
void glMultiTexCoord3iARB(GLenum target, GLint s, GLint t, GLint r);
void glMultiTexCoord3ivARB(GLenum target, const GLint *v);
void glMultiTexCoord3sARB(GLenum target, GLshort s, GLshort t, GLshort r);
void glMultiTexCoord3svARB(GLenum target, const GLshort *v);
void glMultiTexCoord4dARB(GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
void glMultiTexCoord4dvARB(GLenum target, const GLdouble *v);
void glMultiTexCoord4fARB(GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
void glMultiTexCoord4fvARB(GLenum target, const GLfloat *v);
void glMultiTexCoord4iARB(GLenum target, GLint s, GLint t, GLint r, GLint q);
void glMultiTexCoord4ivARB(GLenum target, const GLint *v);
void glMultiTexCoord4sARB(GLenum target, GLshort s, GLshort t, GLshort r, GLshort q);
void glMultiTexCoord4svARB(GLenum target, const GLshort *v);



void glBlendColor (GLclampf, GLclampf, GLclampf, GLclampf);
void glBlendEquation (GLenum);
void glDrawRangeElements (GLenum, GLuint, GLuint, GLsizei, GLenum, const GLvoid *);
void glColorTable (GLenum, GLenum, GLsizei, GLenum, GLenum, const GLvoid *);
void glColorTableParameterfv (GLenum, GLenum, const GLfloat *);
void glColorTableParameteriv (GLenum, GLenum, const GLint *);
void glCopyColorTable (GLenum, GLenum, GLint, GLint, GLsizei);
void glGetColorTable (GLenum, GLenum, GLenum, GLvoid *);
void glGetColorTableParameterfv (GLenum, GLenum, GLfloat *);
void glGetColorTableParameteriv (GLenum, GLenum, GLint *);
void glColorSubTable (GLenum, GLsizei, GLsizei, GLenum, GLenum, const GLvoid *);
void glCopyColorSubTable (GLenum, GLsizei, GLint, GLint, GLsizei);
void glConvolutionFilter1D (GLenum, GLenum, GLsizei, GLenum, GLenum, const GLvoid *);
void glConvolutionFilter2D (GLenum, GLenum, GLsizei, GLsizei, GLenum, GLenum, const GLvoid *);
void glConvolutionParameterf (GLenum, GLenum, GLfloat);
void glConvolutionParameterfv (GLenum, GLenum, const GLfloat *);
void glConvolutionParameteri (GLenum, GLenum, GLint);
void glConvolutionParameteriv (GLenum, GLenum, const GLint *);
void glCopyConvolutionFilter1D (GLenum, GLenum, GLint, GLint, GLsizei);
void glCopyConvolutionFilter2D (GLenum, GLenum, GLint, GLint, GLsizei, GLsizei);
void glGetConvolutionFilter (GLenum, GLenum, GLenum, GLvoid *);
void glGetConvolutionParameterfv (GLenum, GLenum, GLfloat *);
void glGetConvolutionParameteriv (GLenum, GLenum, GLint *);
void glGetSeparableFilter (GLenum, GLenum, GLenum, GLvoid *, GLvoid *, GLvoid *);
void glSeparableFilter2D (GLenum, GLenum, GLsizei, GLsizei, GLenum, GLenum, const GLvoid *, const GLvoid *);
void glGetHistogram (GLenum, GLboolean, GLenum, GLenum, GLvoid *);
void glGetHistogramParameterfv (GLenum, GLenum, GLfloat *);
void glGetHistogramParameteriv (GLenum, GLenum, GLint *);
void glGetMinmax (GLenum, GLboolean, GLenum, GLenum, GLvoid *);
void glGetMinmaxParameterfv (GLenum, GLenum, GLfloat *);
void glGetMinmaxParameteriv (GLenum, GLenum, GLint *);
void glHistogram (GLenum, GLsizei, GLenum, GLboolean);
void glMinmax (GLenum, GLenum, GLboolean);
void glResetHistogram (GLenum);
void glResetMinmax (GLenum);
void glTexImage3D (GLenum, GLint, GLint, GLsizei, GLsizei, GLsizei, GLint, GLenum, GLenum, const GLvoid *);
void glTexSubImage3D (GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, const GLvoid *);
void glCopyTexSubImage3D (GLenum, GLint, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei);


void glMultiTexCoord1d (GLenum, GLdouble);
void glMultiTexCoord1dv (GLenum, const GLdouble *);
void glMultiTexCoord1fv (GLenum, const GLfloat *);
void glMultiTexCoord1i (GLenum, GLint);
void glMultiTexCoord1iv (GLenum, const GLint *);
void glMultiTexCoord1s (GLenum, GLshort);
void glMultiTexCoord1sv (GLenum, const GLshort *);
void glMultiTexCoord2dv (GLenum, const GLdouble *);
void glMultiTexCoord2f (GLenum, GLfloat, GLfloat);
void glMultiTexCoord2fv (GLenum, const GLfloat *);
void glMultiTexCoord2i (GLenum, GLint, GLint);
void glMultiTexCoord2iv (GLenum, const GLint *);
void glMultiTexCoord2s (GLenum, GLshort, GLshort);
void glMultiTexCoord2sv (GLenum, const GLshort *);
void glMultiTexCoord3d (GLenum, GLdouble, GLdouble, GLdouble);
void glMultiTexCoord3dv (GLenum, const GLdouble *);
void glMultiTexCoord3f (GLenum, GLfloat, GLfloat, GLfloat);
void glMultiTexCoord3fv (GLenum, const GLfloat *);
void glMultiTexCoord3i (GLenum, GLint, GLint, GLint);
void glMultiTexCoord3iv (GLenum, const GLint *);
void glMultiTexCoord3s (GLenum, GLshort, GLshort, GLshort);
void glMultiTexCoord3sv (GLenum, const GLshort *);
void glMultiTexCoord4d (GLenum, GLdouble, GLdouble, GLdouble, GLdouble);
void glMultiTexCoord4dv (GLenum, const GLdouble *);
void glMultiTexCoord4f (GLenum, GLfloat, GLfloat, GLfloat, GLfloat);
void glMultiTexCoord4fv (GLenum, const GLfloat *);
void glMultiTexCoord4i (GLenum, GLint, GLint, GLint, GLint);
void glMultiTexCoord4iv (GLenum, const GLint *);
void glMultiTexCoord4s (GLenum, GLshort, GLshort, GLshort, GLshort);
void glMultiTexCoord4sv (GLenum, const GLshort *);
void glLoadTransposeMatrixf (const GLfloat *);
void glLoadTransposeMatrixd (const GLdouble *);
void glMultTransposeMatrixf (const GLfloat *);
void glMultTransposeMatrixd (const GLdouble *);
void glSampleCoverage (GLclampf, GLboolean);
void glCompressedTexImage3D (GLenum, GLint, GLenum, GLsizei, GLsizei, GLsizei, GLint, GLsizei, const GLvoid *);
void glCompressedTexImage2D (GLenum, GLint, GLenum, GLsizei, GLsizei, GLint, GLsizei, const GLvoid *);
void glCompressedTexImage1D (GLenum, GLint, GLenum, GLsizei, GLint, GLsizei, const GLvoid *);
void glCompressedTexSubImage3D (GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLsizei, const GLvoid *);
void glCompressedTexSubImage2D (GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLsizei, const GLvoid *);
void glCompressedTexSubImage1D (GLenum, GLint, GLint, GLsizei, GLenum, GLsizei, const GLvoid *);
void glGetCompressedTexImage (GLenum, GLint, GLvoid *);


void glBlendFuncSeparate (GLenum, GLenum, GLenum, GLenum);
void glFogCoordf (GLfloat);
void glFogCoordfv (const GLfloat *);
void glFogCoordd (GLdouble);
void glFogCoorddv (const GLdouble *);
void glFogCoordPointer (GLenum, GLsizei, const GLvoid *);
void glMultiDrawArrays (GLenum, GLint *, GLsizei *, GLsizei);
void glMultiDrawElements (GLenum, const GLsizei *, GLenum, const GLvoid* *, GLsizei);
void glSecondaryColorPointer (GLint, GLenum, GLsizei, const GLvoid *);
void glWindowPos2d (GLdouble, GLdouble);
void glWindowPos2dv (const GLdouble *);
void glWindowPos2f (GLfloat, GLfloat);
void glWindowPos2fv (const GLfloat *);
void glWindowPos2i (GLint, GLint);
void glWindowPos2iv (const GLint *);
void glWindowPos2s (GLshort, GLshort);
void glWindowPos2sv (const GLshort *);
void glWindowPos3d (GLdouble, GLdouble, GLdouble);
void glWindowPos3dv (const GLdouble *);
void glWindowPos3f (GLfloat, GLfloat, GLfloat);
void glWindowPos3fv (const GLfloat *);
void glWindowPos3i (GLint, GLint, GLint);
void glWindowPos3iv (const GLint *);
void glWindowPos3s (GLshort, GLshort, GLshort);
void glWindowPos3sv (const GLshort *);


void glGenQueries (GLsizei, GLuint *);
void glDeleteQueries (GLsizei, const GLuint *);
GLboolean glIsQuery (GLuint);
void glBeginQuery (GLenum, GLuint);
void glEndQuery (GLenum);
void glGetQueryiv (GLenum, GLenum, GLint *);
void glGetQueryObjectiv (GLuint, GLenum, GLint *);
void glGetQueryObjectuiv (GLuint, GLenum, GLuint *);
void glBindBuffer (GLenum, GLuint);
void glDeleteBuffers (GLsizei, const GLuint *);
void glGenBuffers (GLsizei, GLuint *);
GLboolean glIsBuffer (GLuint);
void glBufferData (GLenum, GLsizeiptr, const GLvoid *, GLenum);
void glBufferSubData (GLenum, GLintptr, GLsizeiptr, const GLvoid *);
void glGetBufferSubData (GLenum, GLintptr, GLsizeiptr, GLvoid *);
GLvoid* glMapBuffer (GLenum, GLenum);
GLboolean glUnmapBuffer (GLenum);
void glGetBufferParameteriv (GLenum, GLenum, GLint *);
void glGetBufferPointerv (GLenum, GLenum, GLvoid* *);


void glBlendEquationSeparate (GLenum, GLenum);
void glDrawBuffers (GLsizei, const GLenum *);
void glStencilOpSeparate (GLenum, GLenum, GLenum, GLenum);
void glStencilFuncSeparate (GLenum, GLenum, GLint, GLuint);
void glStencilMaskSeparate (GLenum, GLuint);
void glDisableVertexAttribArray (GLuint);
void glEnableVertexAttribArray (GLuint);
void glGetActiveAttrib (GLuint, GLuint, GLsizei, GLsizei *, GLint *, GLenum *, GLchar *);
void glGetActiveUniform (GLuint, GLuint, GLsizei, GLsizei *, GLint *, GLenum *, GLchar *);
void glGetAttachedShaders (GLuint, GLsizei, GLsizei *, GLuint *);
GLint glGetAttribLocation (GLuint, const GLchar *);
void glGetProgramInfoLog (GLuint, GLsizei, GLsizei *, GLchar *);
void glGetShaderiv (GLuint, GLenum, GLint *);
void glGetShaderInfoLog (GLuint, GLsizei, GLsizei *, GLchar *);
void glGetShaderSource (GLuint, GLsizei, GLsizei *, GLchar *);
GLint glGetUniformLocation (GLuint, const GLchar *);
void glGetUniformfv (GLuint, GLint, GLfloat *);
void glGetUniformiv (GLuint, GLint, GLint *);
void glGetVertexAttribdv (GLuint, GLenum, GLdouble *);
void glGetVertexAttribfv (GLuint, GLenum, GLfloat *);
void glGetVertexAttribiv (GLuint, GLenum, GLint *);
void glGetVertexAttribPointerv (GLuint, GLenum, GLvoid* *);
void glUniform1fv (GLint, GLsizei, const GLfloat *);
void glUniform2fv (GLint, GLsizei, const GLfloat *);
void glUniform3fv (GLint, GLsizei, const GLfloat *);
void glUniform4fv (GLint, GLsizei, const GLfloat *);
void glUniform1iv (GLint, GLsizei, const GLint *);
void glUniform2iv (GLint, GLsizei, const GLint *);
void glUniform1iv (GLint, GLsizei, const GLint *);
void glUniform2iv (GLint, GLsizei, const GLint *);
void glUniform3iv (GLint, GLsizei, const GLint *);
void glUniform4iv (GLint, GLsizei, const GLint *);
void glUniformMatrix2fv (GLint, GLsizei, GLboolean, const GLfloat *);
void glUniformMatrix3fv (GLint, GLsizei, GLboolean, const GLfloat *);
void glUniformMatrix4fv (GLint, GLsizei, GLboolean, const GLfloat *);
void glValidateProgram (GLuint);
void glVertexAttrib1d (GLuint, GLdouble);
void glVertexAttrib1dv (GLuint, const GLdouble *);
void glVertexAttrib1f (GLuint, GLfloat);
void glVertexAttrib1fv (GLuint, const GLfloat *);
void glVertexAttrib1s (GLuint, GLshort);
void glVertexAttrib1sv (GLuint, const GLshort *);
void glVertexAttrib2d (GLuint, GLdouble, GLdouble);
void glVertexAttrib2dv (GLuint, const GLdouble *);
void glVertexAttrib2f (GLuint, GLfloat, GLfloat);
void glVertexAttrib2fv (GLuint, const GLfloat *);
void glVertexAttrib2s (GLuint, GLshort, GLshort);
void glVertexAttrib2sv (GLuint, const GLshort *);
void glVertexAttrib3d (GLuint, GLdouble, GLdouble, GLdouble);
void glVertexAttrib3dv (GLuint, const GLdouble *);
void glVertexAttrib3f (GLuint, GLfloat, GLfloat, GLfloat);
void glVertexAttrib3fv (GLuint, const GLfloat *);
void glVertexAttrib3s (GLuint, GLshort, GLshort, GLshort);
void glVertexAttrib3sv (GLuint, const GLshort *);
void glVertexAttrib4Nbv (GLuint, const GLbyte *);
void glVertexAttrib4Niv (GLuint, const GLint *);
void glVertexAttrib4Nsv (GLuint, const GLshort *);
void glVertexAttrib4Nub (GLuint, GLubyte, GLubyte, GLubyte, GLubyte);
void glVertexAttrib4Nubv (GLuint, const GLubyte *);
void glVertexAttrib4Nuiv (GLuint, const GLuint *);
void glVertexAttrib4Nusv (GLuint, const GLushort *);
void glVertexAttrib4bv (GLuint, const GLbyte *);
void glVertexAttrib4d (GLuint, GLdouble, GLdouble, GLdouble, GLdouble);
void glVertexAttrib4dv (GLuint, const GLdouble *);
void glVertexAttrib4f (GLuint, GLfloat, GLfloat, GLfloat, GLfloat);
void glVertexAttrib4fv (GLuint, const GLfloat *);
void glVertexAttrib4iv (GLuint, const GLint *);
void glVertexAttrib4s (GLuint, GLshort, GLshort, GLshort, GLshort);
void glVertexAttrib4sv (GLuint, const GLshort *);
void glVertexAttrib4ubv (GLuint, const GLubyte *);
void glVertexAttrib4uiv (GLuint, const GLuint *);
void glVertexAttrib4usv (GLuint, const GLushort *);
void glVertexAttribPointer (GLuint, GLint, GLenum, GLboolean, GLsizei, const GLvoid *);
%endif /* GL_GLEXT_PROTOTYPES */

#endif
/* }}} */
/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
