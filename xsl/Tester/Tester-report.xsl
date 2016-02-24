<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Tester-report.xsl 7396 2016-01-26 13:02:55Z arjan $ 
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
     Reporting stylesheet for the Tester step.
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <xsl:variable name="stylesheet">Tester-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Tester-report.xsl 7396 2016-01-26 13:02:55Z arjan $</xsl:variable>
    
    <xsl:output indent="no"/>
    
    <!-- 
        context document is the parms.xml file. 
    -->
    <xsl:template match="/config">
        <report>
            <step-display-name>Tester</step-display-name>
            <summary>
                <info label="my label">My value</info>
            </summary>
            <page>
                <title>Title of the first Tester reporting page</title>
                <content>
                    <div>
                        <h1>First report page</h1>
                        <p>This is the report on the step Tester, the first "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                    <div>
                        <h1>Second report page</h1>
                        <p>This is the report on the step Tester, the second "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                </content>
            </page>
            <page>
                <title>Title of the second Tester reporting page</title>
                <content>
                    <div>
                        <h1>First report page</h1>
                        <p>This is the report on the step Tester, the first "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                    <div>
                        <h1>Second report page</h1>
                        <p>This is the report on the step Tester, the second "division" </p>
                        <xsl:call-template name="show-some-info"/>
                    </div>
                </content>
            </page>
        </report>
    </xsl:template>

    <xsl:template name="show-some-info">
        <table>
            <xsl:for-each select="/config/messages/message">
                <tr>
                    <td><xsl:value-of select="type"/></td>
                    <td><xsl:value-of select="text"/></td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
</xsl:stylesheet>
