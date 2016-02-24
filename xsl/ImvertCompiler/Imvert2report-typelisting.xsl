<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2report-typelisting.xsl 7266 2015-09-17 12:42:54Z arjan $ 
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
        Compile a list of all types, associated with all attributes/relations of that type
    -->
   
    <xsl:template match="imvert:packages" mode="typelisting">
        <page>
            <title>Type listing</title>
            <content>
                <div>
                    <div class="intro">
                        <p>
                            This is the overview of all types (value types and classes), and their occurrence.
                        </p>
                        <p>
                            Per type the following is indicated:
                        </p>
                        <ul>
                            <li>P::C in which P = package C = class/type</li>
                            <li>Any property of this type, in the form of P::C.p in which P = package C = class, p = property</li>
                        </ul>
                    </div>
                    <table>
                        <xsl:sequence select="imf:create-table-header('type:50,properties of this type:50')"/>
                        <xsl:variable name="types" as="node()*">
                            <xsl:apply-templates select="//imvert:type-name[not(ancestor::imvert:package/imvert:config-external)]" mode="typelisting-fetch"/>
                        </xsl:variable>
                        <xsl:for-each-group select="$types" group-by="concat(@tp,@tn,@btn)">
                            <xsl:sort select="concat(@tp,@tn,@btn)"/>
                            <xsl:for-each select="current-group()">
                                <xsl:sort select="@cp"/>
                                <xsl:sort select="@cn"/>
                                <tr>
                                    <td>
                                        <xsl:if test="position()=1">
                                            <xsl:sequence select="imf:compile-construct-name(@tp,@tn,'',@btn)"/>
                                        </xsl:if>
                                    </td>
                                    <td>
                                        <xsl:sequence select="imf:compile-construct-name(@cp,@cn,@rn,@rt)"/>
                                    </td>
                                </tr>
                            </xsl:for-each>               
                        </xsl:for-each-group>
                    </table>
                </div>
            </content>
        </page>
    </xsl:template>
    
    <xsl:template match="imvert:type-name" mode="typelisting-fetch">
        <xsl:variable name="type-name" select="."/>
        <xsl:variable name="baretype-name" select="../imvert:baretype"/>
        <xsl:variable name="type-package" select="../imvert:type-package"/>
        <xsl:variable name="relation-type" select="if (local-name(..)='attribute') then 'attrib' else 'assoc'"/>
        <xsl:variable name="relation-name" select="../imvert:name"/>
        <xsl:variable name="class-name" select="../../../imvert:name"/>
        <xsl:variable name="class-package" select="../../../../imvert:name"/>
        
        <xsl:variable name="t" select="if ($baretype-name != $type-name) then concat(' (',$baretype-name,')') else ''"/>
        <type xmlns=""
            cp="{$class-package}"
            cn="{$class-name}"
            btn="{$baretype-name}"
            tp="{$type-package}"
            tn="{$type-name}"
            rn="{$relation-name}"
            rt="{$relation-type}"
            name="{concat($type-package,':',$type-name,$t)}" rel="{concat($class-package,':',$class-name,'.',$relation-name)}" prop="{$relation-type}"/>
    </xsl:template>    
    
</xsl:stylesheet>
