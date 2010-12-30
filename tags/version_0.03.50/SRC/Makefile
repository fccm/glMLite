# {{{ COPYING 
#
# +-----------------------------------------------------------------------+
# |  This file contains compile rules to build glMLite, an OCaml binding  |
# |  to the OpenGL API.                                                   |
# +-----------------------------------------------------------------------+
# |  Copyright (C) 2006, 2007, 2008  Florent Monnier                      |
# |  Contact:  <fmonnier@linux-nantes.org>                                |
# +-----------------------------------------------------------------------+
# |  This program is free software: you can redistribute it and/or        |
# |  modify it under the terms of the GNU General Public License          |
# |  as published by the Free Software Foundation, either version 3       |
# |  of the License, or (at your option) any later version.               |
# |                                                                       |
# |  This program is distributed in the hope that it will be useful,      |
# |  but WITHOUT ANY WARRANTY; without even the implied warranty of       |
# |  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        |
# |  GNU General Public License for more details.                         |
# |                                                                       |
# |  You should have received a copy of the GNU General Public License    |
# |  along with this program.  If not, see <http://www.gnu.org/licenses/> |
# +-----------------------------------------------------------------------+
#
# }}}

include ../Makefile.depend

all: core_byte core_opt \
     jpeg jpeg_opt \
     varray

everything: all fungl funglut doc

.PHONY: all everything

# {{{ Enums 

ENUMS_DIR=enums

# enums are generated in the directory enums/
include ./Makefile.enums

# }}}
# {{{ mlpp 

include ./Makefile.mlpp

# }}}

.PHONY: core_byte core_opt
core_byte: gl_byte glu_byte glut_byte varray_byte
core_opt: gl_opt  glu_opt  glut_opt  varray_opt

# {{{ common rules 

%.cmi: %.mli
	$(OCAMLC) -c $<

# }}}
# {{{ GL 
.PHONY: gl gl_byte gl_opt
gl_byte: GL.cma
gl_opt: GL.cmxa
gl: gl_opt gl_byte

ML_GL_INCS=\
    $(ENUMS_DIR)/primitive.inc.ml         \
    $(ENUMS_DIR)/gl_capability.inc.ml     $(ENUMS_DIR)/polygon_mode.inc.ml         \
    $(ENUMS_DIR)/face_mode.inc.ml         $(ENUMS_DIR)/clear_mask.inc.ml           \
    $(ENUMS_DIR)/gl_error.inc.ml          $(ENUMS_DIR)/matrix_mode.inc.ml          \
    $(ENUMS_DIR)/shade_mode.inc.ml        $(ENUMS_DIR)/tex_param_target.inc.ml     \
    $(ENUMS_DIR)/gl_func.inc.ml           $(ENUMS_DIR)/hint_target.inc.ml          \
    $(ENUMS_DIR)/hint_mode.inc.ml         $(ENUMS_DIR)/list_mode.inc.ml            \
    $(ENUMS_DIR)/blend_sfactor.inc.ml     $(ENUMS_DIR)/blend_dfactor.inc.ml        \
    $(ENUMS_DIR)/map2_target.inc.ml       $(ENUMS_DIR)/map1_target.inc.ml          \
    $(ENUMS_DIR)/render_mode.inc.ml       $(ENUMS_DIR)/color_material_mode.inc.ml  \
    $(ENUMS_DIR)/enabled_cap.inc.ml       $(ENUMS_DIR)/pixel_data_format.inc.ml    \
    $(ENUMS_DIR)/internal_format.inc.ml   $(ENUMS_DIR)/pixel_data_type.inc.ml      \
    $(ENUMS_DIR)/pixel_buffer_type.inc.ml $(ENUMS_DIR)/pixel_buffer_format.inc.ml  \
    $(ENUMS_DIR)/orientation.inc.ml       $(ENUMS_DIR)/texture_binding.inc.ml      \
    $(ENUMS_DIR)/get_integer_4.inc.ml     $(ENUMS_DIR)/get_boolean_1.inc.ml        \
    $(ENUMS_DIR)/get_string.inc.ml        $(ENUMS_DIR)/get_matrix.inc.ml           \
    $(ENUMS_DIR)/get_integer_1.inc.ml     $(ENUMS_DIR)/get_float_3.inc.ml          \
    $(ENUMS_DIR)/get_float_1.inc.ml       $(ENUMS_DIR)/get_float_2.inc.ml          \
    $(ENUMS_DIR)/get_float_4.inc.ml       $(ENUMS_DIR)/get_integer_2.inc.ml        \
    $(ENUMS_DIR)/get_boolean_4.inc.ml     $(ENUMS_DIR)/texture_i.inc.ml            \
    $(ENUMS_DIR)/get_texture_binding.inc.ml \
    $(ENUMS_DIR)/texenv_target.inc.ml     $(ENUMS_DIR)/texenv_pname.inc.ml         \
    $(ENUMS_DIR)/texenv_param.inc.ml      $(ENUMS_DIR)/attrib_bit.inc.ml           \
    $(ENUMS_DIR)/stencil_op.inc.ml        $(ENUMS_DIR)/target_2d.inc.ml            \
    $(ENUMS_DIR)/pixel_packing_i.inc.ml   $(ENUMS_DIR)/pixel_packing_b.inc.ml      \
    $(ENUMS_DIR)/pixel_transfer_i.inc.ml  $(ENUMS_DIR)/pixel_transfer_f.inc.ml     \
    $(ENUMS_DIR)/pixel_transfer_b.inc.ml  $(ENUMS_DIR)/pixel_transfer_f_ARB.inc.ml \
    $(ENUMS_DIR)/accum_op.inc.ml          $(ENUMS_DIR)/blend_mode.inc.ml           \
    $(ENUMS_DIR)/blend_mode_ext.inc.ml    $(ENUMS_DIR)/op_code.inc.ml              \
    $(ENUMS_DIR)/draw_buffer_mode.inc.ml  $(ENUMS_DIR)/read_buffer_mode.inc.ml     \
    $(ENUMS_DIR)/copy_tex_target.inc.ml   $(ENUMS_DIR)/pixel_map.inc.ml            \
    $(ENUMS_DIR)/min_filter.inc.ml        $(ENUMS_DIR)/mag_filter.inc.ml           \
    $(ENUMS_DIR)/wrap_param.inc.ml        \
    $(ENUMS_DIR)/tex_coord.inc.ml         $(ENUMS_DIR)/tex_coord_gen_func.inc.ml   \
    $(ENUMS_DIR)/tex_gen_param.inc.ml     $(ENUMS_DIR)/clip_plane.inc.ml           \
    $(ENUMS_DIR)/pixel_type.inc.ml        $(ENUMS_DIR)/tex_coord_fun_params.inc.ml \
    $(ENUMS_DIR)/buffer_object_target.inc.ml \
    $(ENUMS_DIR)/vbo_usage_pattern.inc.ml

#   $(ENUMS_DIR)/tex_parameter.inc.ml     $(ENUMS_DIR)/tex_param_pname.inc.ml      \

GL.ml: GL.ml.pp $(ML_GL_INCS) $(MLPP)
	$(MLPP) -C $<  > $@

GL.mli: GL.ml.pp $(ML_GL_INCS) $(MLPP)
	$(MLPP) -D MLI -C $<  > $@
	ocaml struct_to_sig.ml $@   # 's/= struct/: sig/g'

GL.cmi: GL.mli $(ML_GL_INCS)

GL.cmx: GL.ml GL.cmi
	$(OCAMLOPT) -c $<

GL.cmo: GL.ml GL.cmi
	$(OCAMLC) -c $<

C_GL_INCS=\
    $(ENUMS_DIR)/gl_capability.inc.c       $(ENUMS_DIR)/polygon_mode.inc.c         \
    $(ENUMS_DIR)/face_mode.inc.c           $(ENUMS_DIR)/clear_mask.inc.c           \
    $(ENUMS_DIR)/face_mode.inc-r.c         \
    $(ENUMS_DIR)/gl_error.inc-r.c          $(ENUMS_DIR)/matrix_mode.inc.c          \
    $(ENUMS_DIR)/shade_mode.inc.c          $(ENUMS_DIR)/tex_param_target.inc.c     \
    $(ENUMS_DIR)/gl_func.inc.c             $(ENUMS_DIR)/hint_target.inc.c          \
    $(ENUMS_DIR)/hint_mode.inc.c           $(ENUMS_DIR)/list_mode.inc.c            \
    $(ENUMS_DIR)/blend_sfactor.inc.c       $(ENUMS_DIR)/blend_dfactor.inc.c        \
    $(ENUMS_DIR)/map2_target.inc.c         $(ENUMS_DIR)/map1_target.inc.c          \
    $(ENUMS_DIR)/render_mode.inc.c         $(ENUMS_DIR)/color_material_mode.inc.c  \
    $(ENUMS_DIR)/enabled_cap.inc.c         $(ENUMS_DIR)/pixel_data_type.inc.c      \
    $(ENUMS_DIR)/pixel_data_format.inc.c   $(ENUMS_DIR)/internal_format.inc.c      \
    $(ENUMS_DIR)/pixel_data_format.inc-r.c $(ENUMS_DIR)/internal_format.inc-r.c    \
    $(ENUMS_DIR)/pixel_buffer_type.inc.c   $(ENUMS_DIR)/pixel_buffer_format.inc.c  \
    $(ENUMS_DIR)/orientation.inc.c         $(ENUMS_DIR)/texture_binding.inc.c      \
    $(ENUMS_DIR)/get_integer_4.inc.c       $(ENUMS_DIR)/get_boolean_1.inc.c        \
    $(ENUMS_DIR)/get_string.inc.c          $(ENUMS_DIR)/get_matrix.inc.c           \
    $(ENUMS_DIR)/get_integer_1.inc.c       $(ENUMS_DIR)/get_float_3.inc.c          \
    $(ENUMS_DIR)/get_float_1.inc.c         $(ENUMS_DIR)/get_float_2.inc.c          \
    $(ENUMS_DIR)/get_float_4.inc.c         $(ENUMS_DIR)/get_integer_2.inc.c        \
    $(ENUMS_DIR)/get_boolean_4.inc.c       $(ENUMS_DIR)/texture_i.inc.c            \
    $(ENUMS_DIR)/get_texture_binding.inc.c \
    $(ENUMS_DIR)/texenv_target.inc.c       $(ENUMS_DIR)/texenv_pname.inc.c         \
    $(ENUMS_DIR)/texenv_param.inc.c        $(ENUMS_DIR)/attrib_bit.inc.c           \
    $(ENUMS_DIR)/stencil_op.inc.c          $(ENUMS_DIR)/target_2d.inc.c            \
    $(ENUMS_DIR)/pixel_packing_i.inc.c     $(ENUMS_DIR)/pixel_packing_b.inc.c      \
    $(ENUMS_DIR)/pixel_transfer_i.inc.c    $(ENUMS_DIR)/pixel_transfer_f.inc.c     \
    $(ENUMS_DIR)/pixel_transfer_b.inc.c    $(ENUMS_DIR)/pixel_transfer_f_ARB.inc.c \
    $(ENUMS_DIR)/accum_op.inc.c            $(ENUMS_DIR)/blend_mode.inc.c           \
    $(ENUMS_DIR)/blend_mode_ext.inc.c      $(ENUMS_DIR)/op_code.inc.c              \
    $(ENUMS_DIR)/draw_buffer_mode.inc.c    $(ENUMS_DIR)/read_buffer_mode.inc.c     \
    $(ENUMS_DIR)/copy_tex_target.inc.c     $(ENUMS_DIR)/pixel_map.inc.c            \
    $(ENUMS_DIR)/list_mode.inc-r.c         \
    $(ENUMS_DIR)/min_filter.inc.c          $(ENUMS_DIR)/mag_filter.inc.c           \
    $(ENUMS_DIR)/wrap_param.inc.c          \
    $(ENUMS_DIR)/tex_coord.inc.c           $(ENUMS_DIR)/tex_coord_gen_func.inc.c   \
    $(ENUMS_DIR)/tex_gen_param.inc.c       $(ENUMS_DIR)/clip_plane.inc.c           \
    $(ENUMS_DIR)/pixel_type.inc.c          $(ENUMS_DIR)/tex_coord_fun_params.inc.c \
    $(ENUMS_DIR)/buffer_object_target_arb.inc.c \
    $(ENUMS_DIR)/vbo_usage_pattern_arb.inc.c    \
    $(ENUMS_DIR)/vbo_usage_pattern_arb.inc-r.c

#   $(ENUMS_DIR)/tex_param_pname.inc.c     $(ENUMS_DIR)/tex_parameter.inc.c        \

gl.wrap.o: gl.wrap.c  $(C_GL_INCS)
ifeq ($(USE_GL3_CORE_PROFILE),OK)
	$(OCAMLC)  -c -ccopt -DUSE_MY_GL3_CORE_PROFILE $<
else
	$(OCAMLC)  -c  $<
endif


ifeq ($(USE_GL3_CORE_PROFILE),OK)
gl3_deprecations.o: gl3_deprecations.c gl3_deprecations.h
	$(OCAMLC)  -c  $<

dllgl_stubs.so libgl_stubs.a: gl.wrap.o gl3_deprecations.o
	$(OCAMLMKLIB)  -oc  gl_stubs  $^  $(GL_LIBS)
else
dllgl_stubs.so libgl_stubs.a: gl.wrap.o
	$(OCAMLMKLIB)  -oc  gl_stubs  $<  $(GL_LIBS)
endif

GL.cmxa GL.a:  GL.cmx  dllgl_stubs.so
	$(OCAMLMKLIB)  -o  GL  $<  $(GL_LIBS) -lgl_stubs

GL.cma:  GL.cmo  dllgl_stubs.so
	$(OCAMLC) -a -o $@ -ccopt "$(GL_LIBS)" -dllib -lgl_stubs $<

GL.cmxs: GL.cmxa
	$(OCAMLOPT) -shared -linkall -o $@ $<

# }}}
# {{{ Glu 
.PHONY: glu glu_byte glu_opt
glu_byte: Glu.cma
glu_opt: Glu.cmxa
glu: glu_byte glu_opt


Glu.ml: Glu.ml.pp $(MLPP)
	$(MLPP) -C $<  > $@

Glu.mli: Glu.ml.pp $(MLPP)
	$(MLPP) -D MLI -C $<  > $@
	ocaml struct_to_sig.ml $@  # 's/= struct/: sig/g'


Glu.cmi: Glu.mli GL.cmi
	$(OCAMLC) -c $<


Glu.cmx: Glu.ml Glu.cmi
	$(OCAMLOPT) -c $<

Glu.cmo: Glu.ml Glu.cmi
	$(OCAMLC) -c $<


C_GLU_INCS=\
    $(ENUMS_DIR)/gl_error.inc.c

glu.wrap.o: glu.wrap.c  $(C_GLU_INCS)
	$(OCAMLC) -c $<

dllGlu.so libGlu.a: glu.wrap.o
	$(OCAMLMKLIB) -o Glu  $<  $(GLU_LIBS)

Glu.cmxa Glu.a:  Glu.cmx  dllGlu.so
	$(OCAMLMKLIB) -o Glu  $<  $(GLU_LIBS)

Glu.cma:  Glu.cmo  dllGlu.so
	$(OCAMLMKLIB) -o Glu  $<  $(GLU_LIBS)

Glu.cmxs: Glu.cmxa
	$(OCAMLOPT) -shared -linkall -o $@ $<

# }}}
# {{{ Glut 
.PHONY: glut glut_byte glut_opt
glut_byte: Glut.cma
glut_opt: Glut.cmxa
glut: glut_byte glut_opt

ML_GLUT_INCS=\
    $(ENUMS_DIR)/mouse_button.inc.ml $(ENUMS_DIR)/mouse_button_state.inc.ml	\
    $(ENUMS_DIR)/init_mode.inc.ml    $(ENUMS_DIR)/special_key.inc.ml		\
    $(ENUMS_DIR)/game_mode.inc.ml    $(ENUMS_DIR)/visibility_state.inc.ml	\
    $(ENUMS_DIR)/entry_state.inc.ml  $(ENUMS_DIR)/get_state.inc.ml		\
    $(ENUMS_DIR)/glut_device.inc.ml  $(ENUMS_DIR)/cursor_type.inc.ml

Glut.ml: Glut.ml.pp  $(ML_GLUT_INCS) $(MLPP)
	$(MLPP) -C $<  >  $@

Glut.mli: Glut.mli.pp  $(ML_GLUT_INCS) $(MLPP)
	$(MLPP) -C $<  >  $@

Glut.cmx: Glut.ml Glut.cmi
	$(OCAMLOPT) -c $<

Glut.cmo: Glut.ml Glut.cmi
	$(OCAMLC)  -c $<

C_GLUT_INCS=\
    $(ENUMS_DIR)/mouse_button.inc.c   \
    $(ENUMS_DIR)/mouse_button.inc-r.c $(ENUMS_DIR)/mouse_button_state.inc-r.c	\
    $(ENUMS_DIR)/init_mode.inc.c      $(ENUMS_DIR)/special_key.inc-r.c		\
    $(ENUMS_DIR)/game_mode.inc.c      $(ENUMS_DIR)/visibility_state.inc-r.c	\
    $(ENUMS_DIR)/entry_state.inc-r.c  $(ENUMS_DIR)/get_state.inc.c		\
    $(ENUMS_DIR)/glut_device.inc.c    $(ENUMS_DIR)/cursor_type.inc.c


glut.wrap.o: glut.wrap.c  $(C_GLUT_INCS)
	$(OCAMLC)  -c  $<

dllGlut.so libGlut.a: glut.wrap.o
	$(OCAMLMKLIB)  -o  Glut  $<  $(GLUT_LIBS)

Glut.cmxa Glut.a:  Glut.cmx  dllGlut.so
	$(OCAMLMKLIB)  -o  Glut  $<  $(GLUT_LIBS)

Glut.cma:  Glut.cmo  dllGlut.so
	$(OCAMLMKLIB)  -o  Glut  $<  $(GLUT_LIBS)

Glut.cmxs: Glut.cmxa
	$(OCAMLOPT) -shared -linkall -o $@ $<

clean_glut:
	rm -f  glut.wrap.o dllGlut.so libGlut.a \
	  Glut.a Glut.cmx Glut.cmo Glut.cmxa Glut.cma Glut.cmxs \
	  $(C_GLUT_INCS)

.PHONY: clean_glut

# }}}

# {{{ Fun GL 
.PHONY: FunGL fungl
FunGL fungl: FunGL.cma FunGL.cmxa


FunGL.ml: FunGL.ml.pp $(ML_GL_INCS) $(MLPP)
	$(MLPP) -C $<  > $@

FunGL.mli: FunGL.ml.pp $(ML_GL_INCS) $(MLPP)
	$(MLPP) -D MLI -C $<  > $@
	ocaml struct_to_sig.ml $@   # 's/= struct/: sig/g'

FunGL.cmi: FunGL.mli GL.cmi

FunGL.cmx: FunGL.ml GL.cmi FunGL.cmi
	$(OCAMLOPT) -c $<

FunGL.cmo: FunGL.ml GL.cmi FunGL.cmi
	$(OCAMLC) -c $<

fungl.wrap.o: fungl.wrap.c  $(C_GL_INCS)
	$(OCAMLC) -c $<

dllFunGL.so libFunGL.a: fungl.wrap.o
	$(OCAMLMKLIB)  -o  FunGL  $<  $(GL_LIBS)

FunGL.cmxa FunGL.a:  FunGL.cmx  dllFunGL.so
	$(OCAMLMKLIB)  -o  FunGL  $<  $(GL_LIBS)

FunGL.cma:  FunGL.cmo  dllFunGL.so
	$(OCAMLMKLIB)  -o  FunGL  $<  $(GL_LIBS)


clean_fungl:
	rm -f FunGL.cm[ioxa] FunGL.{o,a,cmxa} *FunGL.{so,a}

.PHONY: clean_fungl

# }}}
# {{{ Fun Glut 
.PHONY: FunGlut funglut
FunGlut funglut: FunGlut.cma FunGlut.cmxa

FunGlut.mli: FunGlut.ml GL.cmi Glu.cmi Glut.cmi
	$(OCAMLC) -i $< > $@

FunGlut.cmi: FunGlut.mli
	$(OCAMLC) -c $<

FunGlut.cmo: FunGlut.ml FunGlut.cmi Glut.cmi GL.cmi Glu.cmi
	$(OCAMLC) -c $<

FunGlut.cmx: FunGlut.ml FunGlut.cmi Glut.cmi GL.cmi Glu.cmi
	$(OCAMLOPT) -c $<

#FunGlut.cmxa: FunGlut.cmx Glut.cmx
#	$(OCAMLMKLIB) -o FunGlut $^  $(GLUT_LIBS)

#FunGlut.cma: FunGlut.cmo Glut.cmo
#	$(OCAMLMKLIB) -o FunGlut $^  $(GLUT_LIBS)

FunGlut.cma: FunGlut.cmo
	$(OCAMLC) -a $< -o $@

FunGlut.cmxa: FunGlut.ml Glut.cmx
	$(OCAMLOPT) -a -o $@ Glut.cmx FunGlut.ml

# }}}

# {{{ doc 

DOC_DIR=doc

.PHONY: GLE.mli
GLE.mli:
	($(MAKE) GLE.mli -f Makefile.GLE)

doc: GL.mli GL.cmi Glu.mli Glut.mli \
     vertArray.mli VBO.mli GLE.mli \
     jpeg_loader.ml genimg_loader.ml svg_loader.ml png_loader.ml \
     FunGL.mli  FunGlut.ml FunGlut.cmi
	if [ ! -d $(DOC_DIR) ]; then mkdir $(DOC_DIR) ; fi
	$(OCAMLDOC)  \
	      GL.mli Glu.mli Glut.mli vertArray.mli VBO.mli GLE.mli ftgl.ml  \
	      jpeg_loader.ml png_loader.ml svg_loader.ml genimg_loader.ml  \
	      FunGL.mli  FunGlut.ml  \
	    -colorize-code -html  \
	    -css-style _style.css  \
	    -d $(DOC_DIR)
	cp .style.css $(DOC_DIR)/_style.css
	chmod  a+r  $(DOC_DIR)/_style.css


.PHONY: public_html install_doc
public_html: install_doc
install_doc: $(DOC_DIR)
	mkdir -p   $(DOC_INSTALL_PATH)
	cp -Rf $<  $(DOC_INSTALL_PATH)
	chmod a+rx $(DOC_INSTALL_PATH)
	chmod a+r  $(DOC_INSTALL_PATH)/*

clean-doc cleandoc:
	rm -rf $(DOC_DIR)/

# }}}
# {{{ gen-incs 

incs:\
	$(ML_GL_INCS)    \
	$(C_GL_INCS)     \
	$(C_GLU_INCS)    \
	$(ML_GLUT_INCS)  \
	$(C_GLUT_INCS)
	touch $^

# }}}

# {{{ jpeg loader 
.PHONY: jpeg jpeg_byte jpeg_opt
jpeg_byte: jpeg_loader.cma
jpeg_opt: jpeg_loader.cmxa
jpeg: jpeg_byte jpeg_opt

jpeg_loader.cmi jpeg_loader.cmo: jpeg_loader.ml  GL.cmi
	$(OCAMLC) -c $<

jpeg_loader.cmx jpeg_loader.o: jpeg_loader.ml
	$(OCAMLOPT) -c $<

loader-libjpeg.o: loader-libjpeg.c  loader-libjpeg-mem.c  loader-texure.h
	$(OCAMLC)  -c  $<

dlljpeg_loader.so libjpeg_loader.a: loader-libjpeg.o
	$(OCAMLMKLIB) -o jpeg_loader $< $(GL_LIBS) -L"`ocamlc -where`" -lbigarray -ljpeg

jpeg_loader.cmxa jpeg_loader.a:  jpeg_loader.cmx  dlljpeg_loader.so
	$(OCAMLMKLIB) -o jpeg_loader $< $(GL_LIBS) -L"`ocamlc -where`" -lbigarray -ljpeg

jpeg_loader.cma:  jpeg_loader.cmo  dlljpeg_loader.so
	$(OCAMLMKLIB) -o jpeg_loader $< $(GL_LIBS) -L"`ocamlc -where`" -lbigarray -ljpeg

# }}}

# {{{ Vertex Array 

include ./Makefile.VArray

# }}}
# {{{ VBO 

vbo: vbo_byte vbo_opt
vbo_byte:
	($(MAKE) vbo_byte -f Makefile.VBO)
vbo_opt:
	($(MAKE) vbo_opt -f Makefile.VBO)

VBO.mli:
	($(MAKE) VBO.mli -f Makefile.VBO)

clean_vbo:
	($(MAKE) vbo_clean -f Makefile.VBO)

# }}}

# {{{ clean 
.PHONY: clean cleaner clean-pp cleanall clean-all

clean:
	rm -f a.out *.so *.[oa] *.cm[ixoa] *.cmx[as] *.annot *.exe
cleaner:
	rm -f *~
clean-pp:
	rm -f  GL.ml{,i}  Glu.ml{,i}  Glut.ml{,i}
	rm -f FunGL.ml{,i}
	rm -f vertArray.ml{,i}

cleanall clean_all clean-all: clean cleaner clean-pp clean-conf clean-doc clean-mlpp clean-meta \
                              clean-enum-incs clean-enum-dist

# }}}

# {{{ install 

DIST_FILES_CORE=\
    GL.a   GL.cmi   GL.cmxa   GL.cmx    \
    Glu.a  Glu.cmi  Glu.cmxa  Glu.cmx   \
    Glut.a Glut.cmi Glut.cmxa Glut.cmx  \
    libgl_stubs.a     \
    libGlu.a          \
    libGlut.a         \
    GL.o    Glu.o    Glut.o     \
    GL.cma  Glu.cma  Glut.cma   \
    \
    vertArray.cma     \
    vertArray.cmi     \
    vertArray.cmxa    \
    vertArray.cmx     \
    vertArray.a       \
    vertArray.o       \
    libvertArray.a    \
#EOL
DIST_FILES_JPEG=\
    jpeg_loader.cma   \
    jpeg_loader.cmi   \
    jpeg_loader.cmxa  \
    jpeg_loader.cmx   \
    jpeg_loader.a     \
    jpeg_loader.o     \
    libjpeg_loader.a  \
#EOL
DIST_FILES_FUN=\
    FunGL.cma         \
    FunGL.cmi         \
    FunGL.cmxa        \
    FunGL.cmx         \
    FunGL.a           \
    FunGL.o           \
    libFunGL.a        \
    \
    FunGlut.cma       \
    FunGlut.cmi       \
    FunGlut.cmxa      \
    FunGlut.cmx       \
    FunGlut.a         \
    FunGlut.o         \
#EOL

SO_DIST_FILES_CORE=\
    dllgl_stubs.so    \
    dllGlu.so         \
    dllGlut.so        \
    dllvertArray.so   \
#EOL
SO_DIST_FILES_JPEG=\
    dlljpeg_loader.so \
#EOL
SO_DIST_FILES_FUN=\
    dllFunGL.so   \
#EOL

.PHONY: install  install_core  install_jpeg  install_fun
install: install_core  install_jpeg  install_fun

install_core: $(DIST_FILES_CORE)  $(SO_DIST_FILES_CORE) META
	if [ ! -d $(PREFIX) ]; then install -d $(PREFIX) ; fi

	for file in $(SO_DIST_FILES_CORE); do if [ -f $$file ];then install -m 0755 $$file $(SO_PREFIX)/; fi; done
	for file in $(DIST_FILES_CORE);    do if [ -f $$file ];then install -m 0644 $$file $(PREFIX)/; fi; done
	install -m 0644 META $(PREFIX)/


install_jpeg: $(DIST_FILES_JPEG)  $(SO_DIST_FILES_JPEG)
	if [ ! -d $(PREFIX) ]; then install -d $(PREFIX) ; fi

	for file in $(SO_DIST_FILES_JPEG); do if [ -f $$file ];then install -m 0755 $$file $(SO_PREFIX)/; fi; done
	for file in $(DIST_FILES_JPEG);    do if [ -f $$file ];then install -m 0644 $$file $(PREFIX)/; fi; done


install_fun: $(DIST_FILES_FUN)  $(SO_DIST_FILES_FUN)
	if [ ! -d $(PREFIX) ]; then install -d $(PREFIX) ; fi

	for file in $(SO_DIST_FILES_FUN); do if [ -f $$file ];then install -m 0755 $$file $(SO_PREFIX)/; fi; done
	for file in $(DIST_FILES_FUN);    do if [ -f $$file ];then install -m 0644 $$file $(PREFIX)/; fi; done


uninstall:
	rm $(PREFIX)/*
	rmdir $(PREFIX)/

# }}}

# {{{ META 

#META: META.in
#	cp -f $< $@
#	sed -i -e "s:GL_LIBS:$(GL_LIBS):g" $@
#	sed -i -e "s:GLU_LIBS:$(GLU_LIBS):g" $@
#	sed -i -e "s:GLUT_LIBS:$(GLUT_LIBS):g" $@

META: META.in
	ocaml meta.ml \
	    -GL_LIBS "$(GL_LIBS)" \
	    -GLU_LIBS "$(GLU_LIBS)" \
	    -GLUT_LIBS "$(GLUT_LIBS)" \
	    $< > $@

cleanmeta clean-meta:
	rm -f META

# }}}
# {{{ findlib install 

install_findlib: $(DIST_FILES)  $(SO_DIST_FILES) META
	ocamlfind install glMLite $^

uninstall_findlib:
	ocamlfind remove glMLite

# }}}

# vim: fdm=marker
