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
    my $note = $fields[3];
    print "  <fix-word-morph osisBookId=\"${bookId}\" osisId=\"${wordId}\"><morph>${morph}</morph><note>${note}</note></fix-word-morph>\n";
}
