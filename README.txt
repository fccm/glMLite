
  glMLite is released under the terms of the GPL license.
  A copy of the GPL license is in the file 'LICENSE_GPL.txt'


  To compile the OCaml OpenGL wrapper, as usual:
    make

  To compile and run a test demo, try the command:
    make test

  To install:
    su -c 'make install'

  By default the install path is:
    `ocamlc -where`/glMLite/

  If you wish to install it in a non standard path, use:
    make install PREFIX=$HOME/my_gl

  (If you don't give an absolute path,
   the given path will be relative to the SRC/ directory)


  For findlib users, you can compile stuff with:
    ocamlfind ocamlc -linkpkg -package glMLite  foo.ml
  Or the traditional way, just:
    ocamlc -I +glMLite GL.cma Glu.cma Glut.cma  foo.ml


  If you don't need everything from this package, you can do
  partial builds.
  To only get the modules GL, Glu, Glut and vertArray:
    make core
    make install_core
  If you wish the VBO module (Vertex Buffer Object):
    make vbo
    make install_vbo
  If you wish the JPEG image loader (requires the libjpeg):
    make jpeg
    make install_jpeg
  If you wish the PNG image loader (requires the libpng):
    make png
    make install_png
  If you also wish the functional module (which is experimental):
    make fun
    make install_fun
  If you wish the beta Genimg_loader module (requires the libMagick):
    make genimg
    make install_genimg
  If you wish to load rastered SVG to use it as texture (requires the librsvg):
    make svg
    make install_svg
  If you wish to make extrusions along given path (does require the libgle):
    make gle
    make install_gle
  If you wish the ftgl lib wrapper (does require the libftgl):
    make ftgl
    make install_ftgl

  By default only the core and the jpeg targets are built.
  If you want to build and install everything run `make everything` and
  under root `make install_everything` but this will require that all the
  dependent libraries are installed along with their related header files.
  (Most often the package containing the header files for a library has the
  same name with an additional -devel suffix.  For example for the GLE the
  package of the library itself is libgle3-3.1.0 and the header files are in
  a package libgle3-devel-3.1.0 Idem for librsvg2-2.9.5 and librsvg2-devel-2.9.5
  and so on.)


  LablGL Interoperability:
  If you wish to swap from LablGL to glMLite or the opposite,
  the directory LablGL/ provides two different ways to achieve this task.
  It contains a README.txt file for explanations about this.


  The GL module is also known to work with the GLX module provided by this
  OCaml-Xlib bindings: http://www.linux-nantes.org/~fmonnier/OCaml/Xlib/

  You can get the last development version from the svn which is hosted
  at OCamlForge:
  https://forge.ocamlcore.org/scm/?group_id=142


  Send any questions, comments, bug reports or any other kind of problems, to:
    <fmonnier@linux-nantes.org>

