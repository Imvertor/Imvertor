<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: extension-variable.xsl 7231 2015-09-02 13:32:05Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    version="2.0">
  
    <xsl:function name="imf:get-variable">
        <xsl:param name="name"/>
        <xsl:sequence select="ext:imvertorGetVariable($name)"/>
    </xsl:function>
    <xsl:function name="imf:set-variable">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:sequence select="ext:imvertorSetVariable($name,$value)"/>
    </xsl:function>
    
</xsl:stylesheet>