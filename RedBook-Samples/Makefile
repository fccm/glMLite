include ../Makefile.depend

VARR = varray.opt aapoly.opt
NOGLU = teaambient.opt
BA= picksquare_ba.opt bitmap.opt wrap.opt polys.opt font.opt texgen.opt drawf.opt
STD= quadric.opt tesswind.opt accpersp.opt anti.opt bezcurve.opt bezmesh.opt blending.opt \
     depthcue.opt double.opt model.opt picksquare.opt plane.opt polyoff.opt robot.opt \
     sb2db.opt stencil_mask.opt stencil.opt fog.opt clip.opt alpha.opt unproject.opt \
     nurbs.opt cube.opt aargb.opt dof.opt movelight.opt accanti.opt stroke.opt

all: $(STD) $(VARR) $(BA) $(NOGLU)

$(VARR): %.opt: %.ml
	$(OCAMLOPT) -I ../$(SRC) GL.cmxa Glu.cmxa Glut.cmxa bigarray.cmxa vertArray.cmxa $< -o $@

$(BA): %.opt: %.ml
	$(OCAMLOPT) -I ../$(SRC) GL.cmxa Glu.cmxa Glut.cmxa bigarray.cmxa $< -o $@

$(STD): %.opt: %.ml
	$(OCAMLOPT) -I ../$(SRC) GL.cmxa Glu.cmxa Glut.cmxa $< -o $@

$(NOGLU): %.opt: %.ml
	$(OCAMLOPT) -I ../$(SRC) GL.cmxa Glut.cmxa $< -o $@


.PHONY: clean clean-build
clean: clean-build
	rm -f *.opt

clean-build:
	rm -f *.cm[iox] *.o

