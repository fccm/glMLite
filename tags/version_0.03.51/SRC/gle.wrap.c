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

#include <GL/gle.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

#define Val_none Val_int(0)
#define Some_val(v) Field(v,0)


#if __GLE_DOUBLE
#define check_kind(func,ba) \
    if ((Bigarray_val(ba)->flags & BIGARRAY_KIND_MASK) != BIGARRAY_FLOAT64) \
        caml_invalid_argument(#func ": wrong Bigarray.kind")
#else
#define check_kind(func,ba) \
    if ((Bigarray_val(ba)->flags & BIGARRAY_KIND_MASK) != BIGARRAY_FLOAT32) \
        caml_invalid_argument(#func ": wrong Bigarray.kind")
#endif


CAMLprim value sizeof_gledouble( value unit )
{
    return Val_long(sizeof(gleDouble));
}

static const int join_style_table[] = {
    TUBE_JN_RAW,
    TUBE_JN_ANGLE,
    TUBE_JN_CUT,
    TUBE_JN_ROUND,
    TUBE_JN_CAP,
    TUBE_NORM_FACET,
    TUBE_NORM_EDGE,
    TUBE_NORM_PATH_EDGE,
    TUBE_CONTOUR_CLOSED,
};

static inline int
join_style_val( value mask_list )
{
    int c_mask = 0; 
    while ( mask_list != Val_emptylist )
    {
        value head = Field(mask_list, 0);
        c_mask |= join_style_table[Long_val(head)];
        mask_list = Field(mask_list, 1);
    }
    return c_mask;
}

CAMLprim value ml_glesetjoinstyle( value join_style )
{
    gleSetJoinStyle( join_style_val(join_style) );
    return Val_unit;
}


#define  Val_TUBE_JN_RAW          Val_int(0)
#define  Val_TUBE_JN_ANGLE        Val_int(1)
#define  Val_TUBE_JN_CUT          Val_int(2)
#define  Val_TUBE_JN_ROUND        Val_int(3)
#define  Val_TUBE_JN_CAP          Val_int(4)
#define  Val_TUBE_NORM_FACET      Val_int(5)
#define  Val_TUBE_NORM_EDGE       Val_int(6)
#define  Val_TUBE_NORM_PATH_EDGE  Val_int(7)
#define  Val_TUBE_CONTOUR_CLOSED  Val_int(8)

static value
Val_join_style( int c_mask )
{
    CAMLparam0();
    CAMLlocal2(li, cons);
    li = Val_emptylist;

#define set_mask(mask) \
    if (c_mask & mask) { \
        cons = caml_alloc(2, 0); \
        Store_field( cons, 0, Val_##mask ); \
        Store_field( cons, 1, li ); \
        li = cons; \
    }
    set_mask( TUBE_JN_RAW )
    set_mask( TUBE_JN_ANGLE )
    set_mask( TUBE_JN_CUT )
    set_mask( TUBE_JN_ROUND )
    set_mask( TUBE_JN_CAP )
    set_mask( TUBE_NORM_FACET )
    set_mask( TUBE_NORM_EDGE )
    set_mask( TUBE_NORM_PATH_EDGE )
    set_mask( TUBE_CONTOUR_CLOSED )
#undef set_mask
    CAMLreturn(li);
}

CAMLprim value ml_glegetjoinstyle( value unit )
{
    return Val_join_style( gleGetJoinStyle() );
}


CAMLprim value ml_gledestroygc( value unit ) {
    gleDestroyGC ();
    return Val_unit;
}


#define ba_dim1(ba) (Bigarray_val(ba)->dim[0])

#define glecolor_val(color_ba) \
    (ba_dim1(color_ba) == 0 ? 0x0 : ((gleColor *) Data_bigarray_val(color_ba)))


CAMLprim value ml_glepolycylinder(
        value npoints,
        value point_array,
        value color_array,
        value radius )
{
    check_kind(glePolyCylinder, point_array);

    glePolyCylinder(
            Int_val(npoints),
            (void *) /* gleDouble[][3] */ Data_bigarray_val(point_array),
            glecolor_val(color_array),
            Double_val(radius) );
    return Val_unit;
}



CAMLprim value ml_glepolycone(
        value npoints,
        value point_array,
        value color_array,
        value radius_array )
{
    check_kind(glePolyCone, point_array);
    check_kind(glePolyCone, radius_array);

    glePolyCone(
            Int_val(npoints),
            (void *) /* gleDouble[][3] */ Data_bigarray_val(point_array),
            glecolor_val(color_array),
            (gleDouble *) Data_bigarray_val(radius_array) );

    return Val_unit;
}



CAMLprim value ml_glepolycone_c4f(
        value npoints,
        value point_array,
        value color4_array,
        value radius_array )
{
    check_kind(glePolyCone_c4f, point_array);
    check_kind(glePolyCone_c4f, radius_array);

    glePolyCone_c4f(
            Int_val(npoints),
            (void *) /* gleDouble[][3] */ Data_bigarray_val(point_array),
            (gleColor4f *) Data_bigarray_val(color4_array),
            (gleDouble *) Data_bigarray_val(radius_array) );

    return Val_unit;
}



CAMLprim value ml_gleextrusion(
        value ncp,
        value contour,
        value cont_normal,
        value up,
        value npoints,
        value point_array,
        value color_array )
{
    gleDouble _up[3];

    if (up != Val_none)
    {
        _up[0] = Double_val(Field(Some_val(up),0));
        _up[1] = Double_val(Field(Some_val(up),1));
        _up[2] = Double_val(Field(Some_val(up),2));
    }

    check_kind(gleExtrusion, contour);
    check_kind(gleExtrusion, cont_normal);
    check_kind(gleExtrusion, point_array);

    gleExtrusion(
            Int_val(ncp),
            (void *) /* gleDouble[][2] */ Data_bigarray_val(contour),
            (void *) /* gleDouble[][2] */ Data_bigarray_val(cont_normal),
            (up == Val_none ? NULL : _up),
            Int_val(npoints),
            (void *) /* gleDouble[][3] */ Data_bigarray_val(point_array),
            glecolor_val(color_array) );

    return Val_unit;
}
CAMLprim value ml_gleextrusion_bytecode( value * argv, int argn ) { 
    return ml_gleextrusion( argv[0], argv[1], argv[2], argv[3], argv[4], argv[5], argv[6] );
}



CAMLprim value ml_gletwistextrusion(
        value ncp,
        value contour,
        value cont_normal,
        value up,
        value npoints,
        value point_array,
        value color_array,
        value twist_array )
{
    gleDouble _up[3];

    if (up != Val_none)
    {
        _up[0] = Double_val(Field(Some_val(up),0));
        _up[1] = Double_val(Field(Some_val(up),1));
        _up[2] = Double_val(Field(Some_val(up),2));
    }

    check_kind(gleTwistExtrusion, contour);
    check_kind(gleTwistExtrusion, cont_normal);
    check_kind(gleTwistExtrusion, point_array);
    check_kind(gleTwistExtrusion, twist_array);

    gleTwistExtrusion(
            Int_val(ncp),
            (void *) /* gleDouble[][2] */ Data_bigarray_val(contour),
            (void *) /* gleDouble[][2] */ Data_bigarray_val(cont_normal),
            (up == Val_none ? NULL : _up),
            Int_val(npoints),
            (void *) /* gleDouble[][3] */ Data_bigarray_val(point_array),
            glecolor_val(color_array),
            (gleDouble *) Data_bigarray_val(twist_array) );

    return Val_unit;
}
CAMLprim value ml_gletwistextrusion_bytecode( value * argv, int argn ) { 
    return ml_gletwistextrusion( argv[0], argv[1], argv[2], argv[3],
                                 argv[4], argv[5], argv[6], argv[7] );
}



CAMLprim value ml_glespiral(
        value ncp,
        value contour,
        value cont_normal,
        value up,
        value start_radius,
        value drd_theta,
        value start_z,
        value dzd_theta,
        value start_xform,
        value dx_formd_theta,
        value start_theta,
        value sweep_theta )
{
    gleDouble _up[3];
    gleDouble _start_xform[2][3];
    gleDouble _dx_formd_theta[2][3];

    if (up != Val_none)
    {
        _up[0] = Double_val(Field(Some_val(up),0));
        _up[1] = Double_val(Field(Some_val(up),1));
        _up[2] = Double_val(Field(Some_val(up),2));
    }

    if (start_xform != Val_none)
    {
        value fst = Field(Some_val(start_xform),0);
        value snd = Field(Some_val(start_xform),1);

        _start_xform[0][0] = Double_val(Field(fst,0));
        _start_xform[0][1] = Double_val(Field(fst,1));
        _start_xform[0][2] = Double_val(Field(fst,2));

        _start_xform[1][0] = Double_val(Field(snd,0));
        _start_xform[1][1] = Double_val(Field(snd,1));
        _start_xform[1][2] = Double_val(Field(snd,2));
    }

    if (dx_formd_theta != Val_none)
    {
        value fst = Field(Some_val(dx_formd_theta),0);
        value snd = Field(Some_val(dx_formd_theta),1);

        _dx_formd_theta[0][0] = Double_val(Field(fst,0));
        _dx_formd_theta[0][1] = Double_val(Field(fst,1));
        _dx_formd_theta[0][2] = Double_val(Field(fst,2));

        _dx_formd_theta[1][0] = Double_val(Field(snd,0));
        _dx_formd_theta[1][1] = Double_val(Field(snd,1));
        _dx_formd_theta[1][2] = Double_val(Field(snd,2));
    }

    check_kind(gleSpiral, contour);
    check_kind(gleSpiral, cont_normal);

    gleSpiral(
            Int_val(ncp),
            (void *) /* gleDouble[][2] */ Data_bigarray_val(contour),
            (void *) /* gleDouble[][2] */ Data_bigarray_val(cont_normal),
            (up == Val_none ? NULL : _up),
            Double_val(start_radius),
            Double_val(drd_theta),
            Double_val(start_z),
            Double_val(dzd_theta),
            (start_xform == Val_none ? NULL : _start_xform),
            (dx_formd_theta == Val_none ? NULL : _dx_formd_theta),
            Double_val(start_theta),
            Double_val(sweep_theta) );

    return Val_unit;
}
CAMLprim value ml_glespiral_bytecode( value * argv, int argn ) { 
    return ml_glespiral( argv[0], argv[1], argv[2], argv[3],
                         argv[4], argv[5], argv[6], argv[7],
                         argv[8], argv[9], argv[10], argv[11] );
}



CAMLprim value ml_glehelicoid(
        value torus_radius,
        value start_radius,
        value drd_theta,
        value start_z,
        value dzd_theta,
        value start_xform,
        value dx_formd_theta,
        value start_theta,
        value sweep_theta )
{
    gleDouble _start_xform[2][3];
    gleDouble _dx_formd_theta[2][3];

    if (start_xform != Val_none)
    {
        value fst = Field(Some_val(start_xform),0);
        value snd = Field(Some_val(start_xform),1);

        _start_xform[0][0] = Double_val(Field(fst,0));
        _start_xform[0][1] = Double_val(Field(fst,1));
        _start_xform[0][2] = Double_val(Field(fst,2));

        _start_xform[1][0] = Double_val(Field(snd,0));
        _start_xform[1][1] = Double_val(Field(snd,1));
        _start_xform[1][2] = Double_val(Field(snd,2));
    }

    if (dx_formd_theta != Val_none)
    {
        value fst = Field(Some_val(dx_formd_theta),0);
        value snd = Field(Some_val(dx_formd_theta),1);

        _dx_formd_theta[0][0] = Double_val(Field(fst,0));
        _dx_formd_theta[0][1] = Double_val(Field(fst,1));
        _dx_formd_theta[0][2] = Double_val(Field(fst,2));

        _dx_formd_theta[1][0] = Double_val(Field(snd,0));
        _dx_formd_theta[1][1] = Double_val(Field(snd,1));
        _dx_formd_theta[1][2] = Double_val(Field(snd,2));
    }

    gleHelicoid(
            Double_val(torus_radius),
            Double_val(start_radius),
            Double_val(drd_theta),
            Double_val(start_z),
            Double_val(dzd_theta),
            (start_xform == Val_none ? NULL : _start_xform),
            (dx_formd_theta == Val_none ? NULL : _dx_formd_theta),
            Double_val(start_theta),
            Double_val(sweep_theta) );

    return Val_unit;
}
CAMLprim value ml_glehelicoid_bytecode( value * argv, int argn ) { 
    return ml_glehelicoid( argv[0], argv[1], argv[2], argv[3],
                           argv[4], argv[5], argv[6], argv[7], argv[8] );
}

/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
