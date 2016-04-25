#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use File::Find::Rule;

# read the content of the glossaryLaTeX and of the document
open(my $glossaryFile, '<' . $ARGV[0]);
my $glossary = join('', <$glossaryFile>);
close $glossaryFile;


my @files = find(
  file =>
  name => [ qw/ *.tex / ],
  in   => $ARGV[1]
);

foreach my $file (@files) {
	open(my $documentFile, "<$file");
	my $document = join('', <$documentFile>);
	close $documentFile;
	# find the word in the glossaryLaTeX and store them in an array
	my @words = $glossary =~ /(\\item\[[\w+(\s|\/|\-)]+\])/g;
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
		$document =~ s/ $word([ ]?[^\w])/ \\glossaryItem{$word}$1/g;
		$document =~ s/ $lowercaseWord([ ]?[^\w])/ \\glossaryItem{$lowercaseWord}$1/g;

		# if there's already glossaryItem, delete the one just added
		$document =~ s/\\glossaryItem{\\glossaryItem{$word}}/\\glossaryItem{$word}/g;
		$document =~ s/\\glossaryItem{\\glossaryItem{$lowercaseWord}}/\\glossaryItem{$lowercaseWord}/g;

		# remove glossaryItem from sections
		$document =~ s/section{([\w }]*)\\glossaryItem{$lowercaseWord}/section{$1$lowercaseWord/g;
		$document =~ s/section{([\w }]*)\\glossaryItem{$word}/section{$1$word/g;
		$document =~ s/section{([\w }]*)\\glossaryItem{\\glossaryItem{$word}}/section{$word/g;
		$document =~ s/section{([\w }]*)\\glossaryItem{\\glossaryItem{$lowercaseWord}}/section{$1$lowercaseWord/g;

		# add glossaryItem on Node.js
		$document =~ s/Node.js/\\glossaryItem{Node.js}/g;
		$document =~ s/\\glossaryItem{\\glossaryItem{Node.js}}/\\glossaryItem{Node.js}/g;
		$document =~ s/section{([\w ]*)\\glossaryItem{Node.js}/section{$1Node.js/g;
	}
	# write on the document file
	open ($documentFile, ">$file");
	print $documentFile $document;
	close $documentFile;
}
