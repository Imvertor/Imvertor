<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2dependencies.xsl 7277 2015-09-24 09:15:57Z arjan $ 
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
        Generate a file that lists package dependencies.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2dependencies</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2dependencies.xsl 7277 2015-09-24 09:15:57Z arjan $</xsl:variable>
   
    <xsl:template match="/imvert:packages">
        <xsl:variable name="root-package" select="imf:get-config-stereotypes(('stereotype-name-base-package','stereotype-name-variant-package','stereotype-name-application-package'))"/>
        <imvert:package-dependencies>
            <xsl:apply-templates select="$document-packages[imvert:name/@original=$application-package-name and imvert:stereotype=$root-package]" mode="package-dependencies"/>
        </imvert:package-dependencies>
    </xsl:template>
    
    <xsl:template match="imvert:package" mode="package-dependencies">
        <imvert:package id="{imvert:id}" name="{imvert:name}" release="{imvert:release}" supplier-project="{imvert:supplier-project}" supplier-name="{imvert:supplier-name}" supplier-release="{imvert:supplier-release}"/>
        <xsl:variable name="supplier-id" select="imvert:used-package-id"/>
        <xsl:if test="$supplier-id">
            <xsl:apply-templates select="$document-packages[imvert:id=$supplier-id]" mode="package-dependencies"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
