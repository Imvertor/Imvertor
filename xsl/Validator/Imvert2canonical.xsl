<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2canonical-KINGUIM.xsl 7353 2015-12-13 15:43:37Z arjan $ 
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
         Canonization of the input, common to all metamodels.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
   
    <xsl:variable name="stylesheet">Imvert2canonical</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2canonical-KINGUIM.xsl 7353 2015-12-13 15:43:37Z arjan $</xsl:variable>
    
    <xsl:template match="/imvert:packages">
        <imvert:packages>
            <xsl:sequence select="imf:compile-imvert-header(.,$stylesheet,$stylesheet-version)"/>
            <xsl:apply-templates select="imvert:package"/>
        </imvert:packages>
    </xsl:template>
    
    <xsl:template match="imvert:class[imvert:designation = 'datatype']">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <imvert:stereotype origin="system">
                <xsl:value-of select="imf:get-config-stereotypes('stereotype-name-datatype')[1]"/>
            </imvert:stereotype>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="imvert:class[imvert:designation = 'enumeration']/imvert:attributes/imvert:attribute">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <imvert:stereotype origin="system">
                <xsl:value-of select="imf:get-config-stereotypes('stereotype-name-enum')[1]"/>
            </imvert:stereotype>
        </xsl:copy>
    </xsl:template>
    
    <!-- remove explicit trace relations; traces are recorded as imvert:trace (client to supplier) -->
    <xsl:template match="imvert:association[imvert:stereotype = imf:get-config-stereotypes('stereotype-name-trace')]">
        <!-- remove -->
    </xsl:template>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
