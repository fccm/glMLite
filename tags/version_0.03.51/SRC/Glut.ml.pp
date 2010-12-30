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


external glutInit: argv:string array -> string array = "ml_glutinit"

external glutInitWindowPosition: x:int -> y:int -> unit = "ml_glutinitwindowposition"
external glutPositionWindow: x:int -> y:int -> unit = "ml_glutpositionwindow"
external glutInitWindowSize: width:int -> height:int -> unit = "ml_glutinitwindowsize"
external glutReshapeWindow: width:int -> height:int -> unit = "ml_glutreshapewindow"

type window_id
external glutCreateWindow: title:string -> window_id = "ml_glutcreatewindow"
external glutSetWindow: win:window_id -> unit = "ml_glutsetwindow"
external glutGetWindow: unit -> window_id = "ml_glutgetwindow"
external glutCreateSubWindow: win:window_id -> x:int -> y:int -> width:int -> height:int -> window_id = "ml_glutcreatesubwindow"
external glutDestroyWindow: win:window_id -> unit = "ml_glutdestroywindow"

external glutSwapBuffers: unit -> unit = "ml_glutswapbuffers"
external glutPostRedisplay: unit -> unit = "ml_glutpostredisplay"
external glutFullScreen: unit -> unit = "ml_glutfullscreen"
external glutMainLoop: unit -> unit = "ml_glutmainloop"
external glutLeaveMainLoop: unit -> unit = "ml_glutleavemainloop"

external glutSetWindowTitle: name:string -> unit = "ml_glutsetwindowtitle"
external glutSetIconTitle: name:string -> unit = "ml_glutseticontitle"
external glutPopWindow: unit -> unit = "ml_glutpopwindow"
external glutPushWindow: unit -> unit = "ml_glutpushwindow"
external glutShowWindow: unit -> unit = "ml_glutshowwindow"
external glutHideWindow: unit -> unit = "ml_gluthidewindow"
external glutIconifyWindow: unit -> unit = "ml_gluticonifywindow"


#include "enums/cursor_type.inc.ml"
external glutSetCursor: cursor:cursor_type -> unit = "ml_glutsetcursor"


#include "enums/init_mode.inc.ml"
external glutInitDisplayMode: mode:init_mode list -> unit = "ml_glutinitdisplaymode"



external glutDisplayFunc: unit -> unit = "ml_glutdisplayfunc"
let glutDisplayFunc ~display =
  Callback.register "GL callback display" display;
  glutDisplayFunc();
;;

external glutReshapeFunc: unit -> unit = "ml_glutreshapefunc"
let glutReshapeFunc ~reshape =
  Callback.register "GL callback reshape" reshape;
  glutReshapeFunc();
;;

external glutKeyboardFunc: unit -> unit = "ml_glutkeyboardfunc"
let glutKeyboardFunc ~keyboard =
  Callback.register "GL callback keyboard" keyboard;
  glutKeyboardFunc();
;;

external glutKeyboardUpFunc: unit -> unit = "ml_glutkeyboardupfunc"
let glutKeyboardUpFunc ~keyboard_up =
  Callback.register "GL callback keyboard-up" keyboard_up;
  glutKeyboardUpFunc();
;;

external glutPassiveMotionFunc: unit -> unit = "ml_glutpassivemotionfunc"
let glutPassiveMotionFunc ~passive =
  Callback.register "GL callback passive" passive;
  glutPassiveMotionFunc();
;;

external glutMotionFunc: unit -> unit = "ml_glutmotionfunc"
let glutMotionFunc ~motion =
  Callback.register "GL callback motion" motion;
  glutMotionFunc();
;;

#include "enums/mouse_button_state.inc.ml"

external glutMouseFunc: unit -> unit = "ml_glutmousefunc"
let glutMouseFunc ~mouse =
  Callback.register "GL callback mouse" mouse;
  glutMouseFunc();
;;

#include "enums/visibility_state.inc.ml"

external glutVisibilityFunc: unit -> unit = "ml_glutvisibilityfunc"
let glutVisibilityFunc ~visibility =
  Callback.register "GL callback visibility" visibility;
  glutVisibilityFunc();
;;

#include "enums/entry_state.inc.ml"

external glutEntryFunc: unit -> unit = "ml_glutentryfunc"
let glutEntryFunc ~entry =
  Callback.register "GL callback entry" entry;
  glutEntryFunc();
;;

#include "enums/special_key.inc.ml"

external glutSpecialFunc: unit -> unit = "ml_glutspecialfunc"
let glutSpecialFunc ~special =
  Callback.register "GL callback special" special;
  glutSpecialFunc();
;;

external glutSpecialUpFunc: unit -> unit = "ml_glutspecialupfunc"
let glutSpecialUpFunc ~special_up =
  Callback.register "GL callback special-up" special_up;
  glutSpecialUpFunc();
;;

external glutIdleFunc: unit -> unit = "ml_glutidlefunc"
let glutIdleFunc ~idle =
  Callback.register "GL callback idle" idle;
  glutIdleFunc();
;;

external glutRemoveIdleFunc: unit -> unit = "ml_glutremoveidlefunc"


type menu_id = int

external glutCreateMenu: unit -> menu_id = "ml_glutcreatemenu"
let glutCreateMenu ~menu =
  Callback.register "GL callback menu" menu;
  glutCreateMenu();
;;



external init_glutTimerFunc : (int -> unit) -> unit = "init_gluttimerfunc_cb"

let timer_hashtbl = Hashtbl.create 32 ;;

let real_call_back i = (Hashtbl.find timer_hashtbl i) () ;;
      
let () = init_glutTimerFunc real_call_back ;;
    

external _glutTimerFunc : int -> int -> unit = "ml_gluttimerfunc"

let timer_count = ref 0 ;;

let glutTimerFunc ~msecs ~timer:(cb:(value:'a -> unit)) ~value =
  let i = !timer_count in
  incr timer_count;
  Hashtbl.add timer_hashtbl i (fun () ->
      Hashtbl.remove timer_hashtbl i;
      cb value);
  _glutTimerFunc msecs i
;;



external glutAddSubMenu: name:string -> menu:menu_id -> unit = "ml_glutaddsubmenu"
external glutAddMenuEntry: name:string -> value:int -> unit = "ml_glutaddmenuentry"
external glutGetMenu: unit -> menu_id = "ml_glutgetmenu"
external glutSetMenu: menu:menu_id -> unit = "ml_glutsetmenu"
external glutDestroyMenu: menu:menu_id -> unit = "ml_glutdestroymenu"

#include "enums/mouse_button.inc.ml"
external glutAttachMenu: button:mouse_button -> unit = "ml_glutattachmenu"
external glutDetachMenu: button:mouse_button -> unit = "ml_glutdetachmenu"

external glutChangeToMenuEntry: entry:int -> name:string -> value:int -> unit = "ml_glutchangetomenuentry"
external glutChangeToSubMenu: entry:int -> name:string -> menu:menu_id -> unit = "ml_glutchangetosubmenu"
external glutRemoveMenuItem: entry:int -> unit = "ml_glutremovemenuitem"


external glutInitDisplayString: string -> unit = "ml_glutinitdisplaystring"


(* State Retrieval *)

#include "enums/get_state.inc.ml"
external glutGet: state:get_state -> int = "ml_glutget"

#include "enums/glut_device.inc.ml"
external glutDeviceGet: device:glut_device -> int = "ml_glutdeviceget"

type active_modifier =
  | GLUT_ACTIVE_SHIFT
  | GLUT_ACTIVE_CTRL
  | GLUT_ACTIVE_ALT

external glutGetModifiers: unit -> active_modifier list = "ml_glutgetmodifiers"
external glutGetModifiersB: unit -> bool * bool * bool = "ml_glutgetmodifiers_t"

external glutExtensionSupported: extension:string -> bool = "ml_glutextensionsupported"


(* Game Mode *)

external glutGameModeString: mode:string -> unit = "ml_glutgamemodestring"

external glutEnterGameMode: unit -> unit = "ml_glutentergamemode"
external glutLeaveGameMode: unit -> unit = "ml_glutleavegamemode"

#include "enums/game_mode.inc.ml"
external glutGameModeGet: game_mode:game_mode -> int = "ml_glutgamemodeget"


(* Font Rendering *)

type stroke_font =
  | GLUT_STROKE_ROMAN
  | GLUT_STROKE_MONO_ROMAN

type bitmap_font =
  | GLUT_BITMAP_9_BY_15
  | GLUT_BITMAP_8_BY_13
  | GLUT_BITMAP_TIMES_ROMAN_10
  | GLUT_BITMAP_TIMES_ROMAN_24
  | GLUT_BITMAP_HELVETICA_10
  | GLUT_BITMAP_HELVETICA_12
  | GLUT_BITMAP_HELVETICA_18

external glutBitmapCharacter: font:bitmap_font -> c:char -> unit = "ml_glutbitmapcharacter"
external glutBitmapWidth: font:bitmap_font -> c:char -> int = "ml_glutbitmapwidth"

external glutStrokeCharacter: font:stroke_font -> c:char -> unit = "ml_glutstrokecharacter"
external glutStrokeWidth: font:stroke_font -> c:char -> int = "ml_glutstrokewidth"

external glutBitmapHeight: font:bitmap_font -> int = "ml_glutbitmapheight"
external glutStrokeHeight: font:stroke_font -> float = "ml_glutstrokeheight"

external glutBitmapLength: font:bitmap_font -> str:string -> int = "ml_glutbitmaplength"
external glutStrokeLength: font:stroke_font -> str:string -> int = "ml_glutstrokelength"


(* Geometric Object Rendering *)

external glutWireSphere: radius:float -> slices:int -> stacks:int -> unit = "ml_glutwiresphere"
external glutSolidSphere: radius:float -> slices:int -> stacks:int -> unit = "ml_glutsolidsphere"
external glutWireCone: base:float -> height:float -> slices:int -> stacks:int -> unit = "ml_glutwirecone"
external glutSolidCone: base:float -> height:float -> slices:int -> stacks:int -> unit = "ml_glutsolidcone"
external glutWireCube: size:float -> unit = "ml_glutwirecube"
external glutSolidCube: size:float -> unit = "ml_glutsolidcube"
external glutWireTorus: innerRadius:float -> outerRadius:float -> sides:int -> rings:int -> unit = "ml_glutwiretorus"
external glutSolidTorus: innerRadius:float -> outerRadius:float -> sides:int -> rings:int -> unit = "ml_glutsolidtorus"
external glutWireDodecahedron: unit -> unit = "ml_glutwiredodecahedron"
external glutSolidDodecahedron: unit -> unit = "ml_glutsoliddodecahedron"
external glutWireTeapot: size:float -> unit = "ml_glutwireteapot"
external glutSolidTeapot: size:float -> unit = "ml_glutsolidteapot"
external glutWireOctahedron: unit -> unit = "ml_glutwireoctahedron"
external glutSolidOctahedron: unit -> unit = "ml_glutsolidoctahedron"
external glutWireTetrahedron: unit -> unit = "ml_glutwiretetrahedron"
external glutSolidTetrahedron: unit -> unit = "ml_glutsolidtetrahedron"
external glutWireIcosahedron: unit -> unit = "ml_glutwireicosahedron"
external glutSolidIcosahedron: unit -> unit = "ml_glutsolidicosahedron"

external glutWireRhombicDodecahedron: unit -> unit = "ml_glutwirerhombicdodecahedron"
external glutSolidRhombicDodecahedron: unit -> unit = "ml_glutsolidrhombicdodecahedron"


(* Color Index *)

external glutSetColor: cell:int -> r:float -> g:float -> b:float -> unit = "ml_glutsetcolor"
(** to use with [glIndex] *)

external glutGetColor: cell:int -> float * float * float = "ml_glutgetcolor"


(* vim: et fdm=marker filetype=ocaml
 *)
