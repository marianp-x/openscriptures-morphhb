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

my %osisVerbStepToHebrewBinyanim = (
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

my %osisVerbStepToAramaicBinyanim = (
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
    "q" => "ve-perfect",           # ve-perfect
    "i" => "imperfect",
    "w" => "va-imperfect",         # va-imperfect
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
    "OsisWordNum",
    "TokenType",
    "OsisWordId",
    "WordSpeechType",
    "WordHebrew",
    "WordHebrewN",
    "WordHebrewC",
    "WordHebrewParsed",
    "Lemma",
    "Morph",
    "PrefixConjunction",
    "PrefixPreposition",
    "PrefixArticle",
    "PrefixInterrogative",
    "PrefixParticle",
    "WordVerbBinyanim",
    "WordVerbForm",
    "WordVerbPGN",
    "WordVerbState",
    "SuffixPronominal",
    "SuffixPronominalPGN",
    "SuffixDirectionalHe",
    "SuffixParagogicHe",
    "SuffixParagogicNun" .
    "\n";

print SCHEMA
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(ASCII)",
    "string(UTF-8)",
    "string(UTF-8)",
    "string(ASCII)",
    "string(ASCII)",
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
$xpc->registerNs("osis", "http://www.bibletechnologies.net/2003/OSIS/namespace");

my @books = $xpc->findnodes("/osis:osis/osis:osisText/osis:div[\@type = 'book']");
foreach my $book (@books) {
    my $osisBookId = $book->getAttribute("osisID");
    print DEBUG "osisBookId($osisBookId)\n";

    my @chapters = $xpc->findnodes("osis:chapter", $book);
    foreach my $chapter (@chapters) {
        my $osisChapterId = $chapter->getAttribute("osisID");
        print DEBUG "osisChapterId($osisChapterId)\n";

        my @verses = $xpc->findnodes("osis:verse", $chapter);
        foreach my $verse (@verses) {
            my $osisVerseId = $verse->getAttribute("osisID");
            print DEBUG "osisVerseId($osisVerseId)\n";

            my @tokens = $xpc->findnodes(".//osis:w[not(\@type)]|osis:seg", $verse);
            print DEBUG "verse/nodes(" . scalar(@tokens). ")\n";
            my $tokenNum = 1;
            foreach my $token (@tokens) {
                my $tokenName = $token->localname;
                my $osisWordNum = $osisVerseId . "." . $tokenNum;
                my @osisWordNumParsed = parseOsisWordNum($osisWordNum);
                print DEBUG "osisWordNum($osisWordNum),@osisWordNumParsed,tokenNum($tokenNum),tokenName($tokenName)";
                my $osisWordId = "";
                if ($tokenName eq "w") {
                    $osisWordId = $token->getAttribute("id");
                    my $lemma = $token->getAttribute("lemma");
                    my $morph = $token->getAttribute("morph");
                    my $wordLang = substr($morph, 0, 1);
                    $morph = substr($morph, 1);
                    my $wordHebrewParsed = $token->textContent;
                    my $wordHebrew = $wordHebrewParsed =~ s#/##gr;
                    my $wordHebrewN = stripTaamim($wordHebrew);
                    my $wordHebrewC = stripPointing($wordHebrew);
                    my $wordSpeechType = "";
                    print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),wordHebrew($wordHebrew),wordHebrewN($wordHebrewN),wordHebrewC($wordHebrewC),wordHebrewParsed($wordHebrewParsed),lemma($lemma),morph($morph)\n";

                    my $prefixConjunction = "";
                    my $prefixConjunctionName = "";
                    my $prefixPreposition = "";
                    my $prefixArticle = "";
                    my $prefixInterrogative = "";
                    my $prefixParticle = "";
                    my $wordVerbBinyanim = "";
                    my $wordVerbForm = "";
                    my $wordVerbFormN = "";
                    my $wordVerbFormC = "";
                    my $wordVerbPGN = "";
                    my $wordVerbState = "";
                    my $suffixPronominal = "";
                    my $suffixPronominalPGN = "";
                    my $suffixDirectionalHe = "";
                    my $suffixParagogicHe = "";
                    my $suffixParagogicNun = "";

                    my @morphSegments = split(/\//, $morph);
                    my @wordHebrewParsedSegments = split(/\//, $wordHebrewParsed);
                    die("ERROR($osisWordNum/$osisWordId): Inconsistent '@morphSegments' vs '@wordHebrewParsedSegments'") if scalar(@morphSegments) ne scalar(@wordHebrewParsedSegments);
                    for(my $s = 0; $s < scalar(@morphSegments); $s++) {
                        my $morphS = $morphSegments[$s];
                        my $wordHebrewS = $wordHebrewParsedSegments[$s];

                        if ($morphS =~ m/^C/) {
                            $prefixConjunction = $wordHebrewS;
                            my $prefixConjunctionBare = stripTaamim($prefixConjunction);
                            $prefixConjunctionName = "UNKNOWN";
                            $prefixConjunctionName = $prefixConjuctionToName{$prefixConjunctionBare} if defined($prefixConjuctionToName{$prefixConjunctionBare});
                            print DEBUG "osisWordId($osisWordId),prefixConjunction($prefixConjunction),prefixConjunctionBare($prefixConjunctionBare),prefixConjunctionName($prefixConjunctionName)\n";
                        } elsif ($morphS =~ m/^R/) {
                            $prefixPreposition = $wordHebrewS;
                            my $i = 1;
                            my $t = substr($morphS, $i++, 1);
                            if ($t eq "d") {
                                $prefixArticle = "הַ";           # TODO: Match the vowel to the preposition vowel.
                            }
                        } elsif ($morphS =~ m/^T/) {
                            my $i = 1;
                            my $t = substr($morphS, $i++, 1);
                            if ($t eq "d") {
                                $prefixArticle = $wordHebrewS;
                            } elsif ($t eq "i") {
                                $prefixInterrogative = $wordHebrewS;
                            } elsif ($t eq "r") {
                                $prefixParticle = $wordHebrewS;
                            }
                        } elsif ($morphS =~ m/^S/) {
                            my $i = 1;
                            my $t = substr($morphS, $i++, 1);
                            if ($t eq "p") {
                                $suffixPronominal = $wordHebrewS;
                                my $p = substr($morphS, $i++, 1);
                                my $g = substr($morphS, $i++, 1);
                                my $n = substr($morphS, $i++, 1);
                                $suffixPronominalPGN = "$p$g$n";
                            } elsif ($t eq "d") {
                                $suffixDirectionalHe = $wordHebrewS;
                            } elsif ($t eq "h") {
                                $suffixParagogicHe = $wordHebrewS;
                            } elsif ($t eq "n") {
                                $suffixParagogicNun = $wordHebrewS;
                            }
                        } elsif ($morphS =~ m/^V/) {
                            $wordSpeechType = "VERB";
                            my $i = 1;
                            my $b = substr($morphS, $i++, 1);
                            if ($wordLang eq "H") {
                                $wordVerbBinyanim = $osisVerbStepToHebrewBinyanim{$b};
                            } elsif ($wordLang eq "A") {
                                $wordVerbBinyanim = $osisVerbStepToAramaicBinyanim{$b};
                            } else {
                                print ERROR "ERROR($osisWordNum/$osisWordId): Unknown wordLang($wordLang)\n";
                            }
                            print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),morphS($morphS),i($i),b($b),wordVerbBinyanim($wordVerbBinyanim)\n";
                            my $f = substr($morphS, $i++, 1);
                            $wordVerbForm = $osisVerbConjugationToHebrewForm{$f};
                            if (!defined($wordVerbForm)) {
                                print ERROR "ERROR($osisWordNum/$osisWordId): Unknown wordVerbForm($wordVerbForm)\n";
                            }
                            if ($prefixConjunctionName eq "UNKNOWN") {
                                print ERROR "ERROR($osisWordNum/$osisWordId): Unknown prefixConjunction($prefixConjunction)\n";
                            }
                            if ($prefixConjunctionName ne "") {
                                my $wordVerbFormCore = $wordVerbForm =~ s/^(ve-|va-)//gr;
                                my $wordVerbFormConjuction = "${prefixConjunctionName}-${wordVerbFormCore}";
                                if ($f eq "q" and $wordVerbFormConjuction ne "ve-perfect") {
                                    print ERROR "WARNING($osisWordNum/$osisWordId): The wordVerbForm($wordVerbForm) does not match wordVerbFormConjuction($wordVerbFormConjuction) -- keeping the wordVerbForm($wordVerbForm)\n";
                                } elsif ($f eq "w" and $wordVerbFormConjuction ne "va-imperfect") {
                                    print ERROR "WARNING($osisWordNum/$osisWordId): The wordVerbForm($wordVerbForm) does not match wordVerbFormConjuction($wordVerbFormConjuction) -- keeping the wordVerbForm($wordVerbForm)\n";
                                } else {
                                    $wordVerbForm = $wordVerbFormConjuction;
                                }
                            }
                            print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),morphS($morphS),i($i),f($f),wordVerbForm($wordVerbForm)\n";

                            my $p = "";
                            if ($f eq "r" || $f eq "s") {
                                $p = "3";
                            } elsif ($f eq "a" || $f eq "c") {
                                $p = "*";
                            } else {
                                $p = substr($morphS, $i++, 1);
                            }
                            print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),morphS($morphS),i($i),p($p)\n";

                            my $g = "";
                            if ($f eq "a" || $f eq "c") {
                                $g = "*";
                            } else {
                                $g = substr($morphS, $i++, 1);
                            }
                            print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),morphS($morphS),i($i),g($g)\n";

                            my $n = "";
                            if ($f eq "a" || $f eq "c") {
                                $n = "*";
                            } else {
                                $n = substr($morphS, $i++, 1);
                            }
                            print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),morphS($morphS),i($i),n($n)\n";

                            $wordVerbPGN = "$p$g$n";
                            print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),morphS($morphS),wordVerbPGN($wordVerbPGN)\n";
                            if ($f =~ m/[rs]/) {
                                my $s = substr($morphS, $i++, 1);
                                $wordVerbState = $osisStateToHebrewState{$s};
                                $wordVerbForm .= " " . $wordVerbState;
                                print DEBUG "osisWordId($osisWordId),wordSpeechType($wordSpeechType),morphS($morphS),i($i),s($s),wordVerbState($wordVerbState)\n";
                            }
                        }
                    }
                    print OUTPUT
                        $osisWordNum,
                        "WORD",
                        $osisWordId,
                        $wordSpeechType,
                        $wordHebrew,
                        $wordHebrewN,
                        $wordHebrewC,
                        $wordHebrewParsed,
                        $lemma,
                        $morph,
                        $prefixConjunction,
                        $prefixPreposition,
                        $prefixArticle,
                        $prefixInterrogative,
                        $prefixParticle,
                        $wordVerbBinyanim,
                        $wordVerbForm,
                        $wordVerbPGN,
                        $wordVerbState,
                        $suffixPronominal,
                        $suffixPronominalPGN,
                        $suffixDirectionalHe,
                        $suffixParagogicHe,
                        $suffixParagogicNun;
                } elsif ($tokenName eq "seg") {
                    my $segType = $token->getAttribute("type");
                    my $segHebrew = $token->textContent;
                    print DEBUG "segType($segType),segHebrew($segHebrew)\n";
                    print OUTPUT
                        $osisWordNum,
                        "SEG",
                        $osisWordId,
                        $segType,
                        $segHebrew;
                } elsif ($tokenName eq "note") {
                    my $noteN = "";
                    $noteN = $token->getAttribute("n") if defined($token->getAttribute("n"));
                    my $noteType = "";
                    $noteType = $token->getAttribute("type") if defined($token->getAttribute("type"));
                    my $note = $token->toString();
                    print DEBUG "noteN($noteN),noteType($noteType),note($note)\n";
                    print OUTPUT
                        $osisWordNum,
                        "NOTE",
                        $osisWordId,
                        $noteN,
                        $noteType,
                        $note;
                } else {
                    print ERROR "ERROR($osisWordNum): Unknown tokenName($tokenName)\n";
                }
                print OUTPUT "\n";
                $tokenNum++;
            }
        }
    }
}

close(OUTPUT);
close(ERROR);
close(DEBUG);
