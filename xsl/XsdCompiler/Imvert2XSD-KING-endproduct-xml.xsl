<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2XSD-KING-endproduct-xml.xsl 7417 2016-02-09 13:01:46Z arjan $ 
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
    <xsl:import href="Imvert2XSD-KING-enrich-excel.xsl"/>
    
    <xsl:import href="Imvert2XSD-KING-common.xsl"/>
    
    <xsl:import href="Imvert2XSD-KING-create-endproduct-structure.xsl"/>
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <xsl:variable name="stylesheet">Imvert2XSD-KING-endproduct-xml</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2XSD-KING-endproduct-xml.xsl 7417 2016-02-09 13:01:46Z arjan $</xsl:variable>  
    
    <!-- set the processing parameters of the stylesheets. -->
    <xsl:variable name="debug" select="'no'"/>
    <xsl:variable name="use-EAPconfiguration" select="'yes'"/>
    
    <xsl:variable name="enriched-endproduct-base-config-excel">
        <result>
            <xsl:choose>
                <xsl:when test="ends-with(lower-case($endproduct-base-config-excel),'.xlsx')">
                    <!-- excel based on OO-XML -->
                    <xsl:for-each select="$content-doc/files/file/ss:worksheet">
                        <xsl:variable name="worksheet">
                            <xsl:apply-templates select="." mode="resolve-strings"/>
                        </xsl:variable>
                        <!-- IK MAAK HIER GEWOON EEN KOPIE, BEWERK DEZE DATA NAAR BEHOREN -->
                        <xsl:sequence select="$worksheet"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="ends-with(lower-case($endproduct-base-config-excel),'.xls')">
                    <!-- excel 97-2003 --> 
                    <xsl:variable name="xml-path" select="imf:serializeExcel($endproduct-base-config-excel,concat($workfolder-path,'/excel.xml'),$excel-97-dtd-path)"/>
                    <xsl:variable name="xml-doc" select="imf:document(imf:file-to-url($xml-path))"/>
                    <xsl:apply-templates select="$xml-doc/workbook"/>
                    
                    <!--<xsl:sequence select="$xml-doc/*"/>-->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="imf:msg('WARNING','No or not a known endproduct base configuration excel file: [1] ', ($endproduct-base-config-excel))"/>
                </xsl:otherwise>
            </xsl:choose>
        </result>
    </xsl:variable>
    
    <xsl:variable name="enriched-endproduct-config-excel">
        <result>
            <xsl:choose>
                <xsl:when test="$use-EAPconfiguration = 'no'">
                    <xsl:choose>
                        <xsl:when test="ends-with(lower-case($endproduct-config-excel),'.xlsx')">
                            <!-- excel based on OO-XML -->
                            <xsl:for-each select="$content-doc/files/file/ss:worksheet">
                                <xsl:variable name="worksheet">
                                    <xsl:apply-templates select="." mode="resolve-strings"/>
                                </xsl:variable>
                                <!-- IK MAAK HIER GEWOON EEN KOPIE, BEWERK DEZE DATA NAAR BEHOREN -->
                                <xsl:sequence select="$worksheet"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="ends-with(lower-case($endproduct-config-excel),'.xls')">
                            <!-- excel 97-2003 -->
                            <xsl:variable name="xml-path" select="imf:serializeExcel($endproduct-config-excel,concat($workfolder-path,'/excel.xml'),$excel-97-dtd-path)"/>
                            <xsl:variable name="xml-doc" select="imf:document(imf:file-to-url($xml-path))"/>
                            <xsl:apply-templates select="$xml-doc/workbook"/>
                            
                            <!--<xsl:sequence select="$xml-doc/*"/>-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="imf:msg('WARNING','No or not a known endproduct configuration excel file: [1] ', ($endproduct-config-excel))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$use-EAPconfiguration = 'yes'">
                    <xsl:variable name="berichten-infoset" select="imf:document(imf:get-config-string('properties','RESULT_ENDPRODUCT_MSG_FILE_PATH'))"/>  
                    <xsl:variable name="berichten-table" select="imf:create-berichten-table($berichten-infoset/berichten/*)"/>
                    <!-- <result-infoset>
						 <xsl:sequence select="$berichten-infoset"/>       
					</result-infoset>
					<result-table>-->
                    <xsl:sequence select="$berichten-table"/>       
                    <!--</result-table>-->
                </xsl:when>
            </xsl:choose>			
        </result>
    </xsl:variable>
    
	<xsl:variable name="berichtNaam" select="/imvert:packages/imvert:application"/>
	
    <xsl:variable name="imvert-endproduct">
        <xsl:apply-templates select="//imvert:package[imvert:name/@original='Bericht']" mode="create-message-structure"/>
        <!--<xsl:sequence select="//imvert:package[imvert:name/@original='Bericht']/imvert:package[imvert:name/@original='Objecttype']/*"/>-->
        <!--<xsl:sequence select="/*"/>-->
     </xsl:variable>
    
    <xsl:template match="/">
        <xsl:result-document href="file:/c:/temp/result.xml">
            <xsl:sequence select="$enriched-endproduct-config-excel"/>
        </xsl:result-document> 
         <xsl:result-document href="file:/c:/temp/imvert-endproduct.xml">
            <xsl:sequence select="$imvert-endproduct/*"/>
        </xsl:result-document> 
       <xsl:sequence select="$imvert-endproduct/*"/>
    </xsl:template>
    
    <!-- onderdruk even de suppressXsltNamespaceCheck melding -->
    <xsl:template match="/imvert:dummy"/>
    
</xsl:stylesheet>
