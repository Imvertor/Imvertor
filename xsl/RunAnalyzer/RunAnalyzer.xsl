<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: RunAnalyzer.xsl 7262 2015-09-16 14:23:48Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 

    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all" 
    version="2.0">

    <xsl:import href="../common/Imvert-common.xsl"/>

    <xsl:variable name="stylesheet">RunAnalyzer</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: RunAnalyzer.xsl 7262 2015-09-16 14:23:48Z arjan $</xsl:variable>

    <xsl:variable name="errors" select="$configuration/config/messages/message[type=('ERROR','FATAL')]"/>
    <xsl:variable name="warnings" select="$configuration/config/messages/message[type='WARN']"/>
    <xsl:variable name="message" select="($errors,$warnings)[1]/text"/>
    
    <xsl:variable name="status-message" select="
        if (empty($errors) and empty($warnings)) 
        then 'This release is fully conformant.' 
        else 
            if (exists($errors)) 
            then 
                if (exists($warnings)) 
                then 'Errors and warnings found. This release should not be distributed.'
                else 'Errors found. This release should not be distributed.'
            else 'Warnings found. Some issues should be resolved before distribution.'"/>
    
    <xsl:template match="/">
        <xsl:sequence select="imf:set-config-string('appinfo','error-count',string(count($errors)))"/>
        <xsl:sequence select="imf:set-config-string('appinfo','warning-count',string(count($warnings)))"/>
        <xsl:sequence select="imf:set-config-string('appinfo','status-message',$status-message)"/>
    </xsl:template>

</xsl:stylesheet>
