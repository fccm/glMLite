
  glMLite can be compiled with different versions of OpenGL.
  It should be possible to compile with versions 1.2, 1.3, 1.4,
  2.0 and 2.1 of OpenGL, and probably 3.X too.
  Currently this version of glMLite has been tested successfully
  under linux with OpenGL 2.1 and under Mac OS X with OpenGL 1.4.

  With newer versions of OpenGL there are additional gl-enums.
  The gl-enums (the parameters to the OpenGL functions) are
  managed in glMLite with the XML file 'SRC/enums.list.xml'.

  For example the type wrap_param in the module GL is managed
  with this piece of XML:

  <glenums name='wrap_param'>
    <enum version='GL_VERSION_0_0'>GL_CLAMP</enum>
    <enum version='GL_VERSION_1_3'>GL_CLAMP_TO_BORDER</enum>
    <enum version='GL_VERSION_1_2'>GL_CLAMP_TO_EDGE</enum>
    <enum version='GL_VERSION_1_4'>GL_MIRRORED_REPEAT</enum>
    <enum version='GL_VERSION_0_0'>GL_REPEAT</enum>
  </glenums>

  You can see that the parameter GL_MIRRORED_REPEAT has been
  added in the OpenGL version 1.4, so if you compile for a
  10 years old OpenGL version 1.2 this parameter won't be
  included, and everything will compile just fine.
  (GL_VERSION_0_0 just means an older version than 1.2)

