if [ -d `ocamlc -where`/Xlib ]
then
	:
else
	echo "This demo requires Xlib/GLX available from:"
	echo "http://decapode314.free.fr/ocaml/Xlib/"
	echo "https://github.com/fccm/ocaml-xlib"
	exit 1
fi

ocaml -I +glMLite GL.cma Glu.cma png_loader.cma -I +Xlib Xlib.cma GLX.cma keysym_match.cma lesson16.ml
