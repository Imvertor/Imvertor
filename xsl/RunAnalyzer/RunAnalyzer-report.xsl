<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: RunAnalyzer-report.xsl 7353 2015-12-13 15:43:37Z arjan $ 
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
         Create the full HTML report, and compile a summary ("overview") from the individual steps.
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:include href="report-config.xsl"/>
    <xsl:include href="report-parameters.xsl"/>
    
    <xsl:variable name="stylesheet">RunAnalyzer-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: RunAnalyzer-report.xsl 7353 2015-12-13 15:43:37Z arjan $</xsl:variable>
    
    <xsl:variable name="error-count" select="imf:get-config-string('appinfo','error-count')"/>
    <xsl:variable name="warning-count" select="imf:get-config-string('appinfo','warning-count')"/>
    <xsl:variable name="status-message" select="imf:get-config-string('appinfo','status-message')"/>
    
    <xsl:variable name="schema-error-count" select="imf:get-config-string('appinfo','schema-error-count')"/>
    
    <xsl:variable name="messages" select="/config/messages/message"/>
    
    <xsl:template match="/config">
        
        <report>
            <step-display-name>Run analysis</step-display-name>
            <summary>
                <info label="Status">
                    <xsl:sequence select="imf:report-label('Message', $status-message)"/>
                </info>
                <info label="Exceptions">
                    <xsl:sequence select="imf:report-label('Errors', $error-count)"/>
                    <xsl:sequence select="imf:report-label('Warnings', $warning-count)"/>
                    <xsl:sequence select="imf:report-label('Schema errors', $schema-error-count)"/>
                </info>
            </summary>
            <xsl:if test="exists($messages)">
                <!-- generate complete overview of all messages -->
                <page>
                    <title>Run analysis</title>
                    <info>
                        <xsl:value-of select="concat('(', $error-count,' errors, ', $warning-count, ' warnings)')"/>
                    </info>
                    <content>
                        <div>
                            <h1>Explanation</h1>
                            <p>This is the overview of all errors and warnings.</p>
                            <p>If hints are show, these are intended to support the user of this release to assess the impact on current implementations</p>
                            <xsl:if test="$schema-error-count ne '0'">
                                <p>
                                    This table also reports errors found when parsing the result XML schema(s). 
                                    These messages should not occur here, and indicate an error in the software.
                                    Please contact your system administrator, providing the orginal resources, as well as this report.
                                </p>
                            </xsl:if>
                        </div>
                        <xsl:for-each-group select="$messages" group-by="src">
                            <div>
                                <h1>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </h1>
                                <table>
                                    <thead>
                                        <tr class="tableHeader">
                                            <td>Type</td>
                                            <td>Element</td>
                                            <td>Message</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="current-group()">
                                            <tr class="{type}">
                                                <td><xsl:value-of select="type"/></td>
                                                <td><xsl:value-of select="name"/></td>
                                                <td><xsl:value-of select="text"/></td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </xsl:for-each-group>
                    </content>
                </page>
            </xsl:if>
            
            <!-- generated overview of configuration -->
            <xsl:apply-templates select="." mode="doc-config"/>
            
            <!-- generated overview of parameters -->
            <xsl:apply-templates select="." mode="doc-parameters"/>
            
        </report>
    </xsl:template>
    
</xsl:stylesheet>
