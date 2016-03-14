# xml-glossary
<h1>glossaryLatex</h1>
Permette di costruire il glossario in forato .tex. Lo script Perl createLatex.pl prende un solo parametro, ovvero il path del file xml contenente il glossario. Il file xml deve essere valido rispetto al file schema.xsd.
Se lo script viene eseguito da Chronos cambiare il percorso del file xsl usato per levare i namespace dal file xml (commentare la linea 11 e togliere il commento dalla linea 10). 
Nella directory contenente il file xml verrà creato un file, glossary.tex, corrispondente al file tex del glossario.

<h1>glossaryItem</h1>
Permette di intersecare il glossario (in formato tex) e un documento (in formato tex) qualsiasi. Lo script accetta due parametri:
- 0: path del file tex del glossario;
- 1: path del file tex del documento.
Per ogni termine, o plurale, 'term', presente nel glossario, lo script trova e sostituisce tutte le occorrenze nel documento con \glossaryItem{term}.
La modifica viene fatta direttamente nel file puntato da (1).
