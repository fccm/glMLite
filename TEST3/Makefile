GL_PATH := "../SRC/"
#GL_PATH := "+glMLite"

#ogl_draw.mli: ogl_draw.ml
#	ocamlc -i -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $< > $@

ogl_draw.cmi: ogl_draw.mli
	ocamlc -c -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $<

ogl_draw.cmo: ogl_draw.ml ogl_draw.cmi
	ocamlc -c -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $<

ogl_draw.cmx: ogl_draw.ml ogl_draw.cmi
	ocamlopt -c -I $(GL_PATH) GL.cmxa vertArray.cmxa VBO.cmxa $<

####################

ogl_matrix.cmi: ogl_matrix.mli
	ocamlc -c -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $<

ogl_matrix.cmo: ogl_matrix.ml ogl_matrix.cmi
	ocamlc -c -I $(GL_PATH) GL.cma vertArray.cma VBO.cma $<

ogl_matrix.cmx: ogl_matrix.ml ogl_matrix.cmi
	ocamlopt -c -I $(GL_PATH) GL.cmxa vertArray.cmxa VBO.cmxa $<

clean:
	rm -f *.[oa] *.{opt,byte,cmxa} *.cm[ioxa]
.PHONY: clean
