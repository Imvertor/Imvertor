<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 * Copyright (C) 2016 VNG/KING
 * 
 * This file is part of Imvertor.
 *
 * Imvertor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Imvertor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
  
    xmlns:ws="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    
    xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-entity.xsl"/>

    <xsl:variable name="ooxml-namespace" select="'http://schemas.openxmlformats.org/spreadsheetml/2006/main'"/>
    <xsl:variable name="ooxml-schemalocation-file" select="'D:\projects\validprojects\Kadaster-Imvertor\Imvertor-OS\ImvertorCommon\trunk\xsd\ooxml\sml.xsd'"/>
    <xsl:variable name="ooxml-schemalocation-url" select="imf:file-to-url($ooxml-schemalocation-file)"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ws:worksheet">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="xsi:schemaLocation" select="concat($ooxml-namespace,' ', $ooxml-schemalocation-url)"/> 
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@x14ac:*"/> <!-- ignore -->
    <xsl:template match="@*:Ignorable"/> <!-- ignore -->
    <xsl:template match="*[namespace-uri() = 'Ignorable']"/> <!-- ignore -->
    <xsl:template match="@*[namespace-uri() = 'Ignorable']"/> <!-- ignore -->
    
    <xsl:template match="/files/file[@path = 'xl\worksheets\sheet1.xml']//ws:c[1]">
        <ws:c r="A1" s="1" t="inlineStr">
            <ws:is><ws:t>DIT IS EEN TEST</ws:t></ws:is>
        </ws:c>
    </xsl:template>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
