<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: common-report.xsl 7242 2015-09-08 08:37:18Z arjan $ 
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
     Reporting stylesheet for the system common step.
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">common-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: common-report.xsl 7242 2015-09-08 08:37:18Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>Common</step-display-name>
            <!-- no reports -->
        </report>
    </xsl:template>

</xsl:stylesheet>
