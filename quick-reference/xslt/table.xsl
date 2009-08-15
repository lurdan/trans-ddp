<?xml version="1.0" encoding="utf-8" ?>
<!-- vim: set sts=2 ai expandtab:

Process raw XML file:
 * to add URL attribute as "&url-*;"
 * to add ID  attribute to valid name from title for tables
 * to add popcon and package size as &pkgsize-***; and &pop-***; 
     package_name @@@popcon1@@@ @@@psize1@@@  ...
     something    package_name  @@@popcon2@@@ @@@psize2@@@ ...
 * Debian URL links are provided for package lists using non-translating parts for reason.
 * Do not add link to translatable strings.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:variable name="uletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 !#$%()=-~^|\/+*,.?;:@`&quot;&apos;&amp;&gt;&lt;’</xsl:variable>
<xsl:variable name="lletters">abcdefghijklmnopqrstuvwxyzabcdefghij</xsl:variable>
<!-- I will use max 32 characters for href references and id references -->

<xsl:output method="xml" indent="yes"/>

<!-- xsl:strip-space elements="*"/ -->


<!-- column 1 -->
<xsl:template match="//tbody/row/entry[1]">
  <xsl:choose>
    <xsl:when test="contains(../entry[2], '@@@popcon1@@@')">
      <!-- column 1 is package name -->
      <xsl:copy>
      <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://packages.debian.org/sid/", normalize-space(.), "@@@dq@@@@@@gt@@@")'/>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:text disable-output-escaping="yes">&lt;/ulink&gt; </xsl:text>
      <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://bugs.debian.org/", normalize-space(.), "@@@dq@@@@@@gt@@@")'/>
      <xsl:text disable-output-escaping="yes">*&lt;/ulink&gt;</xsl:text>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- column 2 -->
<xsl:template match="//tbody/row/entry[2]">
  <xsl:choose>
    <xsl:when test="contains(../entry[3], '@@@popcon2@@@')">
      <!-- column 2 is package name -->
      <xsl:copy>
      <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://packages.debian.org/sid/", normalize-space(.), "@@@dq@@@@@@gt@@@")'/>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:text disable-output-escaping="yes">&lt;/ulink&gt; </xsl:text>
      <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://bugs.debian.org/", normalize-space(.), "@@@dq@@@@@@gt@@@")'/>
      <xsl:text disable-output-escaping="yes">*&lt;/ulink&gt;</xsl:text>
      </xsl:copy>
    </xsl:when>
    <xsl:when test="contains(., '@@@popcon1@@@')">
      <!-- column 2 is popcon -->
      <xsl:copy>
      <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://qa.debian.org/popcon.php?package=", normalize-space(../entry[1]), "@@@dq@@@@@@gt@@@")'/>
      <xsl:text disable-output-escaping="yes">&amp;pop-</xsl:text>
      <xsl:value-of select="translate( normalize-space(../entry[1]), $uletters, $lletters)"/>
      <xsl:value-of select="';'"/>
      <xsl:text disable-output-escaping="yes">&lt;/ulink&gt;</xsl:text>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- column 3 -->
<xsl:template match="//tbody/row/entry[3]">
  <xsl:choose>
    <xsl:when test="contains(., '@@@popcon2@@@')">
      <!-- column 3 is popcon -->
      <xsl:copy>
      <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://qa.debian.org/popcon.php?package=", normalize-space(../entry[2]), "@@@dq@@@@@@gt@@@")'/>
      <xsl:text disable-output-escaping="yes">&amp;pop-</xsl:text>
      <xsl:value-of select="translate( normalize-space(../entry[2]), $uletters, $lletters)"/>
      <xsl:value-of select="';'"/>
      <xsl:text disable-output-escaping="yes">&lt;/ulink&gt;</xsl:text>
      </xsl:copy>
    </xsl:when>
    <xsl:when test="contains(., '@@@psize1@@@')">
      <!-- column 3 is size -->
      <xsl:copy>
      <xsl:choose>
        <xsl:when test="starts-with(normalize-space(../entry[1]), 'lib')">
          <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://packages.qa.debian.org/", substring(normalize-space(../entry[1]), 1, 4), "/", normalize-space(../entry[1]), ".html@@@dq@@@@@@gt@@@")'/>
          <xsl:text disable-output-escaping="yes">&amp;size-</xsl:text>
          <xsl:value-of select="translate( normalize-space(../entry[1]), $uletters, $lletters)"/>
          <xsl:value-of select="';'"/>
          <xsl:text disable-output-escaping="yes">&lt;/ulink&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://packages.qa.debian.org/", substring(normalize-space(../entry[1]), 1, 1), "/", normalize-space(../entry[1]), ".html@@@dq@@@@@@gt@@@")'/>
          <xsl:text disable-output-escaping="yes">&amp;size-</xsl:text>
          <xsl:value-of select="translate( normalize-space(../entry[1]), $uletters, $lletters)"/>
          <xsl:value-of select="';'"/>
          <xsl:text disable-output-escaping="yes">&lt;/ulink&gt;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- column 3 -->
<xsl:template match="//tbody/row/entry[4]">
  <xsl:choose>
    <xsl:when test="contains(., '@@@psize2@@@')">
      <!-- column 4 is size -->
      <xsl:copy>
      <xsl:choose>
        <xsl:when test="starts-with(normalize-space(../entry[2]), 'lib')">
          <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://packages.qa.debian.org/", substring(normalize-space(../entry[2]), 1, 4), "/", normalize-space(../entry[2]), ".html@@@dq@@@@@@gt@@@")'/>
          <xsl:text disable-output-escaping="yes">&amp;size-</xsl:text>
          <xsl:value-of select="translate( normalize-space(../entry[2]), $uletters, $lletters)"/>
          <xsl:value-of select="';'"/>
          <xsl:text disable-output-escaping="yes">&lt;/ulink&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='concat("@@@lt@@@ulink url=@@@dq@@@http://packages.qa.debian.org/", substring(normalize-space(../entry[2]), 1, 1), "/", normalize-space(../entry[2]), ".html@@@dq@@@@@@gt@@@")'/>
          <xsl:text disable-output-escaping="yes">&amp;size-</xsl:text>
          <xsl:value-of select="translate( normalize-space(../entry[2]), $uletters, $lletters)"/>
          <xsl:value-of select="';'"/>
          <xsl:text disable-output-escaping="yes">&lt;/ulink&gt;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="ulink">
  <xsl:choose>
    <xsl:when test="starts-with(@url,'/')">
      <xsl:value-of select="node()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:attribute name="url">
          <xsl:text>@@@ampbare@@@</xsl:text>
          <xsl:choose>
            <xsl:when test="string-length(.) = 0">
              <xsl:choose>
                <xsl:when test="string-length(translate(@url,$uletters,$lletters)) &lt;= 32">
                  <xsl:value-of select="translate(@url,$uletters,$lletters)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(substring(translate(@url,$uletters,$lletters),1,16),substring(translate(@url,$uletters,$lletters), string-length(translate(@url,$uletters,$lletters))-15,16))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="string-length(translate(.,$uletters,$lletters)) &lt;= 32">
                  <xsl:value-of select="translate(.,$uletters,$lletters)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(substring(translate(.,$uletters,$lletters),1,16),substring(translate(.,$uletters,$lletters), string-length(translate(.,$uletters,$lletters))-15,16))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="';'"/>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="string-length(.) = 0">
            <xsl:value-of select="@url"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- add id attribute -->
<xsl:template match="table">
  <xsl:copy>
    <xsl:attribute name="id">
      <xsl:choose>
        <xsl:when test="string-length(translate(title,$uletters,$lletters)) &lt;= 32">
          <xsl:value-of select="translate(title,$uletters,$lletters)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(substring(translate(title,$uletters,$lletters),1,16),substring(translate(title,$uletters,$lletters), string-length(translate(title,$uletters,$lletters))-15,16))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>

