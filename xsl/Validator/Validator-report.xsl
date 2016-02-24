<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Validator-report.xsl 7353 2015-12-13 15:43:37Z arjan $ 
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
     Reporting stylesheet for the Validator step.
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:variable name="stylesheet">Validator-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Validator-report.xsl 7353 2015-12-13 15:43:37Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>Validator</step-display-name>
            <summary>
                <info label="Release">
                    <xsl:sequence select="imf:report-key-label('Version', 'appinfo','version')"/>
                    <xsl:sequence select="imf:report-key-label('Phase', 'appinfo','phase')"/>
                    <xsl:sequence select="imf:report-key-label('Release', 'appinfo','release')"/>
                </info>
            </summary>
        </report>
    </xsl:template>

</xsl:stylesheet>
