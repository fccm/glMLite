(** JPEG image loader *)

(** Jpeg image loader, optimised to load the data directly inside the bigarray. *)

(*
type image_color_space =
  | JCS_RGB           (** red/green/blue *)
  | JCS_GRAYSCALE     (** monochrome *)
  | JCS_CMYK          (** C/M/Y/K *)
  | JCS_YCbCr         (** Y/Cb/Cr (also known as YUV) *)
  | JCS_YCCK          (** Y/Cb/Cr/K *)
  | JCS_UNKNOWN       (** error/unspecified *)
*)

external load_img: GL.img_input ->
      GL.image_data *
      int * int *
      GL.InternalFormat.internal_format *
      GL.pixel_data_format
      = "caml_load_jpeg_file"
(** The 2 additionnal integers are the [width] and [height] *)

