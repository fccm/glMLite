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

#if defined(__APPLE__) && !defined (VMDMESA)
  #include <OpenGL/glu.h> 
  #include <OpenGL/gl.h>
#else
  #include <GL/glu.h>
  #include <GL/gl.h>
#endif

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/callback.h>

#include <caml/bigarray.h>

#include <string.h>

#define MESA_DEBUG

#define ret  return Val_unit;
#define t_val  CAMLprim value

#include "gl.wrap.h"


t_val ml_gluperspective( value fovy, value aspect, value zNear, value zFar )
          { gluPerspective( Double_val(fovy), Double_val(aspect), Double_val(zNear), Double_val(zFar)); ret }

t_val ml_glulookat_native(
               value eyeX, value eyeY, value eyeZ,
               value centerX, value centerY, value centerZ,
               value upX, value upY, value upZ )
          { gluLookAt( Double_val(eyeX), Double_val(eyeY), Double_val(eyeZ),
                       Double_val(centerX), Double_val(centerY), Double_val(centerZ),
                       Double_val(upX), Double_val(upY), Double_val(upZ) ); ret }

t_val ml_glulookat_bytecode(value * argv, int argn)
          { return ml_glulookat_native( argv[0], argv[1], argv[2],
                                        argv[3], argv[4], argv[5],
                                        argv[6], argv[7], argv[8] ); }

t_val ml_gluortho2d( value left, value right, value bottom, value top )
          { gluOrtho2D( Double_val(left), Double_val(right), Double_val(bottom), Double_val(top) ); ret }


t_val ml_gluerrorstring( value _gl_error ) {
    CAMLparam1( _gl_error );
    GLenum gl_error;
#include "enums/gl_error.inc.c"
    const GLubyte *err_str = gluErrorString( gl_error );

    CAMLreturn( caml_copy_string( (char *)err_str ));
}

static const GLenum tess_error_table[] = {
    GLU_TESS_MISSING_BEGIN_POLYGON,
    GLU_TESS_MISSING_BEGIN_CONTOUR,
    GLU_TESS_MISSING_END_POLYGON,
    GLU_TESS_MISSING_END_CONTOUR,
    GLU_TESS_COORD_TOO_LARGE,
    GLU_TESS_NEED_COMBINE_CALLBACK,
    GLU_OUT_OF_MEMORY,
    GLU_TESS_ERROR7,
    GLU_TESS_ERROR8,
};

t_val ml_glutesserrorstring( value tess_error )
{
    CAMLparam1( tess_error );
    const GLubyte *err_str = gluErrorString( tess_error_table[Long_val(tess_error)] );
    CAMLreturn( caml_copy_string( (char *)err_str ));
}


t_val ml_glupickmatrix( value x, value y, value width, value height, value ml_viewport )
{
    GLint viewport[4];
    viewport[0] = Int_val(Field(ml_viewport,0));
    viewport[1] = Int_val(Field(ml_viewport,1));
    viewport[2] = Int_val(Field(ml_viewport,2));
    viewport[3] = Int_val(Field(ml_viewport,3));
    gluPickMatrix(Double_val(x), Double_val(y), Double_val(width), Double_val(height), viewport); ret
}


t_val ml_glugetstring( value _glu_desc )
{
    const GLubyte * info;
    GLenum glu_desc;
    switch (Int_val(_glu_desc)) {
        case 0: glu_desc = GLU_VERSION; break;
        case 1: glu_desc = GLU_EXTENSIONS; break;
    }
    info = gluGetString( glu_desc );
    return caml_copy_string( (char *) info);
}


t_val ml_glubuild2dmipmaps_native(
        /* GLenum target, */
        value _internal_format,
        value width, value height,
        value _pixel_data_format,
        value _pixel_data_type,
        value pixel_data )
{
    GLint st;
    GLenum target = GL_TEXTURE_2D;
    GLenum pixel_data_format;
    GLenum pixel_data_type;
    GLint internal_format;
#include "enums/pixel_data_format.inc.c"
#include "enums/pixel_data_type.inc.c"
#include "enums/internal_format.inc.c"

    st = gluBuild2DMipmaps(
            target,
            internal_format,
            Int_val(width), Int_val(height),
            pixel_data_format, pixel_data_type,
            //(void *) pixel_data );
            (void *) Data_bigarray_val(pixel_data) );

    if (st != 0) caml_failwith("gluBuild2DMipmaps");

    return Val_unit;
}
t_val ml_glubuild2dmipmaps_bytecode(value * argv, int argn)
          { return ml_glubuild2dmipmaps_native( argv[0], argv[1], argv[2],
                                                argv[3], argv[4], argv[5] ); }


t_val ml_glubuild1dmipmaps(
        /* GLenum target, */
        value _internal_format,
        value width,
        value _pixel_data_format,
        value _pixel_data_type,
        value pixel_data )
{
    GLint st;
    GLenum target = GL_TEXTURE_1D;
    GLenum pixel_data_format;
    GLenum pixel_data_type;
    GLint internal_format;
#include "enums/pixel_data_format.inc.c"
#include "enums/pixel_data_type.inc.c"
#include "enums/internal_format.inc.c"

    st = gluBuild1DMipmaps(
            target,
            internal_format,
            Int_val(width),
            pixel_data_format, pixel_data_type,
            //(void *) pixel_data );
            (void *) Data_bigarray_val(pixel_data) );

    if (st != 0) caml_failwith("gluBuild1DMipmaps");

    return Val_unit;
}


t_val ml_glubuild3dmipmaps_native(
        /* GLenum target, */
        value _internal_format,
        value width, value height, value depth,
        value _pixel_data_format,
        value _pixel_data_type,
        value pixel_data )
{
    GLint st;
    GLenum target = GL_TEXTURE_3D;
    GLenum pixel_data_format;
    GLenum pixel_data_type;
    GLint internal_format;
#include "enums/pixel_data_format.inc.c"
#include "enums/pixel_data_type.inc.c"
#include "enums/internal_format.inc.c"

    st = gluBuild3DMipmaps(
            target,
            internal_format,
            Int_val(width), Int_val(height), Int_val(depth),
            pixel_data_format, pixel_data_type,
            //(void *) pixel_data );
            (void *) Data_bigarray_val(pixel_data) );

    if (st != 0) caml_failwith("gluBuild3DMipmaps");

    return Val_unit;
}
t_val ml_glubuild3dmipmaps_bytecode(value * argv, int argn)
          { return ml_glubuild3dmipmaps_native( argv[0], argv[1], argv[2], argv[3],
                                                argv[4], argv[5], argv[6] ); }





t_val ml_gluunproject_native( value x, value y, value z, value ml_model, value ml_proj, value ml_view )
{
    CAMLparam5(x, y, z, ml_model, ml_proj);
    CAMLxparam1(ml_view);
    CAMLlocal1( tuple );

    GLdouble model[16];
    GLdouble proj[16];
    GLint view[4];

    GLdouble mx, my, mz;

    view[0] = Int_val(Field(ml_view, 0));
    view[1] = Int_val(Field(ml_view, 1));
    view[2] = Int_val(Field(ml_view, 2));
    view[3] = Int_val(Field(ml_view, 3));

    {
      proj[0] = Double_field(Field(ml_proj, 0), 0);
      proj[1] = Double_field(Field(ml_proj, 0), 1);
      proj[2] = Double_field(Field(ml_proj, 0), 2);
      proj[3] = Double_field(Field(ml_proj, 0), 3);

      proj[4] = Double_field(Field(ml_proj, 1), 0);
      proj[5] = Double_field(Field(ml_proj, 1), 1);
      proj[6] = Double_field(Field(ml_proj, 1), 2);
      proj[7] = Double_field(Field(ml_proj, 1), 3);

      proj[8]  = Double_field(Field(ml_proj, 2), 0);
      proj[9]  = Double_field(Field(ml_proj, 2), 1);
      proj[10] = Double_field(Field(ml_proj, 2), 2);
      proj[11] = Double_field(Field(ml_proj, 2), 3);

      proj[12] = Double_field(Field(ml_proj, 3), 0);
      proj[13] = Double_field(Field(ml_proj, 3), 1);
      proj[14] = Double_field(Field(ml_proj, 3), 2);
      proj[15] = Double_field(Field(ml_proj, 3), 3);
    }

    {
      model[0] = Double_field(Field(ml_model, 0), 0);
      model[1] = Double_field(Field(ml_model, 0), 1);
      model[2] = Double_field(Field(ml_model, 0), 2);
      model[3] = Double_field(Field(ml_model, 0), 3);

      model[4] = Double_field(Field(ml_model, 1), 0);
      model[5] = Double_field(Field(ml_model, 1), 1);
      model[6] = Double_field(Field(ml_model, 1), 2);
      model[7] = Double_field(Field(ml_model, 1), 3);

      model[8]  = Double_field(Field(ml_model, 2), 0);
      model[9]  = Double_field(Field(ml_model, 2), 1);
      model[10] = Double_field(Field(ml_model, 2), 2);
      model[11] = Double_field(Field(ml_model, 2), 3);

      model[12] = Double_field(Field(ml_model, 3), 0);
      model[13] = Double_field(Field(ml_model, 3), 1);
      model[14] = Double_field(Field(ml_model, 3), 2);
      model[15] = Double_field(Field(ml_model, 3), 3);
    }

    gluUnProject( Double_val(x), Double_val(y), Double_val(z),
                  model, proj, view, &mx, &my, &mz);

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(mx) );
    Store_field( tuple, 1, caml_copy_double(my) );
    Store_field( tuple, 2, caml_copy_double(mz) );

    CAMLreturn( tuple );
}
t_val ml_gluunproject_bytecode(value * argv, int argn)
          { return ml_gluunproject_native( argv[0], argv[1], argv[2],
                                           argv[3], argv[4], argv[5] ); }



t_val ml_gluunproject_flat_native( value x, value y, value z, value model, value proj, value ml_view )
{
    CAMLparam5(x, y, z, model, proj);
    CAMLxparam1(ml_view);
    CAMLlocal1(tuple);

    GLdouble mx, my, mz;
    GLint view[4];
    int len;

    len = Wosize_val(model) / Double_wosize;
    if (len != 16) caml_invalid_argument("gluUnProjectFlat: array length should be 16");

    len = Wosize_val(proj) / Double_wosize;
    if (len != 16) caml_invalid_argument("gluUnProjectFlat: array length should be 16");

    view[0] = Int_val(Field(ml_view, 0));
    view[1] = Int_val(Field(ml_view, 1));
    view[2] = Int_val(Field(ml_view, 2));
    view[3] = Int_val(Field(ml_view, 3));

    gluUnProject( Double_val(x), Double_val(y), Double_val(z),
                  (double *)model, (double *)proj, view,
                  &mx, &my, &mz);

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(mx) );
    Store_field( tuple, 1, caml_copy_double(my) );
    Store_field( tuple, 2, caml_copy_double(mz) );

    CAMLreturn( tuple );
}
t_val ml_gluunproject_flat_bytecode(value * argv, int argn)
          { return ml_gluunproject_flat_native( argv[0], argv[1], argv[2],
                                                argv[3], argv[4], argv[5] ); }



t_val ml_util_gluunproject( value x, value y )
{
    CAMLparam2( x, y );
    CAMLlocal1( tuple );

    GLdouble modelview[16];
    GLdouble proj[16];
    GLint viewport[4];
    GLdouble mx, my, mz;

    glGetDoublev(GL_MODELVIEW_MATRIX, modelview);
    glGetDoublev(GL_PROJECTION_MATRIX, proj);
    glGetIntegerv(GL_VIEWPORT, viewport);

    gluUnProject( Long_val(x), viewport[3] - Long_val(y), 0.0f,
                  modelview, proj, viewport, &mx, &my, &mz);

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(mx) );
    Store_field( tuple, 1, caml_copy_double(my) );
    Store_field( tuple, 2, caml_copy_double(mz) );

    CAMLreturn( tuple );
}


t_val ml_gluunproject_pixel( value x, value y )
{
    CAMLparam2( x, y );
    CAMLlocal1( tuple );

    GLdouble modelview[16];
    GLdouble projection[16];
    GLint viewport[4];
    GLint winX, winY;
    GLfloat winZ;
    GLdouble mx, my, mz;

    glGetDoublev( GL_MODELVIEW_MATRIX, modelview );
    glGetDoublev( GL_PROJECTION_MATRIX, projection );
    glGetIntegerv( GL_VIEWPORT, viewport );

    winX = Long_val(x);
    winY =  (viewport[3] - Long_val(y));
    glReadPixels( winX, winY, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &winZ );

    gluUnProject( (GLdouble)winX, (GLdouble)winY, (GLdouble)winZ, modelview, projection, viewport, &mx, &my, &mz);

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(mx) );
    Store_field( tuple, 1, caml_copy_double(my) );
    Store_field( tuple, 2, caml_copy_double(mz) );

    CAMLreturn( tuple );
}


t_val ml_gluproject_native( value x, value y, value z, value ml_model, value ml_proj, value ml_view )
{
    CAMLparam5(x, y, z, ml_model, ml_proj);
    CAMLxparam1(ml_view);
    CAMLlocal1( tuple );

    GLdouble model[16];
    GLdouble proj[16];
    GLint view[4];

    GLint st;

    GLdouble mx, my, mz;

    view[0] = Int_val(Field(ml_view, 0));
    view[1] = Int_val(Field(ml_view, 1));
    view[2] = Int_val(Field(ml_view, 2));
    view[3] = Int_val(Field(ml_view, 3));

    {
      proj[0] = Double_field(Field(ml_proj, 0), 0);
      proj[1] = Double_field(Field(ml_proj, 0), 1);
      proj[2] = Double_field(Field(ml_proj, 0), 2);
      proj[3] = Double_field(Field(ml_proj, 0), 3);

      proj[4] = Double_field(Field(ml_proj, 1), 0);
      proj[5] = Double_field(Field(ml_proj, 1), 1);
      proj[6] = Double_field(Field(ml_proj, 1), 2);
      proj[7] = Double_field(Field(ml_proj, 1), 3);

      proj[8]  = Double_field(Field(ml_proj, 2), 0);
      proj[9]  = Double_field(Field(ml_proj, 2), 1);
      proj[10] = Double_field(Field(ml_proj, 2), 2);
      proj[11] = Double_field(Field(ml_proj, 2), 3);

      proj[12] = Double_field(Field(ml_proj, 3), 0);
      proj[13] = Double_field(Field(ml_proj, 3), 1);
      proj[14] = Double_field(Field(ml_proj, 3), 2);
      proj[15] = Double_field(Field(ml_proj, 3), 3);
    }

    {
      model[0] = Double_field(Field(ml_model, 0), 0);
      model[1] = Double_field(Field(ml_model, 0), 1);
      model[2] = Double_field(Field(ml_model, 0), 2);
      model[3] = Double_field(Field(ml_model, 0), 3);

      model[4] = Double_field(Field(ml_model, 1), 0);
      model[5] = Double_field(Field(ml_model, 1), 1);
      model[6] = Double_field(Field(ml_model, 1), 2);
      model[7] = Double_field(Field(ml_model, 1), 3);

      model[8]  = Double_field(Field(ml_model, 2), 0);
      model[9]  = Double_field(Field(ml_model, 2), 1);
      model[10] = Double_field(Field(ml_model, 2), 2);
      model[11] = Double_field(Field(ml_model, 2), 3);

      model[12] = Double_field(Field(ml_model, 3), 0);
      model[13] = Double_field(Field(ml_model, 3), 1);
      model[14] = Double_field(Field(ml_model, 3), 2);
      model[15] = Double_field(Field(ml_model, 3), 3);
    }

    st = gluProject( Double_val(x), Double_val(y), Double_val(z),
                     model, proj, view, &mx, &my, &mz);

    if (st == GLU_FALSE) caml_failwith("gluProject");

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(mx) );
    Store_field( tuple, 1, caml_copy_double(my) );
    Store_field( tuple, 2, caml_copy_double(mz) );

    CAMLreturn( tuple );
}
t_val ml_gluproject_bytecode(value * argv, int argn)
          { return ml_gluproject_native( argv[0], argv[1], argv[2],
                                         argv[3], argv[4], argv[5] ); }


t_val ml_gluproject_flat_native( value x, value y, value z, value model, value proj, value ml_view )
{
    CAMLparam5(x, y, z, model, proj);
    CAMLxparam1(ml_view);
    CAMLlocal1(tuple);

    GLdouble mx, my, mz;
    GLint view[4];
    int len;
    GLint st;

    len = Wosize_val(model) / Double_wosize;
    if (len != 16) caml_invalid_argument("gluProjectFlat: array length should be 16");

    len = Wosize_val(proj) / Double_wosize;
    if (len != 16) caml_invalid_argument("gluProjectFlat: array length should be 16");

    view[0] = Int_val(Field(ml_view, 0));
    view[1] = Int_val(Field(ml_view, 1));
    view[2] = Int_val(Field(ml_view, 2));
    view[3] = Int_val(Field(ml_view, 3));

    st = gluProject( Double_val(x), Double_val(y), Double_val(z),
                     (double *)model, (double *)proj, view,
                     &mx, &my, &mz);

    if (st == GLU_FALSE) caml_failwith("gluProject");

    tuple = caml_alloc(3, 0);

    Store_field( tuple, 0, caml_copy_double(mx) );
    Store_field( tuple, 1, caml_copy_double(my) );
    Store_field( tuple, 2, caml_copy_double(mz) );

    CAMLreturn( tuple );
}
t_val ml_gluproject_flat_bytecode(value * argv, int argn)
          { return ml_gluproject_flat_native( argv[0], argv[1], argv[2],
                                              argv[3], argv[4], argv[5] ); }


t_val ml_gluproject_util( value objX, value objY, value objZ )
{
    CAMLparam3( objX, objY, objZ );
    CAMLlocal1( tuple );

    GLdouble modelview[16];
    GLdouble projection[16];
    GLint viewport[4];
    GLdouble winX, winY, winZ;
    GLint st;

    glGetDoublev( GL_MODELVIEW_MATRIX, modelview );
    glGetDoublev( GL_PROJECTION_MATRIX, projection );
    glGetIntegerv( GL_VIEWPORT, viewport );

    st = gluProject(
            Double_val(objX), Double_val(objY), Double_val(objZ),
            modelview, projection, viewport,
            &winX, &winY, &winZ );

    if (st == GLU_FALSE) {
        caml_failwith("gluProject");
    }
    tuple = caml_alloc(3, 0);
    Store_field( tuple, 0, caml_copy_double(winX) );
    Store_field( tuple, 1, caml_copy_double(winY) );
    Store_field( tuple, 2, caml_copy_double(winZ) );
    CAMLreturn( tuple );
}



/* Quadrics */

#define Val_gluquadric(q) ((value) q)
#define Gluquadric_val(v) ((GLUquadric *) v)

t_val ml_glunewquadric( value unit )
{
    GLUquadric *quadric;
    quadric = gluNewQuadric();
    if (quadric == 0) caml_failwith("gluNewQuadric");
    return Val_gluquadric(quadric);
}

t_val ml_gludeletequadric( value quad )
{
    gluDeleteQuadric( Gluquadric_val(quad) );
    return Val_unit;
}

t_val ml_gluquadricdrawstyle( value quad, value ml_draw )
{
    GLenum draw;
    switch (Int_val(ml_draw))
    {
        case 0: draw = GLU_POINT; break;
        case 1: draw = GLU_LINE; break;
        case 2: draw = GLU_FILL; break;
        case 3: draw = GLU_SILHOUETTE; break;
        default: caml_failwith("gluQuadricDrawStyle");
    }
    gluQuadricDrawStyle( Gluquadric_val(quad), draw );
    return Val_unit;
}

t_val ml_gluquadrictexture( value quad, value texture )
{
    gluQuadricTexture( Gluquadric_val(quad), Bool_val(texture) );
    return Val_unit;
}

t_val ml_glusphere( value quad, value radius, value slices, value stacks )
{
    gluSphere( Gluquadric_val(quad), Double_val(radius), Int_val(slices), Int_val(stacks) );
    return Val_unit;
}

t_val ml_glucylinder_native( value quad, value base, value top, value height, value slices, value stacks )
{
    gluCylinder( Gluquadric_val(quad), Double_val(base), Double_val(top), Double_val(height),
                 Int_val(slices), Int_val(stacks) );
    return Val_unit;
}
t_val ml_glucylinder_bytecode(value * argv, int argn)
{
    return ml_glucylinder_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5] );
}


t_val ml_gludisk( value quad, value inner, value outer, value slices, value loops )
{
    gluDisk( Gluquadric_val(quad), Double_val(inner), Double_val(outer), Int_val(slices), Int_val(loops) );
    return Val_unit;
}

t_val ml_glupartialdisk_native( value quad, value inner, value outer, value slices, value loops, value start, value sweep )
{
    gluPartialDisk( Gluquadric_val(quad), Double_val(inner), Double_val(outer),
                    Int_val(slices), Int_val(loops), Double_val(start), Double_val(sweep) );
    return Val_unit;
}
t_val ml_glupartialdisk_bytecode(value * argv, int argn)
{
    return ml_glupartialdisk_native( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6] );
}

t_val ml_gluquadricorientation( value quad, value ml_orientation )
{
    GLenum orientation;
    switch (Int_val(ml_orientation))
    {
        case 0: orientation = GLU_OUTSIDE; break;
        case 1: orientation = GLU_INSIDE; break;
    }
    gluQuadricOrientation( Gluquadric_val(quad), orientation );
    return Val_unit;
}

t_val ml_gluquadricnormals( value quad, value ml_normal )
{
    GLenum normal;
    switch (Int_val(ml_normal))
    {
        case 0: normal = GLU_NONE; break;
        case 1: normal = GLU_FLAT; break;
        case 2: normal = GLU_SMOOTH; break;
    }
    gluQuadricNormals( Gluquadric_val(quad), normal );
    return Val_unit;
}




/* Tesselation */

t_val ml_glunewtess( value unit ) { return (value) gluNewTess(); }

t_val ml_glubeginpolygon( value tess ) { gluBeginPolygon( (GLUtesselator *) tess ); ret }
t_val ml_gluendpolygon( value tess ) { gluEndPolygon( (GLUtesselator *) tess ); ret }

t_val ml_glutessbegincontour( value tess ) { gluTessBeginContour( (GLUtesselator *) tess ); ret }
t_val ml_glutessendcontour( value tess ) { gluTessEndContour( (GLUtesselator *) tess ); ret }

t_val ml_glutessnormal( value tess, value x, value y, value z )
{
    gluTessNormal( (GLUtesselator *)tess, Double_val(x), Double_val(y), Double_val(z));
    return Val_unit;
}

t_val ml_glugettesswindingrule( value tess, value _winding )
{
    GLdouble winding;
    switch (Int_val(_winding)) {
        case 0: winding = GLU_TESS_WINDING_ODD; break;
        case 1: winding = GLU_TESS_WINDING_NONZERO; break;
        case 2: winding = GLU_TESS_WINDING_POSITIVE; break;
        case 3: winding = GLU_TESS_WINDING_NEGATIVE; break;
        case 4: winding = GLU_TESS_WINDING_ABS_GEQ_TWO; break;
    }
    gluTessProperty( (GLUtesselator *)tess, GLU_TESS_WINDING_RULE, winding );
    return Val_unit;
}

t_val ml_glugettessboundaryonly( value tess, value boundary_only )
{
    gluTessProperty( (GLUtesselator *)tess, GLU_TESS_BOUNDARY_ONLY, Int_val(boundary_only) );
    return Val_unit;
}

t_val ml_glugettesstolerance( value tess, value tolerance )
{
    gluTessProperty( (GLUtesselator *)tess, GLU_TESS_TOLERANCE, Double_val(tolerance) );
    return Val_unit;
}


t_val ml_glunextcontour( value tess, value contour )
{
    GLenum t;
    switch (Int_val(contour))
    {
        case 0: t = GLU_CW; break;
        case 1: t = GLU_CCW; break;
        case 2: t = GLU_INTERIOR; break;
        case 3: t = GLU_EXTERIOR; break;
        case 4: t = GLU_UNKNOWN; break;
    }
    gluNextContour( (GLUtesselator *) tess, t );
    return Val_unit;
}


/* {{{ chunk pool */

#define CHUNK_SIZE 32

typedef struct chunk_block
{
    struct chunk_block *next;
    int n;
    GLdouble pos[CHUNK_SIZE][3];
} chunk_block;

static chunk_block *chunk_list = NULL;

GLdouble *push_vertex( GLdouble * coords )
{
    GLdouble *ptr;
    if (chunk_list == NULL || chunk_list->n >= CHUNK_SIZE) {
        chunk_block *tail = chunk_list;
        chunk_list = (chunk_block*)malloc(sizeof(chunk_block));
        chunk_list->next = tail;
        chunk_list->n = 0;
    }
    ptr = chunk_list->pos[chunk_list->n++];
    ptr = memcpy (ptr, coords, sizeof(GLdouble) * 3);
    return ptr;
}
GLdouble *_push_vertex( GLdouble x, GLdouble y, GLdouble z )
{
    GLdouble ptr[3];
    ptr[0] = x;
    ptr[1] = y;
    ptr[2] = z;
    return push_vertex( ptr );
}

void free_chunk_list()
{
    while (chunk_list != NULL) {
        chunk_block *next = chunk_list->next;
        free(chunk_list);
        chunk_list = next;
    }
    chunk_list = NULL;
}

/* }}} */
/* {{{ tess locations list */

typedef struct _tess_vertex {
    GLdouble loc[3];
    void * next;
} tess_vertex;

tess_vertex * tess_v_list = NULL;

GLdouble * tess_v_push( value x, value y, value z )
{
    tess_vertex *cons;
    cons = malloc(sizeof(tess_vertex));
    cons->loc[0] = (GLdouble) Double_val(x);
    cons->loc[1] = (GLdouble) Double_val(y);
    cons->loc[2] = (GLdouble) Double_val(z);
    cons->next = tess_v_list;
    tess_v_list = cons;
    return cons->loc;
}

void tess_v_free()
{
    while ( tess_v_list != NULL )
    {
        tess_vertex *tmp;
        tmp = tess_v_list;
        tess_v_list = tmp->next;
        free( tmp );
    }
    tess_v_list = NULL;
}
/* }}} */

t_val ml_glutessvertex( value tess, value x, value y, value z )
{
    GLdouble *loc;
    loc = tess_v_push( x, y, z );
    gluTessVertex( (GLUtesselator *) tess, loc, (GLvoid *)loc );
    return Val_unit;
}

t_val ml_glutessbeginpolygon_data( value tess, value data ) { gluTessBeginPolygon( (GLUtesselator *) tess, (GLvoid*) data ); ret }
t_val ml_glutessbeginpolygon( value tess ) { gluTessBeginPolygon( (GLUtesselator *) tess, NULL ); ret }

t_val ml_glutessendpolygon( value tess )
{
    gluTessEndPolygon( (GLUtesselator *) tess );
    tess_v_free();
    return Val_unit;
}


// {{{ gluTesselate 

CAMLprim value
tesselate_points( value tess, value ml_point_array )
{
    CAMLparam1( ml_point_array );

    GLUtesselator * tobj = (GLUtesselator *) tess;

    GLdouble *tri;

    int i, len;
    len = Wosize_val(ml_point_array);

    tri = malloc( sizeof(GLdouble) * 3 * len);

    gluTessBeginPolygon(tobj, NULL);
      gluTessBeginContour(tobj);

        for (i=0; i < len; i++)
        {
            GLdouble *location;

            tri[3*i + 0] = Double_val(Field(Field(ml_point_array, i), 0));
            tri[3*i + 1] = Double_val(Field(Field(ml_point_array, i), 1));
            tri[3*i + 2] = Double_val(Field(Field(ml_point_array, i), 2));

            location = &tri[3*i];
            gluTessVertex( (GLUtesselator*) tess,
                           location,
                           (GLvoid*) location );
        }

      gluTessEndContour(tobj);
    gluTessEndPolygon(tobj);

    free(tri);

    CAMLreturn( Val_unit );
}
// }}}
// {{{ gluTesselateIter 

CAMLprim value
tesselate_iter_points( value tess, value ml_data_list, value li_len )
{
    CAMLparam1( ml_data_list );
    CAMLlocal1( ml_point_array );

    GLUtesselator * tobj = (GLUtesselator *) tess;

    GLdouble **tri;

    int j, n = 0;

    tri = malloc(sizeof(GLdouble *) * Int_val(li_len));

    gluTessBeginPolygon(tobj, NULL);

      while ( ml_data_list != Val_emptylist )
      {
          ml_point_array = Field(ml_data_list,0);

          int i, len;
          len = Wosize_val(ml_point_array);

          tri[n] = malloc(sizeof(GLdouble) * 3 * len);

          gluTessBeginContour(tobj);
            for (i=0; i < len; i++)
            {
                GLdouble *location;

                tri[n][3*i + 0] = Double_val(Field(Field(ml_point_array, i), 0));
                tri[n][3*i + 1] = Double_val(Field(Field(ml_point_array, i), 1));
                tri[n][3*i + 2] = Double_val(Field(Field(ml_point_array, i), 2));

                location = &tri[n][3*i];
                gluTessVertex( tobj,
                               location,
                               (GLvoid*) location );
            }
          gluTessEndContour(tobj);

          ++n;

          ml_data_list = Field(ml_data_list,1);
      }

    gluTessEndPolygon(tobj);

    for (j=0; j<n; j++) {
        free(tri[j]);
    }
    free(tri);

    CAMLreturn( Val_unit );
}
// }}}


// {{{ Glu-Tess Default Callbacks 

#define  default_glutess_cb_begin  glBegin
void __default_glutess_cb_begin( GLenum type ) {
    glBegin(type);
}
void default_glutess_cb_begin_data( GLenum type, void *polygon_data ) {
    glBegin(type);
}
void default_glutess_cb_edge_flag( GLboolean flag ) {
}
void default_glutess_cb_edge_flag_data( GLboolean flag, void *polygon_data ) {
}
#define  __default_glutess_cb_vertex  glVertex3dv
void default_glutess_cb_vertex( void *vertex_data ) {
    glTexCoord2dv((GLdouble *)vertex_data);
    glVertex3dv((GLdouble *)vertex_data);
}
void default_glutess_cb_vertex_data( void *vertex_data, void *polygon_data ) {
    glTexCoord2dv((GLdouble *)vertex_data);
    glVertex3dv((GLdouble *)vertex_data);
}
#define  default_glutess_cb_end  glEnd
void __user_glutess_cb_end( ) {
    glEnd();
}
void default_glutess_cb_end_data( void *polygon_data ) {
    glEnd();
}

void default_glutess_cb_combine( GLdouble coords[3], void *vertex_data[4],
                                 GLfloat weight[4], void **outData ) {
    /*
    GLdouble *new;
    new = malloc(sizeof(GLdouble) * 3);
    new[0] = coords[0];
    new[1] = coords[1];
    new[2] = coords[2];
    *outData = new;
    */
    *outData = push_vertex(coords);
}
void default_glutess_cb_combine_data( GLdouble coords[3], void *vertex_data[4],
                                      GLfloat weight[4], void **outData,
                                      void *polygon_data ) {
    GLdouble *new;
    new = malloc(sizeof(GLdouble) * 3);
    new[0] = coords[0];
    new[1] = coords[1];
    new[2] = coords[2];
    *outData = new;
}

void default_glutess_cb_error( GLenum errno ) {
    char err_msg[76] = "Tessellation Error: ";
    const GLubyte *estring;
    estring = gluErrorString(errno);
    strncat(err_msg, (char *)estring, 76);
    caml_failwith(err_msg);
}
void default_glutess_cb_error_data( GLenum errno, void *polygon_data ) {
    default_glutess_cb_error(errno);
}

// }}}

#define CB_GLUTESS (void(*)())

typedef struct glutess_cb_assoc {
    GLenum kind;
    void (*cb)();
} glutess_cb_assoc;

glutess_cb_assoc glutess_default_cb_table[] =
{
    { GLU_TESS_BEGIN,          CB_GLUTESS default_glutess_cb_begin },
    { GLU_TESS_BEGIN_DATA,     CB_GLUTESS default_glutess_cb_begin_data },
    { GLU_TESS_EDGE_FLAG,      CB_GLUTESS default_glutess_cb_edge_flag },
    { GLU_TESS_EDGE_FLAG_DATA, CB_GLUTESS default_glutess_cb_edge_flag_data },
    { GLU_TESS_VERTEX,         CB_GLUTESS default_glutess_cb_vertex },
    { GLU_TESS_VERTEX_DATA,    CB_GLUTESS default_glutess_cb_vertex_data },
    { GLU_TESS_END,            CB_GLUTESS default_glutess_cb_end },
    { GLU_TESS_END_DATA,       CB_GLUTESS default_glutess_cb_end_data },
    { GLU_TESS_COMBINE,        CB_GLUTESS default_glutess_cb_combine },
    { GLU_TESS_COMBINE_DATA,   CB_GLUTESS default_glutess_cb_combine_data },
    { GLU_TESS_ERROR,          CB_GLUTESS default_glutess_cb_error },
    { GLU_TESS_ERROR_DATA,     CB_GLUTESS default_glutess_cb_error_data },
};

t_val ml_glutesscallback_default( value tess, value which )
{
    glutess_cb_assoc  glutess =  glutess_default_cb_table[Int_val(which)];
    gluTessCallback( (GLUtesselator *) tess, glutess.kind, CB_GLUTESS glutess.cb );
    return Val_unit;
}

t_val ml_gludeletetess( value tess )
{
    gluDeleteTess( (GLUtesselator *) tess );
    free_chunk_list();
    return Val_unit;
}

// {{{ Glu-Tess User defined Callbacks 

void user_glutess_cb_begin_data( GLenum type, void *polygon_data ) {
}
void user_glutess_cb_edge_flag( GLboolean flag ) {
}
void user_glutess_cb_edge_flag_data( GLboolean flag, void *polygon_data ) {
}
void user_glutess_cb_vertex_data( void *vertex_data, void *polygon_data ) {
}
void user_glutess_cb_end_data( void *polygon_data ) {
}
void user_glutess_cb_combine( GLdouble coords[3], void *vertex_data[4],
                              GLfloat weight[4], void **outData ) {
}
#if 0
void user_glutess_cb_combine( GLdouble coords[3], VERTEX *d[4],
                              GLfloat w[4], VERTEX **dataOut ) {
    VERTEX *new = new_vertex();

    new->x = coords[0];
    new->y = coords[1];
    new->z = coords[2];
    new->r = w[0]*d[0]->r + w[1]*d[1]->r + w[2]*d[2]->r + w[3]*d[3]->r;
    new->g = w[0]*d[0]->g + w[1]*d[1]->g + w[2]*d[2]->g + w[3]*d[3]->g;
    new->b = w[0]*d[0]->b + w[1]*d[1]->b + w[2]*d[2]->b + w[3]*d[3]->b;
    new->a = w[0]*d[0]->a + w[1]*d[1]->a + w[2]*d[2]->a + w[3]*d[3]->a;
    *dataOut = new;
}
#endif
void user_glutess_cb_combine_data( GLdouble coords[3], void *vertex_data[4],
                                   GLfloat weight[4], void **outData,
                                   void *polygon_data ) {
}

// }}}

// {{{ gluCallbackTessVertex 

void user_glutess_cb_vertex( void *vertex_data )
{
    static value * closure_f = NULL;

    GLdouble x, y, z;
    x = ((GLdouble *)vertex_data)[0];
    y = ((GLdouble *)vertex_data)[1];
    z = ((GLdouble *)vertex_data)[2];

    if (closure_f == NULL) {
        closure_f = caml_named_value("GLU callback tess vertex");
    }
    caml_callback3( *closure_f, caml_copy_double(x),
                                caml_copy_double(y),
                                caml_copy_double(z) );
}
CAMLprim value ml_glutess_cb_vertex( value tess )
{
    gluTessCallback( (GLUtesselator *)tess, GLU_TESS_VERTEX, user_glutess_cb_vertex );
    return Val_unit;
}
// }}}
// {{{ gluCallbackTessBegin 

void user_glutess_cb_begin( GLenum type )
{
    static value * closure_f = NULL;
    GLenum prim;
    switch (type) {
        case GL_POINTS        : prim = Val_int(0); break;
        case GL_LINES         : prim = Val_int(1); break;
        case GL_LINE_LOOP     : prim = Val_int(2); break;
        case GL_LINE_STRIP    : prim = Val_int(3); break;
        case GL_TRIANGLES     : prim = Val_int(4); break;
        case GL_TRIANGLE_STRIP: prim = Val_int(5); break;
        case GL_TRIANGLE_FAN  : prim = Val_int(6); break;
        case GL_QUADS         : prim = Val_int(7); break;
        case GL_QUAD_STRIP    : prim = Val_int(8); break;
        case GL_POLYGON       : prim = Val_int(9); break;
        default: caml_failwith("gluCallbackTessBegin: Unrecognized primitive type");
    }

    if (closure_f == NULL) {
        closure_f = caml_named_value("GLU callback tess begin");
    }
    caml_callback( *closure_f, prim );
}
CAMLprim value ml_glutess_cb_begin( value tess )
{
    gluTessCallback( (GLUtesselator *)tess, GLU_TESS_BEGIN, user_glutess_cb_begin );
    return Val_unit;
}
// }}}
// {{{ gluCallbackTessEnd 

void user_glutess_cb_end( GLenum type )
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GLU callback tess end");
    }
    caml_callback( *closure_f, Val_unit );
}
CAMLprim value ml_glutess_cb_end( value tess )
{
    gluTessCallback( (GLUtesselator *)tess, GLU_TESS_END, user_glutess_cb_end );
    return Val_unit;
}
// }}}
// {{{ gluCallbackTessError 

void user_glutess_cb_error( GLenum errno )
{
    static value * closure_f = NULL;

    int err;
    switch (errno)
    {
        case GLU_TESS_MISSING_BEGIN_POLYGON: err =  0; break;
        case GLU_TESS_MISSING_BEGIN_CONTOUR: err =  1; break;
        case GLU_TESS_MISSING_END_POLYGON  : err =  2; break;
        case GLU_TESS_MISSING_END_CONTOUR  : err =  3; break;
        case GLU_TESS_COORD_TOO_LARGE      : err =  4; break;
        case GLU_TESS_NEED_COMBINE_CALLBACK: err =  5; break;
        case GLU_OUT_OF_MEMORY             : err =  6; break;
        case GLU_TESS_ERROR7               : err =  7; break;
        case GLU_TESS_ERROR8               : err =  8; break;
        default: caml_failwith("gluCallbackTessError: Unrecognized error type");
    }

    if (closure_f == NULL) {
        closure_f = caml_named_value("GLU callback tess error");
    }
    caml_callback( *closure_f, Val_int(err) );
}
CAMLprim value ml_glutess_cb_error( value tess )
{
    gluTessCallback( (GLUtesselator *)tess, GLU_TESS_ERROR, user_glutess_cb_error );
    return Val_unit;
}
// }}}


/* Nurbs Surfaces */

t_val ml_glunewnurbsrenderer( value unit )
{
    GLUnurbs *nurb;
    nurb = gluNewNurbsRenderer();
    return (value) nurb;
}

t_val ml_glubeginsurface( value nurb )
{
    gluBeginSurface( (GLUnurbs *) nurb );
    return Val_unit;
}

t_val ml_gluendsurface( value nurb )
{
    gluEndSurface( (GLUnurbs *) nurb );
    return Val_unit;
}

t_val ml_glunurbsproperty1( value nurb, value p )
{
    switch (Int_val(p)) {
      case  0: gluNurbsProperty( (GLUnurbs *)nurb, GLU_CULLING, GLU_TRUE); break;
      case  1: gluNurbsProperty( (GLUnurbs *)nurb, GLU_CULLING, GLU_FALSE); break;
      case  2: gluNurbsProperty( (GLUnurbs *)nurb, GLU_AUTO_LOAD_MATRIX, GLU_TRUE); break;
      case  3: gluNurbsProperty( (GLUnurbs *)nurb, GLU_AUTO_LOAD_MATRIX, GLU_FALSE); break;
      case  4: gluNurbsProperty( (GLUnurbs *)nurb, GLU_DISPLAY_MODE, GLU_OUTLINE_POLYGON); break;
      case  5: gluNurbsProperty( (GLUnurbs *)nurb, GLU_DISPLAY_MODE, GLU_FILL); break;
      case  6: gluNurbsProperty( (GLUnurbs *)nurb, GLU_DISPLAY_MODE, GLU_OUTLINE_PATCH); break;
      case  7: gluNurbsProperty( (GLUnurbs *)nurb, GLU_SAMPLING_METHOD, GLU_PATH_LENGTH); break;
      case  8: gluNurbsProperty( (GLUnurbs *)nurb, GLU_SAMPLING_METHOD, GLU_PARAMETRIC_ERROR); break;
      case  9: gluNurbsProperty( (GLUnurbs *)nurb, GLU_SAMPLING_METHOD, GLU_DOMAIN_DISTANCE); break;
      case 10: gluNurbsProperty( (GLUnurbs *)nurb, GLU_SAMPLING_METHOD, GLU_OBJECT_PATH_LENGTH); break;
      case 11: gluNurbsProperty( (GLUnurbs *)nurb, GLU_SAMPLING_METHOD, GLU_OBJECT_PARAMETRIC_ERROR); break;
      case 12: gluNurbsProperty( (GLUnurbs *)nurb, GLU_NURBS_MODE, GLU_NURBS_RENDERER); break;
      case 13: gluNurbsProperty( (GLUnurbs *)nurb, GLU_NURBS_MODE, GLU_NURBS_TESSELLATOR); break;
    }
    return Val_unit;
}
t_val ml_glunurbsproperty2( value nurb, value p, value v )
{
    switch (Int_val(p)) {
      case  0: gluNurbsProperty( (GLUnurbs *)nurb, GLU_SAMPLING_TOLERANCE, Double_val(v)); break;
      case  1: gluNurbsProperty( (GLUnurbs *)nurb, GLU_PARAMETRIC_TOLERANCE, Double_val(v)); break;
      case  2: gluNurbsProperty( (GLUnurbs *)nurb, GLU_U_STEP, Double_val(v)); break;
      case  3: gluNurbsProperty( (GLUnurbs *)nurb, GLU_V_STEP, Double_val(v)); break;
    }
    return Val_unit;
}

t_val ml_glunurbssurface_native(
        value nurb,
        value ml_sKnots,
        value ml_tKnots,
        value sStride,
        value tStride,
        value ml_control,
        value sOrder,
        value tOrder,
        value type )
{
    int i, sKnotCount, tKnotCount, n_control;
    GLfloat* sKnots;
    GLfloat* tKnots;
    GLfloat* control;
    sKnotCount = Wosize_val(ml_sKnots) / Double_wosize;
    tKnotCount = Wosize_val(ml_tKnots) / Double_wosize;
    n_control = Wosize_val(ml_control) / Double_wosize;
    sKnots = malloc(sKnotCount * sizeof(GLfloat));
    tKnots = malloc(tKnotCount * sizeof(GLfloat));
    control = malloc(n_control * sizeof(GLfloat));
    for (i=0; i < sKnotCount; ++i) {
        sKnots[i] = Double_field(ml_sKnots, i);
    }
    for (i=0; i < tKnotCount; ++i) {
        tKnots[i] = Double_field(ml_tKnots, i);
    }
    for (i=0; i < n_control; ++i) {
        control[i] = Double_field(ml_control, i);
    }
    gluNurbsSurface(
        (GLUnurbs *) nurb,
        sKnotCount, sKnots,
        tKnotCount, tKnots,
        Int_val(sStride),
        Int_val(tStride),
        control,
        Int_val(sOrder),
        Int_val(tOrder),
        (type == Val_int(0) ? GL_MAP2_VERTEX_3 : GL_MAP2_VERTEX_4)
    );
    free(sKnots);
    free(tKnots);
    free(control);
    return Val_unit;
}
t_val ml_glunurbssurface_bytecode(value * argv, int argn)
          { return ml_glunurbssurface_native( argv[0], argv[1], argv[2],
                                              argv[3], argv[4], argv[5],
                                              argv[6], argv[7], argv[8] ); }

t_val ml_glubegintrim( value nurb )
{
    gluBeginTrim( (GLUnurbs *) nurb );
    return Val_unit;
}

t_val ml_gluendtrim( value nurb )
{
    gluEndTrim( (GLUnurbs *) nurb );
    return Val_unit;
}

t_val ml_glupwlcurve( value nurb, value _count, value ml_data, value stride, value type)
{
    int i, count;
    GLfloat* data;
    count = Wosize_val(ml_data) / Double_wosize;
    data = malloc(count * sizeof(GLfloat));
    for (i=0; i<count; i++) {
        data[i] = Double_field(ml_data, i);
    }
    gluPwlCurve(
        (GLUnurbs *) nurb,
        Int_val(_count),
        data,
        Int_val(stride),
        (type == Val_int(0) ? GLU_MAP1_TRIM_2 : GLU_MAP1_TRIM_3)
    );
    free(data);
    return Val_unit;
}


static const GLenum nurbs_curve_type_table[] = {
    GL_MAP1_VERTEX_3,
    GL_MAP1_VERTEX_4,
    GLU_MAP1_TRIM_2,
    GLU_MAP1_TRIM_3,
};

t_val ml_glunurbscurve_native( value nurb, value ml_knots, value stride, value ml_control, value order, value type)
{
    int i, knotCount, n_control;
    GLfloat *knots;
    GLfloat *control;
    knotCount = Wosize_val(ml_knots) / Double_wosize;
    n_control = Wosize_val(ml_control) / Double_wosize;
    knots = malloc(knotCount * sizeof(GLfloat));
    control = malloc(n_control * sizeof(GLfloat));
    for (i=0; i<knotCount; i++) {
        knots[i] = Double_field(ml_knots, i);
    }
    for (i=0; i<n_control; i++) {
        control[i] = Double_field(ml_control, i);
    }
    gluNurbsCurve(
        (GLUnurbs *)nurb,
        knotCount,
        knots,
        Int_val(stride),
        control,
        Int_val(order),
        nurbs_curve_type_table[Long_val(type)]
    );
    free(control);
    free(knots);
    return Val_unit;
}
t_val ml_glunurbscurve_bytecode(value * argv, int argn)
          { return ml_glunurbscurve_native( argv[0], argv[1], argv[2],
                                            argv[3], argv[4], argv[5] ); }


/* vim: sw=4 sts=4 ts=4 et fdm=marker nowrap
 */
