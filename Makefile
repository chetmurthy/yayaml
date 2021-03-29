
OCAMLFIND=ocamlfind
NOT_OCAMLFIND=not-ocamlfind
PACKAGES=bos,fmt,camlp5.extprint,camlp5.extend,camlp5.pprintf,pcre,yaml,pa_ppx.deriving_plugins.std,pa_ppx.base.link,pa_ppx.runtime,pa_ppx.testutils,sedlex

OBJ=jsontypes.cmo jsontoken.cmo jsonparse.cmo tml.cmo

all: $(OBJ) yamltest jsontest ocamlyaml_tmltest bs4j_tmltest json_tmltest json_testsuite_test

yamltest: $(OBJ) yamltest.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -linkpkg -linkall -syntax camlp5r $^ -o $@

ocamlyaml_tmltest: $(OBJ) ocamlyaml_tmltest.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -linkpkg -linkall -syntax camlp5r $^ -o $@

bs4j_tmltest: $(OBJ) bs4j_tmltest.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -linkpkg -linkall -syntax camlp5r $^ -o $@

json_tmltest: $(OBJ) json_tmltest.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -linkpkg -linkall -syntax camlp5r $^ -o $@

json_testsuite_test: $(OBJ) json_testsuite_test.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -linkpkg -linkall -syntax camlp5r $^ -o $@

jsontest: $(OBJ) jsontest.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -linkpkg -linkall -syntax camlp5r $^ -o $@

test:: all
	mkdir -p _build
	./jsontest -runner sequential || true
#	./yamltest || true

testsuite:: test
#	./ocamlyaml_tmltest || true
	./bs4j_tmltest || true
	./json_tmltest || true
	./json_testsuite_test || true

just-testsuite:: all
#	./ocamlyaml_tmltest || true
	./bs4j_tmltest || true
	./json_tmltest || true
	./json_testsuite_test || true

.SUFFIXES: .mll .ml .cmo .cmx

jsontypes.cmo: jsontypes.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<

jsontest.cmo: jsontest.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<
tml.cmo: tml.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),sedlex,oUnit -syntax camlp5o -c $<

jsonparse.cmo: jsonparse.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),sedlex,oUnit -syntax camlp5r -c $<

jsontoken.cmo: jsontoken.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package fmt,camlp5.gramlib,sedlex.ppx -c $<

yamltest.cmo: yamltest.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<

ocamlyaml_tmltest.cmo: ocamlyaml_tmltest.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<

bs4j_tmltest.cmo: bs4j_tmltest.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<

json_tmltest.cmo: json_tmltest.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<

json_testsuite_test.cmo: json_testsuite_test.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<

jsontest.cmo: jsontest.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package $(PACKAGES),oUnit -syntax camlp5o -c $<

.mll.ml:
	ocamllex $<
#	perl -p -i -e 's,#.*,,' $@

clean:
	rm -rf *test *.cm* *.o yamllexer.ml _build *.log *.cache


depend::
	$(OCAMLFIND) ocamldep $(DEBUG) -package $(PACKAGES) -syntax camlp5o \
		tml.ml jsontypes.ml \
		yamltest.ml jsontest.ml \
		ocamlyaml_tmltest.ml bs4j_tmltest.ml \
		json_tmltest.ml json_testsuite_test.ml > .depend.NEW || true
	$(OCAMLFIND) ocamldep $(DEBUG) -package sedlex.ppx jsontoken.ml >> .depend.NEW || true
	$(OCAMLFIND) ocamldep $(DEBUG) -package $(PACKAGES) -syntax camlp5r jsonparse.ml >> .depend.NEW
	mv .depend.NEW .depend

-include .depend