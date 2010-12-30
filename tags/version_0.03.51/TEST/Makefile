# +-------------------------------------------------------------------+
# | This file contains compile rules to build a wraper to the OpenGL. |
# +-------------------------------------------------------------------+
# |  (C)  2006 - 2009  Florent Monnier   <fmonnier@linux-nantes.org>  |
# +-------------------------------------------------------------------+
# |                                                                   |
# | This program is free software; you can redistribute it and/or     |
# | modify it under the terms of the GNU General Public License       |
# | as published by the Free Software Foundation; either version 2    |
# | of the License, or (at your option) any later version.            |
# |                                                                   |
# | This program is distributed in the hope that it will be useful,   |
# | but WITHOUT ANY WARRANTY; without even the implied warranty of    |
# | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.              |
# | See the GNU General Public License for more details.              |
# |                                                                   |
# | You should have received a copy of the GNU General Public License |
# | along with this program ;                                         |
# | if not, write to the Free Software Foundation, Inc.,              |
# | 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA      |
# |                                                                   |
# +-------------------------------------------------------------------+
# | You can find the GNU General Public License on the internet too:  |
# | http://www.fsf.org/licensing/licenses/gpl.html                    |
# +-------------------------------------------------------------------+

include ../Makefile.depend

GL_WRAPER_SRC=../SRC

# GL_WRAPER_PATH := $(PREFIX)
  GL_WRAPER_PATH := $(GL_WRAPER_SRC)

all: test

SExprLite.cma:  SExprLite.cmi SExprLite.cmo
	$(OCAMLC) -a -o SExprLite.cma SExprLite.cmo

SExprLite.cmx: SExprLite.ml
	$(OCAMLOPT) -c SExprLite.ml

SExprLite.cmxa:  SExprLite.cmi SExprLite.cmx
	$(OCAMLOPT) -a -o SExprLite.cmxa SExprLite.cmx

# cma deps
$(GL_WRAPER_PATH)/GL.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) GL.cma)
$(GL_WRAPER_PATH)/Glu.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) Glu.cma)
$(GL_WRAPER_PATH)/Glut.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) Glut.cma)
$(GL_WRAPER_PATH)/vertArray.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) vertArray.cma)
$(GL_WRAPER_PATH)/VBO.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) VBO.cma -f Makefile.VBO)
$(GL_WRAPER_PATH)/jpeg_loader.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) jpeg_loader.cma)
$(GL_WRAPER_PATH)/png_loader.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) png_loader.cma -f Makefile.png)
$(GL_WRAPER_PATH)/svg_loader.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) svg_loader.cma -f Makefile.rsvg)
$(GL_WRAPER_PATH)/genimg_loader.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) genimg_loader.cma -f Makefile.IM)
$(GL_WRAPER_PATH)/ftgl.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) ftgl.cma -f Makefile.ftgl)
$(GL_WRAPER_PATH)/FunGL.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) fungl)
$(GL_WRAPER_PATH)/FunGlut.cma:
	(cd $(GL_WRAPER_SRC); $(MAKE) funglut)

# cmxa deps
$(GL_WRAPER_PATH)/GL.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) GL.cmxa)
$(GL_WRAPER_PATH)/Glu.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) Glu.cmxa)
$(GL_WRAPER_PATH)/Glut.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) Glut.cmxa)
$(GL_WRAPER_PATH)/vertArray.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) vertArray.cmxa)
$(GL_WRAPER_PATH)/VBO.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) VBO.cmxa)
$(GL_WRAPER_PATH)/jpeg_loader.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) jpeg_loader.cmxa)
$(GL_WRAPER_PATH)/png_loader.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) png_loader.cmxa -f Makefile.png)
$(GL_WRAPER_PATH)/svg_loader.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) svg_loader.cmxa -f Makefile.rsvg)
$(GL_WRAPER_PATH)/genimg_loader.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) genimg_loader.cmxa -f Makefile.IM)
$(GL_WRAPER_PATH)/ftgl.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) ftgl.cmxa -f Makefile.ftgl)
$(GL_WRAPER_PATH)/FunGL.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) fungl)
$(GL_WRAPER_PATH)/FunGlut.cmxa:
	(cd $(GL_WRAPER_SRC); $(MAKE) funglut)


# main deps
CMXA_DEPS=\
    $(GL_WRAPER_PATH)/GL.cmxa           \
    $(GL_WRAPER_PATH)/Glu.cmxa          \
    $(GL_WRAPER_PATH)/Glut.cmxa         \
    $(GL_WRAPER_PATH)/FunGL.cmxa        \
    $(GL_WRAPER_PATH)/FunGlut.cmxa      \
    $(GL_WRAPER_PATH)/vertArray.cmxa    \
    $(GL_WRAPER_PATH)/jpeg_loader.cmxa  \
    $(GL_WRAPER_PATH)/png_loader.cmxa   \
    $(GL_WRAPER_PATH)/svg_loader.cmxa   \
    $(GL_WRAPER_PATH)/ftgl.cmxa

# COMPILES A DEMO
# default demo to compile:
DEMO=demo_sexpr.ml
DEMO_OPT := $(patsubst %.ml,%.opt, $(DEMO))

# there are more modules than needed by the default demo,
# so that make can be called with DEMO defined with another demo, for example:
# make DEMO=outline.ml
$(DEMO_OPT):  $(DEMO)  $(CMXA_DEPS)  SExprLite.cmxa
	$(OCAMLOPT)  -o $@              \
	    -ccopt -L$(GL_WRAPER_PATH)  \
	    -I $(GL_WRAPER_PATH)        \
	    GL.cmxa Glu.cmxa Glut.cmxa  \
	    FunGL.cmxa  FunGlut.cmxa    \
	    vertArray.cmxa              \
	    jpeg_loader.cmxa            \
	    png_loader.cmxa             \
	    svg_loader.cmxa             \
	    ftgl.cmxa                   \
	    str.cmxa  bigarray.cmxa     \
	    SExprLite.cmxa              \
	    $<

# test

test: test-opt

test-opt: $(DEMO_OPT)
	./$(DEMO_OPT)


clean:
	rm -f *.[oa] *.cm[ixoa] *.cmxa *.opt

cleaner: clean
	rm -f *~

# vim: fdm=marker
