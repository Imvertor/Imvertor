<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: localize-xsd.xsl 7299 2015-11-10 11:31:12Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all"
    version="2.0">

    <!--
       Translate URIs for imports and includes within the source XSD based on
       the mapping passed.
       This is part of the strategy to maintain a set of external schema's 
       needed for CDMKAD based schema's, and pass as a local copy in the distributions.
    -->
    
    <xsl:include href="../common/Imvert-common.xsl"/>
    
    <xsl:param name="local-schema-folder-name">unknown-folder</xsl:param>
    <xsl:param name="local-schema-mapping-file">unknown-file</xsl:param>
    
    <xsl:variable name="local-schema-mapping" select="imf:document($local-schema-mapping-file)/local-schemas"/>
    
    <xsl:variable name="local-mapping-notification" select="imf:get-config-parameter('local-mapping-notification')"/>
    
    <xsl:template match="/xs:schema">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:comment>
                <xsl:value-of select="concat('&#10;',normalize-space($local-mapping-notification),'&#10;')"/>
            </xsl:comment>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="xs:import/@schemaLocation">
        <xsl:attribute name="schemaLocation" select="imf:get-local-uri(.)"/>
    </xsl:template>
    <xsl:template match="xs:include/@schemaLocation">
        <xsl:attribute name="schemaLocation" select="imf:get-local-uri(.)"/>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="comment()|processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:function name="imf:get-local-uri" as="xs:string">
        <xsl:param name="external-location" as="xs:string"/>
        <xsl:variable name="local-schema" select="$local-schema-mapping/local-schema[@schemafolder=$local-schema-folder-name]"/>
        <xsl:variable name="local-map" 
            select="$local-schema/local-map[starts-with($external-location,@source-uri-prefix)]"/>
        <xsl:variable name="local-location" select="concat($local-map/@target-uri-prefix,substring-after($external-location,$local-map/@source-uri-prefix))"/>
        <xsl:value-of select="
            if ($local-map) 
            then $local-location
            else $external-location"/>
    </xsl:function>
    
</xsl:stylesheet>
