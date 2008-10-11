<?xml version='1.0' encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:param name="latex.encoding">utf8</xsl:param>
  <xsl:param name="latex.class.options">10pt,onecolumn</xsl:param>

  <xsl:param name="format">a4</xsl:param>

  <!-- no space for subtitle -->
  <xsl:template match="article/subtitle"/>

  <xsl:template match="book|article" mode="docinfo">
    <!-- Apply default settings -->
    <xsl:apply-imports/>

    <!-- pass to LaTeX -->
    <xsl:if test="$format='lt'">
      <xsl:text>\REFletterformat&#10;</xsl:text>
    </xsl:if>
    <xsl:text>\def\REFcorpauthorimage{</xsl:text>
    <xsl:value-of
	select="/article/articleinfo/corpauthor//imagedata[@format='EPS']/@fileref"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:text>\def\REFcorpauthorurl{</xsl:text>
    <xsl:value-of
	select="/article/articleinfo/corpauthor/ulink/@url"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:text>\def\REFversion{</xsl:text>
    <xsl:value-of
	select="/article/articleinfo/keywordset/keyword[@role='version']"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:text>\def\REFrevnumber{</xsl:text>
    <xsl:value-of
	select="/article/articleinfo/revhistory/revision[1]/revnumber"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:text>\def\REFdate{</xsl:text>
    <xsl:value-of
	select="/article/articleinfo/revhistory/revision[1]/date"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <!-- xsl:template match="processing-instruction('custom-notice')" -->
  <xsl:template match="ackno">
    <!-- <xsl:if test="$ad"> -->
    <!--   <xsl:text>\begin{center} -->
    <!--   \input{</xsl:text><xsl:value-of select="$ad"/><xsl:text>} -->
    <!--   \end{center} -->
    <!--   \vfill</xsl:text> -->
    <!-- </xsl:if> -->
    <!-- visual layout - how I hate it! -->
    <xsl:text>\newpages{</xsl:text>
    <xsl:choose>
        <xsl:when test="contains('bg', /article/@lang)">2</xsl:when>
        <xsl:when test="contains('es eu fi gl hu nl pt pt_BR ru',
            /article/@lang)">0</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
    <xsl:text>}&#10;~&#10;</xsl:text>
    <xsl:text>\vfill&#10;</xsl:text>
    <xsl:text>\begin{minipage}{\linewidth}&#10;</xsl:text>
    <xsl:text>{\footnotesize&#10;</xsl:text>
    <xsl:text>\textbf{&#10;\begin{center}&#10;</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'LegalNotice'"/>
    </xsl:call-template>
    <xsl:text>\end{center}&#10;}&#10;\vspace{-2ex}&#10;</xsl:text>
    <xsl:text>\DBKlegalblock}&#10;\vspace{-2ex}&#10;</xsl:text>
    <xsl:text>{\scriptsize \DBKcopyright \\&#10;</xsl:text>
    <xsl:value-of
      select="/article/articleinfo/keywordset/keyword[@role='madeby']"/>
    <xsl:text>: \url{http://xinocat.com/refcard/}}&#10;</xsl:text>
    <xsl:text>\end{minipage}&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="x-informaltable">
    <xsl:text>\begin{minipage}{\linewidth}%&#10;</xsl:text>
    <xsl:apply-imports/>
    <xsl:text>\end{minipage}&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
