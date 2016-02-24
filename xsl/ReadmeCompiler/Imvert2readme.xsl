<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2readme.xsl 7257 2015-09-14 11:58:30Z arjan $ 
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

    <xsl:param name="xsd-files-generated"/>
    <xsl:param name="etc-files-generated"/>
   
    <xsl:variable name="stylesheet">Imvert2readme</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2readme.xsl 7257 2015-09-14 11:58:30Z arjan $</xsl:variable>

    <xsl:variable name="RELEASENAME" select="$application-package-release-name"/>
    <xsl:variable name="EAVERSION" select="/imvert:packages/imvert:exporter"/>
    <xsl:variable name="APPLICATIONNAME" select="$application-package-name"/>
    <xsl:variable name="CONTACTEMAIL" select="imf:get-config-string('cli','contactemail','(unspecified)')"/>
    <xsl:variable name="CONTACTURL" select="imf:get-config-string('cli','contacturl','(unspecified)')"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    Readme - <xsl:value-of select="$application-package-name"/>
                </title>
            </head>
            <body>
                <h2>
                    Readme - <xsl:value-of select="$application-package-name"/>
                </h2>
                <p> Dit is informatie bij de release met de naam <br/>
                    <b><xsl:value-of select="$RELEASENAME"/></b>. </p>
                <p> Dit bestand is opgebouwd uit de volgende folders: </p>
                <ul>
                    <li> Folder <a href="doc/index.html">/doc</a> bevat de systeemdocumentatie. Systeem documentatie betreft een rapportage van het aangeboden UML model vanuit het perspectief van de omzetting naar een XML schema. </li>
                    <xsl:if test="$uml-report-available = 'true'">
                        <li> Folder <a href="uml/report/index.html">/uml</a> bevat een d.m.v. <xsl:value-of select="$EAVERSION"/> samengesteld HTML report. Dit is informatie die ontleend is aan de applicatie en de applicaties waar het op teruggaat. </li>
                    </xsl:if>
                    <xsl:variable name="xsd-files" select="tokenize($xsd-files-generated,';')"/>
                    <xsl:if test="exists($xsd-files)">
                        <li> Folder /xsd bevat het gegenereerde schema, en de schema’s waar dit naar verwijst. Het gegenereerde schema voor de applicatie zelf zit in de folder met de naam "<xsl:value-of select="$APPLICATIONNAME"/>". Hierin zijn alle gegenereerde schema’s, per package, opgenomen in eigen folders met de naam van het package. Daarin is het (enige) schema geplaatst. Ook worden voor referentie elementen aparte schema’s opgesteld met de naam X-ref, wanneer van toepassing.
                            <pre>
                                <xsl:for-each select="$xsd-files">
                                    <xsl:if test="ends-with(.,'.xsd')">
                                        <a href="{.}"><xsl:value-of select="."/></a><br/>
                                    </xsl:if>
                                </xsl:for-each>
                            </pre>
                        </li>
                    </xsl:if>
                    <xsl:variable name="etc-files" select="tokenize($etc-files-generated,';')"/>
                    <xsl:if test="exists($etc-files)">
                        <li> Folder /etc bevat (afhankelijk van de status van de applicatie) het samengestelde EAP sjabloon, Imvert informatie over de historie, en Imvert informatie over het UML model. Wie een beetje handig is met XML kan deze bestanden oppikken en er geheel eigen reports op draaien. 
                            <pre>
                                <xsl:for-each select="$etc-files">
                                    <xsl:if test="contains(.,'.')">
                                        <a href="{.}"><xsl:value-of select="."/></a><br/>
                                    </xsl:if>
                                </xsl:for-each>
                            </pre>
                        </li>
                    </xsl:if>
                </ul>
                <xsl:if test="normalize-space($CONTACTURL)">
                    <p> Kijk verder op <a href="http://{$CONTACTURL}"><xsl:value-of select="$CONTACTURL"/></a>. </p>
                </xsl:if>
                <xsl:if test="normalize-space($CONTACTEMAIL)">
                    <p> Reacties op de vorm van deze release zijn welkom. Neem contact op met <a href="{concat('mailto:',$CONTACTEMAIL)}"><xsl:value-of select="$CONTACTEMAIL"/></a>. </p>
                </xsl:if>
                <hr/>
                <i><xsl:value-of select="imf:create-markers()"/></i>
            </body>
        </html>
    </xsl:template>

    <xsl:function name="imf:create-markers">
        <xsl:value-of select="string-join(
            ('#ph:', imf:get-config-string('appinfo','phase'), 
            '#ts:', imf:get-config-string('appinfo','task'), 
            '#er:', imf:get-config-string('appinfo','error-count'), 
            '#re:', imf:get-config-string('appinfo','release'), 
            '#dt:', imf:get-config-string('run','start'), 
            '#id:', imf:get-config-string('system','generation-id'), 
            '#'),'')"/>
    </xsl:function>
</xsl:stylesheet>
