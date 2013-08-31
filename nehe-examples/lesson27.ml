(*              The following linux/GLUT port by Jeff Pound, 2004
 *
 *      This code has been created by Banu Octavian aka Choko - 20 may 2000
 *      and uses NeHe tutorials as a starting point (window initialization,
 *      texture loading, GL initialization and code for keypresses) - very good
 *      tutorials, Jeff. If anyone is interested about the presented algorithm
 *      please e-mail me at boct@romwest.ro
 *      Attention!!! This code is not for beginners.
 *)
(* The full tutorial associated with this file is available here:
   http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=09 *)

(* (OCaml version by Florent Monnier) *)

open GL       (* Module For The OpenGL Library *)
open Glu      (* Module For The GLu Library *)
open Glut     (* Module For The GLUT Library *)

let strip ?(chars=" \t\r\n") s =
  let p = ref 0 in
  let l = String.length s in
  while !p < l && String.contains chars (String.unsafe_get s !p) do
    incr p;
  done;
  let p = !p in
  let l = ref (l - 1) in
  while !l >= p && String.contains chars (String.unsafe_get s !l) do
    decr l;
  done;
  String.sub s p (!l - p + 1)
;;


module T3Dobject = struct

(* vertex in 3d-coordinate system *)
type sPoint = float * float * float

(* plane equation *)
type sPlaneEq = {
  mutable a: float;
  mutable b: float;
  mutable c: float;
  mutable d: float;
}

(* structure describing an object's face *)
type sPlane = {
  p: int array;
  normals: sPoint array;
  neigh: int array;
  planeEq: sPlaneEq;
  mutable visible: bool;
}

(* object structure *)
type glObject = {
  nPlanes: int;
  nPoints: int;
  points: sPoint array;
  planes: sPlane array;
}


(* load object *)
let readObject ~st =
  let ic = open_in st in
  let rec input ic =
    let s = strip(input_line ic) in
    if s <> "" then (s) else input ic
  in
  (* points *)
  let s = input ic in
  let nPoints = Scanf.sscanf s "%d" (fun n -> n) in
  let points =
    Array.init (succ nPoints) (function 0 -> (0.0, 0.0, 0.0)
    | _ ->
      let s = input ic in
      Scanf.sscanf s "%f %f %f" (fun x y z -> (x, y, z))
    )
  in
  (* planes *)
  let s = input ic in
  let nPlanes = Scanf.sscanf s "%d" (fun n -> n) in
  let planes =
    Array.init nPlanes (fun _ ->
      let s = input ic in
      Scanf.sscanf s "%d %d %d %f %f %f %f %f %f %f %f %f"
        (fun p0 p1 p2 x0 y0 z0 x1 y1 z1 x2 y2 z2 ->
           { p = [| p0; p1; p2 |];
             normals = [| (x0, y0, z0);
                          (x1, y1, z1);
                          (x2, y2, z2); |];
             neigh = [| 0; 0; 0 |];
             planeEq = { a=0.0; b=0.0; c=0.0; d=0.0 };
             visible = false;
           }
        )
    )
  in
  close_in ic;
  { nPoints = nPoints;
    nPlanes = nPlanes;
    points = points;
    planes = planes;
  }
;;


(* connectivity procedure - based on Gamasutra's article
   hard to explain here *)
let setConnectivity (o : glObject) =

  for i = 0 to o.nPlanes - 2 do
    for j = i+1 to pred o.nPlanes do
      for ki = 0 to pred 3 do
        if o.planes.(i).neigh.(ki) = 0 then begin
          for kj = 0 to pred 3 do
            let p1i = ki
            and p1j = kj in
            let p2i = (ki+1) mod 3
            and p2j = (kj+1) mod 3 in

            let p1i = o.planes.(i).p.(p1i)
            and p2i = o.planes.(i).p.(p2i)
            and p1j = o.planes.(j).p.(p1j)
            and p2j = o.planes.(j).p.(p2j) in

            let _P1i = ((p1i+p2i)-abs(p1i-p2i))/2
            and _P2i = ((p1i+p2i)+abs(p1i-p2i))/2
            and _P1j = ((p1j+p2j)-abs(p1j-p2j))/2
            and _P2j = ((p1j+p2j)+abs(p1j-p2j))/2 in

            if ((_P1i = _P1j) && (_P2i = _P2j)) then begin  (* they are neighbours *)
              o.planes.(i).neigh.(ki) <- j+1;   
              o.planes.(j).neigh.(kj) <- i+1;   
            end
          done
        end
      done
    done
  done
;;


(* function for computing a plane equation given 3 points *)
let calcPlane (o : glObject) (plane : sPlane) =

  let v1x, v1y, v1z = o.points.(plane.p.(0))
  and v2x, v2y, v2z = o.points.(plane.p.(1))
  and v3x, v3y, v3z = o.points.(plane.p.(2)) in

  plane.planeEq.a <- v1y*.(v2z-.v3z) +. v2y*.(v3z-.v1z) +. v3y*.(v1z-.v2z);
  plane.planeEq.b <- v1z*.(v2x-.v3x) +. v2z*.(v3x-.v1x) +. v3z*.(v1x-.v2x);
  plane.planeEq.c <- v1x*.(v2y-.v3y) +. v2x*.(v3y-.v1y) +. v3x*.(v1y-.v2y);
  plane.planeEq.d <- -.( v1x *. (v2y*.v3z -. v3y*.v2z) +.
                         v2x *. (v3y*.v1z -. v1y*.v3z) +.
                         v3x *. (v1y*.v2z -. v2y*.v1z) );
;;


(* procedure for drawing the object - very simple *)
let drawGLObject (o : glObject) =
  glBegin GL_TRIANGLES;
  for i = 0 to pred o.nPlanes do
    for j = 0 to pred 3 do
      glNormal3v o.planes.(i).normals.(j);
      glVertex3v o.points.(o.planes.(i).p.(j));
    done;
  done;
  glEnd();
;;


let castShadow o lp =

  let v1x, v1y, v1z = ref 0., ref 0., ref 0. in
  let v2x, v2y, v2z = ref 0., ref 0., ref 0. in

  (* set visual parameter *)
  for i = 0 to pred o.nPlanes do
    (* chech to see if light is in front or behind the plane (face plane) *)
    let side = o.planes.(i).planeEq.a *. lp.(0) +.
               o.planes.(i).planeEq.b *. lp.(1) +.
               o.planes.(i).planeEq.c *. lp.(2) +.
               o.planes.(i).planeEq.d *. lp.(3) in
    if side > 0.0
    then o.planes.(i).visible <- true
    else o.planes.(i).visible <- false
  done;

  glDisable GL_LIGHTING;
  glDepthMask false;
  glDepthFunc GL_LEQUAL;

  glEnable GL_STENCIL_TEST;
  glColorMask false false false false;
  glStencilFuncn GL_ALWAYS 1 0xffffffffn;

  (* first pass, stencil operation decreases stencil value *)
  glFrontFace GL_CCW;
  glStencilOp GL_KEEP GL_KEEP GL_INCR;
  for i = 0 to pred o.nPlanes do
    if o.planes.(i).visible then begin
      for j = 0 to pred 3 do
        let k = o.planes.(i).neigh.(j) in
        if ((k = 0) || not(o.planes.(k-1).visible)) then begin
          (* here we have an edge, we must draw a polygon *)
          let p1 = o.planes.(i).p.(j)
          and jj = (j+1) mod 3 in
          let p2 = o.planes.(i).p.(jj) in

          (* calculate the length of the vector *)
          let p1x, p1y, p1z = o.points.(p1) in
          v1x := (p1x -. lp.(0)) *. 100.;
          v1y := (p1y -. lp.(1)) *. 100.;
          v1z := (p1z -. lp.(2)) *. 100.;

          let p2x, p2y, p2z = o.points.(p2) in
          v2x := (p2x -. lp.(0)) *. 100.;
          v2y := (p2y -. lp.(1)) *. 100.;
          v2z := (p2z -. lp.(2)) *. 100.;
          
          (* draw the polygon *)
          glBegin GL_TRIANGLE_STRIP;
            glVertex3v o.points.(p1);
            let x, y, z = o.points.(p1) in
            glVertex3 (x +. !v1x)
                      (y +. !v1y)
                      (z +. !v1z);

            glVertex3v o.points.(p2);
            let x, y, z = o.points.(p2) in
            glVertex3 (x +. !v2x)
                      (y +. !v2y)
                      (z +. !v2z);
          glEnd();
        end;
      done;
    end;
  done;

  (* second pass, stencil operation increases stencil value *)
  glFrontFace GL_CW;
  glStencilOp GL_KEEP GL_KEEP GL_DECR;
  for i = 0 to pred o.nPlanes do
    if o.planes.(i).visible then begin
      for j = 0 to pred 3 do
        let k = o.planes.(i).neigh.(j) in
        if ((k = 0) || not(o.planes.(k-1).visible)) then begin
          (* here we have an edge, we must draw a polygon *)
          let p1 = o.planes.(i).p.(j)
          and jj = (j+1) mod 3 in
          let p2 = o.planes.(i).p.(jj) in

          (* calculate the length of the vector *)
          let p1x, p1y, p1z = o.points.(p1) in
          v1x := (p1x -. lp.(0)) *. 100.;
          v1y := (p1y -. lp.(1)) *. 100.;
          v1z := (p1z -. lp.(2)) *. 100.;

          let p2x, p2y, p2z = o.points.(p2) in
          v2x := (p2x -. lp.(0)) *. 100.;
          v2y := (p2y -. lp.(1)) *. 100.;
          v2z := (p2z -. lp.(2)) *. 100.;
          
          (* draw the polygon *)
          glBegin GL_TRIANGLE_STRIP;
            glVertex3v o.points.(p1);
            let x, y, z = o.points.(p1) in
            glVertex3 (x +. !v1x)
                      (y +. !v1y)
                      (z +. !v1z);

            glVertex3v o.points.(p2);
            let x, y, z = o.points.(p2) in
            glVertex3 (x +. !v2x)
                      (y +. !v2y)
                      (z +. !v2z);
          glEnd();
        end;
      done;
    end;
  done;

  glFrontFace GL_CCW;
  glColorMask true true true true;

  (* draw a shadowing rectangle covering the entire screen *)
  glColor4 0.0 0.0 0.0 0.4;
  glEnable GL_BLEND;
  glBlendFunc Sfactor.GL_SRC_ALPHA  Dfactor.GL_ONE_MINUS_SRC_ALPHA;
  glStencilFuncn GL_NOTEQUAL 0 0xffffffffn;
  glStencilOp GL_KEEP GL_KEEP GL_KEEP;
  glPushMatrix();
  glLoadIdentity();
  glBegin GL_TRIANGLE_STRIP;
    glVertex3 (-0.1) ( 0.1) (-0.10);
    glVertex3 (-0.1) (-0.1) (-0.10);
    glVertex3 ( 0.1) ( 0.1) (-0.10);
    glVertex3 ( 0.1) (-0.1) (-0.10);
  glEnd();
  glPopMatrix();
  glDisable GL_BLEND;

  glDepthFunc GL_LEQUAL;
  glDepthMask true;
  glEnable GL_LIGHTING;
  glDisable GL_STENCIL_TEST;
  glShadeModel GL_SMOOTH;
;;

end

open T3Dobject

let ( += ) a b = a := !a +. b
let ( -= ) a b = a := !a -. b

let ( +=. ) a i b = a.(i) <- a.(i) +. b
let ( -=. ) a i b = a.(i) <- a.(i) -. b


let xrot = ref 0.0 and xspeed = ref 0.0                 (* X Rotation & X Speed *)
let yrot = ref 0.0 and yspeed = ref 0.0                 (* Y Rotation & Y Speed *)

let lightPos = [|0.0;  5.0; -4.0; 1.0 |]                (* Light Position *)
let lightAmb = ( 0.2,  0.2,  0.2, 1.0)                  (* Ambient Light Values *)
let lightDif = ( 0.6,  0.6,  0.6, 1.0)                  (* Diffuse Light Values *)
let lightSpc = (-0.2, -0.2, -0.2, 1.0)                  (* Specular Light Values *)

let matAmb = (0.4, 0.4, 0.4, 1.0)                       (* Material - Ambient Values *)
let matDif = (0.2, 0.6, 0.9, 1.0)                       (* Material - Diffuse Values *)
let matSpc = (0.0, 0.0, 0.0, 1.0)                       (* Material - Specular Values *)
let matShn = (0.0)                                      (* Material - Shininess *)

let objPos = [| -2.0; -2.0; -5.0 |]                     (* Object Position *)

let spherePos = [| -4.0; -5.0; -6.0 |]


let vMatMult m v =
  let res = [|                                          (* Hold Calculated Results *)
    m.(0) *. v.(0) +. m.(4) *. v.(1) +. m.( 8) *. v.(2) +. m.(12) *. v.(3);
    m.(1) *. v.(0) +. m.(5) *. v.(1) +. m.( 9) *. v.(2) +. m.(13) *. v.(3);
    m.(2) *. v.(0) +. m.(6) *. v.(1) +. m.(10) *. v.(2) +. m.(14) *. v.(3);
    m.(3) *. v.(0) +. m.(7) *. v.(1) +. m.(11) *. v.(2) +. m.(15) *. v.(3);
  |] in
  v.(0) <- res.(0);                                     (* Results Are Stored Back In v[] *)
  v.(1) <- res.(1);
  v.(2) <- res.(2);
  v.(3) <- res.(3);                                     (* Homogenous Coordinate *)
;;


let resizeGLScene ~width ~height =                      (* Resize And Initialize The GL Window *)

  let height =
    if height = 0                                       (* Prevent A Divide By Zero By *)
    then 1                                              (* Making Height Equal One *)
    else height
  in
  glViewport 0 0 width height;                          (* Reset The Current Viewport *)

  glMatrixMode GL_PROJECTION;                           (* Select The Projection Matrix *)
  glLoadIdentity();                                     (* Reset The Projection Matrix *)

  (* Calculate The Aspect Ratio Of The Window *)
  gluPerspective 45.0 (float width /. float height) 0.001 100.0;

  glMatrixMode GL_MODELVIEW;                            (* Select The Modelview Matrix *)
  glLoadIdentity();                                     (* Reset The Modelview Matrix *)
;;


let initGLObjects() =                                   (* Initialize Objects *)
  let obj = T3Dobject.readObject "Data/lesson27/Object2.txt" in (* Read Object2 Into obj *)

  T3Dobject.setConnectivity obj;                        (* Set Face To Face Connectivity *)

  for i = 0 to pred obj.nPlanes do                      (* Loop Through All Object Planes *)
    calcPlane obj obj.planes.(i);                       (* Compute Plane Equations For All Faces *)
  done;
  (obj)
;;


let initGL() =                                          (* All Setup For OpenGL Goes Here *)
  let obj = initGLObjects() in                          (* Function For Initializing Our Object(s) *)
  glShadeModel GL_SMOOTH;                               (* Enable Smooth Shading *)
  glClearColor 0.0 0.0 0.0 0.5;                         (* Black Background *)
  glClearDepth 1.0;                                     (* Depth Buffer Setup *)
  glClearStencil 0;                                     (* Stencil Buffer Setup *)
  glEnable GL_DEPTH_TEST;                               (* Enables Depth Testing *)
  glDepthFunc GL_LEQUAL;                                (* The Type Of Depth Testing To Do *)
  glHint GL_PERSPECTIVE_CORRECTION_HINT  GL_NICEST;     (* Really Nice Perspective Calculations *)

  let _lightPos = (lightPos.(0), lightPos.(1), lightPos.(2), lightPos.(3)) in
  glLight (GL_LIGHT 1) (Light.GL_POSITION _lightPos);   (* Set Light1 Position *)
  glLight (GL_LIGHT 1) (Light.GL_AMBIENT lightAmb);     (* Set Light1 Ambience *)
  glLight (GL_LIGHT 1) (Light.GL_DIFFUSE lightDif);     (* Set Light1 Diffuse *)
  glLight (GL_LIGHT 1) (Light.GL_SPECULAR lightSpc);    (* Set Light1 Specular *)
  glEnable GL_LIGHT1;                                   (* Enable Light1 *)
  glEnable GL_LIGHTING;                                 (* Enable Lighting *)

  glMaterial GL_FRONT (Material.GL_AMBIENT matAmb);     (* Set Material Ambience *)
  glMaterial GL_FRONT (Material.GL_DIFFUSE matDif);     (* Set Material Diffuse *)
  glMaterial GL_FRONT (Material.GL_SPECULAR matSpc);    (* Set Material Specular *)
  glMaterial GL_FRONT (Material.GL_SHININESS matShn);   (* Set Material Shininess *)

  glCullFace GL_BACK;                                   (* Set Culling Face To Back Face *)
  glEnable GL_CULL_FACE;                                (* Enable Culling *)
  glClearColor 0.1 1.0 0.5 1.0;                         (* Set Clear Color (Greenish Color) *)

  let q = gluNewQuadric() in                            (* Initialize Quadratic For Drawing A Sphere *)
  gluQuadricNormals q GLU_SMOOTH;                       (* Enable Smooth Normal Generation *)
  gluQuadricTexture q false;                            (* Disable Auto Texture Coords *)
  (q, obj)
;;


let drawGLRoom() =                                      (* Draw The Room (Box) *)
  glBegin GL_QUADS;                                     (* Begin Drawing Quads *)
  (* Floor *)
  glNormal3 (0.0) (1.0) (0.0);                          (* Normal Pointing Up *)
  glVertex3 (-10.0)(-10.0)(-20.0);                      (* Back Left *)
  glVertex3 (-10.0)(-10.0)( 20.0);                      (* Front Left *)
  glVertex3 ( 10.0)(-10.0)( 20.0);                      (* Front Right *)
  glVertex3 ( 10.0)(-10.0)(-20.0);                      (* Back Right *)
  (* Ceiling *)
  glNormal3 (0.0)(-1.0) (0.0);                          (* Normal Point Down *)
  glVertex3 (-10.0)( 10.0)( 20.0);                      (* Front Left *)
  glVertex3 (-10.0)( 10.0)(-20.0);                      (* Back Left *)
  glVertex3 ( 10.0)( 10.0)(-20.0);                      (* Back Right *)
  glVertex3 ( 10.0)( 10.0)( 20.0);                      (* Front Right *)
  (* Front Wall *)
  glNormal3 (0.0) (0.0) (1.0);                          (* Normal Pointing Away From Viewer *)
  glVertex3 (-10.0)( 10.0)(-20.0);                      (* Top Left *)
  glVertex3 (-10.0)(-10.0)(-20.0);                      (* Bottom Left *)
  glVertex3 ( 10.0)(-10.0)(-20.0);                      (* Bottom Right *)
  glVertex3 ( 10.0)( 10.0)(-20.0);                      (* Top Right *)
  (* Back Wall *)
  glNormal3 (0.0) (0.0)(-1.0);                          (* Normal Pointing Towards Viewer *)
  glVertex3 ( 10.0)( 10.0)( 20.0);                      (* Top Right *)
  glVertex3 ( 10.0)(-10.0)( 20.0);                      (* Bottom Right *)
  glVertex3 (-10.0)(-10.0)( 20.0);                      (* Bottom Left *)
  glVertex3 (-10.0)( 10.0)( 20.0);                      (* Top Left *)
  (* Left Wall *)
  glNormal3 (1.0) (0.0) (0.0);                          (* Normal Pointing Right *)
  glVertex3 (-10.0)( 10.0)( 20.0);                      (* Top Front *)
  glVertex3 (-10.0)(-10.0)( 20.0);                      (* Bottom Front *)
  glVertex3 (-10.0)(-10.0)(-20.0);                      (* Bottom Back *)
  glVertex3 (-10.0)( 10.0)(-20.0);                      (* Top Back *)
  (* Right Wall *)
  glNormal3 (-1.0) (0.0) (0.0);                         (* Normal Pointing Left *)
  glVertex3 ( 10.0)( 10.0)(-20.0);                      (* Top Back *)
  glVertex3 ( 10.0)(-10.0)(-20.0);                      (* Bottom Back *)
  glVertex3 ( 10.0)(-10.0)( 20.0);                      (* Bottom Front *)
  glVertex3 ( 10.0)( 10.0)( 20.0);                      (* Top Front *)
  glEnd();                                              (* Done Drawing Quads *)
;;


let drawGLScene q obj () =                              (* Main Drawing Routine *)

  (* Clear Color Buffer, Depth Buffer, Stencil Buffer *)
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT; GL_STENCIL_BUFFER_BIT];
    
  glLoadIdentity();                                     (* Reset Modelview Matrix *)
  glTranslate (0.0) (0.0) (-20.0);                      (* Zoom Into Screen 20 Units *)
  let _lightPos = (lightPos.(0), lightPos.(1), lightPos.(2), lightPos.(3)) in
  glLight (GL_LIGHT 1) (Light.GL_POSITION _lightPos);    (* Position Light1 *)
  glTranslate spherePos.(0) spherePos.(1) spherePos.(2); (* Position The Sphere *)
  gluSphere q 1.5 32 16;                                (* Draw A Sphere *)

  (* calculate light's position relative to local coordinate system
     dunno if this is the best way to do it, but it actually works
     if u find another aproach, let me know ;) *)

  (* we build the inversed matrix by doing all the actions in reverse order
     and with reverse parameters (notice -xrot, -yrot, -objPos[], etc.) *)
  glLoadIdentity();                                 (* Reset Matrix *)
  glRotate (-. !yrot) 0.0 1.0 0.0;                  (* Rotate By -yrot On Y Axis *)
  glRotate (-. !xrot) 1.0 0.0 0.0;                  (* Rotate By -xrot On X Axis *)
  let minv = glGetMatrixFlat Get.GL_MODELVIEW_MATRIX in (* Retrieve ModelView Matrix (Stores In minv) *)
  let lp = Array.copy lightPos in           (* Store Light Position In lp *)
  vMatMult minv lp;                                 (* We Store Rotated Light Vector In 'lp' Array *)
  glTranslate (-. objPos.(0)) (-. objPos.(1)) (-. objPos.(2)); (* Move Negative On All Axis Based On objPos Values (X, Y, Z) *)
  let minv = glGetMatrixFlat Get.GL_MODELVIEW_MATRIX in (* Retrieve ModelView Matrix From minv *)
  let wlp = [| 0.0; 0.0; 0.0; 1.0 |] in             (* World Local Coords *)
  vMatMult minv wlp;                                (* We Store The Position Of The World Origin Relative To The *)
  (* Local Coord. System In 'wlp' Array *)
  (lp +=. 0) wlp.(0);                               (* Adding These Two Gives Us The *)
  (lp +=. 1) wlp.(1);                               (* Position Of The Light Relative To *)
  (lp +=. 2) wlp.(2);                               (* The Local Coordinate System *)

  glColor4 0.7 0.4 0.0 1.0;                         (* Set Color To An Orange *)
  glLoadIdentity();                                 (* Reset Modelview Matrix *)
  glTranslate 0.0 0.0 (-20.0);                      (* Zoom Into The Screen 20 Units *)
  drawGLRoom();                                     (* Draw The Room *)
  glTranslate objPos.(0) objPos.(1) objPos.(2);     (* Position The Object *)
  glRotate !xrot 1.0 0.0 0.0;                       (* Spin It On The X Axis By xrot *)
  glRotate !yrot 0.0 1.0 0.0;                       (* Spin It On The Y Axis By yrot *)
  drawGLObject obj;                                 (* Procedure For Drawing The Loaded Object *)
  castShadow obj lp;                                (* Procedure For Casting The Shadow Based On The Silhouette *)

  glColor4 0.7 0.4 0.0 1.0;                         (* Set Color To Purplish Blue *)
  glDisable GL_LIGHTING;                            (* Disable Lighting *)
  glDepthMask false;                                (* Disable Depth Mask *)
  glTranslate lp.(0) lp.(1) lp.(2);                 (* Translate To Light's Position *)
  (* Notice We're Still In Local Coordinate System *)
  gluSphere q 0.2 16 8;                             (* Draw A Little Yellow Sphere (Represents Light) *)
  glEnable GL_LIGHTING;                             (* Enable Lighting *)
  glDepthMask true;                                 (* Enable Depth Mask *)

  xrot += !xspeed;
  yrot += !yspeed;

  glFlush();
  glutSwapBuffers();
;;


let specialFunc ~key ~x ~y =                    (* Process Key Presses *)
  match key with
  | GLUT_KEY_LEFT  -> yspeed -= 0.1;            (* 'Arrow Left' Decrease yspeed *)
  | GLUT_KEY_RIGHT -> yspeed += 0.1;            (* 'Arrow Right' Increase yspeed *)
  | GLUT_KEY_UP    -> xspeed -= 0.1;            (* 'Arrow Up' Decrease xspeed *)
  | GLUT_KEY_DOWN  -> xspeed += 0.1;            (* 'Arrow Down' Increase xspeed *)
  | _ -> ()
;;


let keyFunc ~key ~x ~y =
  match key with
  (* Adjust Light's Position *)
  | 'L' | 'l' -> (lightPos +=. 0) 0.05;         (* 'L' Moves Light Right *)
  | 'J' | 'j' -> (lightPos -=. 0) 0.05;         (* 'J' Moves Light Left *)

  | 'I' | 'i' -> (lightPos +=. 1) 0.05;         (* 'I' Moves Light Up *)
  | 'K' | 'k' -> (lightPos -=. 1) 0.05;         (* 'K' Moves Light Down *)

  | 'O' | 'o' -> (lightPos +=. 2) 0.05;         (* 'O' Moves Light Toward Viewer *)
  | 'U' | 'u' -> (lightPos -=. 2) 0.05;         (* 'U' Moves Light Away From Viewer *)

  (* Adjust Object's Position *)
  | '6' -> (objPos +=. 0) 0.05;                 (* 'Numpad6' Move Object Right *)
  | '4' -> (objPos -=. 0) 0.05;                 (* 'Numpad4' Move Object Left *)

  | '8' -> (objPos +=. 1) 0.05;                 (* 'Numpad8' Move Object Up *)
  | '5' -> (objPos -=. 1) 0.05;                 (* 'Numpad5' Move Object Down *)

  | '9' -> (objPos +=. 2) 0.05;                 (* 'Numpad9' Move Object Toward Viewer *)
  | '7' -> (objPos -=. 2) 0.05;                 (* 'Numpad7' Move Object Away From Viewer *)

  (* Adjust Ball's Position *)
  | 'D' | 'd' -> (spherePos +=. 0) 0.05;        (* 'D' Move Ball Right *)
  | 'A' | 'a' -> (spherePos -=. 0) 0.05;        (* 'A' Move Ball Left *)

  | 'W' | 'w' -> (spherePos +=. 1) 0.05;        (* 'W' Move Ball Up *)
  | 'S' | 's' -> (spherePos -=. 1) 0.05;        (* 'S' Move Ball Down *)

  | 'E' | 'e' -> (spherePos +=. 2) 0.05;        (* 'E' Move Ball Toward Viewer *)
  | 'Q' | 'q' -> (spherePos -=. 2) 0.05;        (* 'Q' Move Ball Away From Viewer *)
  | '\027' ->    (* Escape key *)
      exit(0);
  | _ -> ()
;;


(* initialize everything and enter the main loop *)
let () =
  let _ = glutInit Sys.argv in
  glutInitWindowSize 800 600;
  glutInitDisplayMode [GLUT_RGB; GLUT_DOUBLE; GLUT_STENCIL; GLUT_DEPTH];
  let _ = glutCreateWindow "Banu Octavian & NeHe's Shadow Casting Tutorial" in

  let q, obj = initGL() in

  glutDisplayFunc (drawGLScene q obj);
  glutIdleFunc (drawGLScene q obj);
  glutKeyboardFunc keyFunc;
  glutSpecialFunc specialFunc;
  glutReshapeFunc resizeGLScene;
  
  glutMainLoop();
;;

