<?xml version='1.0' encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:param name="latex.encoding">utf8</xsl:param>
  <xsl:param name="latex.class.options">10pt</xsl:param>

  <!-- no space for subtitle -->
  <xsl:template match="article/subtitle"/>

  <xsl:template match="book|article" mode="docinfo">
    <!-- Apply default settings -->
    <xsl:apply-imports/>

    <!-- pass to LaTeX -->
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

 <xsl:template match="ackno">
    <xsl:text>\gotopage{6}\parskip=-3ex&#10;</xsl:text>
    <xsl:apply-templates select="/article/articleinfo/legalnotice"/>
    <xsl:text>\begin{flushleft}</xsl:text>
    <xsl:apply-templates select="/article/articleinfo/copyright[1]"/>
    <xsl:if test="/article/articleinfo/copyright[2]">
      <xsl:text>\\</xsl:text>
      <xsl:apply-templates select="/article/articleinfo/copyright[2]"/>
    </xsl:if>
    <xsl:text>\\
    {\small </xsl:text><xsl:value-of
      select="/article/articleinfo/keywordset/keyword[@role='madeby']"/>
    <xsl:text>: \url{http://xinocat.com/refcard/}}
    \end{flushleft}
    </xsl:text>
  </xsl:template>

  <xsl:template name="keyword-list">
    <xsl:for-each select="/article/articleinfo/keywordset/keyword[@role='']">
      <xsl:value-of select="."/>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="book|article" mode="preamble">
    <xsl:apply-imports/>
    <xsl:text>\hypersetup{%&#10;</xsl:text>
    <xsl:if test="$doc.pdfcreator.show='1'">
      <xsl:text>pdfcreator={DBLaTeX-</xsl:text>
      <xsl:value-of select="$version"/>
      <xsl:text>},%&#10;</xsl:text>
    </xsl:if>
    <xsl:text>pdftitle={</xsl:text>
    <xsl:value-of select="/article/title"/>
    <xsl:text>},%&#10;</xsl:text>
    <xsl:text>pdfauthor={</xsl:text>
    <xsl:value-of select="/article/articleinfo/author/firstname"/>
    <xsl:value-of select="/article/articleinfo/author/surname"/>
    <xsl:text>},%&#10;</xsl:text>
    <xsl:if test="/book/subtitle|/article/subtitle">
      <xsl:text>pdfsubject={</xsl:text>
      <xsl:value-of select="/article/subtitle"/>
      <xsl:text>},%&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="/book/bookinfo/keywordset|/article/articleinfo/keywordset">
      <xsl:text>pdfkeywords={</xsl:text>
      <xsl:call-template name="keyword-list"/>
      <xsl:text>},&#10;</xsl:text>
    </xsl:if>
    <xsl:text>pdfpagemode=UseNone,&#10;</xsl:text>
    <xsl:text>pdfpagelabels,&#10;</xsl:text>
    <xsl:text>pdfstartview=FitH,&#10;</xsl:text>
    <xsl:text>urlcolor=url&#10;</xsl:text>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
