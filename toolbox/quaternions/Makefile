all: quaternions.cmx quaternions.cmo

quaternions.cmi: quaternions.mli
	ocamlopt -g -c quaternions.mli

quaternions.cmx: quaternions.ml quaternions.cmi
	ocamlopt -g -c quaternions.ml

quaternions.cmo: quaternions.ml quaternions.cmi
	ocamlc -g -c quaternions.ml

clean:
	rm -f *.cm[ioxa] *.o

.PHONY: all clean
