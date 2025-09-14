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

BOOK_XMLs := $(foreach bookName, $(BOOK_NAMEs), $(bookName).xml)
BOOK_TSVs := $(foreach bookName, $(BOOK_NAMEs), $(bookName).tsv)
BOOK_DEBUGs := $(foreach bookName, $(BOOK_NAMEs), $(bookName).debug)

GENERATED=\
	WLC.tsv \
	$(BOOK_TSVs) \
	$(BOOK_DEBUGs) \

all: WLC.tsv

WLC.tsv : $(BOOK_TSVs)
	/usr/bin/cat "Gen.schema" | head -n 1 >"WLC.tsv"
	/usr/bin/cat $(BOOK_TSVs) >>"WLC.tsv"

%.tsv %.debug : %.xml Makefile decode-books.pl
	decode-books.pl "$*.xml" \
		1>"$*.tsv" \
		3>"$*.debug" \
		4>"$*.schema"

clean:
	rm -f \
		$(GENERATED)

edit:
	"C:/Program Files/Vim/vim91/gvim.exe" +"set number" +"set delcombine" +"set maxcombine=6" \
		"Makefile" \
		"README.md" \
		"decode-books.pl" \
		"WLC.tsv" \
		$(BOOK_XMLs) \
		$(BOOK_TSVs) \
		$(BOOK_DEBUGs) \
		"osisCore.2.1.1.xsd" \
		&

validate:
	/usr/bin/xmllint --schema "osisCore.2.1.1.xsd" --noout $(BOOK_XMLs)

print:
	@echo "BOOK_NAMEs($(BOOK_NAMEs))"
	@echo "BOOK_XMLs($(BOOK_XMLs))"
	@echo "BOOK_TSVs($(BOOK_TSVs))"
	@echo "BOOK_DEBUGs($(BOOK_DEBUGs))"
