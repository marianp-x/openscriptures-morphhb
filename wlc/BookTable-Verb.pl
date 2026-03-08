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

my %osisBookIdToSblBookName = (
    "Gen" => "Genesis",
    "Exod" => "Exodus",
    "Lev" => "Leviticus",
    "Num" => "Numbers",
    "Deut" => "Deuteronomy",
    "Josh" => "Joshua",
    "Judg" => "Judges",
    "Ruth" => "Ruth",
    "1Sam" => "1 Samuel",
    "2Sam" => "2 Samuel",
    "1Kgs" => "1 Kings",
    "2Kgs" => "2 Kings",
    "1Chr" => "1 Chronicles",
    "2Chr" => "2 Chronicles",
    "Ezra" => "Ezra",
    "Neh" => "Nehemiah",
    "Esth" => "Esther",
    "Job" => "Job",
    "Ps" => "Psalms",
    "Prov" => "Proverbs",
    "Eccl" => "Ecclesiastes",
    "Song" => "Song of Solomon",
    "Isa" => "Isaiah",
    "Jer" => "Jeremiah",
    "Lam" => "Lamentations",
    "Ezek" => "Ezekiel",
    "Dan" => "Daniel",
    "Hos" => "Hosea",
    "Joel" => "Joel",
    "Amos" => "Amos",
    "Obad" => "Obadiah",
    "Jonah" => "Jonah",
    "Mic" => "Micah",
    "Nah" => "Nahum",
    "Hab" => "Habakkuk",
    "Zeph" => "Zephaniah",
    "Hag" => "Haggai",
    "Zech" => "Zechariah",
    "Mal" => "Malachi",
);

my %osisVerbStempToHebrewBinyanim = (
    "q" => "qal",
    "N" => "niphal",
    "p" => "piel",
    "P" => "pual",
    "h" => "hiphil",
    "H" => "hophal",
    "t" => "hithpael",
    "o" => "polel",
    "O" => "polal",
    "r" => "hithpolel",
    "m" => "poel",
    "M" => "poal",
    "k" => "palel",
    "K" => "pulal",
    "Q" => "qal passive",
    "l" => "pilpel",
    "L" => "polpal",
    "f" => "hithpalpel",
    "D" => "nithpael",
    "j" => "pealal",
    "i" => "pilel",
    "u" => "hothpaal",
    "c" => "tiphil",
    "v" => "hishtaphel",
    "w" => "nithpalel",
    "y" => "nithpoel",
    "z" => "hithpoel",
);

my %osisVerbStempToAramaicBinyanim = (
    "q" => "peal",
    "Q" => "peil",
    "u" => "hithpeel",
    "p" => "pael",
    "P" => "ithpaal",
    "M" => "hithpaal",
    "a" => "aphel",
    "h" => "haphel",
    "s" => "saphel",
    "e" => "shaphel",
    "H" => "hophal",
    "i" => "ithpeel",
    "t" => "hishtaphel",
    "v" => "ishtaphel",
    "w" => "hithaphel",
    "o" => "polel",
    "z" => "ithpoel",
    "r" => "hithpolel",
    "f" => "hithpalpel",
    "b" => "hephal",
    "c" => "tiphel",
    "m" => "poel",
    "l" => "palpel",
    "L" => "ithpalpel",
    "O" => "ithpolel",
    "G" => "ittaphal",
);

my %osisVerbConjugationToHebrewForm = (
    "p" => "perfect",
    "q" => "sequential perfect",           # ve-perfect
    "i" => "imperfect",
    "w" => "sequential imperfect",         # va-imperfect
    "h" => "cohortative",
    "j" => "jussive",
    "v" => "imperative",
    "r" => "participle active",
    "s" => "participle passive",
    "a" => "infinitive absolute",
    "c" => "infinitive construct",
);

my %prefixConjuctionToName = (
    "וְ" => "ve",
    "וֶ" => "ve",
    "וֵ" => "ve",
    "וִ" => "ve",
    "וּ" => "ve",
    "וֲ" => "ve",
    "וַ" => "va",
    "וָ" => "va",
    "כִּי" => "ki",
    "כִי" => "khi",
    "לוּ" => "lu",
    "אִם" => "im",
    "פֶּן" => "pen",
    "לוּלֵי" => "lulei",
    "בִלְתִּי" => "vilti",
);

my %osisStateToHebrewState = (
    "a" => "absolute",
    "c" => "construct",
    "d" => "determined",
);

my %osisParticleTypeToHebrewParticle = (
    "a" => "affirmation",
    "d" => "definite article",
    "e" => "exhortation",
    "i" => "interrogative",
    "j" => "interjection",
    "m" => "demonstrative",
    "n" => "negative",
    "o" => "direct object marker",
    "r" => "relative",
);

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

sub parseOsisWordNum
{
    my $osisWordNum = shift;
    if ($osisWordNum =~ m/(\w+)\.(\d+)\.(\d+).(\d+)/) {
        my $osisBookId = $1;
        my $osisChapterId = $2;
        my $osisVerseId = $3;
        my $osisWordId = $4;
        my $sblBookName = $osisBookIdToSblBookName{$1};
        return ($sblBookName, $osisChapterId, $osisVerseId, $osisWordId);
    }
}

#---------------------------------------------------------

print SCHEMA
    "WordPathJewish",
    "WordPathChristian",
    "WordId",
    "OsisWordId",
    "Language",
    "TokenName",
    "TokenSpeechType",
    "TokenText",
    "TokenTextN",
    "TokenTextC",
    "TokenTextParsed",
    "WordLemma",
    "PrefixConjunction",
    "PrefixPreposition",
    "PrefixArticle",
    "PrefixInterrogative",
    "PrefixParticle",
    "WordVerbBinyanim",
    "WordForm",
    "WordPGN",
    "WordState",
    "SuffixPronominal",
    "SuffixPronominalPGN",
    "SuffixDirectionalHe",
    "SuffixParagogicHe",
    "SuffixParagogicNun" .
    "\n";

print SCHEMA
    "string(UTF-8)",
    "string(UTF-8)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(ASCII)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(UTF-8)",
    "string(ASCII)",
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
        my $tokenSpeechType = "";
        my @tokenTexts = ();
#       print DEBUG "osisWordNum($osisWordNum),@osisWordNumParsed,tokenInBookNum($tokenInBookNum),tokenName($tokenName)";
        if ($tokenName =~ "_punctuation") {
            $tokenSpeechType = "punctuation";
            push(@tokenTexts, $token->textContent);
            $osisWordId = "";
        } elsif ($tokenName =~ "_word_(.*)") {
            $tokenSpeechType = $1;
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
            $tokenSpeechType,
            $tokenText,
            $tokenTextN,
            $tokenTextC,
            $tokenTextParsed,
            "WordLemma",
            "PrefixConjunction",
            "PrefixPreposition",
            "PrefixArticle",
            "PrefixInterrogative",
            "PrefixParticle",
            "WordVerbBinyanim",
            "WordForm",
            "WordPGN",
            "WordState",
            "SuffixPronominal",
            "SuffixPronominalPGN",
            "SuffixDirectionalHe",
            "SuffixParagogicHe",
            "SuffixParagogicNun" .
            "\n";

        $tokenInBookNum++;
    }
}

close(OUTPUT);
close(ERROR);
close(DEBUG);
