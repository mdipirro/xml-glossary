#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use XML::LibXML;
use XML::LibXSLT;
use Cwd;
use autodie qw(:all);

my $xmlFile = $ARGV[0];
#my $xslFile = './plugins/mdipirro/xml-glossary/modules/glossaryLaTeX/alphabeticalOrder.xsl';
my $xslFile = 'alphabeticalOrder.xsl';
my $orderedFile = $xmlFile;
$orderedFile =~ s/.xml$/Ordered.xml/;
my $xslt = XML::LibXSLT->new();
my $source = XML::LibXML->load_xml(location => $xmlFile);
my $style_doc = XML::LibXML->load_xml(location=>$xslFile, no_cdata=>1);
my $stylesheet = $xslt->parse_stylesheet($style_doc);
my $results = $stylesheet->transform($source);
my $out = $stylesheet->output_as_bytes($results);
$out =~ s/<\?xml version="1.0"\?>/<\?xml version="1.0" encoding="UTF-8"\?>/;
# escape chars #, _ and % 
my @escape = ('%', '#', '_');
foreach my $e (@escape) {
    $out =~ s/$e/\\$e/g;
    $out =~ s/\\\\$e/\\$e/g;
}
# escape $
$out =~ s/\$/\\\$/g;
$out =~ s/\\\\\$/\\\$/g;
# write on the ordered glossary
open my $orderedGlossary, '>', "$orderedFile";
print $orderedGlossary $out;
close $orderedGlossary;
# start glossary parsing
open $orderedGlossary, '<', "$orderedFile";
my $parser = XML::LibXML->new();
my $xmldoc = $parser->parse_file($orderedFile);
my @letters = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
);
my $texFilename = substr($ARGV[0], 0, rindex($ARGV[0], '/')) . '/glossary.tex';
open(my $tex, '>:encoding(UTF-8)', $texFilename);
foreach my $letter (@letters) { # foreach letter
    if ($xmldoc->exists("//term[substring(word,1,1) = '$letter']")) { # if there's a word which starts with it
        print $tex "\\newpage \n"; # make a new page and start writing
        print $tex "\\begin{center}\\textbf{\\Huge{$letter}}\\end{center}\n";
        print $tex '\begin{description}';
        foreach my $term ($xmldoc->findnodes("//term[substring(word,1,1) = '$letter']")) {
            print $tex '\item[' . $term->findvalue('./word') . '] \hfill \\\\' . "\n";
            if ($term->exists('./extended')) { # check if there's an extended explanation of the word
                print $tex 'Nome esteso: ' . $term->findvalue('./extended') . "\\\\ \n";
            }
            if ($term->exists('./plural')) { # check if there's a plural of the word
                print $tex 'Plurale: ' . $term->findvalue('./plural') . "\\\\ \n";
            }
            # print the definition of the word
            print $tex $term->findvalue('./definition') . "\n ";
        }
        print $tex '\end{description}' . "\n";
    }
}
close $tex;
unlink $orderedFile;
