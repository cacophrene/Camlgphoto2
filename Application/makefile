# camlgphoto2 library makefile

TARGET=camlgphoto2

DIR=-I +lablgtk2 -I +camlgphoto2
LIB=lablgtk.cma unix.cma camlgphoto2.cma
FLAGS=-w s -g
OPTFLAGS=-w s -g -nodynlink -unsafe

IMP=gUI.ml param.ml action.ml
CMO=$(IMP:.ml=.cmo)
CMX=$(IMP:.ml=.cmx)
MAIN=camlgphoto2.ml

%.cmo: %.mli %.ml
	@echo -n "(software) Building $@... "
	@$(OCAMLC) $(FLAGS) $(DIR) -c $^
	@echo "Done"

%.cmx: %.mli %.ml
	@echo -n "(software) Building $@... "
	@$(OCAMLOPT) $(OPTFLAGS) $(DIR) -c $^
	@echo "Done"

byt: $(CMO)
	@echo -n "(software) Building $@... "
	@$(OCAMLC) $(FLAGS) $(DIR) $(LIB) $(CMO) $(MAIN) -o "$(TARGET)"
	@echo "Done"

opt: $(CMX)
	@echo -n "(software) Building $@... "
	@$(OCAMLOPT) $(OPTFLAGS) $(DIR) $(LIB:.cma=.cmxa) $(CMX) $(MAIN) -o "$(TARGET)" 
	@echo "Done"

all: clean byt opt

clean:
	@echo -n "(software) Cleaning up... "
	@rm -f *.[oa] *.cm[iox]
	@echo "Done"
