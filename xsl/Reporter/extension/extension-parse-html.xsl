<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: extension-parse-html.xsl 7231 2015-09-02 13:32:05Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    version="2.0">
  
    <xsl:function name="imf:parse-html" as="item()*">
        <xsl:param name="html-string" as="xs:string"/>
        <xsl:param name="is-escaped" as="xs:boolean"/>
        <xsl:sequence select="ext:parse-html($html-string,$is-escaped)"/>
    </xsl:function>
    
</xsl:stylesheet>