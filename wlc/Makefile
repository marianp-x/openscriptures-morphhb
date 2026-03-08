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
IDX_OUTPUT_PATH := idx
WRD_OUTPUT_PATH := wrd
TBL_OUTPUT_PATH := tbl
TSV_OUTPUT_PATH := tsv

BOOK_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(bookName).xml)
BOOK_FIXES_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(FIX_OUTPUT_PATH)/$(bookName)Fix.xml)
BOOK_FIXED_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(FIX_OUTPUT_PATH)/$(bookName).xml)
BOOK_NRMED_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(NRM_OUTPUT_PATH)/$(bookName).xml)
BOOK_IDXED_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(IDX_OUTPUT_PATH)/$(bookName).xml)
BOOK_WORDS_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(WRD_OUTPUT_PATH)/$(bookName).xml)
BOOK_TABLES_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(TBL_OUTPUT_PATH)/$(bookName).tsv)
BOOK_SCHEMAS_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(TBL_OUTPUT_PATH)/$(bookName).schema)
BOOK_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).tsv)
BOOK_SCHEMAs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).schema)
BOOK_DEBUGs := $(foreach bookName, $(BOOK_NAMEs), $(TSV_OUTPUT_PATH)/$(bookName).debug)

.PHONY: all fixes norms tsvs words diffs diag

all: tsvs words

# --
# FIX
# --

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

# --
# NRM
# --

norms: $(BOOK_NRMED_XMLs)

$(NRM_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(NRM_OUTPUT_PATH)/%.xml

$(NRM_OUTPUT_PATH)/%.xml : $(FIX_OUTPUT_PATH)/%.xml $(NRM_OUTPUT_PATH) Makefile BookNorm.xsl BookNorm.xsd xml.xsd
	/usr/bin/xsltproc --nonet --xinclude "BookNorm.xsl" "$(FIX_OUTPUT_PATH)/$*.xml" >"$@"
	/usr/bin/xmllint --nonet --schema "BookNorm.xsd" --noout "$@"

# --
# IDX
# --

indices: $(BOOK_IDXED_XMLs)

$(IDX_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(IDX_OUTPUT_PATH)/%.xml

$(IDX_OUTPUT_PATH)/%.xml : $(NRM_OUTPUT_PATH)/%.xml $(IDX_OUTPUT_PATH) Makefile BookIndex.pl BookIndex.xsd xml.xsd
	BookIndex.pl "$(NRM_OUTPUT_PATH)/$*.xml" "$@" 3>"$(IDX_OUTPUT_PATH)/$*.debug"
	/usr/bin/xmllint --nonet --schema "BookIndex.xsd" --noout "$@"

# --
# WRD
# --

words: $(BOOK_WORDS_XMLs)

$(WRD_OUTPUT_PATH):
	mkdir -p "$@"

.PRECIOUS: $(WRD_OUTPUT_PATH)/%.xml

$(WRD_OUTPUT_PATH)/%.xml : $(WRD_OUTPUT_PATH) $(IDX_OUTPUT_PATH)/%.xml Makefile BookWord.xsl BookWord.xsd
	/usr/bin/xsltproc --nonet "BookWord.xsl" $(IDX_OUTPUT_PATH)/$*.xml >"$@"
	/usr/bin/xmllint --nonet --schema "BookWord.xsd" --noout "$@"

# --
# TBL
# --

$(TBL_OUTPUT_PATH):
	mkdir -p "$@"

tables: \
	$(TBL_OUTPUT_PATH)/WLC.tsv \
	$(TBL_OUTPUT_PATH)/WLC-Verb.tsv

# *.tsv

$(TBL_OUTPUT_PATH)/WLC.tsv : $(foreach bookName, $(BOOK_NAMEs), $(TBL_OUTPUT_PATH)/$(bookName).tsv)
	/usr/bin/cat "$(TBL_OUTPUT_PATH)/Gen.schema" | head -n 1 >"$@"
	/usr/bin/cat $^ >>"$@"

.PRECIOUS: $(TBL_OUTPUT_PATH)/%.tsv

# $(TBL_OUTPUT_PATH)/%.tsv : $(TBL_OUTPUT_PATH) $(WRD_OUTPUT_PATH)/%.xml BookTable.xsl Makefile
#	/usr/bin/xsltproc --nonet --stringparam "bookSchemaFname" "$(TBL_OUTPUT_PATH)/$*.schema" "BookTable.xsl" $(WRD_OUTPUT_PATH)/$*.xml >"$@"

$(TBL_OUTPUT_PATH)/%.tsv $(TBL_OUTPUT_PATH)/%.debug  $(TBL_OUTPUT_PATH)/%.schema: $(TBL_OUTPUT_PATH) $(WRD_OUTPUT_PATH)/%.xml BookTable.pl Makefile
	BookTable.pl "$(WRD_OUTPUT_PATH)/$*.xml" \
		1>"$(TBL_OUTPUT_PATH)/$*.tsv" \
		3>"$(TBL_OUTPUT_PATH)/$*.debug" \
		4>"$(TBL_OUTPUT_PATH)/$*.schema"

# *-Verb.tsv

$(TBL_OUTPUT_PATH)/WLC-Verb.tsv : $(foreach bookName, $(BOOK_NAMEs), $(TBL_OUTPUT_PATH)/$(bookName)-Verb.tsv)
	/usr/bin/cat "$(TBL_OUTPUT_PATH)/Gen-Verb.schema" | head -n 1 >"$@"
	/usr/bin/cat $^ >>"$@"

.PRECIOUS: $(TBL_OUTPUT_PATH)/%-Verb.tsv

# $(TBL_OUTPUT_PATH)/%-Verb.tsv : $(TBL_OUTPUT_PATH) $(WRD_OUTPUT_PATH)/%.xml BookTable-Verb.xsl Makefile
# 	/usr/bin/xsltproc --nonet --stringparam "bookSchemaFname" "$(TBL_OUTPUT_PATH)/$*.schema" "BookTable-Verb.xsl" $(WRD_OUTPUT_PATH)/$*.xml >"$@"

$(TBL_OUTPUT_PATH)/%-Verb.tsv $(TBL_OUTPUT_PATH)/%-Verb.debug  $(TBL_OUTPUT_PATH)/%-Verb.schema: $(TBL_OUTPUT_PATH) $(WRD_OUTPUT_PATH)/%.xml BookTable-Verb.pl Makefile
	BookTable-Verb.pl "$(WRD_OUTPUT_PATH)/$*.xml" \
		1>"$(TBL_OUTPUT_PATH)/$*-Verb.tsv" \
		3>"$(TBL_OUTPUT_PATH)/$*-Verb.debug" \
		4>"$(TBL_OUTPUT_PATH)/$*-Verb.schema"

# --
# TSV
# --

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

# --
# DIFFs
# --

diffs:
	/usr/bin/cut --delimiter="	" --fields=3,5-16,18- $(TSV_OUTPUT_PATH)/WLC.tsv >$(TSV_OUTPUT_PATH)/WLC-c.tsv
	/usr/bin/cut --delimiter="	" --fields=4,6-17,19- $(WRD_OUTPUT_PATH)/WLC.tsv >$(WRD_OUTPUT_PATH)/WLC-c.tsv
	"C:/Program Files/Vim/vim91/gvim.exe" -R -d +"set list" tsv/WLC-c.tsv wrd/WLC-c.tsv &

# --
# Diag
# --

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
		fix/*.xml \
		idx/*.xml \
		idx/*.debug \
		nrm/*.xml \
		wrd/*.xml \
		tbl/*.debug \
		tbl/*.schema \
		tbl/*.tsv \
		tst/*.tsv \
		$(GENERATED)

edit:
	"C:/Program Files/Vim/vim91/gvim.exe" -R +"set guifont=Consolas:h18" +"set number" +"set wrap" +"set delcombine" +"set maxcombine=6" \
		"$(TBL_OUTPUT_PATH)/WLC.tsv" \
		"$(TBL_OUTPUT_PATH)/WLC-Verb.tsv" \
		$(BOOK_XMLs) \
		$(BOOK_FIXES_XMLs) \
		$(BOOK_FIXED_XMLs) \
		$(BOOK_NRMED_XMLs) \
		$(BOOK_IDXED_XMLs) \
		$(BOOK_WORDS_XMLs) \
		$(BOOK_SCHEMAS_TSVs) \
		$(BOOK_TABLES_TSVs) \
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
		"BookIndex.pl" \
		"BookWord.xsl" \
		"BookWord.xsd" \
		"BookTable.pl" \
		"BookTable.xsl" \
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
