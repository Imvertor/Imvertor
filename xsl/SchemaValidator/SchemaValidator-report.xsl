<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: SchemaValidator-report.xsl 7353 2015-12-13 15:43:37Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    xmlns:imvert-schemavalidation="http://www.imvertor.org/schema/report/schemavalidation"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:variable name="stylesheet">SchemaValidator-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: SchemaValidator-report.xsl 7353 2015-12-13 15:43:37Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>Schema validation</step-display-name>
            <summary>
                <info label="Schema validation">
                    <xsl:sequence select="imf:report-key-label('Status', 'appinfo','schema-validation-status')"/>
                    <xsl:sequence select="imf:report-key-label('Error count', 'appinfo','schema-error-count')"/>
                </info>
            </summary>
        </report>
    </xsl:template>
        
</xsl:stylesheet>
