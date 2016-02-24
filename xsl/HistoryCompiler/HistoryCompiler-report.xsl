<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: HistoryCompiler-report.xsl 7272 2015-09-21 13:54:24Z arjan $ 
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
         Reporting stylesheet for History compilation
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:import href="Imvert2report-versions-common.xsl"/>
    <xsl:import href="Imvert2report-versions.xsl"/>
    <xsl:import href="Imvert2report-versions-consolidated.xsl"/>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>History compiler</step-display-name>
            <xsl:choose>
                <xsl:when test="imf:boolean(imf:get-config-string('cli','createhistory'))">
                    <summary>
                        <info label="History">
                            <xsl:sequence select="imf:report-label('Read from history file','yes')"/>
                            <xsl:sequence select="imf:report-label('File',imf:get-config-string('cli','hisfile'))"/>
                            <xsl:sequence select="imf:report-label('Date start',imf:get-config-string('cli','starthistory'))"/>
                        </info>
                    </summary>
                    <page>
                        <title>Version history (listed)</title>
                        <content>
                            <div>
                                <xsl:apply-templates select="." mode="versions"/>
                            </div>
                        </content>
                    </page>
                    <page>
                        <title>Version history (consolidated)</title>
                        <content>
                            <div>
                                <xsl:apply-templates select="." mode="versions-consolidated"/>
                            </div>
                        </content>
                    </page>
                    
                </xsl:when>
                <xsl:otherwise>
                    <summary>
                        <info label="History">
                            <xsl:sequence select="imf:report-label('Read from history file','no')"/>
                        </info>
                    </summary>
                </xsl:otherwise>
            </xsl:choose>
         </report>
    </xsl:template>
    
</xsl:stylesheet>
