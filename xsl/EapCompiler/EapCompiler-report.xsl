<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: EapCompiler-report.xsl 7262 2015-09-16 14:23:48Z arjan $ 
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
         Reporting stylesheet for the EAP compilation process
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:variable name="stylesheet">EapCompiler-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: EapCompiler-report.xsl 7262 2015-09-16 14:23:48Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>EAP compiler</step-display-name>
            <status/>
            <summary/>
      </report>
    </xsl:template>

</xsl:stylesheet>
