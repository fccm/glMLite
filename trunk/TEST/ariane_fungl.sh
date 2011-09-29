echo "Usage:"
echo "use arrows and + / - keys"
GL_PATH=""
if [ -d ../SRC/ ]
then
	make ../SRC/{GL.cma,Glu.cma,Glut.cma,FunGL.cma,FunGlut.cma}
	GL_PATH="../SRC/"
else
	GL_PATH="+glMLite"
fi
ocaml -I $GL_PATH GL.cma FunGL.cma Glu.cma Glut.cma FunGlut.cma ariane_fungl.ml $*
