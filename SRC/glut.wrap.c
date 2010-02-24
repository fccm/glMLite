/* {{{ COPYING 

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

\* }}} */

#if defined(__APPLE__) && !defined (VMDMESA)
  #include <GLUT/glut.h>
#else
  #include <GL/glut.h>
  #if 0
    #include <GL/freeglut.h>
    #include <GL/openglut.h>
  #endif
#endif

#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/alloc.h>
#include <caml/signals.h>

#include <stdio.h>
#include <string.h>

#define MESA_DEBUG

#define ret  return Val_unit;
#define t_val  CAMLprim value

t_val ml_glutinitwindowposition( value x, value y )      { glutInitWindowPosition( Int_val(x), Int_val(y) ); ret }
t_val ml_glutpositionwindow( value x, value y )          { glutPositionWindow( Int_val(x), Int_val(y) ); ret }
t_val ml_glutinitwindowsize( value width, value height ) { glutInitWindowSize( Int_val(width), Int_val(height) ); ret }
t_val ml_glutreshapewindow( value width, value height )  { glutReshapeWindow( Int_val(width), Int_val(height) ); ret }
t_val ml_glutswapbuffers( value unit )                   { glutSwapBuffers(); ret }
t_val ml_glutpostredisplay( value unit )                 { glutPostRedisplay(); ret }
t_val ml_glutfullscreen( value unit )                    { glutFullScreen(); ret }
t_val ml_glutmainloop( value unit )                      { glutMainLoop (); ret }
/*{ 
  enter_blocking_section ();
  glutMainLoop (); 
  leave_blocking_section ();
  return Val_unit; 
}*/

t_val ml_glutpopwindow( value unit )                     { glutPopWindow(); ret }
t_val ml_glutpushwindow( value unit )                    { glutPushWindow(); ret }
t_val ml_glutshowwindow( value unit )                    { glutShowWindow(); ret }
t_val ml_gluthidewindow( value unit )                    { glutHideWindow(); ret }
t_val ml_gluticonifywindow( value unit )                 { glutIconifyWindow(); ret }

t_val ml_glutsetwindowtitle( value name ) { glutSetWindowTitle( String_val(name) ); ret }
t_val ml_glutseticontitle( value name ) { glutSetIconTitle( String_val(name) ); ret }


t_val ml_glutcreatewindow( value title ) { return Val_int(glutCreateWindow( String_val(title) )); }
t_val ml_glutsetwindow( value win ) { glutSetWindow( Int_val(win) ); ret }
t_val ml_glutgetwindow( value unit ) { return Val_int(glutGetWindow()); }
t_val ml_glutdestroywindow( value win ) { glutDestroyWindow( Int_val(win) ); ret }
t_val ml_glutcreatesubwindow( value win, value x, value y, value width, value height )
{
    return Val_int(
        glutCreateSubWindow( Int_val(win), Int_val(x), Int_val(y), Int_val(width), Int_val(height) ));
}

t_val ml_glutleavemainloop( value unit ) {
#if defined(__FREEGLUT_EXT_H__) || defined(__OPENGLUT_EXT_H__)
    glutLeaveMainLoop();
#else
    caml_failwith("glutLeaveMainLoop: function not available");
#endif
    return Val_unit;
}


/* {{{ glutInit() */

CAMLprim value ml_glutinit( value ml_argv )
{
    CAMLparam1( ml_argv );
    CAMLlocal2( ml_arg, new_argv );

    int argc = Wosize_val(ml_argv);

    char ** argv = malloc((argc+1) * sizeof(char*));

    int i;
    for (i=0; i < argc; i++)
    {
        ml_arg = Field(ml_argv,i);
        int len = caml_string_length(ml_arg);
        char *arg = String_val(ml_arg);
        argv[i] = malloc((len+1) * sizeof(char));
        strncpy(argv[i], arg, len);
        argv[i][len] = '\0';
    }
    argv[argc] = NULL;

    int argc_orig = argc;

    /* glutInit may change argc and argv */
    glutInit(&argc, argv);

    new_argv = caml_copy_string_array( (char const **)argv );

    for (i=0; i < argc_orig; i++) {
        free(argv[i]);
    }
    free(argv);

    CAMLreturn( new_argv );
}
/* }}} */
/* {{{ glutInitDisplayMode() */

CAMLprim value ml_glutinitdisplaymode( value mask_list )
{
    CAMLparam1( mask_list );
    CAMLlocal1( _init_mode );

    unsigned int mode = 0;
    unsigned int init_mode;

    while ( mask_list != Val_emptylist )
    {
        _init_mode = Field(mask_list,0);
#include "enums/init_mode.inc.c"
        mode |= init_mode;
        mask_list = Field(mask_list,1);
    }

    glutInitDisplayMode( mode );

    CAMLreturn( Val_unit );
}
/* }}} */


/* Callbacks */
/* {{{ display */

void display_closure()
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback display");
    }
    caml_callback(*closure_f, Val_unit);
}
CAMLprim value ml_glutdisplayfunc( value unit ) { glutDisplayFunc(display_closure); ret }

/* }}} */
/* {{{ reshape */

void reshape_closure(int x, int y)
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback reshape");
    }
    caml_callback2(*closure_f, Val_int(x), Val_int(y));
}
CAMLprim value ml_glutreshapefunc( value unit ) { glutReshapeFunc(reshape_closure); ret }

/* }}} */
/* {{{ keyboard */

void keyboard_closure(unsigned char key, int x, int y)
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback keyboard");
    }
    caml_callback3(*closure_f, Val_int(key), Val_int(x), Val_int(y));
}
CAMLprim value ml_glutkeyboardfunc( value unit ) { glutKeyboardFunc(keyboard_closure); ret }

/* }}} */
/* {{{ keyboard up */

void keyboardup_closure(unsigned char key, int x, int y)
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback keyboard-up");
    }
    caml_callback3(*closure_f, Val_int(key), Val_int(x), Val_int(y));
}
CAMLprim value ml_glutkeyboardupfunc( value unit ) { glutKeyboardUpFunc(keyboardup_closure); ret }

/* }}} */
/* {{{ passive */

void passive_closure(int x, int y)
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback passive");
    }
    caml_callback2(*closure_f, Val_int(x), Val_int(y));
}
CAMLprim value ml_glutpassivemotionfunc( value unit ) { glutPassiveMotionFunc(passive_closure); ret }

/* }}} */
/* {{{ motion */

void motion_closure(int x, int y)
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback motion");
    }
    caml_callback2(*closure_f, Val_int(x), Val_int(y));
}
CAMLprim value ml_glutmotionfunc( value unit ) { glutMotionFunc(motion_closure); ret }

/* }}} */
/* {{{ mouse */

#if !defined(GLUT_WHEEL_UP)
#  define GLUT_WHEEL_UP   3
#  define GLUT_WHEEL_DOWN 4
#endif

void mouse_closure(int _mouse_button, int _mouse_button_state, int x, int y)
{
    static value * closure_f = NULL;
    value args[4];

    long mouse_button = 0;
    long mouse_button_state = 0;
#include "enums/mouse_button.inc-r.c"
#include "enums/mouse_button_state.inc-r.c"

    args[0] = Val_int(mouse_button);
    args[1] = Val_int(mouse_button_state);
    args[2] = Val_int(x);
    args[3] = Val_int(y);

    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback mouse");
    }
    caml_callbackN(*closure_f, 4, args);
}
CAMLprim value ml_glutmousefunc( value unit ) { glutMouseFunc(mouse_closure); ret }

/* }}} */
/* {{{ visibility */

void visibility_closure( int _visibility_state )
{
    static value * closure_f = NULL;

    long visibility_state;
#include "enums/visibility_state.inc-r.c"

    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback visibility");
    }
    caml_callback(*closure_f, Val_int(visibility_state));
}
CAMLprim value ml_glutvisibilityfunc( value unit ) { glutVisibilityFunc(visibility_closure); ret }

/* }}} */
/* {{{ entry */

void entry_closure( int _entry_state )
{
    static value * closure_f = NULL;

    long entry_state;
#include "enums/entry_state.inc-r.c"

    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback entry");
    }
    caml_callback(*closure_f, Val_int(entry_state));
}
CAMLprim value ml_glutentryfunc( value unit ) { glutEntryFunc(entry_closure); ret }

/* }}} */
/* {{{ special */

void special_closure(int _special_key, int x, int y)
{
    long special_key;
#include "enums/special_key.inc-r.c"

    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback special");
    }
    caml_callback3(*closure_f, Val_int(special_key), Val_int(x), Val_int(y));
}
CAMLprim value ml_glutspecialfunc( value unit ) { glutSpecialFunc(special_closure); ret }

/* }}} */
/* {{{ special up */

void specialup_closure(int _special_key, int x, int y)
{
    long special_key;
#include "enums/special_key.inc-r.c"

    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback special-up");
    }
    caml_callback3(*closure_f, Val_int(special_key), Val_int(x), Val_int(y));
}
CAMLprim value ml_glutspecialupfunc( value unit ) { glutSpecialUpFunc(specialup_closure); ret }

/* }}} */
/* {{{ idle */

void idle_closure()
{
    static value * closure_f = NULL;
    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback idle");
    }
    caml_callback(*closure_f, Val_unit);
}
CAMLprim value ml_glutidlefunc( value unit ) { glutIdleFunc(idle_closure); ret }

CAMLprim value ml_glutremoveidlefunc( value unit ) { glutIdleFunc(NULL); ret }

/* }}} */
/* {{{ timer */

static value caml_glutTimerFunc_cb = 0;  // real_call_back i

CAMLprim void init_gluttimerfunc_cb( value f )
{
    caml_glutTimerFunc_cb = f;
    caml_register_global_root( &caml_glutTimerFunc_cb );
}

static void glutTimerFunc_cb( int idx )
{
    leave_blocking_section();
    callback( caml_glutTimerFunc_cb, (value) idx );
    enter_blocking_section();
}

CAMLprim value ml_gluttimerfunc( value millis, value timer_count )
{
    glutTimerFunc( Int_val(millis), &glutTimerFunc_cb, (int) timer_count );
    return Val_unit;
}

/* }}} */
/* {{{ menu */

void menu_closure( int entry )
{
    static value * closure_f = NULL;

    if (closure_f == NULL) {
        closure_f = caml_named_value("GL callback menu");
    }
    caml_callback(*closure_f, Val_int(entry));
}
CAMLprim value ml_glutcreatemenu( value unit ) { return Val_int(glutCreateMenu(menu_closure)); }

/* }}} */



t_val ml_glutinitdisplaystring( value str ) { glutInitDisplayString( String_val(str) ); ret }


t_val ml_glutget( value _get_state )
{
    GLenum get_state;
#include "enums/get_state.inc.c"
    return Val_int( glutGet(get_state) );
}

t_val ml_glutdeviceget( value _glut_device )
{
    GLenum glut_device;
#include "enums/glut_device.inc.c"
    return Val_int( glutDeviceGet(glut_device) );
}


t_val ml_glutgetmodifiers( value unit )
{
    CAMLparam1( unit );
    CAMLlocal2( mod, cons );

    int active_mod;
    active_mod = glutGetModifiers();

    mod = Val_emptylist;

    if (active_mod & GLUT_ACTIVE_SHIFT)
    {
        cons = caml_alloc(2, 0);
        Store_field( cons, 0, Val_int(0) );
        Store_field( cons, 1, mod );
        mod = cons;
    }

    if (active_mod & GLUT_ACTIVE_CTRL)
    {
        cons = caml_alloc(2, 0);
        Store_field( cons, 0, Val_int(1) );
        Store_field( cons, 1, mod );
        mod = cons;
    }

    if (active_mod & GLUT_ACTIVE_ALT)
    {
        cons = caml_alloc(2, 0);
        Store_field( cons, 0, Val_int(2) );
        Store_field( cons, 1, mod );
        mod = cons;
    }

    CAMLreturn( mod );
}


t_val ml_glutgetmodifiers_t( value unit )
{
    CAMLparam1( unit );
    CAMLlocal1( tuple );

    int active_mod;
    active_mod = glutGetModifiers();

    tuple = caml_alloc(3, 0);

    if (active_mod & GLUT_ACTIVE_SHIFT)
        Store_field( tuple, 0, Val_true );
    else
        Store_field( tuple, 0, Val_false );

    if (active_mod & GLUT_ACTIVE_CTRL)
        Store_field( tuple, 1, Val_true );
    else
        Store_field( tuple, 1, Val_false );

    if (active_mod & GLUT_ACTIVE_ALT)
        Store_field( tuple, 2, Val_true );
    else
        Store_field( tuple, 2, Val_false );

    CAMLreturn( tuple );
}


t_val ml_glutextensionsupported( value extension )
{
    return Val_int(glutExtensionSupported(String_val(extension)));
}


t_val ml_glutsetcursor( value _cursor_type )
{
    int cursor_type;
#include "enums/cursor_type.inc.c"
    glutSetCursor( cursor_type ); ret
}


/* Game Mode */

t_val ml_glutgamemodestring( value mode ) { glutGameModeString( String_val(mode) ); ret }

t_val ml_glutentergamemode( value unit ) { int st; st = glutEnterGameMode(); ret }
t_val ml_glutleavegamemode( value unit ) { glutLeaveGameMode(); ret }

t_val ml_glutgamemodeget( value _game_mode )
{
    GLenum game_mode;
#include "enums/game_mode.inc.c"
    return Val_int( glutGameModeGet( game_mode ));
}


/* TODO
GLUT_KEY_REPEAT_OFF
GLUT_KEY_REPEAT_ON
GLUT_KEY_REPEAT_DEFAULT

void glutIgnoreKeyRepeat( int ignore );
void glutSetKeyRepeat( int repeatMode );
*/


/* Menu Management */

t_val ml_glutaddmenuentry( value name, value entry ) { glutAddMenuEntry( String_val(name), Int_val(entry) ); ret }

t_val ml_glutgetmenu( value unit ) { return Val_int( glutGetMenu() ); }
t_val ml_glutsetmenu( value menu ) { glutSetMenu( Int_val(menu) ); ret }
t_val ml_glutdestroymenu( value menu ) { glutDestroyMenu( Int_val(menu) ); ret }

t_val ml_glutattachmenu( value _mouse_button )
{
    int mouse_button;
#include "enums/mouse_button.inc.c"
    glutAttachMenu( mouse_button ); ret
}

t_val ml_glutdetachmenu( value _mouse_button )
{
    int mouse_button;
#include "enums/mouse_button.inc.c"
    glutDetachMenu( mouse_button ); ret
}

t_val ml_glutaddsubmenu( value name, value menu ) { glutAddSubMenu( String_val(name), Int_val(menu) ); ret }

t_val ml_glutchangetomenuentry( value entry_nb, value name, value entry )
{
    glutChangeToMenuEntry( Int_val(entry_nb), String_val(name), Int_val(entry) ); ret
}

t_val ml_glutchangetosubmenu( value entry_nb, value name, value menu )
{
    glutChangeToSubMenu( Int_val(entry_nb), String_val(name), Int_val(menu) ); ret
}

t_val ml_glutremovemenuitem( value entry ) { glutRemoveMenuItem( Int_val(entry) ); ret }


/* Font Rendering */


static void* stroke_font_table[] = {
    GLUT_STROKE_ROMAN,
    GLUT_STROKE_MONO_ROMAN,
};

static void* bitmap_font_table[] = {
    GLUT_BITMAP_9_BY_15,
    GLUT_BITMAP_8_BY_13,
    GLUT_BITMAP_TIMES_ROMAN_10,
    GLUT_BITMAP_TIMES_ROMAN_24,
    GLUT_BITMAP_HELVETICA_10,
    GLUT_BITMAP_HELVETICA_12,
    GLUT_BITMAP_HELVETICA_18,
};

t_val ml_glutbitmapcharacter( value ml_font, value character )
{
    void *font;
    font = (void *) bitmap_font_table[Int_val(ml_font)];
    glutBitmapCharacter( font, Int_val(character) ); ret
}
t_val ml_glutbitmapwidth( value ml_font, value character )
{
    void *font;
    font = (void *) bitmap_font_table[Int_val(ml_font)];
    return Val_int(glutBitmapWidth( font, Int_val(character) ));
}

t_val ml_glutstrokecharacter( value ml_font, value character )
{
    void *font;
    font = (void *) stroke_font_table[Int_val(ml_font)];
    glutStrokeCharacter( font, Int_val(character) ); ret
}

t_val ml_glutstrokewidth( value ml_font, value character )
{
    void *font;
    font = (void *) stroke_font_table[Int_val(ml_font)];
    return Val_int(glutStrokeWidth( font, Int_val(character) ));
}


t_val ml_glutbitmapheight( value ml_font ) {
#if defined(__FREEGLUT_EXT_H__) || defined(__OPENGLUT_EXT_H__)
    void *font;
    font = (void *) bitmap_font_table[Int_val(ml_font)];
    return Val_int(glutBitmapHeight( font ));
#else
    caml_failwith("glutBitmapHeight: function not available");
#endif
}
t_val ml_glutstrokeheight( value ml_font ) {
#if defined(__FREEGLUT_EXT_H__) || defined(__OPENGLUT_EXT_H__)
    void *font;
    font = (void *) stroke_font_table[Int_val(ml_font)];
    return caml_copy_double(glutStrokeHeight( font ));
#else
    caml_failwith("glutStrokeHeight: function not available");
#endif
}



#if (GLUT_API_VERSION >= 4 || GLUT_XLIB_IMPLEMENTATION >= 9)

t_val ml_glutbitmaplength( value ml_font, value string )
{
    void *font;
    font = (void *) bitmap_font_table[Int_val(ml_font)];
    return Val_int( glutBitmapLength( font, (unsigned char *) String_val(string) ));
}

t_val ml_glutstrokelength( value ml_font, value string )
{
    void *font;
    font = (void *) stroke_font_table[Int_val(ml_font)];
    return Val_int(glutStrokeLength( font, (unsigned char *) String_val(string) ));
}

#else
t_val ml_glutbitmaplength( value ml_font, value string )
{
    caml_failwith("glutBitmapLength: function not available");
    return Val_int(0);
}
t_val ml_glutstrokelength( value ml_font, value string )
{
    caml_failwith("glutStrokeLength: function not available");
    return Val_int(0);
}
#endif


/* Geometric Object Rendering */

t_val ml_glutwiresphere( value radius, value slices, value stacks ) { glutWireSphere( Double_val(radius), Int_val(slices), Int_val(stacks) ); ret }
t_val ml_glutsolidsphere( value radius, value slices, value stacks ) { glutSolidSphere( Double_val(radius), Int_val(slices), Int_val(stacks) ); ret }
t_val ml_glutwirecone( value base, value height, value slices, value stacks ) { glutWireCone( Double_val(base), Double_val(height), Int_val(slices), Int_val(stacks) ); ret }
t_val ml_glutsolidcone( value base, value height, value slices, value stacks ) { glutSolidCone( Double_val(base), Double_val(height), Int_val(slices), Int_val(stacks) ); ret }
t_val ml_glutwirecube( value size) { glutWireCube( Double_val(size) ); ret }
t_val ml_glutsolidcube( value size) { glutSolidCube( Double_val(size) ); ret }
t_val ml_glutwiretorus( value innerRadius, value outerRadius, value sides, value rings ) { glutWireTorus( Double_val(innerRadius), Double_val(outerRadius), Int_val(sides), Int_val(rings) ); ret }
t_val ml_glutsolidtorus( value innerRadius, value outerRadius, value sides, value rings ) { glutSolidTorus( Double_val(innerRadius), Double_val(outerRadius), Int_val(sides), Int_val(rings) ); ret }
t_val ml_glutwiredodecahedron( value unit ) { glutWireDodecahedron(); ret }
t_val ml_glutsoliddodecahedron( value unit ) { glutSolidDodecahedron(); ret }
t_val ml_glutwireteapot( value size) { glutWireTeapot( Double_val(size) ); ret }
t_val ml_glutsolidteapot( value size) { glutSolidTeapot( Double_val(size) ); ret }
t_val ml_glutwireoctahedron( value unit ) { glutWireOctahedron(); ret }
t_val ml_glutsolidoctahedron( value unit ) { glutSolidOctahedron(); ret }
t_val ml_glutwiretetrahedron( value unit ) { glutWireTetrahedron(); ret }
t_val ml_glutsolidtetrahedron( value unit ) { glutSolidTetrahedron(); ret }
t_val ml_glutwireicosahedron( value unit ) { glutWireIcosahedron(); ret }
t_val ml_glutsolidicosahedron( value unit ) { glutSolidIcosahedron(); ret }

t_val ml_glutwirerhombicdodecahedron( value unit ) {
#if defined(__FREEGLUT_EXT_H__) || defined(__OPENGLUT_EXT_H__)
    glutWireRhombicDodecahedron(); ret
#else
    caml_failwith("glutWireRhombicDodecahedron: function not available");
#endif
}
t_val ml_glutsolidrhombicdodecahedron( value unit ) {
#if defined(__FREEGLUT_EXT_H__) || defined(__OPENGLUT_EXT_H__)
    glutSolidRhombicDodecahedron(); ret
#else
    caml_failwith("glutSolidRhombicDodecahedron: function not available");
#endif
}



/* Color Index */
/* TODO
void glutCopyColormap(int win);
*/

t_val ml_glutsetcolor( value ndx, value red, value green, value blue )
{
    glutSetColor( Int_val(ndx), Double_val(red), Double_val(green), Double_val(blue) ); ret
}

t_val ml_glutgetcolor( value index )
{
    CAMLparam1( index );
    CAMLlocal1( comp );

    GLfloat rgb[3];
    int ndx = Int_val(index);
    rgb[0] = glutGetColor( ndx, 0 );
    rgb[1] = glutGetColor( ndx, 1 );
    rgb[2] = glutGetColor( ndx, 2 );

    comp = caml_alloc(3, 0);

    Store_field( comp, 0, caml_copy_double( rgb[0] ) );
    Store_field( comp, 1, caml_copy_double( rgb[1] ) );
    Store_field( comp, 2, caml_copy_double( rgb[2] ) );

    CAMLreturn( comp );
}


/* TODO
// Overlay

// GLUT overlay sub-API.
GLUTAPI void GLUTAPIENTRY glutEstablishOverlay(void);
GLUTAPI void GLUTAPIENTRY glutRemoveOverlay(void);
GLUTAPI void GLUTAPIENTRY glutUseLayer(GLenum layer);
GLUTAPI void GLUTAPIENTRY glutPostOverlayRedisplay(void);
#if (GLUT_API_VERSION >= 4 || GLUT_XLIB_IMPLEMENTATION >= 11)
GLUTAPI void GLUTAPIENTRY glutPostWindowOverlayRedisplay(int win);
#endif
GLUTAPI void GLUTAPIENTRY glutShowOverlay(void);
GLUTAPI void GLUTAPIENTRY glutHideOverlay(void);
#endif
*/

/* vim: sw=4 sts=4 ts=4 et fdm=marker nowrap
 */
