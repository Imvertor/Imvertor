<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2XSD-KING-endproduct.xsl 3 2015-11-05 10:35:07Z ArjanLoeffen $ 
-->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:UML="omg.org/UML1.3" 
	xmlns:imvert="http://www.imvertor.org/schema/system" 
	xmlns:imf="http://www.imvertor.org/xsl/functions" 
	xmlns:imvert-result="http://www.imvertor.org/schema/imvertor/application/v20160201" 
	xmlns:BG="http://www.egem.nl/StUF/sector/bg/0310" 
	xmlns:metadata="http://www.kinggemeenten.nl/metadataVoorVerwerking" 
	xmlns:ztc="http://www.kinggemeenten.nl/ztc0310" 
	xmlns:StUF="http://www.egem.nl/StUF/StUF0301" 
	xmlns:ep="http://www.imvertor.org/schema/endproduct" 
	xmlns:ss="http://schemas.openxmlformats.org/spreadsheetml/2006/main" 
	version="2.0">
	
	<xsl:output indent="yes" method="xml" encoding="UTF-8"/>
	
	<xsl:variable name="stylesheet">Imvert2XSD-KING-create-endproduct-schema</xsl:variable>
	<xsl:variable name="stylesheet-version">$Id: Imvert2XSD-KING-create-endproduct-schema.xsl 1 2015-11-11 12:02:00Z RobertMelskens $</xsl:variable>
	
	<xsl:variable name="typeBericht" select="/ep:message-set/ep:message/ep:type"/>
	<xsl:variable name="berichtCode" select="/ep:message-set/ep:message/ep:code"/>

	<xsl:template match="ep:message-set">
		<xs:schema targetNamespace="http://www.egem.nl/StUF/sector/bg/0310" elementFormDefault="qualified" attributeFormDefault="unqualified">
			<xs:import namespace="http://www.egem.nl/StUF/StUF0301" schemaLocation="stuf0301.xsd"/>
			<?x xsl:apply-templates select="ep:message"/>
			<xsl:apply-templates select="//ep:attribute[not(.//ep:attribute)]" mode="createComplexTypes"/>
			<xsl:apply-templates select="//ep:attribute[not(.//ep:attribute)]" mode="createSimpleTypes"/ x?>
		</xs:schema>
	</xsl:template>

</xsl:stylesheet>
