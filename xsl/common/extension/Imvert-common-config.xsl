<!-- 
    SVN: $Id: Imvert-common-config.xsl 7189 2015-07-29 14:59:39Z arjan $ 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    version="2.0">
    
    <!-- 
        A config string doesn't have to exist. If so, it returns an empty sequence.
    -->
    
    <xsl:function name="imf:get-config-string" as="xs:string?">
        <xsl:param name="group"/>
        <xsl:param name="name"/>
        <xsl:sequence select="(
            ext:imvertorParameterFile('GET',string($group),string($name),())
            )"/>      
    </xsl:function>
    
    <xsl:function name="imf:get-config-string" as="xs:string?">
        <xsl:param name="group"/>
        <xsl:param name="name"/>
        <xsl:param name="default"/>
        <xsl:variable name="cfg" select="imf:get-config-string($group,$name)"/>
        <xsl:sequence select="if (exists($cfg)) then $cfg else $default"/>
    </xsl:function>
    
    <xsl:function name="imf:remove-config" as="xs:string?">
        <xsl:param name="group"/>
        <xsl:param name="name"/>
        <xsl:sequence select="(
            ext:imvertorParameterFile('REMOVE',string($group),string($name),())
            )"/>      
    </xsl:function>
    
    <xsl:function name="imf:set-config-string" as="item()*">
        <xsl:param name="group"/>
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:sequence select="(
            ext:imvertorParameterFile('SET',string($group),string($name),string($value))
            )"/>      
    </xsl:function>
    
    <xsl:function name="imf:save-config-file" as="item()*">
        <xsl:sequence select="(
            ext:imvertorParameterFile('SAVE',(),(),()) 
            )"/>      
    </xsl:function>
    
</xsl:stylesheet>