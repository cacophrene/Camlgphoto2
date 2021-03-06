#! /bin/bash

LIBRARY_DIR=Library
PROGRAM_DIR=Application

# OCaml configuration.
ocamlc.opt -vnum >& /dev/null
if [ $? == 0 ]; then
  OCAMLC="ocamlc.opt"
else
  OCAMLC="ocamlc"
fi
echo "(config) Bytecode compiler: $OCAMLC"

ocamlopt.opt -vnum >& /dev/null
if [ $? == 0 ]; then
  OCAMLOPT="ocamlopt.opt"
else
  OCAMLOPT="ocamlopt"
fi
echo "(config) Native code compiler: $OCAMLOPT"

OCAMLDIR=$(ocamlc -where)
echo "(config) OCaml main directory: $OCAMLDIR"
export OCAMLDIR
OCAMLVNUM=$($OCAMLC -vnum)
if [ "$OCAMLVNUM" == "4.00.0" ]; then
  echo "(config) OCaml version: $OCAMLVNUM"
else
  echo "(config) Your OCaml version ($OCAMLVNUM) is obsolete!"
  exit 2
fi

cd $LIBRARY_DIR
mkdir build &> /dev/null
cp *.ml *.mli *.c *.h makefile build
cd build
make "OCAMLC=$OCAMLC" "OCAMLOPT=$OCAMLOPT" all
mkdir $OCAMLDIR/camlgphoto2 &> /dev/null
cp *.[ao] *.cm[iaox] *.cmxa ../*.ml ../*.mli ../*.[ch] $OCAMLDIR/camlgphoto2
cp dllcamlgphoto2.so $OCAMLDIR/stublibs
cd ../../api
sed -i "s/charset=iso-8859-1/charset=utf-8/" *.html

cd ../$PROGRAM_DIR
mkdir build &> /dev/null
cp *.ml *.mli makefile build
cd build
make "OCAMLC=$OCAMLC" "OCAMLOPT=$OCAMLOPT" all
mv camlgphoto2 ..
cd ..
cp camlgphoto2 /home/edouard/Bureau
