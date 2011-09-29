(*
  Copyright (C) 2010 Florent Monnier

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
*)

type t = float array

let get_identity_matrix() =
  [| 1.0; 0.0; 0.0; 0.0;
     0.0; 1.0; 0.0; 0.0;
     0.0; 0.0; 1.0; 0.0;
     0.0; 0.0; 0.0; 1.0; |]
;;

(* construct a projection matrix *)
let perspective_projection ~fov ~ratio ~near ~far =

  let maxY = near *. tan (fov *. 3.14159256 /. 360.0) in
  let minY = -. maxY in
  let minX = minY *. ratio
  and maxX = maxY *. ratio in

  let data = Array.make 16 0.0 in

  data.(0) <- 2.0 *. near /. (maxX -. minX);
  data.(5) <- 2.0 *. near /. (maxY -. minY);
  data.(8) <- (maxX +. minX) /. (maxX -. minX);
  data.(9) <- (maxY +. minY) /. (maxY -. minY);
  data.(10) <- -. (far +. near) /. (far -. near);
  data.(11) <- -. 1.0;
  data.(14) <- -. (2.0 *. far *. near) /. (far -. near);

  (data)
;;

let ortho_projection ~left ~right ~bottom ~top ~near ~far =
  let x_diff = right -. left
  and y_diff = top -. bottom
  and z_diff = far -. near in
  let mat = [|
    2.0 /. x_diff;  0.0; 0.0; 0.0;
    0.0; 2.0 /. y_diff;  0.0; 0.0;
    0.0; 0.0; -2.0 /. z_diff; 0.0;
    (-. right -. left) /. x_diff;
    (-. top -. bottom) /. y_diff;
    (-. far -. near)   /. z_diff;
    1.0;
  |] in
  (mat)

(* construct a transformation matrix from a translation *)
let translation_matrix (x,y,z) =
  let data = get_identity_matrix() in
  data.(12) <- data.(12) +. x;
  data.(13) <- data.(13) +. y;
  data.(14) <- data.(14) +. z;
  (data)
;;

(* multiply two matrices *)
let mult_matrix ~mat1 ~mat2 =
  if Array.length mat1 <> 16
  || Array.length mat2 <> 16
  then invalid_arg "mult_matrix";

  let mat1_get = Array.unsafe_get mat1
  and mat2_get = Array.unsafe_get mat2 in

  let mat1_0  = mat1_get 0     and mat2_0  = mat2_get 0
  and mat1_1  = mat1_get 1     and mat2_1  = mat2_get 1
  and mat1_2  = mat1_get 2     and mat2_2  = mat2_get 2
  and mat1_3  = mat1_get 3     and mat2_3  = mat2_get 3
  and mat1_4  = mat1_get 4     and mat2_4  = mat2_get 4
  and mat1_5  = mat1_get 5     and mat2_5  = mat2_get 5
  and mat1_6  = mat1_get 6     and mat2_6  = mat2_get 6
  and mat1_7  = mat1_get 7     and mat2_7  = mat2_get 7
  and mat1_8  = mat1_get 8     and mat2_8  = mat2_get 8
  and mat1_9  = mat1_get 9     and mat2_9  = mat2_get 9
  and mat1_10 = mat1_get 10    and mat2_10 = mat2_get 10
  and mat1_11 = mat1_get 11    and mat2_11 = mat2_get 11
  and mat1_12 = mat1_get 12    and mat2_12 = mat2_get 12
  and mat1_13 = mat1_get 13    and mat2_13 = mat2_get 13
  and mat1_14 = mat1_get 14    and mat2_14 = mat2_get 14
  and mat1_15 = mat1_get 15    and mat2_15 = mat2_get 15
  in
  let ( * ) = ( *. ) in
  let ( + ) = ( +. ) in
  [|
    mat1_0 * mat2_0  + mat1_4 * mat2_1  + mat1_8  * mat2_2  + mat1_12 * mat2_3;
    mat1_1 * mat2_0  + mat1_5 * mat2_1  + mat1_9  * mat2_2  + mat1_13 * mat2_3;
    mat1_2 * mat2_0  + mat1_6 * mat2_1  + mat1_10 * mat2_2  + mat1_14 * mat2_3;
    mat1_3 * mat2_0  + mat1_7 * mat2_1  + mat1_11 * mat2_2  + mat1_15 * mat2_3;
    mat1_0 * mat2_4  + mat1_4 * mat2_5  + mat1_8  * mat2_6  + mat1_12 * mat2_7;
    mat1_1 * mat2_4  + mat1_5 * mat2_5  + mat1_9  * mat2_6  + mat1_13 * mat2_7;
    mat1_2 * mat2_4  + mat1_6 * mat2_5  + mat1_10 * mat2_6  + mat1_14 * mat2_7;
    mat1_3 * mat2_4  + mat1_7 * mat2_5  + mat1_11 * mat2_6  + mat1_15 * mat2_7;
    mat1_0 * mat2_8  + mat1_4 * mat2_9  + mat1_8  * mat2_10 + mat1_12 * mat2_11;
    mat1_1 * mat2_8  + mat1_5 * mat2_9  + mat1_9  * mat2_10 + mat1_13 * mat2_11;
    mat1_2 * mat2_8  + mat1_6 * mat2_9  + mat1_10 * mat2_10 + mat1_14 * mat2_11;
    mat1_3 * mat2_8  + mat1_7 * mat2_9  + mat1_11 * mat2_10 + mat1_15 * mat2_11;
    mat1_0 * mat2_12 + mat1_4 * mat2_13 + mat1_8  * mat2_14 + mat1_12 * mat2_15;
    mat1_1 * mat2_12 + mat1_5 * mat2_13 + mat1_9  * mat2_14 + mat1_13 * mat2_15;
    mat1_2 * mat2_12 + mat1_6 * mat2_13 + mat1_10 * mat2_14 + mat1_14 * mat2_15;
    mat1_3 * mat2_12 + mat1_7 * mat2_13 + mat1_11 * mat2_14 + mat1_15 * mat2_15;
  |]
;;

let matrix_translate ~matrix (x, y, z) =
  matrix.(12) <- matrix.(0) *. x +. matrix.(4) *. y +. matrix.(8)  *. z +. matrix.(12);
  matrix.(13) <- matrix.(1) *. x +. matrix.(5) *. y +. matrix.(9)  *. z +. matrix.(13);
  matrix.(14) <- matrix.(2) *. x +. matrix.(6) *. y +. matrix.(10) *. z +. matrix.(14);
  matrix.(15) <- matrix.(3) *. x +. matrix.(7) *. y +. matrix.(11) *. z +. matrix.(15);
;;

