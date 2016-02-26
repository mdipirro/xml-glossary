use strict;

use XML::LibXML;
use XML::XSLT;

my $xmlFile = 'glossary.xml';
my $xslFile = 'alphabeticalOrder.xsl';
my $orderedFile = 'orderedGlossary.xml';
my $xslt = XML::XSLT->new ($xslFile, warnings => 1);
$xslt->transform ($xmlFile);
open(my $orderedGlossary, '>', $orderedFile);
print $orderedGlossary '<?xml version="1.0" encoding="UTF-8"?>';
print $orderedGlossary $xslt->toString;
close $orderedGlossary;
my $parser = XML::LibXML->new();
my $xmldoc = $parser->parse_file($orderedFile);
my @letters = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
);
my $texFilename = 'main.tex';
open(my $tex, '>:crlf', $texFilename);
foreach my $letter (@letters) { # foreach letter
    if ($xmldoc->exists("//term[substring(word,1,1) = '$letter']")) { # if there's a word which starts with it
        print $tex "\\newpage \n"; # make a new page and start writing
        print $tex "\\textbf{$letter}\n";
        print $tex '\begin{description}';
        foreach my $term ($xmldoc->findnodes("//term[substring(word,1,1) = '$letter']")) {
            print $tex '\item[' . $term->findvalue('./word') . '] \hfill \\\\' . "\n";
            if ($term->exists('./extended')) {
                print $tex 'Nome esteso: ' . $term->findvalue('./extended') . "\n";
            }
            print $tex '\begin{enumerate}' . "\n";
            foreach my $definition ($term->findnodes('./definition')) {
                print $tex '\item ' . $definition->textContent() . "\n";
            }
            print $tex '\end{enumerate}' . "\n";
        }
        print $tex '\end{description}';
    }
}
close $tex;