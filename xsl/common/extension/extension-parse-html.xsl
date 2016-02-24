<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: extension-parse-html.xsl 7378 2016-01-12 14:12:42Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    version="2.0">
  
    <xsl:function name="imf:parse-html" as="item()*">
        <xsl:param name="html-string" as="xs:string"/>
        <xsl:param name="is-escaped" as="xs:boolean"/>
        <xsl:sequence select="ext:imvertorParseHTML($html-string,$is-escaped)"/>
    </xsl:function>
    
</xsl:stylesheet>