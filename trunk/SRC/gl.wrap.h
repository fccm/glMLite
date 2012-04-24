/* {{{ COPYING 

  This file belongs to glMLite, an OCaml binding to the OpenGL API.

  Copyright (C) 2006 - 2011  Florent Monnier, Some rights reserved
  Contact:  <fmonnier@linux-nantes.org>

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.

\* }}} */

/* GLSL Shaders */

/* wrap as abstract */
//define Val_shader_object(v) ((value)(v))
//define Shader_object_val(v) ((GLuint)(v))

//define Val_shader_program(v) ((value)(v))
//define Shader_program_val(v) ((GLuint)(v))

/* wrap as ints */
#define Val_shader_object Val_long
#define Shader_object_val Long_val

#define Val_shader_program Val_long
#define Shader_program_val Long_val

