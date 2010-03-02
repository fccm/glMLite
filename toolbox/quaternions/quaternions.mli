type quaternion = {
  mutable qx : float;
  mutable qy : float;
  mutable qz : float;
  mutable qw : float;
}
val quaternion : float * float * float -> float -> quaternion
val identity_quaternion : unit -> quaternion
val normalise : quaternion -> unit
val getConjugate : quaternion -> quaternion
val mult_quaternion : quaternion -> quaternion -> quaternion
val normalise_vector : float * float * float -> float * float * float
val mult_quaternion_vector :
  quaternion -> float * float * float -> float * float * float
val quaternion_of_axis : float * float * float -> float -> quaternion
val quaternion_of_euler :
  pitch:float -> yaw:float -> roll:float -> quaternion
val matrix_of_quaternion : quaternion -> float array
val axisAngle_of_quaternion : quaternion -> (float * float * float) * float
val vectors_add :
  float * float * float -> float * float * float -> float * float * float
class camera :
  object
    val mutable movespeed : float
    val mutable pos : float * float * float
    val mutable rotation : quaternion
    val mutable rotspeed : float
    val mutable xmov : float
    val mutable xrot : float
    val mutable ymov : float
    val mutable yrot : float
    val mutable zmov : float
    method get_pos : float * float * float
    method get_rotation : quaternion
    method movex : float -> unit
    method movey : float -> unit
    method movez : float -> unit
    method rotatex : float -> unit
    method rotatey : float -> unit
    method set_movespeed : float -> unit
    method set_pos : float * float * float -> unit
    method set_rotation : quaternion -> unit
    method set_rotspeed : float -> unit
    method set_xmov : float -> unit
    method set_xrot : float -> unit
    method set_ymov : float -> unit
    method set_yrot : float -> unit
    method set_zmov : float -> unit
    method tick : float -> unit
  end
