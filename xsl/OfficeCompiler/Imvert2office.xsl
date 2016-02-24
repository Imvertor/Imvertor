<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2office.xsl 7396 2016-01-26 13:02:55Z arjan $ 
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
          Transform Imvertor constructs to an office input document (HTML).
    -->
    
    <xsl:output indent="no"/>
   
    <xsl:variable name="stylesheet">Imvert2office</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2office.xsl 7396 2016-01-26 13:02:55Z arjan $</xsl:variable>
    
    <xsl:template match="/imvert:packages">
       <h1>No translation available!</h1>
    </xsl:template>
   
</xsl:stylesheet>
