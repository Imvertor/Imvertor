<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2XSD-KING-endproduct.xsl 38 2015-12-02 12:38:02Z ArjanLoeffen $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:UML="omg.org/UML1.3"
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    xmlns:imvert-result="http://www.imvertor.org/schema/imvertor/application/v20160201"
    xmlns:imvert-ep="http://www.imvertor.org/schema/endproduct"
    
    xmlns:bg="http://www.egem.nl/StUF/sector/bg/0310" 
    xmlns:metadata="http://www.kinggemeenten.nl/metadataVoorVerwerking" 
    xmlns:ztc="http://www.kinggemeenten.nl/ztc0310" 
    xmlns:stuf="http://www.egem.nl/StUF/StUF0301" 
    
    xmlns:ss="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    
    version="2.0">
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="Imvert2XSD-KING-common.xsl"/>
    
    <xsl:import href="Imvert2XSD-KING-create-endproduct-schema.xsl"/>
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <xsl:variable name="stylesheet">Imvert2XSD-KING-endproduct-xsd</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2XSD-KING-endproduct.xsl 38 2015-12-02 12:38:02Z ArjanLoeffen $</xsl:variable>  
    
    <!-- set the processing parameters of the stylesheets. -->
    <xsl:variable name="debug" select="'no'"/>
    <xsl:variable name="use-EAPconfiguration" select="'yes'"/>
    
    <xsl:variable name="imvert-endproduct" select="imf:document(imf:get-config-string('properties','RESULT_ENDPRODUCT_XML_FILE_PATH'))"/>  
    
    <xsl:variable name="xsd-file-folder-path" select="imf:get-config-string('properties','RESULT_XSD_APPLICATION_FOLDER')"/>
    <xsl:variable name="xsd-file-url" select="imf:file-to-url(concat($xsd-file-folder-path,'/koppelvlak.xsd'))"/>
    <xsl:template match="/">
        <result>
            <xsl:comment select="concat('XSD is geplaatst in ', $xsd-file-url)"/>
        </result>
        <xsl:result-document href="{$xsd-file-url}">
            <xsl:apply-templates select="$imvert-endproduct/imvert-ep:endproduct-structures"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="/imvert:dummy"/>
    
</xsl:stylesheet>
