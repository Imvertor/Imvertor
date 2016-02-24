<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: ReadmeCompiler-report.xsl 7257 2015-09-14 11:58:30Z arjan $ 
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
         Reporting stylesheet for the Readme compiler
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:variable name="stylesheet">ReadmeCompiler-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: ReadmeCompiler-report.xsl 7257 2015-09-14 11:58:30Z arjan $</xsl:variable>
    
    <!--
           This step is made when report is already created. 
           By convention the reporting information is created here but it is not used by the current process.
    -->
    <xsl:template match="/config">
        <report>
            <step-display-name>Readme compiler</step-display-name>
        </report>
    </xsl:template>

    
</xsl:stylesheet>
