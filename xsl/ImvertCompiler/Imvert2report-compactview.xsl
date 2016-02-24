<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2report-compactview.xsl 7266 2015-09-17 12:42:54Z arjan $ 
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
        Compile Base info. This is:
        position | Name | Property | Type | minocc | maxOcc |stereotype 
    -->
    <xsl:template match="imvert:packages" mode="compactview">
        <page>
            <title>Compact view</title>
            <content>
                <div>
                    <div class="intro">
                        <p>
                            This is a technical overview ofd all constructs, suitable for import into Excel.
                        </p>
                    </div>
                    <table>
                        <xsl:sequence select="imf:create-table-header('pos:10,property:40,type:40,min:5,max:5,stereotype:10')"/>
                        <xsl:apply-templates select=".//imvert:class[not(imvert:ref-master)]" mode="compactview"/>
                    </table>
                </div>
            </content>
        </page>
    </xsl:template>
    
    <xsl:template match="imvert:class" mode="compactview">
        <tr>
            <td/>
            <td>
                <xsl:sequence select="imf:get-construct-name(.)"/>
            </td>
            <td/>
            <td>
                <xsl:value-of select="imvert:min-occurs"/>
            </td>   
            <td>
                <xsl:value-of select="imvert:max-occurs"/>
            </td>   
            <td>
                <xsl:value-of select="string-join(imvert:stereotype,' ')"/>
            </td>
        </tr>
        <xsl:choose>
            <xsl:when test="imvert:attributes/imvert:attribute|imvert:associations/imvert:association">
                <xsl:for-each select="imvert:attributes/imvert:attribute|imvert:associations/imvert:association">
                    <xsl:sort select="xs:integer(imvert:position)"/>
                    <xsl:apply-templates select="." mode="compactview"/>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="imvert:attribute" mode="compactview">
        <xsl:apply-templates select="." mode="compactview-property"/>   
    </xsl:template>
    <xsl:template match="imvert:association" mode="compactview">
        <xsl:apply-templates select="." mode="compactview-property"/>   
    </xsl:template>
    
    <xsl:template match="*" mode="compactview-property">
        <tr>
            <td>
                <xsl:value-of select="imvert:position"/>
            </td>
            <td>
                <xsl:sequence select="imf:get-construct-name(.)"/>
            </td>
            <td>
                <xsl:value-of select="@type-display-name"/>
                <xsl:if test="imvert:baretype != imvert:type-name"> (<xsl:value-of select="imvert:baretype"/>)</xsl:if>
            </td>   
            <td>
                <xsl:value-of select="imvert:min-occurs"/>
            </td>   
            <td>
                <xsl:value-of select="imvert:max-occurs"/>
            </td>   
            <td>
                <xsl:value-of select="string-join(imvert:stereotype,' ')"/>
            </td>
        </tr>
     </xsl:template>

    <xsl:template match="*|text()" mode="compactview">
        <xsl:apply-templates mode="compactview"/>
    </xsl:template>  
   
</xsl:stylesheet>
