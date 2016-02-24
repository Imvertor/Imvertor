<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2validation-KING.xsl 7322 2015-11-25 10:08:59Z arjan $ 
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
        This validatiuon may be imported by stylesheets for SIM or UIM that augment the validation rules.
    -->
    
    <xsl:import href="Imvert2validation-KING.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2validation-KINGSIM</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2validation-KING.xsl 7322 2015-11-25 10:08:59Z arjan $</xsl:variable>
    
  
    <!-- TODO what special validations for KING SIM? -->
    
</xsl:stylesheet>
