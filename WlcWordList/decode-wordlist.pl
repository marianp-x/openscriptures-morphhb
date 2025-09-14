#!/usr/bin/perl -w


use strict;
use warnings;
use utf8;
use feature "unicode_strings";
use open qw(:std :encoding(UTF-8));
use charnames ":full";
use IO::Handle;
use Unicode::Normalize;
use XML::LibXML;
use XML::LibXML::XPathContext;
use English;
use v5.36;

#---------------------------------------------------------

$OFS = "\t";

# Initialize the I/O:

my $filename = shift @ARGV;

# Output latex
open(OUTPUT, ">&1") or die("Failed to open writing to FD #1");

# Error messages:
open(ERROR, ">&2") or die("Failed to open writing to FD #2");

# Debug messages:
open(DEBUG, ">&3") or die("Failed to open writing to FD #3");

my $dom = XML::LibXML->load_xml(location => $filename);
my $xpc = XML::LibXML::XPathContext->new($dom);
$xpc->registerNs("vm", "http://www.APTBibleTools.com/namespace");

my %hebrewPrefixes;

my @prefixes = $xpc->findnodes("/vm:lex/vm:p/vm:n");
foreach my $prefix (@prefixes) {
    $hebrewPrefixes{$prefix->getAttribute("id")} = NFC($prefix->getAttribute("v"));
}

my %hebrewSuffixes;

my @suffixes = $xpc->findnodes("/vm:lex/vm:s/vm:n");
foreach my $suffix (@suffixes) {
    $hebrewSuffixes{$suffix->getAttribute("id")} = NFC($suffix->getAttribute("v"));
}

my @wordRefs = $xpc->findnodes("/vm:lex/vm:w/vm:r");
foreach my $wordRef (@wordRefs) {
    my $word = $wordRef->parentNode;
    my $hebrewWord = NFC($word->getAttribute("v"));
    if (!defined($hebrewWord)) {
        print ERROR "No 'v' defined.";
    }
    if ($hebrewWord eq "\N{HEBREW PUNCTUATION GERESH}") {
        $hebrewWord = "";
    }
    $hebrewWord = $hebrewWord =~ s/\N{ZERO WIDTH SPACE}//gr;
    $hebrewWord = $hebrewWord =~ s/\N{ZERO WIDTH JOINER}//gr;
    $hebrewWord = $hebrewWord =~ s/\N{ZERO WIDTH NON-JOINER}//gr;
    my $strongsNum = $word->getAttribute("a");
    if (!defined($strongsNum)) {
        print ERROR "No 'a' defined.";
    }
    my $prefixIds = $wordRef->getAttribute("p");
    my @hebrewPrefixes = ();
    if (defined($prefixIds)) {
        foreach my $id (split(/ /, $prefixIds)) {
            push(@hebrewPrefixes, $hebrewPrefixes{$id});
        }
    }
    my $suffixIds = $wordRef->getAttribute("s");
    my @hebrewSuffixes = ();
    if (defined($suffixIds)) {
        foreach my $id (split(/ /, $suffixIds)) {
            push(@hebrewSuffixes, $hebrewSuffixes{$id});
        }
    }
    my $bookRef = $wordRef->textContent;

    my $hebrewWordComplete = join("", @hebrewPrefixes, $hebrewWord, @hebrewSuffixes);

    print OUTPUT $bookRef, $strongsNum, $hebrewWordComplete . "\n";
}

close(OUTPUT);
close(ERROR);
close(DEBUG);
