<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2XSD-KING-endproduct.xsl 3 2015-11-05 10:35:07Z ArjanLoeffen $ 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:UML="omg.org/UML1.3"
	xmlns:imvert="http://www.imvertor.org/schema/system"
	xmlns:imf="http://www.imvertor.org/xsl/functions"
	xmlns:imvert-result="http://www.imvertor.org/schema/imvertor/application/v20160201"
	xmlns:bg="http://www.egem.nl/StUF/sector/bg/0310"
	xmlns:metadata="http://www.kinggemeenten.nl/metadataVoorVerwerking"
	xmlns:ztc="http://www.kinggemeenten.nl/ztc0310" xmlns:stuf="http://www.egem.nl/StUF/StUF0301"
	xmlns:imvert-ep="http://www.imvertor.org/schema/endproduct"
	xmlns:ss="http://schemas.openxmlformats.org/spreadsheetml/2006/main" version="2.0">

	<?x Voor het plaatsen van deze processing instructie werkte alles naar behoren. x?>

	<xsl:output indent="yes" method="xml" encoding="UTF-8"/>

	<xsl:variable name="stylesheet">Imvert2XSD-KING-create-endproduct-structure</xsl:variable>
	<xsl:variable name="stylesheet-version">$Id: Imvert2XSD-KING-create-endproduct-structure.xsl 1
		2015-11-11 11:50:00Z RobertMelskens $</xsl:variable>

	<xsl:variable name="tagged-values">
		<xsl:sequence select="//imvert:package[imvert:name = 'Bericht']//imvert:class[imvert:name = 'Bericht']/imvert:tagged-values"/>
	</xsl:variable>

	<xsl:template match="imvert:package[imvert:name = 'Bericht']" mode="create-message-structure">
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:package[mode=create-message-structure]'"/>
		</xsl:if>
		<imvert-ep:endproduct-structures>
			<xsl:apply-templates
				select="
					imvert:class[imvert:name = 'Vraagbericht' or
					imvert:name = 'AntwoordBericht' or
					imvert:name = 'KennisgevingBericht' or
					imvert:name = 'VrijBericht']"
				mode="create-initial-message-structure"> </xsl:apply-templates>
		</imvert-ep:endproduct-structures>
	</xsl:template>

	<xsl:template match="imvert:class" mode="create-initial-message-structure">
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:class[mode=create-initial-message-structure]'"/>
		</xsl:if>
		<xsl:variable name="berichtCode"
			select="imf:determineBerichtCode(imvert:name, $tagged-values)"/>
		<imvert-ep:message name="{$berichtNaam}" typeBericht="{imvert:name}"
			berichtCode="{$berichtCode}" packageType="{ancestor::imvert:package/imvert:name}"
			stereotype="{imvert:stereotype}">
			<xsl:sequence select="imf:create-output-element('imvert-ep:name', imvert:name)"/>
			<xsl:sequence select="imf:create-output-element('imvert-ep:alias', imvert:alias)"/>
			<xsl:if test="imf:boolean($debug)">
				<xsl:sequence select="imf:create-output-element('imvert-ep:id', imvert:id)"/>
			</xsl:if>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:documentation', imvert:documentation)"/>
			<?x Voor het volgende element moet zo nodig nog code geschreven worden. x?>
			<imvert-ep:tagged-values> </imvert-ep:tagged-values>
			<imvert-ep:attributes>
				<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
					<xsl:with-param name="proces-type" select="'attributes'"/>
					<xsl:with-param name="resolvingEntity" select="imvert:name"/>
				</xsl:apply-templates>
				<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
					<xsl:with-param name="sourceEntity" select="imvert:name"/>
				</xsl:apply-templates>
			</imvert-ep:attributes>
			<imvert-ep:associations>
				<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
					<xsl:with-param name="proces-type" select="'associations'"/>
					<xsl:with-param name="resolvingEntity" select="imvert:name"/>
				</xsl:apply-templates>
				<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
					<xsl:with-param name="entity" select="imvert:name"/>
					<xsl:with-param name="sourceEntity" select="imvert:name"/>
					<xsl:with-param name="id-trail" select="concat('#1#', imvert:id, '#')"/>
				</xsl:apply-templates>
			</imvert-ep:associations>
		</imvert-ep:message>
	</xsl:template>

	<!-- Dit template initialiseert de verwerking van de superclasses van de in bewerking zijnde class. -->
	<xsl:template match="imvert:supertype" mode="create-message-content">
		<xsl:param name="proces-type"/>
		<xsl:param name="resolvingEntity"/>
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:supertype[mode=create-message-content]'"/>
		</xsl:if>
		<xsl:variable name="imvertId" select="imvert:type-id"/>
		<?x xsl:element name="{concat('imvert-ep:',$proces-type,'-supertype')}" x?>
			<xsl:apply-templates select="//imvert:class[imvert:id = $imvertId]"	mode="create-message-content">
				<xsl:with-param name="proces-type" select="$proces-type"/>
				<xsl:with-param name="entity" select="imvert:type-name"/>
				<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
			</xsl:apply-templates>
		<?x /xsl:element x?>
	</xsl:template>

	<?x xsl:template match="imvert:attributes" mode="create-message-content">
		<xsl:param name="sourceEntity"/>
		<xsl:variable name="name" select="imvert:name"/>
		<xsl:variable name="type-id" select="imvert:type-id"/>
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:attribute[mode=create-message-content]'"/>
		</xsl:if>
		<imvert-ep:attributes>
			
		</imvert-ep:attributes>
	</xsl:template x?>
	
	<xsl:template match="imvert:attribute" mode="create-message-content">
		<xsl:param name="sourceEntity"/>
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:attribute[mode=create-message-content]'"/>
		</xsl:if>
		<xsl:variable name="name" select="imvert:name"/>
		<xsl:variable name="type-id" select="imvert:type-id"/>
		<!-- In de onderstaande when statements is een check opgenomen op het berichtType zodat de juiste rijen geselecteerd worden. -->
		<imvert-ep:attribute>
			<xsl:attribute name="sourceEntity" select="$sourceEntity"/>
			<xsl:sequence select="imf:create-output-element('imvert-ep:name', imvert:name)"/>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:min-occurs', imvert:min-occurs)"/>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:max-occurs', imvert:max-occurs)"/>
			<xsl:choose>
				<!--<xsl:when test="imvert:type-id and not(imvert:stereotype='attribuutsoort')">-->
				<xsl:when test="imvert:type-id">
					<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-datatype-content"/>
				</xsl:when>
				<xsl:otherwise>
					<?x xsl:apply-templates select="//imvert:class[imvert:id=current()/imvert:type-id]" mode="create-message-content"/ x?>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Waarschijnlijk kunnen we ook de elementen 'imvert:is-id' en 'imvert:baretype' weglaten. Volgende apply-templates kan ik ook vervangen door 
				 een aantal sequences met imf:create-output-element() functie. -->
			<xsl:apply-templates
				select="*[local-name() != 'name' and local-name() != 'id' and local-name() != 'stereotype' and local-name() != 'min-occurs' and local-name() != 'max-occurs' and local-name() != 'type-id' 
				          and local-name() != 'position' and local-name() != 'merged' and local-name() != 'tagged-values' and local-name() != 'is-value-derived' and local-name() != 'conceptual-schema-type' 
				          and local-name() != 'attribute-type-designation' and local-name() != 'type-package-id' and local-name() != 'type-modifier']"
				mode="replicate-imvert-elements"/>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:stereotype', imvert:stereotype)"/>
		</imvert-ep:attribute>
	</xsl:template>

	<xsl:template match="imvert:association" mode="create-message-content">
		<xsl:param name="entity"/>
		<xsl:param name="sourceEntity"/>
		<xsl:param name="id-trail"/>
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:association[mode=create-message-content]'"/>
		</xsl:if>
		<xsl:variable name="name">
			<xsl:choose>
				<xsl:when test="imvert:name != ''">
					<xsl:value-of select="imvert:name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="imvert:name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- In de onderstaande when statements is een check opgenomen op het berichtType zodat de juiste rijen geselecteerd worden. -->
		<imvert-ep:association packageType="{ancestor::imvert:package/imvert:name}">
			<xsl:attribute name="sourceEntity" select="$sourceEntity"/>
			<xsl:variable name="type-id" select="imvert:type-id"/>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:associationName', //imvert:class[imvert:id = $type-id]/imvert:name)"/>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:alias', //imvert:class[imvert:id = $type-id]/imvert:alias)"/>
			<xsl:if test="imf:boolean($debug)">
				<xsl:sequence
					select="imf:create-output-element('imvert-ep:id', //imvert:class[imvert:id = $type-id]/imvert:id)"
				/>
			</xsl:if>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:documentation', //imvert:class[imvert:id = $type-id]/imvert:documentation)"/>
			<xsl:apply-templates select="imvert:name" mode="replicate-imvert-elements"/>
			<xsl:apply-templates select="imvert:min-occurs | imvert:max-occurs"
				mode="replicate-imvert-elements"/>
			<!-- Volgende apply-templates kan ik ook vervangen door een aantal sequences met imf:create-output-element() functie. -->
			<xsl:apply-templates
				select="*[local-name() != 'name' and local-name() != 'id' and local-name() != 'stereotype' and local-name() != 'min-occurs' and local-name() != 'max-occurs' 
						  and local-name() != 'type-id' and local-name() != 'position' and local-name() != 'merged' and local-name() != 'tagged-values' and local-name() != 'association-class' 
						  and local-name() != 'type-name' and local-name() != 'type-package' and local-name() != 'min-occurs-source' and local-name() != 'max-occurs-source' 
						  and local-name() != 'role-target' and local-name() != 'source-navigable' and local-name() != 'target-navigable' and local-name() != 'aggregation']"
				mode="replicate-imvert-elements"/>
			<xsl:apply-templates select="imvert:association-class"
				mode="create-message-relations-content">
				<xsl:with-param name="proces-type" select="'associations'"/>
				<xsl:with-param name="resolvingEntity" select="$entity"/>
				<xsl:with-param name="id-trail" select="$id-trail"/>
				<xsl:with-param name="entity" select="imvert:type-name"/>
			</xsl:apply-templates>
			<imvert-ep:attributes>
				<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-message-content">
					<xsl:with-param name="proces-type" select="'attributes'"/>
					<xsl:with-param name="resolvingEntity" select="$entity"/>
					<xsl:with-param name="id-trail" select="$id-trail"/>
				</xsl:apply-templates>
			</imvert-ep:attributes>
			<imvert-ep:associations>
				<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-message-relations-content">
					<xsl:with-param name="proces-type" select="'associations'"/>
					<xsl:with-param name="resolvingEntity" select="$entity"/>
					<xsl:with-param name="id-trail" select="$id-trail"/>
					<xsl:with-param name="entity" select="imvert:type-name"/>
				</xsl:apply-templates>
			</imvert-ep:associations>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:stereotype', imvert:stereotype)"/>
		</imvert-ep:association>
	</xsl:template>

	<xsl:template match="imvert:association-class" mode="create-message-relations-content">
		<xsl:param name="proces-type" select="'associations'"/>
		<xsl:param name="resolvingEntity"/>
		<xsl:param name="id-trail"/>
		<xsl:param name="entity"/>
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:association-class[mode=create-message-relations-content]'"/>
		</xsl:if>
		<imvert-ep:relation packageType="{ancestor::imvert:package/imvert:name}"
			stereotype="{imvert:stereotype}">
			<xsl:if test="imf:boolean($debug)">
				<xsl:attribute name="id" select="imvert:id"/>
			</xsl:if>
			<xsl:variable name="type-id" select="imvert:type-id"/>
			<imvert-ep:attributes>
				<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]" mode="create-message-content">
					<xsl:with-param name="proces-type" select="'attributes'"/>
					<xsl:with-param name="resolvingEntity" select="$entity"/>
					<xsl:with-param name="id-trail" select="$id-trail"/>
				</xsl:apply-templates>
			</imvert-ep:attributes>
			<imvert-ep:associations>
				<xsl:apply-templates select="//imvert:class[imvert:id = $type-id]"
					mode="create-message-relations-content">
					<xsl:with-param name="proces-type" select="'associations'"/>
					<xsl:with-param name="resolvingEntity" select="$entity"/>
					<xsl:with-param name="id-trail" select="$id-trail"/>
					<xsl:with-param name="entity" select="imvert:type-name"/>
				</xsl:apply-templates>
			</imvert-ep:associations>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:stereotype', imvert:stereotype)"/>
		</imvert-ep:relation>
	</xsl:template>

	<xsl:template match="imvert:class" mode="create-message-content">
		<!-- Deze parameter wordt gebruikt om te kunnen bepalen in welk stadium de opbouw van het bericht is. Is het overkoepelende 'imvert-ep:complexType' element al aangemaakt
			  of moet dat nog gebeuren. Indien deze parameter leeg is dan is dat element nog niet aangemaakt en moet in dit template de eerste when geactiveerd worden. 

			  MISSCHIEN KUNNEN WE HIER OOK EEN TOGGLE PARAMETER VAN MAKEN MET DE WAARDE 'yes' EN 'no'. -->
		<xsl:param name="resolvingEntity" select="''"/>
		<!-- Indien de bovenstaande parameter gevuld is dan wordt deze parameter gebruikt om te bepalen in welke modus dit template moet worden gebruikt. Moeten de attributes 
			  van een superclass of een gerelateerde class worden opgehaald of moeten de associations van een superclass of een gerelateerde class worden opgehaald. -->
		<xsl:param name="proces-type" select="''"/>
		<xsl:param name="entity" select="imvert:name"/>
		<!-- De volgende parameter heeft alleen een functie als dit template wordt gebruikt voor de verwerking van relaties. Met deze parameter voorkomen we dat relaties recursief 
			  tot in het oneindige worden geprocessed. Indien een relatie voor de tweede keer wordt geprocessed dan moet het proces stoppen. -->
		<xsl:param name="id-trail"/>
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:class[mode=create-message-content]'"/>
		</xsl:if>
		<!-- De packageType bepaald hoe er omgegaan moet worden met associations. Indien de packageType gelijk is aan 'Model' dan worden associations vertaald naar relaties 
			  waarbinnen gerelateerde entiteiten worden geplaatts. Is de packageType echter gelijk aan 'Bericht' dan worden associations vertaalt naar normale container elementen.-->
		<?x imvert-ep:complexType packageType="{ancestor::imvert:package/imvert:name}"
			stereotype="{imvert:stereotype}" x?>
			<xsl:if test="imf:boolean($debug)">
				<xsl:sequence
					select="imf:create-output-element('imvert-ep:id', imvert:id)"/>
				<xsl:comment select="concat('resolvingEntity: (',$resolvingEntity,') ,proces-type: ',$proces-type)"/>
			</xsl:if>
			<?x xsl:sequence select="imf:create-output-element('imvert-ep:name', imvert:name)"/ x?>
			<xsl:choose>
				<!-- In de volgende twee when's worden de superclasses of relatieclasses van de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt,
					  de eerste in de attributes mode en de tweede in de association mode. -->
				<?x xsl:when test="
						$resolvingEntity != ''
						and $proces-type = 'attributes'">
					<xsl:if test="imf:boolean($debug)">
						<xsl:comment select="'$resolvingEntity != empty and $proces-type = attributes'"/>
					</xsl:if>
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
							<xsl:with-param name="proces-type" select="$proces-type"/>
							<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
						</xsl:apply-templates>
						<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
							<xsl:with-param name="sourceEntity" select="$entity"/>
						</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$resolvingEntity != ''
						and $proces-type = 'associations'">
					<xsl:if test="imf:boolean($debug)">
						<xsl:comment select="'$resolvingEntity != empty and $proces-type = associations'"/>
					</xsl:if>
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="proces-type" select="$proces-type"/>
						<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
					</xsl:apply-templates>
					<xsl:choose>
						<xsl:when test="not(contains($id-trail, concat('#2#', imvert:id, '#')))">
							<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
								<xsl:with-param name="entity" select="$resolvingEntity"/>
								<xsl:with-param name="sourceEntity" select="$entity"/>
								<xsl:with-param name="id-trail">
									<xsl:choose>
										<xsl:when
											test="contains($id-trail, concat('#1#', imvert:id, '#'))">
											<xsl:value-of
												select="concat('#2#', imvert:id, '#', $id-trail)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of
												select="concat('#1#', imvert:id, '#', $id-trail)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<imvert-ep:recursive-association>
								<!-- Indien recursie gaat voorkomen dan moet dit nog worden gecodeerd. -->
							</imvert-ep:recursive-association>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when x?>
				<xsl:when test="
					$proces-type = 'attributes'">
					<xsl:if test="imf:boolean($debug)">
						<xsl:comment select="'$resolvingEntity = empty and $proces-type = attributes'"/>
					</xsl:if>
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="proces-type" select="$proces-type"/>
						<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
					</xsl:apply-templates>
					<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
						<xsl:with-param name="sourceEntity" select="$entity"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="
					$proces-type = 'associations'">
					<xsl:if test="imf:boolean($debug)">
						<xsl:comment select="'$resolvingEntity = empty and $proces-type = associations'"/>
					</xsl:if>
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="proces-type" select="$proces-type"/>
						<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
					</xsl:apply-templates>
					<xsl:choose>
						<xsl:when test="not(contains($id-trail, concat('#2#', imvert:id, '#')))">
							<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
								<xsl:with-param name="entity" select="$resolvingEntity"/>
								<xsl:with-param name="sourceEntity" select="$entity"/>
								<xsl:with-param name="id-trail">
									<xsl:choose>
										<xsl:when
											test="contains($id-trail, concat('#1#', imvert:id, '#'))">
											<xsl:value-of
												select="concat('#2#', imvert:id, '#', $id-trail)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of
												select="concat('#1#', imvert:id, '#', $id-trail)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<imvert-ep:recursive-association>
								<!-- Indien recursie gaat voorkomen dan moet dit nog worden gecodeerd. -->
							</imvert-ep:recursive-association>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- In deze when wordt de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt. 
					 Dit is de class waarvan de waarde van 'imvert:alias' gelijk is aan de kolom 'entiteittype' van het in bewerking zijnde berichttype. -->
				<xsl:otherwise>
					<?x xsl:when test="$resolvingEntity = ''" x?>
					<xsl:if test="imf:boolean($debug)">
						<xsl:comment select="'$resolvingEntity = notempty'"/>
					</xsl:if>
					<xsl:sequence select="imf:create-output-element('imvert-ep:name', $entity)"/>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:alias', imvert:alias)"/>
					<xsl:if test="imf:boolean($debug)">
						<xsl:sequence select="imf:create-output-element('imvert-ep:id', imvert:id)"
						/>
					</xsl:if>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:documentation', imvert:documentation)"/>
					<imvert-ep:attributes>
						<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
							<xsl:with-param name="proces-type" select="'attributes'"/>
							<xsl:with-param name="resolvingEntity" select="$entity"/>
						</xsl:apply-templates>
						<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
							<xsl:with-param name="sourceEntity" select="$entity"/>
						</xsl:apply-templates>
					</imvert-ep:attributes>
					<imvert-ep:associations>
						<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
							<xsl:with-param name="proces-type" select="'associations'"/>
							<xsl:with-param name="resolvingEntity" select="$entity"/>
						</xsl:apply-templates>
						<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
							<xsl:with-param name="entity" select="$entity"/>
							<xsl:with-param name="sourceEntity" select="$entity"/>
							<xsl:with-param name="id-trail"
								select="concat('#1#', imvert:id, '#', $id-trail)"/>
						</xsl:apply-templates>
					</imvert-ep:associations>
				<?x /xsl:when x?>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:sequence
				select="imf:create-output-element('imvert-ep:stereotype', imvert:stereotype)"/>
		<?x /imvert-ep:complexType x?>
	</xsl:template>

	<xsl:template match="imvert:class" mode="create-message-relations-content">
		<!-- Deze parameter wordt gebruikt om te kunnen bepalen in welk stadium de opbouw van het bericht is. Is het overkoepelende 'imvert-ep:complexType' element al aangemaakt
			  of moet dat nog gebeuren. Indien deze parameter leeg is dan is dat element nog niet aangemaakt en moet in dit template de eerste when geactiveerd worden. 

			  MISSCHIEN KUNNEN WE HIER OOK EEN TOGGLE PARAMETER VAN MAKEN MET DE WAARDE 'yes' EN 'no'. -->
		<xsl:param name="resolvingEntity" select="''"/>
		<!-- Indien de bovenstaande parameter gevuld is dan wordt deze parameter gebruikt om te bepalen in welke modus dit template moet worden gebruikt. Moeten de attributes 
			  van een superclass of een gerelateerde class worden opgehaald of moeten de associations van een superclass of een gerelateerde class worden opgehaald. -->
		<xsl:param name="proces-type" select="''"/>
		<xsl:param name="entity" select="imvert:name"/>
		<xsl:param name="id-trail"/>
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:class[mode=create-message-relations-content]'"/>
		</xsl:if>
		<?x imvert-ep:complexType packageType="{ancestor::imvert:package/imvert:name}"
			stereotype="{imvert:stereotype}" x?>
			<xsl:if test="imf:boolean($debug)">
				<xsl:sequence
					select="imf:create-output-element('imvert-ep:id', imvert:id)"/>
			</xsl:if>
			<xsl:choose>
				<!-- In deze eerste when wordt de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt. 
						 Dit is de class waarvan de waarde van 'imvert:alias' gelijk is aan de kolom 'entiteittype' van het in bewerking zijnde berichttype. -->

				<!-- Deze when kan waarschijnlijk weg omdat dit template pas wordt aangeroepen als de relaties in bewerking zijn. -->
				<xsl:when test="$resolvingEntity = ''">
					<xsl:comment select="'LET OP: Als deze tekst toont dan klopt er iets niet. Deze when tak zou nooit geactiveerd mogen worden.'"/>
				</xsl:when>
				<!-- In de volgende twee when's worden de superclasses of relatieclasses van de class die gerelateerd is aan het in bewerking zijnde berichttype verwerkt,
						  de eerste in de attributes mode en de tweede in de association mode. -->
				<xsl:when test="
						$resolvingEntity != ''
						and $proces-type = 'attributes'">
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="proces-type" select="$proces-type"/>
						<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
					</xsl:apply-templates>
					<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
						<xsl:with-param name="sourceEntity" select="$entity"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when
					test="
						$resolvingEntity != ''
						and $proces-type = 'associations'">
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="proces-type" select="$proces-type"/>
						<xsl:with-param name="resolvingEntity" select="$resolvingEntity"/>
					</xsl:apply-templates>
					<xsl:choose>
						<xsl:when test="not(contains($id-trail, concat('#2#', imvert:id, '#')))">
							<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
								<xsl:with-param name="entity" select="$entity"/>
								<xsl:with-param name="sourceEntity" select="$entity"/>
								<xsl:with-param name="id-trail">
									<xsl:choose>
										<xsl:when
											test="contains($id-trail, concat('#1#', imvert:id, '#'))">
											<xsl:value-of
												select="concat('#2#', imvert:id, '#', $id-trail)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of
												select="concat('#1#', imvert:id, '#', $id-trail)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<imvert-ep:recursive-structure>
								<!-- Indien recursie gaat voorkomen dan moet dit nog worden gecodeerd. -->
							</imvert-ep:recursive-structure>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		<?x /imvert-ep:complexType x?>
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

	<xsl:template match="imvert:class" mode="create-datatype-content">
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:class[mode=create-datatype-content]'"/>
		</xsl:if>
		<xsl:choose>
			<!-- De eerste when tackled de situatie waarbij het datatype van een attribute geen simpleType betreft maar toch een complexType. In feite verwijst een attribute dan naar een objectType.
					  Deze situatie doet zich bijv. voor als we in een union verwijzen naar een entiteit in de ´Model´ package. -->
			<xsl:when test="imvert:stereotype = 'OBJECTTYPE'">
				<?x xsl:message>================LET OP! LET OP! LET OP! LET OP! LET OP! LET OP! LET OP! LET OP! LET OP!===============</xsl:message>
				<xsl:apply-templates select="*" mode="create-message-content"/ x?>
				<imvert-ep:attributes>
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="proces-type" select="'attributes'"/>
						<xsl:with-param name="resolvingEntity" select="imvert-ep:name"/>
					</xsl:apply-templates>
					<xsl:apply-templates select=".//imvert:attribute" mode="create-message-content">
						<xsl:with-param name="sourceEntity" select="imvert-ep:name"/>
					</xsl:apply-templates>
				</imvert-ep:attributes>
				<imvert-ep:associations>
					<xsl:apply-templates select="imvert:supertype" mode="create-message-content">
						<xsl:with-param name="proces-type" select="'associations'"/>
						<xsl:with-param name="resolvingEntity" select="imvert-ep:name"/>
					</xsl:apply-templates>
					<xsl:apply-templates select=".//imvert:association" mode="create-message-content">
						<xsl:with-param name="entity" select="imvert-ep:name"/>
						<xsl:with-param name="sourceEntity" select="imvert-ep:name"/>
						<?x xsl:with-param name="id-trail"
							select="concat('#1#', imvert:id, '#', $id-trail)"/ x?>
					</xsl:apply-templates>
				</imvert-ep:associations>
			</xsl:when>
			<xsl:when test="imvert:stereotype = 'ENUMERATION'">
				<imvert-ep:datatype id="{imvert:id}">
					<xsl:apply-templates select="imvert:attributes/imvert:attribute" mode="create-datatype-content"/>
				</imvert-ep:datatype>
			</xsl:when>
			<xsl:when test="imvert:stereotype = 'DATATYPE'">
				<xsl:choose>
					<!-- In de when tak betreft het eigenlijk een soort van groepselement vandaar dat we hier een imvert-ep:attributes element genereren. -->
					<xsl:when test="imvert:attributes/imvert:attribute">
						<imvert-ep:attributes>
							<xsl:apply-templates select="imvert:attributes/imvert:attribute" mode="create-datatype-content"/>
						</imvert-ep:attributes>
					</xsl:when>
					<xsl:otherwise>
						<imvert-ep:datatype id="{imvert:id}">
							<xsl:apply-templates select="imvert:documentation" mode="replicate-imvert-elements"/>
						</imvert-ep:datatype>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<imvert-ep:attributes>
					<xsl:apply-templates select="imvert:attributes/imvert:attribute" mode="create-datatype-content"/>
				</imvert-ep:attributes>	
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="imvert:attribute" mode="create-datatype-content">
		<xsl:if test="imf:boolean($debug)">
			<xsl:comment select="'imvert:attribute[mode=create-datatype-content]'"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="imvert:stereotype = 'ENUM'">
				<imvert-ep:enumeration>
					<xsl:sequence select="imf:create-output-element('imvert-ep:name', imvert:name)"/>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:min-occurs', imvert:min-occurs)"/>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:max-occurs', imvert:max-occurs)"/>
					<xsl:choose>
						<!--<xsl:when test="imvert:type-id and not(imvert:stereotype='attribuutsoort')">-->
						<xsl:when test="imvert:type-id">
							<xsl:apply-templates select="//imvert:class[imvert:id = current()/imvert:type-id]" mode="create-datatype-content"/>
						</xsl:when>
						<!--<xsl:otherwise>
					<xsl:apply-templates select="//imvert:class[imvert:id=current()/imvert:type-id]" mode="create-message-content"/>
				</xsl:otherwise>-->
					</xsl:choose>
					<!-- Waarschijnlijk kunnen we ook de elementen 'imvert:is-id' en 'imvert:baretype' weglaten. Volgende apply-templates kan ik ook vervangen door 
				  		 een aantal sequences met imf:create-output-element() functie. -->
					<xsl:apply-templates
						select="*[local-name() != 'name' and local-name() != 'id' and local-name() != 'stereotype' and local-name() != 'min-occurs' and local-name() != 'max-occurs' and local-name() != 'type-id' 
								  and local-name() != 'position' and local-name() != 'merged' and local-name() != 'tagged-values' and local-name() != 'is-value-derived' and local-name() != 'conceptual-schema-type' 
								  and local-name() != 'attribute-type-designation' and local-name() != 'type-package-id' and local-name() != 'type-modifier']"
						mode="replicate-imvert-elements"/>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:stereotype', imvert:stereotype)"/>
				</imvert-ep:enumeration>
			</xsl:when>
			<xsl:otherwise>
				<imvert-ep:attribute>
					<xsl:sequence select="imf:create-output-element('imvert-ep:name', imvert:name)"/>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:min-occurs', imvert:min-occurs)"/>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:max-occurs', imvert:max-occurs)"/>
					<xsl:choose>
						<!--<xsl:when test="imvert:type-id and not(imvert:stereotype='attribuutsoort')">-->
						<xsl:when test="imvert:type-id">
							<xsl:apply-templates select="//imvert:class[imvert:id = current()/imvert:type-id]" mode="create-datatype-content"/>
						</xsl:when>
						<!--<xsl:otherwise>
					<xsl:apply-templates select="//imvert:class[imvert:id=current()/imvert:type-id]" mode="create-message-content"/>
				</xsl:otherwise>-->
					</xsl:choose>
					<!-- Waarschijnlijk kunnen we ook de elementen 'imvert:is-id' en 'imvert:baretype' weglaten. Volgende apply-templates kan ik ook vervangen door 
				  		 een aantal sequences met imf:create-output-element() functie. -->
					<xsl:apply-templates
						select="*[local-name() != 'name' and local-name() != 'id' and local-name() != 'stereotype' and local-name() != 'min-occurs' and local-name() != 'max-occurs' and local-name() != 'type-id' 
						and local-name() != 'position' and local-name() != 'merged' and local-name() != 'tagged-values' and local-name() != 'is-value-derived' and local-name() != 'conceptual-schema-type' 
						and local-name() != 'attribute-type-designation' and local-name() != 'type-package-id' and local-name() != 'type-modifier']"
						mode="replicate-imvert-elements"/>
					<xsl:sequence
						select="imf:create-output-element('imvert-ep:stereotype', imvert:stereotype)"/>
				</imvert-ep:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="imf:determineBerichtCode">
		<xsl:param name="typeBericht" as="xs:string"/>
		<xsl:param name="tagged-values"/>
		<xsl:choose>
			<xsl:when test="$typeBericht = 'Vraagbericht'">
				<xsl:choose>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>Lv01</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>Lv02</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>Lv05</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>Lv06</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>Lv07</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>Lv08</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>Lv09</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>Lv10</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('test: ', $typeBericht)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$typeBericht = 'AntwoordBericht'">
				<xsl:choose>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>La01</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>La02</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>Lav05</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'No']"
						>La06</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>La07</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>La08</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>La09</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsFormeel']/imvert:value = 'Yes' and
							imvert:tagged-values/imvert:tagged-value[imvert:name = 'IsMaterieel']/imvert:value = 'Yes']"
						>La10</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$typeBericht = 'KennisgevingBericht'">
				<xsl:choose>
					<xsl:when
						test="$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No']"
						>Lk01</xsl:when>
					<xsl:when
						test="$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes']"
						>Lk02</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$typeBericht = 'Vrij bericht'">
				<xsl:choose>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsInkomend']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No']"
						>Di01</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsInkomend']/imvert:value = 'Yes' and
							imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes']"
						>Di02</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsInkomend']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'No']"
						>Du01</xsl:when>
					<xsl:when
						test="
							$tagged-values/imvert:tagged-values[imvert:tagged-value[imvert:name = 'IsInkomend']/imvert:value = 'No' and
							imvert:tagged-value[imvert:name = 'IsSynchroon']/imvert:value = 'Yes']"
						>Du02</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>

	</xsl:function>

</xsl:stylesheet>
