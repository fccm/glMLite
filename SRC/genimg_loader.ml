(** Generic image loader *)

(**
  This module uses the ImageMagick library, which can read 
  a lot of different images file formats.
  The complete list of these is available on 
  {{:http://www.imagemagick.org/script/formats.php}this web-page}.

  If the image to load is known to be a jpeg or a png, you should
  use the specialised modules [Jpeg_loader], [Png_loader] and
  [Svg_loader] instead which will be far more efficient.
*)

(*
type image_type =
  | Undefined_image_type
  | Bilevel              (** Monochrome image  *)
  | Grayscale
  | GrayscaleMatte       (** Grayscale image with an alpha channel *)
  | Palette              (** Indexed colors *)
  | PaletteMatte         (** Indexed colors + Alpha *)
  | TrueColor            (** RGB *)
  | TrueColorMatte       (** RGBA *)
  | ColorSeparation      (** Cyan/Yellow/Magenta/Black (CYMK) *)
  | ColorSeparationMatte (** CYMK + Alpha *)
  | Optimize
*)

external load_img: GL.img_input ->
      GL.image_data *
      int * int *
      GL.InternalFormat.internal_format *
      GL.pixel_data_format
      = "magick_loader"
(** The 2 additionnal integers are the [width] and [height] *)

