<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="html"
                version="1.0">

  <xsl:import
      href="http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook.xsl"/>

  <xsl:param name="html.stylesheet">debian.css</xsl:param>
  <xsl:param name="use.extension" select="'1'"></xsl:param>
  <xsl:param name="linenumbering.extension" select="'1'"></xsl:param>

  <xsl:template match="revhistory"
                mode="article.titlepage.recto.auto.mode"/>

  <xsl:template match="revhistory"
                mode="article.titlepage.recto.auto.mode.footnote">
    <div xsl:use-attribute-sets="article.titlepage.recto.style">
      <xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
    </div>
  </xsl:template>

  <xsl:template name="process.footnotes">
    <xsl:apply-templates select="articleinfo/revhistory"
                         mode="article.titlepage.recto.auto.mode.footnote"/>
  </xsl:template>

</xsl:stylesheet>
