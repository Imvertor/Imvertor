<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: XmiTranslator-report.xsl 7238 2015-09-07 10:00:21Z arjan $ 
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
    
    <xsl:variable name="stylesheet">XmiTranslator-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: XmiTranslator-report.xsl 7238 2015-09-07 10:00:21Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <xsl:variable name="messages" select="$configuration//messages/message[src='XMI1Imvert']"/>
        <xsl:variable name="errors" select="$messages[type=('FATAL','ERROR')]"/>
        
        <report>
            <step-display-name>XMI translator</step-display-name>
            <status>
                <xsl:sequence select="if (count($errors) eq 0) then 'succeeds' else 'fails'"/>
            </status>
            <summary>
                <info label="XMI Translation">
                    <xsl:sequence select="imf:report-label('Status', concat(count($errors), ' errors'))"/>
                </info>
            </summary>
            <xsl:if test="exists($messages)">
                <page>
                    <title>XML translation report</title>
                    <info>
                        <xsl:value-of select="concat('(', count($errors),' errors)')"/>
                    </info>
                    <content>
                        <div>
                            <h1>XMI processing info</h1>
                            <table>
                                <thead>
                                    <tr class="tableHeader">
                                        <td>Type</td>
                                        <td>Element</td>
                                        <td>Message</td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="$messages">
                                        <tr class="{type}">
                                            <td><xsl:value-of select="type"/></td>
                                            <td><xsl:value-of select="name"/></td>
                                            <td><xsl:value-of select="text"/></td>
                                        </tr>
                                    </xsl:for-each>
                                </tbody>
                            </table>
                        </div>
                    </content>
                </page>
            </xsl:if>
      </report>
    </xsl:template>

</xsl:stylesheet>
