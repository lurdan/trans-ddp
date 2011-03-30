<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
    method="xml" indent="yes" encoding="utf-8"
    doctype-system="http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"
    doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"/>


  <!-- You must escape # in URL -->
  <xsl:template match="ulink[.!='']">
    <xsl:copy-of select="."/>
    <xsl:text> (</xsl:text><filename><xsl:value-of
        select="translate(@url,'#','\#')" /></filename><xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="*|@*|text()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
