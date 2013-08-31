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

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

#include <FTGL/ftgl.h>

CAMLprim value
ml_ftglCreatePixmapFont( value filename )
{
    FTGLfont *font = ftglCreatePixmapFont(String_val(filename));
    if(!font) caml_failwith("ftglCreatePixmapFont");
    return (value) font;
}

CAMLprim value
ml_ftglCreateBitmapFont( value filename )
{
    FTGLfont *font = ftglCreateBitmapFont(String_val(filename));
    if(!font) caml_failwith("ftglCreateBitmapFont");
    return (value) font;
}

CAMLprim value
ml_ftglCreateBufferFont( value filename )
{
    FTGLfont *font = ftglCreateBufferFont(String_val(filename));
    if(!font) caml_failwith("ftglCreateBufferFont");
    return (value) font;
}

CAMLprim value
ml_ftglCreateTextureFont( value filename )
{
    FTGLfont *font = ftglCreateTextureFont(String_val(filename));
    if(!font) caml_failwith("ftglCreateTextureFont");
    return (value) font;
}

CAMLprim value
ml_ftglCreateOutlineFont( value filename )
{
    FTGLfont *font = ftglCreateOutlineFont(String_val(filename));
    if(!font) caml_failwith("ftglCreateOutlineFont");
    return (value) font;
}

CAMLprim value
ml_ftglCreateExtrudeFont( value filename )
{
    FTGLfont *font = ftglCreateExtrudeFont(String_val(filename));
    if(!font) caml_failwith("ftglCreateExtrudeFont");
    return (value) font;
}

CAMLprim value
ml_ftglCreatePolygonFont( value filename )
{
    FTGLfont *font = ftglCreatePolygonFont(String_val(filename));
    if(!font) caml_failwith("ftglCreatePolygonFont");
    return (value) font;
}

CAMLprim value
ml_ftglDestroyFont( value font )
{
    ftglDestroyFont( (FTGLfont *)font );
    return Val_unit;
}

CAMLprim value
ml_ftglSetFontFaceSize( value font, value size, value res )
{
    int ret = ftglSetFontFaceSize( (FTGLfont *)font, Int_val(size), Int_val(res) );
    if (!ret) caml_failwith("ftglCreatePixmapFont");
    return Val_unit;
}

CAMLprim value
ml_ftglGetFontFaceSize( value font )
{
    return Val_int( ftglGetFontFaceSize( (FTGLfont *)font ));
}

static const int render_mode_table[] = {
    FTGL_RENDER_FRONT,
    FTGL_RENDER_BACK,
    FTGL_RENDER_SIDE,
    FTGL_RENDER_ALL
};

/*
FTGL_ALIGN_LEFT
FTGL_ALIGN_CENTER
FTGL_ALIGN_RIGHT
FTGL_ALIGN_JUSTIFY
*/

CAMLprim value
ml_ftglRenderFont( value font, value str, value render_mode )
{
    ftglRenderFont( (FTGLfont *)font, String_val(str),
                     render_mode_table[Long_val(render_mode)] );
    return Val_unit;
}

/* FTGL/FTFont.h */

// TODO:
// int ftglSetFontCharMap(FTGLfont* font, FT_Encoding encoding);

CAMLprim value
ml_ftglSetFontDepth( value font, value depth )
{
    ftglSetFontDepth( (FTGLfont *)font, Double_val(depth) );
    return Val_unit;
}

CAMLprim value
ml_ftglSetFontOutset( value font, value front, value back )
{
    ftglSetFontOutset( (FTGLfont *)font, Double_val(front), Double_val(back) );
    return Val_unit;
}

// TODO:
//void ftglSetFontDisplayList(FTGLfont* font, int useList);

CAMLprim value
ml_ftglGetFontAscender( FTGLfont* font )
{
    return caml_copy_double( ftglGetFontAscender( (FTGLfont *)font ));
}

CAMLprim value
ml_ftglGetFontDescender( FTGLfont* font )
{
    return caml_copy_double( ftglGetFontDescender( (FTGLfont *)font ));
}

CAMLprim value
ml_ftglGetFontLineHeight( FTGLfont* font )
{
    return caml_copy_double( ftglGetFontLineHeight( (FTGLfont *)font ));
}

// TODO:
// void ftglGetFontBBox(FTGLfont* font, const char *string, int len, float bounds[6]);

CAMLprim value
ml_ftglGetFontAdvance( FTGLfont* font, value str )
{
    return caml_copy_double( ftglGetFontAdvance( (FTGLfont *)font, String_val(str) ));
}

// TODO:
// FT_Error ftglGetFontError(FTGLfont* font);


#if 0
/* FTGL/FTExtrdGlyph.h */

FTGLglyph *ftglCreateExtrudeGlyph(
                FT_GlyphSlot glyph, float depth,
                float frontOutset, float backOutset,
                int useDisplayList );

#endif


/* FTGL/FTSimpleLayout.h */

CAMLprim value
ml_ftglCreateSimpleLayout( value unit )
{
    FTGLlayout * layout = ftglCreateSimpleLayout();
    return (value) layout;
}

CAMLprim value
ml_ftglSetLayoutFont( value layout, value font )
{
    ftglSetLayoutFont( (FTGLlayout *)layout, (FTGLfont *)font );
    return Val_unit;
}

CAMLprim value
ml_ftglGetLayoutFont( value layout )
{
    FTGLfont * font = ftglGetLayoutFont( (FTGLlayout *)layout );
    return (value) font;
}

CAMLprim value
ml_ftglSetLayoutLineLength( value layout, value lineLength )
{
    ftglSetLayoutLineLength( (FTGLlayout *)layout, Double_val(lineLength) );
    return Val_unit;
}

CAMLprim value
ml_ftglGetLayoutLineLength( value layout )
{
    return caml_copy_double( ftglGetLayoutLineLength( (FTGLlayout *)layout ));
}

CAMLprim value
ml_ftglSetLayoutAlignment( value layout, value alignment )
{
    ftglSetLayoutAlignment( (FTGLlayout *)layout, Int_val(alignment) );
    return Val_unit;
}

CAMLprim value
ml_ftglGetLayoutAlignement( value layout )
{
    return Val_int( ftglGetLayoutAlignement( (FTGLlayout *)layout ) );
}

CAMLprim value
ml_ftglSetLayoutLineSpacing( value layout, value lineSpacing )
{
    ftglSetLayoutLineSpacing( (FTGLlayout *)layout, Double_val(lineSpacing) );
    return Val_unit;
}

#if 0
CAMLprim value
ml_ftglGetLayoutLineSpacing( value layout )
{
    return caml_copy_double( ftglGetLayoutLineSpacing( (FTGLlayout *)layout ));
}
#endif


/* FTGL/FTLayout.h */

CAMLprim value
ml_ftglDestroyLayout( value layout )
{
    ftglDestroyLayout( (FTGLlayout *)layout );
    return Val_unit;
}

// void ftglGetLayoutBBox(FTGLlayout *layout, const char* string, float bounds[6]);
// void ftglRenderLayout(FTGLlayout *layout, const char *string, int mode);
// FT_Error ftglGetLayoutError(FTGLlayout* layout);

/* vim: ts=4 sts=4 sw=4 et fdm=marker nowrap
 */
