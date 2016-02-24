<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2validation-BOM.xsl 7276 2015-09-23 15:39:33Z arjan $ 
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
        Validation of the UML only for BP rules. 
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-validation.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2validation-BOM</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2validation-BOM.xsl 7276 2015-09-23 15:39:33Z arjan $</xsl:variable>
    
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
        other validation that is required for the immediate XMI translation result. 
    -->
    <xsl:template match="*"> 
        <xsl:apply-templates/>
    </xsl:template> 
    
    <xsl:template match="text()|processing-instruction()"> 
        <!-- nothing -->
    </xsl:template> 
    
</xsl:stylesheet>
