<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:osis="http://www.bibletechnologies.net/2003/OSIS/namespace"
        xmlns:exslt="http://exslt.org/common"
        xmlns:date="http://exslt.org/dates-and-times"
        xmlns:func="http://exslt.org/functions"
        xmlns:regexp="http://exslt.org/regular-expressions"
        xmlns:mp="http://my.own.org/namespace"
        extension-element-prefixes="date func regexp mp"
        exclude-result-prefixes="date func mp">

<!--                               -->

<xsl:strip-space elements="*"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:output indent="no"/>
<xsl:output encoding="UTF-8"/>

<xsl:template match="/osis:osis">
  <xsl:apply-templates/>
</xsl:template>

<!--                               -->

<xsl:template match="osis:seg">
  <xsl:text>seg</xsl:text>
  <xsl:text>&#09;</xsl:text>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text>&#09;</xsl:text>
  <xsl:text>&#09;</xsl:text>
  <xsl:text>&#10;</xsl:text>

  <xsl:apply-templates/>
</xsl:template>

<!--                               -->

<xsl:template match="osis:w">
  <xsl:text>w</xsl:text>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text>&#09;</xsl:text>
  <!--
  <xsl:value-of select="@n"/>
  <xsl:value-of select="regexp:replace(text(), '[\x{0590}-\x{05AF}\x{05BD}]', 'g', '')"/>
    -->
  <xsl:value-of select="mp:strip_taamim(text())"/>
  <xsl:text>&#10;</xsl:text>

  <xsl:apply-templates/>
</xsl:template>

<!--                               -->

<xsl:template match="osis:note">
  <xsl:text>note</xsl:text>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@n"/>
  <xsl:text>&#10;</xsl:text>

  <xsl:apply-templates/>
</xsl:template>

<!--                               -->

<xsl:template match="osis:rdg">
  <xsl:text>rdg</xsl:text>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@type"/>
  <xsl:text>&#09;</xsl:text>
  <xsl:value-of select="@n"/>
  <xsl:text>&#10;</xsl:text>

  <xsl:apply-templates/>
</xsl:template>

<!-- Ignore all other elements -->

<xsl:template match="text()|@*">
</xsl:template>

<!-- ***************************************************************** -->
<!--                              FUNCTIONS                            -->
<!-- ***************************************************************** -->

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

</xsl:transform>

<!--
  vim:shiftwidth=2:tabstop=2
-->
