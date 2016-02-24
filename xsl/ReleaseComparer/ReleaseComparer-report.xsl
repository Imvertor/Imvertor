<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: ReleaseComparer-report.xsl 7264 2015-09-17 11:01:47Z arjan $ 
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
         Reporting stylesheet for the Release comparer
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
   
   <!--
        Delegated to "plugin" configuration for compare 
    -->
    <xsl:import href="compare/xsl/Imvert/Imvert2compare-report-horizontal.xsl"/>
    
    <xsl:variable name="stylesheet">ReleaseComparer-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: ReleaseComparer-report.xsl 7264 2015-09-17 11:01:47Z arjan $</xsl:variable>
    
    <!-- get the docrelease name, if any -->
    <xsl:variable name="documentation-release" select="imf:get-config-string('system','documentation-release',false())"/>
    <!-- determine the location of the report generated -->
    <xsl:variable name="report" select="document(imf:file-to-url(imf:get-config-string('properties','WORK_COMPARE_LISTING_FILE')))"/>
    <!-- get the number of differences found -->
    <xsl:variable name="diff-count" select="imf:get-config-string('appinfo','release-compare-differences')"/>
    
    <xsl:template match="/config">
        <report>
            <step-display-name>Release comparison</step-display-name>
            <summary>
                <xsl:if test="normalize-space($documentation-release)">
                    <info label="Documentation release">
                        <xsl:sequence select="imf:report-label('Release date',$documentation-release)"/>
                        <xsl:sequence select="imf:report-label('differences found',$diff-count)"/>
                    </info>
                </xsl:if>
            </summary>
            <xsl:if test="normalize-space($documentation-release) and ($diff-count ne '0')">
                <xsl:for-each select="$report"> <!-- set the context document -->
                    <xsl:call-template name="fetch-comparison-report"/>                  
                </xsl:for-each>
            </xsl:if>
        </report>
    </xsl:template>
    
</xsl:stylesheet>
