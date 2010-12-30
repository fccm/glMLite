#!/bin/sh

GL_PATH=""
if [ -d "../SRC/" ]
then
	make ../SRC/{GL.cma,Glu.cma,Glut.cma,jpeg_loader.cma,png_loader.cma,svg_loader.cma,genimg_loader.cma}
	GL_PATH="../SRC/"
else
	GL_PATH="+glMLite"
fi

IMG="wall-rgb.jpg"

if [ "$1" ]
then
      if [ -f "$1" ]
      then
            IMG="$1"
      fi
fi

BUF=""
for v in $*
do
      if [ $v == "-buf" ]
      then
            BUF="-buf"
      fi
done

echo "loading texture $IMG"

ocaml -I $GL_PATH GL.cma Glu.cma Glut.cma \
    jpeg_loader.cma \
    png_loader.cma \
    svg_loader.cma \
    genimg_loader.cma \
    loading_textures.ml  "$IMG"  $BUF

#EOF
