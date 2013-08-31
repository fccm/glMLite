GL_PATH=""
if [ -d ../SRC/ ]
then
	make ../SRC/{GL.cma,Glu.cma,Glut.cma}
	GL_PATH="../SRC/"
else
	GL_PATH="+glMLite"
fi
ocaml -I $GL_PATH GL.cma Glu.cma Glut.cma d1.ml
