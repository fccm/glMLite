(* gluUnProject test/demo
 * by Florent Monnier
 * This program is in the public domain.
 *
 * clic in the window to add a new point
 *)
open GL
open Glu
open Glut

let px = ref 0.0
let py = ref 0.0

let points = ref []


let display() =
  glClear [GL_COLOR_BUFFER_BIT; GL_DEPTH_BUFFER_BIT];
  glLoadIdentity();

  glPointSize 5.0;
  glBegin GL_POINTS;
    List.iter (function (x,y, r,g,b) ->
        glColor3 r g b;  glVertex2 x y;
        ) !points;
    glColor3  1.0  1.0  0.0;  glVertex2 !px  !py;
  glEnd();

  glFlush();
  glutSwapBuffers();
;;


let reshape  ~width:w ~height:h =
  glViewport 0  0  w h;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  let x_min = -6.0 and x_max = 6.0
  and y_min = -6.0 and y_max = 6.0
  and z_min, z_max = -6.0, 60.0 in
  if w <= h then
    glOrtho x_min x_max (y_min *. float h /. float w)
                        (y_max *. float h /. float w) z_min z_max
  else
    glOrtho (x_min *. float w /. float h)
            (x_max *. float w /. float h) y_min y_max z_min z_max;

  glMatrixMode GL_MODELVIEW;
  glLoadIdentity();
;;


let motion ~x ~y =
  let mx, my, _ = gluUnProjectUtil ~x ~y in
  px := mx;
  py := my;
;;

let passive ~x ~y =
  let mx, my, _ = gluUnProjectUtil ~x ~y in
  px := mx;
  py := my;
;;


let mouse ~button ~state ~x ~y =
  let mx, my, _ = gluUnProjectUtil ~x ~y in
  px := mx;
  py := my;
  match button, state with
  | GLUT_LEFT_BUTTON, GLUT_DOWN ->
      let r, g, b =
        Random.float 1.0,
        Random.float 1.0,
        Random.float 1.0
      in
      let pt = (mx,my, r,g,b) in
      points := pt :: !points;
  | _ -> ()
;;


let keyboard ~key ~x ~y =
  match key with 'q' | '\027' -> exit 0 | _ -> ()
;;

let idle () =
  glutPostRedisplay();
;;


let gl_init() =
  glClearColor 0.5 0.5 0.5  0.0;
  glShadeModel GL_FLAT;
;;

let () = (* usage *)
  print_endline "usage: clic in the window to add a new point";
;;

let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_DOUBLE; GLUT_RGB];
  glutInitWindowSize 600 600;
  glutInitWindowPosition 100 100;
  ignore(glutCreateWindow Sys.argv.(0));
  gl_init();
  glutDisplayFunc ~display;
  glutReshapeFunc ~reshape;
  glutIdleFunc ~idle;
  glutMouseFunc ~mouse;
  glutKeyboardFunc ~keyboard;
  glutMotionFunc ~motion;
  glutPassiveMotionFunc ~passive;
  glutMainLoop();
;;

