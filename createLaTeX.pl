use strict;

use XML::LibXML;
use XML::XSLT;
use XML::Validate;

# order glossary: unuseful!
=comment
my $xslFile = 'alphabeticalOrder.xsl';
my $xmlFile = 'glossary.xml';
my $orderedFile = 'orderedGlossary.xml';
my $xslt = XML::XSLT->new ($xmlFile, warnings => 1);
$xslt->transform ($xmlFile);
open(my $orderedGlossary, '>', $orderedFile);
print $orderedGlossary '<?xml version="1.0" encoding="UTF-8"?>';
print $orderedGlossary $xslt->toString;
close $orderedGlossary;
=cut

my $xmlFile = 'glossary.xml';
my $validator = new XML::Validate(Type => 'LibXML');
open XML, $xmlFile;
my $xml = join("", <XML>);
close XML;
# Check if the glossary is still valid
if ($validator->validate($xml)) { #If not, stop and show the error
    print "Document is invalid\n";
    my $message = $validator->last_error()->{message};
    my $line = $validator->last_error()->{line};
    my $column = $validator->last_error()->{column};
    print "Error: $message at line $line, column $column\n";
} else { # else parse it and write the tex file
    my @letters = (
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    );
    my $parser = XML::LibXML->new();
    my $xmldoc = $parser->parse_file($xmlFile);
    $xmldoc->documentElement->setNamespace('glossary', 'g');
    my $texFilename = 'main.tex';
    open(my $tex, '>:crlf', $texFilename);
    foreach my $letter (@letters) { # foreach letter
        if ($xmldoc->exists("//g:term[substring(g:word,1,1) = '$letter']")) { # if there's a word which starts with it
            print $tex "\\newpage \n"; # make a new page and start writing
            print $tex "\\textbf{$letter}\n";
            print $tex '\begin{description}';
            foreach my $term ($xmldoc->findnodes("//g:term[substring(g:word,1,1) = '$letter']")) {
                print $tex '\item[' . $term->findvalue('./g:word') . '] \hfill \\\\' . "\n";
                if ($term->exists('./g:extended')) {
                    print $tex 'Nome esteso: ' . $term->findvalue('./g:extended') . "\n";
                }
                print $tex '\begin{enumerate}' . "\n";
                foreach my $definition ($term->findnodes('./g:definition')) {
                    print $tex '\item ' . $definition->textContent() . "\n";
                }
                print $tex '\end{enumerate}' . "\n";
            }
            print $tex '\end{description}';
        }
    }
    close $tex;
}