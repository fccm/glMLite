#include <stdio.h>

#ifdef __APPLE__
  #include <OpenGL/gl.h>
#else
  #include <GL/gl.h>
#endif

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>

CAMLprim value conf_main( value unit )
{
    CAMLparam1(unit);
    CAMLlocal5(res, vli, vcons, eli, econs);

    vli = Val_emptylist;
    eli = Val_emptylist;

#ifdef GL_ARB_imaging
    {   econs = caml_alloc(2, 0);
        Store_field( econs, 0, caml_copy_string("GL_ARB_imaging") );
        Store_field( econs, 1, eli );
        eli = econs;
    }
#endif


#ifdef GL_VERSION_1_1
    {   vcons = caml_alloc(2, 0);
        Store_field( vcons, 0, caml_copy_string("GL_VERSION_1_1") );
        Store_field( vcons, 1, vli );
        vli = vcons;
    }
#endif

#ifdef GL_VERSION_1_2
    {   vcons = caml_alloc(2, 0);
        Store_field( vcons, 0, caml_copy_string("GL_VERSION_1_2") );
        Store_field( vcons, 1, vli );
        vli = vcons;
    }
#endif

#ifdef GL_VERSION_1_3
    {   vcons = caml_alloc(2, 0);
        Store_field( vcons, 0, caml_copy_string("GL_VERSION_1_3") );
        Store_field( vcons, 1, vli );
        vli = vcons;
    }
#endif

#ifdef GL_VERSION_1_4
    {   vcons = caml_alloc(2, 0);
        Store_field( vcons, 0, caml_copy_string("GL_VERSION_1_4") );
        Store_field( vcons, 1, vli );
        vli = vcons;
    }
#endif

#ifdef GL_VERSION_1_5
    {   vcons = caml_alloc(2, 0);
        Store_field( vcons, 0, caml_copy_string("GL_VERSION_1_5") );
        Store_field( vcons, 1, vli );
        vli = vcons;
    }
#endif

#ifdef GL_VERSION_2_0
    {   vcons = caml_alloc(2, 0);
        Store_field( vcons, 0, caml_copy_string("GL_VERSION_2_0") );
        Store_field( vcons, 1, vli );
        vli = vcons;
    }
#endif

#ifdef GL_VERSION_2_1
    {   vcons = caml_alloc(2, 0);
        Store_field( vcons, 0, caml_copy_string("GL_VERSION_2_1") );
        Store_field( vcons, 1, vli );
        vli = vcons;
    }
#endif

    res = caml_alloc(2, 0);
    Store_field( res, 0, vli );  /* versions */
    Store_field( res, 1, eli );  /* extensions */

    CAMLreturn(res);
}

