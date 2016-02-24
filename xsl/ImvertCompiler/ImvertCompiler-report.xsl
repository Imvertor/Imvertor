<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: ImvertCompiler-report.xsl 7424 2016-02-15 10:58:15Z arjan $ 
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
         Reporting stylesheet for the Apc modifier
    -->
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-derivation.xsl"/>
    <xsl:import href="../common/Imvert-common-report.xsl"/>
    
    <xsl:import href="Imvert2report-quickview.xsl"/>
    <xsl:import href="Imvert2report-compactview.xsl"/>
    <xsl:import href="Imvert2report-typelisting.xsl"/>
    <xsl:import href="Imvert2report-valuelists.xsl"/>
    <xsl:import href="Imvert2report-state.xsl"/>
    <xsl:import href="Imvert2report-documentation.xsl"/>
    <xsl:import href="Imvert2report-identification.xsl"/>
    <xsl:import href="Imvert2report-conceptualschemas.xsl"/>
    <xsl:import href="Imvert2report-taggedvalues.xsl"/>
    <xsl:import href="Imvert2report-trace.xsl"/>
    
    <xsl:variable name="stylesheet">ImvertCompiler-report.xsl</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: ImvertCompiler-report.xsl 7424 2016-02-15 10:58:15Z arjan $</xsl:variable>
    
    <xsl:template match="/config">
        <xsl:variable name="doc" select="imf:document(imf:get-config-string('properties','WORK_EMBELLISH_FILE'))"/>
        <xsl:variable name="packages" select="$doc/imvert:packages/imvert:package[not(imvert:ref-master)]"/>
        <report>
            <step-display-name>Imvert compiler</step-display-name>
            <summary>
                <info label="User defined constructs">
                    <xsl:sequence select="imf:report-label('Packages', count($packages))"/>
                    <xsl:sequence select="imf:report-label('classes', count($packages/imvert:class))"/>
                </info>
            </summary>
            <xsl:apply-templates select="$doc/imvert:packages" mode="quickview"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="compactview"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="typelisting"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="valuelists"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="state"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="documentation"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="tv"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="identification"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="conceptualschemas"/>
            <xsl:apply-templates select="$doc/imvert:packages" mode="trace"/>
            
        </report>
    </xsl:template>

    
</xsl:stylesheet>
