#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;
use feature "unicode_strings";
use open ':encoding(utf8)';
use open ':std';
use English;
use v5.36;

BEGIN {
    print "<fixes>\n";
}

END {
    print "</fixes>\n";
}

while(<>) {
    s/\r//g;                # Normalize EOL across platforms to UNIX '\n'.
    chomp;
    next if m/^#/;
    my @fields = split(/\t/, $_);
    my $bookId = $fields[0];
    my $wordId = $fields[1];
    my $morph = $fields[2];
    my $morphNote = $fields[3];
    my $lemma = $fields[4];
    my $lemmaNote = $fields[5];
    my $text = $fields[6];
    my $textNote = $fields[7];
    print "  <fix-word osisBookId=\"${bookId}\" osisId=\"${wordId}\">";
    if (defined($morph) && length($morph) gt 0) {
        print "<morph>${morph}</morph>";
    }
    if (defined($morphNote) && length($morphNote) gt 0) {
        print "<morph-note>${morphNote}</morph-note>";
    }
    if (defined($lemma) && length($lemma) gt 0) {
        print "<lemma>${lemma}</lemma>";
    }
    if (defined($lemmaNote) && length($lemmaNote) gt 0) {
        print "<lemma-note>${lemmaNote}</lemma-note>";
    }
    if (defined($text) && length($text) gt 0) {
        print "<text>${text}</text>";
    }
    if (defined($textNote) && length($textNote) gt 0) {
        print "<text-note>${textNote}</text-note>";
    }
    print "</fix-word>\n";
}
