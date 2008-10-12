<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
    method="xml" indent="yes" encoding="utf-8"
    doctype-system="http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd"
    doctype-public="-//OASIS//DTD DocBook XML V4.2//EN"/>

  <!-- disabled, not Debian-specific -->
  <xsl:template match="section[@id='samba']"/>

  <xsl:template match="section/glosslist">
    <xsl:if
	test="contains('dpkg apache2 configuration shell-commands apt', ../@id)">
      <xsl:processing-instruction name="custom-pagebreak"/>
    </xsl:if>
    <informaltable pgwide="1" frame="none" colsep="1" rowsep="1">
      <xsl:attribute name="id"><xsl:value-of
      select="../@id"/></xsl:attribute>
      <!-- role="small" is understood by dblatex -->
      <xsl:attribute name="role">
	<xsl:choose>
	  <xsl:when test="contains('bg es fr',
			  /article/@lang)">footnotesize</xsl:when>
	  <xsl:otherwise>small</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:processing-instruction
	  name="dbfo">keep-together="always"</xsl:processing-instruction>
      <tgroup cols="2">
	<colspec align="justify" colwidth="2*" colname="l"/>
	<colspec align="justify" colwidth="3*" colname="r"/>
	<spanspec spanname="a" namest="l" nameend="r"/>
	<thead>
	  <row>
	    <entry spanname="a" align="center"><xsl:value-of
	    select="../title"/></entry>
	  </row>
	</thead>
	<tbody>
	  <xsl:apply-templates select="*"/>
	</tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

  <xsl:template match="article">
    <article>
      <xsl:apply-templates select="*|@*|text()"/>
      <xsl:processing-instruction name="custom-notice"/>
      <ackno/> <!-- until dblatex understands the custom-notice -->
    </article>
  </xsl:template>

  <xsl:template match="articleinfo">
    <articleinfo>
      <xsl:copy-of select="document('refcard.dbk')/article/articleinfo/corpauthor"/>
      <xsl:copy-of select="document('refcard.dbk')/article/articleinfo/author"/>
      <revhistory>
	<revision>
	  <xsl:copy-of
	   select="document('refcard.dbk')/article/articleinfo/revhistory/revision[1]/revnumber"/>
	  <xsl:copy-of
	   select="document('refcard.dbk')/article/articleinfo/revhistory/revision[1]/date"/>
	</revision>
      </revhistory>
      <xsl:apply-templates select="*|@*|text()"/>
    </articleinfo>
  </xsl:template>

  <xsl:template match="glossentry">
    <row>
      <xsl:apply-templates select="*|@*|text()"/>
    </row>
  </xsl:template>

  <xsl:template match="glossterm">
    <entry align="left">
      <xsl:apply-templates select="*|@*|text()"/>
    </entry>
  </xsl:template>

  <xsl:template match="glossdef">
    <entry>
      <xsl:attribute name="align">
	<xsl:choose>
	  <xsl:when test="contains('ar fa he',
			  /article/@lang)">right</xsl:when>
	  <xsl:otherwise>left</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="para/*|para/@*|para/text()"/>
    </entry>
  </xsl:template>

  <xsl:template match="section">
    <xsl:apply-templates select="*|text()"/>
  </xsl:template>

  <xsl:template match="section/title"/>

  <!-- for the original English only one copyright note -->
  <xsl:template match="copyright[position() != 1]">
    <xsl:if test="/article/@lang != 'en-GB'">
      <xsl:copy>
	<xsl:apply-templates select="*|@*|text()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*|@*|text()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
