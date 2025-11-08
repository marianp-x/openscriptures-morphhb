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
NRM_OUTPUT_PATH := nrm
WRD_OUTPUT_PATH := wrd
TBL_OUTPUT_PATH := tbl
TSV_OUTPUT_PATH := tsv

BOOK_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(bookName).xml)
BOOK_FIXES_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(FIX_OUTPUT_PATH)/$(bookName)Fix.xml)
BOOK_FIXED_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(FIX_OUTPUT_PATH)/$(bookName).xml)
BOOK_NRMED_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(NRM_OUTPUT_PATH)/$(bookName).xml)
BOOK_WORDS_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(WRD_OUTPUT_PATH)/$(bookName).xml)
BOOK_TABLES_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(TBL_OUTPUT_PATH)/$(bookName).tsv)
BOOK_SCHEMAS_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(TBL_OUTPUT_PATH)/$(bookName).schema)
BOOK_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).tsv)
BOOK_SCHEMAs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).schema)
BOOK_DEBUGs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).debug)

.PHONY: all fixes norm tsvs words diffs diag

all: tsvs words

# FIX

fixes: $(BOOK_FIXED_XMLs)

$(FIX_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(FIX_OUTPUT_PATH)/%Fix.xml

$(FIX_OUTPUT_PATH)/%Fix.xml : BookFix.tsv $(FIX_OUTPUT_PATH) Makefile tsv2xml.pl BookFix.xsd xml.xsd
	perl -ane 'my $$bookId = $$F[0]; print if $$bookId =~ m/^$*$$/' <"$<" | tsv2xml.pl >"$@"
	/usr/bin/xmllint --nonet --schema "BookFix.xsd" --noout "$@"

.PRECIOUS: $(FIX_OUTPUT_PATH)/%.xml

$(FIX_OUTPUT_PATH)/%.xml : %.xml $(FIX_OUTPUT_PATH)/%Fix.xml $(FIX_OUTPUT_PATH) Makefile BookFix.xsl osisCore.2.1.1.xsd xml.xsd
	/usr/bin/xmllint --nonet --schema "osisCore.2.1.1.xsd" --noout "$*.xml"
	/usr/bin/xsltproc --nonet --stringparam "bookFixXmlFname" "$(FIX_OUTPUT_PATH)/$*Fix.xml" "BookFix.xsl" "$*.xml" >"$(FIX_OUTPUT_PATH)/$*.xml"
	/usr/bin/xmllint --nonet --schema "osisCore.2.1.1.xsd" --noout "$(FIX_OUTPUT_PATH)/$*.xml"

# NRM

norm: $(BOOK_NRMED_XMLs)

$(NRM_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(NRM_OUTPUT_PATH)/%.xml

$(NRM_OUTPUT_PATH)/%.xml : $(FIX_OUTPUT_PATH)/%.xml $(NRM_OUTPUT_PATH) Makefile BookNorm.xsl BookNorm.xsd xml.xsd
	/usr/bin/xsltproc --nonet --xinclude "BookNorm.xsl" "$(FIX_OUTPUT_PATH)/$*.xml" >"$@"
	/usr/bin/xmllint --nonet --schema "BookNorm.xsd" --noout "$@"

# TSV output:

tsvs: $(TSV_OUTPUT_PATH)/WLC.tsv

$(TSV_OUTPUT_PATH):
	mkdir -p "$@"

$(TSV_OUTPUT_PATH)/WLC.tsv : $(BOOK_TSVs)
	/usr/bin/cat "$(TSV_OUTPUT_PATH)/Gen.schema" | head -n 1 >"$@"
	/usr/bin/cat $(BOOK_TSVs) >>"$@"

.PRECIOUS: $(TSV_OUTPUT_PATH)/%.tsv

$(TSV_OUTPUT_PATH)/%.tsv $(TSV_OUTPUT_PATH)/%.debug : $(TSV_OUTPUT_PATH) $(FIX_OUTPUT_PATH)/%.xml Makefile decode-books.pl
	decode-books.pl "$(FIX_OUTPUT_PATH)/$*.xml" \
		1>"$(TSV_OUTPUT_PATH)/$*.tsv" \
		3>"$(TSV_OUTPUT_PATH)/$*.debug" \
		4>"$(TSV_OUTPUT_PATH)/$*.schema"

# WRD

words: $(BOOK_WORDS_XMLs)

$(WRD_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(WRD_OUTPUT_PATH)/%.xml

$(WRD_OUTPUT_PATH)/%.xml : $(WRD_OUTPUT_PATH) $(NRM_OUTPUT_PATH)/%.xml Makefile BookWord.xsl BookWord.xsd
	/usr/bin/xsltproc --nonet "BookWord.xsl" $(NRM_OUTPUT_PATH)/$*.xml >"$@"
	/usr/bin/xmllint --nonet --schema "BookWord.xsd" --noout "$@"

# TBL

tables: $(TBL_OUTPUT_PATH)/WLC.tsv

$(TBL_OUTPUT_PATH)/WLC.tsv : $(BOOK_TABLES_TSVs)
	/usr/bin/cat "$(TBL_OUTPUT_PATH)/Gen.schema" | head -n 1 >"$@"
	/usr/bin/cat $(BOOK_TABLES_TSVs) >>"$@"

$(TBL_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(TBL_OUTPUT_PATH)/%.tsv

$(TBL_OUTPUT_PATH)/%.tsv : $(TBL_OUTPUT_PATH) $(WRD_OUTPUT_PATH)/%.xml BookTable.xsl Makefile
	/usr/bin/xsltproc --nonet --stringparam "bookSchemaFname" "$(TBL_OUTPUT_PATH)/$*.schema" "BookTable.xsl" $(WRD_OUTPUT_PATH)/$*.xml >"$@"

# DIFFs

diffs:
	/usr/bin/cut --delimiter="	" --fields=3,5-16,18- $(TSV_OUTPUT_PATH)/WLC.tsv >$(TSV_OUTPUT_PATH)/WLC-c.tsv
	/usr/bin/cut --delimiter="	" --fields=4,6-17,19- $(WRD_OUTPUT_PATH)/WLC.tsv >$(WRD_OUTPUT_PATH)/WLC-c.tsv
	"C:/Program Files/Vim/vim91/gvim.exe" -R -d +"set list" tsv/WLC-c.tsv wrd/WLC-c.tsv &

# Diag

diag: $(TSV_OUTPUT_PATH)/Diag.tsv $(TSV_OUTPUT_PATH)/DiagStructure.tsv

$(TSV_OUTPUT_PATH)/Diag.tsv: Diag.xsl Makefile $(BOOK_XMLs)
	@echo "Element	@id	@type	@n" >"$@"
	/usr/bin/xsltproc --nonet "Diag.xsl" $(BOOK_XMLs) >>"$@"

$(TSV_OUTPUT_PATH)/DiagStructure.tsv: DiagStructure.xsl Makefile $(BOOK_XMLs)
	/usr/bin/xsltproc --nonet "DiagStructure.xsl" $(BOOK_XMLs) | /usr/bin/sort --unique >"$@"

# Other

GENERATED:=\
	$(TSV_OUTPUT_PATH)/WLC.tsv \
	$(BOOK_FIXES_XMLs) \
	$(BOOK_FIXED_XMLs) \
	$(BOOK_NRMED_XMLs) \
	$(BOOK_WORDS_XMLs) \
	$(BOOK_SCHEMAS_TSVs) \
	$(BOOK_TSVs) \
	$(BOOK_SCHEMAs) \
	$(BOOK_DEBUGs)

# Helpers

clean:
	rm -f \
		$(GENERATED)

edit:
	"C:/Program Files/Vim/vim91/gvim.exe" -R +"set guifont=Consolas:h18" +"set number" +"set wrap" +"set delcombine" +"set maxcombine=6" \
		"$(TSV_OUTPUT_PATH)/WLC.tsv" \
		"$(WRD_OUTPUT_PATH)/WLC.tsv" \
		$(BOOK_XMLs) \
		$(BOOK_FIXES_XMLs) \
		$(BOOK_FIXED_XMLs) \
		$(BOOK_NRMED_XMLs) \
		$(BOOK_WORDS_XMLs) \
		$(BOOK_SCHEMAS_TSVs) \
		$(BOOK_TSVs) \
		$(BOOK_SCHEMAs) \
		$(BOOK_DEBUGs) \
		&
	"C:/Program Files/Vim/vim91/gvim.exe" +"set number" +"set delcombine" +"set maxcombine=6" \
		"Makefile" \
		"README.md" \
		"tsv2xml.pl" \
		"decode-books.pl" \
		"BookFix.tsv" \
		"BookFix.xsl" \
		"BookFix.xsd" \
		"BookNorm.xsl" \
		"BookNorm.xsd" \
		"BookWord.xsl" \
		"BookWord.xsd" \
		"Diag.xsl" \
		"osisCore.2.1.1.xsd" \
		"xml.xsd" \
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
