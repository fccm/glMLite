(* {{{ COPYING *(

  +-----------------------------------------------------------------------+
  |  This file belongs to glMLite, an OCaml binding to the OpenGL API.    |
  +-----------------------------------------------------------------------+
  |  Copyright (C) 2006, 2007, 2008  Florent Monnier                      |
  |  Contact:  <fmonnier@linux-nantes.org>                                |
  +-----------------------------------------------------------------------+
  |  This program is free software: you can redistribute it and/or        |
  |  modify it under the terms of the GNU General Public License          |
  |  as published by the Free Software Foundation, either version 3       |
  |  of the License, or (at your option) any later version.               |
  |                                                                       |
  |  This program is distributed in the hope that it will be useful,      |
  |  but WITHOUT ANY WARRANTY; without even the implied warranty of       |
  |  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        |
  |  GNU General Public License for more details.                         |
  |                                                                       |
  |  You should have received a copy of the GNU General Public License    |
  |  along with this program.  If not, see <http://www.gnu.org/licenses/> |
  +-----------------------------------------------------------------------+

)* }}} *)

(** An {i experimental} attempt at a functional interface to Glut. *)

open Glut
open Glu
open GL

(** This function works like a [List.fold_left] which means that the application
    data is given as the parameter [init] and then passed through each callback.
    A callback get the app data as first argument and then returns with this data,
    modified or not, which will be provided to the next callback in the same way. *)
let fun_glut ~display
      ?reshape ?keyboard ?keyboard_up ?special ?special_up ?mouse ?motion ?passive
      ?visibility ?entry ?timer ?idle
      ?(full_screen=false)
      ?(window_size=800, 600)
      ?title ?display_mode
      ?init_gl
      ~init () =

  ignore(glutInit Sys.argv);
  begin match display_mode with
    Some display_mode -> glutInitDisplayMode display_mode
  | None -> glutInitDisplayMode []
  end;
  begin match window_size with
  | width, height -> glutInitWindowSize width height
  end;
  begin match title with
    Some title -> ignore(glutCreateWindow title)
  | None -> ignore(glutCreateWindow Sys.argv.(0))
  end;
  if full_screen then glutFullScreen();

  begin match init_gl with
    Some f -> f()
  | None -> ()
  end;

  let app = ref init in

  begin match reshape with
    Some cb -> glutReshapeFunc cb
  | None -> glutReshapeFunc (fun ~width:w ~height:h ->
      let h = if h = 0 then 1 else h in
      glViewport 0 0 w h;
      glMatrixMode GL_PROJECTION;
      glLoadIdentity();
      gluPerspective 60. ((float w)/.(float h)) 0.1 1000.0;
      glMatrixMode GL_MODELVIEW;
      glutPostRedisplay())
  end;

  glutDisplayFunc (fun () -> display !app);

  begin match keyboard with None -> ()
  | Some cb -> glutKeyboardFunc (fun ~key ~x ~y -> app := cb !app ~key ~x ~y)
  end;
  begin match keyboard_up with None -> ()
  | Some cb -> glutKeyboardUpFunc (fun ~key ~x ~y -> app := cb !app ~key ~x ~y)
  end;
  begin match special with None -> ()
  | Some cb -> glutSpecialFunc (fun ~key ~x ~y -> app := cb !app ~key ~x ~y)
  end;
  begin match special_up with None -> ()
  | Some cb -> glutSpecialUpFunc (fun ~key ~x ~y -> app := cb !app ~key ~x ~y)
  end;
  begin match mouse with None -> ()
  | Some cb -> glutMouseFunc (fun ~button ~state ~x ~y -> app := cb !app ~button ~state ~x ~y)
  end;
  begin match motion with None -> ()
  | Some cb -> glutMotionFunc (fun ~x ~y -> app := cb !app ~x ~y)
  end;
  begin match passive with None -> ()
  | Some cb -> glutPassiveMotionFunc (fun ~x ~y -> app := cb !app ~x ~y)
  end;
  begin match visibility with None -> ()
  | Some cb -> glutVisibilityFunc (fun ~state -> app := cb !app ~state)
  end;
  begin match entry with None -> ()
  | Some cb -> glutEntryFunc (fun ~state -> app := cb !app ~state)
  end;

  begin match timer with
  | Some [] | None -> ()
  | Some timers ->
      ListLabels.iter timers ~f:
        (fun (_timer, msecs) ->
           let rec timer =
             (fun ~value ->
                let _app = _timer !app in
                app := _app;
                glutTimerFunc ~msecs ~value:_app ~timer
             )
           in
           glutTimerFunc ~msecs ~value:!app ~timer
        )
  end;

  begin match idle with None -> ()
  | Some idle ->
      glutIdleFunc (fun () -> app := idle !app;)
  end;

  glutMainLoop();
;;

let post_redisplay f x =
  glutPostRedisplay();
  (f x)

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
