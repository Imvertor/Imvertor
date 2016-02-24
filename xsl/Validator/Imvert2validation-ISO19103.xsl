<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2validation-ISO19103.xsl 7277 2015-09-24 09:15:57Z arjan $ 
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
        Validation of the UML only for ISO19103 rules. 
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-validation.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2validation-ISO19103</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2validation-ISO19103.xsl 7277 2015-09-24 09:15:57Z arjan $</xsl:variable>
    
    <xsl:variable name="application-package" select="(//imvert:package[imvert:name/@original=$application-package-name])[1]"/>
    
    <!-- 
        Document validation; this validates the root (application-)package.
    -->
    <xsl:template match="/imvert:packages">
        <imvert:report>
            <!-- info used to determine report location are set here -->
            <xsl:variable name="application-package-release" select="$application-package/imvert:release"/>
            <xsl:variable name="application-package-version" select="$application-package/imvert:version"/>
            <xsl:variable name="application-package-phase" select="$application-package/imvert:phase"/>
            
            <xsl:attribute name="release" select="if ($application-package-release) then $application-package-release else '00000000'"/>
            <xsl:attribute name="version" select="if ($application-package-version) then $application-package-version else '0.0.0'"/>
            <xsl:attribute name="phase" select="if ($application-package-phase) then $application-package-phase else '0'"/>
            
            <xsl:sequence select="imf:report-error(., not($application-package), 'No such application package found: [1]', ($application-package-name))"/>
            <!-- process the application package -->
            <xsl:apply-templates select=".//imvert:package[.=$application-package]"/>
        </imvert:report>
    </xsl:template>
    
    <!--
        Rules for the application package
    -->
    <xsl:template match="imvert:package[.=$application-package]">
        <!--setup-->
        <xsl:variable name="this-package" select="."/>
   
        <!-- check as regular package -->
        <xsl:next-match/>
    </xsl:template>
    
    <!--
        Rules for the domain packages
    -->
    <xsl:template match="imvert:package[imvert:stereotype = imf:get-config-stereotypes('stereotype-name-iso')19103-applicationschema]">
        <!--setup-->
        <xsl:variable name="this-package" select="."/>
        
        <!-- check as regular package -->
        <xsl:next-match/>
    </xsl:template>
        
    <xsl:template match="imvert:package" priority="0">
        <!--setup-->
        <xsl:variable name="this-package" select="."/>
        
        <!-- continue other validation -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- 
        other validation 
    -->
    <xsl:template match="*"> 
        <xsl:apply-templates/>
    </xsl:template> 
    
</xsl:stylesheet>
