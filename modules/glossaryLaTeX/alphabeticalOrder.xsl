<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:template match="/">
        <glossary>
        <xsl:for-each select="//term">
            <xsl:sort select="translate(./word, $uppercase, $smallcase)" />
            <xsl:copy-of select="." />
            
        </xsl:for-each>
        </glossary>
    </xsl:template>

</xsl:stylesheet>
