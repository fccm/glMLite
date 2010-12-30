open Printf
open LablGL

let pi = 4. *. atan 1.

module Array = struct
  include Array

  let for_all p a =
    fold_left (fun b x -> p x && b) true a
end

type vec2 = { x: float; y: float }

let vec2 x y = {x=x; y=y}

let zero = vec2 0. 0.

let of_list = function
    [x; y] -> vec2 x y
  | _ -> invalid_arg "Vec2.of_list"

let ( +| ) a b = {x = a.x +. b.x; y = a.y +. b.y}
let ( -| ) a b = {x = a.x -. b.x; y = a.y -. b.y}
let ( ~| ) a = {x = -. a.x; y = -. a.y}
let ( *| ) s r = {x = s *. r.x; y = s *. r.y}

let normal a = { x = a.y; y = -. a.x }
let dot a b = a.x *. b.x +. a.y *. b.y
let length2 r = dot r r
let length r = sqrt(length2 r)
let unitise r = 1. /. length r *| r

(* Get the time since the program started. *)
let time =
  let t = Unix.gettimeofday() in
  fun () -> Unix.gettimeofday() -. t

let width = ref 1 and height = ref 1

(* Reshape the viewport and store the width and height. *)
let reshape ~w ~h =
  GlDraw.viewport ~x:0 ~y:0 ~w ~h;
  width := max 1 w;
  height := max 1 h

(* Pass a single vertex to the OpenGL. *)
let vertex {x=x; y=y} =
  GlDraw.vertex ~x ~y ()

let translate r =
  GlMat.translate ~x:r.x ~y:r.y ()

let rotate angle =
  let angle = angle *. 180. /. pi in
  GlMat.rotate ~angle ~z:1. ()

let scale s =
  GlMat.scale ~x:s ~y:s ()

let protect f g =
  try
    f();
    g()
  with e ->
    g();
    raise e

let mat f =
  GlMat.push();
  protect f GlMat.pop

let render prim f =
  GlDraw.begins prim;
  protect f GlDraw.ends

let circle x = vec2 (sin x) (cos x)

(* Memoize OpenGL calls in a display list. *)
let gl_memoize f =
  let dl = ref None in
  fun () -> match !dl with
  | Some dl -> GlList.call dl
  | None ->
      let dl' = GlList.create `compile in
      f ();
      GlList.ends ();
      dl := Some dl'

let rec iter f l u = if l<u then (f l; iter f (l+1) u)

(* Render a ball at the origin. *)
let render_ball =
  gl_memoize
    (fun () ->
       let n = 36 in
       let aux i = circle (2. *. pi *. float i /. float n) in
       render `triangle_fan
	 (fun () ->
	    vertex zero;
	    iter (fun i -> vertex (aux i)) 0 (n/4+1));
       render `triangle_fan
	 (fun () ->
	    vertex zero;
	    iter (fun i -> vertex (aux i)) (n/2) (3*n/4+1));
       render `triangle_strip
	 (fun () -> iter (fun i ->
			    vertex (0.9 *| aux i);
			    vertex (aux i)) 0 (n+1)))

type circle = { center: vec2; radius: float }

type ball = { circle: circle;
	      velocity: vec2;
	      angle: float;
	      angular_velocity: float }

let make_ball ?(v=vec2 0.1 0.) ?(r=0.05) x y =
  { circle = { center = vec2 x y; radius = r };
    velocity = v;
    angle = 0.;
    angular_velocity = 0. }

type surface =
    Line of vec2 * vec2
  | Circle of vec2 * float

let surfaces = ref [Line (vec2 0. 0., vec2 0. 1.);
		    Line (vec2 0. 1., vec2 1. 1.);
		    Line (vec2 1. 1., vec2 1. 0.);
		    Line (vec2 1. 0.2, vec2 0. 0.)]

(* Split balls. *)
let balls =
  ref [|{(make_ball 0.5 0.9) with velocity = vec2 0. (-1.)};
	{(make_ball 0.45 0.05) with velocity = vec2 0. 0.};
	{(make_ball 0.55 0.05) with velocity = vec2 0. 0.}|]
let surfaces = ref [Line (vec2 0. 0., vec2 0. 1.);
		    Line (vec2 0. 1., vec2 1. 1.);
		    Line (vec2 1. 1., vec2 1. 0.);
		    Line (vec2 1. 0., vec2 0. 0.)]
let g = vec2 0. 0.1

let n_balls = try min 100 (max 0 (int_of_string(Sys.argv.(1)))) with _ -> 3

(* Funnel *)
let balls =
  let n = 10 in
  ref (Array.init n_balls
	 (fun x -> make_ball ~v:(vec2 0. 0.) ~r:0.02
	    (0.2 +. 0.03 *. float ((x/n) mod 2) +. 0.06 *. float (x mod n))
	    (0.9 -. 0.04 *. float (x/n))))
let surfaces =
  let n = 128 in
  let aux i =
    let r = circle (2. *. pi *. float (i + n/4) /. float n) in
    vec2 (0.5 +. 0.5 *. r.x) (1. +. r.y) in
  ref (Array.to_list (Array.init n (fun i -> Line (aux (i-1), aux i))))
let surfaces = ref (Circle (vec2 0.37 0.3, 0.11) ::
		      Circle (vec2 0.63 0.3, 0.11) ::
		      !surfaces)
let g = vec2 0. 0.5

let display_ball ball =
  mat (fun () ->
	 translate ball.circle.center;
	 rotate ball.angle;
	 scale ball.circle.radius;
	 render_ball())

let display_balls () =
  Array.iter display_ball !balls

let display_surface = function
    Line (v1, v2) ->
      GlDraw.begins `lines;
      List.iter vertex [v1; v2];
      GlDraw.ends ()
  | Circle (c, r) ->
      GlMat.push();
      mat (fun () ->
	     translate c;
	     scale r;
	     let n = 360 in
	     GlDraw.begins `line_loop;
	     for i=0 to n-1 do
	       vertex (circle (2. *. pi *. float i /. float n))
	     done;
	     GlDraw.ends ())

let display_surfaces =
  gl_memoize (fun () -> List.iter display_surface !surfaces)

let display () =
  GlClear.clear [ `color; `depth ];
  Gl.enable `depth_test;
  GlFunc.depth_func `lequal;

  (* Initialise a orthogonal projection of the 2D scene. *)
  GlMat.mode `projection;
  GlMat.load_identity ();
  GlMat.ortho ~x:(0., 1.) ~y:(0., 1.) ~z:(0., 1.);
  GlMat.mode `modelview;
  GlMat.load_identity ();

  GlDraw.color (1., 1., 1.) ~alpha:1.;

  display_balls();
  display_surfaces();

  Gl.finish ();

  Unix.sleep 0;

  Glut.swapBuffers ()

let clamp l u (x : float) =
  if x<l then l else if x>u then u else x

let circle_circle c1 r1 c2 r2 =
  let s = c2 -| c1 in
  c1 +| 0.5 *. (length s +. r1 -. r2) *| unitise s

let circle_circle c1 r1 c2 r2 =
  let s = c2 -| c1 in
  let l = length s in
  let s = (1. /. l) *| s in
  c1 +| 0.5 *. (l +. r1 -. r2) *| s

(* Find the point of impact between a circle and a surface. *)
let point_of_impact circle = function
    Line (p1, p2) ->
      (* Find the closest approach of the finite line v1 -> v2 to the point
	 r. *)
      let p21 = p2 -| p1 in
      let x = clamp 0. 1. (dot (circle.center -| p1) p21 /. length2 p21) in
      p1 +| x *| p21
  | Circle (c2, r2) -> circle_circle circle.center circle.radius c2 r2

let circle_circle_intersects c1 c2 =
  let p = circle_circle c1.center c1.radius c2.center c2.radius in
  length(c1.center -| p) < c1.radius

let rec update_ball dt (ball, impacts as accu) surface =
  let p = point_of_impact ball.circle surface in

  let d = ball.circle.center -| p in

  if length d > ball.circle.radius then accu else begin
    (* Local basis through center and perpendicular. *)
    let a = unitise d in
    let b = normal a in
    
    (* Resolve the velocity at the point of impact into components through the
       center and perpendicular. *)
    let dva = dot ball.velocity a in
    let dvb = dot ball.velocity b in
    if dva >= 0. then accu else
      { ball with
	  velocity = ball.velocity +| 2. *. abs_float dva *| a -|
	      0. *. ball.angular_velocity *. ball.circle.radius *| b;
	  angular_velocity = -. dvb /. ball.circle.radius }, p::impacts
  end

(* Bisect the time slice until there is only one impact. *)
let rec update t t' balls =
  let dt = t' -. t in

  (* Ball-ball impacts. *)
  let balls', impacts =
    let balls = Array.copy balls in
    let impacts = Array.map (fun _ -> []) balls in
    let n = Array.length balls in

    for i=0 to n-1 do
      (* Ball-surface impacts *)
      (fun (b, is) ->
	 balls.(i) <- b;
	 impacts.(i) <- is)
	(List.fold_left (update_ball dt) (balls.(i), impacts.(i)) !surfaces);

      (* Ball-ball impacts. *)
      if i>0 then
	let b1 = balls.(i) in
	for j=0 to i-1 do
	  let b2 = balls.(j) in
	  let c1 = b1.circle and c2 = b2.circle in
	  let p = circle_circle c1.center c1.radius c2.center c2.radius in
	  if length(c1.center -| p) < c1.radius then begin
	    let u1 = b1.velocity and u2 = b2.velocity in
	    let da1 = b1.angular_velocity and da2 = b2.angular_velocity in
	    let r1 = c1.radius and r2 = c2.radius in

	    (* Find the velocity difference to the center-of-momentum frame. *)
	    let com = 0.5 *| (u1 +| u2) in

	    (* Move to COM frame. *)
	    let u1 = u1 -| com and u2 = u2 -| com in
	    let u = unitise (c2.center -| c1.center) in
	    let v = normal u in
	    let impulse = u2 -| u1 +| (da1 *. r1 -. da2 *. r2) *| v in
	    let impulse_u = dot u impulse *| u in
	    let impulse_v = dot v impulse in
	    let v1 = u1 +| impulse_u and v2 = u2 -| impulse_u in
	    let da1' = da1 +. impulse_v *. r1 in
	    let da2' = da2 -. impulse_v *. r2 in

	    (* Move from COM frame. *)
	    let v1 = v1 +| com and v2 = v2 +| com in

	    balls.(i) <- { balls.(i) with
			     velocity = v1;
			     angular_velocity = da1' };
	    balls.(j) <- { balls.(j) with
			     velocity = v2;
			     angular_velocity = da2' };
	    impacts.(i) <- p :: impacts.(i);
	    impacts.(j) <- p :: impacts.(j);
	  end
	done;
    done;

    for i=0 to n-1 do
      let b = balls.(i) in
      let r = b.circle.center and dr = b.velocity in
      let a = b.angle and da = b.angular_velocity in
      let rec aux dr = function
	  [] ->
	     { balls.(i) with
		 circle = { balls.(i).circle with center = r +| dt *| dr };
		 angle = mod_float (a +. dt *. da) (2. *. pi);
		 velocity = dr -| (t' -. t) *| g }
	| p::t ->
	    (* Make sure the velocity is not pointing towards the impact
	       point. *)
	    let d = unitise(r -| p) in
	    aux (dr -| min 0. (dot dr d) *| d) t in
      balls.(i) <- aux dr impacts.(i);
      match impacts.(i) with
	[] | [_] -> ()
      | _ ->
	  balls.(i) <- { balls.(i) with angular_velocity = 0. }
    done;
    balls, impacts in

  (* Bisect if there was at least one impact and the time slice was large
     enough. *)
  let aux = function [] | [_] -> true | _ -> false in
  if dt<0.01 && (Array.for_all aux impacts || dt < 1e-3) then balls' else
    let t2 = (t +. t') *. 0.5 in
    update t2 t' (update t t2 balls)

let old_time = ref 0.

let idle () =
  let time' = time() in
  balls := update !old_time time' !balls;
  old_time := time';
  Glut.postRedisplay ()

let () =
  ignore (Glut.init Sys.argv);
  Glut.initDisplayMode ~alpha:true ~double_buffer:true ~depth:true ();
  Glut.initWindowSize ~w:256 ~h:256;
  ignore (Glut.createWindow ~title:"Bouncing balls");
  GlClear.color (0., 0., 0.) ~alpha:0.;

  Gl.enable `blend;
  List.iter Gl.enable [`line_smooth; `polygon_smooth];
  List.iter (fun x -> GlMisc.hint x `nicest) [`line_smooth; `polygon_smooth];
  GlDraw.line_width 4.;
  GlFunc.blend_func ~src:`src_alpha ~dst:`one;

  Glut.reshapeFunc ~cb:reshape;
  Glut.displayFunc ~cb:display;
  Glut.idleFunc ~cb:(Some idle);
  Glut.keyboardFunc ~cb:(fun ~key ~x ~y -> if key=27 then exit 0);
  Glut.mainLoop ()
