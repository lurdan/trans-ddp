<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
    method="xml" indent="yes" encoding="utf-8"
    doctype-system="http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"
    doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"/>


  <!-- You must convert footnote as (...) -->
  <xsl:template match="footnote">
    (<xsl:apply-templates select="*|@*|text()"/>)
  </xsl:template>

  <!-- You must skip paragraph braks in footnote -->
  <xsl:template match="footnote/para">
    <xsl:apply-templates select="*|@*|text()"/>
  </xsl:template>

  <xsl:template match="*|@*|text()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
