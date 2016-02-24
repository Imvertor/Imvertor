<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2report-trace.xsl 7266 2015-09-17 12:42:54Z arjan $ 
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
        Compile Tracing info. This is:
        type | client-name+link | client-package | client-class | client-property | supplier-name+link |supplier-package | supplier-class | supplier-property 
        
        context document: imvert:layers-set
    -->
    
    <xsl:variable name="derivationtree" select="imf:document($derivationtree-file-url)"/>
    <xsl:variable name="pairs" select="$derivationtree/imvert:layers-set/imvert:layer"/>

    <xsl:variable name="model-is-traced" select="imf:boolean(imf:get-config-string('cli','modelistraced'))"/>
    
    <xsl:template match="imvert:packages" mode="trace">
        <page>
            <title>Derivation Traces</title>
            <content>
                <div>
                    <div class="intro">
                        <p>
                            This is a technical overview of all traces explicitly created between classes, attributes and associations. 
                        </p>
                        <p>
                            The full name of the construct is show (Package::Class.property), along with the ID. Each column represents a next derivation model.
                        </p>
                        <p>
                            Possible errors reported are 1/ recursion when an object traces an object already traced, 2/ missing suppliers, where a trace is set but the traced construct is not available.
                        </p>
                    </div>
                    <table>
                        <!-- <xsl:sequence select="imf:create-table-header('type:10,client:10,package:10,class:10,property:10,supplier:10,package:10,class:10,property:10')"/> -->
                        <xsl:variable name="h" as="xs:string*">
                            <xsl:for-each select="$pairs[1]/imvert:supplier">
                                <xsl:value-of select="@application"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="colwidth" select="90 div count($pairs[1]/imvert:supplier)"/>
                        <xsl:variable name="h2" select="string-join(($h,''),concat(':',$colwidth,','))"/>
                        <xsl:variable name="h3" select="concat('type:10,',$h2)"/>
                       <xsl:sequence select="imf:create-table-header($h3)"/>    
                        <xsl:apply-templates select="$pairs/imvert:supplier[1]" mode="trace"/>
                    </table>
                </div>
            </content>
        </page>
    </xsl:template>
 
    <xsl:template match="imvert:supplier" mode="trace">
      <xsl:apply-templates select="*" mode="trace"/>
    </xsl:template>
    
    <xsl:template match="imvert:class" mode="trace">
        <tr>
            <td>
                <xsl:value-of select="local-name(.)"/>
            </td>
            <xsl:sequence select="imf:get-trace-documentation-columns(.)"/>
        </tr>
        <xsl:apply-templates mode="trace"/>
    </xsl:template>
    
    <xsl:template match="imvert:attribute" mode="trace">
        <tr>
            <td>&#160;&#8212;Attribute</td>
            <xsl:sequence select="imf:get-trace-documentation-columns(.)"/>
        </tr>
        <xsl:apply-templates mode="trace"/>
    </xsl:template>
    <xsl:template match="imvert:association" mode="trace">
        <tr>
            <td>&#160;&#8212;Association</td>
            <xsl:sequence select="imf:get-trace-documentation-columns(.)"/>
        </tr>
        <xsl:apply-templates mode="trace"/>
    </xsl:template>
    
    
    <xsl:template match="*|text()" mode="trace">
        <xsl:apply-templates mode="trace"/>
    </xsl:template>  
    
    <xsl:function name="imf:get-trace-documentation-columns">
        <xsl:param name="client-construct"/>
        
        <xsl:variable name="layers" select="imf:get-construct-in-all-layers($client-construct,true(),$model-is-traced)"/>
        <xsl:for-each select="$layers/*">
            <td>
                <xsl:choose>
                    <xsl:when test="self::error">
                        <span class="error">
                            <xsl:value-of select="@type"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@display-name"/>
                    </xsl:otherwise>
                </xsl:choose>
                <span class="tid">
                    <xsl:value-of select="imvert:id"/>
                </span>
            </td>
        </xsl:for-each>
    </xsl:function>
     
</xsl:stylesheet>
