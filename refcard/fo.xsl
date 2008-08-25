<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		version="1.0">

  <!-- (C) 2008 W. Martin Borgert debacle@debian.org
       See COPYING for the license status of this software. -->

  <xsl:import
      href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <xsl:param name="body.font.master">9</xsl:param>
  <xsl:param name="body.margin.bottom">0mm</xsl:param>
  <xsl:param name="body.margin.top">0mm</xsl:param>
  <xsl:param name="draft.mode">no</xsl:param>
  <xsl:param name="footer.rule">0</xsl:param>
  <xsl:param name="header.rule">0</xsl:param>
  <xsl:param name="page.height">210mm</xsl:param>
  <xsl:param name="page.margin.bottom">2mm</xsl:param>
  <xsl:param name="page.margin.inner">2mm</xsl:param>
  <xsl:param name="page.margin.outer">2mm</xsl:param>
  <xsl:param name="page.margin.top">2mm</xsl:param>
  <xsl:param name="page.width">99mm</xsl:param>
  <xsl:param name="region.after.extent">0mm</xsl:param>
  <xsl:param name="region.before.extent">0mm</xsl:param>
  <xsl:param name="title.font.family">serif</xsl:param>
  <xsl:param name="ulink.show" select="0"></xsl:param>

  <xsl:template name="header.content"/>
  <xsl:template name="footer.content"/>

  <xsl:template match="title" mode="article.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="article.titlepage.recto.style"
	      keep-with-next.within-column="always"
	      font-size="12pt"
	      font-variant="small-caps"
	      font-weight="bold">
      <xsl:call-template name="component.title">
	<xsl:with-param name="node" select="ancestor-or-self::article[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="article.titlepage.recto">
    <xsl:apply-templates mode="article.titlepage.recto.auto.mode"
			 select="articleinfo/corpauthor"/>
    <xsl:apply-templates mode="article.titlepage.recto.auto.mode"
			 select="title"/>
    <xsl:apply-templates mode="article.titlepage.recto.auto.mode"
			 select="articleinfo/keywordset/keyword[@role='version']"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="article.titlepage.recto.auto.mode"
			 select="articleinfo/revhistory/revision[1]/revnumber"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="article.titlepage.recto.auto.mode"
			 select="articleinfo/revhistory/revision[1]/date"/>
    <fo:block font-family="courier"> <!-- "{$monospace.font.family}" -->
      <xsl:apply-templates mode="article.titlepage.recto.auto.mode"
			   select="/article/articleinfo/corpauthor/ulink/@url"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="processing-instruction('custom-pagebreak')">
    <fo:block break-before='page'/>
  </xsl:template>

  <xsl:template match="processing-instruction('custom-notice')">
    <fo:block start-indent="0pt"
	      text-align="center"
	      keep-together="always"
	      margin-top="4cm">
      <fo:inline font-weight="bold">
	<xsl:call-template name="gentext">
	  <xsl:with-param name="key" select="'LegalNotice'"/>
	</xsl:call-template>
      </fo:inline>
      <fo:block text-align="justify">
	<xsl:apply-templates select="/article/articleinfo/legalnotice"
			     mode="titlepage.mode"/>
	<xsl:apply-templates select="/article/articleinfo/copyright[1]"
			     mode="titlepage.mode"/>
	<xsl:if test="/article/articleinfo/copyright[2]">
	  <fo:block>
	    <xsl:apply-templates select="/article/articleinfo/copyright[2]"
				 mode="titlepage.mode"/>
	  </fo:block>
	</xsl:if>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="thead/row/entry/text()">
    <fo:block font-variant="small-caps"
	      font-weight="bold">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
