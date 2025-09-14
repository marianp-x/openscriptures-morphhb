all: WordList.tsv

%.tsv %.debug : %.xml Makefile decode-wordlist.pl
	decode-wordlist.pl "$*.xml" \
		1>"$*.tsv" \
		3>"$*.debug"

clean:
	rm -f \
		WordList.tsv \
		WordList.debug

edit:
	"C:/Program Files/Vim/vim91/gvim.exe" +"set number" \
		"Makefile" \
		"decode-wordlist.pl" \
		"WordList.xml" \
		"WlcWordList.xsd" \
		"WordList.tsv" \
		"WordList.debug" \
		&
