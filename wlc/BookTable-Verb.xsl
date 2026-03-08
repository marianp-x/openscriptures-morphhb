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

<xsl:variable name="languageToOsisLanguageCodeXml">
  <entry id="hebrew">H</entry>
  <entry id="aramaic">A</entry>
  <entry id="greek">G</entry>
</xsl:variable>
<xsl:variable name="languageToOsisLanguageCode" select="common:node-set($languageToOsisLanguageCodeXml)"/>

<xsl:variable name="personToPgnXml">
  <entry id="">*</entry>
  <entry id="1">1</entry>
  <entry id="2">2</entry>
  <entry id="3">3</entry>
</xsl:variable>
<xsl:variable name="personToPgn" select="common:node-set($personToPgnXml)"/>

<xsl:variable name="genderToPgnXml">
  <entry id="">*</entry>
  <entry id="both">*</entry>
  <entry id="common">*</entry>
  <entry id="feminine">f</entry>
  <entry id="masculine">m</entry>
</xsl:variable>
<xsl:variable name="genderToPgn" select="common:node-set($genderToPgnXml)"/>

<xsl:variable name="numberToPgnXml">
  <entry id="">*</entry>
  <entry id="dual">d</entry>
  <entry id="plural">p</entry>
  <entry id="singular">s</entry>
</xsl:variable>
<xsl:variable name="numberToPgn" select="common:node-set($numberToPgnXml)"/>

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
    <xsl:value-of select="'TokenType'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'Token'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'TokenN'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'TokenC'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'TokenParsed'"/>
    <xsl:text>&NL;</xsl:text>
  </common:document>
</xsl:template>

<!--                               -->

<xsl:template match="*[contains(name(), '_word_verb')]">

  <xsl:message terminate="no">
    <xsl:value-of select="concat('Verb(', position(), '):', name(.))"/>
  </xsl:message>

  <xsl:variable name="wordPathJewish">
    <xsl:value-of select="concat(../@bookPathJewish, '/', @versePathJewish)"/>
  </xsl:variable>
  <xsl:variable name="wordPathChristian">
    <xsl:value-of select="concat(../@bookPathChristian, '/', @versePathChristian)"/>
  </xsl:variable>
  <xsl:variable name="wordId">
    <!-- TODO: Generate in Word XML -->
  </xsl:variable>
  <xsl:variable name="osisWordId">
    <xsl:value-of select="@osisWordId"/>
  </xsl:variable>
  <xsl:variable name="wordName" select="name(.)"/>
  <xsl:variable name="language" select="substring-before($wordName, '_')"/>
  <xsl:variable name="word">
    <xsl:choose>
      <xsl:when test="contains($wordName, 'punctuation')">
        <xsl:value-of select="text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="mp:string_join('', */text())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordParsed">
    <xsl:value-of select="mp:string_join('׀', */text())"/>
  </xsl:variable>
  <xsl:variable name="wordN">
    <xsl:value-of select="mp:strip_taamim($word)"/>
  </xsl:variable>
  <xsl:variable name="wordC">
    <xsl:value-of select="mp:strip_pointing($word)"/>
  </xsl:variable>
  <xsl:variable name="wordLemma">
    <xsl:value-of select="mp:string_join('|', */@lemma)"/>
  </xsl:variable>
  <xsl:variable name="wordConjunction">
    <xsl:value-of select="mp:string_join('׀', conjunction/text())"/>
  </xsl:variable>
  <xsl:variable name="wordPreposition">
    <xsl:value-of select="mp:string_join('׀', preposition/text())"/>
  </xsl:variable>
  <xsl:variable name="wordArticle">
    <xsl:choose>
      <xsl:when test="$wordName = 'hebrew_preposition_definite'">
        <xsl:value-of select="'הַ'"/>    <!-- TODO: generate according to the form -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="mp:string_join('׀', hebrew_particle_definite_article/text())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordInterrogative">
    <xsl:value-of select="mp:string_join('׀', hebrew_particle_interrogative/text())"/>
  </xsl:variable>
  <xsl:variable name="wordParticle">
    <xsl:value-of select="mp:string_join('׀', hebrew_particle_relative/text())"/>
  </xsl:variable>
  <xsl:variable name="verbXml">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*[contains(name(), '_verb_')]"/>
    </xsl:copy>
  </xsl:variable>
  <xsl:variable name="verb" select="common:node-set($verbXml)"/>
  <xsl:variable name="verbName">
    <xsl:value-of select="name(*[contains(name(), '_verb_')])"/>
  </xsl:variable>
  <xsl:message terminate="no">
    <xsl:value-of select="concat('VerbName(', position(), '):', $verbName)"/>
  </xsl:message>
  <xsl:variable name="wordVerbBinyanim">
    <xsl:value-of select="$verb/@binyanim"/>
    <!--
    <xsl:value-of select="*[contains(name(), '_verb_')]/@binyanim"/>
     -->
  </xsl:variable>
  <xsl:variable name="wordFormMain">
    <xsl:choose>
      <xsl:when test="contains($verbName, 'perfect')">
        <xsl:value-of select="mp:string_join(' ', 'perfect', $verb/@role)"/>
      </xsl:when>
      <xsl:when test="contains($verbName, 'imperfect')">
        <xsl:value-of select="mp:string_join(' ', 'imperfect', $verb/@role)"/>
      </xsl:when>
      <xsl:when test="contains($verbName, 'imperative')">
        <xsl:value-of select="'imperative'"/>
      </xsl:when>
      <xsl:when test="contains($verbName, 'cohortative')">
        <xsl:value-of select="'cohortative'"/>
      </xsl:when>
      <xsl:when test="contains($verbName, 'jussive')">
        <xsl:value-of select="'jussive'"/>
      </xsl:when>
      <xsl:when test="contains($verbName, 'participle')">
        <xsl:value-of select="mp:string_join(' ', 'participle', $verb/@role)"/>
      </xsl:when>
      <xsl:when test="contains($verbName, 'infinitive')">
        <xsl:value-of select="'infinitive'"/>
      </xsl:when>
      <xsl:message terminate="yes">
        <xsl:text>ERROR: </xsl:text>
        <xsl:text>Unexpected verb form '</xsl:text>
        <xsl:value-of select="$wordName"/>
        <xsl:text>'</xsl:text>
      </xsl:message>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordForm">
    <xsl:choose>
      <xsl:when test="normalize-space($wordConjunction)">
        <xsl:value-of select="mp:string_join('-', 'conjuction', $wordFormMain)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$wordFormMain"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordPgn">
    <xsl:choose>
      <xsl:when test="normalize-space($verb/@pgn)">
        <xsl:value-of select="@pgn"/>
      </xsl:when>
      <xsl:when test="normalize-space($verb/@gn)">
        <xsl:value-of select="@gn"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordState">
    <xsl:value-of select="$verb/@state"/>
  </xsl:variable>
  <xsl:variable name="suffixPronominal">
    <xsl:value-of select="*[contains(name(), '_suffix_pronominal')]"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixPronominal">
    <xsl:value-of select="$suffixPronominal/text()"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixPronominalPgn">
    <xsl:value-of select="$suffixPronominal/@pgn"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixDirectionalHei">
    <xsl:value-of select="*[contains(name(), '_suffix_directional_he')]/text()"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixParagogicHei">
    <xsl:value-of select="*[contains(name(), '_suffix_paragogic_he')]/text()"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixParagogicNun">
    <xsl:value-of select="*[contains(name(), '_suffix_paragogic_nun')]/text()"/>
  </xsl:variable>

  <xsl:value-of select="$wordPathJewish"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordPathChristian"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordId"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$osisWordId"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$language"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordName"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$word"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordN"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordC"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordParsed"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordLemma"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordConjunction"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordPreposition"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordArticle"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordInterrogative"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordParticle"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordVerbBinyanim"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordForm"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordPgn"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordState"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordSuffixPronominal"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordSuffixPronominalPgn"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordSuffixDirectionalHei"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordSuffixParagogicHei"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordSuffixParagogicNun"/>
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
