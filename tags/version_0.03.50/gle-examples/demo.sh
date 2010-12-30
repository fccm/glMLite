demo=`basename $1 .ml`
make -f Makefile.demo DEMO=${demo}
./${demo}.opt
