<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2report-versions-common.xsl 7299 2015-11-10 11:31:12Z arjan $ 
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
    
    <!-- Version info is in a separate file -->
    
    <xsl:variable name="empty">--</xsl:variable>
    <xsl:variable name="history-doc" select="imf:document(imf:get-config-string('properties','WORK_HISTORY_FILE'))"/>
    <xsl:variable name="start-history-at" select="imf:get-config-string('cli','starthistory')"/>
    <xsl:variable name="release-to-public" select="imf:get-config-string('appinfo','task') eq 'release'"/>
    
    <!-- 
        Determine the date from which to show the changes. 
        This is any date after the release date of the previous version of this application. 
        This date is used as the basis for all listings. 
        
        Note that a more encompassing version history can be obtained.
        The larger version history is a Imvertor parameter -starthistoryat, and passed as $start-history-at
        
    --> 
    
    <xsl:variable name="all-application-versions" select="$history-doc/imvert-history:versions/imvert-history:variants/imvert-history:variant[imvert-history:variant-name=$application-package-name]"/>
    <xsl:variable name="this-application-version" select="$all-application-versions[last()]"/>
    <xsl:variable name="this-application-release" select="($this-application-version//imvert-history:rev-date)[1]"/>
    <xsl:variable name="prev-application-version" select="$all-application-versions[last() - 1]"/>
    <xsl:variable name="prev-application-release" select="($prev-application-version//imvert-history:rev-date)[last()]"/>
    <xsl:variable name="history-start-release" select="if ($prev-application-release) then $prev-application-release else '00000000'"/>
   
</xsl:stylesheet>
