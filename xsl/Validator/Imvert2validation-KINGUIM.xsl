<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2validation-KINGUIM.xsl 7347 2015-12-09 10:42:29Z arjan $ 
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
        Validation of the UML only for KING rules, which follow the BP rules mostly. 
    -->
    
    <xsl:import href="Imvert2validation-KING.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2validation-KINGUIM</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2validation-KINGUIM.xsl 7347 2015-12-09 10:42:29Z arjan $</xsl:variable>
    
    <!-- TODO added validation for KING exchange models UIM -->

</xsl:stylesheet>
