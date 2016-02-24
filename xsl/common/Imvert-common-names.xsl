<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert-common-names.xsl 7371 2016-01-11 11:07:16Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- all common variables replaced by cfg references, see IM-119 -->
        
    <xsl:variable name="language" select="imf:get-config-string('cli','language')"/>    
 
    <!--
        Translate a key (e.g. "pattern") within a particular realm (such as "tv", for tagged value) to a valid alternative key (eg. "patroon") 
        in accordance with the language chosen (eg. "nl").
    -->
    <!--TODO translate() beter integreren in alle configuraties -->
    <xsl:variable name="realms">
        <xi:include href="listings/realms.xml"/>
    </xsl:variable>
    <xsl:key name="key-realms" match="//map" use="concat(../../@name,'-',../@name,'-',@lang)"/>
    
    <xsl:function name="imf:translate" as="xs:string*">
        <xsl:param name="key" as="xs:string*"/>
        <xsl:param name="realm" as="xs:string"/>
        <xsl:for-each select="$key">
            <xsl:variable name="v" select="key('key-realms',concat($realm,'-',.,'-',$language),$realms)"/>
            <xsl:value-of select="if (normalize-space($v)) then $v else $key"/>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="imf:translate-tv" as="xs:string*">
        <xsl:param name="key" as="xs:string*"/>
        <xsl:sequence select="imf:translate($key,'tv')"/>
    </xsl:function>
    
</xsl:stylesheet>
