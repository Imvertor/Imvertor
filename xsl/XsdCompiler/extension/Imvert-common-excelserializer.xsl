<!-- 
    SVN: $Id: Imvert-common-excelserializer.xsl 7297 2015-11-05 10:19:21Z arjan $ 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    xmlns:imvert="http://www.imvertor.org/xsl/functions"
    
    version="2.0">
    
    <!--
        Serialize the excel 97-2003 file to the result XML file.
        Returns the (full) xml result file path.
    -->
    <xsl:function name="imf:serializeExcel" as="xs:string*">
        <xsl:param name="excelpath"/>
        <xsl:param name="xmlpath"/>
        <xsl:param name="dtdpath"/>
        <xsl:sequence select="ext:imvertorExcelSerializer($excelpath,$xmlpath,$dtdpath)"/>
    </xsl:function>
    
</xsl:stylesheet>