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

<xsl:variable name="isoLangCodeToOsisLanguageXml">
  <entry id="he">H</entry>
  <entry id="arc">A</entry>
  <entry id="el">G</entry>
</xsl:variable>
<xsl:variable name="isoLangCodeToOsisLanguage" select="common:node-set($isoLangCodeToOsisLanguageXml)"/>

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
  <xsl:apply-templates select="token"/>

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
    <xsl:value-of select="'WordSpeechType'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordHebrew'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordHebrewN'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordHebrewC'"/>
    <xsl:text>&TAB;</xsl:text>
    <xsl:value-of select="'WordHebrewParsed'"/>
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
    <xsl:text>&#10;</xsl:text>
  </common:document>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token">

  <xsl:variable name="tokenPathJewish">
    <xsl:value-of select="concat(../@bookPathJewish, '/', @versePathJewish)"/>
  </xsl:variable>
  <xsl:variable name="tokenPathChristian">
    <xsl:value-of select="concat(../@bookPathChristian, '/', @versePathChristian)"/>
  </xsl:variable>
  <xsl:variable name="wordId">
    <xsl:value-of select="generate-id(.)"/>
  </xsl:variable>
  <xsl:variable name="osisWordId">
    <xsl:value-of select="@osisWordId"/>
  </xsl:variable>
  <xsl:variable name="wordSpeechXml">
    <xsl:call-template name="tokenSpeech">
      <xsl:with-param name="osisWordId" select="$osisWordId"/>
      <xsl:with-param name="token" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="wordSpeech" select="common:node-set($wordSpeechXml)"/>
  <xsl:variable name="wordSpeechName" select="$wordSpeech/speech[1]/@name"/>
  <xsl:variable name="wordSpeechType" select="$wordSpeech/speech[1]/@type"/>
  <xsl:variable name="wordMorphLang">
    <xsl:value-of select="$isoLangCodeToOsisLanguage/entry[@id = current()/@lang]"/>
  </xsl:variable>
  <xsl:variable name="wordTextParts" select="./*/text()"/>
  <xsl:variable name="wordHebrewParsed">
    <xsl:value-of select="mp:string_join('׀', $wordTextParts)"/>
  </xsl:variable>
  <xsl:variable name="wordHebrew">
    <xsl:choose>
      <xsl:when test="$wordHebrewParsed != '׀'">
        <xsl:value-of select="translate($wordHebrewParsed, '׀', '')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$wordHebrewParsed"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordHebrewN">
    <xsl:value-of select="mp:strip_taamim($wordHebrew)"/>
  </xsl:variable>
  <xsl:variable name="wordHebrewC">
    <xsl:value-of select="mp:strip_pointing($wordHebrew)"/>
  </xsl:variable>
  <xsl:variable name="wordLemma">
    <xsl:value-of select="mp:string_join('|', */@lemma)"/>
  </xsl:variable>
  <xsl:variable name="wordMorph">
    <xsl:choose>
      <xsl:when test="$wordSpeechName = 'punctuation'">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($wordMorphLang, mp:string_join('|', */@morph))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordConjunctionParts" select="conjunction/text()"/>
  <xsl:variable name="wordConjunction">
    <xsl:value-of select="mp:string_join('׀', $wordConjunctionParts)"/>
  </xsl:variable>
  <xsl:variable name="wordPreposition">
    <xsl:value-of select="mp:string_join('׀', preposition/text())"/>
  </xsl:variable>
  <xsl:variable name="wordArticle">
    <xsl:choose>
      <xsl:when test="preposition[@type = 'definite article']">
        <xsl:value-of select="'הַ'"/>    <!-- TODO: generate according to the form -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="particle[@type = 'definite article']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordInterrogative">
    <xsl:value-of select="particle[@type = 'interrogative']"/>
  </xsl:variable>
  <xsl:variable name="wordParticle">
    <xsl:value-of select="particle[@type = 'relative']"/>
  </xsl:variable>
  <xsl:variable name="wordVerbBinyanim">
    <xsl:value-of select="verb/@stem"/>
  </xsl:variable>
  <xsl:variable name="wordState">
    <xsl:value-of select="verb/@state"/>
  </xsl:variable>
  <xsl:variable name="wordFormMain">
    <xsl:choose>
      <xsl:when test="contains($wordSpeechType, 'participle')">
        <xsl:value-of select="concat($wordSpeechType, ' ', $wordState)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$wordSpeechType"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordForm">
    <xsl:choose>
      <xsl:when test="conjunction and $wordSpeechName = 'verb' and not(contains($wordSpeechType, 'sequential'))">
        <xsl:value-of select="concat('conjunction-', $wordFormMain)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$wordFormMain"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="wordPerson">
    <xsl:value-of select="$wordSpeech/speech[1]/@person"/>
  </xsl:variable>
  <xsl:variable name="wordGender">
    <xsl:value-of select="$wordSpeech/speech[1]/@gender"/>
  </xsl:variable>
  <xsl:variable name="wordNumber">
    <xsl:value-of select="$wordSpeech/speech[1]/@number"/>
  </xsl:variable>
  <xsl:variable name="wordPgn">
    <xsl:value-of select="concat($personToPgn/entry[@id = $wordPerson], $genderToPgn/entry[@id = $wordGender], $numberToPgn/entry[@id = $wordNumber])"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixPronominal">
    <xsl:value-of select="suffix[@type = 'pronominal']"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixPronominalPerson">
    <xsl:value-of select="suffix[@type = 'pronominal']/@person"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixPronominalGender">
    <xsl:value-of select="suffix[@type = 'pronominal']/@gender"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixPronominalNumber">
    <xsl:value-of select="suffix[@type = 'pronominal']/@number"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixPronominalPgn">
    <xsl:value-of select="concat($personToPgn/entry[@id = $wordSuffixPronominalPerson], $genderToPgn/entry[@id = $wordSuffixPronominalGender], $numberToPgn/entry[@id = $wordSuffixPronominalNumber])"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixDirectionalHei">
    <xsl:value-of select="suffix[@type = 'directional he']/text()"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixParagogicHei">
    <xsl:value-of select="suffix[@type = 'paragogic he']/text()"/>
  </xsl:variable>
  <xsl:variable name="wordSuffixParagogicNun">
    <xsl:value-of select="suffix[@type = 'paragogic nun']/text()"/>
  </xsl:variable>

  <xsl:value-of select="$tokenPathJewish"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$tokenPathChristian"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordId"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$osisWordId"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordSpeech/speech[1]/@name"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordHebrew"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordHebrewN"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordHebrewC"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordHebrewParsed"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordLemma"/>
  <xsl:text>&TAB;</xsl:text>
  <xsl:value-of select="$wordMorph"/>
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

<func:function name="mp:speech_type">
  <xsl:param name="token"/>

  <func:result>
    <xsl:choose>

      <!-- core types -->

      <xsl:when test="$token/verb">
        <xsl:value-of select="$token/verb"/>
      </xsl:when>
      <xsl:when test="$token/noun">
        <xsl:value-of select="$token/noun"/>
      </xsl:when>
      <xsl:when test="$token/pronoun">
        <xsl:value-of select="$token/pronoun"/>
      </xsl:when>
      <xsl:when test="$token/adjective">
        <xsl:value-of select="$token/adjective"/>
      </xsl:when>
      <xsl:when test="$token/adverb">
        <xsl:value-of select="$token/adverb"/>
      </xsl:when>

      <!-- prefixes that can also be standalone -->

      <xsl:when test="$token/conjunction">
        <xsl:value-of select="$token/conjunction"/>
      </xsl:when>
      <xsl:when test="$token/preposition">
        <xsl:value-of select="$token/preposition"/>
      </xsl:when>
      <xsl:when test="$token/particle">
        <xsl:value-of select="$token/particle"/>
      </xsl:when>

      <!-- punctuation -->

      <xsl:when test="$token/sof_pasuq">
        <xsl:value-of select="$token/sof_pasuq"/>
      </xsl:when>
      <xsl:when test="$token/maqqaf">
        <xsl:value-of select="$token/maqqaf"/>
      </xsl:when>
      <xsl:when test="$token/paseiq">
        <xsl:value-of select="$token/paseiq"/>
      </xsl:when>
      <xsl:when test="$token/parasha_sssuma">
        <xsl:value-of select="$token/parasha_sssuma"/>
      </xsl:when>
      <xsl:when test="$token/parasha_pssuhha">
        <xsl:value-of select="$token/parasha_pssuhha"/>
      </xsl:when>
      <xsl:when test="$token/nun_hafukha">
        <xsl:value-of select="$token/nun_hafukha"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>ERROR: </xsl:text>
          <xsl:text>Unexpected speech type '</xsl:text>
          <xsl:value-of select="name($token/*)"/>
          <xsl:text>'</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </func:result>
</func:function>

<!--                               -->

<xsl:template name="tokenSpeech">
  <xsl:param name="osisWordId"/>
  <xsl:param name="token"/>

  <xsl:choose>

    <!-- core types -->

    <xsl:when test="$token/verb">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>verb</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/verb/@type"/></xsl:attribute>
        <xsl:attribute name="person"><xsl:value-of select="$token/verb/@person"/></xsl:attribute>
        <xsl:attribute name="gender"><xsl:value-of select="$token/verb/@gender"/></xsl:attribute>
        <xsl:attribute name="number"><xsl:value-of select="$token/verb/@number"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/noun">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>noun</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/noun/@type"/></xsl:attribute>
        <xsl:attribute name="person"><xsl:value-of select="$token/noun/@person"/></xsl:attribute>
        <xsl:attribute name="gender"><xsl:value-of select="$token/noun/@gender"/></xsl:attribute>
        <xsl:attribute name="number"><xsl:value-of select="$token/noun/@number"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/pronoun">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>pronoun</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/pronoun/@type"/></xsl:attribute>
        <xsl:attribute name="person"><xsl:value-of select="$token/pronoun/@person"/></xsl:attribute>
        <xsl:attribute name="gender"><xsl:value-of select="$token/pronoun/@gender"/></xsl:attribute>
        <xsl:attribute name="number"><xsl:value-of select="$token/pronoun/@number"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/adjective">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>adjective</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/adjective/@type"/></xsl:attribute>
        <xsl:attribute name="person"><xsl:value-of select="$token/adjective/@person"/></xsl:attribute>
        <xsl:attribute name="gender"><xsl:value-of select="$token/adjective/@gender"/></xsl:attribute>
        <xsl:attribute name="number"><xsl:value-of select="$token/adjective/@number"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/adverb">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>adverb</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/adverb/@type"/></xsl:attribute>
      </xsl:element>
    </xsl:when>

    <!-- prefixes that can also be standalone -->

    <xsl:when test="$token/conjunction">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>conjunction</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/conjunction/@type"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/preposition">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>preposition</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/preposition/@type"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/particle">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>particle</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/particle/@type"/></xsl:attribute>
      </xsl:element>
    </xsl:when>

    <!-- punctuation -->

    <xsl:when test="$token/punctuation">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>punctuation</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/punctuation/@type"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">
        <xsl:value-of select="concat('ERROR[', $osisWordId, ']: ')"/>
        <xsl:value-of select="concat('Unexpected speech type.')"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--                               -->

</xsl:transform>

<!--
  vim:shiftwidth=2:tabstop=2
-->
