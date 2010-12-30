# run this build script with:
# make -f lesson16.make

lesson16.opt: lesson16.ml
	ocamlopt \
	   -I +glMLite GL.cmxa Glu.cmxa png_loader.cmxa \
	   -I +Xlib Xlib.cmxa GLX.cmxa keysym_match.cmxa \
	   lesson16.ml -o $@

