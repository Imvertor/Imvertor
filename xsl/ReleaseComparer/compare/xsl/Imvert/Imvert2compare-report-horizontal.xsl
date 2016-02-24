<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2compare-report-horizontal.xsl 7266 2015-09-17 12:42:54Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"

    exclude-result-prefixes="#all" 
    version="2.0">
    
    <xsl:import href="Imvert2compare-common.xsl"/>
    
    <xsl:variable name="ctrl-name-map" select="document($ctrl-name-mapping-filepath)/maps/map" as="element()*"/>
    <xsl:variable name="test-name-map" select="document($test-name-mapping-filepath)/maps/map" as="element()*"/>
    
    <xsl:template name="fetch-comparison-report">
        <page>
            <title>Release comparison</title>
            <info>
                <xsl:value-of select="concat('(', count(/imvert:report/imvert:diffs/imvert:diff),' differences)')"/>
            </info>
            <content>
                <div class="intro">
                    <p>
                        This table show all differences between two versions of an Imvert XML:
                        <ul>
                            <li>
                                Control: The previous release.
                            </li>
                            <li>
                                Test: the current release. 
                            </li>
                        </ul> 
                    </p>
                </div>   
                <xsl:choose>
                    <xsl:when test="exists(/imvert:report/imvert:diffs)">
                        <table class="compare">
                            <tr class="tableHeader"        >
                                <td>Package</td>
                                <td>Class</td>
                                <td>Attrib/Assoc</td>
                                <td>Property</td>
                                <td>Explain</td>
                                <td>LVL</td>
                                <td>Change</td>
                                <td>Control</td>
                                <td>Test</td>
                            </tr>
                            <xsl:apply-templates select="/imvert:report" mode="diffs">
                                <xsl:with-param name="level" select="'user'"/>
                            </xsl:apply-templates>
                        </table>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>No differences found!</p>
                    </xsl:otherwise>
                </xsl:choose>
            </content>    
        </page>
    </xsl:template>
    
    <xsl:template match="imvert:report" mode="diffs">
        <xsl:param name="level"/>
        
        <xsl:for-each select="imvert:diffs/imvert:diff[imvert:level = $level]">
            <xsl:sort select="imvert:compos"/>
            <xsl:variable name="compos" select="imvert:compos"/>
            <xsl:variable name="orig-ctrl" select="$ctrl-name-map[@elm=$compos]/@orig"/>
            <xsl:variable name="orig-test" select="$test-name-map[@elm=$compos]/@orig"/>
            <xsl:variable name="orig" select="if (exists($orig-ctrl)) then $orig-ctrl[1] else $orig-test[1]"/>
            <xsl:variable name="tokens" select="tokenize($orig,'\.')"/>
            <xsl:variable name="info" select="key('imvert-compare-config',imvert:type,$imvert-compare-config-doc)[1]"/>
            
            <xsl:sequence select="imf:debug(concat('Reporting on ', $orig))"/>
            <tr>
                <xsl:if test="$info/../@level='system'">
                    <xsl:attribute name="class">cmp-system</xsl:attribute>
                </xsl:if>
                <td>
                    <xsl:value-of select="$tokens[1]"/>
                </td>
                <td>
                    <xsl:value-of select="$tokens[2]"/>
                </td>
                <td>
                    <xsl:value-of select="$tokens[3]"/>
                </td>
                <td>
                    <xsl:variable name="type" select="imvert:type"/>
                    <xsl:variable name="orig-tv-ctrl" select="$ctrl-name-map[@elm=$type]/@orig"/>
                    <xsl:variable name="orig-tv-test" select="$test-name-map[@elm=$type]/@orig"/>
                    <xsl:variable name="orig-tv" select="if (exists($orig-tv-ctrl)) then $orig-tv-ctrl else $orig-tv-test"/>
                    <xsl:value-of select="if (starts-with($type,'tv_')) then $orig-tv else $type"/>
                </td>
                <td>
                    <xsl:value-of select="$info"/>
                </td>
                <td>
                    <xsl:value-of select="($info/../@level,'model')[1]"/>
                </td>
                <td>
                    <xsl:value-of select="imvert:change"/>
                </td>
                <td>
                    <xsl:if test="imvert:change = 'value'">
                        <xsl:attribute name="class">code</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="imvert:ctrl"/>
                </td>
                <td>
                    <xsl:if test="imvert:change = 'value'">
                        <xsl:attribute name="class">code</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="imvert:test"/>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
