include ../Makefile.depend

GL_PATH := "../SRC/"
#GL_PATH := "+glMLite"

all: ogl_draw.cmo ogl_matrix.cmo

shaders.cmo: shaders.ml
	$(OCAMLC) -c $<

shaders.cmx: shaders.ml
	$(OCAMLOPT) -c $<


#ogl_draw.mli: ogl_draw.ml
#	$(OCAMLC) -i -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $< > $@

ogl_draw.cmi: ogl_draw.mli
	$(OCAMLC) -c -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $<

ogl_draw.cmo: ogl_draw.ml ogl_draw.cmi shaders.cmo
	$(OCAMLC) -c -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $<

ogl_draw.cmx: ogl_draw.ml ogl_draw.cmi shaders.cmx
	$(OCAMLOPT) -c -I $(GL_PATH) GL.cmxa vertArray.cmxa VBO.cmxa $<

####################

ogl_matrix.cmi: ogl_matrix.mli
	$(OCAMLC) -c $<

ogl_matrix.cmo: ogl_matrix.ml ogl_matrix.cmi
	$(OCAMLC) -c $<

ogl_matrix.cmx: ogl_matrix.ml ogl_matrix.cmi
	$(OCAMLOPT) -c $<

clean:
	rm -f *.[oa] *.{opt,byte,cmxa} *.cm[ioxa]
.PHONY: clean all
