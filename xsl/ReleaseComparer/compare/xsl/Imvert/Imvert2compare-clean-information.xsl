<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 * Copyright (C) 2016 Dienst voor het kadaster en de openbare registers
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
