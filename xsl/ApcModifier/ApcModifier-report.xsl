<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: ApcModifier-report.xsl 7238 2015-09-07 10:00:21Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- 
         Reporting stylesheet for the Apc modifier
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:variable name="stylesheet">ApcModifier-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: ApcModifier-report.xsl 7238 2015-09-07 10:00:21Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>APC modifier</step-display-name>
            <summary>
                <!-- if an application configuration was active, provide some info -->
                <xsl:if test="imf:get-config-string('system','apc-file-path')">
                    <info label="App config">
                        <xsl:sequence select="imf:report-key-label('Excel file', 'system','apc-file-path')"/>
                    </info>
                </xsl:if>
            </summary>
        </report>
    </xsl:template>
    
</xsl:stylesheet>
