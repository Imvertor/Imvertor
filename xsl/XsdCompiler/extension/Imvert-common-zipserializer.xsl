<!-- 
    SVN: $Id: Imvert-common-zipserializer.xsl 7295 2015-11-04 11:24:37Z arjan $ 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    xmlns:imvert="http://www.imvertor.org/xsl/functions"
    
    version="2.0">
    
    <!--
        Serialize the zip file to a temporary folder.
        Returns the (full) folder path.
    -->
    <xsl:function name="imf:serializeFromZip" as="xs:string*">
        <xsl:param name="filepath"/>
        <xsl:param name="folderpath"/>
        <xsl:sequence select="ext:imvertorZipSerializer($filepath,$folderpath)"/>
    </xsl:function>

    <!--
        Deserialize the folder to the new zip file.
        Returns the (full) zip file path.
    -->
    <xsl:function name="imf:deserializeToZip" as="xs:string*">
        <xsl:param name="folderpath"/>
        <xsl:param name="filepath"/>
        <xsl:sequence select="ext:imvertorZipDeserializer($folderpath,$filepath)"/>
    </xsl:function>
    
</xsl:stylesheet>