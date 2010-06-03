# compiling using the findLib:
PROG=`basename $1 .ml`.opt
QUAT_PATH="../toolbox/quaternions/"
PROG=`basename $1 .ml`.opt
pushd $QUAT_PATH
make quaternions.cmx
popd
make ogl_draw.cmx ogl_matrix.cmx
ocamlfind opt -linkpkg -package glMLite.vbo,glMLite.glut \
    -I . ogl_draw.cmx ogl_matrix.cmx \
    -I $QUAT_PATH quaternions.cmx \
    $1 -o $PROG
