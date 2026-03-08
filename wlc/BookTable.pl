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

# Input XML
# TODO: Explore custom I/O handling: open(INPUT, "<&0") or die("Failed to open BASE from FD #0");

my $filename = shift @ARGV;

# Output TSV
open(OUTPUT, ">&1") or die("Failed to open writing to FD #1");

# Error messages:
open(ERROR, ">&2") or die("Failed to open writing to FD #2");

# Debug messages:
open(DEBUG, ">&3") or die("Failed to open writing to FD #3");

# Output TSV schema
open(SCHEMA, ">&4") or die("Failed to open writing to FD #4");

#---------------------------------------------------------

sub stripTaamim {
    my $string = shift;
    $string =~ s/[\x{0590}-\x{05AF}\x{05BD}]//g;        # ta`amim + messeg
    $string =~ s/[\x{05C4}]//g;                         # upper dot
    $string =~ s/[\x{05C5}]//g;                         # lower dot
    return $string;
}

sub stripNiqqudh {
    my $string = shift;
    $string =~ s/[\x{05B0}-\x{05BB}]//g;                # niqqudh
    return $string;
}

sub stripPointing {
    my $string = shift;
    $string =~ s/[\x{0590}-\x{05AF}\x{05BD}]//g;        # ta`amim + messeg
    $string =~ s/[\x{05B0}-\x{05BB}]//g;                # niqqud
    $string =~ s/[\x{05BC}]//g;                         # dagheish
    $string =~ s/[\x{05C1}]//g;                         # shin dot
    $string =~ s/[\x{05C2}]//g;                         # sin dot
    $string =~ s/[\x{05C4}]//g;                         # upper dot
    $string =~ s/[\x{05C5}]//g;                         # lower dot
    return $string;
}

#---------------------------------------------------------

print SCHEMA
    "WordPathJewish",
    "WordPathChristian",
    "WordId",
    "OsisWordId",
    "Language",
    "TokenName",
    "TokenText",
    "TokenTextN",
    "TokenTextC",
    "TokenTextParsed" .
    "\n";

print SCHEMA
    "string(UTF-8)",
    "string(UTF-8)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(UTF-8)" .
    "\n";

my $dom = XML::LibXML->load_xml(location => $filename);
my $xpc = XML::LibXML::XPathContext->new($dom);

my @books = $xpc->findnodes("/book");
foreach my $book (@books) {
    my $osisBookId = $book->getAttribute("osisBookId");
    my $bookPathJewish = $book->getAttribute("bookPathJewish");
    my $bookPathChristian = $book->getAttribute("bookPathChristian");
    my $tokenInBookNum = 1;
    my $versePathJewishLast = "";
    my $tokenInPathJewish = 0;
    my $versePathChristianLast = "";
    my $tokenInPathChristian = 0;

    my @tokens = $xpc->findnodes("*", $book);
    foreach my $token (@tokens) {
        my $tokenName = $token->localname;
        my $wordId = "";
        my @tokenNameSegments = split(/_/, $tokenName);
        my $versePathJewish = $token->getAttribute("versePathJewish");
        my $versePathChristian = $token->getAttribute("versePathChristian");
        if ($versePathJewish eq $versePathJewishLast) {
            $tokenInPathJewish++;
        } else {
            $tokenInPathJewish = 1;
        }
        $versePathJewishLast = $versePathJewish;
        if ($versePathChristian eq $versePathChristianLast) {
            $tokenInPathChristian++;
        } else {
            $tokenInPathChristian = 1;
        }
        $versePathChristianLast = $versePathChristian;
        my $osisWordId = $token->getAttribute("osisWordId");
        my $language = $tokenNameSegments[0];
        my @tokenTexts = ();
#       print DEBUG "osisWordNum($osisWordNum),@osisWordNumParsed,tokenInBookNum($tokenInBookNum),tokenName($tokenName)";
        if ($tokenName =~ "_punctuation") {
            push(@tokenTexts, $token->textContent);
            $osisWordId = "";
        } else {
            my @tokenParts = $xpc->findnodes("*", $token);
            foreach my $tokenPart (@tokenParts) {
                push(@tokenTexts, $tokenPart->textContent);
            }
        }
        my $tokenText = join("", @tokenTexts);
        my $tokenTextN = stripTaamim($tokenText);
        my $tokenTextC = stripPointing($tokenText);
        my $tokenTextParsed = join("׀", @tokenTexts);

        print OUTPUT
            join("/", ($bookPathJewish, $versePathJewish, $tokenInPathJewish)),
            join("/", ($bookPathChristian, $versePathChristian, $tokenInPathChristian)),
            $wordId,
            $osisWordId,
            $language,
            $tokenName,
            $tokenText,
            $tokenTextN,
            $tokenTextC,
            $tokenTextParsed .
            "\n";

        $tokenInBookNum++;
    }
}

close(OUTPUT);
close(ERROR);
close(DEBUG);
