<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2XSD-KING-endproduct.xsl 3 2015-11-05 10:35:07Z ArjanLoeffen $ 
-->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:UML="omg.org/UML1.3" 
	xmlns:imvert="http://www.imvertor.org/schema/system" 
	xmlns:imf="http://www.imvertor.org/xsl/functions" 
	xmlns:imvert-result="http://www.imvertor.org/schema/imvertor/application/v20160201" 
	xmlns:BG="http://www.egem.nl/StUF/sector/bg/0310" 
	xmlns:metadata="http://www.kinggemeenten.nl/metadataVoorVerwerking" 
	xmlns:ztc="http://www.kinggemeenten.nl/ztc0310" 
	xmlns:stuf="http://www.egem.nl/StUF/StUF0301" 
	xmlns:imvert-ep="http://www.imvertor.org/schema/endproduct" 
	xmlns:ss="http://schemas.openxmlformats.org/spreadsheetml/2006/main" 
	version="2.0">
	
	<xsl:output indent="yes" method="xml" encoding="UTF-8"/>
	
	<xsl:variable name="stylesheet">Imvert2XSD-KING-create-endproduct-schema</xsl:variable>
	<xsl:variable name="stylesheet-version">$Id: Imvert2XSD-KING-create-endproduct-schema.xsl 1 2015-11-11 12:02:00Z RobertMelskens $</xsl:variable>
	
	<xsl:variable name="typeBericht" select="/imvert-ep:endproduct-structures/imvert-ep:message/@typeBericht"/>
	<xsl:variable name="berichtCode" select="/imvert-ep:endproduct-structures/imvert-ep:message/@berichtCode"/>

	<xsl:template match="/imvert:packages">
		<dummy>
			ZIE HET RESULTAAT VAN XML SCHEMA GENERATOR IN DE APPLICATIE DISTRIBUTIE
		</dummy>
	</xsl:template>
	
	<xsl:template match="imvert-ep:endproduct-structures">
		<xs:schema targetNamespace="http://www.egem.nl/StUF/sector/bg/0310" elementFormDefault="qualified" attributeFormDefault="unqualified">
			<xs:import namespace="http://www.egem.nl/StUF/StUF0301" schemaLocation="stuf0301.xsd"/>
			<xsl:apply-templates select="imvert-ep:message"/>
			<!--<xsl:for-each select="imvert-ep:message">
				<xsl:apply-templates select="imvert-ep:class" mode="berichtenstructuur">
					<xsl:with-param name="typeBericht" select="@typeBericht"/>
					<xsl:with-param name="berichtCode" select="@berichtCode"/>
					<xsl:with-param name="naam" select="@name"/>
				</xsl:apply-templates>
			</xsl:for-each>-->
			<!--<xsl:for-each select="imvert-ep:message">
				<xsl:apply-templates select="imvert-ep:class" mode="berichtencontent">
					<xsl:with-param name="typeBericht" select="@typeBericht"/>
					<xsl:with-param name="berichtCode" select="@berichtCode"/>
					<xsl:with-param name="naam" select="@name"/>
					<xsl:with-param name="toplevel" select="'yes'"/>
				</xsl:apply-templates>
			</xsl:for-each>-->
		</xs:schema>
	</xsl:template>

	<xsl:template match="imvert-ep:message">
		<xs:element name="{@name}">
			<xs:complexType>
				<xs:sequence>
					<xs:element name="stuurgegevens">
						<xs:complexType>
							<xs:sequence>
								<xsl:apply-templates select="imvert-ep:class/imvert-ep:associations/imvert-ep:class/imvert-ep:association[imvert-ep:name/@original='algemene stuurgegevens']" mode="stuurgegevens1"/>
								<xsl:apply-templates select="imvert-ep:class/imvert-ep:associations/imvert-ep:class/imvert-ep:association[imvert-ep:name/@original='zender stuurgegevens']" mode="stuurgegevens2"/>
								<xsl:apply-templates select="imvert-ep:class/imvert-ep:associations/imvert-ep:class/imvert-ep:association[imvert-ep:name/@original='ontvanger stuurgegevens']" mode="stuurgegevens3"/>
							</xs:sequence>
						</xs:complexType>				
					</xs:element>
					<xs:element name="parameters">
						<xs:complexType>
							<xs:sequence>
								<xsl:apply-templates select="imvert-ep:class/imvert-ep:attributes/imvert-ep:attribute"/>
							</xs:sequence>
						</xs:complexType>				
					</xs:element>
					<xsl:apply-templates select="imvert-ep:class/imvert-ep:attributes/imvert-ep:class[@packageType='Bericht']/imvert-ep:attribute[imvert-ep:name/@original='melding']"/>
					<xsl:apply-templates select="imvert-ep:class/imvert-ep:associations/imvert-ep:association" mode="content"/>
				</xs:sequence>
			</xs:complexType>
		</xs:element>
	</xsl:template>
	
	<xsl:template match="imvert-ep:association" mode="stuurgegevens1">
		<xsl:apply-templates select="imvert-ep:attributes/imvert-ep:class/imvert-ep:attribute" mode="stuurgegevens"/>		
	</xsl:template>
	
	<xsl:template match="imvert-ep:association" mode="stuurgegevens2">
		<xs:element name="zender">
			<xs:complexType>
				<xs:sequence>
					<xsl:apply-templates select="imvert-ep:attributes/imvert-ep:class/imvert-ep:attribute" mode="stuurgegevens"/>		
				</xs:sequence>
			</xs:complexType>
		</xs:element>				
	</xsl:template>

	<xsl:template match="imvert-ep:association" mode="stuurgegevens3">
		<xs:element name="ontvanger">
			<xs:complexType>
				<xs:sequence>
					<xsl:apply-templates select="imvert-ep:attributes/imvert-ep:class/imvert-ep:attribute" mode="stuurgegevens"/>		
				</xs:sequence>
			</xs:complexType>
		</xs:element>				
	</xsl:template>

	<xsl:template match="imvert-ep:attribute" mode="stuurgegevens">
		<xs:element name="{imvert-ep:name}">
			<xsl:attribute name="minOccurs" select="imvert-ep:min-occurs"/>
			<xsl:attribute name="maxOccurs" select="imvert-ep:max-occurs"/>
		</xs:element>		
	</xsl:template>

	<xsl:template match="imvert-ep:association" mode="content">
		<xsl:comment select="'match=imvert-ep:association mode=content'"/>
		<xsl:choose>
			<xsl:when test="@packageType='Bericht'">
				<xs:element name="{imvert-ep:name}" nillable="true" minOccurs="{imvert-ep:min-occurs}" maxOccurs="{imvert-ep:max-occurs}">
					<!--<xsl:if test="imvert-ep:attributes/imvert-ep:attribute or imvert-ep:associations/imvert-ep:association">-->
						<xs:complexType>
							<xs:sequence>
								<xsl:apply-templates select="imvert-ep:attributes"/>
								<xsl:apply-templates select="imvert-ep:associations"/>
							</xs:sequence>
						</xs:complexType>
					<!--</xsl:if>-->
				</xs:element>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template match="imvert-ep:attributes">
		<xsl:param name="alias"/>
		<xsl:param name="naam"/>
		<xsl:comment select="'match=imvert-ep:attributes nomode'"/>
		<xsl:apply-templates select="imvert-ep:class" mode="berichtenstructuur"/>
		<xsl:apply-templates select="imvert-ep:attribute">
			<xsl:with-param name="alias" select="$alias"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="imvert-ep:attribute">
		<xsl:param name="alias"/>
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="naam"/>
		<xsl:comment select="'match=imvert-ep:attribute nomode'"/>
		<xs:element name="{imvert-ep:name}" nillable="true" minOccurs="{imvert-ep:min-occurs}" maxOccurs="{imvert-ep:max-occurs}">
			<xsl:choose>
				<xsl:when test="imvert-ep:class">
					<xsl:apply-templates select="imvert-ep:class" mode="berichtencontent">
						<xsl:with-param name="typeBericht" select="@typeBericht"/>
						<xsl:with-param name="berichtCode" select="@berichtCode"/>
						<xsl:with-param name="naam" select="@name"/>
					</xsl:apply-templates>					
				</xsl:when>
				<xsl:when test="not(imvert-ep:type-package)">
					<xs:simpleType>
						<xs:restriction>
							<xsl:attribute name="base">
								<xsl:choose>
									<xsl:when test="imvert-ep:type-name = 'integer'">
										<xsl:value-of select="'xs:int'"/>
									</xsl:when>
									<xsl:when test="imvert-ep:type-name = 'char'">
										<xsl:value-of select="'xs:string'"/>
									</xsl:when>
									<xsl:when test="imvert-ep:type-name = 'datetime'">
										<xsl:value-of select="'xs:string'"/>
									</xsl:when>
									<xsl:when test="imvert-ep:type-name = 'boolean'">
										<xsl:value-of select="'xs:boolean'"/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="imvert-ep:max-length">
									<xs:maxLength>
										<xsl:attribute name="value" select="imvert-ep:max-length"/>
									</xs:maxLength>
								</xsl:when>
								<xsl:when test="imvert-ep:total-digits">
									<xs:totalDigits>
										<xsl:attribute name="value" select="imvert-ep:total-digits"/>
									</xs:totalDigits>
								</xsl:when>
							</xsl:choose>
						</xs:restriction>
					</xs:simpleType>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="imvert-ep:stereotype='enumeration'">
							<xs:simpleType>
								<xs:restriction base="xs:string">
									<xsl:apply-templates select="imvert-ep:attributes/imvert-ep:attribute" mode="enumerationType"/>
								</xs:restriction>
							</xs:simpleType>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="type" select="concat(imvert-ep:type-name,imvert-ep:max-length)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xs:element>
	</xsl:template>

	<xsl:template match="imvert-ep:class" mode="berichtenstructuur">
		<xsl:param name="withComplexType" select="'Yes'"/>
		<xsl:comment select="concat('match=imvert-ep:class mode=berichtenstructuur withComplexType=',$withComplexType)"/>
		<xsl:choose>
			<xsl:when test="not(.[name()!='imvert:class' and name()!='imvert:name'])">
				<xsl:comment select="'Robert1'"/>
				<xsl:apply-templates select="imvert-ep:attribute/imvert-ep:class" mode="berichtenstructuur">
					<xsl:with-param name="withComplexType" select="'Yes'"/>
				</xsl:apply-templates>			
			</xsl:when>
			<xsl:when test="@packageType='Bericht' and @stereotype='union' and (parent::imvert-ep:associations or parent::imvert-ep:attributes)">
				<xsl:comment select="'Robert2'"/>
				<xs:choice>
					<xsl:apply-templates select="imvert-ep:attribute/imvert-ep:class" mode="berichtenstructuur">
						<xsl:with-param name="withComplexType" select="'Yes'"/>
					</xsl:apply-templates>			
				</xs:choice>
			</xsl:when>
			<xsl:when test="@packageType='Bericht' and @stereotype='union' and (not(parent::imvert-ep:associations) and not(parent::imvert-ep:attributes))">
				<xsl:comment select="'Robert3'"/>
				<xs:complexType>
					<xs:choice>
						<xsl:apply-templates select="imvert-ep:attribute/imvert-ep:class" mode="berichtenstructuur">
							<xsl:with-param name="withComplexType" select="'Yes'"/>
						</xsl:apply-templates>			
					</xs:choice>
				</xs:complexType>
			</xsl:when>
			<xsl:when test="@packageType='Model' and $withComplexType='Yes'">
				<xsl:comment select="'Robert4'"/>
				<xs:sequence>
					<xsl:apply-templates select="imvert-ep:class" mode="berichtenstructuur">
						<xsl:with-param name="withComplexType" select="'Yes'"/>
					</xsl:apply-templates>			
					<xsl:apply-templates select="imvert-ep:attribute"/>							
					<xsl:apply-templates select="imvert-ep:attributes"/>							
					<xsl:apply-templates select="imvert-ep:associations"/>	
				</xs:sequence>		
			</xsl:when>
			<xsl:when test="@packageType='Model' and $withComplexType='No'">
				<xsl:comment select="'Robert5'"/>
				<xs:complexType>
					<xs:sequence>
						<xsl:apply-templates select="imvert-ep:attribute"/>							
						<xsl:apply-templates select="imvert-ep:attributes"/>							
						<xsl:apply-templates select="imvert-ep:associations"/>	
					</xs:sequence>	
				</xs:complexType>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment select="'Robert6'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
			
	<xsl:template match="imvert-ep:attribute" mode="enumerationType">
		<xs:enumeration value="{imvert-ep:name/@original}"/>
	</xsl:template>
	
	<xsl:template match="imvert-ep:associations">
		<xsl:param name="alias"/>
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="naam"/>
		<xsl:param name="berichtNaam"/>
		<xsl:comment select="'match=imvert-ep:associations nomode'"/>
		<xsl:apply-templates select="imvert-ep:association">
			<xsl:with-param name="alias" select="$alias"/>
			<xsl:with-param name="typeBericht" select="$typeBericht"/>
			<xsl:with-param name="berichtCode" select="$berichtCode"/>
			<xsl:with-param name="naam" select="$naam"/>
			<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="imvert-ep:recursive-structure"/>
	</xsl:template>

	<xsl:template match="imvert-ep:association">
		<xsl:param name="alias"/>
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="naam"/>
		<xsl:param name="berichtNaam"/>
		<xsl:comment select="'match=imvert-ep:association nomode'"/>
		<xs:element name="{imvert-ep:name}" nillable="true" minOccurs="{imvert-ep:min-occurs}" maxOccurs="{imvert-ep:max-occurs}">
			<xs:complexType>
				<xs:sequence>
					<xs:element name="gerelateerde" nillable="true">
						<xs:complexType>
							<xs:sequence>
								<xsl:apply-templates select="imvert-ep:attributes">
									<xsl:with-param name="alias" select="$alias"/>
								</xsl:apply-templates>
								<!--<xs:element name="inOnderzoek" type="{concat('stuf:InOnderzoek',$alias)}" nillable="true" minOccurs="0" maxOccurs="unbounded"/>-->
								<xs:element name="inOnderzoek" type="xs:string" nillable="true" minOccurs="0" maxOccurs="unbounded">
									<xsl:comment select="'De code voor het genereren van het complexType voor dit element moet nog worden geimplementeerd'"/>
								</xs:element>
								<xs:element ref="stuf:extraElementen" minOccurs="0"/>
								<xsl:apply-templates select="imvert-ep:associations">
									<xsl:with-param name="alias" select="$alias"/>
									<xsl:with-param name="typeBericht" select="$typeBericht"/>
									<xsl:with-param name="berichtCode" select="$berichtCode"/>
									<xsl:with-param name="naam" select="$naam"/>
									<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
								</xsl:apply-templates>
							</xs:sequence>
							<xs:attribute ref="stuf:entiteittype" use="required" fixed="{$alias}"/>
						</xs:complexType>
					</xs:element>
					<xsl:apply-templates select="imvert-ep:association-class">
						<xsl:with-param name="alias" select="$alias"/>
						<xsl:with-param name="typeBericht" select="$typeBericht"/>
						<xsl:with-param name="berichtCode" select="$berichtCode"/>
						<xsl:with-param name="naam" select="$naam"/>
						<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
					</xsl:apply-templates>
					<xs:element name="inOnderzoek" type="stuf:StatusMetagegevenNoValue" nillable="true" minOccurs="0"/>
					<!--<xs:element name="brondocument" type="{concat('BG:Brondocument',$alias)}" minOccurs="0"/>-->
					<xs:element name="brondocument" type="xs:string" minOccurs="0">
						<xsl:comment select="'De code voor het genereren van het complexType voor dit element moet nog worden geimplementeerd'"/>
					</xs:element>
					<xsl:apply-templates select="imvert-ep:association-class/imvert-ep:associations"/>
					<xsl:apply-templates select="imvert-ep:associations"/>
				</xs:sequence>
				<xs:attribute ref="stuf:entiteittype" use="required" fixed="???"/>
			</xs:complexType>
		</xs:element>
	</xsl:template>
	
	<xsl:template match="imvert-ep:association-class">
		<xsl:param name="alias"/>
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="naam"/>
		<xsl:param name="berichtNaam"/>
		<xsl:comment select="'match=imvert-ep:association-class nomode'"/>
		<xsl:apply-templates select="imvert-ep:attributes">
			<xsl:with-param name="alias" select="$alias"/>
		</xsl:apply-templates>
		<!--<xs:element name="brondocument" type="{concat('BG:Brondocument',imvert-ep:alias)}" minOccurs="0" maxOccurs="unbounded"/>-->
		<!--<xs:element ref="stuf:tijdvakGeldigheid" minOccurs="0"/>
		<xs:element ref="stuf:tijdstipRegistratie" minOccurs="0"/>
		<xs:element ref="stuf:extraElementen" minOccurs="0"/>-->
		<xsl:apply-templates select="imvert-ep:associations">
			<xsl:with-param name="alias" select="$alias"/>
			<xsl:with-param name="typeBericht" select="$typeBericht"/>
			<xsl:with-param name="berichtCode" select="$berichtCode"/>
			<xsl:with-param name="naam" select="$naam"/>
			<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="imvert-ep:association" mode="formerlyClass">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="naam"/>
		<xsl:param name="berichtNaam"/>
		<xsl:variable name="alias" select="imvert-ep:alias"/>
		<xsl:comment select="'match=imvert-ep:association mode=formerlyClass'"/>
		<xsl:choose>
			<xsl:when test="$typeBericht='VraagBericht'">
			</xsl:when>
			<xsl:when test="$typeBericht='AntwoordBericht'">
				<xs:complexType>
					<xsl:attribute name="name">
						<xsl:choose>
							<xsl:when test="$naam='standaard'">
								<xsl:value-of select="concat($alias,'-gerelateerdeAntwoord')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($berichtNaam,$alias,'-gerelateerdeAntwoord')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xs:sequence>
						<xsl:apply-templates select="imvert-ep:attributes">
							<xsl:with-param name="alias" select="$alias"/>
						</xsl:apply-templates>
						<!--<xs:element name="brondocument" type="{concat('BG:Brondocument',imvert-ep:alias)}" minOccurs="0" maxOccurs="unbounded"/>-->
						<xs:element ref="stuf:tijdvakGeldigheid" minOccurs="0"/>
						<xs:element ref="stuf:tijdstipRegistratie" minOccurs="0"/>
						<xs:element ref="stuf:extraElementen" minOccurs="0"/>
						<xsl:if test="$berichtCode='La01'">
							<!--<xs:element name="historieMaterieel" type="{concat('BG:',imvert-ep:alias,'-historieMaterieel')}" minOccurs="0" maxOccurs="unbounded"/>
							<xs:element name="historieFormeel" type="BG:NPS-historieFormeel" minOccurs="0" maxOccurs="unbounded"/>-->
						</xsl:if>
						<xsl:apply-templates select="imvert-ep:associations">
							<xsl:with-param name="alias" select="$alias"/>
						</xsl:apply-templates>
					</xs:sequence>
					<xs:attribute ref="stuf:entiteittype" use="required" fixed="{$alias}"/>
				</xs:complexType>
			</xsl:when>
			<xsl:when test="$typeBericht='KennisgevingBericht'">
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="imvert-ep:recursive-structure">
		<xsl:comment select="'Moet nog worden ingevuld'"/>
	</xsl:template>

	<!-- (Nog) niet gebruikte templates -->

	<xsl:template match="imvert-ep:class" mode="berichtenstructuur-oud">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="naam"/>
		<xsl:variable name="alias" select="imvert-ep:alias"/>
		<xsl:if test="not(preceding-sibling::imvert-ep:class[imvert-ep:alias = $alias])">
			<xsl:variable name="volledigeBerichtCode">
				<xsl:value-of select="concat(lower-case($alias),$berichtCode)"/>
			</xsl:variable>
			<xsl:variable name="berichtNaam">
				<xsl:choose>
					<xsl:when test="$naam = 'standaard'">
						<xsl:value-of select="$volledigeBerichtCode"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($volledigeBerichtCode,'-',$naam)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xs:element name="{$berichtNaam}">
				<xsl:choose>
					<xsl:when test="$naam = 'standaard' and (@context = 'start' or @context = 'scope' or @context = 'vanaf' or @context = 'tot en met' or @context = 'gelijk')">
						<!--<xs:element name="{$naam}">-->
							<xs:complexType>
								<xs:sequence>
<!--									<xs:element name="stuurgegevens" type="{concat('stuf:',$alias,'-StuurgegevensLv01')}"/>
									<xs:element name="parameters" type="{concat('stuf:',$alias,'-parametersVraagSynchroon')}"/>-->
									<xs:element name="stuurgegevens" type="stuf:StuurgegevensLv01"/>
									<xs:element name="parameters" type="stuf:ParametersVraagSynchroon"/>
									<xs:sequence>
										<!--<element name="gelijk" type="BG:AOA-vraag" minOccurs="0">-->
										<xs:element name="gelijk" minOccurs="0">
											<xsl:attribute name="type">
														<xsl:value-of select="concat('BG:',$alias,'-gelijk')"/>
											</xsl:attribute>
										</xs:element>
										<!--<element name="vanaf" type="BG:AOA-vraag" minOccurs="0">-->
										<xs:element name="vanaf" minOccurs="0">
											<xsl:attribute name="type">
														<xsl:value-of select="concat('BG:',$alias,'-vanaf')"/>
											</xsl:attribute>
										</xs:element>
										<!--<element name="totEnMet" type="BG:AOA-vraag" minOccurs="0">-->
										<xs:element name="totEnMet" minOccurs="0">
											<xsl:attribute name="type">
														<xsl:value-of select="concat('BG:',$alias,'-tm')"/>
											</xsl:attribute>
										</xs:element>
										<xs:element name="scope" minOccurs="0">
											<xs:complexType>
												<xs:sequence>
													<!--<element name="object" type="BG:AOA-vraag">-->
													<xs:element name="object">
														<xsl:attribute name="type">
																	<xsl:value-of select="concat('BG:',$alias,'-scope')"/>
														</xsl:attribute>
													</xs:element>
												</xs:sequence>
											</xs:complexType>
										</xs:element>
										<xs:element name="start" minOccurs="0">
											<xs:complexType>
												<xs:sequence>
													<xs:element name="object">
														<xsl:attribute name="type" select="concat('BG:',$alias,'-start')"/>
													</xs:element>
												</xs:sequence>
											</xs:complexType>
										</xs:element>
									</xs:sequence>
								</xs:sequence>
							</xs:complexType>
						<!--</xs:element>-->
					</xsl:when>
					<xsl:when test="$naam != 'standaard' and (@context = 'start' or @context = 'scope' or @context = 'vanaf' or @context = 'tot en met' or @context = 'gelijk')">
						<!--<xs:element name="{$naam}">-->
							<xs:complexType>
								<xs:sequence>
<!--									<xs:element name="stuurgegevens" type="{concat('stuf:',$alias,'-StuurgegevensLv01')}"/>
									<xs:element name="parameters" type="{concat('stuf:',$alias,'-parametersVraagSynchroon')}"/>-->
									<xs:element name="stuurgegevens" type="stuf:StuurgegevensLv01"/>
									<xs:element name="parameters" type="stuf:ParametersVraagSynchroon"/>
									<xs:sequence>
										<!--<element name="gelijk" type="BG:AOA-vraag" minOccurs="0">-->
										<xs:element name="gelijk" minOccurs="0">
											<xsl:attribute name="type">
														<xsl:value-of select="concat('BG:',$berichtNaam,'-',$alias,'-gelijk')"/>
											</xsl:attribute>
										</xs:element>
										<!--<element name="vanaf" type="BG:AOA-vraag" minOccurs="0">-->
										<xs:element name="vanaf" minOccurs="0">
											<xsl:attribute name="type">
														<xsl:value-of select="concat('BG:',$berichtNaam,'-',$alias,'-vanaf')"/>
											</xsl:attribute>
										</xs:element>
										<!--<element name="totEnMet" type="BG:AOA-vraag" minOccurs="0">-->
										<xs:element name="totEnMet" minOccurs="0">
											<xsl:attribute name="type">
														<xsl:value-of select="concat('BG:',$berichtNaam,'-',$alias,'-tm')"/>
											</xsl:attribute>
										</xs:element>
										<xs:element name="scope" minOccurs="0">
											<xs:complexType>
												<xs:sequence>
													<!--<element name="object" type="BG:AOA-vraag">-->
													<xs:element name="object">
														<xsl:attribute name="type">
																	<xsl:value-of select="concat('BG:',$berichtNaam,'-',$alias,'-scope')"/>
														</xsl:attribute>
													</xs:element>
												</xs:sequence>
											</xs:complexType>
										</xs:element>
										<xs:element name="start" minOccurs="0">
											<xs:complexType>
												<xs:sequence>
													<!--<element name="object" type="BG:AOA-antwoord">-->
													<xs:element name="object">
														<xsl:attribute name="type" select="concat('BG:',$berichtNaam,'-',$alias,'-start')"/>
													</xs:element>
												</xs:sequence>
											</xs:complexType>
										</xs:element>
									</xs:sequence>
								</xs:sequence>
							</xs:complexType>
						<!--</xs:element>-->
					</xsl:when>
					<xsl:when test="@context = 'antwoord'">
						<!--<xs:element name="{$naam}">-->
							<xs:complexType>
								<xs:sequence>
									<!--<xs:element name="stuurgegevens" type="{concat('stuf:',$alias,'-StuurgegevensLa01')}"/>
									<xs:element name="parameters" type="stuf:ParametersAntwoordSynchroon"/>-->
									<xs:element name="stuurgegevens" type="stuf:StuurgegevensLa01"/>
									<xs:element name="parameters" type="stuf:ParametersAntwoordSynchroon"/>
									<xs:element name="melding" type="stuf:Melding" minOccurs="0" maxOccurs="unbounded"/>
									<xs:element name="antwoord" minOccurs="0">
										<xs:complexType>
											<xs:sequence>
												<xs:element name="object" maxOccurs="unbounded">
													<xsl:attribute name="type">
														<xsl:choose>
															<xsl:when test="naam = 'standaard'">
																<xsl:value-of select="concat('BG:',$alias,'-antwoord')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="concat('BG:',$berichtNaam,'-',$alias,'-antwoord')"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						<!--</xs:element>-->
					</xsl:when>
					<xsl:when test="@context = 'kennisgeving'">
						<!--<xs:element name="{$naam}">-->
							<xs:complexType>
								<xs:sequence>
									<xs:element name="stuurgegevens" type="stuf:StuurgegevensLk01"/>
									<xs:element name="parameters" type="stuf:ParametersLk01"/>
									<!--<xs:element name="object" type="BG:AOA-kennisgeving" nillable="true" maxOccurs="2">-->
									<xs:element name="object" nillable="true" maxOccurs="2">
										<xsl:attribute name="type">
											<xsl:choose>
												<xsl:when test="naam = 'standaard'">
													<xsl:value-of select="concat('BG:',$alias,'-kennisgeving')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="concat('BG:',$berichtNaam,'-',$alias,'-kennisgeving')"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						<!--</xs:element>-->
					</xsl:when>
				</xsl:choose>
			</xs:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="imvert-ep:class" mode="berichtencontent">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="naam"/>
		<xsl:param name="toplevel" select="'no'"/>
		<xsl:variable name="alias" select="imvert-ep:alias"/>
		<xsl:variable name="volledigeBerichtCode">
			<xsl:value-of select="concat(lower-case($alias),$berichtCode)"/>
		</xsl:variable>
		<xsl:variable name="berichtNaam">
			<xsl:choose>
				<xsl:when test="$naam = 'standaard'">
					<xsl:value-of select="$volledigeBerichtCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($volledigeBerichtCode,'-',$naam)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!-- LET OP! Een start object is in principe altijd gelijk aan een antwoord. Het is echter de vraag of het voordelen biedt om deze toch van elkaar af te kunnen laten wjken. -->
			<xsl:when test="$naam = 'standaard' and (@context = 'start' or @context = 'scope' or @context = 'vanaf' or @context = 'tot en met' or @context = 'gelijk') and $toplevel = 'yes'">
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="@context = 'start'">
							<xsl:value-of select="'start'"/>
						</xsl:when>
						<xsl:when test="@context = 'scope'">
							<xsl:value-of select="'scope'"/>
						</xsl:when>
						<xsl:when test="@context = 'vanaf'">
							<xsl:value-of select="'vanaf'"/>
						</xsl:when>
						<xsl:when test="@context = 'tot en met'">
							<xsl:value-of select="'tm'"/>
						</xsl:when>
						<xsl:when test="@context = 'gelijk'">
							<xsl:value-of select="'gelijk'"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xs:complexType>
					<xsl:attribute name="name" select="concat($alias,'-',$type)"/>
					<xs:sequence>
						<xsl:apply-templates select="imvert-ep:attributes">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
						</xsl:apply-templates>
						<xs:element ref="stuf:tijdvakGeldigheid" minOccurs="0"/>
						<xs:element ref="stuf:tijdstipRegistratie" minOccurs="0"/>
						<xs:element ref="stuf:extraElementen" minOccurs="0"/>
						<xsl:apply-templates select="imvert-ep:associations">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
						</xsl:apply-templates>
					</xs:sequence>
					<xs:attribute ref="stuf:entiteittype" use="required" fixed="{$alias}"/>
				</xs:complexType>
			</xsl:when>
			<xsl:when test="$naam != 'standaard' and (@context = 'start' or @context = 'scope' or @context = 'vanaf' or @context = 'tot en met' or @context = 'gelijk') and $toplevel = 'yes'">
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="@context = 'start'">
							<xsl:value-of select="'start'"/>
						</xsl:when>
						<xsl:when test="@context = 'scope'">
							<xsl:value-of select="'scope'"/>
						</xsl:when>
						<xsl:when test="@context = 'vanaf'">
							<xsl:value-of select="'vanaf'"/>
						</xsl:when>
						<xsl:when test="@context = 'tot en met'">
							<xsl:value-of select="'tm'"/>
						</xsl:when>
						<xsl:when test="@context = 'gelijk'">
							<xsl:value-of select="'gelijk'"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xs:complexType>
					<xsl:attribute name="name" select="concat($berichtNaam,'-',$alias,'-',$type)"/>
					<xs:sequence>
						<xsl:apply-templates select="imvert-ep:attributes">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
						</xsl:apply-templates>
						<xs:element ref="stuf:tijdvakGeldigheid" minOccurs="0"/>
						<xs:element ref="stuf:tijdstipRegistratie" minOccurs="0"/>
						<xs:element ref="stuf:extraElementen" minOccurs="0"/>
						<xsl:apply-templates select="imvert-ep:associations">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
						</xsl:apply-templates>
					</xs:sequence>
					<xs:attribute ref="stuf:entiteittype" use="required" fixed="{$alias}"/>
				</xs:complexType>
			</xsl:when>
			<xsl:when test="@context = 'antwoord' and $toplevel = 'yes'">
				<xs:complexType>
					<xsl:attribute name="name">
						<xsl:choose>
							<xsl:when test="$berichtNaam=''">
								<xsl:value-of select="concat($alias,'-antwoord')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($berichtNaam,'-',$alias,'-antwoord')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xs:sequence>
						<xsl:apply-templates select="imvert-ep:attributes">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
						</xsl:apply-templates>
						<!--<xs:element name="brondocument" type="{concat('BG:Brondocument',imvert-ep:alias)}" minOccurs="0" maxOccurs="unbounded"/>-->
						<xs:element ref="stuf:tijdvakGeldigheid" minOccurs="0"/>
						<xs:element ref="stuf:tijdstipRegistratie" minOccurs="0"/>
						<xs:element ref="stuf:extraElementen" minOccurs="0"/>
						<xsl:if test="$berichtCode='La01' or $berichtCode='La02' or $berichtCode='La03' or $berichtCode='La04' or $berichtCode='La05' or $berichtCode='La06' or $berichtCode='La07' or $berichtCode='La08'">
							<!--<xs:element name="historieMaterieel" type="{concat('BG:',imvert-ep:alias,'-historieMaterieel')}" minOccurs="0" maxOccurs="unbounded"/>
							<xs:element name="historieFormeel" type="{concat('BG:',imvert-ep:alias,'-historieFormeel')}" minOccurs="0" maxOccurs="unbounded"/>-->
							<xs:element name="historieMaterieel" type="xs:string" minOccurs="0" maxOccurs="unbounded">
								<xsl:comment select="'De code voor het genereren van het complexType voor dit element moet nog worden geimplementeerd'"/>
							</xs:element>
							<xs:element name="historieFormeel" type="xs:string" minOccurs="0" maxOccurs="unbounded">
								<xsl:comment select="'De code voor het genereren van het complexType voor dit element moet nog worden geimplementeerd'"/>
							</xs:element>
						</xsl:if>
						<xsl:apply-templates select="imvert-ep:associations">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
						</xsl:apply-templates>
					</xs:sequence>
					<xs:attribute ref="stuf:entiteittype" use="required" fixed="{$alias}"/>
				</xs:complexType>
			</xsl:when>
			<xsl:when test="@context = 'kennisgeving' and $toplevel = 'yes'">
				<xs:complexType>
					<xsl:attribute name="name">
						<xsl:choose>
							<xsl:when test="$berichtNaam=''">
								<xsl:value-of select="concat($alias,'-kennisgeving')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($berichtNaam,'-',$alias,'-kennisgeving')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xs:sequence>
						<xsl:apply-templates select="imvert-ep:attributes">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
						</xsl:apply-templates>
						<!--<xs:element name="brondocument" type="{concat('BG:Brondocument',imvert-ep:alias)}" minOccurs="0" maxOccurs="unbounded"/>-->
						<xs:element ref="stuf:tijdvakGeldigheid" minOccurs="0"/>
						<xs:element ref="stuf:tijdstipRegistratie" minOccurs="0"/>
						<xs:element ref="stuf:extraElementen" minOccurs="0"/>
						<xsl:apply-templates select="imvert-ep:associations">
							<xsl:with-param name="alias" select="$alias"/>
							<xsl:with-param name="typeBericht" select="$typeBericht"/>
							<xsl:with-param name="berichtCode" select="$berichtCode"/>
							<xsl:with-param name="naam" select="$naam"/>
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
						</xsl:apply-templates>
					</xs:sequence>
					<xs:attribute ref="stuf:entiteittype" use="required" fixed="{$alias}"/>
				</xs:complexType>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="imvert-ep:attributes">
					<xsl:with-param name="alias" select="$alias"/>
					<xsl:with-param name="typeBericht" select="$typeBericht"/>
					<xsl:with-param name="berichtCode" select="$berichtCode"/>
					<xsl:with-param name="naam" select="$naam"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="imvert-ep:associations">
					<xsl:with-param name="alias" select="$alias"/>
					<xsl:with-param name="typeBericht" select="$typeBericht"/>
					<xsl:with-param name="berichtCode" select="$berichtCode"/>
					<xsl:with-param name="naam" select="$naam"/>
					<xsl:with-param name="berichtNaam" select="$berichtNaam"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	</xsl:stylesheet>
