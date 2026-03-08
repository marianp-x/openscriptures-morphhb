<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
  <!ENTITY TAB "&#x09;">
  <!ENTITY NL "&#x0a;">
]>

<xsl:transform version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:common="http://exslt.org/common"
        xmlns:date="http://exslt.org/dates-and-times"
        xmlns:func="http://exslt.org/functions"
        xmlns:regexp="http://exslt.org/regular-expressions"
        xmlns:mp="http://my.own.org/namespace"
        extension-element-prefixes="common date func regexp mp"
        exclude-result-prefixes="common date func mp">

<!--
  The 'bookSchemaFname' global parameter is used to control the name of the
  name of the external output file TSV.

  The default value for this parameter is designed to NOT match any .xml file,
  thus implicitly making this parameter mandatory to be defined during the
  run-time.
  -->

<xsl:param name="bookSchemaFname" select="'UNKNOWN'"/>

<!--                               -->

<xsl:output method="text" encoding="UTF-8"/>
<xsl:output encoding="UTF-8"/>
<xsl:strip-space elements="*"/>

<!--                               -->

<xsl:template match="/book">
  <xsl:apply-templates select="*"/>

  <common:document href="{$bookSchemaFname}"
                   method="text"
                   encoding="UTF-8">
    <xsl:value-of select="'TokenPathJewish'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'TokenPathChristian'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordId'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'OsisWordId'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'Language'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'Word'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordN'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordC'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordParsed'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordLemma'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordMorph'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordConjunction'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordPreposition'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordArticle'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordInterrogative'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordParticle'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordVerbBinyanim'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordForm'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordPgn'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordState'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordSuffixPronominal'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordSuffixPronominalPgn'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordSuffixDirectionalHei'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordSuffixParagogicHei'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordSuffixParagogicNun'"/>
    <xsl:text>&NL;</xsl:text>
  </common:document>
</xsl:template>

<!--                               -->

<xsl:template match="*[starts-with(name(), 'hebrew_') or starts-with(name(), 'aramaic_')]">

  <xsl:variable name="tokenPathJewish">
    <xsl:value-of select="concat(../@bookPathJewish, '/', @versePathJewish)"/>
  </xsl:variable>
  <xsl:variable name="tokenPathChristian">
    <xsl:value-of select="concat(../@bookPathChristian, '/', @versePathChristian)"/>
  </xsl:variable>
  <xsl:variable name="wordId">
    <!-- TODO: Generate in Word XML -->
  </xsl:variable>
  <xsl:variable name="osisWordId">
    <xsl:value-of select="@osisWordId"/>
  </xsl:variable>
  <xsl:variable name="tokenName" select="name(.)"/>
  <xsl:variable name="language" select="substring-before($wordName, '_')"/>
  <xsl:variable name="token">
    <xsl:choose>
      <xsl:when test="contains($tokenName, 'punctuation')">
        <xsl:value-of select="text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="mp:string_join('', */text())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="tokenParsed">
    <xsl:choose>
      <xsl:when test="contains($tokenName, 'punctuation')">
        <xsl:value-of select="text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="mp:string_join('׀', */text())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="tokenN">
    <xsl:value-of select="mp:strip_taamim($token)"/>
  </xsl:variable>
  <xsl:variable name="tokenC">
    <xsl:value-of select="mp:strip_pointing($token)"/>
  </xsl:variable>

  <xsl:value-of select="$tokenPathJewish"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$tokenPathChristian"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordId"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$osisWordId"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$language"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$tokenName"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$token"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$tokenN"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$tokenC"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$tokenParsed"/>
  <xsl:text>&NL;</xsl:text>

</xsl:template>

<!-- Ignore all other elements -->

<xsl:template match="text()|@*">
</xsl:template>

<!-- ***************************************************************** -->
<!--                              FUNCTIONS                            -->
<!-- ***************************************************************** -->

<func:function name="mp:strip_pointing">
  <xsl:param name="hebrew"/>

  <xsl:variable name="sansTaamim">
    <xsl:value-of select="mp:strip_taamim($hebrew)"/>
  </xsl:variable>

  <xsl:variable name="sansNiqqudh">
    <xsl:value-of select="translate($sansTaamim, '&#1456;&#1457;&#1458;&#1459;&#1460;&#1461;&#1462;&#1463;&#1464;&#1465;&#1466;&#1467;', '')"/>
  </xsl:variable>

  <xsl:variable name="sansShinDots">
    <xsl:value-of select="translate($sansNiqqudh, '&#1473;&#1474;', '')"/>
  </xsl:variable>

  <xsl:variable name="sansDagheish">
    <xsl:value-of select="translate($sansShinDots, '&#1468;', '')"/>
  </xsl:variable>

  <func:result>
    <xsl:value-of select="$sansDagheish"/>
  </func:result>
</func:function>

<!--                               -->

<func:function name="mp:strip_taamim">
  <xsl:param name="hebrew"/>

  <xsl:variable name="sansCantilations">
    <xsl:value-of select="translate($hebrew, '&#1425;&#1426;&#1427;&#1428;&#1429;&#1430;&#1431;&#1432;&#1433;&#1434;&#1435;&#1436;&#1437;&#1438;&#1439;&#1440;&#1441;&#1442;&#1443;&#1444;&#1445;&#1446;&#1447;&#1448;&#1449;&#1450;&#1451;&#1452;&#1453;&#1454;&#1455;', '')"/>
  </xsl:variable>

  <xsl:variable name="sansMeteg">
    <xsl:value-of select="translate($sansCantilations, '&#1469;', '')"/>
  </xsl:variable>

  <xsl:variable name="sansErasureDots">
    <xsl:value-of select="translate($sansMeteg, '&#1476;&#1477;', '')"/>
  </xsl:variable>

  <func:result>
    <xsl:value-of select="$sansErasureDots"/>
  </func:result>
</func:function>

<!--                               -->

<func:function name="mp:string_join">
  <xsl:param name="delimiter"/>
  <xsl:param name="strings"/>

  <func:result>
    <xsl:for-each select="$strings">
      <xsl:if test="position() > 1">
        <xsl:value-of select="$delimiter"/>
      </xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </func:result>
</func:function>

<!--                               -->

</xsl:transform>

<!--
  vim:shiftwidth=2:tabstop=2
-->
