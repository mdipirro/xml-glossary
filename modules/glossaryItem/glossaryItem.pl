#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

print $ARGV[0] . "\n" . $ARGV[1];

# read the content of the glossaryLaTeX and of the document
open(my $glossaryFile, '<' . $ARGV[0]);
my $glossary = join('', <$glossaryFile>);
close $glossaryFile;
open(my $documentFile, '<' . $ARGV[1]);
my $document = join('', <$documentFile>);
close $documentFile;
# find the word in the glossaryLaTeX and store them in an array
my @words = $glossary =~ /(\\item\[\w+\])/g;
for (my $i = 0; $i < @words; $i++) {
    $words[$i] = substr($words[$i], 6, -1);
}
my @plurals = $glossary =~ /Plurale: \w+/g;
for (my $i = 0; $i < @plurals; $i++) {
    $plurals[$i] = substr($plurals[$i], 9);
}
push (@words, @plurals);
# given a word "word", replace all the occurrences of "word" with \glossaryItem{word}
my $lowercaseWord;
foreach my $word (@words) {
    # replace the word adding \glossaryItem
    # the word may be written with the first character in lower or upper case. Replace both
    $lowercaseWord = lcfirst($word);
    $document =~ s/$word/\\glossaryItem{$word}/g;
    $document =~ s/$lowercaseWord/\\glossaryItem{$lowercaseWord}/g;

    # if there's already glossaryItem, delete the one just added
    $document =~ s/\\glossaryItem{\\glossaryItem{$word}}/\\glossaryItem{$word}/g;
    $document =~ s/\\glossaryItem{\\glossaryItem{$lowercaseWord}}/\\glossaryItem{$lowercaseWord}/g;
}
# write on the document file
open ($documentFile, '>' . $ARGV[1]);
print $documentFile $document;
close $documentFile;