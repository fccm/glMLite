#! /bin/sh
#
# rundemo script.
# This script will launch each of the demo programs in turn.
#
make deps

echo " "
echo "--------------------------------------------------------------------"
echo " The most basic primitive is the cylinder primitive."
echo " Press left mouse button to move."
echo " Press middle mouse button to exit."
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=cylinder
./cylinder.opt


echo " "
echo "--------------------------------------------------------------------"
echo " Very similar to the cylinder primitive, but with different"
echo " radius along the path."
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=cone
./cone.opt


echo " "
echo "--------------------------------------------------------------------"
echo " The joinstyles connecting the poly-cylinder segments"
echo " can be modified."
echo " Use the middle mouse button to select a menu entry"
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=cylinder MAIN=mainjoin.ml OUTPUT=joinstyle
./joinstyle.opt


echo " "
echo "--------------------------------------------------------------------"
echo " By varying the radius, we can build a polycone."
echo " Note that the join style can be applied to cones as well."
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=cone MAIN=mainjoin.ml OUTPUT=joincone
./joincone.opt


echo " "
echo "--------------------------------------------------------------------"
echo " Alpha Blending (transparency) is now supported!"
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=alpha
./alpha.opt


echo " "
echo "--------------------------------------------------------------------"
echo " Sloppy Sax -- A more complicated polycone example"
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=horn
./horn.opt


echo " "
echo "--------------------------------------------------------------------"
echo " In fact, join styles can be applied to an arbitrary"
echo " cross-section."
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=texas
./texas.opt


echo " "
echo "--------------------------------------------------------------------"
echo " The way in which the join style is applied depends on the distance"
echo " of the contour from the origin."
echo " Compare the upper and lower figures for different join styles."
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=joinoffset
./joinoffset.opt


echo " "
echo "--------------------------------------------------------------------"
echo " In fact, joinstyles can be applied to non-closed contours as well."
echo " This demo also demonstrates the use of per-segment twisting."
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=twistoid
./twistoid.opt


echo " "
echo "--------------------------------------------------------------------"
echo " A different example of applying a twist."
echo "--------------------------------------------------------------------"
echo " "
make -f Makefile.demo DEMO=beam
./beam.opt

exit 0

# ------------------------------------------------------------
echo " "
echo "A generalized torus ..."
echo " "
./helix
#
# ------------------------------------------------------------
echo " "
echo "A generalized torus has a number of adjustable parameters"
echo " "
./helix2
#
# ------------------------------------------------------------
echo " "
echo "A generalized torus has a number of adjustable parameters"
echo " "
./helix3
#
# ------------------------------------------------------------
echo " "
echo "A generalized torus can even exhibit torsion"
echo " "
./helix4
#
# ------------------------------------------------------------
echo " "
echo "Torsion helps shear this candlestick profile"
echo " "
./candlestick
#
# ------------------------------------------------------------
echo " "
echo "Effect of Torsion vs. Parallel translation"
echo " "
./transport
#
# ------------------------------------------------------------
echo " "
echo "Texture mapped cylinders"
echo " "
./helixtex
#
# ------------------------------------------------------------
echo " "
echo "Simple Screw Shape"
echo " "
./screw
#
# ------------------------------------------------------------
echo " "
echo "Complex Screw Shape"
echo " "
./taper
#
# ------------------------------------------------------------
echo " "
echo "Misc other"
./twistex
./twoid

echo " end of demo --- That's all folks!"
