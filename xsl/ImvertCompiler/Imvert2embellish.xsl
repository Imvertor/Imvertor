<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2embellish.xsl 7226 2015-09-01 11:11:54Z arjan $ 
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
        Plaats niet-essentiele informatie in Imvert ten behoeve van een eenvoudiger verwerking door reporting en XSD conversie tools.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2embellish</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2embellish.xsl 7226 2015-09-01 11:11:54Z arjan $</xsl:variable>
   
    <xsl:template match="/imvert:packages">
        <imvert:packages>
            <imvert:id><xsl:value-of select="$application-package-release-name"/></imvert:id>
            <xsl:sequence select="imf:compile-imvert-header(.,$stylesheet,$stylesheet-version)"/>
            <xsl:apply-templates select="imvert:package"/>
        </imvert:packages>
    </xsl:template>
    
    <xsl:template match="imvert:package">
        <xsl:copy>
            <xsl:attribute name="display-name" select="imf:get-display-name(.)"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="imvert:class">
        <xsl:copy>
            <xsl:attribute name="display-name" select="imf:get-display-name(.)"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="imvert:supertype">
        <xsl:copy>
            <xsl:variable name="superclass" select="imf:get-class(imvert:type-name,imvert:type-package)"/>
            <xsl:attribute name="display-name" select="imf:get-display-name($superclass)"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="imvert:substitution">
        <xsl:copy>
            <xsl:variable name="supplierclass" select="imf:get-class(imvert:supplier,imvert:supplier-package)"/>
            <xsl:attribute name="display-name" select="imf:get-display-name($supplierclass)"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="imvert:attribute[imvert:type-name]">
        <xsl:variable name="class" select="imf:get-class(imvert:type-name,imvert:type-package)"/>
        <xsl:copy>
            <xsl:attribute name="display-name" select="imf:get-display-name(.)"/>
            <xsl:choose>
                <xsl:when test="$class">
                    <xsl:attribute name="type-display-name" select="imf:get-display-name($class)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="type-display-name" select="imvert:type-name"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="imvert:copy-down-type-id">
                <xsl:variable name="copy-down-class" select="imf:get-construct-by-id(imvert:copy-down-type-id)"/>
                <xsl:attribute name="copy-down-display-name" select="imf:get-construct-name($copy-down-class)"></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="imvert:association">
        <xsl:variable name="class" select="imf:get-class(imvert:type-name,imvert:type-package)"/>
        <xsl:copy>
            <xsl:attribute name="display-name" select="imf:get-display-name(.)"/>
            <xsl:attribute name="type-display-name" select="imf:get-display-name($class)"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
   
</xsl:stylesheet>
