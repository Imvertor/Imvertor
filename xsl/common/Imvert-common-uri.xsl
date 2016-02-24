<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert-common-uri.xsl 7176 2015-07-23 15:38:34Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!--
        return the parts of an uri passed as elements: 
        <protocol>  e.g. http
        <server> e.g. www.armatiek.nl
        <path> e.g. projecten.html
        
        Access as e.g. imf:get-uri-parts("http://www.armatiek.nl/projecten.html")/path
    -->
    <xsl:function name="imf:get-uri-parts" as="element()*">
        <xsl:param name="uri" as="xs:string?"/>
        <xsl:if test="$uri">
            <xsl:variable name="uri-parts" select="tokenize($uri,'/')"/>
            <!-- 1 http://abc -->
            <!-- 2 uri:abc -->
            <!-- 3 /abc -->
            <xsl:variable name="type" select="
                if ($uri-parts[2]='' and ends-with($uri-parts[1],':')) then '1' 
                else if (contains($uri-parts[1],':')) then '2'
                else '3'"/>
            <xsl:choose>
                <xsl:when test="$type='1'">
                    <xsl:sequence select="imf:get-uri-parts-elements($uri-parts[1],$uri-parts[3],string-join(subsequence($uri-parts,4),'/'))"></xsl:sequence>
                </xsl:when>
                <xsl:when test="$type='2'">
                    <xsl:sequence select="imf:get-uri-parts-elements(substring-before($uri-parts[1],':'),'',concat(substring-after($uri-parts[1],':'),string-join(subsequence($uri-parts,2),'/')))"/>
                </xsl:when>
                <xsl:when test="$type='3'">
                    <xsl:sequence select="imf:get-uri-parts-elements('','',string-join($uri-parts,'/'))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
      </xsl:function>
    
    <xsl:function name="imf:get-uri-parts-elements" as="element()*">
        <xsl:param name="protocol"/>
        <xsl:param name="server"/>
        <xsl:param name="path"/>
        <uri>
            <protocol xmlns="">
                <xsl:value-of select="$protocol"/>
            </protocol>
            <server xmlns="">
                <xsl:value-of select="$server"/>
            </server>
            <path xmlns="">
                <xsl:value-of select="$path"/>
            </path>
        </uri>
    </xsl:function>
    
 </xsl:stylesheet>
