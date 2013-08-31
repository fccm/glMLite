(** PNG image loader *)

external load_img: GL.img_input ->
        GL.image_data *
        int * int *
        GL.InternalFormat.internal_format *
        GL.pixel_data_format
        = "load_png_file"
(** The 2 additionnal integers are the [width] and [height] *)

