(* From the Red Book:
   http://www.glprogramming.com/red/chapter06.html *)

(* OCaml version by Florent Monnier *)

open GL ;;
open Glu ;;
open Glut ;;

let left_first = ref true ;;


(*  Initialize alpha blending function.  *)
let init() =
  glEnable GL_BLEND;
  glBlendFunc Sfactor.GL_SRC_ALPHA  Dfactor.GL_ONE_MINUS_SRC_ALPHA;
  glShadeModel GL_FLAT;
  glClearColor 0.0  0.0  0.0  0.0;
;;


let drawLeftTriangle() =
(* draw yellow triangle on LHS of screen *)
  glBegin GL_TRIANGLES;
    glColor4 1.0  1.0  0.0  0.75;
    glVertex3 0.1  0.9  0.0; 
    glVertex3 0.1  0.1  0.0; 
    glVertex3 0.7  0.5  0.0; 
  glEnd();
;;


let drawRightTriangle() =
(* draw cyan triangle on RHS of screen *)
  glBegin GL_TRIANGLES;
    glColor4 0.0  1.0  1.0  0.75;
    glVertex3 0.9  0.9  0.0; 
    glVertex3 0.3  0.5  0.0; 
    glVertex3 0.9  0.1  0.0; 
  glEnd();
;;


let display() =
  glClear [GL_COLOR_BUFFER_BIT];

  if (!left_first) then begin
    drawLeftTriangle();
    drawRightTriangle();
  end
  else begin
    drawRightTriangle();
    drawLeftTriangle();
  end;
  glFlush();
;;


let reshape ~width ~height =
  glViewport 0 0 width height;
  glMatrixMode GL_PROJECTION;
  glLoadIdentity();
  if (width <= height) then
    gluOrtho2D 0.0  1.0  0.0 (1.0 *. float height /. float width)
  else 
    gluOrtho2D 0.0 (1.0 *. float width /. float height) 0.0  1.0;
;;


let keyboard ~key ~x ~y =
  match key with
  | 't' | 'T' -> left_first := not !left_first; glutPostRedisplay();   
  | 'q' | '\027' (* Escape *) -> exit 0;
  | _ -> ()
;;


let () =
  ignore(glutInit Sys.argv);
  glutInitDisplayMode [GLUT_SINGLE; GLUT_RGB];
  glutInitWindowSize 200 200;
  ignore(glutCreateWindow Sys.argv.(0));
  init();
  glutReshapeFunc ~reshape;
  glutKeyboardFunc ~keyboard;
  glutDisplayFunc ~display;
  glutMainLoop();
;;

