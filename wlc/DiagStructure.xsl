<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:osis="http://www.bibletechnologies.net/2003/OSIS/namespace"
        xmlns:exslt="http://exslt.org/common"
        xmlns:date="http://exslt.org/dates-and-times"
        xmlns:func="http://exslt.org/functions"
        xmlns:mp24="http://my.own.org/namespace"
        extension-element-prefixes="date func mp24"
        exclude-result-prefixes="date func mp24">

<!--                               -->

<xsl:strip-space elements="*"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:output indent="no"/>
<xsl:output encoding="UTF-8"/>

<xsl:template match="/">
  <xsl:call-template name="parse">
    <xsl:with-param name="path" select="'/'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="parse">
  <xsl:param name="path"/>

  <xsl:choose>
    <xsl:when test="count(*) > 0">
      <xsl:for-each select="*">
        <xsl:call-template name="parse">
          <xsl:with-param name="path" select="concat($path, name(.), '/')"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$path"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--                               -->

</xsl:transform>

<!--
  vim:shiftwidth=2:tabstop=2
-->
