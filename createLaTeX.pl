use strict;

use XML::XSLT;

my $xslt = XML::XSLT->new ('alphabeticalOrder.xsl', warnings => 1);
$xslt->transform ('glossary.xml');
open(my $orderedGlossary, ">", "orderedGlossary.xml");
print $orderedGlossary $xslt->toString;
close $orderedGlossary;