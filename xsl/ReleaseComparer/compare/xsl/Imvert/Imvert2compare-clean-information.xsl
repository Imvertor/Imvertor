<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2compare-clean-information.xsl 7228 2015-09-01 13:24:51Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
  
    xmlns:dfx="http://www.topologi.com/2005/Diff-X" 
    xmlns:del="http://www.topologi.com/2005/Diff-X/Delete" 
    xmlns:ins="http://www.topologi.com/2005/Diff-X/Insert"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- 
       Compare two Imvert result files on all aspects except technical stuff.  
    -->
   
    <xsl:import href="Imvert2compare-common.xsl"/>
    
    <xsl:output indent="no"/>
    
    <xsl:variable name="stylesheet">Imvert2compare</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2compare-clean-information.xsl 7228 2015-09-01 13:24:51Z arjan $</xsl:variable>
    
    <!-- create to representations, removing all documentation level elements -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:variable name="info" select="key('imvert-compare-config',local-name(),$imvert-compare-config-doc)[1]"/>
        <xsl:choose>
            <xsl:when test="$include-reference-packages = 'false' and exists(*:reference)">
                <!-- ignore -->
            </xsl:when>
            <xsl:when test="$identify-construct-by-function = 'id' and local-name() = 'id'">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="$identify-construct-by-function = 'name' and local-name() = 'name'">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="$info/../@info='ignore'">
                <!-- ignore -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:template match="processing-instruction()|comment()">
        <!-- ignore -->
    </xsl:template>
    
</xsl:stylesheet>
