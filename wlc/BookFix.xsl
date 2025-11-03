<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="1.0"
        xmlns="http://www.bibletechnologies.net/2003/OSIS/namespace"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:osis="http://www.bibletechnologies.net/2003/OSIS/namespace"
        xmlns:common="http://exslt.org/common"
        xmlns:func="http://exslt.org/functions"
        xmlns:mp="http://my.own.org/namespace"
        extension-element-prefixes="common func mp"
        exclude-result-prefixes="common func mp">

<!--
  The 'bookFixesXmlFname' global parameter is used to control the name of the
  external XML file.

  The default value for this parameter is designed to NOT match any .xml file,
  thus implicitly making this parameter mandatory to be defined during the
  run-time.
  -->

<xsl:param name="bookFixXmlFname" select="'UNKNOWN'"/>

<!--                               -->

<!-- <xsl:strip-space elements="*"/> -->          <!-- handling the formatting manually-->
<xsl:output method="xml" encoding="UTF-8"/>
<xsl:output omit-xml-declaration="no"/>
<xsl:output indent="yes"/>
<xsl:output encoding="UTF-8"/>

<!--                               -->

<xsl:variable name="osisBookId" select="osis:osis/osis:osisText/osis:div[@type = 'book' and position() = 1]/@osisID"/>

<!--                               -->

<xsl:variable name="bookFixesXml" select="document($bookFixXmlFname)"/>
<xsl:variable name="bookFixes" select="common:node-set($bookFixesXml)"/>

<!--                               -->

<xsl:template match="osis:osis/osis:osisText/osis:div/osis:chapter/osis:verse/osis:w/osis:seg">
  <xsl:value-of select="text()"/>
</xsl:template>

<!--                               -->

<xsl:template match="osis:osis/osis:osisText/osis:div/osis:chapter/osis:verse//osis:w[not(@type)]">
  <xsl:variable name="wid" select="@id"/>
  <xsl:variable name="fix" select="$bookFixes/fixes/fix-word[@osisId = $wid]"/>
  <xsl:choose>
    <xsl:when test="$fix">
      <xsl:element name="w">
        <xsl:attribute name="type">
          <xsl:value-of select="'x-err'"/>
        </xsl:attribute>
        <xsl:apply-templates select="@lemma|@n|@morph|@id"/>
        <xsl:value-of select="text()"/>
      </xsl:element>
      <xsl:element name="note">
        <xsl:attribute name="type">
          <xsl:value-of select="'x-fix'"/>
        </xsl:attribute>
        <xsl:element name="catchWord">
          <xsl:value-of select="text()"/>
        </xsl:element>
        <xsl:variable name="noteTextParts" select="$fix/*[contains(name(), 'note')]/text()"/>
        <xsl:value-of select="mp:string_join(' ', $noteTextParts)"/>
        <xsl:element name="w">
          <xsl:choose>
            <xsl:when test="normalize-space($fix/lemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$fix/lemma"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="@lemma"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="@n"/>
          <xsl:choose>
            <xsl:when test="normalize-space($fix/morph) != ''">
              <xsl:attribute name="morph">
                <xsl:value-of select="$fix/morph"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="@morph"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="@id"/>
          <xsl:value-of select="text()"/>
        </xsl:element>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!--                               -->

<!-- Identity template: copy all elements and their attributes -->
<xsl:template match="*|@*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

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
