<?xml version="1.0" encoding="UTF-8"?>

<xsl:transform version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:osis="http://www.bibletechnologies.net/2003/OSIS/namespace"
        xmlns:common="http://exslt.org/common"
        xmlns:str="http://exslt.org/strings"
        extension-element-prefixes="common str">

<!--                               -->

<xsl:output method="xml" encoding="UTF-8"/>
<xsl:output omit-xml-declaration="no"/>
<xsl:output indent="yes"/>
<xsl:output encoding="UTF-8"/>
<xsl:strip-space elements="*"/>

<xsl:key name="getToken" match="token" use="."/>

<!--                               -->

<xsl:variable name="osisBookId" select="osis:osis/osis:osisText/osis:div[@type = 'book' and position() = 1]/@osisID"/>

<xsl:variable name="osisBookIdToNameChristianXml">
  <entry groupName="Old Testament" osisId="Gen">Genesis</entry>
  <entry groupName="Old Testament" osisId="Exod">Exodus</entry>
  <entry groupName="Old Testament" osisId="Lev">Leviticus</entry>
  <entry groupName="Old Testament" osisId="Num">Numbers</entry>
  <entry groupName="Old Testament" osisId="Deut">Deuteronomy</entry>
  <entry groupName="Old Testament" osisId="Josh">Joshua</entry>
  <entry groupName="Old Testament" osisId="Judg">Judges</entry>
  <entry groupName="Old Testament" osisId="Ruth">Ruth</entry>
  <entry groupName="Old Testament" osisId="1Sam">1 Samuel</entry>
  <entry groupName="Old Testament" osisId="2Sam">2 Samuel</entry>
  <entry groupName="Old Testament" osisId="1Kgs">1 Kings</entry>
  <entry groupName="Old Testament" osisId="2Kgs">1 Kings</entry>
  <entry groupName="Old Testament" osisId="1Chr">1 Chronicles</entry>
  <entry groupName="Old Testament" osisId="2Chr">2 Chronicles</entry>
  <entry groupName="Old Testament" osisId="Ezra">Ezra</entry>
  <entry groupName="Old Testament" osisId="Neh">Nehemiah</entry>
  <entry groupName="Old Testament" osisId="Esth">Esther</entry>
  <entry groupName="Old Testament" osisId="Job">Job</entry>
  <entry groupName="Old Testament" osisId="Ps">Psalms</entry>
  <entry groupName="Old Testament" osisId="Prov">Proverbs</entry>
  <entry groupName="Old Testament" osisId="Eccl">Ecclesiastes</entry>
  <entry groupName="Old Testament" osisId="Song">Song of Songs</entry>
  <entry groupName="Old Testament" osisId="Isa">Isaiah</entry>
  <entry groupName="Old Testament" osisId="Jer">Jeremiah</entry>
  <entry groupName="Old Testament" osisId="Lam">Lamentations</entry>
  <entry groupName="Old Testament" osisId="Ezek">Ezekiel</entry>
  <entry groupName="Old Testament" osisId="Dan">Daniel</entry>
  <entry groupName="Old Testament" osisId="Hos">Hosea</entry>
  <entry groupName="Old Testament" osisId="Joel">Joel</entry>
  <entry groupName="Old Testament" osisId="Amos">Amos</entry>
  <entry groupName="Old Testament" osisId="Obad">Obadiah</entry>
  <entry groupName="Old Testament" osisId="Jonah">Jonah</entry>
  <entry groupName="Old Testament" osisId="Mic">Micah</entry>
  <entry groupName="Old Testament" osisId="Nah">Nahum</entry>
  <entry groupName="Old Testament" osisId="Hab">Habakkuk</entry>
  <entry groupName="Old Testament" osisId="Zeph">Zephaniah</entry>
  <entry groupName="Old Testament" osisId="Hag">Haggai</entry>
  <entry groupName="Old Testament" osisId="Zech">Zechariah</entry>
  <entry groupName="Old Testament" osisId="Mal">Malachi</entry>
</xsl:variable>
<xsl:variable name="osisBookIdToNameChristian" select="common:node-set($osisBookIdToNameChristianXml)"/>

<xsl:variable name="osisBookIdToNameJewishXml">
  <entry groupName="תורה"   osisId="Gen">בראשית</entry>
  <entry groupName="תורה"   osisId="Exod">שמות</entry>
  <entry groupName="תורה"   osisId="Lev">ויקרא</entry>
  <entry groupName="תורה"   osisId="Num">במדבר</entry>
  <entry groupName="תורה"   osisId="Deut">דברים</entry>
  <entry groupName="נביאים" osisId="Josh">יהושע</entry>
  <entry groupName="נביאים" osisId="Judg">שופטים</entry>
  <entry groupName="נביאים" osisId="1Sam">שמואל א</entry>
  <entry groupName="נביאים" osisId="2Sam">שמואל ב</entry>
  <entry groupName="נביאים" osisId="1Kgs">מלכים א</entry>
  <entry groupName="נביאים" osisId="2Kgs">מלכים ב</entry>
  <entry groupName="נביאים" osisId="Isa">ישעיהו</entry>
  <entry groupName="נביאים" osisId="Jer">ירמיהו</entry>
  <entry groupName="נביאים" osisId="Ezek">יחזקאל</entry>
  <entry groupName="נביאים" osisId="Hos">הושע</entry>
  <entry groupName="נביאים" osisId="Joel">יואל</entry>
  <entry groupName="נביאים" osisId="Amos">עמוס</entry>
  <entry groupName="נביאים" osisId="Obad">עובדיה</entry>
  <entry groupName="נביאים" osisId="Jonah">יונה</entry>
  <entry groupName="נביאים" osisId="Mic">מיכה</entry>
  <entry groupName="נביאים" osisId="Nah">נחום</entry>
  <entry groupName="נביאים" osisId="Hab">חבקוק</entry>
  <entry groupName="נביאים" osisId="Zeph">צפניה</entry>
  <entry groupName="נביאים" osisId="Hag">חגי</entry>
  <entry groupName="נביאים" osisId="Zech">זכריה</entry>
  <entry groupName="נביאים" osisId="Mal">מלאכי</entry>
  <entry groupName="כתובים" osisId="Ps">תהילים</entry>
  <entry groupName="כתובים" osisId="Prov">משלי</entry>
  <entry groupName="כתובים" osisId="Job">איוב</entry>
  <entry groupName="כתובים" osisId="Song">שיר השירים</entry>
  <entry groupName="כתובים" osisId="Ruth">רות</entry>
  <entry groupName="כתובים" osisId="Lam">איכה</entry>
  <entry groupName="כתובים" osisId="Eccl">קהלת</entry>
  <entry groupName="כתובים" osisId="Esth">אסתר</entry>
  <entry groupName="כתובים" osisId="Dan">דניאל</entry>
  <entry groupName="כתובים" osisId="Ezra">עזרא</entry>
  <entry groupName="כתובים" osisId="Neh">נחמיה</entry>
  <entry groupName="כתובים" osisId="1Chr">דברי הימים א</entry>
  <entry groupName="כתובים" osisId="2Chr">דברי הימים ב</entry>
</xsl:variable>
<xsl:variable name="osisBookIdToNameJewish" select="common:node-set($osisBookIdToNameJewishXml)"/>

<xsl:variable name="osisLanguageToIsoCodeXml">
  <entry id="H">he</entry>
  <entry id="A">arc</entry>
  <entry id="G">el</entry>
</xsl:variable>
<xsl:variable name="osisLanguageToIsoCode" select="common:node-set($osisLanguageToIsoCodeXml)"/>

<xsl:variable name="osisVerbStemsHebrewXml">
  <entry lang="he" id="q">qal</entry>
  <entry lang="he" id="N">niphal</entry>
  <entry lang="he" id="p">piel</entry>
  <entry lang="he" id="P">pual</entry>
  <entry lang="he" id="h">hiphil</entry>
  <entry lang="he" id="H">hophal</entry>
  <entry lang="he" id="t">hithpael</entry>
  <entry lang="he" id="o">polel</entry>
  <entry lang="he" id="O">polal</entry>
  <entry lang="he" id="r">hithpolel</entry>
  <entry lang="he" id="m">poel</entry>
  <entry lang="he" id="M">poal</entry>
  <entry lang="he" id="k">palel</entry>
  <entry lang="he" id="K">pulal</entry>
  <entry lang="he" id="Q">qal passive</entry>
  <entry lang="he" id="l">pilpel</entry>
  <entry lang="he" id="L">polpal</entry>
  <entry lang="he" id="f">hithpalpel</entry>
  <entry lang="he" id="D">nithpael</entry>
  <entry lang="he" id="j">pealal</entry>
  <entry lang="he" id="i">pilel</entry>
  <entry lang="he" id="u">hothpaal</entry>
  <entry lang="he" id="c">tiphil</entry>
  <entry lang="he" id="v">hishtaphel</entry>
  <entry lang="he" id="w">nithpalel</entry>
  <entry lang="he" id="y">nithpoel</entry>
  <entry lang="he" id="z">hithpoel</entry>
</xsl:variable>
<xsl:variable name="osisVerbStemsHebrew" select="common:node-set($osisVerbStemsHebrewXml)"/>

<xsl:variable name="osisVerbStemsAramaicXml">
  <entry lang="arc" id="q">peal</entry>
  <entry lang="arc" id="Q">peil</entry>
  <entry lang="arc" id="u">hithpeel</entry>
  <entry lang="arc" id="p">pael</entry>
  <entry lang="arc" id="P">ithpaal</entry>
  <entry lang="arc" id="M">hithpaal</entry>
  <entry lang="arc" id="a">aphel</entry>
  <entry lang="arc" id="h">haphel</entry>
  <entry lang="arc" id="s">saphel</entry>
  <entry lang="arc" id="e">shaphel</entry>
  <entry lang="arc" id="H">hophal</entry>
  <entry lang="arc" id="i">ithpeel</entry>
  <entry lang="arc" id="t">hishtaphel</entry>
  <entry lang="arc" id="v">ishtaphel</entry>
  <entry lang="arc" id="w">hithaphel</entry>
  <entry lang="arc" id="o">polel</entry>
  <entry lang="arc" id="z">ithpoel</entry>
  <entry lang="arc" id="r">hithpolel</entry>
  <entry lang="arc" id="f">hithpalpel</entry>
  <entry lang="arc" id="b">hephal</entry>
  <entry lang="arc" id="c">tiphel</entry>
  <entry lang="arc" id="m">poel</entry>
  <entry lang="arc" id="l">palpel</entry>
  <entry lang="arc" id="L">ithpalpel</entry>
  <entry lang="arc" id="O">ithpolel</entry>
  <entry lang="arc" id="G">ittaphal</entry>
</xsl:variable>
<xsl:variable name="osisVerbStemsAramaic" select="common:node-set($osisVerbStemsAramaicXml)"/>

<xsl:variable name="osisVerbConjugationTypesXml">
  <entry id="p">perfect</entry>
  <entry id="q">sequential perfect</entry>
  <entry id="i">imperfect</entry>
  <entry id="w">sequential imperfect</entry>
  <entry id="h">cohortative</entry>
  <entry id="j">jussive</entry>
  <entry id="v">imperative</entry>
  <entry id="r">participle active</entry>
  <entry id="s">participle passive</entry>
  <entry id="a">infinitive absolute</entry>
  <entry id="c">infinitive construct</entry>
</xsl:variable>
<xsl:variable name="osisVerbConjugationTypes" select="common:node-set($osisVerbConjugationTypesXml)"/>

<xsl:variable name="osisPronounTypesXml">
  <entry id="d">demonstrative</entry>
  <entry id="f">indefinite</entry>
  <entry id="i">interrogative</entry>
  <entry id="p">personal</entry>
  <entry id="r">relative</entry>
</xsl:variable>
<xsl:variable name="osisPronounTypes" select="common:node-set($osisPronounTypesXml)"/>

<xsl:variable name="osisNounTypesXml">
  <entry id="c">common</entry>
  <entry id="g">gentilic</entry>
  <entry id="p">proper name</entry>
  <entry id="x"></entry>
</xsl:variable>
<xsl:variable name="osisNounTypes" select="common:node-set($osisNounTypesXml)"/>

<xsl:variable name="osisNounGendersXml">
  <entry id="b">both</entry>
  <entry id="f">feminine</entry>
  <entry id="m">masculine</entry>
</xsl:variable>
<xsl:variable name="osisNounGenders" select="common:node-set($osisNounGendersXml)"/>

<xsl:variable name="osisVerbGendersXml">
  <entry id="c">common</entry>
  <entry id="f">feminine</entry>
  <entry id="m">masculine</entry>
</xsl:variable>
<xsl:variable name="osisVerbGenders" select="common:node-set($osisVerbGendersXml)"/>

<xsl:variable name="osisNumbersXml">
  <entry id="d">dual</entry>
  <entry id="p">plural</entry>
  <entry id="s">singular</entry>
</xsl:variable>
<xsl:variable name="osisNumbers" select="common:node-set($osisNumbersXml)"/>

<xsl:variable name="osisStatesHebrewXml">
  <entry id="a">absolute</entry>
  <entry id="c">construct</entry>
</xsl:variable>
<xsl:variable name="osisStatesHebrew" select="common:node-set($osisStatesHebrewXml)"/>

<xsl:variable name="osisStatesAramaicXml">
  <entry id="a">absolute</entry>
  <entry id="c">construct</entry>
  <entry id="d">determined</entry>
</xsl:variable>
<xsl:variable name="osisStatesAramaic" select="common:node-set($osisStatesAramaicXml)"/>

<xsl:variable name="osisAdjectiveTypesXml">
  <entry id="a">adjective</entry>
  <entry id="c">cardinal number</entry>
  <entry id="g">gentilic</entry>
  <entry id="o">ordinal number</entry>
</xsl:variable>
<xsl:variable name="osisAdjectiveTypes" select="common:node-set($osisAdjectiveTypesXml)"/>

<xsl:variable name="osisParticleTypesXml">
  <entry id="a">affirmation</entry>
  <entry id="d">definite article</entry>
  <entry id="e">exhortation</entry>
  <entry id="i">interrogative</entry>
  <entry id="j">interjection</entry>
  <entry id="m">demonstrative</entry>
  <entry id="n">negative</entry>
  <entry id="o">direct object marker</entry>
  <entry id="r">relative</entry>
</xsl:variable>
<xsl:variable name="osisParticleTypes" select="common:node-set($osisParticleTypesXml)"/>

<xsl:variable name="osisPrepositionTypesXml">
  <entry id="d">definite article</entry>
</xsl:variable>
<xsl:variable name="osisPrepositionTypes" select="common:node-set($osisPrepositionTypesXml)"/>

<!--                               -->

<xsl:template match="/">

  <xsl:element name="book">
    <xsl:attribute name="osisBookId">
      <xsl:value-of select="$osisBookId"/>
    </xsl:attribute>
    <xsl:attribute name="bookPathJewish">
      <xsl:value-of select="concat($osisBookIdToNameJewish/entry[@osisId = $osisBookId]/@groupName, '/', $osisBookIdToNameJewish/entry[@osisId = $osisBookId])"/>
    </xsl:attribute>
    <xsl:attribute name="bookPathChristian">
      <xsl:value-of select="concat($osisBookIdToNameChristian/entry[@osisId = $osisBookId]/@groupName, '/', $osisBookIdToNameChristian/entry[@osisId = $osisBookId])"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>

</xsl:template>

<!--                               -->

<xsl:template match="osis:w[not(@type)]">

  <xsl:element name="token">
    <xsl:variable name="lang" select="substring(@morph, 1, 1)"/>
    <xsl:variable name="langIsoCode" select="$osisLanguageToIsoCode/entry[@id = $lang]"/>

    <xsl:attribute name="versePathJewish">
      <xsl:call-template name="getVersePathJewish">
        <xsl:with-param name="token" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="versePathChristian">
      <xsl:call-template name="getVersePathKjv">
        <xsl:with-param name="token" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="lang">
      <xsl:value-of select="$langIsoCode"/>
    </xsl:attribute>
    <xsl:variable name="osisWordId" select="@id"/>
    <xsl:attribute name="osisWordId">
      <xsl:value-of select="$osisWordId"/>
    </xsl:attribute>
    <xsl:attribute name="lemma">
      <xsl:value-of select="translate(@lemma, '/', '|')"/>
    </xsl:attribute>
    <xsl:attribute name="morph">
      <xsl:value-of select="translate(@morph, '/', '|')"/>
    </xsl:attribute>

    <xsl:variable name="morph" select="substring(@morph, 2)"/>
    <xsl:variable name="morphSet" select="str:tokenize($morph, '/')"/>

    <xsl:variable name="lemmaSet" select="str:tokenize(@lemma, '/')"/>

    <xsl:variable name="accentOverride" select="following-sibling::*[position() = 1 and name() = 'note' and @type = 'alternative']/osis:rdg[@type = 'x-accent']"/>
    <xsl:variable name="word">
      <xsl:choose>
        <xsl:when test="not($accentOverride)">
          <xsl:apply-templates mode="within-word"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$accentOverride/text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="str:tokenize($word, '/')">
      <xsl:variable name="num">
        <xsl:value-of select="position()"/>
      </xsl:variable>
      <xsl:variable name="wordPartLemma">
        <xsl:value-of select="$lemmaSet[position() = $num]"/>
      </xsl:variable>
      <xsl:variable name="wordPartMorph">
        <xsl:value-of select="$morphSet[position() = $num]"/>
      </xsl:variable>
      <xsl:variable name="wordPartMorphType">
        <xsl:value-of select="substring($wordPartMorph, 1, 1)"/>
      </xsl:variable>
      <xsl:variable name="wordPartMorphDetails">
        <xsl:value-of select="substring($wordPartMorph, 2)"/>
      </xsl:variable>

      <xsl:choose>

        <xsl:when test="$wordPartMorphType = 'A'">
          <xsl:element name="adjective">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="morph">
              <xsl:value-of select="$wordPartMorph"/>
            </xsl:attribute>
            <xsl:variable name="type_tag" select="substring($wordPartMorphDetails, 1, 1)"/>
            <xsl:variable name="type" select="$osisAdjectiveTypes/entry[@id = $type_tag]"/>
            <xsl:if test="normalize-space($type) != ''">
              <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="attributesFromPgn">
              <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 2)"/>
              <xsl:with-param name="type" select="'simple-noun'"/>
            </xsl:call-template>
            <xsl:call-template name="attributesFromState">
              <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 1)"/>
              <xsl:with-param name="type" select="'simple-noun'"/>
              <xsl:with-param name="langIsoCode" select="$langIsoCode"/>
            </xsl:call-template>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'C'">
          <xsl:element name="conjunction">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="morph">
              <xsl:value-of select="$wordPartMorph"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'D'">
          <xsl:element name="adverb">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="morph">
              <xsl:value-of select="$wordPartMorph"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'N'">
          <xsl:element name="noun">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="morph">
              <xsl:value-of select="$wordPartMorph"/>
            </xsl:attribute>
            <xsl:variable name="type_tag" select="substring($wordPartMorphDetails, 1, 1)"/>
            <xsl:variable name="type" select="$osisNounTypes/entry[@id = $type_tag]"/>
            <xsl:if test="normalize-space($type) != ''">
              <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="normalize-space($type) != 'proper name'">
              <xsl:call-template name="attributesFromPgn">
                <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 2)"/>
                <xsl:with-param name="type" select="'simple-noun'"/>
              </xsl:call-template>
              <xsl:call-template name="attributesFromState">
                <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 1)"/>
                <xsl:with-param name="type" select="'simple-noun'"/>
                <xsl:with-param name="langIsoCode" select="$langIsoCode"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'P'">
          <xsl:element name="pronoun">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="morph">
              <xsl:value-of select="$wordPartMorph"/>
            </xsl:attribute>
            <xsl:variable name="type_tag" select="substring($wordPartMorphDetails, 1, 1)"/>
            <xsl:variable name="type" select="$osisPronounTypes/entry[@id = $type_tag]"/>
            <xsl:if test="normalize-space($type) != ''">
              <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="attributesFromPgn">
              <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 2)"/>
              <xsl:with-param name="type" select="$type"/>
            </xsl:call-template>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'R'">
          <xsl:element name="preposition">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="morph">
              <xsl:value-of select="$wordPartMorph"/>
            </xsl:attribute>
            <xsl:variable name="type_tag" select="substring($wordPartMorphDetails, 1, 1)"/>
            <xsl:variable name="type" select="$osisPrepositionTypes/entry[@id = $type_tag]"/>
            <xsl:if test="normalize-space($type) != ''">
              <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'S'">
          <xsl:variable name="suffixType">
            <xsl:value-of select="substring($wordPartMorphDetails, 1, 1)"/>
          </xsl:variable>
          <xsl:element name="suffix">
            <xsl:choose>
              <xsl:when test="$suffixType = 'p'">
                <xsl:if test="normalize-space($wordPartLemma) != ''">
                  <xsl:attribute name="lemma">
                    <xsl:value-of select="$wordPartLemma"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="morph">
                  <xsl:value-of select="$wordPartMorph"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                  <xsl:value-of select="'pronominal'"/>
                </xsl:attribute>
                <xsl:call-template name="attributesFromPgn">
                  <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 2)"/>
                  <xsl:with-param name="type" select="''"/>
                </xsl:call-template>
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:when test="$suffixType = 'd'">
                <xsl:if test="normalize-space($wordPartLemma) != ''">
                  <xsl:attribute name="lemma">
                    <xsl:value-of select="$wordPartLemma"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="morph">
                  <xsl:value-of select="$wordPartMorph"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                  <xsl:value-of select="'directional he'"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:when test="$suffixType = 'h'">
                <xsl:if test="normalize-space($wordPartLemma) != ''">
                  <xsl:attribute name="lemma">
                    <xsl:value-of select="$wordPartLemma"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="morph">
                  <xsl:value-of select="$wordPartMorph"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                  <xsl:value-of select="'paragogic he'"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:when test="$suffixType = 'n'">
                <xsl:if test="normalize-space($wordPartLemma) != ''">
                  <xsl:attribute name="lemma">
                    <xsl:value-of select="$wordPartLemma"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="morph">
                  <xsl:value-of select="$wordPartMorph"/>
                </xsl:attribute>
                  <xsl:attribute name="type">
                    <xsl:value-of select="'paragogic nun'"/>
                  </xsl:attribute>
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="yes">
                  <xsl:value-of select="concat('ERROR[', $osisWordId, ']: ')"/>
                  <xsl:value-of select="concat('Unexpected suffix type &quot;', $suffixType, '&quot;')"/>
                </xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'T'">
          <xsl:variable name="type_tag" select="substring($wordPartMorphDetails, 1, 1)"/>
          <xsl:variable name="type" select="$osisParticleTypes/entry[@id = $type_tag]"/>
          <xsl:element name="particle">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="morph">
              <xsl:value-of select="$wordPartMorph"/>
            </xsl:attribute>
            <xsl:if test="normalize-space($type) != ''">
              <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:when>

        <xsl:when test="$wordPartMorphType = 'V'">

          <xsl:element name="verb">
            <xsl:if test="normalize-space($wordPartLemma) != ''">
              <xsl:attribute name="lemma">
                <xsl:value-of select="$wordPartLemma"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="normalize-space($wordPartMorphDetails) != ''">
              <xsl:attribute name="morph">
                <xsl:value-of select="$wordPartMorph"/>
              </xsl:attribute>

              <xsl:variable name="stem_tag" select="substring($wordPartMorphDetails, 1, 1)"/>
              <xsl:choose>
                <xsl:when test="$langIsoCode = 'he'">
                  <xsl:variable name="stem" select="$osisVerbStemsHebrew/entry[@lang = $langIsoCode and @id = $stem_tag]"/>
                  <xsl:attribute name="stem">
                    <xsl:value-of select="$stem"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:when test="$langIsoCode = 'arc'">
                  <xsl:variable name="stem" select="$osisVerbStemsAramaic/entry[@lang = $langIsoCode and @id = $stem_tag]"/>
                  <xsl:attribute name="stem">
                    <xsl:value-of select="$stem"/>
                  </xsl:attribute>
                </xsl:when>
              </xsl:choose>

              <xsl:variable name="type_tag" select="substring($wordPartMorphDetails, 2, 1)"/>
              <xsl:variable name="type" select="$osisVerbConjugationTypes/entry[@id = $type_tag]"/>
              <xsl:attribute name="type">
                <xsl:value-of select="$type"/>
              </xsl:attribute>

              <xsl:call-template name="attributesFromPgn">
                <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 3)"/>
                <xsl:with-param name="type" select="$type"/>
              </xsl:call-template>

              <xsl:call-template name="attributesFromState">
                <xsl:with-param name="morph" select="substring($wordPartMorphDetails, 2)"/>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="langIsoCode" select="$langIsoCode"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:element>

        </xsl:when>
        <xsl:otherwise>

          <xsl:message terminate="yes">
            <xsl:value-of select="concat('ERROR[', $osisWordId, ']: ')"/>
            <xsl:value-of select="concat('Unexpected wordPartMorphType(', $wordPartMorphType, ')')"/>
          </xsl:message>

        </xsl:otherwise>
      </xsl:choose>

    </xsl:for-each>

  </xsl:element>

</xsl:template>

<!--                               -->

<xsl:template match="osis:seg" mode="within-word">

  <xsl:choose>
    <xsl:when test="@type = 'x-large' or @type = 'x-small' or @type = 'x-suspended'">
      <xsl:value-of select="text()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">
        <xsl:value-of select="concat('ERROR: Unexpected seg/@type(', @type, ')')"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!--                               -->

<xsl:template match="osis:w/text()" mode="within-word">

  <xsl:value-of select="."/>

</xsl:template>

<!--                               -->

<xsl:template match="osis:seg[not(@subType)]">
  <xsl:element name="token">
    <xsl:attribute name="versePathJewish">
      <xsl:call-template name="getVersePathJewish">
        <xsl:with-param name="token" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="versePathChristian">
      <xsl:call-template name="getVersePathKjv">
        <xsl:with-param name="token" select="."/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="lang">
      <xsl:value-of select="'he'"/>
    </xsl:attribute>

    <xsl:element name="punctuation">
      <xsl:choose>
        <xsl:when test="@type = 'x-sof-pasuq'">
          <xsl:attribute name="type"><xsl:text>sof pasuq</xsl:text></xsl:attribute>
        </xsl:when>
        <xsl:when test="@type = 'x-maqqef'">
          <xsl:attribute name="type"><xsl:text>maqqef</xsl:text></xsl:attribute>
        </xsl:when>
        <xsl:when test="@type = 'x-paseq'">
          <xsl:attribute name="type"><xsl:text>paseq</xsl:text></xsl:attribute>
        </xsl:when>
        <xsl:when test="@type = 'x-samekh'">
          <xsl:attribute name="type"><xsl:text>samekh</xsl:text></xsl:attribute>
        </xsl:when>
        <xsl:when test="@type = 'x-pe'">
          <xsl:attribute name="type"><xsl:text>pe</xsl:text></xsl:attribute>
        </xsl:when>
        <xsl:when test="@type = 'x-reversednun'">
          <xsl:attribute name="type"><xsl:text>reversed nun</xsl:text></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">
            <xsl:value-of select="concat('ERROR: Unexpected seg/@type(', @type, ')')"/>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="text()"/>
    </xsl:element>

  </xsl:element>

</xsl:template>

<!--                               -->

<xsl:template name="getVersePathJewish">
  <xsl:param name="token"/>

  <xsl:variable name="verseIdJew">
    <xsl:value-of select="$token/ancestor::osis:verse/@osisID"/>
  </xsl:variable>
  <xsl:variable name="chapterNumJew">
    <xsl:value-of select="substring-before(substring-after($verseIdJew, '.'), '.')"/>
  </xsl:variable>
  <xsl:variable name="verseNumJew">
    <xsl:value-of select="substring-after(substring-after($verseIdJew, '.'), '.')"/>
  </xsl:variable>

  <xsl:value-of select="concat($chapterNumJew, '/', $verseNumJew)"/>

</xsl:template>

<!--                               -->

<xsl:template name="getVersePathKjv">
  <xsl:param name="token"/>

  <xsl:variable name="verseIdJew">
    <xsl:value-of select="$token/ancestor::osis:verse/@osisID"/>
  </xsl:variable>
  <xsl:variable name="chapterNumJew">
    <xsl:value-of select="substring-before(substring-after($verseIdJew, '.'), '.')"/>
  </xsl:variable>
  <xsl:variable name="verseNumJew">
    <xsl:value-of select="substring-after(substring-after($verseIdJew, '.'), '.')"/>
  </xsl:variable>

  <xsl:variable name="verseIdKjv">
    <xsl:value-of select="substring-after(ancestor::osis:verse/osis:note/text(), 'KJV:')"/>
  </xsl:variable>
  <xsl:variable name="chapterNumKjv">
    <xsl:choose>
      <xsl:when test="$verseIdKjv = ''">
        <xsl:value-of select="$chapterNumJew"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before(substring-after($verseIdKjv, '.'), '.')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="verseNumKjv">
    <xsl:choose>
      <xsl:when test="$verseIdKjv = ''">
        <xsl:value-of select="$verseNumJew"/>
      </xsl:when>
      <xsl:when test="contains($verseIdKjv, '!')">
        <xsl:value-of select="substring-before(substring-after(substring-after($verseIdKjv, '.'), '.'), '!')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after(substring-after($verseIdKjv, '.'), '.')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="concat($chapterNumKjv, '/', $verseNumKjv)"/>

</xsl:template>

<!--                               -->

<xsl:template name="attributesFromPgn">
  <xsl:param name="morph"/>
  <xsl:param name="type"/>

  <xsl:variable name="person_tag">
    <xsl:choose>
      <xsl:when test="$type = 'simple-noun' or starts-with($type, 'participle')">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:when test="starts-with($type, 'infinitive')">
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($morph, 1, 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="person" select="$person_tag"/>
  <xsl:if test="normalize-space($person) != '' and normalize-space($person) != 'x'">
    <xsl:attribute name="person">
      <xsl:value-of select="$person"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:variable name="gender_tag">
    <xsl:choose>
      <xsl:when test="$type = 'simple-noun' or starts-with($type, 'participle')">
        <xsl:value-of select="substring($morph, 1, 1)"/>
      </xsl:when>
      <xsl:when test="starts-with($type, 'infinitive')">
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($morph, 2, 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="gender">
    <xsl:choose>
      <xsl:when test="$type = 'simple-noun'">
        <xsl:value-of select="$osisNounGenders/entry[@id = $gender_tag]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$osisVerbGenders/entry[@id = $gender_tag]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="normalize-space($gender) != ''">
    <xsl:attribute name="gender">
      <xsl:value-of select="$gender"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:variable name="number_tag">
    <xsl:choose>
      <xsl:when test="$type = 'simple-noun' or starts-with($type, 'participle')">
        <xsl:value-of select="substring($morph, 2, 1)"/>
      </xsl:when>
      <xsl:when test="starts-with($type, 'infinitive')">
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($morph, 3, 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="number" select="$osisNumbers/entry[@id = $number_tag]"/>
  <xsl:if test="normalize-space($number) != ''">
    <xsl:attribute name="number">
      <xsl:value-of select="$number"/>
    </xsl:attribute>
  </xsl:if>

</xsl:template>

<!--                               -->

<xsl:template name="attributesFromState">
  <xsl:param name="morph"/>
  <xsl:param name="type"/>
  <xsl:param name="langIsoCode"/>

  <xsl:variable name="state_tag">
    <xsl:choose>
      <xsl:when test="$type = 'simple-noun' or starts-with($type, 'participle')">
        <xsl:value-of select="substring($morph, 4, 1)"/>
      </xsl:when>
      <xsl:when test="starts-with($type, 'infinitive')">
        <xsl:value-of select="substring($morph, 1, 1)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$langIsoCode = 'he'">
      <xsl:variable name="state" select="$osisStatesHebrew/entry[@id = $state_tag]"/>
      <xsl:if test="normalize-space($state) != ''">
        <xsl:attribute name="state">
          <xsl:value-of select="$state"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$langIsoCode = 'arc'">
      <xsl:variable name="state" select="$osisStatesAramaic/entry[@id = $state_tag]"/>
      <xsl:if test="normalize-space($state) != ''">
        <xsl:attribute name="state">
          <xsl:value-of select="$state"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<!--                               -->

<xsl:template match="text()|@*">

  <!-- ignored -->

</xsl:template>

<!--                               -->

</xsl:transform>

<!--
  vim:shiftwidth=2:tabstop=2
-->
