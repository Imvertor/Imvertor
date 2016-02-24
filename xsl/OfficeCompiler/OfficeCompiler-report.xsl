<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: OfficeCompiler-report.xsl 7244 2015-09-09 12:45:15Z arjan $ 
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
    
    <xsl:variable name="stylesheet">OfficeCompiler-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: OfficeCompiler-report.xsl 7244 2015-09-09 12:45:15Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <xsl:variable name="messages" select="$configuration//messages/message[src='XMI1Imvert']"/>
        <xsl:variable name="errors" select="$messages[type=('FATAL','ERROR')]"/>
        
        <report>
            <step-display-name>Office compiler</step-display-name>
            <status>
                <xsl:sequence select="if (count($errors) eq 0) then 'succeeds' else 'fails'"/>
            </status>
            <summary>
                <info label="Office documentation">
                    <xsl:sequence select="imf:report-key-label('Saved as','appinfo','office-documentation-filename')"/>
                </info>
            </summary>
      </report>
    </xsl:template>

</xsl:stylesheet>
