<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 * Copyright (C) 2016 Dienst voor het kadaster en de openbare registers
 * 
 * This file is part of Imvertor.
 *
 * Imvertor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Imvertor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet    
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:imvert="http://www.imvertor.org/schema/system"
	xmlns:imf="http://www.imvertor.org/xsl/functions"
	xmlns:html="http://www.w3.org/1999/xhtml"
	
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:variable name="derivation-tree" select="imf:document($derivationtree-file-url)"/>

	<xsl:variable name="model-is-traced" select="imf:boolean(imf:get-config-string('cli','modelistraced'))"/>
	
	<!-- 
		Return the construct in the derivation tree with the specified ID 
		In case of copy-down there may be several.
	-->
	<xsl:function name="imf:get-construct-in-derivation-by-id" as="element()*">
		<xsl:param name="id" as="xs:string"/> <!-- the ID of the construct -->
		<xsl:sequence select="$derivation-tree//*[imvert:id=$id]"/>
	</xsl:function>
	
	<!-- 
		Pass any construct, and return all derived or deriving client + supplier constructs wrapped in imvert:layer elements 
		Example:
		
		<imvert:layer xmlns:imvert="http://www.imvertor.org/schema/system" project="INFOMOD" application="RM-487531-SIM" release="20140401">
		  <imvert:class display-name="Basismodel::Adresseerbaar object aanduiding_SIM" layered-name="Basismodel_AdresseerbaarObjectAanduiding_SIM">
	-->
	<xsl:function name="imf:get-construct-in-all-layers" as="element()*">
		<xsl:param name="client-construct" as="element()"/> <!-- the construct in the layer -->
		<xsl:param name="force-canonical-name" as="xs:boolean"/> 
		<xsl:param name="is-traced" as="xs:boolean"/>
		
		<xsl:choose>
			<xsl:when test="$is-traced">
				<!-- based on trace id, get all constructs in all layers, ordered from client to supplier. -->
				<xsl:variable name="client-construct-id" select="$client-construct/imvert:id"/>
				<xsl:variable name="client-construct-in-tree" select="imf:get-construct-by-id($client-construct-id,$derivation-tree)"/>
				<xsl:variable name="traced" select="imf:get-trace-supply-chain($client-construct,())"/>
				<xsl:variable name="constructs" select="($client-construct-in-tree, $traced)"/>
				<xsl:for-each select="$constructs">
					<xsl:variable name="layer" select="ancestor::imvert:supplier"/>
					<xsl:sequence select="imf:create-layer($layer/@project,$layer/@application,$layer/@release,.)"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="not($is-traced)">
				<xsl:variable name="dn" select="imf:get-display-name($client-construct)"/>
				<!-- based on display-name, get all layered-names, usually one. -->
				<xsl:variable name="ln" select="($derivation-tree//*[@display-name=$dn]/@layered-name)[1]"/>
				<!-- all same constructs have the same layered name. So now fetch those constructs -->
				<xsl:variable name="constructs" select="$derivation-tree//*[@layered-name=$ln]"/>
				<xsl:for-each-group 
					select="$constructs[self::imvert:package or self::imvert:class or self::imvert:attribute or self::imvert:association]"
					group-by="concat(ancestor::imvert:supplier/@project,'_',ancestor::imvert:supplier/@application,'_',ancestor::imvert:supplier/@release,'_',@layered-name)">
					<xsl:variable name="construct" select="current-group()[1]"/>
					<xsl:variable name="layer" select="$construct/ancestor::imvert:supplier"/>
					<xsl:sequence select="imf:create-layer($layer/@project,$layer/@application,$layer/@release,.)"/>
				</xsl:for-each-group>
			</xsl:when>
		</xsl:choose>
	</xsl:function>
	
	<!-- create a imvert:layer element -->
	<xsl:function name="imf:create-layer" as="element()">
		<xsl:param name="project" as="xs:string"/>
		<xsl:param name="application" as="xs:string"/>
		<xsl:param name="release" as="xs:string"/>
		<xsl:param name="content" as="item()*"/>
		<imvert:layer project="{$project}" application="{$application}" release="{$release}">
			<xsl:sequence select="$content"/>
		</imvert:layer>
	</xsl:function>
	
	<!-- 
		Combine all imvert documentation elements. 
		This returns the HTML for the documentation with special markers between the derived documentation parts. 
	-->
	<xsl:function name="imf:get-compiled-documentation" as="item()*">
		<xsl:param name="construct" as="element()"/> <!-- any construct that may have documentation -->
		<xsl:param name="is-traced" as="xs:boolean"/>
		
		<xsl:variable name="layers" select="imf:get-construct-in-all-layers($construct,true(),$is-traced)"/>
		<xsl:variable name="result" as="item()*">
			<xsl:for-each select="$layers">
				<xsl:if test="position() = 1 or imf:boolean($derive-documentation)">
					<xsl:variable name="doc" select="*/imvert:documentation[*]"/>
					<!-- if supplier has documentation, mark this as extracted from the supplier -->
					<xsl:if test="position() gt 1 and exists($doc/node())">
						<p class="supplierMark" xmlns="http://www.w3.org/1999/xhtml">
							<xsl:value-of select="concat(imf:get-config-parameter('documentation-separator'),@application,' (', @release, ')',imf:get-config-parameter('documentation-separator'))"/>
						</p>
					</xsl:if>
					<xsl:sequence select="$doc/node()"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:sequence select="$result"/>
	</xsl:function>
	
	<!-- 
		Get the latest (client) value specified of any tagged value 
	-->
	<xsl:function name="imf:get-compiled-tagged-values" as="element()*">
		<xsl:param name="construct" as="element()"/> <!-- any construct that may have tagged values -->
		<xsl:param name="is-traced" as="xs:boolean"/>
		<xsl:param name="include-empty" as="xs:boolean"/>
			
		<xsl:variable name="layers" select="imf:get-construct-in-all-layers($construct,true(),$is-traced)"/>
		<xsl:variable name="tvs" as="element()*">
			<xsl:for-each-group select="imf:get-config-tagged-values()" group-by="name"> <!-- returns tv elements -->
				<xsl:for-each select="current-group()[last()]">
					<!-- The tagged value is declared -->
					<xsl:variable name="tv-name" select="name"/>
					<xsl:variable name="tv" select="($layers/*/imvert:tagged-values/imvert:tagged-value[imvert:name=$tv-name])[last()]"/>
					<xsl:if test="exists($tv)">
						<!-- The tagged value is provided, there's a most specific value -->
						<xsl:variable name="supplier" select="imf:get-supplier-from-layers($tv)"/>
						<xsl:variable name="local" select="if (empty($supplier/preceding-sibling::*)) then 'true' else 'false'"/>
						<d 
							name="{$tv-name}" 
							original-name="{$tv/imvert:name/@original}" 
							value="{$tv/imvert:value}" 
							original-value="{$tv/imvert:value/@original}" 
							project="{$supplier/@project}"
							application="{$supplier/@application}"
							release="{$supplier/@release}"
							local="{$local}"
						/>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:sequence select="if ($include-empty) then $tvs else $tvs[normalize-space(@value)]"/>
	</xsl:function>
	
	<xsl:function name="imf:get-supplier-from-layers">
		<xsl:param name="construct" as="element()"/>
		<xsl:variable name="construct-id" select="($construct/ancestor::*[imvert:id])[1]/imvert:id"/>
		<xsl:sequence select="imf:get-construct-by-id($construct-id,$derivation-tree)/ancestor::imvert:supplier"/>
	</xsl:function>
	
	<xsl:function name="imf:get-adapted-display-name" as="xs:string?">
		<xsl:param name="client-construct" as="element()"/>
		<!-- 
			A package may have the tagged value "supplier-name". 
			This is set to the name of the supplier package (normally, client and supplier package names are the same).
			Note that you cannot (yet) re-map names of classes and properties.
		-->
		<xsl:variable name="remapped-package" select="$client-construct/ancestor-or-self::imvert:package[imvert:supplier-package-name][1]"/>
		<xsl:choose>
			<xsl:when test="empty($remapped-package)"/>
			<xsl:when test="$client-construct/self::imvert:package">
				<xsl:value-of select="imf:compile-construct-name($remapped-package/imvert:supplier-package-name, (), (), ())"/>
			</xsl:when>
			<xsl:when test="$client-construct/self::imvert:class">
				<xsl:value-of select="imf:compile-construct-name($remapped-package/imvert:supplier-package-name, $client-construct/imvert:name, (), ())"/>
			</xsl:when>
			<xsl:when test="$client-construct[self::imvert:attribute or self::imvert:association]">
				<xsl:value-of select="imf:compile-construct-name($remapped-package/imvert:supplier-package-name, $client-construct/../../imvert:name, $client-construct/imvert:name, ())"/>
			</xsl:when>
		</xsl:choose> 
	</xsl:function>
	
	<xsl:function name="imf:canonical-name" as="xs:string">
		<xsl:param name="name"/>
		<xsl:value-of select="lower-case(string-join(tokenize($name,'_'),''))"/>
	</xsl:function>
	
	<!-- for tracing: -->
	
	<!-- get all construct in the trace tree that are in supply chain for the supplied client construct -->
	<xsl:function name="imf:get-trace-supply-chain">
		<xsl:param name="client"/>
		<xsl:param name="trace-history" as="element()*"/>
		
		<xsl:variable name="supplier-id" select="$client/imvert:trace"/>
		<xsl:variable name="supplier" select="imf:get-trace-construct-by-id($client,$supplier-id,$derivation-tree)"/>
		
		<xsl:choose>
			<xsl:when test="empty($supplier-id)">
				<!-- skip -->
			</xsl:when>
			<xsl:when test="empty($supplier)">
				<error id="{$supplier-id}" type="NO-SUPPLIER"/>
			</xsl:when>
			<xsl:when test="$trace-history = $supplier">
				<error id="{$supplier-id}" type="TRACE-RECURSION"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="imf:get-trace-construct-by-id($client,$supplier-id,$derivation-tree)"/>
				<xsl:sequence select="imf:get-trace-supply-chain($supplier,($trace-history,$supplier))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- get the construct by ID where the id supplied is passed as the value of a trace (imvert:trace) -->
	<xsl:function name="imf:get-trace-construct-by-id">
		<xsl:param name="client"/>
		<xsl:param name="supplier-id"/>
		<xsl:param name="document-root"/>
		<xsl:variable name="supplier-id-corrected">
			<xsl:choose>
				<xsl:when test="$client/self::imvert:class">
					<xsl:value-of select="$supplier-id"/> <!-- EAID_xxx becomes EAID_xxx -->
				</xsl:when>
				<xsl:when test="$client/self::imvert:attribute">
					<xsl:value-of select="$supplier-id"/>  <!-- {xxx} becomes {xxx} -->
				</xsl:when>
				<xsl:when test="$client/self::imvert:association">
					<xsl:value-of select="concat('EAID_',replace(substring($supplier-id,2,string-length($supplier-id) - 2),'-','_'))"/> <!-- {xxx} becomes EAID_xxx -->
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:sequence select="imf:get-construct-by-id($supplier-id-corrected,$document-root)"/>
	</xsl:function>
	
</xsl:stylesheet>