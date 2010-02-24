GL_PATH=""
if [ -d ../SRC/ ]
then
	make ../SRC/{GL.cma,Glu.cma,Glut.cma,vertArray.cma,VBO.cma}
	GL_PATH="../SRC/"
else
	GL_PATH="+glMLite"
fi
ocaml -I $GL_PATH bigarray.cma GL.cma Glu.cma Glut.cma vertArray.cma VBO.cma vbo_example.ml

