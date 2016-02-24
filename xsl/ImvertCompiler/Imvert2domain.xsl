<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2domain.xsl 7379 2016-01-14 07:39:34Z arjan $ 
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
        Verwijder alle packages die binnen een domain package vallen.
        Verwijder tevens alle packages die tussen root package en domain vallen.
        
        Dus als wordt verwezen naar een object in subdomain, dan wordt dat vervangen door het domein waar het onderdeel van is.
        Subdomeinen zijn slechts een groeperingsconstructie tbv. UML en spelen geen rol in XSD (en documentatie).
        
        Dit stylesheet plaatst tevens de base-namespace op alle packages.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2domain</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2domain.xsl 7379 2016-01-14 07:39:34Z arjan $</xsl:variable>
   
    <!-- bepaal welke package de applicatie bevat -->
    <xsl:variable name="base-package" select="
        $document-packages[imvert:name=imf:get-normalized-name($application-package-name,'package-name') 
        and 
        imvert:stereotype=imf:get-config-stereotypes(('stereotype-name-base-package','stereotype-name-application-package'))]">
    </xsl:variable>

    <xsl:variable name="known-package" select="(
        imf:get-config-stereotypes('stereotype-name-domain-package'),
        imf:get-config-stereotypes('stereotype-name-base-package'), 
        imf:get-config-stereotypes('stereotype-name-application-package'), 
        imf:get-config-stereotypes('stereotype-name-system-package'), 
        imf:get-config-stereotypes('stereotype-name-components-package'), 
        imf:get-config-stereotypes('stereotype-name-external-package'))"/>
    
    <xsl:variable name="domain-mapping" as="node()*">
        <xsl:for-each select="$base-package/descendant-or-self::imvert:package">
            <xsl:variable name="domain" select="ancestor-or-self::imvert:package[imvert:stereotype=imf:get-config-stereotypes('stereotype-name-domain-package')][1]"/>
            <map sd-name="{imvert:name}" d-name="{if ($domain) then $domain/imvert:name else imvert:name}"/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/imvert:packages">
        <!-- test the mapping first; no different mappings subdomain-domain are allowed -->
        <!--TODO If subdomains have same name: disallow, so error! -->
        <xsl:variable name="duplicate-subdomain-names" as="xs:string*">
            <xsl:for-each-group select="$domain-mapping" group-by="@sd-name">
                <xsl:if test="distinct-values(current-group()/@d-name)[2]">
                    <xsl:value-of select="current-grouping-key()"/>
                </xsl:if>
            </xsl:for-each-group>
        </xsl:variable>
     
        <imvert:packages>
            <xsl:sequence select="*[not(self::imvert:package or self::imvert:filter)]"/>
            <xsl:sequence select="imf:create-output-element('imvert:base-namespace',$base-package/imvert:namespace)"/>
            <xsl:sequence select="imf:create-output-element('imvert:version',$base-package/imvert:version)"/>
            <xsl:sequence select="imf:create-output-element('imvert:phase',$base-package/imvert:phase)"/>
            <xsl:sequence select="imf:create-output-element('imvert:release',$base-package/imvert:release)"/>
            <xsl:sequence select="imf:create-output-element('imvert:documentation',$base-package/imvert:documentation/node(),'',false(),false())"/>
            <xsl:sequence select="imvert:filter"/>
            <xsl:sequence select="imf:compile-imvert-filter($stylesheet, $stylesheet-version)"/>
            
            <xsl:choose>
                <xsl:when test="empty($base-package)">
                    <xsl:sequence select="imf:msg('ERROR','No package [1] defined with stereotype base or application. Is the name valid?',$application-package-name)"/>
                </xsl:when>
                <xsl:when test="empty($base-package/imvert:namespace)">
                    <xsl:sequence select="imf:msg('ERROR','No root namespace defined.')"/>
                </xsl:when>
                <!-- IM129 
                <xsl:when test="exists($duplicate-subdomain-names)">
                    <xsl:sequence select="imf:msg('ERROR',concat('Subdomain name(s) occur(s) within different domains: ' , string-join($duplicate-subdomain-names,', ')))"/>
                </xsl:when>
                -->
                <xsl:otherwise>
                    <xsl:apply-templates select="imvert:package"/>
                </xsl:otherwise>
            </xsl:choose>
        </imvert:packages>
    </xsl:template>
    
    <!-- een package dat geen domain is en valt binnen een root package wordt verwijderd. -->
    <xsl:template match="imvert:package[not(imvert:stereotype=$known-package)]">
        <!-- een package dat ergens binnen een domein package is opgenomen wordt verwijderd -->
        <xsl:if test="ancestor::imvert:package/imvert:stereotype=imf:get-config-stereotypes('stereotype-name-domain-package')">
            <xsl:apply-templates select="imvert:class"/>
        </xsl:if>
        <xsl:apply-templates select="imvert:package"/>
    </xsl:template>
    
    <xsl:template match="imvert:type-package">
        <xsl:sequence select="imf:create-output-element('imvert:type-package',($domain-mapping[@sd-name=current()]/@d-name)[1])"/>
    </xsl:template>
    
    <xsl:template match="imvert:class">
        <imvert:class>
            <xsl:apply-templates/>
            <xsl:variable name="subpackages" select="imf:get-package-structure(.)"/>
            <xsl:for-each select="$subpackages">
                <xsl:sequence select="imf:create-output-element('imvert:subpackage',imvert:name)"/>
            </xsl:for-each>
        </imvert:class>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- Return all packages that the element is part of, that are (within) a domain package -->
    <xsl:function name="imf:get-package-structure" as="element()*">
        <xsl:param name="this" as="element()"/>
        <xsl:sequence select="$this/ancestor-or-self::imvert:package[ancestor-or-self::imvert:package/imvert:stereotype=imf:get-config-stereotypes('stereotype-name-domain-package')]"/>
    </xsl:function>
</xsl:stylesheet>
