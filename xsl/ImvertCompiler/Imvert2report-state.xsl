<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2report-state.xsl 7266 2015-09-17 12:42:54Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 

    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all" 
    version="2.0">

    <!-- 
      Report on the state of all packages, as well as the enrire release.
    -->
    
    <xsl:template match="imvert:packages" mode="state">
        <page>
            <title>State</title>
            <content>
                <div>
                    <div class="intro">
                        <p>
                            This overview lists all packages, the namespace URI, and version:
                        </p>
                        <ul>
                            <li>Name: The technical name of the package</li>
                            <li>Package: The URI of the package, and the resulting namespace (including the release). This links to an internet location where more info can be found.</li>
                            <li>Versions: The subversion reference (revision number and date), if available, as well as the combination of version and phase.</li>
                        </ul>
                    </div>
                    <table>
                        <xsl:sequence select="imf:create-table-header('name:20,package:60,versions:20')"/>
                        <xsl:apply-templates select="imvert:package" mode="state"/>
                    </table>
                </div>
            </content>
        </page>
    </xsl:template>
    
    <!--
        Return state of this package 
    -->
    <xsl:template match="imvert:package" mode="state">
        <tr>
            <td>
                <b>
                    <xsl:value-of select="imvert:name"/>
                </b>
            </td>
            <td>
                <b>
                    <a>
                        <xsl:attribute name="href" select="imvert:namespace"/>
                        <xsl:value-of select="imvert:namespace"/>
                    </a>
                </b>
            </td>
            <td>
                <xsl:value-of select="concat('SVN ', imvert:svn-revision, ' (',imvert:svn-date,')')"/>
            </td>
        </tr>
            <xsl:for-each select="(., .//imvert:base)">
                <tr>
                    <xsl:variable name="namespace" select="concat(imvert:namespace,'/v',imvert:release)"/>
                    <td/>
                    <td>
                        <a>
                            <xsl:attribute name="href" select="$namespace"/>
                            <xsl:value-of select="$namespace"/>
                        </a>
                    </td>
                    <td>
                        <xsl:value-of select="concat(imvert:version,' (',imvert:phase,')')"/>
                    </td>
                </tr>
            </xsl:for-each>
        <xsl:apply-templates select="imvert:package" mode="state"/>
    </xsl:template>

       
</xsl:stylesheet>
