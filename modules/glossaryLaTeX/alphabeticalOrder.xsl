<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <glossary>
        <xsl:for-each select="//term">
            <xsl:sort select="./word" />
            <xsl:copy-of select="." />
        </xsl:for-each>
        </glossary>
    </xsl:template>

</xsl:stylesheet>