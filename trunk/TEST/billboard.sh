GL_PATH=""
if [ -d ../SRC/ ]
then
	make ../SRC/{GL.cma,Glu.cma,Glut.cma,jpeg_loader.cma}
	GL_PATH="../SRC/"
else
	GL_PATH="+glMLite"
fi
ocaml -I $GL_PATH GL.cma Glu.cma Glut.cma jpeg_loader.cma ./billboard.ml
