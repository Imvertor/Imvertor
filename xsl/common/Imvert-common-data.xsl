<?xml version="1.0" encoding="UTF-8"?>
<!-- SVN: $Id: Imvert-common-data.xsl 7174 2015-07-23 11:04:06Z arjan $ -->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:imvert="http://www.imvertor.org/schema/system"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:variable name="document" select="/"/>
    
    <xsl:variable 
        name="document-packages" 
        select="$document//imvert:package"
        as="node()*"/>
    
    <xsl:variable 
        name="document-classes" 
        select="$document//imvert:class"
        as="node()*"/>
    
</xsl:stylesheet>
