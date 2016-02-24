<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: VERSIONS2merger.xsl 7379 2016-01-14 07:39:34Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    xmlns:imvert-history="http://www.imvertor.org/schema/history"

    exclude-result-prefixes="#all"
    version="2.0">

    <!-- 
        Context document is the dependencies file. 
        It references packages that must be merged, such that VERSIONS2Imvert
        can be applied to generate the history documentation
        
        The application's history is passed, 
        The history of the supplier is extracted from the applications folder.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <!-- path to history file for this application;  --> 
    <xsl:variable name="imvert-history-path" select="imf:file-to-url(imf:get-config-string('properties','WORK_HISTORY_FILE'))"/>

    <xsl:variable name="stylesheet">VERSIONS2merger</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: VERSIONS2merger.xsl 7379 2016-01-14 07:39:34Z arjan $</xsl:variable>

    <xsl:template match="/imvert:package-dependencies">
        <imvert-history:versions>
            <imvert-history:filter>
                <imvert-history:name>
                    <xsl:value-of select="$stylesheet"/>
                </imvert-history:name>
                <imvert-history:date>
                    <xsl:value-of select="current-dateTime()"/>
                </imvert-history:date>
                <imvert-history:version>
                    <xsl:value-of select="$stylesheet-version"/>
                </imvert-history:version>
            </imvert-history:filter>
            <imvert-history:variants>
                <xsl:apply-templates select="imvert:package"/>
            </imvert-history:variants>
        </imvert-history:versions>
    </xsl:template>
   
    <xsl:template match="imvert:package">
        <!-- fetch history of the client package (variant, application) -->
        <xsl:sequence select="imf:fetch($imvert-history-path)"/>
        <!-- fetch history of supplier if any -->
        <xsl:if test="normalize-space(@supplier-name) and @supplier-name!='#NONE'">
            <xsl:variable name="supplier">
                <!-- fetch history of the supplier package (base, variant) if any -->
                <xsl:sequence select="imf:fetch-supplier(@supplier-project, @supplier-name, @supplier-release)"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="not($supplier)">
                    <xsl:sequence select="imf:msg('ERROR','The application [1] is not available',imf:get-application-identifier(@supplier-project,@supplier-name,@supplier-release))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$supplier"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:function name="imf:fetch" as="element()*">
        <xsl:param name="url" as="xs:string"/>
        <xsl:variable name="history-imvert-file-exists" select="unparsed-text-available($url)"/>
        <xsl:choose>
            <xsl:when test="not($history-imvert-file-exists)">
                <xsl:sequence select="imf:msg('WARN','Cannot find history file for [1]',$url)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="history-imvert-file-document" select="imf:document($url)"/>
                <xsl:apply-templates select="$history-imvert-file-document/imvert-history:versions/imvert-history:filter" mode="content-copy"/>
                <xsl:for-each select="$history-imvert-file-document/imvert-history:versions/imvert-history:variants/imvert-history:variant">
                    <imvert-history:variant>
                        <imvert-history:version>
                            <xsl:value-of select="imvert-history:sheet-name"/>
                        </imvert-history:version>
                        <xsl:apply-templates select="*[not(self::imvert-history:version)]" mode="content-copy"/>
                    </imvert-history:variant>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="imf:fetch-supplier" as="element()*">
        <xsl:param name="project-name" as="xs:string"/>
        <xsl:param name="package-name" as="xs:string"/>
        <xsl:param name="package-release" as="xs:string"/>
        <xsl:variable name="history-imvert-file-url" select="imf:get-history-url($project-name,$package-name,$package-release)"/>
        <xsl:sequence select="imf:fetch($history-imvert-file-url)"/>
    </xsl:function>
    
    <xsl:template match="*" mode="content-copy">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="content-copy"/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:function name="imf:get-history-url" as="xs:string">
        <xsl:param name="project-name" as="xs:string"/>
        <xsl:param name="application-name" as="xs:string"/>
        <xsl:param name="application-release" as="xs:string"/>
        <xsl:value-of select="imf:file-to-url(concat($applications-folder-path,'/',$project-name,'/',$application-name,'/',$application-release,'/etc/',$application-name,'.history.imvert.xml'))"/>
    </xsl:function>
    
    <xsl:function name="imf:get-application-identifier" as="xs:string">
        <xsl:param name="project" as="xs:string"/>
        <xsl:param name="appname" as="xs:string"/>
        <xsl:param name="apprelease" as="xs:string?"/>
        <xsl:variable name="result" select="concat($project,':',$appname,':',$apprelease)"/>
        <xsl:value-of select="$result"/>
    </xsl:function>
</xsl:stylesheet>
