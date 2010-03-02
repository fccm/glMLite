
let get_matrix4_identity() =
  [| 1.0; 0.0; 0.0; 0.0;
     0.0; 1.0; 0.0; 0.0;
     0.0; 0.0; 1.0; 0.0;
     0.0; 0.0; 0.0; 1.0; |]
;;

(* construct a projection matrix *)
let projection_matrix ~fov ~aspect ~near_plane ~far_plane =

  let maxY = near_plane *. tan (fov *. 3.14159256 /. 360.0) in
  let minY = -. maxY in
  let minX = minY *. aspect
  and maxX = maxY *. aspect in

  let data = Array.make 16 0.0 in

  data.(0) <- 2.0 *. near_plane /. (maxX -. minX);
  data.(5) <- 2.0 *. near_plane /. (maxY -. minY);
  data.(8) <- (maxX +. minX) /. (maxX -. minX);
  data.(9) <- (maxY +. minY) /. (maxY -. minY);
  data.(10) <- -. (far_plane +. near_plane) /. (far_plane -. near_plane);
  data.(11) <- -. 1.0;
  data.(14) <- -. (2.0 *. far_plane *. near_plane) /. (far_plane -. near_plane);

  (data)
;;

(* construct a transformation matrix from a translation *)
let transformation_matrix (x,y,z) =
  let data = get_matrix4_identity() in
  data.(12) <- data.(12) +. x;
  data.(13) <- data.(13) +. y;
  data.(14) <- data.(14) +. z;
  (data)
;;

(* multiply two matrices *)
let mult_matrix4 ~mat1 ~mat2 =
  if Array.length mat1 <> 16
  || Array.length mat2 <> 16
  then invalid_arg "mult_Matrix4";

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

