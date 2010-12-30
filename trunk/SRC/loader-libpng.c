/* pnglib.c -- png texture loader
 * last modification: aug. 14, 2007
 * Copyright (c) 2005-2007 David HENRY
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <stdlib.h>
#include <string.h>

#include <png.h>

/* Microsoft Visual C++ */
#ifdef _MSC_VER
#pragma comment (lib, "libpng.lib")
#pragma comment (lib, "zlib.lib")
#pragma comment (linker, "/nodefaultlib:libc")
#endif  /* _MSC_VER */

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/bigarray.h>

#if defined(__APPLE__) && !defined (VMDMESA)
  #include <OpenGL/gl.h>
  #include <OpenGL/glext.h>
#else
  #include <GL/gl.h>
  #include <GL/glext.h>
#endif

#include "loader-texure.h"
#define ERR_BUF_SIZE 256

/* OpenGL texture info */
struct gl_texture_t
{
  GLsizei width;
  GLsizei height;

  GLint internalFormat;
  GLenum format;

  int texels_size;
  GLubyte *texels;
};

static void
GetPNGtextureInfo (int color_type, struct gl_texture_t *texinfo)
{
  switch (color_type)
    {
    case PNG_COLOR_TYPE_GRAY:
      texinfo->internalFormat = 1;
      texinfo->format = GL_LUMINANCE;
      break;

    case PNG_COLOR_TYPE_GRAY_ALPHA:
      texinfo->internalFormat = 2;
      texinfo->format = GL_LUMINANCE_ALPHA;
      break;

    case PNG_COLOR_TYPE_RGB:
      texinfo->internalFormat = 3;
      texinfo->format = GL_RGB;
      break;

    case PNG_COLOR_TYPE_RGB_ALPHA:
      texinfo->internalFormat = 4;
      texinfo->format = GL_RGBA;
      break;

    default:
      /* Badness */
      break;
    }
}

/* ====================================================== */

static void
ReadPNGFromFile (const char *filename, struct gl_texture_t *texinfo)
{
  char err_buf[ERR_BUF_SIZE];
  png_byte magic[8];
  png_structp png_ptr;
  png_infop info_ptr;
  int bit_depth, color_type;
  FILE *fp = NULL;
  png_bytep *row_pointers = NULL;
  png_uint_32 w, h;
  int i, j;

  /* Open image file */
  fp = fopen (filename, "rb");
  if (!fp)
    {
      snprintf(err_buf, ERR_BUF_SIZE, "Error: couldn't open png file \"%s\"", filename);
      caml_failwith(err_buf);
    }

  /* Read magic number */
  fread (magic, 1, sizeof (magic), fp);

  /* Check for valid magic number */
  if (!png_check_sig (magic, sizeof (magic)))
    {
      fclose (fp);
      snprintf(err_buf, ERR_BUF_SIZE, "Error: \"%s\" is not a valid PNG image!", filename);
      caml_failwith(err_buf);
    }

  /* Create a png read struct */
  png_ptr = png_create_read_struct (PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
  if (!png_ptr)
    {
      fclose (fp);
      snprintf(err_buf, ERR_BUF_SIZE, "Error: couldn't create png read struct for image \"%s\"", filename);
      caml_failwith(err_buf);
    }

  /* Create a png info struct */
  info_ptr = png_create_info_struct (png_ptr);
  if (!info_ptr)
    {
      fclose (fp);
      png_destroy_read_struct (&png_ptr, NULL, NULL);
      snprintf(err_buf, ERR_BUF_SIZE, "Error: couldn't create png info struct for image \"%s\"", filename);
      caml_failwith(err_buf);
    }

  /* Initialize the setjmp for returning properly after a libpng error occured */
  if (setjmp (png_jmpbuf (png_ptr)))
    {
      fclose (fp);
      png_destroy_read_struct (&png_ptr, &info_ptr, NULL);

      if (row_pointers)
        free (row_pointers);

      if (texinfo->texels)
        free (texinfo->texels);

      snprintf(err_buf, ERR_BUF_SIZE, "Error: a libpng error occured while reading image \"%s\"", filename);
      caml_failwith(err_buf);
    }

  /* Setup libpng for using standard C fread() function with our FILE pointer */
  png_init_io (png_ptr, fp);

  /* Tell libpng that we have already read the magic number */
  png_set_sig_bytes (png_ptr, sizeof (magic));

  /* Read png info */
  png_read_info (png_ptr, info_ptr);

  /* Get some usefull information from header */
  bit_depth = png_get_bit_depth (png_ptr, info_ptr);
  color_type = png_get_color_type (png_ptr, info_ptr);

  /* Convert index color images to RGB images */
  if (color_type == PNG_COLOR_TYPE_PALETTE)
    png_set_palette_to_rgb (png_ptr);

  /* Convert 1-2-4 bits grayscale images to 8 bits grayscale. */
  if (color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8)
    png_set_gray_1_2_4_to_8 (png_ptr);

  if (png_get_valid (png_ptr, info_ptr, PNG_INFO_tRNS))
    png_set_tRNS_to_alpha (png_ptr);

  if (bit_depth == 16)
    png_set_strip_16 (png_ptr);
  else if (bit_depth < 8)
    png_set_packing (png_ptr);

  /* Update info structure to apply transformations */
  png_read_update_info (png_ptr, info_ptr);

  /* Retrieve updated information */
  png_get_IHDR (png_ptr, info_ptr, &w, &h, &bit_depth,
                &color_type, NULL, NULL, NULL);
  texinfo->width = w;
  texinfo->height = h;

  /* Get image format and components per pixel */
  GetPNGtextureInfo (color_type, texinfo);

  /* We can now allocate memory for storing pixel data */
  texinfo->texels_size = sizeof (GLubyte) * texinfo->width *
                         texinfo->height * texinfo->internalFormat;
  texinfo->texels = (GLubyte *)malloc (texinfo->texels_size);

  /* Setup a pointer array.  Each one points at the begening of a row. */
  row_pointers = (png_bytep *)malloc (sizeof (png_bytep) * texinfo->height);

  for (i = 0, j = texinfo->height - 1; i < texinfo->height; ++i, --j)
    {
      row_pointers[j] = (png_bytep)(texinfo->texels +
        ((texinfo->height - (i + 1)) * texinfo->width * texinfo->internalFormat));
    }

  /* Read pixel data using row pointers */
  png_read_image (png_ptr, row_pointers);

  /* Finish decompression and release memory */
  png_read_end (png_ptr, NULL);
  png_destroy_read_struct (&png_ptr, &info_ptr, NULL);

  /* We don't need row pointers anymore */
  free (row_pointers);

  fclose (fp);
}

/* ====================================================== */

/* File buffer struct */
struct file_buffer_t
{
  unsigned char *data;
  long length;
  long offset;
};

static void
png_read_from_mem (png_structp png_ptr, png_bytep data, png_size_t length)
{
  struct file_buffer_t *src
    = (struct file_buffer_t *)png_get_io_ptr (png_ptr);

  /* Copy data from image buffer */
  memcpy (data, src->data + src->offset, length);

  /* Advance in the file */
  src->offset += length;
}

static void
png_error_fn (png_structp png_ptr, png_const_charp error_msg)
{
  fprintf (stderr, "png_error: %s \n", error_msg);

  longjmp (png_jmpbuf (png_ptr), 1);
}

static void
png_warning_fn (png_structp png_ptr, png_const_charp warning_msg)
{
  fprintf (stderr, "png_warning: %s \n", warning_msg);
}

static void
ReadPNGFromMemory (const struct file_buffer_t *file, struct gl_texture_t *texinfo)
{
  char err_buf[ERR_BUF_SIZE];
  png_structp png_ptr;
  png_infop info_ptr;
  int bit_depth, color_type;
  png_bytep *row_pointers = NULL;
  png_uint_32 w, h;
  int i, j;

  /* Check for valid magic number */
  if (!png_check_sig (file->data, 8))
    {
      snprintf(err_buf, ERR_BUF_SIZE, "Error: the buffer is not a valid PNG image");
      caml_failwith(err_buf);
    }

  /* Create a png read struct */
  png_ptr = png_create_read_struct (PNG_LIBPNG_VER_STRING, NULL, png_error_fn, png_warning_fn);
  if (!png_ptr)
    {
      snprintf(err_buf, ERR_BUF_SIZE, "Error: couldn't create png read struct for image buffer");
      caml_failwith(err_buf);
    }

  /* Create a png info struct */
  info_ptr = png_create_info_struct (png_ptr);
  if (!info_ptr)
    {
      png_destroy_read_struct (&png_ptr, NULL, NULL);
      snprintf(err_buf, ERR_BUF_SIZE, "Error: couldn't create png info struct for image buffer");
      caml_failwith(err_buf);
    }


  /* Initialize the setjmp for returning properly after a libpng error occured */
  if (setjmp (png_jmpbuf (png_ptr)))
    {
      png_destroy_read_struct (&png_ptr, &info_ptr, NULL);

      if (row_pointers)
        free (row_pointers);

      if (texinfo->texels)
        free (texinfo->texels);

      snprintf(err_buf, ERR_BUF_SIZE, "Error: a libpng error occured while reading image buffer");
      caml_failwith(err_buf);
    }

  /* Set "png_read" callback function and give source of data */
  png_set_read_fn (png_ptr, (png_voidp *)file, png_read_from_mem);

  /* Read png info */
  png_read_info (png_ptr, info_ptr);

  /* Get some usefull information from header */
  bit_depth = png_get_bit_depth (png_ptr, info_ptr);
  color_type = png_get_color_type (png_ptr, info_ptr);

  /* Convert index color images to RGB images */
  if (color_type == PNG_COLOR_TYPE_PALETTE)
    png_set_palette_to_rgb (png_ptr);

  /* Convert 1-2-4 bits grayscale images to 8 bits grayscale. */
  if (color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8)
    png_set_gray_1_2_4_to_8 (png_ptr);

  if (png_get_valid (png_ptr, info_ptr, PNG_INFO_tRNS))
    png_set_tRNS_to_alpha (png_ptr);

  if (bit_depth == 16)
    png_set_strip_16 (png_ptr);
  else if (bit_depth < 8)
    png_set_packing (png_ptr);

  /* Update info structure to apply transformations */
  png_read_update_info (png_ptr, info_ptr);

  /* Retrieve updated information */
  png_get_IHDR (png_ptr, info_ptr, &w, &h, &bit_depth,
                &color_type, NULL, NULL, NULL);
  texinfo->width = w;
  texinfo->height = h;

  /* Get image format and components per pixel */
  GetPNGtextureInfo (color_type, texinfo);

  /* We can now allocate memory for storing pixel data */
  texinfo->texels_size = sizeof (GLubyte) * texinfo->width *
                         texinfo->height * texinfo->internalFormat;
  texinfo->texels = (GLubyte *)malloc (texinfo->texels_size);

  /* Setup a pointer array.  Each one points at the begening of a row. */
  row_pointers = (png_bytep *)malloc (sizeof (png_bytep) * texinfo->height);

  for (i = 0, j = texinfo->height - 1; i < texinfo->height; ++i, --j)
    {
      row_pointers[j] = (png_bytep)(texinfo->texels +
        ((texinfo->height - (i + 1)) * texinfo->width * texinfo->internalFormat));
    }

  /* Read pixel data using row pointers */
  png_read_image (png_ptr, row_pointers);

  /* Finish decompression and release memory */
  png_read_end (png_ptr, NULL);
  png_destroy_read_struct (&png_ptr, &info_ptr, NULL);

  /* Don't need row pointers anymore */
  free (row_pointers);
}

/* ====================================================== */

static void
read_png_from_memory (value buffer_file, struct gl_texture_t *png_tex)
{
  struct file_buffer_t _file;
  struct file_buffer_t *file;
  file = &_file;

  file->offset = 0;
  file->length = caml_string_length (buffer_file);
  file->data = (unsigned char *) String_val(buffer_file);

  /* Load PNG texture from memory */
  ReadPNGFromMemory (file, png_tex);
}

static void
load_png_from_file (value filename, struct gl_texture_t *png_tex)
{
  /* Load PNG texture from file */
  ReadPNGFromFile (String_val(filename), png_tex);
}

CAMLprim value
load_png_file (value input)
{
  CAMLparam1(input);
  CAMLlocal2(ret, img_ba);

  struct gl_texture_t png_tex;
  switch (Tag_val(input))
  {
    /* given a filename of an image */
    case 0: load_png_from_file(Field(input,0), &png_tex); break;

    /* given the image data in a buffer */
    case 1: read_png_from_memory(Field(input,0), &png_tex); break;
  }
  if (!png_tex.texels) caml_failwith("texels not initialised");

  {
    long dims[3];
    dims[0] = png_tex.width;
    dims[1] = png_tex.height;
    dims[2] = png_tex.internalFormat;
    img_ba = alloc_bigarray(BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT, 3, NULL, dims);

    memcpy(Data_bigarray_val(img_ba), png_tex.texels, png_tex.texels_size);
  }

  ret = caml_alloc(5, 0);

  Store_field( ret, 0, img_ba );
  Store_field( ret, 1, Val_int(png_tex.width) );
  Store_field( ret, 2, Val_int(png_tex.height) );
  Store_field( ret, 3, Val_internal_format(png_tex.internalFormat) );
  Store_field( ret, 4, Val_pixel_data_format(png_tex.format) );

  free (png_tex.texels);

  CAMLreturn( ret );
}

// vim: sw=2 sts=2 ts=2 et fdm=marker
