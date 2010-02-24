
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

