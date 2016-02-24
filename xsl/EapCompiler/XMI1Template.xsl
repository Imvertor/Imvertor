<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: XMI1Template.xsl 7299 2015-11-10 11:31:12Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    xmlns:UML="omg.org/UML1.3" 

    exclude-result-prefixes="#all"
    version="2.0"
    >
    
    <!-- maak een working copy aan vanuit dit XMI bestand. -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">XML1Template</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: XMI1Template.xsl 7299 2015-11-10 11:31:12Z arjan $</xsl:variable>
    
    <xsl:param name="oldname" select="$application-package-name"/>
    <xsl:param name="newname" select="'NEWNAME'"/>
    <xsl:param name="newauthor" select="'NEWAUTHOR'"/>
    
    <!-- get all ID values -->
    <xsl:variable name="idmap" as="element()+">
        <xsl:apply-templates select="//@xmi.id" mode="idmap"/>
    </xsl:variable>
    
    <!-- determine which element/attributes are typed as ID -->
    <xsl:variable name="idrep" as="element()+">
        <xsl:variable name="n" as="element()+">
            <xsl:apply-templates select="//@*" mode="idrep"/>
        </xsl:variable>
        <xsl:for-each-group select="$n" group-by="concat(@elm, '/', @att)">
            <xsl:sequence select="current-group()[1]"/>
        </xsl:for-each-group>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template match="UML:ClassifierRole[@name=$oldname]">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()=$oldname)]"/>
            <xsl:attribute name="name" select="$newname"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="UML:Package[@name=$oldname]">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()=$oldname)]"/>
            <xsl:attribute name="name" select="$newname"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="UML:TaggedValue[@tag=('ea_sourceName','package_name') and @value=$oldname]">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='value')]"/>
            <xsl:attribute name="value" select="'$newname'"/>
        </xsl:copy>
    </xsl:template>
   
    <!-- application documentation is separated from base documentation. Separator is a fixed string. -->
    <xsl:template match="UML:TaggedValue[@tag='documentation']">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='value')]"/>
            <xsl:attribute name="value" select="concat(imf:get-config-parameter('documentation-newline'), imf:get-config-parameter('documentation-separator'), $oldname, imf:get-config-parameter('documentation-separator'), imf:get-config-parameter('documentation-newline'), @value)"/>
       </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@xmi.id">
        <xsl:attribute name="xmi.id" select="$idmap[@old=current()]/@new"/>
    </xsl:template>

    <xsl:template match="@xmi.id" mode="idmap">
        <m ns="" old="{.}" new="{.}"/> <!-- no change needed; automatic import will reset all GUIDs -->
    </xsl:template>

    <xsl:template match="@*" mode="idrep">
        <xsl:if test="$idmap/@old=current()">
            <m ns="" elm="{local-name(parent::*)}" att="{local-name(.)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:variable name="attname" select="local-name(.)"/>
        <xsl:variable name="attval" select="."/>
        <xsl:variable name="mappedval" select="$idmap[@old=$attval]/@new"/>
        <xsl:variable name="elmname" select="local-name(..)"/>
        <xsl:choose>
            <xsl:when test="$idrep[@elm=$elmname and @att=$attname and $mappedval]">
                <xsl:attribute name="{$attname}" select="$mappedval"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{$attname}" select="$attval"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
