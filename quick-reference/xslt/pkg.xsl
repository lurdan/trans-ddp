<?xml version="1.0" encoding="utf-8" ?>
<!--

Extract package name for &pkgsize-***; and &pop-***; substitution
to create pkg.lst file which will be used to create pkgsize.ent and popcon.ent
 
 package_name @@@popcon1@@@ @@@psize1@@@  ...
 something    package_name  @@@popcon2@@@ @@@psize2@@@ ...
                            ^^^^^^^^^^^^^
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no"/>

<xsl:strip-space elements="*"/>

<xsl:template match="//tbody/row/entry[3]">
  <xsl:choose>
  <xsl:when test="contains(., '@@@psize1@@@')">
    <xsl:value-of select="' '"/>
    <xsl:value-of select="normalize-space(../entry[1])"/>
    <xsl:value-of select="' &#10;'"/>
  </xsl:when>
  <xsl:when test="contains(., '@@@popcon2@@@')">
    <xsl:value-of select="' '"/>
    <xsl:value-of select="normalize-space(../entry[2])"/>
    <xsl:value-of select="' &#10;'"/>
  </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
</xsl:template>

</xsl:stylesheet>
