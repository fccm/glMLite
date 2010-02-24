(** An SVG image loader *)

(**
  This module uses the lib-rsvg to get from a SVG file a raster
  version which you can use with OpenGL.

  The size of the SVG document (in pixels) will be the size of
  the raster texture.
*)

external load_img: GL.img_input ->
      GL.image_data *
      int * int *
      GL.InternalFormat.internal_format *
      GL.pixel_data_format
      = "ml_rsvg_loader"
(** The 2 additionnal integers are the [width] and [height] *)

