<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: ReleaseCompiler-report.xsl 7243 2015-09-09 11:52:55Z arjan $ 
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
         Reporting stylesheet for the reporting step itself.
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:variable name="stylesheet">ReleaseCompiler-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: ReleaseCompiler-report.xsl 7243 2015-09-09 11:52:55Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>Release ZIP compiler</step-display-name>
            <summary>
                <info label="Zip file">
                    <xsl:sequence select="imf:report-key-label('Path', 'system','zip-release-filepath')"/>
                </info>
            </summary>
        </report>
    </xsl:template>

    
</xsl:stylesheet>
