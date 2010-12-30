if [ ! -f "$1" ]
then
	echo "provide an .ml file as parameter"
	exit 1
fi
GL_PATH="../SRC/"
QUAT_PATH="../toolbox/quaternions/"
PROG=`basename $1 .ml`.opt
pushd $QUAT_PATH
make quaternions.cmx
popd
make ogl_draw.cmx ogl_matrix.cmx
ocamlopt.opt -g -I $GL_PATH GL.cmxa Glut.cmxa bigarray.cmxa vertArray.cmxa VBO.cmxa \
      -I . shaders.cmx ogl_draw.cmx ogl_matrix.cmx \
      -I $QUAT_PATH quaternions.cmx unix.cmxa $1 -o $PROG
