<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
    method="xml" indent="yes" encoding="utf-8"
    doctype-system="http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"
    doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"/>

  <!-- If ulink has text in it -->
  <xsl:template match="ulink[.!='']">
    <xsl:copy-of select="."/>
    <!-- Add plain text of @url except for wikipedia site -->
    <xsl:if test="not(contains(@url,'wikipedia'))">
    (<ulink>
        <xsl:attribute name="url">
            <xsl:value-of select="@url"/>
        </xsl:attribute>
        <xsl:value-of select="@url"/>
    </ulink>)
    </xsl:if>
  </xsl:template>

  <!-- If ulink has no text in it -->
  <xsl:template match="ulink[.='']">
    <ulink>
        <xsl:attribute name="url">
            <xsl:value-of select="@url"/>
        </xsl:attribute>
        <xsl:value-of select="@url"/>
    </ulink>
  </xsl:template>

  <xsl:template match="*|@*|text()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
