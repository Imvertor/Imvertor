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

    xmlns:bg="http://www.egem.nl/StUF/sector/bg/0310" 
    xmlns:metadata="http://www.kinggemeenten.nl/metadataVoorVerwerking" 
    xmlns:ztc="http://www.kinggemeenten.nl/ztc0310" 
    xmlns:stuf="http://www.egem.nl/StUF/StUF0301"
    xmlns:imvert-ep="http://www.imvertor.org/schema/endproduct" 

    xmlns:ss="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    
    version="2.0">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <xsl:variable name="stylesheet">Imvert2XSD-KING-create-endproduct-structure</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2XSD-KING-create-endproduct-structure.xsl 1 2015-11-11 11:50:00Z RobertMelskens $</xsl:variable>
    
	<xsl:variable name="tagged-values">
		<xsl:sequence select="//imvert:package[imvert:name/@original='Bericht']//imvert:class[imvert:name/@original='Bericht']/imvert:tagged-values"/>
	</xsl:variable>

    <xsl:template match="imvert:package[imvert:name/@original='Bericht']" mode="create-message-structure">
		<xsl:if test="$debug='yes'">
			<xsl:comment select="'imvert:package[mode=create-message-structure]'"/>
		</xsl:if>
		<imvert-ep:endproduct-structures>
			<xsl:apply-templates select="imvert:class[imvert:name/@original='Vraagbericht' or 
														imvert:name/@original='AntwoordBericht' or 
														imvert:name/@original='KennisgevingBericht' or 
														imvert:name/@original='Vrij bericht']" mode="create-message-structure">
			</xsl:apply-templates>
		</imvert-ep:endproduct-structures>
	</xsl:template>
	
	<xsl:template match="imvert:class" mode="create-message-structure">
		<xsl:variable name="berichtCode" select="imf:determineBerichtCode(imvert:name/@original,$tagged-values)"/>
		<imvert-ep:message name="{$berichtNaam}" typeBericht="{imvert:name/@original}" berichtCode="$berichtCode" packageType="{ancestor::imvert:package/imvert:name/@original}" stereotype="{imvert:stereotype}" id="{imvert:id}" >
			<imvert-ep:class packageType="{ancestor::imvert:package/imvert:name/@original}" stereotype="{imvert:stereotype}" id="{imvert:id}">
				<imvert-ep:name><xsl:value-of select="imvert:name/@original"/></imvert-ep:name>
				<imvert-ep:alias><xsl:value-of select="imvert:alias"/></imvert-ep:alias>
				<imvert-ep:id><xsl:value-of select="imvert:id"/></imvert-ep:id>
				<imvert-ep:documentation><xsl:value-of select="imvert:documentation"/></imvert-ep:documentation>
				<imvert-ep:tagged-values>
				</imvert-ep:tagged-values>
				<imvert-ep:attributes>
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="typeBericht" select="imvert:name/@original"/><!-- bijv. Vraagbericht -->
						<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. NPS-vraag-bsn_Di02 of npsLk01 -->
						<xsl:with-param name="berichtCode" select="'$berichtCode'"/><!-- bijv. Lv01 of Lk01 -->
						<xsl:with-param name="proces-type" select="'attributes'"/>
						<xsl:with-param name="resolvingEntity" select="imvert:name/@original"/>
						<xsl:with-param name="entiteitType" select="lower-case(imvert:alias)"/>
						<xsl:with-param name="relatie" select="'-'"/>
					</xsl:apply-templates>
					<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
						<xsl:with-param name="typeBericht" select="imvert:name/@original"/><!-- bijv. Vraagbericht -->
						<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. bijv. NPS-vraag-bsn_Di02 of npsLk01 -->
						<xsl:with-param name="berichtCode" select="'$berichtCode'"/><!-- bijv. Lv01 of Lk01 -->
						<xsl:with-param name="entiteitType" select="lower-case(imvert:alias)"/>
						<xsl:with-param name="entity" select="imvert:name/@original"/>
						<xsl:with-param name="sourceEntity" select="imvert:name/@original"/>
						<xsl:with-param name="relatie" select="'-'"/>
					</xsl:apply-templates>
				</imvert-ep:attributes>
				<imvert-ep:associations>
						<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
							<xsl:with-param name="typeBericht" select="imvert:name/@original"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. bijv. NPS-vraag-bsn_Di02 of npsLk01 -->
							<xsl:with-param name="berichtCode" select="'$berichtCode'"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="proces-type" select="'associations'"/>
							<xsl:with-param name="resolvingEntity" select="imvert:name/@original"/>
							<xsl:with-param name="entiteitType" select="lower-case(imvert:alias)"/>
							<xsl:with-param name="relatie" select="'-'"/>
						</xsl:apply-templates>
						<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
							<xsl:with-param name="typeBericht" select="imvert:name/@original"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. bijv. NPS-vraag-bsn_Di02 of npsLk01 -->
							<xsl:with-param name="berichtCode" select="'$berichtCode'"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="entity" select="imvert:name/@original"/>
							<xsl:with-param name="sourceEntity" select="imvert:name/@original"/>
							<xsl:with-param name="entiteitType" select="lower-case(imvert:alias)"/>
							<xsl:with-param name="id-trail" select="concat('#1#',imvert:id,'#')"/>
							<xsl:with-param name="relatie" select="'-'"/>
						</xsl:apply-templates>
					</imvert-ep:associations>
			</imvert-ep:class>
		</imvert-ep:message>
	</xsl:template>

	<!-- Dit template initialiseert de verwerking van de superclasses van de in bewerking zijnde class. -->
    <xsl:template match="imvert:supertype" mode="create-message-content">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtNaam"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="proces-type"/>
		<xsl:param name="resolvingEntity"/>
		<xsl:param name="entiteitType"/>
		<xsl:param name="relatie"/>
		<xsl:variable name="imvertId" select="imvert:type-id"/>
		<xsl:variable name="originalname" select="imvert:type-name/@original"/>
		<xsl:if test="$debug='yes'">
			<xsl:comment select="'imvert:supertype[mode=create-message-structure]'"/>
		</xsl:if>
		<xsl:apply-templates select="//imvert:class[imvert:id = $imvertId]" mode="create-message-content">
			<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
			<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
			<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
			<xsl:with-param name="proces-type" select="$proces-type"/>
			<xsl:with-param name="entity" select="$originalname"/>
			<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
			<xsl:with-param name="entiteitType" select="$entiteitType"/>
			<xsl:with-param name="relatie" select="$relatie"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="imvert:attribute" mode="create-message-content">
		<xsl:param name="typeBericht"/><!-- bijv. Vraagbericht -->
		<xsl:param name="berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
		<xsl:param name="berichtCode"/><!-- bijv. Lv01 of Lk01 -->
		<xsl:param name="entiteitType"/><!-- bijv. nps of aoa -->
		<xsl:param name="entity"/>
		<xsl:param name="sourceEntity"/>
		<xsl:param name="relatie"/>
		<xsl:variable name="name" select="imvert:name/@original"/>
		<xsl:if test="$debug='yes'">
			<xsl:comment select="'imvert:attribute[mode=create-message-structure]'"/>
			<xsl:comment>entiteitType: <xsl:value-of select="$entiteitType"/>, 
				berichtCode: <xsl:value-of select="$berichtCode"/>, 
				berichtNaam: <xsl:value-of select="$berichtNaam"/>, 
				entity: <xsl:value-of select="$entity"/>, 
				relatie: <xsl:value-of select="$relatie"/>, 
				sourceEntity: <xsl:value-of select="$sourceEntity"/>
			</xsl:comment>
		</xsl:if>
		<!-- In de onderstaande when statements is een check opgenomen op het berichtType zodat de juiste rijen geselecteerd worden. -->
		<imvert-ep:attribute>
			<xsl:attribute name="sourceEntity" select="$sourceEntity"/>									
			<xsl:apply-templates select="imvert:name"  mode="replicate-imvert-elements"/>
			<xsl:apply-templates select="imvert:min-occurs | imvert:max-occurs"  mode="replicate-imvert-elements"/>
			<xsl:choose>
				<!--<xsl:when test="imvert:type-id and not(imvert:stereotype='attribuutsoort')">-->
				<xsl:when test="imvert:type-id">
					<xsl:apply-templates select="//imvert:class[imvert:id=current()/imvert:type-id]" mode="create-datatype-content"/>
				</xsl:when>
				<!--<xsl:otherwise>
					<xsl:apply-templates select="//imvert:class[imvert:id=current()/imvert:type-id]" mode="create-message-content"/>
				</xsl:otherwise>-->
			</xsl:choose>
			<xsl:apply-templates select="*[local-name() != 'name' and local-name() != 'min-occurs' and local-name() != 'max-occurs' and local-name() != 'is-value-derived' and local-name() != 'position' and local-name() != 'tagged-values' and local-name()!='merged' and local-name() != 'conceptual-schema-type' and local-name() != 'attribute-type-designation' and local-name() != 'type-id' and local-name() != 'type-package-id']"  mode="replicate-imvert-elements"/>
		</imvert-ep:attribute>
	</xsl:template>
	
	<xsl:template match="imvert:association" mode="create-message-content">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtNaam"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="entity"/>
		<xsl:param name="sourceEntity"/>
		<xsl:param name="entiteitType"/>
		<xsl:param name="id-trail"/>
		<xsl:param name="relatie"/>
		<xsl:if test="$debug='yes'">
			<xsl:comment select="'imvert:association[mode=create-message-content]'"/>
<!--			<xsl:comment>entiteitType: <xsl:value-of select="$entiteitType"/>, 
				berichtCode: <xsl:value-of select="$berichtCode"/>, 
				berichtNaam: <xsl:value-of select="$berichtNaam"/>, 
				entity: <xsl:value-of select="$entity"/>, 
				relatie: <xsl:value-of select="$relatie"/>, 
				sourceEntity: <xsl:value-of select="$sourceEntity"/>
			</xsl:comment>-->
		</xsl:if>
		<xsl:variable name="name">
			<xsl:choose>
				<xsl:when test="imvert:name/@original != ''">
					<xsl:value-of  select="imvert:name/@original"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="imvert:name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
				<!-- In de onderstaande when statements is een check opgenomen op het berichtType zodat de juiste rijen geselecteerd worden. -->
					<imvert-ep:association packageType="{ancestor::imvert:package/imvert:name/@original}">
						<xsl:attribute name="sourceEntity" select="$sourceEntity"/>					
						<xsl:variable name="type-id" select="imvert:type-id"/>
						<imvert-ep:className><xsl:value-of select="//imvert:class[imvert:id = $type-id]/imvert:name/@original"/><!-- <xsl:value-of select="$entity"/>--></imvert-ep:className>
						<imvert-ep:alias><xsl:value-of select="//imvert:class[imvert:id = $type-id]/imvert:alias"/></imvert-ep:alias>
						<imvert-ep:id><xsl:value-of select="//imvert:class[imvert:id = $type-id]/imvert:id"/></imvert-ep:id>
						<imvert-ep:documentation><xsl:value-of select="//imvert:class[imvert:id = $type-id]/imvert:documentation"/></imvert-ep:documentation>
						<xsl:apply-templates select="imvert:name"  mode="replicate-imvert-elements"/>
						<xsl:apply-templates select="imvert:min-occurs | imvert:max-occurs"  mode="replicate-imvert-elements"/>
						<xsl:apply-templates select="*[local-name()!= 'name' and local-name()!= 'min-occurs' and local-name() != 'max-occurs' and local-name()!= 'association-class' and local-name()!='merged' and local-name()!= 'id' and local-name() != 'type-name' and local-name() != 'type-id' and local-name() != 'type-package' and local-name() != 'min-occurs-source' and local-name() != 'max-occurs-source' and local-name() != 'position' and local-name() != 'tagged-values' and local-name() != 'role-target']"  mode="replicate-imvert-elements"/>
						<xsl:apply-templates select="imvert:association-class" mode="create-message-relations-content">
							<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
							<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="proces-type" select="'associations'"/>
							<xsl:with-param name="resolvingEntity" select="$entity"/>
							<xsl:with-param name="entiteitType" select="$entiteitType"/>
							<xsl:with-param name="id-trail" select="$id-trail"/>
							<xsl:with-param name="role-target" select="imvert:role-target"/>
							<xsl:with-param name="relatie" select="imvert:name/@original"/>
							<xsl:with-param name="entity" select="imvert:type-name/@original"/>
						</xsl:apply-templates>
						<imvert-ep:attributes>
							<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-message-content">
								<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
								<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
								<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
								<xsl:with-param name="proces-type" select="'attributes'"/>
								<xsl:with-param name="resolvingEntity" select="$entity"/>
								<xsl:with-param name="entiteitType" select="$entiteitType"/>
								<xsl:with-param name="id-trail" select="$id-trail"/>
								<xsl:with-param name="role-target" select="imvert:role-target"/>
								<xsl:with-param name="relatie" select="imvert:name/@original"/>
							</xsl:apply-templates>
						</imvert-ep:attributes>
						<imvert-ep:associations>
							<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-message-relations-content">
								<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
								<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
								<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
								<xsl:with-param name="proces-type" select="'associations'"/>
								<xsl:with-param name="resolvingEntity" select="$entity"/>
								<xsl:with-param name="entiteitType" select="$entiteitType"/>
								<xsl:with-param name="id-trail" select="$id-trail"/>
								<xsl:with-param name="role-target" select="imvert:role-target"/>
								<xsl:with-param name="relatie" select="imvert:name/@original"/>
								<xsl:with-param name="entity" select="imvert:type-name/@original"/>
							</xsl:apply-templates>
						</imvert-ep:associations>
					</imvert-ep:association>
	</xsl:template>

	<xsl:template match="imvert:association-class" mode="create-message-relations-content">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtNaam"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="proces-type" select="'associations'"/>
		<xsl:param name="resolvingEntity"/>
		<xsl:param name="entiteitType"/>
		<xsl:param name="id-trail"/>
		<xsl:param name="relatie"/>
		<xsl:param name="entity"/>
		<xsl:if test="$debug='yes'">
			<xsl:comment select="'imvert:association-class[mode=create-message-relations-structure]'"/>
		</xsl:if>
		<imvert-ep:association-class packageType="{ancestor::imvert:package/imvert:name/@original}" stereotype="{imvert:stereotype}" id="{imvert:id}">
			<xsl:variable name="type-id" select="imvert:type-id"/>
			<imvert-ep:attributes>
				<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-message-content">
					<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
					<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
					<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
					<xsl:with-param name="proces-type" select="'attributes'"/>
					<xsl:with-param name="resolvingEntity" select="$entity"/>
					<xsl:with-param name="entiteitType" select="$entiteitType"/>
					<xsl:with-param name="id-trail" select="$id-trail"/>
					<xsl:with-param name="relatie" select="imvert:name/@original"/>
				</xsl:apply-templates>
			</imvert-ep:attributes>
			<imvert-ep:associations>
				<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-message-relations-content">
					<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
					<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
					<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
					<xsl:with-param name="proces-type" select="'associations'"/>
					<xsl:with-param name="resolvingEntity" select="$entity"/>
					<xsl:with-param name="entiteitType" select="$entiteitType"/>
					<xsl:with-param name="id-trail" select="$id-trail"/>
					<xsl:with-param name="relatie" select="imvert:name/@original"/>
					<xsl:with-param name="entity" select="imvert:type-name/@original"/>
				</xsl:apply-templates>
			</imvert-ep:associations>
			<xsl:apply-templates select="imvert:stereotype" mode="create-message-content"/>
		</imvert-ep:association-class>
	</xsl:template>
		
	<xsl:template match="imvert:class" mode="create-message-content">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtNaam"/>
		<xsl:param name="berichtCode"/>
		<!-- Deze parameter is nodig om te kunnen bepalen welke Class in het imvertor bestand de kern van het bericht vormt en welke rijen in het configuratiebestand dus moeten
			  worden geprocessed. -->
		<xsl:param name="entiteitType" select="lower-case(imvert:alias)"/>
		<!-- Deze parameter wordt gebruikt om te kunnen bepalen in welk stadium de opbouw van het bericht is. Is het overkoepelende 'imvert-ep:class' element al aangemaakt
			  of moet dat nog gebeuren. Indien deze parameter leeg is dan is dat element nog niet aangemaakt en moet in dit template de eerste when geactiveerd worden. 

			  MISSCHIEN KUNNEN WE HIER OOK EEN TOGGLE PARAMETER VAN MAKEN MET DE WAARDE 'yes' EN 'no'. -->
		<xsl:param name="resolvingEntity" select="''"/>		
		<!-- Indien de bovenstaande parameter gevuld is dan wordt deze parameter gebruikt om te bepalen in welke modus dit template moet worden gebruikt. Moeten de attributes 
			  van een superclass of een gerelateerde class worden opgehaald of moeten de associations van een superclass of een gerelateerde class worden opgehaald. -->
		<xsl:param name="proces-type" select="''"/>
		<xsl:param name="entity" select="imvert:name/@original"/>
		<!-- Bij het gebruik van dit template wordt er standaard vanuit gegaan dat het proces nog niet aanbeland is bij de verwerking van de relaties.
			  De volgende parameter krijgt dan ook bij default de waarde '-' mee. -->
		<xsl:param name="relatie" select="'-'"/>
		<!-- De volgende parameter heeft alleen een functie als dit template wordt gebruikt voor de verwerking van relaties. Met deze parameter voorkomen we dat relaties recursief 
			  tot in het oneindige worden geprocessed. Indien een relatie voor de tweede keer wordt geprocessed dan moet het proces stoppen. -->
		<xsl:param name="id-trail"/>
		<!-- De packageType bepaald hoe er omgegaan moet worden met associations. Indien de packageType gelijk is aan 'Model' dan worden associations vertaald naar relaties 
			  waarbinnen gerelateerde entiteiten worden geplaatts. Is de packageType echter gelijk aan 'Bericht' dan worden associations vertaalt naar normale container elementen.-->
		<xsl:if test="$debug='yes'">
			<xsl:comment select="'imvert:class[mode=create-message-structure]'"/>
		</xsl:if>
		<imvert-ep:class packageType="{ancestor::imvert:package/imvert:name/@original}"  stereotype="{imvert:stereotype}"  id="{imvert:id}">
			<imvert-ep:name original="{imvert:name/@original}"><xsl:value-of select="imvert:name"/></imvert-ep:name>
			<xsl:choose>
				<!-- In deze eerste when wordt de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt. 
					 Dit is de class waarvan de waarde van 'imvert:alias' gelijk is aan de kolom 'entiteittype' van het in bewerking zijnde berichttype. -->
				<xsl:when test="$resolvingEntity = ''">				
						<imvert-ep:name original="{$entity}"><xsl:value-of select="$entity"/></imvert-ep:name>
						<imvert-ep:alias><xsl:value-of select="imvert:alias"/></imvert-ep:alias>
						<imvert-ep:id><xsl:value-of select="imvert:id"/></imvert-ep:id>
						<imvert-ep:documentation><xsl:value-of select="imvert:documentation"/></imvert-ep:documentation>
						<imvert-ep:attributes>
							<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
								<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
								<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
								<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
								<xsl:with-param name="proces-type" select="'attributes'"/>
								<xsl:with-param name="resolvingEntity" select="$entity"/>
								<xsl:with-param name="entiteitType" select="$entiteitType"/>
								<xsl:with-param name="relatie" select="$relatie"/>
							</xsl:apply-templates>
							<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
								<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
								<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
								<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
								<xsl:with-param name="entiteitType" select="$entiteitType"/>
								<xsl:with-param name="entity" select="$entity"/>
								<xsl:with-param name="sourceEntity" select="$entity"/>
								<xsl:with-param name="relatie" select="$relatie"/>
							</xsl:apply-templates>
						</imvert-ep:attributes>
						<imvert-ep:associations>
							<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
								<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
								<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
								<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
								<xsl:with-param name="proces-type" select="'associations'"/>
								<xsl:with-param name="resolvingEntity" select="$entity"/>
								<xsl:with-param name="entiteitType" select="$entiteitType"/>
								<xsl:with-param name="relatie" select="$relatie"/>
							</xsl:apply-templates>
							<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
								<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
								<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
								<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
								<xsl:with-param name="entity" select="$entity"/>
								<xsl:with-param name="sourceEntity" select="$entity"/>
								<xsl:with-param name="entiteitType" select="$entiteitType"/>
								<xsl:with-param name="id-trail" select="concat('#1#',imvert:id,'#',$id-trail)"/>
								<xsl:with-param name="relatie" select="$relatie"/>
							</xsl:apply-templates>
						</imvert-ep:associations>
				</xsl:when>
				<!-- In de volgende twee when's worden de superclasses of relatieclasses van de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt,
					  de eerste in de attributes mode en de tweede in de association mode. -->
				<xsl:when test="$resolvingEntity != ''
										and $proces-type = 'attributes'">
						<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
							<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
							<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="proces-type" select="$proces-type"/>
							<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
							<xsl:with-param name="entiteitType" select="$entiteitType"/>
							<xsl:with-param name="relatie" select="$relatie"/>
						</xsl:apply-templates>
						<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
							<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
							<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="entiteitType" select="$entiteitType"/>
							<xsl:with-param name="entity" select="$resolvingEntity"/>
							<xsl:with-param name="sourceEntity" select="$entity"/>
							<xsl:with-param name="relatie" select="$relatie"/>
						</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$resolvingEntity != ''
										and $proces-type = 'associations'">
						<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
							<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
							<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="proces-type" select="$proces-type"/>
							<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
							<xsl:with-param name="entiteitType" select="$entiteitType"/>
							<xsl:with-param name="relatie" select="$relatie"/>
						</xsl:apply-templates>
						<xsl:choose>
							<xsl:when test="not(contains($id-trail,concat('#2#',imvert:id,'#')))">
								<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
									<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
									<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
									<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
									<xsl:with-param name="entity" select="$resolvingEntity"/>
									<xsl:with-param name="sourceEntity" select="$entity"/>
									<xsl:with-param name="entiteitType" select="$entiteitType"/>
									<xsl:with-param name="id-trail">
										<xsl:choose>
											<xsl:when test="contains($id-trail,concat('#1#',imvert:id,'#'))">
												<xsl:value-of select="concat('#2#',imvert:id,'#',$id-trail)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat('#1#',imvert:id,'#',$id-trail)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="relatie" select="$relatie"/>
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								<imvert-ep:recursive-association>
									<xsl:comment select="'Moet nog worden gecodeerd.'"/>
								</imvert-ep:recursive-association>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="imvert:stereotype" mode="create-message-content"/>
		</imvert-ep:class>
	</xsl:template>
	
	<xsl:template match="imvert:class" mode="create-message-relations-content">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtNaam"/>
		<xsl:param name="berichtCode"/>
		<!-- Deze parameter is nodig om te kunnen bepalen welke Class in het imvertor bestand verwerkt moet worden. -->
		<xsl:param name="entiteitType" select="imvert:alias"/>
		<!-- Deze parameter wordt gebruikt om te kunnen bepalen in welk stadium de opbouw van het bericht is. Is het overkoepelende 'imvert-ep:class' element al aangemaakt
			  of moet dat nog gebeuren. Indien deze parameter leeg is dan is dat element nog niet aangemaakt en moet in dit template de eerste when geactiveerd worden. 

			  MISSCHIEN KUNNEN WE HIER OOK EEN TOGGLE PARAMETER VAN MAKEN MET DE WAARDE 'yes' EN 'no'. -->
		<xsl:param name="resolvingEntity" select="''"/>
		<!-- Indien de bovenstaande parameter gevuld is dan wordt deze parameter gebruikt om te bepalen in welke modus dit template moet worden gebruikt. Moeten de attributes 
			  van een superclass of een gerelateerde class worden opgehaald of moeten de associations van een superclass of een gerelateerde class worden opgehaald. -->
		<xsl:param name="proces-type" select="''"/>
		<xsl:param name="entity" select="imvert:name/@original"/>
		<xsl:param name="id-trail"/>
		<xsl:param name="relatie" select="'-'"/>
			<xsl:if test="$debug='yes'">
				<xsl:comment select="'imvert:class[mode=create-message-relations-structure]'"/>
			</xsl:if>
			<imvert-ep:class packageType="{ancestor::imvert:package/imvert:name/@original}"  stereotype="{imvert:stereotype}"  id="{imvert:id}">
				<xsl:choose>
					<!-- In deze eerste when wordt de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt. 
						 Dit is de class waarvan de waarde van 'imvert:alias' gelijk is aan de kolom 'entiteittype' van het in bewerking zijnde berichttype. -->
						 
					<!-- Deze when kan waarschijnlijk weg omdat dit template pas wordt aangeroepen als de relaties in bewerking zijn. -->
					<xsl:when test="$resolvingEntity = ''">
						<xsl:comment select="'LET OP: Als deze tekst toont dan klopt er iets niet. Deze when tak zou nooit geactiveerd mogen worden.'"/>
					</xsl:when>
					<!-- In de volgende twee when's worden de superclasses of relatieclasses van de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt,
						  de eerste in de attributes mode en de tweede in de association mode. -->
					<xsl:when test="$resolvingEntity != ''
											and $proces-type = 'attributes'">
						<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
							<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
							<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="proces-type" select="$proces-type"/>
							<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
							<xsl:with-param name="entiteitType" select="$entiteitType"/>
							<xsl:with-param name="relatie" select="$relatie"/>
						</xsl:apply-templates>
						<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
							<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
							<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
							<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
							<xsl:with-param name="entiteitType" select="$entiteitType"/>
							<xsl:with-param name="entity" select="$entity"/>
							<xsl:with-param name="sourceEntity" select="$entity"/>
							<xsl:with-param name="relatie" select="$relatie"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$resolvingEntity != ''
											and $proces-type = 'associations'">
							<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
								<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
								<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
								<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
								<xsl:with-param name="proces-type" select="$proces-type"/>
								<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
								<xsl:with-param name="entiteitType" select="$entiteitType"/>
								<xsl:with-param name="relatie" select="$relatie"/>
							</xsl:apply-templates>
							<xsl:choose>
								<xsl:when test="not(contains($id-trail,concat('#2#',imvert:id,'#')))">
									<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
										<xsl:with-param name="typeBericht" select="$typeBericht"/><!-- bijv. Vraagbericht -->
										<xsl:with-param name="berichtNaam" select="$berichtNaam"/><!-- bijv. standaard of nps-alternatief -->
										<xsl:with-param name="berichtCode" select="$berichtCode"/><!-- bijv. Lv01 of Lk01 -->
										<xsl:with-param name="entity" select="$entity"/>
										<xsl:with-param name="sourceEntity" select="$entity"/>
										<xsl:with-param name="entiteitType" select="$entiteitType"/>
										<xsl:with-param name="id-trail">
											<xsl:choose>
												<xsl:when test="contains($id-trail,concat('#1#',imvert:id,'#'))">
													<xsl:value-of select="concat('#2#',imvert:id,'#',$id-trail)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="concat('#1#',imvert:id,'#',$id-trail)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
										<xsl:with-param name="relatie" select="$relatie"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:otherwise>
									<imvert-ep:recursive-structure>
										<xsl:comment select="'Moet nog worden gecodeerd.'"/>
									</imvert-ep:recursive-structure>
								</xsl:otherwise>
							</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</imvert-ep:class>
	</xsl:template>

	<xsl:template match="imvert:name" mode="replicate-imvert-elements">
		<imvert-ep:name original="{@original}"><xsl:value-of select="."/></imvert-ep:name>
	</xsl:template>
	
	<!-- template voor het simpelweg repliceren van elementen. Repliceert nog geen attributes. -->
	<xsl:template match="*" mode="replicate-imvert-elements">
		<xsl:element name="{concat('imvert-ep:',local-name())}">
			<xsl:choose>
				<xsl:when test="*">
					<xsl:apply-templates select="*" mode="replicate-imvert-elements"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<!--<xsl:template match="imvert:min-occurs" mode="replicate-imvert-min-occurs">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtNaam"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="entiteitType"/>
		<xsl:param name="entity"/>
		<xsl:param name="relatie"/>
		<xsl:if test="$enriched-endproduct-config-excel//row[
									col[@naam='entiteittype']/data = $entiteitType
									and col[@naam='typeBericht']/data = $context
									and substring(col[@naam='berichtcode']/data,string-length(col[@naam='berichtcode']/data)-1,2) = $berichtCode
									and (($berichtNaam = 'standaard' and col[@naam='berichtnaam']/data = '') or col[@naam='berichtnaam']/data = $berichtNaam)
									and col[@naam='entiteit']/data = $entity 
									and col[@naam='relatie']/data = $relatie 
									and col[@naam='imvert-id']/data = current()/../imvert:id]">
			<xsl:element name="imvert-ep:min-occurs">
				<xsl:attribute name="original" select="current()/."/>
				<xsl:variable name="id" select="current()/../imvert:id"/>
				<xsl:value-of select="substring-before($enriched-endproduct-config-excel//row[
									col[@naam='entiteittype']/data = $entiteitType
									and col[@naam='typeBericht']/data = $context
									and substring(col[@naam='berichtcode']/data,string-length(col[@naam='berichtcode']/data)-1,2) = $berichtCode
									and (($berichtNaam = 'standaard' and col[@naam='berichtnaam']/data = '') or col[@naam='berichtnaam']/data = $berichtNaam)
									and col[@naam='entiteit']/data = $entity 
									and col[@naam='relatie']/data = $relatie 
									and col[@naam='imvert-id']/data = current()/../imvert:id]/col[@naam='kardinaliteit']/data,'..')"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="imvert:max-occurs" mode="replicate-imvert-max-occurs">
		<xsl:param name="typeBericht"/>
		<xsl:param name="berichtNaam"/>
		<xsl:param name="berichtCode"/>
		<xsl:param name="context"/>
		<xsl:param name="entiteitType"/>
		<xsl:param name="entity"/>
		<xsl:param name="relatie"/>
		<xsl:if test="$enriched-endproduct-config-excel//row[
									col[@naam='entiteittype']/data = $entiteitType
									and col[@naam='typeBericht']/data = $context
									and substring(col[@naam='berichtcode']/data,string-length(col[@naam='berichtcode']/data)-1,2) = $berichtCode
									and (($berichtNaam = 'standaard' and col[@naam='berichtnaam']/data = '') or col[@naam='berichtnaam']/data = $berichtNaam)
									and col[@naam='entiteit']/data = $entity 
									and col[@naam='relatie']/data = $relatie 
									and col[@naam='imvert-id']/data = current()/../imvert:id]">
			<xsl:element name="imvert-ep:max-occurs">
				<xsl:attribute name="original" select="current()/."/>
				<xsl:value-of select="substring-after($enriched-endproduct-config-excel//row[
									col[@naam='entiteittype']/data = $entiteitType
									and col[@naam='typeBericht']/data = $context
									and substring(col[@naam='berichtcode']/data,string-length(col[@naam='berichtcode']/data)-1,2) = $berichtCode
									and (($berichtNaam = 'standaard' and col[@naam='berichtnaam']/data = '') or col[@naam='berichtnaam']/data = $berichtNaam)
									and col[@naam='entiteit']/data = $entity 
									and col[@naam='relatie']/data = $relatie 
									and col[@naam='imvert-id']/data = current()/../imvert:id]/col[@naam='kardinaliteit']/data,'..')"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
-->        
	<xsl:template match="imvert:class" mode="create-datatype-content">
		<!--<imvert-ep:class4 packageType="{ancestor::imvert:package/imvert:name/@original}"  stereotype="{imvert:stereotype}"  id="{imvert:id}">-->
			<xsl:choose>
				<!-- De eerste when tackled de situatie waarbij het datatype van een attribute geen simpleType betreft maar toch een complexType. In feite verwijst een attribute dan naar een objectType.
					  Deze situatie doet zich bijv. voor als we in een union verwijzen naar een entiteit in de ´Model´ package. -->					  
				<xsl:when test="imvert:stereotype='objecttype'">
					<xsl:apply-templates select="." mode="create-message-content"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="imvert:attributes" mode="create-datatype-content"/>
				</xsl:otherwise>
			</xsl:choose>
		<!--</imvert-ep:class4>-->
	</xsl:template>
	
	<xsl:template match="imvert:attributes" mode="create-datatype-content">
		<imvert-ep:attributes>
			<xsl:apply-templates select="imvert:attribute" mode="create-datatype-content"/>
		</imvert-ep:attributes>
	</xsl:template>
	
 	<xsl:template match="imvert:attribute" mode="create-datatype-content">
		<imvert-ep:attribute>
			<xsl:apply-templates select="imvert:name" mode="create-datatype-content"/>
			<xsl:apply-templates select="imvert:stereotype" mode="create-datatype-content"/>
		</imvert-ep:attribute>
	</xsl:template>

 	<xsl:template match="imvert:name" mode="create-datatype-content">
		<imvert-ep:name original="{@original}">
			<xsl:value-of select="."/>
		</imvert-ep:name>
	</xsl:template>

 	<xsl:template match="imvert:stereotype" mode="create-datatype-content">
		<imvert-ep:stereotype><xsl:value-of select="."/></imvert-ep:stereotype>
	</xsl:template>

 	<xsl:template match="imvert:stereotype" mode="create-message-content">
		<imvert-ep:stereotype><xsl:value-of select="."/></imvert-ep:stereotype>
	</xsl:template>

	<xsl:function name="imf:determineBerichtCode">
		<xsl:param name="typeBericht" as="xs:string"/>
		<xsl:param name="tagged-values"/>
		<xsl:choose>
			<xsl:when test="$typeBericht='Vraagbericht'">
				<xsl:choose>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">Lv01</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">Lv02</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">Lv05</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">Lv06</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">Lv07</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">Lv08</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">Lv09</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">Lv10</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$typeBericht='AntwoordBericht'">
				<xsl:choose>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">La01</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">La02</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">Lav05</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'No'">La06</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">La07</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'No' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">La08</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">La09</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isFormeel']/imvert:value = 'Yes' and 
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isMaterieel']/imvert:value = 'Yes'">La10</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$typeBericht='KennisgevingBericht'">
				<xsl:choose>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No'">Lk01</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes'">Lk02</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$typeBericht='Vrij bericht'">
				<xsl:choose>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isInkomend']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No'">Di01</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isInkomend']/imvert:value = 'Yes' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes'">Di02</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isInkomend']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'No'">Du01</xsl:when>
					<xsl:when test="$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isInkomend']/imvert:value = 'No' and
											$tagged-values/imvert:tagged-values/imvert:tagged-value[imvert:name/@original='isSynchroon']/imvert:value = 'Yes'">Du02</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
 