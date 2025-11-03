<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
  <!ENTITY TAB "&#09;">
  <!ENTITY NL "&#10;">
]>

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
  <xsl:value-of select="@n"/>
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

<!--                               -->

</xsl:transform>

<!--
  vim:shiftwidth=2:tabstop=2
-->
