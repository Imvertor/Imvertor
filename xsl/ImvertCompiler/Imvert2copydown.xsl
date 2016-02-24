<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2copydown.xsl 7396 2016-01-26 13:02:55Z arjan $ 
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
        Copy the properties of any copy-down-related supertype to the subclass.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2copydown</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2copydown.xsl 7396 2016-01-26 13:02:55Z arjan $</xsl:variable>
   
    <xsl:template match="/imvert:packages">
        <xsl:copy>
            <xsl:sequence select="imf:compile-imvert-header(.,$stylesheet,$stylesheet-version)"/>
            <xsl:apply-templates select="imvert:package"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="imvert:attributes">
        <xsl:copy>
            <xsl:for-each  select="../imvert:supertype[imvert:stereotype=imf:get-config-stereotypes('stereotype-name-static-generalization')]">
                <xsl:sort select="xs:integer(imvert:position)" order="ascending"/>
                <xsl:variable name="copy-down-superids" select="imvert:type-id"/>
                <xsl:apply-templates select="$document-classes[imvert:id=$copy-down-superids]/imvert:attributes" mode="copy-down"/> 
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:copy> 
    </xsl:template>
    
    <xsl:template match="imvert:attributes" mode="copy-down">
        <xsl:variable name="copy-down-superids" select="../imvert:supertype[imvert:stereotype=imf:get-config-stereotypes('stereotype-name-static-generalization')]/imvert:type-id"/>
        <xsl:apply-templates select="$document-classes[imvert:id=$copy-down-superids]/imvert:attributes" mode="copy-down"/>  
        <xsl:apply-templates select="imvert:attribute" mode="copy-down"/>
    </xsl:template>
    
    <xsl:template match="imvert:attribute" mode="copy-down">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:sequence select="imf:create-output-element('imvert:copy-down-type-id', ../../imvert:id)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="imvert:associations">
        <xsl:copy>
            <xsl:variable name="copy-down-superids" select="../imvert:supertype[imvert:stereotype=imf:get-config-stereotypes('stereotype-name-static-generalization')]/imvert:type-id"/>
            <xsl:apply-templates select="$document-classes[imvert:id=$copy-down-superids]/imvert:associations" mode="copy-down"/>  
            <xsl:apply-templates/>
        </xsl:copy> 
    </xsl:template>
    
    <xsl:template match="imvert:associations" mode="copy-down">
        <xsl:variable name="copy-down-superids" select="../imvert:supertype[imvert:stereotype=imf:get-config-stereotypes('stereotype-name-static-generalization')]/imvert:type-id"/>
        <xsl:apply-templates select="$document-classes[imvert:id=$copy-down-superids]/imvert:associations" mode="copy-down"/>  
        <xsl:apply-templates select="imvert:association" mode="copy-down"/>
    </xsl:template>
    
    <xsl:template match="imvert:association" mode="copy-down">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:sequence select="imf:create-output-element('imvert:copy-down-type-id', ../../imvert:id)"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
