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
use Digest::MD5 qw(md5_hex);
use Encode;
use English;
use v5.36;

#---------------------------------------------------------

$OFS = "\t";

# Initialize the I/O:

# Input XML
# TODO: Explore custom I/O handling: open(INPUT, "<&0") or die("Failed to open BASE from FD #0");

my $inputFilename = shift @ARGV;
my $outputFilename = shift @ARGV;

# Output TSV
open(OUTPUT, ">&1") or die("Failed to open writing to FD #1");

# Error messages:
open(ERROR, ">&2") or die("Failed to open writing to FD #2");

# Debug messages:
open(DEBUG, ">&3") or die("Failed to open writing to FD #3");

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

my $dom = XML::LibXML->load_xml(location => $inputFilename);
my $xpc = XML::LibXML::XPathContext->new($dom);

my @books = $xpc->findnodes("/book");
foreach my $book (@books) {
    my $osisBookId = $book->getAttribute("osisBookId");
    my $tokenInVerseNum = 0;
    my $osisVerseIdLast = "";
    my $tokenInKjvVerseNum = 0;
    my $osisKjvVerseIdLast = "";
    my $tokenPunctuationNum = 1;

    my @tokens = $xpc->findnodes("token", $book);
    foreach my $token (@tokens) {
        # The 'tokenKey' is expected to be unique string for each token in the entire Bible.
        #
        # It is expected to change when either the Hebrew text represented by
        # the token or the OSIS unique identifier change.
        #
        # It is not expected to change when:
        #   - Parsing of the token into sub-tokens changes.
        #   - Parsing of the grammar changes.
        #   - Lemma changes.
        #   - Strong number changes.
        #   - The token is moved around.
        #   - A token with the same Hebrew text changes somewhere else.
        #
        my $osisWordId = $token->getAttribute("osisWordId");
        my @childTokens = $token->getChildrenByTagName("punctuation");
        my $tokenText = $token->textContent() =~ s/\s+//gr;

        my $tokenKey = undef;
        if (scalar(@childTokens) eq 0 && defined($osisWordId)) {
            $tokenKey = join('|', $osisBookId, $osisWordId, $tokenText);
        } elsif (scalar(@childTokens) gt 0 && !defined($osisWordId)) {
            $tokenKey = join('|', $osisBookId, $tokenPunctuationNum, $tokenText);
            $tokenPunctuationNum++;
        } else {
            print STDERR "ERROR: Unexpected token 'tokenText'\n";
            $tokenKey = "ERROR: " . join('|', $osisBookId, $osisWordId, $tokenPunctuationNum, $tokenText);
        }
        my $tokenKeyHash = Digest::MD5::md5_hex(Encode::encode_utf8($tokenKey));
        $token->setAttribute("id", $tokenKeyHash);
        print DEBUG $tokenKeyHash, $tokenKey, "";

        {
            my $osisVerseId = $token->getAttribute("osisVerseId");
            my ($osisBookName, $osisChapterNum, $osisVerseNum) = split(/\./, $osisVerseId);
            $token->setAttribute("osisChapterNum", $osisChapterNum);
            $token->setAttribute("osisVerseNum", $osisVerseNum);
            if ($osisVerseId eq $osisVerseIdLast) {
                $tokenInVerseNum++;
            } else {
                $tokenInVerseNum = 1;
            }
            $osisVerseIdLast = $osisVerseId;
            $token->setAttribute("tokenInVerseNum", $tokenInVerseNum);
            print DEBUG $osisBookName, $osisChapterNum, $osisVerseNum, $tokenInVerseNum, "";
        }
        {
            my $osisKjvVerseId = $token->getAttribute("osisKjvVerseId");
            # The 1Kgs.22.43!b is the only case where the sub-verse numbering
            # is used. The 'VerseMap.xml' tracks a more complete mapping, but
            # since the sub-verse numbering seems to come purely from Christian
            # sources (no Hebrew Bible editions appears to be using this
            # system), stripping and ignoring this sub-verse numbering in this
            # version:
            $osisKjvVerseId =~ s/![abc]$//;

            my ($osisKjvBookName, $osisKjvChapterNum, $osisKjvVerseNum) = split(/\./, $osisKjvVerseId);
            $token->setAttribute("osisKjvChapterNum", $osisKjvChapterNum);
            $token->setAttribute("osisKjvVerseNum", $osisKjvVerseNum);
            if ($osisKjvVerseId eq $osisKjvVerseIdLast) {
                $tokenInKjvVerseNum++;
            } else {
                $tokenInKjvVerseNum = 1;
            }
            $osisKjvVerseIdLast = $osisKjvVerseId;
            $token->setAttribute("tokenInKjvVerseNum", $tokenInKjvVerseNum);
            print DEBUG $osisKjvBookName, $osisKjvChapterNum, $osisKjvVerseNum, $osisKjvVerseId, $tokenInKjvVerseNum, "";
        }
        print DEBUG "\n";
    }
}

$dom->toFile($outputFilename, 1);

close(OUTPUT);
close(ERROR);
close(DEBUG);
