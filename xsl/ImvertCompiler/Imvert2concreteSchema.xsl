<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2concreteSchema.xsl 7402 2016-02-02 13:55:57Z arjan $ 
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
        There may be conceptual schema's referenced within the UML. 
        These should be replaced by the concrete schema's. 
        The association between conceptual and concrete schemas is recorded in a conceptual-schemas mapping file.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2concreteSchema</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2concreteSchema.xsl 7402 2016-02-02 13:55:57Z arjan $</xsl:variable>
   
    <xsl:variable name="conceptual-schema-mapping-name" select="imf:get-config-string('cli','mapping')"/>
    <xsl:variable name="conceptual-schema-mapping-file" select="imf:get-config-string('properties','CONCEPTUAL_SCHEMA_MAPPING_FILE')"/>
    <xsl:variable name="conceptual-schema-mapping" select="imf:document($conceptual-schema-mapping-file)/conceptual-schemas"/>
   
    <xsl:template match="/imvert:packages">
        <imvert:packages>
            <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-svn-id',$conceptual-schema-mapping/svn-id)"/>
            <xsl:sequence select="imf:compile-imvert-header(.,$stylesheet,$stylesheet-version)"/>
            <xsl:apply-templates select="imvert:package"/>
        </imvert:packages>
    </xsl:template>
    
    <xsl:template match="imvert:package">
        <xsl:choose>
            <xsl:when test="imf:is-conceptual(.)">
                <xsl:variable name="map" select="imf:get-conceptual-schema-map(imvert:namespace,$conceptual-schema-mapping-name)"/>
                <xsl:choose>
                    <xsl:when test="$map">
                        <!-- replace this by the concrete package -->
                        <imvert:package>
                            <xsl:apply-templates mode="conceptual">
                                <xsl:with-param name="map" select="$map"/>
                            </xsl:apply-templates>
                        </imvert:package>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="imf:msg('ERROR','Cannot determine a map for namespace [1] when using mapping [2]',(imvert:namespace,$conceptual-schema-mapping-name))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
    <xsl:template match="imvert:package/imvert:namespace" mode="conceptual">
        <xsl:param name="map" as="element()"/>
        <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-namespace',.)"/>
        <xsl:sequence select="imf:create-output-element('imvert:namespace',$map/@namespace)"/>
        <xsl:sequence select="imf:create-output-element('imvert:location',$map/@location)"/>
        <xsl:sequence select="imf:create-output-element('imvert:release',$map/@release)"/>
    </xsl:template>
   
    <xsl:template match="imvert:package/imvert:version" mode="conceptual">
        <xsl:param name="map" as="element()"/>
        <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-version',.)"/>
        <xsl:sequence select="imf:create-output-element('imvert:version',$map/@version)"/>
    </xsl:template>
    
    <xsl:template match="imvert:package/imvert:phase" mode="conceptual">
        <xsl:param name="map" as="element()"/>
        <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-phase',.)"/>
        <xsl:sequence select="imf:create-output-element('imvert:phase',$map/@phase)"/>
    </xsl:template>
    
    <xsl:template match="imvert:package/imvert:author" mode="conceptual">
        <xsl:param name="map" as="element()"/>
        <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-author',.)"/>
        <xsl:sequence select="imf:create-output-element('imvert:author','(system)')"/>
    </xsl:template>
    
    <xsl:template match="imvert:package/imvert:svn-string" mode="conceptual">
        <xsl:param name="map" as="element()"/>
        <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-svn-string',.)"/>
        <xsl:sequence select="imf:create-output-element('imvert:svn-string','(unspecified)')"/>
    </xsl:template>
    
    <xsl:template match="imvert:package/imvert:class" mode="conceptual">
        <xsl:param name="map" as="element()"/>
        <imvert:class>
            <xsl:apply-templates mode="conceptual">
                <xsl:with-param name="map" select="$map"/>
            </xsl:apply-templates>
        </imvert:class>
    </xsl:template>
    
    <xsl:template match="imvert:class/imvert:name" mode="conceptual">
        <xsl:param name="map" as="element()"/>
        <xsl:variable name="mapped-name" select="$map/type[@name=current()/@original]"/>
        <xsl:choose>
            <xsl:when test="$mapped-name">
                <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-class-name',.)"/>
                <xsl:sequence select="imf:create-output-element('imvert:name',$mapped-name)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="imf:msg('ERROR','Cannot determine an element name for interface name [1] when using mapping [2]',(.,$conceptual-schema-mapping-name))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="
        imvert:attribute[imvert:type-id]/imvert:type-name | 
        imvert:supertype[imvert:type-id]/imvert:type-name |
        imvert:supertype[imvert:type-id]/imvert:xsd-substitutiongroup">
        <!-- check if the type is taken from a conceptual schema package -->
        <xsl:variable name="class" select="imf:get-construct-by-id(../imvert:type-id)"/>
        <xsl:choose>
            <xsl:when test="empty($class)">
                <xsl:next-match/>
            </xsl:when>
            <xsl:when test=". = $name-none">
                <xsl:next-match/>
            </xsl:when>
            <xsl:when test="imf:is-conceptual($class)">
                <!-- class in a conceptual schema package -->
                <xsl:variable name="pack" select="$class/ancestor::imvert:package[imvert:namespace][1]"/>
                <xsl:variable name="map" select="imf:get-conceptual-schema-map($pack/imvert:namespace,$conceptual-schema-mapping-name)"/>
                <xsl:variable name="mapped-name" select="$map/type[@name=current()/@original]"/>
                <xsl:choose>
                    <xsl:when test="$mapped-name">
                        <xsl:sequence select="imf:create-output-element('imvert:conceptual-schema-type',.)"/>
                        <xsl:if test="imf:boolean($mapped-name/@primitive)">
                            <xsl:sequence select="imf:create-output-element('imvert:primitive',$mapped-name/@name)"/>
                        </xsl:if>
                        <xsl:sequence select="imf:create-output-element(name(.),$mapped-name)"/>
                        <xsl:variable name="att-name" select="$mapped-name/@asAttribute"/>
                        <xsl:variable name="att-desig" select="$mapped-name/@asAttributeDesignation"/>
                        <xsl:variable name="is-union-element" select="parent::imvert:attribute/imvert:stereotype = imf:get-config-stereotypes('stereotype-name-union-element')"/>
                        <xsl:choose>
                            <!-- when in context of attribute, and not a union element, check if an asAttribute is specified -->
                            <xsl:when test="parent::imvert:attribute and $att-name and not($is-union-element)">
                               <xsl:sequence select="imf:create-output-element('imvert:attribute-type-name',$att-name)"/>
                               <xsl:sequence select="imf:create-output-element('imvert:attribute-type-designation',$att-desig)"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="imf:msg('ERROR','Cannot determine an element name for interface name [1] in namespace [2] when using mapping [3]',(.,$pack/imvert:namespace,$conceptual-schema-mapping-name))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- return the conceptual schema <map> element which holds the mapping of conceptual names to construct in the schema -->
    <xsl:function name="imf:get-conceptual-schema-map" as="element()?">
        <xsl:param name="url" as="xs:string"/>
        <xsl:param name="use-mapping" as="xs:string"/>
        <xsl:variable name="mapping-uses" select="$conceptual-schema-mapping//mapping[@name=$use-mapping]/use"/>
        <xsl:variable name="conceptual-schema" select="$conceptual-schema-mapping/conceptual-schema[url=$url]"/>
        <xsl:variable name="selected-mapping" select="$conceptual-schema/map[@name=$mapping-uses][1]"/>
        <xsl:sequence select="$selected-mapping"/>
    </xsl:function>
    
    <xsl:template match="*" mode="conceptual #default">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
