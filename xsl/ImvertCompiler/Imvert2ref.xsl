<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2ref.xsl 7417 2016-02-09 13:01:46Z arjan $ 
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
        Generate packages holding the XREf constructs. 
        These are needed to reference Objecttypes in the domain packages.
        
        IM-110 They are not generated when buildcollection no
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2ref</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2ref.xsl 7417 2016-02-09 13:01:46Z arjan $</xsl:variable>
   
    <xsl:template match="/imvert:packages">
        <imvert:packages>
            <xsl:sequence select="imf:compile-imvert-header(.,$stylesheet,$stylesheet-version)"/>
            <xsl:apply-templates select="imvert:package"/>
        </imvert:packages>
    </xsl:template>
    
    <xsl:template match="imvert:package">
        <!-- copy the package -->
        <xsl:sequence select="."/>
        <xsl:if test="imf:boolean($buildcollection)">
            <!-- 
                Check if a reference package is required.
                A reference package is created only for domain packages, that have at least one class that is linkable.
            -->
            <xsl:variable name="identifiable-classes" select="imvert:class[imf:is-linkable(.)]"/>
            <xsl:if test="(imvert:stereotype = imf:get-config-stereotypes('stereotype-name-domain-package')) and $identifiable-classes">
                <!-- some of the classes are identifiable, so create a new package -->
                <xsl:variable name="namespace" select="imvert:namespace"/>
                <imvert:package>
                    <xsl:variable name="gs" as="element()?">
                        <p>(Generated schema)</p>
                    </xsl:variable>
                    <xsl:sequence select="imf:create-output-element('imvert:id',imf:get-ref-id(.))"/>
                    <xsl:sequence select="imf:create-output-element('imvert:name',imf:get-ref-name(.))"/>
                    <xsl:sequence select="imf:create-output-element('imvert:namespace',imf:get-ref-namespace(.))"/>
                    <xsl:sequence select="imf:create-output-element('imvert:documentation',$gs,(),false())"/>
                    <xsl:sequence select="imf:create-output-element('imvert:author','(System)')"/>
                    <xsl:sequence select="imf:create-output-element('imvert:version',(imvert:ref-version,imvert:version)[1])"/>
                    <xsl:sequence select="imf:create-output-element('imvert:release',(imvert:ref-release,imvert:release)[1])"/> 
                    <xsl:sequence select="imf:create-output-element('imvert:ref-master',imvert:name)"/>
                    <xsl:apply-templates select="$identifiable-classes" mode="identifiable"/>
                </imvert:package>
            </xsl:if> 
        </xsl:if>
    </xsl:template>

    <xsl:template match="imvert:class" mode="identifiable">
        <!-- an identifiable class -->
        <imvert:class>
            <xsl:variable name="gc" as="element()">
                <p>(Generated class)</p>
            </xsl:variable>
            <xsl:sequence select="imf:create-output-element('imvert:id',imf:get-ref-id(.))"/>
            <xsl:sequence select="imf:create-output-element('imvert:name',imf:get-ref-name(.))"/>
            <xsl:sequence select="imf:create-output-element('imvert:abstract','false')"/>
            <xsl:sequence select="imf:create-output-element('imvert:documentation',$gc,(),false())"/>
            <xsl:sequence select="imf:create-output-element('imvert:author','(System)')"/>
            <xsl:sequence select="imf:create-output-element('imvert:ref-master',imvert:name)"/>
            <xsl:sequence select="imf:create-output-element('imvert:stereotype',imf:get-config-stereotypes('stereotype-name-system-reference-class'))"/>
        </imvert:class>
    </xsl:template>
  
    <xsl:function name="imf:get-ref-id" as="xs:string">
        <xsl:param name="this" as="node()"/>
        <xsl:value-of select="concat($this/imvert:id,imf:get-config-parameter('reference-suffix-id'))"/>
    </xsl:function>
    
    <xsl:function name="imf:get-ref-name" as="xs:string">
        <xsl:param name="this" as="node()"/>
        <xsl:value-of select="concat($this/imvert:name,imf:get-config-parameter('reference-suffix-name'))"/>
    </xsl:function>
    
    <xsl:function name="imf:get-ref-namespace" as="xs:string">
        <xsl:param name="this" as="node()"/>
        <xsl:value-of select="concat($this/imvert:namespace,'-ref')"/>
    </xsl:function>
   
</xsl:stylesheet>
