<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert-common-validation.xsl 7409 2016-02-06 07:31:41Z arjan $ 
-->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	
	xmlns:imvert="http://www.imvertor.org/schema/system"
	xmlns:ext="http://www.imvertor.org/xsl/extensions"
	xmlns:imf="http://www.imvertor.org/xsl/functions"
	
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:variable name="validate-tv-assignment" select="imf:boolean(imf:get-config-string('cli','validatetvassignment'))"/> 
	<xsl:variable name="validate-tv-missing" select="imf:boolean(imf:get-config-string('cli','validatetvmissing'))"/> 
	
	<xsl:function name="imf:report-validation" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="type" as="xs:string"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:param name="parms" as="item()*"></xsl:param>
	
		<xsl:if test="$condition">
			<xsl:sequence select="imf:msg($this,$type,$message,$parms)"/>
		</xsl:if>
	</xsl:function>
	
	<xsl:function name="imf:report-info" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'INFO',$message,())"/>
	</xsl:function>
	<xsl:function name="imf:report-info" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:param name="parms" as="item()*"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'INFO',$message,$parms)"/>
	</xsl:function>
	
	<xsl:function name="imf:report-hint" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'HINT',$message,())"/>
	</xsl:function>
	<xsl:function name="imf:report-hint" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:param name="parms" as="item()*"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'HINT',$message,$parms)"/>
	</xsl:function>
	<xsl:function name="imf:report-warning" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'WARN',$message,())"/>
	</xsl:function>
	<xsl:function name="imf:report-warning" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:param name="parms" as="item()*"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'WARN',$message,$parms)"/>
	</xsl:function>
	<xsl:function name="imf:report-error" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'ERROR',$message,())"/>
	</xsl:function>
	<xsl:function name="imf:report-error" as="node()*">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="condition" as="item()*"/>
		<xsl:param name="message" as="xs:string"/>
		<xsl:param name="parms" as="item()*"/>
		<xsl:sequence select="imf:report-validation($this,$condition,'ERROR',$message,$parms)"/>
	</xsl:function>
	
	<!-- 
		return the tagged value of empty sequence when that tagged value is not found. If a value is passed, check if the value is the same.
	-->
	<xsl:function name="imf:get-tagged-value" as="xs:string?">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="tv-name" as="xs:string"/>
		<xsl:param name="tv-value" as="xs:string?"/>
		<xsl:variable name="tv" select="$this/imvert:tagged-values/imvert:tagged-value[imvert:name = imf:get-normalized-name($tv-name,'tv-name')]"/>
		<xsl:variable name="value" select="string($tv/imvert:value)"/>
		<xsl:choose>
			<xsl:when test="empty($tv)">
				<xsl:sequence select="()"/>
			</xsl:when>
			<xsl:when test="empty($tv-value)">
				<xsl:value-of select="$value"/>
			</xsl:when>
			<xsl:when test="$value = $tv-value">
				<xsl:sequence select="$value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="imf:get-tagged-value" as="xs:string?">
		<xsl:param name="this" as="node()"/>
		<xsl:param name="tv-name" as="xs:string"/>
		<xsl:sequence select="imf:get-tagged-value($this,$tv-name,())"/>
	</xsl:function>
	
</xsl:stylesheet>