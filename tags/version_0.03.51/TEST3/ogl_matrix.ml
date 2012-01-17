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

let pi = 3.14159_26535_89793_23846_2643
let deg_to_rad = pi /. 180.0

let get_identity () =
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


let frustum ~left ~right ~bottom ~top ~near ~far =
  let near_twice = 2.0 *. near
  and right_minus_left = right -. left
  and top_minus_bottom = top -. bottom
  and far_minus_near = far -. near
  in
  let e = near_twice /. right_minus_left
  and f = near_twice /. top_minus_bottom
  and a = (right +. left) /. right_minus_left
  and b = (top +. bottom) /. top_minus_bottom
  and c = -. ((far +. near) /. far_minus_near)
  and d = -. (near_twice *. far /. far_minus_near)
  in
  [| e;   0.0;  a;   0.0;
     0.0; f;    b;   0.0;
     0.0; 0.0;  c;   d;
     0.0; 0.0; -1.0; 0.0; |]


let translation_matrix (x,y,z) =
  [| 1.0; 0.0; 0.0; 0.0;
     0.0; 1.0; 0.0; 0.0;
     0.0; 0.0; 1.0; 0.0;
       x;   y;   z; 1.0; |]


let scale_matrix (x,y,z) =
  [|   x; 0.0; 0.0; 0.0;
     0.0;   y; 0.0; 0.0;
     0.0; 0.0;   z; 0.0;
     0.0; 0.0; 0.0; 1.0; |]


let x_rotation_matrix ~angle:a =
  let a = a *. deg_to_rad in
  let cos_a = cos a
  and sin_a = sin a in
  [| 1.0;      0.0;    0.0;  0.0;
     0.0;    cos_a;  sin_a;  0.0;
     0.0; -. sin_a;  cos_a;  0.0;
     0.0;      0.0;    0.0;  1.0; |]
 
let y_rotation_matrix ~angle:a =
  let a = a *. deg_to_rad in
  let cos_a = cos a
  and sin_a = sin a in
  [| cos_a;  0.0; -. sin_a;  0.0;
       0.0;  1.0;      0.0;  0.0;
     sin_a;  0.0;    cos_a;  0.0;
       0.0;  0.0;      0.0;  1.0; |]

let z_rotation_matrix ~angle:a =
  let a = a *. deg_to_rad in
  let cos_a = cos a
  and sin_a = sin a in
  [|   cos_a;  sin_a;  0.0;  0.0;
    -. sin_a;  cos_a;  0.0;  0.0;
         0.0;    0.0;  1.0;  0.0;
         0.0;    0.0;  0.0;  1.0; |]


(* multiply two matrices *)
let mult_matrix ~m1 ~m2 =
  if Array.length m1 <> 16
  || Array.length m2 <> 16
  then invalid_arg "mult_matrix";

  let mat1_get = Array.unsafe_get m1
  and mat2_get = Array.unsafe_get m2 in

  let m1_0  = mat1_get 0     and m2_0  = mat2_get 0
  and m1_1  = mat1_get 1     and m2_1  = mat2_get 1
  and m1_2  = mat1_get 2     and m2_2  = mat2_get 2
  and m1_3  = mat1_get 3     and m2_3  = mat2_get 3
  and m1_4  = mat1_get 4     and m2_4  = mat2_get 4
  and m1_5  = mat1_get 5     and m2_5  = mat2_get 5
  and m1_6  = mat1_get 6     and m2_6  = mat2_get 6
  and m1_7  = mat1_get 7     and m2_7  = mat2_get 7
  and m1_8  = mat1_get 8     and m2_8  = mat2_get 8
  and m1_9  = mat1_get 9     and m2_9  = mat2_get 9
  and m1_10 = mat1_get 10    and m2_10 = mat2_get 10
  and m1_11 = mat1_get 11    and m2_11 = mat2_get 11
  and m1_12 = mat1_get 12    and m2_12 = mat2_get 12
  and m1_13 = mat1_get 13    and m2_13 = mat2_get 13
  and m1_14 = mat1_get 14    and m2_14 = mat2_get 14
  and m1_15 = mat1_get 15    and m2_15 = mat2_get 15
  in
  [|
    m1_0 *. m2_0  +. m1_4 *. m2_1  +. m1_8  *. m2_2  +. m1_12 *. m2_3;
    m1_1 *. m2_0  +. m1_5 *. m2_1  +. m1_9  *. m2_2  +. m1_13 *. m2_3;
    m1_2 *. m2_0  +. m1_6 *. m2_1  +. m1_10 *. m2_2  +. m1_14 *. m2_3;
    m1_3 *. m2_0  +. m1_7 *. m2_1  +. m1_11 *. m2_2  +. m1_15 *. m2_3;
    m1_0 *. m2_4  +. m1_4 *. m2_5  +. m1_8  *. m2_6  +. m1_12 *. m2_7;
    m1_1 *. m2_4  +. m1_5 *. m2_5  +. m1_9  *. m2_6  +. m1_13 *. m2_7;
    m1_2 *. m2_4  +. m1_6 *. m2_5  +. m1_10 *. m2_6  +. m1_14 *. m2_7;
    m1_3 *. m2_4  +. m1_7 *. m2_5  +. m1_11 *. m2_6  +. m1_15 *. m2_7;
    m1_0 *. m2_8  +. m1_4 *. m2_9  +. m1_8  *. m2_10 +. m1_12 *. m2_11;
    m1_1 *. m2_8  +. m1_5 *. m2_9  +. m1_9  *. m2_10 +. m1_13 *. m2_11;
    m1_2 *. m2_8  +. m1_6 *. m2_9  +. m1_10 *. m2_10 +. m1_14 *. m2_11;
    m1_3 *. m2_8  +. m1_7 *. m2_9  +. m1_11 *. m2_10 +. m1_15 *. m2_11;
    m1_0 *. m2_12 +. m1_4 *. m2_13 +. m1_8  *. m2_14 +. m1_12 *. m2_15;
    m1_1 *. m2_12 +. m1_5 *. m2_13 +. m1_9  *. m2_14 +. m1_13 *. m2_15;
    m1_2 *. m2_12 +. m1_6 *. m2_13 +. m1_10 *. m2_14 +. m1_14 *. m2_15;
    m1_3 *. m2_12 +. m1_7 *. m2_13 +. m1_11 *. m2_14 +. m1_15 *. m2_15;
  |]


let matrix_translate ~matrix (x, y, z) =
  matrix.(12) <- matrix.(0) *. x +. matrix.(4) *. y +. matrix.(8)  *. z +. matrix.(12);
  matrix.(13) <- matrix.(1) *. x +. matrix.(5) *. y +. matrix.(9)  *. z +. matrix.(13);
  matrix.(14) <- matrix.(2) *. x +. matrix.(6) *. y +. matrix.(10) *. z +. matrix.(14);
  matrix.(15) <- matrix.(3) *. x +. matrix.(7) *. y +. matrix.(11) *. z +. matrix.(15);
;;

