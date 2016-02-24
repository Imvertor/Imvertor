<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: XmiCompiler-report.xsl 7277 2015-09-24 09:15:57Z arjan $ 
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
    
    <xsl:variable name="stylesheet">XmiCompiler-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: XmiCompiler-report.xsl 7277 2015-09-24 09:15:57Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>XMI compiler</step-display-name>
            <summary>
                <!-- general -->
                <info label="Invertor version">
                    <xsl:sequence select="imf:report-key-label('Version', 'run','version')"/>
                    <xsl:sequence select="imf:report-key-label('Release', 'run','release')"/>
                </info>
                <info label="Run">
                    <xsl:sequence select="imf:report-key-label('Start', 'run','start')"/>
                </info>
                <info label="Task">
                    <xsl:sequence select="imf:report-key-label('Task', 'cli','task')"/>
                    <xsl:sequence select="imf:report-key-label('Debug', 'cli','debug')"/>
                    <xsl:sequence select="imf:report-key-label('Forced compilation', 'cli','forcecompile')"/>
                </info>
                <info label="Application">
                    <xsl:sequence select="imf:report-key-label('Application', 'cli','application')"/>
                    <xsl:sequence select="imf:report-key-label('Owner', 'cli','owner')"/>
                    <xsl:sequence select="imf:report-key-label('Project', 'cli','project')"/>
                </info>
                <info label="Model">
                    <xsl:sequence select="imf:report-key-label('Metamodel', 'cli','metamodel')"/>
                    <xsl:sequence select="imf:report-key-label('Language', 'cli','language')"/>
                </info>
                
                <!-- specific -->
                <info label="Input file">
                    <xsl:sequence select="imf:report-key-label('UML file', 'cli','umlfile')"/>
                </info>
            </summary>
        </report>
    </xsl:template>

    
</xsl:stylesheet>
