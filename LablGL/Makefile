all: sed  LablGL.cma LablGL.cmxa

sed:\
      LablGL_to_glMLite.sed.sh \
      glMLite_to_LablGL.sed.sh


LablGL_to_glMLite.sed.sh: LablGL_to_glMLite.ml  LablGL_to_glMLite.tab
	ocaml $< > $@

glMLite_to_LablGL.sed.sh: LablGL_to_glMLite.ml  LablGL_to_glMLite.tab
	ocaml $< -rev > $@

.PHONY: deps test clean

deps-cma:
	(cd ../SRC/; $(MAKE) GL.cma Glu.cma Glut.cma)
deps-cmxa:
	(cd ../SRC/; $(MAKE) GL.cmx Glu.cmx Glut.cmx)

test: cma-deps
	ocaml -I ../SRC/ GL.cma Glu.cma Glut.cma  LablGL.ml

LablGL.cma: LablGL.ml deps-cma
	ocamlc -a -o $@ -I ../SRC/  GL.cma  Glu.cma  Glut.cma  $<

LablGL.cmxa: LablGL.ml deps-cmxa
	ocamlopt -a -o $@ -I ../SRC/  GL.cmx  Glu.cmx  Glut.cmx  $<

clean:
	rm -f *.sed.sh *.[oa] *.cm[ioxa] *.cmxa


