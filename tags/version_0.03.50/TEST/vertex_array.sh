GL_PATH=""
if [ -d ../SRC/ ]
then
	make ../SRC/{GL.cma,Glu.cma,Glut.cma,vertArray.cma}
	GL_PATH="../SRC/"
else
	GL_PATH="+glMLite"
fi
ocaml bigarray.cma -I $GL_PATH GL.cma Glu.cma Glut.cma vertArray.cma ./vertex_array.ml
