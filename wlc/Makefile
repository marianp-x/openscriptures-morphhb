BOOK_NAMEs := \
    1Chr \
    1Kgs \
    1Sam \
    2Chr \
    2Kgs \
    2Sam \
    Amos \
    Dan \
    Deut \
    Eccl \
    Esth \
    Exod \
    Ezek \
    Ezra \
    Gen \
    Hab \
    Hag \
    Hos \
    Isa \
    Jer \
    Job \
    Joel \
    Jonah \
    Josh \
    Judg \
    Lam \
    Lev \
    Mal \
    Mic \
    Nah \
    Neh \
    Num \
    Obad \
    Prov \
    Ps \
    Ruth \
    Song \
    Zech \
    Zeph

FIX_OUTPUT_PATH := fix
TSV_OUTPUT_PATH := tsv

BOOK_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(bookName).xml)
BOOK_FIXES_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(FIX_OUTPUT_PATH)/$(bookName)Fixes.xml)
BOOK_FIXED_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(FIX_OUTPUT_PATH)/$(bookName).xml)
BOOK_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).tsv)
BOOK_SCHEMAs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).schema)
BOOK_DEBUGs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).debug)

GENERATED:=\
	$(TSV_OUTPUT_PATH)/WLC.tsv \
	$(BOOK_FIXES_XMLs) \
	$(BOOK_FIXED_XMLs) \
	$(BOOK_TSVs) \
	$(BOOK_SCHEMAs) \
	$(BOOK_DEBUGs)

all: $(TSV_OUTPUT_PATH)/WLC.tsv

$(TSV_OUTPUT_PATH)/WLC.tsv : $(BOOK_TSVs)
	/usr/bin/cat "$(TSV_OUTPUT_PATH)/Gen.schema" | head -n 1 >"$@"
	/usr/bin/cat $(BOOK_TSVs) >>"$@"

$(FIX_OUTPUT_PATH):
	mkdir -p "$@"

$(TSV_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(FIX_OUTPUT_PATH)/%Fixes.xml

$(FIX_OUTPUT_PATH)/%Fixes.xml : BookFixes.tsv Makefile tsv2xml.pl
	perl -ane 'my $$bookId = $$F[0]; print if $$bookId =~ m/^$*$$/' <"$<" | tsv2xml.pl >"$@"

.PRECIOUS: $(FIX_OUTPUT_PATH)/%.xml

$(FIX_OUTPUT_PATH)/%.xml : %.xml $(FIX_OUTPUT_PATH)/%Fixes.xml $(FIX_OUTPUT_PATH) Makefile BookFix.xsl osisCore.2.1.1.xsd
	/usr/bin/xmllint --nonet --schema "osisCore.2.1.1.xsd" --noout "$*.xml"
	/usr/bin/xsltproc --nonet --xinclude --stringparam "bookId" "$*" "BookFix.xsl" "$*.xml" >"$(FIX_OUTPUT_PATH)/$*.xml"
	/usr/bin/xmllint --nonet --schema "osisCore.2.1.1.xsd" --noout "$(FIX_OUTPUT_PATH)/$*.xml"

.PRECIOUS: $(TSV_OUTPUT_PATH)/%.tsv

$(TSV_OUTPUT_PATH)/%.tsv $(TSV_OUTPUT_PATH)/%.debug : $(TSV_OUTPUT_PATH) $(FIX_OUTPUT_PATH)/%.xml Makefile decode-books.pl
	decode-books.pl "$(FIX_OUTPUT_PATH)/$*.xml" \
		1>"$(TSV_OUTPUT_PATH)/$*.tsv" \
		3>"$(TSV_OUTPUT_PATH)/$*.debug" \
		4>"$(TSV_OUTPUT_PATH)/$*.schema"

# Diag

diag: $(TSV_OUTPUT_PATH)/Diag.tsv

$(TSV_OUTPUT_PATH)/Diag.tsv: Diag.xsl Makefile $(BOOK_XMLs)
	@echo "Element	@id	@type	@n" >"$@"
	/usr/bin/xsltproc --nonet "Diag.xsl" $(BOOK_XMLs) >>"$@"

# Testing

TST_OUTPUT_PATH := tst

$(TST_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(TST_OUTPUT_PATH)/%.tsv

$(TST_OUTPUT_PATH)/%.tsv : $(TST_OUTPUT_PATH) $(FIX_OUTPUT_PATH)/%.xml BooksToWords.xsl Makefile
	/usr/bin/xsltproc --nonet "BooksToWords.xsl" $(FIX_OUTPUT_PATH)/$*.xml >"$@"

# Helpers

clean:
	rm -f \
		$(GENERATED)

edit:
	"C:/Program Files/Vim/vim91/gvim.exe" +"set guifont=Consolas:h18" +"set number" +"set delcombine" +"set maxcombine=6" \
		"Makefile" \
		"README.md" \
		"tsv2xml.pl" \
		"decode-books.pl" \
		"BookFix.xsl" \
		"BooksToWords.xsl" \
		"Diag.xsl" \
		"BookFixes.tsv" \
		"$(TSV_OUTPUT_PATH)/WLC.tsv" \
		$(BOOK_XMLs) \
		$(BOOK_TSVs) \
		$(BOOK_DEBUGs) \
		"osisCore.2.1.1.xsd" \
		&

validate:
	/usr/bin/xmllint --nonet --schema "osisCore.2.1.1.xsd" --noout $(BOOK_XMLs)

print:
	@echo "BOOK_NAMEs($(BOOK_NAMEs))"
	@echo "BOOK_XMLs($(BOOK_XMLs))"
	@echo "BOOK_FIXES_XMLs($(BOOK_FIXES_XMLs))"
	@echo "BOOK_FIXED_XMLs($(BOOK_FIXED_XMLs))"
	@echo "BOOK_TSVs($(BOOK_TSVs))"
	@echo "BOOK_SCHEMAs($(BOOK_SCHEMAs))"
	@echo "BOOK_DEBUGs($(BOOK_DEBUGs))"
	@echo "GENERATED($(GENERATED))"
