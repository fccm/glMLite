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

static inline value
Internal_format_val( value tex_internal_format )
{
    GLint  internal_format;
    switch (Tag_val(tex_internal_format))
    {
        case 0:
            internal_format = Int_val( Field(tex_internal_format,0) );
            if (internal_format > 4 || internal_format < 1)
               caml_invalid_argument("Error: type tex_internal_format: "
                                     "(GL.Cnst n): n should be 1, 2, 3 or 4");
            break;
        case 1:
          { value _internal_format = Field(tex_internal_format,0);
#include "enums/internal_format.inc.c"
          } break;
    }
    return internal_format;
}

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

