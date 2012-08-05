# libraryrary makefile

TARGET=camlgphoto2

IMP=gPWidget.ml gPPortInfo.ml gPFileInfo.ml gPFile.ml gPContext.ml \
gPAbilities.ml gPCamera.ml gPMain.ml
WRP=$(wildcard wrap*.c)
SIG=$(IMP:.ml=.mli)
CMO=$(IMP:.ml=.cmo)
CMX=$(IMP:.ml=.cmx)

%.o: %.c
	@echo -n "(library) Building $@... "
	@$(OCAMLOPT) -ccopt -O3 -ccopt -fPIC -ccopt -Wno-int-to-pointer-cast -c $<
	@echo "Done"

dllcamlgphoto2.so: $(WRP:.c=.o)
	@echo -n "(library) Building $@... "
	@ocamlmklib  -L/usr/lib -lgphoto2 $^ -o camlgphoto2
	@echo "Done"

%.cmo: %.mli %.ml
	@echo -n "(library) Building $@... "
	@$(OCAMLC) -c $^
	@echo "Done"

%.cmx: %.mli %.ml
	@echo -n "(library) Building $@... "
	@$(OCAMLOPT) -c $^
	@echo "Done"

byt: $(CMO) dllcamlgphoto2.so
	@echo -n "(library) Building $@... "
	@$(OCAMLC) $(CMO) -a -o "$(TARGET).cma" \
	  -dllib -lcamlgphoto2 \
	  -ccopt -L/usr/lib \
	  -cclib -lgphoto2_port \
	  -cclib -lgphoto2
	@echo "Done"

opt: $(CMX) dllcamlgphoto2.so
	@echo -n "(library) Building $@... "
	@$(OCAMLOPT) $(CMX) -a -o "$(TARGET).cmxa" \
	  -cclib -lcamlgphoto2 \
	  -ccopt -L/usr/lib \
	  -cclib -lgphoto2_port \
	  -cclib -lgphoto2
	@echo "Done"

doc:
	@echo -n "(library) Building documentation... "
	@ocamldoc -html -colorize-code -stars -sort \
	  -d ../../api -t "$(TARGET)" \
	  -I ./build -I $(OCAMLDIR) \
	   $(SIG)
	@echo "Done"

all: clean byt opt doc

clean:
	@echo -n "(library) Cleaning up... "
	@rm -f *.[oa] *.so *.cm[iox]
	@echo "Done"
