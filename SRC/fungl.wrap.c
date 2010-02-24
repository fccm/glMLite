/* {{{ COPYING 

  +-----------------------------------------------------------------------+
  |  This file belongs to glMLite, an OCaml binding to the OpenGL API.    |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2006 -- 2010  Florent Monnier                          |
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
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>

#include "gl.wrap.h"


CAMLprim value c_pop_matrix(value unit) { glPopMatrix(); return Val_unit; }

CAMLprim value c_push_and_translate(value vec) {
    glPushMatrix();
    glTranslated(
        Double_val(Field(vec,0)),
        Double_val(Field(vec,1)),
        Double_val(Field(vec,2))
    );
    return Val_unit;
}

CAMLprim value c_push_and_rotate(value angle, value vec) {
    glPushMatrix();
    glRotated(
        Double_val(angle),
        Double_val(Field(vec,0)),
        Double_val(Field(vec,1)),
        Double_val(Field(vec,2))
    );
    return Val_unit;
}

CAMLprim value c_push_and_scale(value vec) {
    glPushMatrix();
    glScaled(
        Double_val(Field(vec,0)),
        Double_val(Field(vec,1)),
        Double_val(Field(vec,2))
    );
    return Val_unit;
}

CAMLprim value c_push_and_loadIdentity(value unit) {
    glPushMatrix();
    glLoadIdentity();
    return Val_unit;
}

CAMLprim value c_push_and_multMatrix(value mat) {
    if ((Wosize_val(mat) / Double_wosize) != 16)
        caml_invalid_argument("draw_with_matrix: array length should be 16");
    glPushMatrix();
    glMultMatrixd( (double *)mat );
    return Val_unit;
}


CAMLprim value c_set_get_color3( value rgb )
{
    GLdouble * color_state;
    color_state = malloc(4 * sizeof(GLdouble));
    glGetDoublev(GL_CURRENT_COLOR, color_state);
    glColor3d(
        Double_val(Field(rgb,0)),
        Double_val(Field(rgb,1)),
        Double_val(Field(rgb,2))
    );
    return (value) color_state;
}
CAMLprim value c_set_get_color4( value rgb )
{
    GLdouble * color_state;
    color_state = malloc(4 * sizeof(GLdouble));
    glGetDoublev(GL_CURRENT_COLOR, color_state);
    glColor4d(
        Double_val(Field(rgb,0)),
        Double_val(Field(rgb,1)),
        Double_val(Field(rgb,2)),
        Double_val(Field(rgb,3))
    );
    return (value) color_state;
}
CAMLprim value c_restore_color(value color_state) {
    glColor4dv((GLdouble *)color_state);
    free((void *)color_state);
    return Val_unit;
}


/* a quite tricky one */
/* will need to test every variant cases */
CAMLprim value c_set_get_material( value _face_mode, value v /* material_mode */ ) {
    GLenum face_mode;
    GLfloat * material_state;
#include "enums/face_mode.inc.c"
    material_state = malloc(4 * sizeof(GLfloat));
    switch (Tag_val(v))
    {
#define set_get_glMaterial_with_4_floats(pname) \
          { GLfloat params[4]; \
            params[0] = Double_val(Field(v,0)); \
            params[1] = Double_val(Field(v,1)); \
            params[2] = Double_val(Field(v,2)); \
            params[3] = Double_val(Field(v,3)); \
            glGetMaterialfv( \
                face_mode, \
                (pname == GL_AMBIENT_AND_DIFFUSE ? GL_AMBIENT : pname), \
                material_state ); \
            glMaterialfv( \
                face_mode, \
                pname, \
                params ); \
          }
        case 0:
            set_get_glMaterial_with_4_floats(GL_AMBIENT); break;
        case 1:
            set_get_glMaterial_with_4_floats(GL_DIFFUSE); break;
        case 2:
            set_get_glMaterial_with_4_floats(GL_SPECULAR); break;
        case 3:
            set_get_glMaterial_with_4_floats(GL_EMISSION); break;
        case 5:
            set_get_glMaterial_with_4_floats(GL_AMBIENT_AND_DIFFUSE); break;
 
#undef set_get_glMaterial_with_4_floats
 
        case 4:
            glGetMaterialfv(
                face_mode,
                GL_SHININESS,
                material_state );
            glMaterialf(
                face_mode,
                GL_SHININESS,
                Double_val(Field(v,0)) );
            break;
 
        case 6:
          { GLint params[3];
            params[0] = Int_val(Field(v,0));
            params[1] = Int_val(Field(v,1));
            params[2] = Int_val(Field(v,2));
            glGetMaterialfv(
                face_mode,
                GL_COLOR_INDEXES,
                material_state );
            glMaterialiv(
                face_mode,
                GL_COLOR_INDEXES,
                params );
          }
          break;
 
        default: caml_failwith("variant handling bug");
    }
    return (value) material_state;
}
CAMLprim value c_restore_material( value _face_mode, value v /* material_mode */,
                                   value material_state ) {
    GLenum pname;
    GLenum face_mode;
#include "enums/face_mode.inc.c"
    switch (Tag_val(v))
    {
        case 0: pname = GL_AMBIENT; break;
        case 1: pname = GL_DIFFUSE; break;
        case 2: pname = GL_SPECULAR; break;
        case 3: pname = GL_EMISSION; break;
        case 4: pname = GL_SHININESS; break;
        case 5: pname = GL_AMBIENT_AND_DIFFUSE; break;
        case 6: pname = GL_COLOR_INDEXES; break;
 
        default: caml_failwith("variant handling bug");
    }
    glMaterialfv( face_mode, pname, (GLfloat *)material_state );
    free((void *)material_state);
    return Val_unit;
}


CAMLprim value c_set_get_lightModel( value light_model ) {
    GLfloat *lightModel_state;
    GLenum pname = 0;
    lightModel_state = malloc(4 * sizeof(GLfloat));
    switch (Tag_val(light_model))
    {
        case 0:
          { GLfloat param[4];
            pname = GL_LIGHT_MODEL_AMBIENT;
            param[0] = Double_val(Field(light_model,0));
            param[1] = Double_val(Field(light_model,1));
            param[2] = Double_val(Field(light_model,2));
            param[3] = Double_val(Field(light_model,3));
            glGetFloatv( pname, lightModel_state );
            glLightModelfv( pname, param );
          } break;
 
        case 1:
            pname = GL_LIGHT_MODEL_COLOR_CONTROL;
            glGetFloatv( pname, lightModel_state );
            glLightModeli(
                pname,
                (Int_val(Field(light_model,0)) ?
                    GL_SINGLE_COLOR :
                    GL_SEPARATE_SPECULAR_COLOR) );
            break;
 
        case 2: pname = GL_LIGHT_MODEL_LOCAL_VIEWER;
        case 3: if (pname == 0) pname = GL_LIGHT_MODEL_TWO_SIDE;
            glGetFloatv( pname, lightModel_state );
            glLightModeli(
                pname,
                Int_val(Field(light_model,0)) );
            break;
    }
    return (value) lightModel_state;
}
CAMLprim value c_restore_lightModel( value light_model, value lightModel_state ) {
    GLenum pname;
    switch (Tag_val(light_model))
    {
        case 0: pname = GL_LIGHT_MODEL_AMBIENT; break;
        case 1: pname = GL_LIGHT_MODEL_COLOR_CONTROL; break;
        case 2: pname = GL_LIGHT_MODEL_LOCAL_VIEWER; break;
        case 3: pname = GL_LIGHT_MODEL_TWO_SIDE; break;
    }
    glLightModelfv( pname, (GLfloat *)lightModel_state );
    free((void *)lightModel_state);
    return Val_unit;
}


CAMLprim value c_set_get_shadeModel( value _shade_mode ) {
    GLint * shadeModel_state;
    GLenum shade_mode;
#include "enums/shade_mode.inc.c"
    shadeModel_state = malloc(sizeof(GLint));
    glGetIntegerv( GL_SHADE_MODEL, shadeModel_state );
    glShadeModel( shade_mode );
    return (value) shadeModel_state;
}
CAMLprim value c_restore_shadeModel( value shadeModel_state ) {
    glShadeModel( (GLenum) *((GLint *)shadeModel_state) );
    free((void * )shadeModel_state);
    return Val_unit;
}


CAMLprim value c_set_get_frontFace( value  _orientation ) {
    GLenum orientation;
    GLint *frontFace_state;
#include "enums/orientation.inc.c"
    frontFace_state = malloc(sizeof(GLint));
    glGetIntegerv( GL_FRONT_FACE, frontFace_state );
    glFrontFace( orientation );
    return (value) frontFace_state;
}
CAMLprim value c_restore_frontFace( value frontFace_state ) {
    glFrontFace( *(GLint *)frontFace_state );
    free((void *)frontFace_state);
    return Val_unit;
}


CAMLprim value c_set_get_enabled( value _gl_capability ) {
    GLboolean was_enabled;
    GLenum gl_capability;
#include "enums/gl_capability.inc.c"
    was_enabled = glIsEnabled( gl_capability );
    if (was_enabled == GL_TRUE) {
        return Val_false;
    } else {
        glEnable( gl_capability );
        return Val_true;
    }
}
CAMLprim value c_restore_enabled( value _gl_capability ) {
    GLenum gl_capability;
#include "enums/gl_capability.inc.c"
    glDisable( gl_capability );
    return Val_unit;
}


CAMLprim value c_set_get_disabled( value _gl_capability ) {
    GLboolean was_enabled;
    GLenum gl_capability;
#include "enums/gl_capability.inc.c"
    was_enabled = glIsEnabled( gl_capability );
    if (was_enabled == GL_TRUE) {
        glDisable( gl_capability );
        return Val_true;
    } else {
        return Val_false;
    }
}
CAMLprim value c_restore_disabled( value _gl_capability ) {
    GLenum gl_capability;
#include "enums/gl_capability.inc.c"
    glEnable( gl_capability );
    return Val_unit;
}


CAMLprim value c_set_get_viewport( value vp ) {
    GLint * prev_viewport;
    prev_viewport = malloc(4 * sizeof(GLint));
    glGetIntegerv( GL_VIEWPORT, prev_viewport );
    glViewport(
        Int_val(Field(vp,0)),
        Int_val(Field(vp,1)),
        Int_val(Field(vp,2)),
        Int_val(Field(vp,3)) );
    return (value) prev_viewport;
}
CAMLprim value c_restore_viewport( value prev_viewport) {
    glViewport( ((GLint *)prev_viewport)[0],
                ((GLint *)prev_viewport)[1],
                ((GLint *)prev_viewport)[2],
                ((GLint *)prev_viewport)[3] );
    free((void *)prev_viewport);
    return Val_unit;
}


CAMLprim value c_set_get_polygonMode( value _face_mode, value _polygon_mode ) {
    int * polygonMode_state;
    GLenum face_mode, polygon_mode;
#include "enums/polygon_mode.inc.c"
#include "enums/face_mode.inc.c"
    polygonMode_state = malloc(3 * sizeof(int));
    glGetIntegerv( GL_POLYGON_MODE, polygonMode_state );
    glPolygonMode( face_mode, polygon_mode );
    polygonMode_state[2] = face_mode;
    return (value) polygonMode_state;
}
CAMLprim value c_restore_polygonMode( value polygonMode_state ) {

    GLenum face_mode = (GLenum) ((int *)polygonMode_state)[2];
    switch (face_mode)
    {
      /* do not restore more than what was set */
      case GL_FRONT:
        glPolygonMode( GL_FRONT,                     /* face mode */
          (GLenum) ((int *)polygonMode_state)[0] );  /* polygon mode */
        break;
      case GL_BACK:
        glPolygonMode( GL_BACK,                      /* face mode */
          (GLenum) ((int *)polygonMode_state)[1] );  /* polygon mode */
        break;
      case GL_FRONT_AND_BACK:
        glPolygonMode( GL_FRONT_AND_BACK,            /* face mode */
          (GLenum) ((int *)polygonMode_state)[0] );  /* polygon mode */
          /* here [0] and [1] should be the same */
        break;
    }
    free((void *)polygonMode_state);
    return Val_unit;
}


static inline GLenum Polygon_mode_val( value _polygon_mode ) {
    GLenum polygon_mode;
#include "enums/polygon_mode.inc.c"
    return polygon_mode;
}

CAMLprim value c_set_get_polygonMode2( value _front, value _back ) {
    GLenum front = Polygon_mode_val(_front);
    GLenum back  = Polygon_mode_val(_back);
    GLint * polygonMode_state;
    polygonMode_state = malloc(2 * sizeof(GLint));
    glGetIntegerv( GL_POLYGON_MODE, polygonMode_state );
    glPolygonMode( GL_FRONT, front );
    glPolygonMode( GL_BACK, back );
    return (value) polygonMode_state;
}
CAMLprim value c_restore_polygonMode2( value polygonMode_state ) {
    glPolygonMode( GL_FRONT,                     /* face mode */
      (GLenum) ((int *)polygonMode_state)[0] );  /* polygon mode */
    glPolygonMode( GL_BACK,                      /* face mode */
      (GLenum) ((int *)polygonMode_state)[1] );  /* polygon mode */
    free((void *)polygonMode_state);
    return Val_unit;
}


CAMLprim value c_set_get_cullFace( value _face_mode ) {
    GLint * cullFaceMode_state;
    GLenum face_mode;
#include "enums/face_mode.inc.c"
    cullFaceMode_state = malloc(sizeof(GLint));
    glGetIntegerv( GL_CULL_FACE_MODE, cullFaceMode_state );
    glCullFace( face_mode );
    return (value) cullFaceMode_state;
}
CAMLprim value c_restore_cullFace( value cullFaceMode_state ) {
    glCullFace( *(GLint *)cullFaceMode_state );
    free((void *)cullFaceMode_state);
    return Val_unit;
}


CAMLprim value c_set_get_matrixMode( value _matrix_mode ) {
    GLint * matrixMode_state;
    GLenum matrix_mode;
#include "enums/matrix_mode.inc.c"
    matrixMode_state = malloc(sizeof(GLint));
    glGetIntegerv( GL_MATRIX_MODE, matrixMode_state );
    glMatrixMode( matrix_mode );
    return (value) matrixMode_state;
}
CAMLprim value c_restore_matrixMode( value matrixMode_state ) {
    glMatrixMode( (GLenum) *((GLint *)matrixMode_state) );
    free((void *)matrixMode_state);
    return Val_unit;
}


CAMLprim value c_set_get_lineWidth( value lineWidth )
{
    GLdouble * lineWidth_state;
    lineWidth_state = malloc(sizeof(GLdouble));
    glGetDoublev(GL_LINE_WIDTH, lineWidth_state);
    glLineWidth( Double_val(lineWidth) );
    return (value) lineWidth_state;
}
CAMLprim value c_restore_lineWidth(value lineWidth_state) {
    glColor4dv((GLdouble *)lineWidth_state);
    free((void *)lineWidth_state);
    return Val_unit;
}

CAMLprim value c_set_get_pointSize( value pointSize )
{
    GLdouble * pointSize_state;
    pointSize_state = malloc(sizeof(GLdouble));
    glGetDoublev(GL_POINT_SIZE, pointSize_state);
    glPointSize( Double_val(pointSize) );
    return (value) pointSize_state;
}
CAMLprim value c_restore_pointSize(value pointSize_state) {
    glColor4dv((GLdouble *)pointSize_state);
    free((void *)pointSize_state);
    return Val_unit;
}


CAMLprim value c_set_get_programUse( value program ) {
    GLint * old_prog;
    old_prog = malloc(sizeof(GLint));
    glGetIntegerv(GL_CURRENT_PROGRAM, old_prog);
    glUseProgram( Shader_program_val(program) );
    return (value) old_prog;
}
CAMLprim value c_restore_programUse( value old_prog ) {
    glUseProgram( *((GLuint *)old_prog) );
    free((void *)old_prog);
    return Val_unit;
}



#define render_verts(verts, glFun, params) \
\
CAMLprim value \
render_##verts(value prim, value verts) { \
    glBegin(Int_val(prim)); \
    while ( verts != Val_emptylist ) { \
        value vert = Field(verts,0); \
        glFun params; \
        verts = Field(verts,1); \
    } \
    glEnd(); \
    return Val_unit; \
}


#define render_q1verts(qverts, glFun1, params1, glFun2, params2) \
\
CAMLprim value \
render_##qverts(value prim, value qverts) { \
    GLdouble orig_color[4]; \
    GLdouble orig_normal[3]; \
    GLdouble orig_tex_coords[4]; \
    glGetDoublev(GL_CURRENT_COLOR, orig_color); \
    glGetDoublev(GL_CURRENT_NORMAL, orig_normal); \
    glGetDoublev(GL_CURRENT_TEXTURE_COORDS, orig_tex_coords); \
    glBegin(Int_val(prim)); \
    while ( qverts != Val_emptylist ) { \
        value head = Field(qverts,0); \
        value qual = Field(head,0); \
        value vert = Field(head,1); \
        glFun1 params1; \
        glFun2 params2; \
        qverts = Field(qverts,1); \
    } \
    glEnd(); \
    /* restore */ \
    glColor4dv(orig_color); \
    glNormal3dv(orig_normal); \
    glTexCoord4dv(orig_tex_coords); \
    return Val_unit; \
}


#define render_q2verts(qverts, glFun1, params1, glFun2, params2, glFun3, params3) \
\
CAMLprim value \
render_##qverts(value prim, value qverts) { \
    GLdouble orig_color[4]; \
    GLdouble orig_normal[3]; \
    GLdouble orig_tex_coords[4]; \
    glGetDoublev(GL_CURRENT_COLOR, orig_color); \
    glGetDoublev(GL_CURRENT_NORMAL, orig_normal); \
    glGetDoublev(GL_CURRENT_TEXTURE_COORDS, orig_tex_coords); \
    glBegin(Int_val(prim)); \
    while ( qverts != Val_emptylist ) { \
        value head = Field(qverts,0); \
        value qual1 = Field(head,0); \
        value qual2 = Field(head,1); \
        value vert = Field(head,1); \
        glFun1 params1; \
        glFun2 params2; \
        glFun3 params3; \
        qverts = Field(qverts,1); \
    } \
    glEnd(); \
    /* restore */ \
    glColor4dv(orig_color); \
    glNormal3dv(orig_normal); \
    glTexCoord4dv(orig_tex_coords); \
    return Val_unit; \
}


#define render_q3verts(qverts, glFun1, params1, glFun2, params2, glFun3, params3, glFun4, params4) \
\
CAMLprim value \
render_##qverts(value prim, value qverts) { \
    GLdouble orig_color[4]; \
    GLdouble orig_normal[3]; \
    GLdouble orig_tex_coords[4]; \
    glGetDoublev(GL_CURRENT_COLOR, orig_color); \
    glGetDoublev(GL_CURRENT_NORMAL, orig_normal); \
    glGetDoublev(GL_CURRENT_TEXTURE_COORDS, orig_tex_coords); \
    glBegin(Int_val(prim)); \
    while ( qverts != Val_emptylist ) { \
        value head = Field(qverts,0); \
        value qual1 = Field(head,0); \
        value qual2 = Field(head,1); \
        value qual3 = Field(head,2); \
        value vert = Field(head,1); \
        glFun1 params1; \
        glFun2 params2; \
        glFun3 params3; \
        glFun4 params4; \
        qverts = Field(qverts,1); \
    } \
    glEnd(); \
    /* restore */ \
    glColor4dv(orig_color); \
    glNormal3dv(orig_normal); \
    glTexCoord4dv(orig_tex_coords); \
    return Val_unit; \
}


#define render_qNormverts(qverts, glFun1, params1, glFun2, params2) \
\
CAMLprim value \
render_##qverts(value prim, value qverts) { \
    GLdouble orig_color[4]; \
    GLdouble orig_normal[3]; \
    GLdouble orig_tex_coords[4]; \
    glGetDoublev(GL_CURRENT_COLOR, orig_color); \
    glGetDoublev(GL_CURRENT_NORMAL, orig_normal); \
    glGetDoublev(GL_CURRENT_TEXTURE_COORDS, orig_tex_coords); \
    glBegin(Int_val(prim)); \
    while ( qverts != Val_emptylist ) { \
        value head = Field(qverts,0); \
        value norm = Field(head,0); \
        value qual = Field(head,1); \
        value vert = Field(head,2); \
        glNormal3d( \
              Double_val(Field(norm,0)), \
              Double_val(Field(norm,1)), \
              Double_val(Field(norm,2)) ); \
        glFun1 params1; \
        glFun2 params2; \
        qverts = Field(qverts,1); \
    } \
    glEnd(); \
    /* restore */ \
    glColor4dv(orig_color); \
    glNormal3dv(orig_normal); \
    glTexCoord4dv(orig_tex_coords); \
    return Val_unit; \
}


render_verts(verts2, glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))
 
render_verts(verts3, glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))
 
render_verts(verts4, glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))



render_q1verts(norm_verts2,
    glNormal3d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))
 
render_q1verts(norm_verts3,
    glNormal3d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))
 
render_q1verts(norm_verts4,
    glNormal3d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))



render_q1verts(uv_verts2,
    glTexCoord2d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))
 
render_q1verts(uv_verts3,
    glTexCoord2d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))
 
render_q1verts(uv_verts4,
    glTexCoord2d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))



render_q2verts(uv_norm_verts2,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))
 
render_q2verts(uv_norm_verts3,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))
 
render_q2verts(uv_norm_verts4,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))



render_q2verts(uv_rgb_verts2,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glColor3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))
 
render_q2verts(uv_rgb_verts3,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glColor3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))
 
render_q2verts(uv_rgb_verts4,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glColor3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))

render_q2verts(uv_rgba_verts2,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glColor4d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)),
          Double_val(Field(qual2,3)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))
 
render_q2verts(uv_rgba_verts3,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glColor4d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)),
          Double_val(Field(qual2,3)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))
 
render_q2verts(uv_rgba_verts4,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glColor4d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)),
          Double_val(Field(qual2,3)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))




render_q3verts(uv_norm_rgb_verts2,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glColor3d, (
          Double_val(Field(qual3,0)),
          Double_val(Field(qual3,1)),
          Double_val(Field(qual3,2)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))
 
render_q3verts(uv_norm_rgb_verts3,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glColor3d, (
          Double_val(Field(qual3,0)),
          Double_val(Field(qual3,1)),
          Double_val(Field(qual3,2)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))
 
render_q3verts(uv_norm_rgb_verts4,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glColor3d, (
          Double_val(Field(qual3,0)),
          Double_val(Field(qual3,1)),
          Double_val(Field(qual3,2)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))

render_q3verts(uv_norm_rgba_verts2,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glColor4d, (
          Double_val(Field(qual3,0)),
          Double_val(Field(qual3,1)),
          Double_val(Field(qual3,2)),
          Double_val(Field(qual3,3)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))
 
render_q3verts(uv_norm_rgba_verts3,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glColor4d, (
          Double_val(Field(qual3,0)),
          Double_val(Field(qual3,1)),
          Double_val(Field(qual3,2)),
          Double_val(Field(qual3,3)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))
 
render_q3verts(uv_norm_rgba_verts4,
    glTexCoord2d, (
          Double_val(Field(qual1,0)),
          Double_val(Field(qual1,1)) ),
    glNormal3d, (
          Double_val(Field(qual2,0)),
          Double_val(Field(qual2,1)),
          Double_val(Field(qual2,2)) ),
    glColor4d, (
          Double_val(Field(qual3,0)),
          Double_val(Field(qual3,1)),
          Double_val(Field(qual3,2)),
          Double_val(Field(qual3,3)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))




#define render_qXverts(qverts, p1, p2, p3, p4) \
    render_q1verts(qverts, p1, p2, p3, p4) \
    render_qNormverts(norm_##qverts, p1, p2, p3, p4)

render_qXverts(rgb_verts2,
    glColor3d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))

render_qXverts(rgb_verts3,
    glColor3d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))

render_qXverts(rgb_verts4,
    glColor3d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))



render_qXverts(rgba_verts2,
    glColor4d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)),
          Double_val(Field(qual,3)) ),
    glVertex2d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)) ))

render_qXverts(rgba_verts3,
    glColor4d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)),
          Double_val(Field(qual,3)) ),
    glVertex3d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)) ))

render_qXverts(rgba_verts4,
    glColor4d, (
          Double_val(Field(qual,0)),
          Double_val(Field(qual,1)),
          Double_val(Field(qual,2)),
          Double_val(Field(qual,3)) ),
    glVertex4d, (
          Double_val(Field(vert,0)),
          Double_val(Field(vert,1)),
          Double_val(Field(vert,2)),
          Double_val(Field(vert,3)) ))


/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
