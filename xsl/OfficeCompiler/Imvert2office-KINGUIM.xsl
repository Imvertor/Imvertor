<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2office-KING.xsl 7310 2015-11-17 14:27:47Z arjan $ 
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
          Transform KING UIM UML constructs to an office input document (HTML).
    
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <!--<xsl:import href="Imvert2validation-common.xsl"/>-->
    
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:variable name="stylesheet">Imvert2office-KINGUIM</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2office-KING.xsl 7310 2015-11-17 14:27:47Z arjan $</xsl:variable>

    <xsl:variable name="quot"><!--'--></xsl:variable>
    
    <xsl:template match="/imvert:packages">
        <h1>No translation available!</h1>
    </xsl:template>   
</xsl:stylesheet>
