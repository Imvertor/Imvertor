<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2canonical-KING.xsl 7347 2015-12-09 10:42:29Z arjan $ 
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
          Transform KING UML constructs to canonical UML constructs.
          This canonization stylesheet is imported by sopecific UIM or SIM stylesheets.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-validation.xsl"/>
     
    <!-- 
       identity transform
    -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>    
    
</xsl:stylesheet>
