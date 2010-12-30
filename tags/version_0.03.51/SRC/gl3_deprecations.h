
void glClearIndex( GLfloat c );
void glClearAccum( GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha );
void glRotated( GLdouble angle, GLdouble x, GLdouble y, GLdouble z );
void glTranslated( GLdouble x, GLdouble y, GLdouble z );
void glScaled( GLdouble x, GLdouble y, GLdouble z );
void glLoadMatrixd( const GLdouble *m );
void glMultMatrixd( const GLdouble *m );
void glLoadIdentity( void );
void glPushMatrix( void );
void glPopMatrix( void );
void glFrustum( GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble near_val, GLdouble far_val );
void glOrtho( GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble near_val, GLdouble far_val );
void glBegin( GLenum mode );
void glEnd( void );
void glVertex2d( GLdouble x, GLdouble y );
void glVertex3d( GLdouble x, GLdouble y, GLdouble z );
void glVertex4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
void glColor3d( GLdouble red, GLdouble green, GLdouble blue );
void glColor4d( GLdouble red, GLdouble green, GLdouble blue, GLdouble alpha );
void glColor3ub( GLubyte red, GLubyte green, GLubyte blue );
void glColor4ub( GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha );
void glNormal3d( GLdouble nx, GLdouble ny, GLdouble nz );
void glTexCoord1d( GLdouble s );
void glTexCoord2d( GLdouble s, GLdouble t );
void glTexCoord3d( GLdouble s, GLdouble t, GLdouble r );
void glTexCoord4d( GLdouble s, GLdouble t, GLdouble r, GLdouble q );
void glEdgeFlag( GLboolean flag );
void glRectd( GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2 );
void glRecti( GLint x1, GLint y1, GLint x2, GLint y2 );

void glLineStipple( GLint factor, GLushort pattern );
void glShadeModel( GLenum mode );
void glMatrixMode( GLenum mode );

void glRasterPos2d( GLdouble x, GLdouble y );
void glRasterPos3d( GLdouble x, GLdouble y, GLdouble z );
void glRasterPos4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
void glRasterPos2i( GLint x, GLint y );
void glRasterPos3i( GLint x, GLint y, GLint z );
void glRasterPos4i( GLint x, GLint y, GLint z, GLint w );


void glPixelZoom( GLfloat xfactor, GLfloat yfactor );
void glPixelMapfv( GLenum map, GLsizei mapsize, const GLfloat *values );
void glBitmap( GLsizei width, GLsizei height, GLfloat xorig, GLfloat yorig, GLfloat xmove, GLfloat ymove, const GLubyte *bitmap );
void glCopyPixels( GLint x, GLint y, GLsizei width, GLsizei height, GLenum type );
void glPixelTransferi( GLenum pname, GLint param );
void glPixelTransferf( GLenum pname, GLfloat param );
void glTexEnvi( GLenum target, GLenum pname, GLint param );
void glTexEnviv( GLenum target, GLenum pname, const GLint *params );
void glTexGeni( GLenum coord, GLenum pname, GLint param );
void glTexGeniv( GLenum coord, GLenum pname, const GLint *params );
void glTexGendv( GLenum coord, GLenum pname, const GLdouble *params );
void glAlphaFunc( GLenum func, GLclampf ref );
void glClipPlane( GLenum plane, const GLdouble *equation );
void glMap1d( GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points );
void glMap2d( GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points );
void glEvalMesh1( GLenum mode, GLint i1, GLint i2 );
void glEvalMesh2( GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2 );
void glEvalPoint1( GLint i );
void glEvalPoint2( GLint i, GLint j );
void glEvalCoord1d( GLdouble u );
void glEvalCoord1dv( const GLdouble *u );
void glEvalCoord2d( GLdouble u, GLdouble v );
void glEvalCoord2dv( const GLdouble *u );
void glLightf( GLenum light, GLenum pname, GLfloat param );
void glLightfv( GLenum light, GLenum pname, const GLfloat *params );
void glGetLightfv( GLenum light, GLenum pname, GLfloat *params );
void glLightModeli( GLenum pname, GLint param );
void glLightModeliv( GLenum pname, const GLint *params );
void glLightModelfv( GLenum pname, const GLfloat *params );
void glColorMaterial( GLenum face, GLenum mode );
void glMaterialf( GLenum face, GLenum pname, GLfloat param );
void glMaterialfv( GLenum face, GLenum pname, const GLfloat *params );
void glMaterialfv( GLenum face, GLenum pname, const GLfloat *params );
void glGetMaterialfv( GLenum face, GLenum pname, GLfloat *params );
void glGetMaterialiv( GLenum face, GLenum pname, GLint *params );
void glAccum( GLenum op, GLfloat value );
void glMapGrid1d( GLint un, GLdouble u1, GLdouble u2 );
void glMapGrid2d( GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2 );
void glPushAttrib( GLbitfield mask );
void glPopAttrib( void );
void glNewList( GLuint list, GLenum mode );
GLuint glGenLists( GLsizei range );
void glEndList( void );
void glCallList( GLuint list );
void glCallLists( GLsizei n, GLenum type, const GLvoid *lists );
void glDeleteLists( GLuint list, GLsizei range );
void glListBase( GLuint base );
GLboolean glIsList( GLuint list );
GLint glRenderMode( GLenum mode );
void glInitNames( void );
void glLoadName( GLuint name );
void glPushName( GLuint name );
void glPopName( void );
void glSelectBuffer( GLsizei size, GLuint *buffer );
void glFogf( GLenum pname, GLfloat param );
void glFogfv( GLenum pname, const GLfloat *params );
void glFogi( GLenum pname, GLint param );
void glIndexd( GLdouble c );
void glIndexi( GLint c );
void glPolygonStipple( const GLubyte *mask );
void glMultiTexCoord2d( GLenum target, GLdouble s, GLdouble t );
void glPrioritizeTextures( GLsizei n, const GLuint *textures, const GLclampf *priorities );
void glSecondaryColor3d (GLdouble, GLdouble, GLdouble);


#define GL_MAP2_GRID_DOMAIN               0x000A
#define GL_LIGHT_MODEL_AMBIENT            0x000A
#define GL_FOG_COLOR                      0x000A
#define GL_CURRENT_TEXTURE_COORDS         0x000A
#define GL_CURRENT_SECONDARY_COLOR        0x000A
#define GL_CURRENT_RASTER_TEXTURE_COORDS  0x000A
#define GL_CURRENT_RASTER_SECONDARY_COLOR 0x000A
#define GL_CURRENT_RASTER_POSITION        0x000A
#define GL_CURRENT_RASTER_COLOR           0x000A
#define GL_CURRENT_COLOR                  0x000A
#define GL_ACCUM_CLEAR_VALUE              0x000A
#define GL_POINT_DISTANCE_ATTENUATION     0x000A
#define GL_CURRENT_NORMAL                 0x000A
#define GL_CURRENT_INDEX                  0x000A
#define GL_POINT_SIZE_MIN                 0x000A
#define GL_POINT_SIZE_MAX                 0x000A
#define GL_RED_SCALE                      0x000A
#define GL_GREEN_SCALE                    0x000A
#define GL_DEPTH_SCALE                    0x000A
#define GL_BLUE_SCALE                     0x000A
#define GL_ALPHA_SCALE                    0x000A
#define GL_ZOOM_Y                         0x000A
#define GL_ZOOM_X                         0x000A
#define GL_INDEX_CLEAR_VALUE              0x000A
#define GL_FOG_START                      0x000A
#define GL_FOG_INDEX                      0x000A
#define GL_FOG_END                        0x000A
#define GL_FOG_DENSITY                    0x000A
#define GL_CURRENT_RASTER_DISTANCE        0x000A
#define GL_TRANSPOSE_TEXTURE_MATRIX       0x000A
#define GL_TRANSPOSE_PROJECTION_MATRIX    0x000A
#define GL_TRANSPOSE_MODELVIEW_MATRIX     0x000A
#define GL_TRANSPOSE_COLOR_MATRIX         0x000A
#define GL_TEXTURE_MATRIX                 0x000A
#define GL_PROJECTION_MATRIX              0x000A
#define GL_MODELVIEW_MATRIX               0x000A
#define GL_COLOR_MATRIX                   0x000A
#define GL_VERTEX_ARRAY                   0x000A
#define GL_TEXTURE_COORD_ARRAY            0x000A
#define GL_SECONDARY_COLOR_ARRAY          0x000A
#define GL_RGBA_MODE                      0x000A
#define GL_NORMAL_ARRAY                   0x000A
#define GL_MAP_STENCIL                    0x000A
#define GL_MAP_COLOR                      0x000A
#define GL_LINE_STIPPLE                   0x000A
#define GL_LIGHT_MODEL_TWO_SIDE           0x000A
#define GL_LIGHT_MODEL_LOCAL_VIEWER       0x000A
#define GL_LIGHTING                       0x000A
#define GL_LIGHT7                         0x000A
#define GL_LIGHT6                         0x000A
#define GL_LIGHT5                         0x000A
#define GL_LIGHT4                         0x000A
#define GL_LIGHT3                         0x000A
#define GL_LIGHT2                         0x000A
#define GL_LIGHT1                         0x000A
#define GL_LIGHT0                         0x000A
#define GL_INDEX_MODE                     0x000A
#define GL_INDEX_LOGIC_OP                 0x000A
#define GL_INDEX_ARRAY                    0x000A
#define GL_HISTOGRAM                      0x000A
#define GL_FOG_COORD_ARRAY                0x000A
#define GL_EDGE_FLAG_ARRAY                0x000A
#define GL_EDGE_FLAG                      0x000A
#define GL_CURRENT_RASTER_POSITION_VALID  0x000A
#define GL_CONVOLUTION_2D                 0x000A
#define GL_CONVOLUTION_1D                 0x000A
#define GL_COLOR_TABLE                    0x000A
#define GL_COLOR_SUM                      0x000A
#define GL_COLOR_MATERIAL                 0x000A
#define GL_COLOR_ARRAY                    0x000A
#define GL_SELECTION_BUFFER_SIZE          0x000A
#define GL_SECONDARY_COLOR_ARRAY_SIZE     0x000A
#define GL_FOG_COORD_ARRAY_STRIDE         0x000A
#define GL_SECONDARY_COLOR_ARRAY_STRIDE   0x000A
#define GL_VERTEX_ARRAY_STRIDE            0x000A
#define GL_TEXTURE_COORD_ARRAY_STRIDE     0x000A
#define GL_EDGE_FLAG_ARRAY_STRIDE         0x000A
#define GL_COLOR_ARRAY_STRIDE             0x000A
#define GL_INDEX_ARRAY_STRIDE             0x000A
#define GL_NORMAL_ARRAY_STRIDE            0x000A
#define GL_MAX_NAME_STACK_DEPTH           0x000A
#define GL_MAX_COLOR_MATRIX_STACK_DEPTH   0x000A
#define GL_MAX_ATTRIB_STACK_DEPTH         0x000A
#define GL_MAX_CLIENT_ATTRIB_STACK_DEPTH  0x000A
#define GL_ALPHA_BITS                     0x000A
#define GL_BLUE_BITS                      0x000A
#define GL_GREEN_BITS                     0x000A
#define GL_RED_BITS                       0x000A
#define GL_AUX_BUFFERS                    0x000A
#define GL_MAX_CLIP_PLANES                0x000A
#define GL_MAX_TEXTURE_STACK_DEPTH        0x000A
#define GL_MAX_PROJECTION_STACK_DEPTH     0x000A
#define GL_MAX_MODELVIEW_STACK_DEPTH      0x000A
#define GL_TEXTURE_STACK_DEPTH            0x000A
#define GL_PROJECTION_STACK_DEPTH         0x000A
#define GL_MODELVIEW_STACK_DEPTH          0x000A
#define GL_COLOR_MATRIX_STACK_DEPTH       0x000A
#define GL_NAME_STACK_DEPTH               0x000A
#define GL_STENCIL_BITS                   0x000A
#define GL_DEPTH_BITS                     0x000A
#define GL_MAX_TEXTURE_UNITS              0x000A
#define GL_MAX_TEXTURE_COORDS             0x000A
#define GL_MAX_LIST_NESTING               0x000A
#define GL_MAX_LIGHTS                     0x000A
#define GL_LIST_INDEX                     0x000A
#define GL_LIST_BASE                      0x000A
#define GL_CURRENT_RASTER_INDEX           0x000A
#define GL_ACCUM_ALPHA_BITS               0x000A
#define GL_ACCUM_BLUE_BITS                0x000A
#define GL_ACCUM_GREEN_BITS               0x000A
#define GL_ACCUM_RED_BITS                 0x000A
#define GL_BITMAP                         0x000A
#define GL_LUMINANCE_ALPHA                0x000A
#define GL_LUMINANCE                      0x000A
#define GL_COLOR_INDEX                    0x000A
#define GL_EXP2                           0x000A
#define GL_EXP                            0x000A
#define GL_FOG_MODE                       0x000A
#define GL_FRAGMENT_DEPTH                 0x000A
#define GL_FOG_COORD                      0x000A
#define GL_FOG_COORD_SRC                  0x000A
#define GL_FEEDBACK                       0x000A
#define GL_SELECT                         0x000A
#define GL_RENDER                         0x000A
#define GL_COMPILE_AND_EXECUTE            0x000A
#define GL_COMPILE                        0x000A
#define GL_LIST_MODE                      0x000A
#define GL_VIEWPORT_BIT                   0x000A
#define GL_TRANSFORM_BIT                  0x000A
#define GL_TEXTURE_BIT                    0x000A
#define GL_SCISSOR_BIT                    0x000A
#define GL_POLYGON_STIPPLE_BIT            0x000A
#define GL_POLYGON_BIT                    0x000A
#define GL_POINT_BIT                      0x000A
#define GL_PIXEL_MODE_BIT                 0x000A
#define GL_MULTISAMPLE_BIT                0x000A
#define GL_LIST_BIT                       0x000A
#define GL_LINE_BIT                       0x000A
#define GL_LIGHTING_BIT                   0x000A
#define GL_HINT_BIT                       0x000A
#define GL_FOG_BIT                        0x000A
#define GL_EVAL_BIT                       0x000A
#define GL_ENABLE_BIT                     0x000A
#define GL_CURRENT_BIT                    0x000A
#define GL_ACCUM_BUFFER_BIT               0x000A
#define GL_RETURN                         0x000A
#define GL_MULT                           0x000A
#define GL_ADD                            0x000A
#define GL_LOAD                           0x000A
#define GL_ACCUM                          0x000A
#define GL_COLOR_INDEXES                  0x000A
#define GL_SHININESS                      0x000A
#define GL_EMISSION                       0x000A
#define GL_SPECULAR                       0x000A
#define GL_DIFFUSE                        0x000A
#define GL_AMBIENT                        0x000A
#define GL_AMBIENT_AND_DIFFUSE            0x000A
#define GL_SINGLE_COLOR                   0x000A
#define GL_SEPARATE_SPECULAR_COLOR        0x000A
#define GL_LIGHT_MODEL_COLOR_CONTROL      0x000A
#define GL_POSITION                       0x000A
#define GL_SPOT_DIRECTION                 0x000A
#define GL_QUADRATIC_ATTENUATION          0x000A
#define GL_LINEAR_ATTENUATION             0x000A
#define GL_CONSTANT_ATTENUATION           0x000A
#define GL_SPOT_CUTOFF                    0x000A
#define GL_SPOT_EXPONENT                  0x000A
#define GL_AUX3                           0x000A
#define GL_AUX2                           0x000A
#define GL_AUX1                           0x000A
#define GL_AUX0                           0x000A
#define GL_GENERATE_MIPMAP_HINT           0x000A
#define GL_POINT_SMOOTH_HINT              0x000A
#define GL_PERSPECTIVE_CORRECTION_HINT    0x000A
#define GL_FOG_HINT                       0x000A
#define GL_EYE_PLANE                      0x000A
#define GL_OBJECT_PLANE                   0x000A
#define GL_Q                              0x000A
#define GL_R                              0x000A
#define GL_T                              0x000A
#define GL_S                              0x000A
#define GL_REFLECTION_MAP                 0x000A
#define GL_NORMAL_MAP                     0x000A
#define GL_SPHERE_MAP                     0x000A
#define GL_EYE_LINEAR                     0x000A
#define GL_OBJECT_LINEAR                  0x000A
#define GL_TEXTURE_GEN_MODE               0x000A
#define GL_PREVIOUS                       0x000A
#define GL_PRIMARY_COLOR                  0x000A
#define GL_CONSTANT                       0x000A
#define GL_COMBINE                        0x000A
#define GL_SUBTRACT                       0x000A
#define GL_DECAL                          0x000A
#define GL_MODULATE                       0x000A
#define GL_INTERPOLATE                    0x000A
#define GL_ADD_SIGNED                     0x000A
#define GL_COORD_REPLACE                  0x000A
#define GL_RGB_SCALE                      0x000A
#define GL_OPERAND2_ALPHA                 0x000A
#define GL_OPERAND1_ALPHA                 0x000A
#define GL_OPERAND0_ALPHA                 0x000A
#define GL_OPERAND2_RGB                   0x000A
#define GL_OPERAND1_RGB                   0x000A
#define GL_OPERAND0_RGB                   0x000A
#define GL_SRC2_ALPHA                     0x000A
#define GL_SRC1_ALPHA                     0x000A
#define GL_SRC0_ALPHA                     0x000A
#define GL_SRC2_RGB                       0x000A
#define GL_SRC1_RGB                       0x000A
#define GL_SRC0_RGB                       0x000A
#define GL_COMBINE_ALPHA                  0x000A
#define GL_COMBINE_RGB                    0x000A
#define GL_TEXTURE_ENV_MODE               0x000A
#define GL_TEXTURE_FILTER_CONTROL         0x000A
#define GL_TEXTURE_ENV                    0x000A
#define GL_GENERATE_MIPMAP                0x000A
#define GL_CLAMP                          0x000A
#define GL_TEXTURE_PRIORITY               0x000A
#define GL_POST_CONVOLUTION_ALPHA_BIAS    0x000A
#define GL_POST_CONVOLUTION_BLUE_BIAS     0x000A
#define GL_POST_CONVOLUTION_GREEN_BIAS    0x000A
#define GL_POST_CONVOLUTION_RED_BIAS      0x000A
#define GL_POST_CONVOLUTION_ALPHA_SCALE   0x000A
#define GL_POST_CONVOLUTION_BLUE_SCALE    0x000A
#define GL_POST_CONVOLUTION_GREEN_SCALE   0x000A
#define GL_POST_CONVOLUTION_RED_SCALE     0x000A
#define GL_POST_COLOR_MATRIX_ALPHA_BIAS   0x000A
#define GL_POST_COLOR_MATRIX_BLUE_BIAS    0x000A
#define GL_POST_COLOR_MATRIX_GREEN_BIAS   0x000A
#define GL_POST_COLOR_MATRIX_RED_BIAS     0x000A
#define GL_POST_COLOR_MATRIX_ALPHA_SCALE  0x000A
#define GL_POST_COLOR_MATRIX_BLUE_SCALE   0x000A
#define GL_POST_COLOR_MATRIX_GREEN_SCALE  0x000A
#define GL_POST_COLOR_MATRIX_RED_SCALE    0x000A
#define GL_DEPTH_BIAS                     0x000A
#define GL_ALPHA_BIAS                     0x000A
#define GL_BLUE_BIAS                      0x000A
#define GL_GREEN_BIAS                     0x000A
#define GL_RED_BIAS                       0x000A
#define GL_INDEX_OFFSET                   0x000A
#define GL_INDEX_SHIFT                    0x000A
#define GL_PIXEL_MAP_A_TO_A               0x000A
#define GL_PIXEL_MAP_B_TO_B               0x000A
#define GL_PIXEL_MAP_G_TO_G               0x000A
#define GL_PIXEL_MAP_R_TO_R               0x000A
#define GL_PIXEL_MAP_I_TO_A               0x000A
#define GL_PIXEL_MAP_I_TO_B               0x000A
#define GL_PIXEL_MAP_I_TO_G               0x000A
#define GL_PIXEL_MAP_I_TO_R               0x000A
#define GL_PIXEL_MAP_S_TO_S               0x000A
#define GL_PIXEL_MAP_I_TO_I               0x000A
#define GL_TABLE_TOO_LARGE                0x000A
#define GL_STACK_UNDERFLOW                0x000A
#define GL_STACK_OVERFLOW                 0x000A
#define GL_PROJECTION                     0x000A
#define GL_MODELVIEW                      0x000A
#define GL_SMOOTH                         0x000A
#define GL_FLAT                           0x000A
#define GL_ALPHA_TEST                     0x000A
#define GL_VERTEX_PROGRAM_TWO_SIDE        0x000A
#define GL_TEXTURE_GEN_T                  0x000A
#define GL_TEXTURE_GEN_S                  0x000A
#define GL_TEXTURE_GEN_R                  0x000A
#define GL_TEXTURE_GEN_Q                  0x000A
#define GL_SEPARABLE_2D                   0x000A
#define GL_RESCALE_NORMAL                 0x000A
#define GL_POST_CONVOLUTION_COLOR_TABLE   0x000A
#define GL_POST_COLOR_MATRIX_COLOR_TABLE  0x000A
#define GL_POLYGON_STIPPLE                0x000A
#define GL_POINT_SPRITE                   0x000A
#define GL_POINT_SMOOTH                   0x000A
#define GL_NORMALIZE                      0x000A
#define GL_MINMAX                         0x000A
#define GL_MAP2_VERTEX_4                  0x000A
#define GL_MAP2_VERTEX_3                  0x000A
#define GL_MAP2_TEXTURE_COORD_4           0x000A
#define GL_MAP2_TEXTURE_COORD_3           0x000A
#define GL_MAP2_TEXTURE_COORD_2           0x000A
#define GL_MAP2_TEXTURE_COORD_1           0x000A
#define GL_MAP2_NORMAL                    0x000A
#define GL_MAP2_INDEX                     0x000A
#define GL_MAP2_COLOR_4                   0x000A
#define GL_MAP1_VERTEX_4                  0x000A
#define GL_MAP1_VERTEX_3                  0x000A
#define GL_MAP1_TEXTURE_COORD_4           0x000A
#define GL_MAP1_TEXTURE_COORD_3           0x000A
#define GL_MAP1_TEXTURE_COORD_2           0x000A
#define GL_MAP1_TEXTURE_COORD_1           0x000A
#define GL_MAP1_NORMAL                    0x000A
#define GL_MAP1_INDEX                     0x000A
#define GL_MAP1_COLOR_4                   0x000A
#define GL_FOG                            0x000A
#define GL_CLIP_PLANE5                    0x000A
#define GL_CLIP_PLANE4                    0x000A
#define GL_CLIP_PLANE3                    0x000A
#define GL_CLIP_PLANE2                    0x000A
#define GL_CLIP_PLANE1                    0x000A
#define GL_CLIP_PLANE0                    0x000A
#define GL_AUTO_NORMAL                    0x000A
#define GL_SLUMINANCE8_ALPHA8             0x000A
#define GL_SLUMINANCE_ALPHA               0x000A
#define GL_SLUMINANCE8                    0x000A
#define GL_SLUMINANCE                     0x000A
#define GL_INTENSITY16                    0x000A
#define GL_INTENSITY12                    0x000A
#define GL_INTENSITY8                     0x000A
#define GL_INTENSITY4                     0x000A
#define GL_INTENSITY                      0x000A
#define GL_LUMINANCE16_ALPHA16            0x000A
#define GL_LUMINANCE12_ALPHA12            0x000A
#define GL_LUMINANCE12_ALPHA4             0x000A
#define GL_LUMINANCE8_ALPHA8              0x000A
#define GL_LUMINANCE6_ALPHA2              0x000A
#define GL_LUMINANCE4_ALPHA4              0x000A
#define GL_LUMINANCE16                    0x000A
#define GL_LUMINANCE12                    0x000A
#define GL_LUMINANCE8                     0x000A
#define GL_LUMINANCE4                     0x000A
#define GL_COMPRESSED_INTENSITY           0x000A
#define GL_COMPRESSED_LUMINANCE_ALPHA     0x000A
#define GL_COMPRESSED_LUMINANCE           0x000A
#define GL_COMPRESSED_ALPHA               0x000A
#define GL_ALPHA12                        0x000A
#define GL_ALPHA16                        0x000A
#define GL_ALPHA4                         0x000A
#define GL_ALPHA8                         0x000A


/* module vertArray */

#define GL_V2F              0x000A
#define GL_V3F              0x000A
#define GL_C4UB_V2F         0x000A
#define GL_C4UB_V3F         0x000A
#define GL_C3F_V3F          0x000A
#define GL_N3F_V3F          0x000A
#define GL_C4F_N3F_V3F      0x000A
#define GL_T2F_V3F          0x000A
#define GL_T4F_V4F          0x000A
#define GL_T2F_C4UB_V3F     0x000A
#define GL_T2F_C3F_V3F      0x000A
#define GL_T2F_N3F_V3F      0x000A
#define GL_T2F_C4F_N3F_V3F  0x000A
#define GL_T4F_C4F_N3F_V4F  0x000A

void glEnableClientState( GLenum cap );
void glDisableClientState( GLenum cap );
void glArrayElement( GLint i );
void glInterleavedArrays( GLenum format, GLsizei stride, const GLvoid *pointer );
void glVertexPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr );
void glTexCoordPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr );
void glNormalPointer( GLenum type, GLsizei stride, const GLvoid *ptr );
void glIndexPointer( GLenum type, GLsizei stride, const GLvoid *ptr );
void glColorPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr );
void glSecondaryColorPointer( GLint size, GLenum type, GLsizei stride, const GLvoid *ptr );
void glEdgeFlagPointer( GLsizei stride, const GLvoid *ptr );


/* vim: nowrap
 */
