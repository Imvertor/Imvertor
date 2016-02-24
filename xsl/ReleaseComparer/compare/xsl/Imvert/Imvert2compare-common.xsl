<xsl:stylesheet 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0">
    
    <xsl:param name="debug"/>

    <xsl:param name="info-version"/>
    <xsl:param name="info-ctrlpath"/>
    <xsl:param name="info-testpath"/>
    <xsl:param name="info-config"/>
 
    <xsl:param name="work-folder-uri"/>
    
    <xsl:param name="diff-filepath"/>
    <xsl:param name="ctrl-filepath"/>
    <xsl:param name="test-filepath"/>
   
    <xsl:param name="ctrl-name-mapping-filepath"/>
    <xsl:param name="test-name-mapping-filepath"/>
    
    <xsl:param name="identify-construct-by-function"/> <!-- implemented: name, id -->
    <xsl:param name="comparison-role"/> <!-- ctrl or test -->
    <xsl:param name="include-reference-packages"/> <!-- true or false -->
    
    <xsl:variable name="imvert-compare-config-doc" select="document($info-config)"/>
    <xsl:key name="imvert-compare-config" match="elm" use="@form"/>    
    
    <xsl:variable name="sep">-</xsl:variable>
    
    <xsl:function name="imf:debug" as="xs:boolean?">
        <xsl:param name="txt"/>
        <xsl:if test="$debug = 'true'">
            <xsl:message select="concat('DEBUG ', $txt)"/>
        </xsl:if>
    </xsl:function>
    
</xsl:stylesheet>