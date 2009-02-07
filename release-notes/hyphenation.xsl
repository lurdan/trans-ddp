<?xml version='1.0' encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  <xsl:template match="book|article" mode="docinfo">
    <!-- Apply default settings -->
    <xsl:apply-imports/>
    <xsl:text>\input{</xsl:text><xsl:value-of
        select="$lingua"/><xsl:text>/hyphenation.tex}
    </xsl:text>
  </xsl:template>
</xsl:stylesheet>
