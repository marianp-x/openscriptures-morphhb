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

<!--                               -->

<xsl:output method="xml" encoding="UTF-8"/>
<xsl:output omit-xml-declaration="no"/>
<xsl:output indent="yes"/>
<xsl:output encoding="UTF-8"/>
<xsl:strip-space elements="*"/>

<!--                               -->

<xsl:variable name="osisBookIdToNameChristianXml">
  <group>
    <name>Old Testament</name>
    <entry osisId="Gen">Genesis</entry>
    <entry osisId="Exod">Exodus</entry>
    <entry osisId="Lev">Leviticus</entry>
    <entry osisId="Num">Numbers</entry>
    <entry osisId="Deut">Deuteronomy</entry>
    <entry osisId="Josh">Joshua</entry>
    <entry osisId="Judg">Judges</entry>
    <entry osisId="Ruth">Ruth</entry>
    <entry osisId="1Sam">1 Samuel</entry>
    <entry osisId="2Sam">2 Samuel</entry>
    <entry osisId="1Kgs">1 Kings</entry>
    <entry osisId="2Kgs">1 Kings</entry>
    <entry osisId="1Chr">1 Chronicles</entry>
    <entry osisId="2Chr">2 Chronicles</entry>
    <entry osisId="Ezra">Ezra</entry>
    <entry osisId="Neh">Nehemiah</entry>
    <entry osisId="Esth">Esther</entry>
    <entry osisId="Job">Job</entry>
    <entry osisId="Ps">Psalms</entry>
    <entry osisId="Prov">Proverbs</entry>
    <entry osisId="Eccl">Ecclesiastes</entry>
    <entry osisId="Song">Song of Songs</entry>
    <entry osisId="Isa">Isaiah</entry>
    <entry osisId="Jer">Jeremiah</entry>
    <entry osisId="Lam">Lamentations</entry>
    <entry osisId="Ezek">Ezekiel</entry>
    <entry osisId="Dan">Daniel</entry>
    <entry osisId="Hos">Hosea</entry>
    <entry osisId="Joel">Joel</entry>
    <entry osisId="Amos">Amos</entry>
    <entry osisId="Obad">Obadiah</entry>
    <entry osisId="Jonah">Jonah</entry>
    <entry osisId="Mic">Micah</entry>
    <entry osisId="Nah">Nahum</entry>
    <entry osisId="Hab">Habakkuk</entry>
    <entry osisId="Zeph">Zephaniah</entry>
    <entry osisId="Hag">Haggai</entry>
    <entry osisId="Zech">Zechariah</entry>
    <entry osisId="Mal">Malachi</entry>
  </group>
</xsl:variable>
<xsl:variable name="osisBookIdToNameChristian" select="common:node-set($osisBookIdToNameChristianXml)"/>

<xsl:variable name="osisBookIdToNameJewishXml">
  <group>
    <name>תּוֹרָה</name>
    <entry osisId="Gen">בְּרֵאשִׁית</entry>
    <entry osisId="Exod">שְׁמֹות</entry>
    <entry osisId="Lev">וַיִּקְרָא</entry>
    <entry osisId="Num">בְּמִדְבַּר</entry>
    <entry osisId="Deut">דְּבָרִים</entry>
  </group>
  <group>
    <name>נְבִיאִים</name>
    <!-- נביאים ראשונים -->
    <entry osisId="Josh">יְהוֹשֻעַ</entry>
    <entry osisId="Judg">שֹׁפְטִים</entry>
    <entry osisId="1Sam">שְׁמוּאֵל א</entry>
    <entry osisId="2Sam">שְׁמוּאֵל ב</entry>
    <entry osisId="1Kgs">מְלָכִים א</entry>
    <entry osisId="2Kgs">מְלָכִים ב</entry>
    <!-- נביאים אחרונים -->
    <entry osisId="Isa">יְשַׁעְיָהוּ</entry>
    <entry osisId="Jer">יִרְמְיָהוּ</entry>
    <entry osisId="Ezek">יְחֶזְקֵאל</entry>
    <!-- תרי עשר -->
    <entry osisId="Hos">הוֹשֵׁעַ</entry>
    <entry osisId="Joel">יוֹאֵל</entry>
    <entry osisId="Amos">עָמוֹס</entry>
    <entry osisId="Obad">עֹבַדְיָה</entry>
    <entry osisId="Jonah">יוֹנָה</entry>
    <entry osisId="Mic">מִיכָה</entry>
    <entry osisId="Nah">נַחוּם</entry>
    <entry osisId="Hab">חֲבַקּוּק</entry>
    <entry osisId="Zeph">צְפַנְיָה</entry>
    <entry osisId="Hag">חַגַּי</entry>
    <entry osisId="Zech">זְכַרְיָה</entry>
    <entry osisId="Mal">מַלְאָכִי</entry>
  </group>
  <group>
    <name>כְּתוּבִים</name>
    <!-- סִפְרֵי אֶמֶת -->
    <entry osisId="Ps">תְהִלִּים</entry>
    <entry osisId="Prov">מִשְׁלֵי</entry>
    <entry osisId="Job">אִיּוֹב</entry>
    <!-- חמש מגילות -->
    <entry osisId="Song">שִׁיר הַשִּׁירִים</entry>
    <entry osisId="Ruth">רוּת</entry>
    <entry osisId="Lam">אֵיכָה</entry>
    <entry osisId="Eccl">קֹהֶלֶת</entry>
    <entry osisId="Esth">אֶסְתֵר</entry>
    <!-- -->
    <entry osisId="Dan">דָּנִיֵּאל</entry>
    <entry osisId="Ezra">עֶזְרָא</entry>
    <entry osisId="Neh">נְחֶמְיָה</entry>
    <entry osisId="1Chr">דִּבְרֵי הַיָּמִים א</entry>
    <entry osisId="2Chr">דִּבְרֵי הַיָּמִים ב</entry>
  </group>
</xsl:variable>
<xsl:variable name="osisBookIdToNameJewish" select="common:node-set($osisBookIdToNameJewishXml)"/>

<!--                               -->

<xsl:variable name="isoLangCodeToOsisLanguageXml">
  <entry id="he">H</entry>
  <entry id="arc">A</entry>
  <entry id="el">G</entry>
</xsl:variable>
<xsl:variable name="isoLangCodeToOsisLanguage" select="common:node-set($isoLangCodeToOsisLanguageXml)"/>

<xsl:variable name="personToPgnXml">
  <entry id="first">1</entry>
  <entry id="second">2</entry>
  <entry id="third">3</entry>
</xsl:variable>
<xsl:variable name="personToPgn" select="common:node-set($personToPgnXml)"/>

<xsl:variable name="genderToPgnXml">
  <entry id="both">*</entry>
  <entry id="common">*</entry>
  <entry id="feminine">f</entry>
  <entry id="masculine">m</entry>
</xsl:variable>
<xsl:variable name="genderToPgn" select="common:node-set($genderToPgnXml)"/>

<xsl:variable name="numberToPgnXml">
  <entry id="dual">d</entry>
  <entry id="plural">p</entry>
  <entry id="singular">s</entry>
</xsl:variable>
<xsl:variable name="numberToPgn" select="common:node-set($numberToPgnXml)"/>

<!--                               -->

<xsl:template match="/book">
  <xsl:element name="book">
    <xsl:copy-of select="@osisBookId"/>
    <xsl:attribute name="bookPathJewish">
      <xsl:value-of select="concat($osisBookIdToNameJewish/group/entry[@osisId = current()/@osisBookId]/../name, '/', $osisBookIdToNameJewish/group/entry[@osisId = current()/@osisBookId])"/>
    </xsl:attribute>
    <xsl:attribute name="bookPathChristian">
      <xsl:value-of select="concat($osisBookIdToNameChristian/group/entry[@osisId = current()/@osisBookId]/../name, '/', $osisBookIdToNameChristian/group/entry[@osisId = current()/@osisBookId])"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token[@lang = 'he']">
  <xsl:variable name="wordSpeechXml">
    <xsl:call-template name="tokenSpeech">
      <xsl:with-param name="osisWordId" select="@osisWordId"/>
      <xsl:with-param name="token" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="wordSpeech" select="common:node-set($wordSpeechXml)"/>
  <xsl:variable name="wordSpeechName" select="$wordSpeech/speech[1]/@name"/>
  <xsl:variable name="wordSpeechType" select="$wordSpeech/speech[1]/@type"/>

  <xsl:choose>
    <xsl:when test="$wordSpeechName = 'verb'">
      <xsl:element name="hebrew_word_verb">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$wordSpeechName = 'noun'">
      <xsl:element name="hebrew_word_noun">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$wordSpeechName = 'pronoun'">
      <xsl:element name="hebrew_word_pronoun">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$wordSpeechName = 'adjective'">
      <xsl:element name="hebrew_word_adjective">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$wordSpeechName = 'adverb'">
      <xsl:element name="hebrew_word_adverb">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$wordSpeechName = 'particle'">
      <xsl:element name="hebrew_word_particle">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$wordSpeechName = 'preposition'">
      <xsl:element name="hebrew_word_preposition">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$wordSpeechName = 'punctuation'">
      <xsl:element name="hebrew_punctuation">
        <xsl:copy-of select="@versePathJewish|@versePathChristian|@osisWordId"/>
        <xsl:attribute name="role">
          <xsl:value-of select="punctuation[1]/@type"/>
        </xsl:attribute>
        <xsl:value-of select="punctuation/text()"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/conjunction[../@lang = 'he']">
  <xsl:element name="hebrew_conjunction">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/preposition[../@lang = 'he' and @type = 'definite article']">
  <xsl:element name="hebrew_preposition_definite">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/preposition[../@lang = 'he' and not(@type)]">
  <xsl:element name="hebrew_preposition">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'affirmation']">
  <xsl:element name="hebrew_particle_affirmation">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'definite article']">
  <xsl:element name="hebrew_particle_definite_article">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'exhortation']">
  <xsl:element name="hebrew_particle_exhortation">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'interrogative']">
  <xsl:element name="hebrew_particle_interrogative">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'interjection']">
  <xsl:element name="hebrew_particle_interjection">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'demonstrative']">
  <xsl:element name="hebrew_particle_demonstrative">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'negative']">
  <xsl:element name="hebrew_particle_negative">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'direct object marker']">
  <xsl:element name="hebrew_particle_direct_object_marker">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/particle[../@lang = 'he' and @type = 'relative']">
  <xsl:element name="hebrew_particle_relative">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/noun[../@lang = 'he' and @type = 'common']">
  <xsl:element name="hebrew_noun">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="gn">
      <xsl:value-of select="concat($genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:attribute name="state">
      <xsl:value-of select="@state"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/noun[../@lang = 'he' and @type = 'gentilic']">
  <xsl:element name="hebrew_noun_gentilic">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/noun[../@lang = 'he' and @type = 'proper name']">
  <xsl:element name="hebrew_noun_proper">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/pronoun[../@lang = 'he' and @type = 'personal']">
  <xsl:element name="hebrew_pronoun_personal">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="pgn">
      <xsl:value-of select="concat($personToPgn/entry[@id = current()/@person], $genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/pronoun[../@lang = 'he' and @type = 'demonstrative']">
  <xsl:element name="hebrew_pronoun_demonstrative">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="gn">
      <xsl:value-of select="concat($genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/pronoun[../@lang = 'he' and @type = 'indefinite']">
  <xsl:element name="hebrew_pronoun_indefinite">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/adjective[../@lang = 'he' and @type = 'adjective']">
  <xsl:element name="hebrew_adjective">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="gn">
      <xsl:value-of select="concat($genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:attribute name="state">
      <xsl:value-of select="@state"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/adjective[../@lang = 'he' and @type = 'gentilic']">
  <xsl:element name="hebrew_adjective_gentilic">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="form">
      <xsl:value-of select="@type"/>
    </xsl:attribute>
    <xsl:attribute name="gn">
      <xsl:value-of select="concat($genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:attribute name="state">
      <xsl:value-of select="@state"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/adjective[../@lang = 'he' and contains(@type, 'number')]">
  <xsl:element name="hebrew_adjective_number">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="role">
      <xsl:choose>
        <xsl:when test="@type = 'cardinal number'">
          <xsl:value-of select="'cardinal'"/>
        </xsl:when>
        <xsl:when test="@type = 'ordinal number'">
          <xsl:value-of select="'ordinal'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>   <!-- TODO: Assert -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="gn">
      <xsl:value-of select="concat($genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:attribute name="state">
      <xsl:value-of select="@state"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/adverb[../@lang = 'he']">
  <xsl:element name="hebrew_adverb">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/verb[../@lang = 'he' and contains(@type, 'perfect')]">
  <xsl:element name="hebrew_verb_perfect">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="binyanim">
      <xsl:value-of select="@stem"/>
    </xsl:attribute>
    <xsl:if test="@type = 'sequential perfect'">
      <xsl:attribute name="role">
        <xsl:value-of select="'sequential'"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="pgn">
      <xsl:value-of select="concat($personToPgn/entry[@id = current()/@person], $genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/verb[../@lang = 'he' and contains(@type, 'imperfect')]">
  <xsl:element name="hebrew_verb_imperfect">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="binyanim">
      <xsl:value-of select="@stem"/>
    </xsl:attribute>
    <xsl:if test="@type = 'sequential imperfect'">
      <xsl:attribute name="role">
        <xsl:value-of select="'sequential'"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="pgn">
      <xsl:value-of select="concat($personToPgn/entry[@id = current()/@person], $genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/verb[../@lang = 'he' and @type = 'imperative']">
  <xsl:element name="hebrew_verb_imperative">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="binyanim">
      <xsl:value-of select="@stem"/>
    </xsl:attribute>
    <xsl:attribute name="pgn">
      <xsl:value-of select="concat($personToPgn/entry[@id = current()/@person], $genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/verb[../@lang = 'he' and @type = 'cohortative']">
  <xsl:element name="hebrew_verb_cohortative">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="binyanim">
      <xsl:value-of select="@stem"/>
    </xsl:attribute>
    <xsl:attribute name="pgn">
      <xsl:value-of select="concat($personToPgn/entry[@id = current()/@person], $genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/verb[../@lang = 'he' and @type = 'jussive']">
  <xsl:element name="hebrew_verb_jussive">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="binyanim">
      <xsl:value-of select="@stem"/>
    </xsl:attribute>
    <xsl:attribute name="pgn">
      <xsl:value-of select="concat($personToPgn/entry[@id = current()/@person], $genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/verb[../@lang = 'he' and contains(@type, 'participle')]">
  <xsl:element name="hebrew_verb_participal">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="binyanim">
      <xsl:value-of select="@stem"/>
    </xsl:attribute>
    <xsl:attribute name="role">
      <xsl:choose>
        <xsl:when test="@type = 'participle active'">
          <xsl:value-of select="'active'"/>
        </xsl:when>
        <xsl:when test="@type = 'participle passive'">
          <xsl:value-of select="'passive'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>   <!-- TODO: Assert -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="gn">
      <xsl:value-of select="concat($genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:if test="@state">
      <xsl:attribute name="state">
        <xsl:value-of select="@state"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/verb[../@lang = 'he' and contains(@type, 'infinitive')]">
  <xsl:element name="hebrew_verb_infinitive">
    <xsl:attribute name="lemma">
      <xsl:value-of select="@lemma"/>
    </xsl:attribute>
    <xsl:attribute name="binyanim">
      <xsl:value-of select="@stem"/>
    </xsl:attribute>
    <xsl:attribute name="state">
      <xsl:value-of select="@state"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/suffix[../@lang = 'he' and @type = 'pronominal']">
  <xsl:element name="hebrew_suffix_pronominal">
    <xsl:attribute name="pgn">
      <xsl:value-of select="concat($personToPgn/entry[@id = current()/@person], $genderToPgn/entry[@id = current()/@gender], $numberToPgn/entry[@id = current()/@number])"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/suffix[../@lang = 'he' and @type = 'directional he']">
  <xsl:element name="hebrew_suffix_directional_he">
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/suffix[../@lang = 'he' and @type = 'paragogic he']">
  <xsl:element name="hebrew_suffix_paragogic_he">
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/suffix[../@lang = 'he' and @type = 'paragogic nun']">
  <xsl:element name="hebrew_suffix_paragogic_nun">
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>

<!--                               -->

<xsl:template match="/book/token/punctuation[../@lang = 'he']">
  <xsl:element name="hebrew_punctuation">
    <xsl:attribute name="role">
      <xsl:value-of select="@type"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
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

    <xsl:when test="$token/particle[not(following-sibling::preposition) and not(following-sibling::conjunction)]">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>particle</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/particle/@type"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/preposition[not(following-sibling::conjunction)]">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>preposition</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/preposition/@type"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$token/*[name() = 'conjunction']">
      <xsl:element name="speech">
        <xsl:attribute name="name"><xsl:text>conjunction</xsl:text></xsl:attribute>
        <xsl:attribute name="type"><xsl:value-of select="$token/conjunction/@type"/></xsl:attribute>
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
