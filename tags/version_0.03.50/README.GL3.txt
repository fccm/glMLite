
 The main change in OpenGL 3.X is that the "immediate mode" is now
 tagged as deprecated. Though it is still possible to get access to
 it with the compatibility profile, but if one uses the core profile
 all the deprecated functions and enums are removed. This means that
 with the core profile, OpenGL programmers will be supposed to not use
 anymore the functions glTranslate, glRotate, glScale, glLoadMatrix,
 glMultMatrix, but should use GLSL to modify the modelview matrix (and
 idem for the other matrices). Also the functions like glVertex, glColor,
 glNormal, etc, will be deprecated too, the OpenGL programmer will be
 encouraged to use vertex-arrays, VAO's or VBO's.
 There are examples of use of the two modules vertArray and VBO in
 the directories TEST/ and TEST3 and there are also two tutorials online:
 http://www.linux-nantes.org/~fmonnier/ocaml/GL/vertex_array.php
 http://www.linux-nantes.org/~fmonnier/ocaml/GL/gl_vbo.php
 
 Until I have an OpenGL 3 implementation that I can really test 
 I can not be 100% sure that it is handled correctly in glMLite.
 Also considering that we can still use the compatibility profile,
 this means that there are several possible ways to wrap the API:
 with the core profile only, or with the compatibility profile.
 Or perhaps providing two modules GL_core and GL_compatibility.
 An other solution could be to put the core functions in the GL
 module (the current module) and move the deprecated functions in
 a sub-module named GL.Compatibility, so that to make run previous
 code the programmer can just add "open Compatibility" at the
 beginning of the code and by the way the programmer is also
 warned that he's using deprecated features.

 Currently you can compile the OpenGL bindings so that the use
 of deprecated functions and gl-enums will raise an exception,
 compile this with:
 make target USE_GL3_CORE_PROFILE=OK
 This works even if you are not in an 3.X OpenGL version (for
 example 2.1), then you can install <GL3/gl3.h> as follow:
  $ su -
  # wget http://www.opengl.org/registry/api/gl3.h
  # install -d /usr/include/GL3
  # install -m 0644 ./gl3.h /usr/include/GL3/
 Then for example if the function glLight is called, you
 will get:
 exception Failure("glLight: deprecated in OpenGL 3.2")
 (This will not be the final solution, this is only something
 you can use if you wish, before the final solution is chosen
 and released.)

 If you have better ideas, comments, suggestions or anything,
 just email me: <fmonnier(at)linux-nantes.org>

