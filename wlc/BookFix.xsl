<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="1.0"
        xmlns="http://www.bibletechnologies.net/2003/OSIS/namespace"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:osis="http://www.bibletechnologies.net/2003/OSIS/namespace"
        xmlns:exslt="http://exslt.org/common"
        xmlns:date="http://exslt.org/dates-and-times"
        xmlns:func="http://exslt.org/functions"
        xmlns:mp24="http://my.own.org/namespace"
        extension-element-prefixes="date func mp24"
        exclude-result-prefixes="date func mp24">

<!--
  The 'bookId' global parameter is used to control the name of the external XML
  file that follows the pattern "fixes/{bookId}Fixes.xml".

  The default value for this parameter is designed to NOT match any .xml file,
  thus implicitly making this parameter mandatory to be defined during the
  run-time.
  -->

<xsl:param name="bookId" select="'UNKNOWN'"/>

<!--                               -->

<!-- <xsl:strip-space elements="*"/> -->          <!-- handling the formatting manually-->
<xsl:output method="xml" encoding="UTF-8"/>
<xsl:output omit-xml-declaration="no"/>
<xsl:output indent="yes"/>
<xsl:output encoding="UTF-8"/>

<!--                               -->

<xsl:variable name="fixes_xml" select="document(concat('fixes/', $bookId, 'Fixes.xml'))"/>
<xsl:variable name="fixes" select="exslt:node-set($fixes_xml)"/>

<!--                               -->

<xsl:template match="osis:osis/osis:osisText/osis:div/osis:chapter/osis:verse/osis:w/osis:seg">
  <xsl:value-of select="text()"/>
</xsl:template>

<!--                               -->

<xsl:template match="osis:osis/osis:osisText/osis:div/osis:chapter/osis:verse//osis:w[not(@type)]">
  <xsl:variable name="wid" select="@id"/>
  <xsl:variable name="fix" select="$fixes/fixes/fix-word-morph[@osisId = $wid]"/>
  <xsl:choose>
    <xsl:when test="$fix">
      <xsl:element name="w">
        <xsl:if test="count(@type) > 0">
          <xsl:message terminate="no">
            <xsl:text>ERROR: Unable to update 'type' for '</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>'.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:attribute name="type">
          <xsl:value-of select="'x-err-morph'"/>
        </xsl:attribute>
        <xsl:apply-templates select="@lemma|@n|@morph|@id"/>
        <xsl:value-of select="text()"/>
      </xsl:element>
      <xsl:element name="note">
        <xsl:attribute name="type">
          <xsl:value-of select="'x-fix-morph'"/>
        </xsl:attribute>
        <xsl:element name="catchWord">
          <xsl:value-of select="text()"/>
        </xsl:element>
        <xsl:value-of select="$fix/note/text()"/>
        <xsl:element name="w">
          <xsl:apply-templates select="@lemma|@n|@id"/>
          <xsl:attribute name="morph">
            <xsl:value-of select="$fix/morph/text()"/>
          </xsl:attribute>
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

</xsl:transform>

<!--
  vim:shiftwidth=2:tabstop=2
-->
