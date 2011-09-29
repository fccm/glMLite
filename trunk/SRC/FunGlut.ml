(* {{{ COPYING *(

  This file belongs to glMLite, an OCaml binding to the OpenGL API.

  Copyright (C) 2006 - 2011  Florent Monnier, Some rights reserved
  Contact:  <fmonnier@linux-nantes.org>

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
      ?window_position
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
  begin match window_position with
  | Some(x, y) -> glutInitWindowPosition x y
  | None -> ()
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

  let app = ref (init ()) in

  glutDisplayFunc (fun () -> display !app);

  begin match reshape with None -> ()
  | Some cb -> glutReshapeFunc (fun ~width ~height -> app := cb !app ~width ~height)
  end;
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
                glutTimerFunc ~msecs ~value:() ~timer
             )
           in
           glutTimerFunc ~msecs ~value:() ~timer
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
