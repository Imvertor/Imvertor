<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2canonical-Kadaster.xsl 7409 2016-02-06 07:31:41Z arjan $ 
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
          Transform BP UML constructs to canonical UML constructs.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-validation.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2canonical-Kadaster</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2canonical-Kadaster.xsl 7409 2016-02-06 07:31:41Z arjan $</xsl:variable>
    
    <xsl:template match="/imvert:packages">
        <imvert:packages>
            <xsl:sequence select="imf:compile-imvert-header(.,$stylesheet,$stylesheet-version)"/>
            <xsl:apply-templates select="imvert:package"/>
        </imvert:packages>
    </xsl:template>
    
    <!-- generate the correct name here -->
    <xsl:template match="imvert:found-name">
        <xsl:variable name="type" select="
            if (parent::imvert:package) then 'package-name' else 
            if (parent::imvert:attribute) then 'property-name' else
            if (parent::imvert:association) then 'property-name' else 'class-name'"/>
        <imvert:name original="{.}">
            <xsl:value-of select="imf:get-normalized-name(.,$type)"/>
        </imvert:name>
    </xsl:template>
    
    <!-- generate the correct name for types specified, but only when the type is declared as a class (i.e. no system types) -->
    <xsl:template match="imvert:*[imvert:type-id]/imvert:type-name">
        <imvert:type-name original="{.}">
            <xsl:value-of select="imf:get-normalized-name(.,'class-name')"/>
        </imvert:type-name>
    </xsl:template>
    
    <!-- generate the correct name for packages of types specified -->
    <xsl:template match="imvert:type-package">
        <imvert:type-package original="{.}">
            <xsl:value-of select="imf:get-normalized-name(.,'package-name')"/>
        </imvert:type-package>
    </xsl:template>
    
    <!-- when composition, and no name, generate name of the target class on that composition relation -->
    <!-- when composition, and no stereotype, put the composition stereotype there -->
    <xsl:template match="imvert:association[imvert:aggregation='composite']">
        <imvert:association>
            <xsl:choose>
                <xsl:when test="empty(imvert:found-name)">
                    <imvert:name original="" origin="system">
                        <xsl:value-of select="imf:get-normalized-name(imvert:type-name,'property-name')"/>
                    </imvert:name>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="imvert:found-name"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="empty(imvert:stereotype)">
                    <imvert:stereotype>
                        <xsl:value-of select="imf:get-config-stereotypes('stereotype-name-association-to-composite')"/>
                    </imvert:stereotype>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="imvert:stereotype"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="*[not(self::imvert:stereotype or self::imvert:found-name)]"/>
        </imvert:association>
    </xsl:template>
    <!-- 
       identity transform
    -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>    
  
</xsl:stylesheet>
