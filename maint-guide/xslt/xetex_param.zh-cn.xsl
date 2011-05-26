<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

  <xsl:param name="xetex.font">
    <xsl:text>\setmainfont{Nimbus Roman No9 L}&#10;</xsl:text>
    <xsl:text>\setsansfont{Nimbus Sans L}&#10;</xsl:text>
    <xsl:text>\setmonofont{Nimbus Mono L}&#10;</xsl:text>
    <xsl:text>\usepackage{xeCJK}&#10;</xsl:text>
<!-- zh_CN centric: ttf-arphic-gbsn00lp, ttf-wqy-zenhei -->
    <xsl:text>\setCJKmainfont{AR PL SungtiL GB}&#10;</xsl:text>
    <xsl:text>\setCJKsansfont{WenQuanYi Zen Hei}&#10;</xsl:text>
    <xsl:text>\setCJKmonofont{WenQuanYi Zen Hei Mono}&#10;</xsl:text>
<!-- zh_TW centric start: ttf-arphic-uming, ttf-wqy-zenhei -->
<!--
    <xsl:text>\setCJKmainfont{AR PL UMing}&#10;</xsl:text>
    <xsl:text>\setCJKsansfont{WenQuanYi Zen Hei}&#10;</xsl:text>
    <xsl:text>\setCJKmonofont{WenQuanYi Zen Hei Mono}&#10;</xsl:text>
-->
<!-- ko centric: -->
<!--
    <xsl:text>\setCJKmainfont{}&#10;</xsl:text>
    <xsl:text>\setCJKsansfont{}&#10;</xsl:text>
    <xsl:text>\setCJKmonofont{}&#10;</xsl:text>
-->
<!-- ja centric: otf-ipafont-mincho otf-ipafont-gothic -->
<!--
    <xsl:text>\setCJKmainfont{IPAMincho}&#10;</xsl:text>
    <xsl:text>\setCJKsansfont{IPAPGothic}&#10;</xsl:text>
    <xsl:text>\setCJKmonofont{IPAGothic}&#10;</xsl:text>
-->
  </xsl:param>

</xsl:stylesheet>
<!--
= Asian font basics =

== Sanserif ==
  simplified Chinese: 黑体 hēi tǐ
    ttf-wqy-zenhei (zh_CN centric)
      WenQuanYi Zen Hei,文泉驛正黑,文泉驿正黑
      WenQuanYi Zen Hei Sharp,文泉驛點陣正黑,文泉驿点阵正黑
      WenQuanYi Zen Hei Mono,文泉驛等寬正黑,文泉驿等宽正黑
  traditional Chinese: 黑體 hēi tǐ 
  Japanese: ゴシック kaku goshikku, gothic
    otf-ipafont-gothic (ja centric)
      IPAGothic,IPAゴシック
      IPAPGothic,IPA Pゴシック

== Serif ==
中国大陆一般称：宋体；台湾香港一般称：明體
  simplified Chinese: 宋体/(明体), Sòngtǐ
    ttf-arphic-gbsn00lp (zh_CN centric)
      AR PL SungtiL GB
  traditional Chinese: (宋體)/明體, Sòngtǐ
    ttf-arphic-bsmi00lp (zh_TW centric)
      AR PL Mingti2L Big5	
    ttf-arphic-uming    (zh_TW centric)
      AR PL UMing
       = "AR PL Mingti2L Big5" and "AR PL SungtiL GB" + extra in Taiwan-style
  Japanese: 明朝体, Minchōtai
    otf-ipafont-mincho (ja centric)
      IPAMincho,IPA明朝:style=Regular
      IPAPMincho,IPA P明朝:style=Regular
  Korean: Hangul: 명조체; Hanja: 明朝體; Revised Romanization: Myeongjoche

== Script () ==
  simplified Chinese: 楷书; kǎishū
    ttf-arphic-gkai00mp (zh_CN centric)
      AR PL KaitiM GB
  traditional Chinese: 楷書; kǎishū
    ttf-arphic-bkai00mp (zh_TW centric)
      AR PL KaitiM Big5
    ttf-arphic-ukai     (zh_TW centric)
      AR PL UKai
       = AR PL KaitiM Big5" + "AR PL KaitiM GB" + extra in Taiwan-style
  Japanese: 楷書, kaisho (教科書体)

Korean:
ttf-alee
ttf-baekmuk
ttf-nanum
ttf-nanum-coding

encoding names:
  * GB2312, GBK or GB18030: Simplified Chinese
  * Big5:                   Traditional Chinese
-->

