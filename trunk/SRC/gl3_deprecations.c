#include <GL3/gl3.h>
#include <caml/fail.h>


void glClearIndex( GLfloat c ) { caml_failwith("glClearIndex: deprecated in OpenGL 3.2"); }
void glClearAccum( GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha ) { caml_failwith("glClearAccum: deprecated in OpenGL 3.2"); }

void glRotated( GLdouble angle, GLdouble x, GLdouble y, GLdouble z ) { caml_failwith("glRotate: deprecated in OpenGL 3.2"); }
void glTranslated( GLdouble x, GLdouble y, GLdouble z ) { caml_failwith("glTranslate: deprecated in OpenGL 3.2"); }
void glScaled( GLdouble x, GLdouble y, GLdouble z ) { caml_failwith("glScale: deprecated in OpenGL 3.2"); }
void glLoadMatrixd( const GLdouble *m ) { caml_failwith("glLoadMatrix: deprecated in OpenGL 3.2"); }
void glMultMatrixd( const GLdouble *m ) { caml_failwith("glMultMatrix: deprecated in OpenGL 3.2"); }
void glLoadIdentity( ) { caml_failwith("glLoadIdentity: deprecated in OpenGL 3.2"); }
void glPushMatrix( ) { caml_failwith("glPushMatrix: deprecated in OpenGL 3.2"); }
void glPopMatrix( ) { caml_failwith("glPopMatrix: deprecated in OpenGL 3.2"); }
void glFrustum( GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble near_val, GLdouble far_val ) { caml_failwith("glFrustum: deprecated in OpenGL 3.2"); }
void glOrtho( GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble near_val, GLdouble far_val ) { caml_failwith("glOrtho: deprecated in OpenGL 3.2"); }

void glBegin( GLenum mode ) { caml_failwith("glBegin: deprecated in OpenGL 3.2"); }
void glEnd( ) { caml_failwith("glEnd: deprecated in OpenGL 3.2"); }
void glVertex2d( GLdouble x, GLdouble y ) { caml_failwith("glVertex2: deprecated in OpenGL 3.2"); }
void glVertex3d( GLdouble x, GLdouble y, GLdouble z ) { caml_failwith("glVertex3: deprecated in OpenGL 3.2"); }
void glVertex4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w ) { caml_failwith("glVertex4: deprecated in OpenGL 3.2"); }
void glColor3d( GLdouble red, GLdouble green, GLdouble blue ) { caml_failwith("glColor3: deprecated in OpenGL 3.2"); }
void glColor4d( GLdouble red, GLdouble green, GLdouble blue, GLdouble alpha ) { caml_failwith("glColor4: deprecated in OpenGL 3.2"); }
void glColor3ub( GLubyte red, GLubyte green, GLubyte blue ) { caml_failwith("glColor3c: deprecated in OpenGL 3.2"); }
void glColor4ub( GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha ) { caml_failwith("glColor4c: deprecated in OpenGL 3.2"); }

void glNormal3d( GLdouble nx, GLdouble ny, GLdouble nz ) { caml_failwith("glNormal3: deprecated in OpenGL 3.2"); }
void glTexCoord1d( GLdouble s ) { caml_failwith("glTexCoord1: deprecated in OpenGL 3.2"); }
void glTexCoord2d( GLdouble s, GLdouble t ) { caml_failwith("glTexCoord2: deprecated in OpenGL 3.2"); }
void glTexCoord3d( GLdouble s, GLdouble t, GLdouble r ) { caml_failwith("glTexCoord3: deprecated in OpenGL 3.2"); }
void glTexCoord4d( GLdouble s, GLdouble t, GLdouble r, GLdouble q ) { caml_failwith("glTexCoord4: deprecated in OpenGL 3.2"); }
void glEdgeFlag( GLboolean flag ) { caml_failwith("glEdgeFlag: deprecated in OpenGL 3.2"); }
void glRectd( GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2 ) { caml_failwith("glRect: deprecated in OpenGL 3.2"); }
void glRecti( GLint x1, GLint y1, GLint x2, GLint y2 ) { caml_failwith("glRecti: deprecated in OpenGL 3.2"); }

void glLineStipple( GLint factor, GLushort pattern ) { caml_failwith("glLineStipple: deprecated in OpenGL 3.2"); }
void glShadeModel( GLenum mode ) { caml_failwith("glShadeModel: deprecated in OpenGL 3.2"); }
void glMatrixMode( GLenum mode ) { caml_failwith("glMatrixMode: deprecated in OpenGL 3.2"); }

void glRasterPos2d( GLdouble x, GLdouble y ) { caml_failwith("glRasterPos2d: deprecated in OpenGL 3.2"); }
void glRasterPos3d( GLdouble x, GLdouble y, GLdouble z ) { caml_failwith("glRasterPos3d: deprecated in OpenGL 3.2"); }
void glRasterPos4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w ) { caml_failwith("glRasterPos4d: deprecated in OpenGL 3.2"); }
void glRasterPos2i( GLint x, GLint y ) { caml_failwith("glRasterPos2i: deprecated in OpenGL 3.2"); }
void glRasterPos3i( GLint x, GLint y, GLint z ) { caml_failwith("glRasterPos3i: deprecated in OpenGL 3.2"); }
void glRasterPos4i( GLint x, GLint y, GLint z, GLint w ) { caml_failwith("glRasterPos4i: deprecated in OpenGL 3.2"); }


void glPixelZoom( GLfloat xfactor, GLfloat yfactor ) { caml_failwith("glPixelZoom: deprecated in OpenGL 3.2"); }
void glPixelMapfv( GLenum map, GLsizei mapsize, const GLfloat *values ) { caml_failwith("glPixelMap: deprecated in OpenGL 3.2"); }
void glBitmap( GLsizei width, GLsizei height, GLfloat xorig, GLfloat yorig, GLfloat xmove, GLfloat ymove, const GLubyte *bitmap ) { caml_failwith("glBitmap: deprecated in OpenGL 3.2"); }
void glCopyPixels( GLint x, GLint y, GLsizei width, GLsizei height, GLenum type ) { caml_failwith("glCopyPixels: deprecated in OpenGL 3.2"); }
void glPixelTransferi( GLenum pname, GLint param ) { caml_failwith("glPixelTransfer: deprecated in OpenGL 3.2"); }
void glPixelTransferf( GLenum pname, GLfloat param ) { caml_failwith("glPixelTransfer: deprecated in OpenGL 3.2"); }
void glTexEnvi( GLenum target, GLenum pname, GLint param ) { caml_failwith("glTexEnv: deprecated in OpenGL 3.2"); }
void glTexEnviv( GLenum target, GLenum pname, const GLint *params ) { caml_failwith("glTexEnv: deprecated in OpenGL 3.2"); }
void glTexGeni( GLenum coord, GLenum pname, GLint param ) { caml_failwith("glTexGen: deprecated in OpenGL 3.2"); }
void glTexGeniv( GLenum coord, GLenum pname, const GLint *params ) { caml_failwith("glTexGen: deprecated in OpenGL 3.2"); }
void glTexGendv( GLenum coord, GLenum pname, const GLdouble *params ) { caml_failwith("glTexGen: deprecated in OpenGL 3.2"); }
void glAlphaFunc( GLenum func, GLclampf ref ) { caml_failwith("glAlphaFunc: deprecated in OpenGL 3.2"); }
void glClipPlane( GLenum plane, const GLdouble *equation ) { caml_failwith("glClipPlane: deprecated in OpenGL 3.2"); }
void glMap1d( GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points ) { caml_failwith("glMap1: deprecated in OpenGL 3.2"); }
void glMap2d( GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points ) { caml_failwith("glMap2: deprecated in OpenGL 3.2"); }
void glEvalMesh1( GLenum mode, GLint i1, GLint i2 ) { caml_failwith("glEvalMesh1: deprecated in OpenGL 3.2"); }
void glEvalMesh2( GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2 ) { caml_failwith("glEvalMesh2: deprecated in OpenGL 3.2"); }
void glEvalPoint1( GLint i ) { caml_failwith("glEvalPoint1: deprecated in OpenGL 3.2"); }
void glEvalPoint2( GLint i, GLint j ) { caml_failwith("glEvalPoint2: deprecated in OpenGL 3.2"); }
void glEvalCoord1d( GLdouble u ) { caml_failwith("glEvalCoord1: deprecated in OpenGL 3.2"); }
void glEvalCoord1dv( const GLdouble *u ) { caml_failwith("glEvalCoord1: deprecated in OpenGL 3.2"); }
void glEvalCoord2d( GLdouble u, GLdouble v ) { caml_failwith("glEvalCoord2: deprecated in OpenGL 3.2"); }
void glEvalCoord2dv( const GLdouble *u ) { caml_failwith("glEvalCoord2: deprecated in OpenGL 3.2"); }
void glLightf( GLenum light, GLenum pname, GLfloat param ) { caml_failwith("glLight: deprecated in OpenGL 3.2"); }
void glLightfv( GLenum light, GLenum pname, const GLfloat *params ) { caml_failwith("glLight: deprecated in OpenGL 3.2"); }
void glGetLightfv( GLenum light, GLenum pname, GLfloat *params ) { caml_failwith("glGetLight: deprecated in OpenGL 3.2"); }
void glLightModeli( GLenum pname, GLint param ) { caml_failwith("glLightModel: deprecated in OpenGL 3.2"); }
void glLightModeliv( GLenum pname, const GLint *params ) { caml_failwith("glLightModel: deprecated in OpenGL 3.2"); }
void glLightModelfv( GLenum pname, const GLfloat *params ) { caml_failwith("glLightModel: deprecated in OpenGL 3.2"); }
void glColorMaterial( GLenum face, GLenum mode ) { caml_failwith("glColorMaterial: deprecated in OpenGL 3.2"); }
void glMaterialf( GLenum face, GLenum pname, GLfloat param ) { caml_failwith("glMaterial: deprecated in OpenGL 3.2"); }
void glMaterialfv( GLenum face, GLenum pname, const GLfloat *params ) { caml_failwith("glMaterial: deprecated in OpenGL 3.2"); }
void glGetMaterialfv( GLenum face, GLenum pname, GLfloat *params ) { caml_failwith("glGetMaterial: deprecated in OpenGL 3.2"); }
void glGetMaterialiv( GLenum face, GLenum pname, GLint *params ) { caml_failwith("glGetMaterial: deprecated in OpenGL 3.2"); }
void glAccum( GLenum op, GLfloat value ) { caml_failwith("glAccum: deprecated in OpenGL 3.2"); }
void glMapGrid1d( GLint un, GLdouble u1, GLdouble u2 ) { caml_failwith("glMapGrid1: deprecated in OpenGL 3.2"); }
void glMapGrid2d( GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2 ) { caml_failwith("glMapGrid2: deprecated in OpenGL 3.2"); }
void glPushAttrib( GLbitfield mask ) { caml_failwith("glPushAttrib: deprecated in OpenGL 3.2"); }
void glPopAttrib( ) { caml_failwith("glPopAttrib: deprecated in OpenGL 3.2"); }
void glNewList( GLuint list, GLenum mode ) { caml_failwith("glNewList: deprecated in OpenGL 3.2"); }
GLuint glGenLists( GLsizei range ) { caml_failwith("glGenLists: deprecated in OpenGL 3.2"); return 0; }
void glEndList( ) { caml_failwith("glEndList: deprecated in OpenGL 3.2"); }
void glCallList( GLuint list ) { caml_failwith("glCallList: deprecated in OpenGL 3.2"); }
void glCallLists( GLsizei n, GLenum type, const GLvoid *lists ) { caml_failwith("glCallLists: deprecated in OpenGL 3.2"); }
void glDeleteLists( GLuint list, GLsizei range ) { caml_failwith("glDeleteLists: deprecated in OpenGL 3.2"); }
void glListBase( GLuint base ) { caml_failwith("glListBase: deprecated in OpenGL 3.2"); }
GLboolean glIsList( GLuint list ) { caml_failwith("glIsList: deprecated in OpenGL 3.2"); return 0;}
GLint glRenderMode( GLenum mode ) { caml_failwith("glRenderMode: deprecated in OpenGL 3.2"); return 0; }
void glInitNames( ) { caml_failwith("glInitNames: deprecated in OpenGL 3.2"); }
void glLoadName( GLuint name ) { caml_failwith("glLoadName: deprecated in OpenGL 3.2"); }
void glPushName( GLuint name ) { caml_failwith("glPushName: deprecated in OpenGL 3.2"); }
void glPopName( ) { caml_failwith("glPopName: deprecated in OpenGL 3.2"); }
void glSelectBuffer( GLsizei size, GLuint *buffer ) { caml_failwith("glSelectBuffer: deprecated in OpenGL 3.2"); }
void glFogf( GLenum pname, GLfloat param ) { caml_failwith("glFog: deprecated in OpenGL 3.2"); }
void glFogfv( GLenum pname, const GLfloat *params ) { caml_failwith("glFog: deprecated in OpenGL 3.2"); }
void glFogi( GLenum pname, GLint param ) { caml_failwith("glFog: deprecated in OpenGL 3.2"); }
void glIndexd( GLdouble c ) { caml_failwith("glIndex: deprecated in OpenGL 3.2"); }
void glIndexi( GLint c ) { caml_failwith("glIndex: deprecated in OpenGL 3.2"); }
void glPolygonStipple( const GLubyte *mask ) { caml_failwith("glPolygonStipple: deprecated in OpenGL 3.2"); }
void glMultiTexCoord2d( GLenum target, GLdouble s, GLdouble t ) { caml_failwith("glMultiTexCoord2: deprecated in OpenGL 3.2"); }
void glPrioritizeTextures( GLsizei n, const GLuint *textures, const GLclampf *priorities ) { caml_failwith("glPrioritizeTextures: deprecated in OpenGL 3.2"); }
void glSecondaryColor3d( GLdouble r, GLdouble g, GLdouble b ) { caml_failwith("glSecondaryColor3d: deprecated in OpenGL 3.2"); }


/* module vertArray */

void glEnableClientState( GLenum cap ) { caml_failwith("glEnableClientState: deprecated in OpenGL 3.2"); }
void glDisableClientState( GLenum cap ) { caml_failwith("glDisableClientState: deprecated in OpenGL 3.2"); }
void glArrayElement( GLint i ) { caml_failwith("glArrayElement: deprecated in OpenGL 3.2"); }
void glInterleavedArrays( GLenum format, GLsizei stride, const GLvoid *pointer ) { caml_failwith("glInterleavedArrays: deprecated in OpenGL 3.2"); }
void glVertexPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr ) { caml_failwith("glVertexPointer: deprecated in OpenGL 3.2"); }
void glTexCoordPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr ) { caml_failwith("glTexCoordPointer: deprecated in OpenGL 3.2"); }
void glNormalPointer( GLenum type, GLsizei stride, const GLvoid *ptr ) { caml_failwith("glNormalPointer: deprecated in OpenGL 3.2"); }
void glIndexPointer( GLenum type, GLsizei stride, const GLvoid *ptr ) { caml_failwith("glIndexPointer: deprecated in OpenGL 3.2"); }
void glColorPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr ) { caml_failwith("glColorPointer: deprecated in OpenGL 3.2"); }
void glSecondaryColorPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr ) { caml_failwith("glSecondaryColorPointer: deprecated in OpenGL 3.2"); }
void glEdgeFlagPointer( GLsizei stride, const GLvoid *ptr ) { caml_failwith("glEdgeFlagPointer: deprecated in OpenGL 3.2"); }


/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
