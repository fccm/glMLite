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

(** Glut interface *)

(**
{{:http://www.opengl.org/resources/libraries/glut/spec3/spec3.html}Online documentation of the C API}
*)

(** {2 Initialization} *)

external glutInit: argv:string array -> string array = "ml_glutinit"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node10.html}
    doc on opengl.org} *)

external glutInitWindowPosition: x:int -> y:int -> unit = "ml_glutinitwindowposition"
external glutInitWindowSize: width:int -> height:int -> unit = "ml_glutinitwindowsize"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node11.html}
    doc on opengl.org} *)

#include "enums/init_mode.inc.ml"
external glutInitDisplayMode: mode:init_mode list -> unit = "ml_glutinitdisplaymode"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node12.html}
    doc on opengl.org} *)

external glutInitDisplayString: string -> unit = "ml_glutinitdisplaystring"
(** {{:http://www.opengl.org/documentation/specs/glut/spec3/node70.html}
    doc on opengl.org} *)



(** {2 Beginning Event Processing} *)

external glutMainLoop: unit -> unit = "ml_glutmainloop"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node14.html}
    doc on opengl.org} *)

external glutLeaveMainLoop: unit -> unit = "ml_glutleavemainloop"
(** function only available with some implementations (ex: 
    {{:http://freeglut.sourceforge.net/}FreeGlut} or
    {{:http://openglut.sourceforge.net/}OpenGlut}) *)


(** {2 Window Management} *)

type window_id
external glutCreateWindow: title:string -> window_id = "ml_glutcreatewindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node16.html}
    doc on opengl.org} *)

external glutSetWindow: win:window_id -> unit = "ml_glutsetwindow"
external glutGetWindow: unit -> window_id = "ml_glutgetwindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node18.html}
    doc on opengl.org} *)

external glutCreateSubWindow: win:window_id -> x:int -> y:int -> width:int -> height:int -> window_id = "ml_glutcreatesubwindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node17.html}
    doc on opengl.org} *)

external glutDestroyWindow: win:window_id -> unit = "ml_glutdestroywindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node19.html}
    doc on opengl.org} *)

external glutPostRedisplay: unit -> unit = "ml_glutpostredisplay"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node20.html}
    doc on opengl.org} *)

external glutSwapBuffers: unit -> unit = "ml_glutswapbuffers"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node21.html}
    doc on opengl.org} *)

external glutPositionWindow: x:int -> y:int -> unit = "ml_glutpositionwindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node22.html}
    doc on opengl.org} *)

external glutReshapeWindow: width:int -> height:int -> unit = "ml_glutreshapewindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node23.html}
    doc on opengl.org} *)

external glutFullScreen: unit -> unit = "ml_glutfullscreen"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node24.html}
    doc on opengl.org} *)

external glutPopWindow: unit -> unit = "ml_glutpopwindow"
external glutPushWindow: unit -> unit = "ml_glutpushwindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node25.html}
    doc on opengl.org} *)

external glutShowWindow: unit -> unit = "ml_glutshowwindow"
external glutHideWindow: unit -> unit = "ml_gluthidewindow"
external glutIconifyWindow: unit -> unit = "ml_gluticonifywindow"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node26.html}
    doc on opengl.org} *)

external glutSetWindowTitle: name:string -> unit = "ml_glutsetwindowtitle"
external glutSetIconTitle: name:string -> unit = "ml_glutseticontitle"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node27.html}
    doc on opengl.org} *)


#include "enums/cursor_type.inc.ml"
external glutSetCursor: cursor:cursor_type -> unit = "ml_glutsetcursor"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node28.html}
    doc on opengl.org} *)



(* * {2 Overlay Management} *)
(* TODO
    glutEstablishOverlay
    glutUseLayer
    glutRemoveOverlay
    glutPostOverlayRedisplay
    glutShowOverlay
    glutHideOverlay
*)


(** {2 Menu Management} *)
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node35.html}
    doc on opengl.org} *)

type menu_id

val glutCreateMenu: menu:(value:int -> unit) -> menu_id
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node36.html}
    doc on opengl.org} *)

external glutGetMenu: unit -> menu_id = "ml_glutgetmenu"
external glutSetMenu: menu:menu_id -> unit = "ml_glutsetmenu"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node37.html}
    doc on opengl.org} *)

external glutDestroyMenu: menu:menu_id -> unit = "ml_glutdestroymenu"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node38.html}
    doc on opengl.org} *)

external glutAddMenuEntry: name:string -> value:int -> unit = "ml_glutaddmenuentry"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node39.html}
    doc on opengl.org} *)

external glutAddSubMenu: name:string -> menu:menu_id -> unit = "ml_glutaddsubmenu"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node40.html}
    doc on opengl.org} *)

external glutChangeToMenuEntry: entry:int -> name:string -> value:int -> unit = "ml_glutchangetomenuentry"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node41.html}
    doc on opengl.org} *)

external glutChangeToSubMenu: entry:int -> name:string -> menu:menu_id -> unit = "ml_glutchangetosubmenu"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node42.html}
    doc on opengl.org} *)

external glutRemoveMenuItem: entry:int -> unit = "ml_glutremovemenuitem"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node43.html}
    doc on opengl.org} *)

#include "enums/mouse_button.inc.ml"
external glutAttachMenu: button:mouse_button -> unit = "ml_glutattachmenu"
external glutDetachMenu: button:mouse_button -> unit = "ml_glutdetachmenu"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node44.html}
    doc on opengl.org} *)



(** {2 Callback Registration} *)
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node45.html}
    Index of Callback Registration on OpenGL.org} *)

val glutDisplayFunc: display:(unit -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node46.html}
    doc on opengl.org} *)

(* TODO
    glutOverlayDisplayFunc
*)
val glutReshapeFunc: reshape:(width:int -> height:int -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node48.html}
    doc on opengl.org} *)

val glutKeyboardFunc: keyboard:(key:char -> x:int -> y:int -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node49.html}
    doc on opengl.org} *)

val glutKeyboardUpFunc: keyboard_up:(key:char -> x:int -> y:int -> unit) -> unit

#include "enums/mouse_button_state.inc.ml"
val glutMouseFunc: mouse:(button:mouse_button -> state:mouse_button_state -> x:int -> y:int -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node50.html}
    doc on opengl.org} *)

val glutMotionFunc: motion:(x:int -> y:int -> unit) -> unit
val glutPassiveMotionFunc: passive:(x:int -> y:int -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node51.html}
    doc on opengl.org} *)


#include "enums/visibility_state.inc.ml"
val glutVisibilityFunc: visibility:(state:visibility_state -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node52.html}
    doc on opengl.org} *)

#include "enums/entry_state.inc.ml"
val glutEntryFunc: entry:(state:entry_state -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node53.html}
    doc on opengl.org} *)

#include "enums/special_key.inc.ml"
val glutSpecialFunc: special:(key:special_key -> x:int -> y:int -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node54.html}
    doc on opengl.org} *)

val glutSpecialUpFunc: special_up:(key:special_key -> x:int -> y:int -> unit) -> unit
(* TODO
    glutSpaceballMotionFunc
    glutSpaceballRotateFunc
    glutSpaceballButtonFunc
    glutButtonBoxFunc
    glutDialsFunc
    glutTabletMotionFunc
    glutTabletButtonFunc
    glutMenuStatusFunc
*)
val glutIdleFunc: idle:(unit -> unit) -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node63.html}
    doc on opengl.org} *)

external glutRemoveIdleFunc: unit -> unit = "ml_glutremoveidlefunc"

val glutTimerFunc: msecs:int -> timer:(value:'a -> unit) -> value:'a -> unit
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node64.html}
    doc on opengl.org} *)


(** {2 Color Index Colormap Management} *)

(* TODO
    glutCopyColormap
*)

external glutSetColor: cell:int -> r:float -> g:float -> b:float -> unit = "ml_glutsetcolor"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node66.html}
    doc on opengl.org}
    to use with [glIndex] *)

external glutGetColor: cell:int -> float * float * float = "ml_glutgetcolor"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node67.html}
    doc on opengl.org} *)



(** {2 State Retrieval} *)

#include "enums/get_state.inc.ml"
external glutGet: state:get_state -> int = "ml_glutget"
(** {{:http://www.opengl.org/documentation/specs/glut/spec3/node70.html}
    doc on opengl.org} *)

(* TODO
    glutLayerGet
*)

#include "enums/glut_device.inc.ml"
external glutDeviceGet: device:glut_device -> int = "ml_glutdeviceget"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node72.html}
    doc on opengl.org} *)

type active_modifier =
  | GLUT_ACTIVE_SHIFT
  | GLUT_ACTIVE_CTRL
  | GLUT_ACTIVE_ALT

external glutGetModifiers: unit -> active_modifier list = "ml_glutgetmodifiers"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node73.html}
    doc on opengl.org} *)

external glutGetModifiersB: unit -> bool * bool * bool = "ml_glutgetmodifiers_t"
(** same as [glutGetModifiers] but returns a tuple
{[let (shift, ctrl, alt) = glutGetModifiersB() in]} *)

external glutExtensionSupported: extension:string -> bool = "ml_glutextensionsupported"
(** {{:http://www.opengl.org/documentation/specs/glut/spec3/node74.html}
    doc on opengl.org} *)



(** {2 Font Rendering} *)

(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node75.html}
    doc on opengl.org} *)

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
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node76.html}
    doc on opengl.org} *)

external glutBitmapWidth: font:bitmap_font -> c:char -> int = "ml_glutbitmapwidth"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node77.html}
    doc on opengl.org} *)

external glutStrokeCharacter: font:stroke_font -> c:char -> unit = "ml_glutstrokecharacter"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node78.html}
    doc on opengl.org} *)

external glutStrokeWidth: font:stroke_font -> c:char -> int = "ml_glutstrokewidth"
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node79.html}
    doc on opengl.org} *)

external glutBitmapHeight: font:bitmap_font -> int = "ml_glutbitmapheight"
external glutStrokeHeight: font:stroke_font -> float = "ml_glutstrokeheight"

external glutBitmapLength: font:bitmap_font -> str:string -> int = "ml_glutbitmaplength"
external glutStrokeLength: font:stroke_font -> str:string -> int = "ml_glutstrokelength"


(** {2 Geometric Object Rendering} *)
(** {{:http://www.opengl.org/resources/libraries/glut/spec3/node80.html}
    doc on opengl.org} *)

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
(** {{:http://openglut.sourceforge.net/group__geometry.html#ga18}
    doc from openglut} *)

external glutSolidRhombicDodecahedron: unit -> unit = "ml_glutsolidrhombicdodecahedron"
(** {{:http://openglut.sourceforge.net/group__geometry.html#ga19}
    doc from openglut} *)

(* TODO
external glutWireSierpinskiSponge: num_levels:int -> offset:float * float * float -> scale:float -> unit = "ml_glutwiresierpinskisponge"

void glutWireSierpinskiSponge( int num_levels, const GLdouble offset[3], GLdouble scale );
http://openglut.sourceforge.net/group__geometry.html#ga20

void glutSolidSierpinskiSponge( int num_levels, const GLdouble offset[3], GLdouble scale );
http://openglut.sourceforge.net/group__geometry.html#ga21
*)


(** {2 Game Mode} *)
(** {{:http://openglut.sourceforge.net/group__gamemode.html}
    doc from OpenGlut} *)

external glutGameModeString: mode:string -> unit = "ml_glutgamemodestring"

external glutEnterGameMode: unit -> unit = "ml_glutentergamemode"
(** {{:http://openglut.sourceforge.net/group__gamemode.html#ga1}
    doc from openglut} *)

external glutLeaveGameMode: unit -> unit = "ml_glutleavegamemode"

#include "enums/game_mode.inc.ml"
external glutGameModeGet: game_mode:game_mode -> int = "ml_glutgamemodeget"



(* vim: et fdm=marker filetype=ocaml
 *)
