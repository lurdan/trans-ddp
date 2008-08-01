<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

  <!-- (C) 2008 W. Martin Borgert debacle@debian.org
       See COPYING for the license status of this software. -->

  <xsl:output method="text" encoding="ascii"/>

  <xsl:template match="article/title">
    <xsl:text>InfoKey: Title
InfoValue: </xsl:text><xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="article/subtitle">
    <xsl:text>InfoKey: Subject
InfoValue: </xsl:text><xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="holder">
    <!-- xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if -->
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="copyright[1]">
    <xsl:apply-templates select="holder"/>
  </xsl:template>

  <xsl:template match="copyright">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="holder"/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="keyword[@role]"/>

  <xsl:template match="keyword">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="keywordset">
    <xsl:text>InfoKey: Keywords
InfoValue: </xsl:text>
    <xsl:apply-templates select="*"/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="articleinfo">
    <xsl:text>InfoKey: Author
InfoValue: </xsl:text><xsl:apply-templates select="copyright"/>
    <xsl:apply-templates select="keywordset"/>
    <xsl:text>InfoKey: Creator
InfoValue: docbook-xsl, xsltproc
InfoKey: Producer
InfoValue: DBLaTeX|xmlroff
</xsl:text>
  </xsl:template>

  <xsl:template match="*|@*|text()">
    <xsl:apply-templates select="*|@*|text()"/>
  </xsl:template>
</xsl:stylesheet>
