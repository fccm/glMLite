/* {{{ COPYING 

  +-----------------------------------------------------------------------+
  |  This file belongs to glMLite, an OCaml binding to the OpenGL API.    |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2006, 2007, 2008  Florent Monnier                      |
  |  Contact:  <fmonnier@linux-nantes.org>                                |
  +-----------------------------------------------------------------------+
  |  This program is free software: you can redistribute it and/or        |
  |  modify it under the terms of the GNU General Public License          |
  |  as published by the Free Software Foundation, either version 3       |
  |  of the License, or (at your option) any later version.               |
  |                                                                       |
  |  This program is distributed in the hope that it will be useful,      |
  |  but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  |  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        |
  |  GNU General Public License for more details.                         |
  |                                                                       |
  |  You should have received a copy of the GNU General Public License    |
  |  along with this program.  If not, see <http://www.gnu.org/licenses/> |
  +-----------------------------------------------------------------------+

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
