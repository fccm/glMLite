(** Quaternions *)
(* OpenGL:Tutorials:Using Quaternions to represent rotation *)
(* from: http://gpwiki.org/index.php/OpenGL:Tutorials:Using_Quaternions_to_represent_rotation *)
(* Content is available under GNU Free Documentation License 1.2 *)
(* http://www.gnu.org/copyleft/fdl.html *)
(* History log of the document, and authors:
26-05-2006 11:39 Tannin (Initial post)
26-05-2006 11:42 Tannin (typo)
25-07-2006 19:05 81.174.37.6 (Just what is a quaternion?)
25-07-2006 19:06 81.174.37.6 (Just what is a quaternion?)
30-07-2006 06:38 203.206.100.123 (How to convert to/from quaternions - fix formatting)
30-07-2006 11:40 203.206.100.123 (add category tags)
03-10-2006 21:10 144.30.108.40 (Some basic quaternion operations)
05-10-2006 08:21 84.56.180.65
30-10-2007 22:41 158.130.58.47 (Just what is a quaternion?)
30-10-2007 22:42 158.130.58.47 (Why use quaternions)
26-11-2007 19:08 151.188.17.247 (Some basic quaternion operations)
27-11-2007 10:25 Codehead (Reverted edit of 151.188.17.247, changed back to last version by 158.130.58.47)
13-01-2008 09:42 Ronguida (Just what is a quaternion?)
13-01-2008 09:48 Ronguida (Why use quaternions)
13-01-2008 09:51 Ronguida (Why use quaternions)
13-01-2008 10:29 Ronguida (Added section "Why quaternions are neat")
13-01-2008 18:28 Ronguida (Some basic quaternion operations)
13-01-2008 18:48 Ronguida (How to convert to/from quaternions)
26-01-2008 06:51 142.167.170.72 (Rotating vectors)
15-01-2009 15:04 83.237.221.197 (access to 'y' variable was ambigous)
06-08-2009 23:10 Geveno (Normalizing a quaternion)
06-08-2009 23:39 Liam (Bug fix)
15-12-2009 01:01 Helge (Error in vector part: You should add the cross-product, not subtract (found the correct answer on Wikipedia))
*)

(* there are only float calculations in this module *)
external ( + ) : float -> float -> float = "%addfloat"
external ( - ) : float -> float -> float = "%subfloat"
external ( * ) : float -> float -> float = "%mulfloat"
external ( / ) : float -> float -> float = "%divfloat"

(*
==== Foreword and warning ====
Quaternions are all the rage these days for (3D) computer games, so this wiki
wouldn't be complete without an explanation about them. Unfortunately, I'm not
exactly a quaternion-specialist, so there might be errors here. I hope someone
with more knowledge on the topic will review this article. Although this article 
is in the OpenGL-section, the background information is of course true for Direct3D
too. As far as I know, D3D also has some convenience functions for Quaternions.

==== Just what is a quaternion? ====
A quaternion is an element of a 4 dimensional vector-space. It's defined as
w + xi + yj + zk where i, j and k are imaginary numbers. Alternatively, a
quaternion is what you get when you add a scalar and a 3d vector.
The math behind quaternions is only slightly harder than the math behind vectors,
but I'm going to spare you (for the moment).

Sounds scary? Ok, so now you know never to ask that question again... 

Fortunately for you, we will only work with a subset of quaternions: unit
quaternions. Those are quaternions with length 1. Every unit quaternion
represents a 3D rotation, and every 3D rotation has two unit quaternion
representations. Unit quaternions are a way to compactly represent 3D rotations
while avoiding singularities or discontinuities (e.g. gimbal lock).

+-------------------------------------+---------------------------------------------+
| Rotation                            | Quaternions                                 |
+-------------------------------------+---------------------------------------------+
| Identity (no rotation)              | 1, -1                                       |
| 180 degrees about x-axis            | i, -i                                       |
| 180 degrees about y-axis            | j, -j                                       |
| 180 degrees about z-axis            | k, -k                                       |
| angle θ, axis (unit vector) \vec{n} | \pm[\cos(\theta/2) + \vec{n}\sin(\theta/2)] |
+-------------------------------------+---------------------------------------------+


==== Why use quaternions ====
Quaternions have some advantages over other representations of rotations.
- Quaternions don't suffer from gimbal lock, unlike Euler angles.
- They can be represented as 4 numbers, in contrast to the 9 numbers of
  a rotations matrix.
- The conversion to and from axis/angle representation is trivial.
- Smooth interpolation between two quaternions is easy (in contrast to
  axis/angle or rotation matrices).
- After a lot of calculations on quaternions and matrices, rounding errors
  accumulate, so you have to normalize quaternions and orthogonalize a rotation
  matrix, but normalizing a quaternion is a lot less troublesome than
  orthogonalizing a matrix.
- Similar to rotation matrices, you can just multiply 2 quaternions together
  to receive a quaternion that represents both rotations.

The only disadvantages of quaternions are:
- They are hard to visualize.
- You have to convert them to get a human-readable representation (Euler angles)
  or something OpenGL can understand (Matrix).
- Smooth interpolation between quaternions is complicated by the fact that each
  3D rotation has two representations.


==== Why quaternions are neat ====
Quaternions are neat because the unit quaternions are a double-cover for the set
of 3D rotations.

To understand what that means, consider a Mobius strip. To make one, start with
a strip of paper and bring the ends together. Give one of the ends a half-twist,
and then attach it to the other end. The resulting surface is a Mobius strip. 

The Mobius strip has a very important feature: it's non-orientable. When I want
to build and render an object, like a sphere or a cylinder, I need to make sure
all my vertex normals point the same way (e.g. outward). If I try to render a
Mobius strip, I'll get stuck because I won't be able to assign consistent
outward-pointing vector normals. That's what it means to be non-orientable. 

The solution to this problem is to simply duplicate each vertex. One copy gets
an "outward" pointing normal, and the other copy gets an "inward" pointing
normal. When I render the Mobius strip, I'll have to draw each polygon twice,
once facing "outward", and again facing "inward". Mathematicians would call
this a double-cover. 

The set of 3D rotations can be thought of as a 3D surface sitting in 4D
hyper-space. Like the Mobius strip, this surface is non-orientable. As a
result, if I try to represent a 3D rotation using three numbers (e.g. Euler
angles), I'll get stuck with either a singularity or a discontinuity. 

Just like with the Mobius strip, I can solve the problem with a double-cover.
I simply duplicate each possible 3D rotation; one copy gets a "positive"
quaternion, and the other copy gets a "negative" quaternion. The resulting
representation is equivalent to a 3-sphere in 4D hyper-space, it's orientable,
and it completely avoids the problem of singularities and discontinuities.


==== Some basic quaternion operations ====
Here are some methods you will regularly need to work with quaternions.
*)

type quaternion =
  { mutable qx:float;
    mutable qy:float;
    mutable qz:float;
    mutable qw:float; }

let quaternion (x,y,z) w =
  { qx = x;  qy = y;  qz = z;  qw = w }

let identity_quaternion () =
  { qx = 0.0;
    qy = 0.0;
    qz = 0.0;
    qw = 1.0; }

(** {3 Normalizing a quaternion} *)

(* normalising a quaternion works similar to a vector. This method will not do anything
   if the quaternion is close enough to being unit-length. define TOLERANCE as something
   small like 0.00001 to get accurate results *)
let normalise quat =
  let tolerance = 0.00001 in
  let x = quat.qx
  and y = quat.qy
  and z = quat.qz
  and w = quat.qw in
  (* Don't normalize if we don't have to *)
  let mag2 = w *. w +. x *. x +. y *. y +. z *. z in
  if (mag2 <> 0.0) && (abs_float(mag2 -. 1.0) > tolerance)
  then begin
    let mag = sqrt mag2 in
    quat.qx <- quat.qx /. mag;
    quat.qy <- quat.qy /. mag;
    quat.qz <- quat.qz /. mag;
    quat.qw <- quat.qw /. mag;
  end

(** {3 The complex conjugate of a quaternion} *)

(* We need to get the inverse of a quaternion to properly apply a
   quaternion-rotation to a vector.
 * The conjugate of a quaternion is the same as the inverse, as long as the
   quaternion is unit-length *)
let getConjugate quat =
  {
    qx = -. quat.qx;
    qy = -. quat.qy;
    qz = -. quat.qz;
    qw = quat.qw;
  }


(** {3 Multiplying quaternions} *)
(*
To multiply two quaternions, write each one as the sum of a scalar and a vector.
The product of
   q_1 = w_1 + \vec{v_1} and q_2 = w_2 + \vec{v_2} is q = w + \vec{v}
where
   w = w_1 w_2 - \vec{v_1} \cdot \vec{v_2}
   \vec{v} = w_1 \vec{v_2} + w_2 \vec{v_1} + \vec{v_1} \times \vec{v_2}
*)

(* Multiplying q1 with q2 applies the rotation q2 to q1 *)
let mult_quaternion q1 rq =
  {
    qx =  q1.qw *. rq.qx +. q1.qx *. rq.qw +. q1.qy *. rq.qz -. q1.qz *. rq.qy;
    qy =  q1.qw *. rq.qy +. q1.qy *. rq.qw +. q1.qz *. rq.qx -. q1.qx *. rq.qz;
    qz =  q1.qw *. rq.qz +. q1.qz *. rq.qw +. q1.qx *. rq.qy -. q1.qy *. rq.qx;
    qw =  q1.qw *. rq.qw -. q1.qx *. rq.qx -. q1.qy *. rq.qy -. q1.qz *. rq.qz;
  }

(*
Please note: Quaternion-multiplication is NOT commutative. Thus q1 * q2 is
not the same as q2 * q1. This is pretty obvious actually: As I explained,
quaternions represent rotations and multiplying them "concatenates" the
rotations. Now take you hand and hold it parallel to the floor so your hand
points away from you. Rotate it 90° around the x-axis so it is pointing upward.
Now rotate it 90° clockwise around its local y-axis (the one coming out of the
back of your hand). Your hand should now be pointing to your right, with you
looking at the back of your hand. Now invert the rotations: Rotate your hand
around the y-axis so its facing right with the back of the hand facing upwards.
Now rotate around the x axis and your hand is pointing up, back of hand facing
your left. See, the order in which you apply rotations matters. Ok, ok, you
probably knew that...
*)


(** {3 Rotating vectors} *)

(*
To apply a quaternion-rotation to a vector, you need to multiply the vector by
the quaternion and its conjugate.
\vec{v}' = q\; \vec{v}\; \overline{q}
*)

let normalise_vector (x,y,z) =
  let len = sqrt(x *. x +. y *. y +. z *. z) in
  (x /. len, y /. len, z /. len)

(* Multiplying a quaternion q with a vector v applies the q-rotation to v *)
let mult_quaternion_vector q vec =

  let vn_x, vn_y, vn_z = normalise_vector vec in
 
  let vecQuat = {
    qx = vn_x;
    qy = vn_y;
    qz = vn_z;
    qw = 0.0;
  } in
 
  let resQuat = mult_quaternion vecQuat (getConjugate q) in
  let resQuat = mult_quaternion q resQuat in
 
  (resQuat.qx, resQuat.qy, resQuat.qz)
;;


(*
==== How to convert to/from quaternions ====
In the following, I will present the methods necessary to convert all kind of
rotation-representations to and from quaternions. I'll not show how to derive
them because, well, who cares? (oh, and because I don't know how) 
*)

(** {3 Quaternion from axis-angle} *)
(*
To rotate through an angle θ, about the axis (unit vector) \vec{v}, use: 
q = \cos(\theta/2) + \vec{v}\sin(\theta/2) 
*)

(* Convert from Axis Angle *)
let quaternion_of_axis vec angle =
  let angle = angle *. 0.5 in
  let vn_x, vn_y, vn_z = normalise_vector vec in
  let sinAngle = sin angle in
  {
    qx = vn_x *. sinAngle;
    qy = vn_y *. sinAngle;
    qz = vn_z *. sinAngle;
    qw = cos angle;
  }
;;

(** {3 Quaternion from Euler angles} *)

let piover180 = 3.14159265358979312 /. 180.0

(* Convert from Euler Angles *)
let quaternion_of_euler ~pitch ~yaw ~roll =
  (* Basically we create 3 Quaternions, one for pitch, one for yaw, one for roll
     and multiply those together.
     the calculation below does the same, just shorter *)

  let p = pitch *. piover180 /. 2.0
  and y = yaw   *. piover180 /. 2.0
  and r = roll  *. piover180 /. 2.0 in
 
  let sinp = sin p
  and siny = sin y
  and sinr = sin r
  and cosp = cos p
  and cosy = cos y
  and cosr = cos r in
 
  let q = {
    qx = sinr *. cosp *. cosy -. cosr *. sinp *. siny;
    qy = cosr *. sinp *. cosy +. sinr *. cosp *. siny;
    qz = cosr *. cosp *. siny -. sinr *. sinp *. cosy;
    qw = cosr *. cosp *. cosy +. sinr *. sinp *. siny;
  } in
  normalise q;
  (q)
;;


(** {3 Quaternion to Matrix} *)

(* Convert to Matrix *)
let matrix_of_quaternion quat =
  let x = quat.qx
  and y = quat.qy
  and z = quat.qz
  and w = quat.qw in

  let x2 = x * x
  and y2 = y * y
  and z2 = z * z
  and xy = x * y
  and xz = x * z
  and yz = y * z
  and wx = w * x
  and wy = w * y
  and wz = w * z in
 
  (* This calculation would be a lot more complicated for non-unit length quaternions
     Note: The constructor of Matrix4 expects the Matrix in column-major format like
           expected by OpenGL *)
  [|
    1.0 - 2.0 * (y2 + z2); 2.0 * (xy - wz); 2.0 * (xz + wy); 0.0;
    2.0 * (xy + wz); 1.0 - 2.0 * (x2 + z2); 2.0 * (yz - wx); 0.0;
    2.0 * (xz - wy); 2.0 * (yz + wx); 1.0 - 2.0 * (x2 + y2); 0.0;
    0.0; 0.0; 0.0; 1.0;
  |]
;;


(** {3 Quaternion to axis-angle} *)

(*
Given a quaternion q = w + \vec{v}, the (non-normalized) rotation axis is simply
\vec{v}, provided that an axis exists. For very small rotations, \vec{v} gets
close to the zero vector, so when we compute the normalized rotation axis, the
calculation may blow up. In particular, the identity rotation has \vec{v} = 0,
so the rotation axis is undefined. 
To find the angle of rotation, note that w = cos(θ / 2) and \|v\| = \sin(\theta/2).
*)

(* Convert to Axis/Angles *)
let axisAngle_of_quaternion quat =
  let x = quat.qx
  and y = quat.qy
  and z = quat.qz
  and w = quat.qw in
  let scale = sqrt(x * x + y * y + z * z) in
  let axis =
    ( x / scale,
      y / scale,
      z / scale )
  and angle = (acos w) * 2.0 in
  (axis, angle)
;;

(*
==== Example ====
Ok, with the above Quaternion class, It's very simple to create a camera class
that has one such Quaternion to represent its orientation: 
*)

let vectors_add (x1,y1,z1) (x2,y2,z2) =
  (x1+x2, y1+y2, z1+z2)

class camera =
  object (s)
    val mutable pos = (0.0, 0.0, 0.0)
    val mutable rotation = identity_quaternion ()

    val mutable xrot = 0.0
    val mutable yrot = 0.0
    val mutable xmov = 0.0
    val mutable ymov = 0.0
    val mutable zmov = 0.0
    val mutable rotspeed  = 0.0
    val mutable movespeed = 0.0

    method get_pos = pos
    method get_rotation = rotation

    method set_pos v = pos <- v
    method set_rotation r = rotation <- r

    method set_xrot v = xrot <- v
    method set_yrot v = yrot <- v
    method set_xmov v = xmov <- v
    method set_ymov v = ymov <- v
    method set_zmov v = zmov <- v
    method set_rotspeed  v = rotspeed  <- v
    method set_movespeed v = movespeed <- v

    method movex xmmod =
      let vec = mult_quaternion_vector rotation (xmmod, 0.0, 0.0) in
      pos <- vectors_add pos vec;

    method movey ymmod =
      let x, y, z = pos in
      let new_pos = (x, y - ymmod, z) in
      pos <- new_pos;

    method movez zmmod =
      let vec = mult_quaternion_vector rotation (0.0, 0.0, -. zmmod) in
      pos <- vectors_add pos vec;

    method rotatex xrmod =
      let nrot = { qx = 1.0; qy = 0.0; qz = 0.0; qw = xrmod * piover180 } in
      rotation <- mult_quaternion rotation nrot;  (* TODO: check if the order is right *)
 
    method rotatey yrmod =
      let nrot = quaternion (0.0, 1.0, 0.0) (yrmod * piover180) in
      rotation <- mult_quaternion nrot rotation;  (* TODO: check if the order is right *)
 
    method tick seconds =
      if (xrot <> 0.0) then s#rotatex(xrot * seconds * rotspeed);
      if (yrot <> 0.0) then s#rotatey(yrot * seconds * rotspeed);

      if (xmov <> 0.0) then s#movex(xmov * seconds * movespeed);
      if (ymov <> 0.0) then s#movey(ymov * seconds * movespeed);
      if (zmov <> 0.0) then s#movez(zmov * seconds * movespeed);

  end
;;

(*
In this code, xrot, yrot, xmov, ymov and zmov are floats representing how fast
the player wants to rotate/move around/on this axis. "seconds" is the time
passed since the last call to tick. rotspeed and movespeed represent how fast
the camera can rotate or move. piover180 is defined as pi/180, so multiplying
with it converts from degrees to radians.

You might be wondering why in rotatex we multiply "rotation * nrot" and in
rotatey "nrot * rotation". As I said, multiplication is not commutative. The
first rotates the existing quaternion around x (looking up and down), the second
rotates an upward-quaternion around the existing rotation. This way, we look
left/right around the global y-axis, while rotation up/down is around the local
x-axis. This is the behaviour you have in a 3D shooter. Try to change the order
of rotations to see what happens.
*)

