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
    xmlns:uml="http://schema.omg.org/spec/UML/2.1"
    xmlns:UML="omg.org/UML1.3"
    xmlns:thecustomprofile="http://www.sparxsystems.com/profiles/thecustomprofile/1.0"
    xmlns:EAUML="http://www.sparxsystems.com/profiles/EAUML/1.0"
    xmlns:xmi="http://schema.omg.org/spec/XMI/2.1"
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-doc.xsl"/>
    <xsl:import href="../common/Imvert-common-entity.xsl"/>
    
    <!-- Transform XMI 1.1 to Imvert format. According to metamodel BP. -->
 
    <xsl:variable name="document" select="/"/>

    <xsl:variable 
        name="extension-elements"          
        select="$document//xmi:Extension/elements/element[@scope='public']"/>
    <xsl:variable 
        name="extension-attributes"      
        select="$extension-elements/attributes/attribute[@scope='Public']"/>
    <xsl:variable 
        name="extension-connectors" 
        select="$document//xmi:Extension/connectors/connector"/>
    <xsl:variable 
        name="document-thecustomprofile" 
        select="$document//thecustomprofile:*"/>
    <xsl:variable 
        name="document-EAUML" 
        select="$document//EAUML:*"/>
    
    <xsl:variable 
        name="document-packages" 
        select="$document//UML:Package"/>
    <xsl:variable 
        name="document-elements" 
        select="$document//element"/>
    <xsl:variable 
        name="document-connectors" 
        select="$document//connector"/>
    <xsl:variable 
        name="document-attributes" 
        select="$document//attribute"/>

    <xsl:key name="key-construct-by-id" match="//*[@xmi.id]" use="@xmi.id"/>
    <xsl:key name="key-construct-by-idref" match="//*[@xmi:idref]" use="@xmi:idref"/>
    <xsl:key name="key-packages-by-alias" match="//package" use="properties/@alias"/>
    
    <xsl:variable 
        name="document-realisations" 
        select="$document//UML:Dependency[UML:ModelElement.taggedValue/UML:TaggedValue[@tag='ea_type' and @value='Realisation']]"/>
    
    <xsl:variable name="additional-tagged-values" select="imf:get-config-tagged-values()" as="element(tv)*"/>
    
    <xsl:output encoding="UTF-8" method="xml" indent="no"/>
       
    <xsl:template match="/">
        <imvert:packages>
            <xsl:if test="imf:boolean($debug)">
                <debug-info>
                    <configuration-owner-file>
                        <xsl:sequence select="$configuration-owner-file"/>
                    </configuration-owner-file>
                    <configuration-metamodel-file>
                        <xsl:sequence select="$configuration-metamodel-file"/>
                    </configuration-metamodel-file>
                    <configuration-schemarules-file>
                        <xsl:sequence select="$configuration-schemarules-file"/>
                    </configuration-schemarules-file>
                    <configuration-tvset-file>
                        <xsl:sequence select="$configuration-tvset-file"/>
                    </configuration-tvset-file>
                    <xref-props>
                        <xsl:sequence select="$parsed-xref-properties"/> 
                    </xref-props>
                    <additional-tagged-values>
                        <xsl:sequence select="$additional-tagged-values"/> 
                    </additional-tagged-values>
                </debug-info>
            </xsl:if>
            <xsl:sequence select="imf:create-output-element('imvert:debug',$debug)"/>
            <xsl:sequence select="imf:create-output-element('imvert:project',$project-name)"/>
            <xsl:sequence select="imf:create-output-element('imvert:application',$application-package-name)"/>
            <xsl:sequence select="imf:create-output-element('imvert:generated',$generation-date)"/>
            <xsl:sequence select="imf:create-output-element('imvert:generator',$imvertor-version)"/>
            <xsl:sequence select="imf:create-output-element('imvert:exported',concat(replace(/XMI/@timestamp,' ','T'),'Z'))"/>
            <xsl:sequence select="imf:create-output-element('imvert:exporter',concat(//XMI.documentation/XMI.exporter,' v ', //XMI.documentation/XMI.exporterVersion))"/>
            <xsl:sequence select="imf:compile-imvert-filter()"/>
            
            <xsl:variable name="project-name-shown" select="($project-name, concat($owner-name,': ',$project-name))" as="xs:string+"/>
            <xsl:variable name="root-package" select="$document-packages[imf:get-normalized-name(@name,'system-name') = $project-name-shown][imf:get-stereotypes(.)=imf:get-config-stereotypes('stereotype-name-project-package')]"/>
            
            <xsl:choose>
                <xsl:when test="empty($root-package)">
                    <xsl:sequence select="imf:msg('FATAL',concat(
                        'Specified project &quot;', 
                        string-join($project-name-shown,'&quot; or &quot;'),
                        '&quot; should exist and be stereotyped as: ', 
                          imf:get-config-stereotypes('stereotype-name-project-package')))"/>
                </xsl:when>
                <xsl:when test="not(imf:get-config-has-owner())">
                    <xsl:sequence select="imf:msg('ERROR',
                        'Not a known owner: [1]',
                        ($owner-name)
                         )"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="$content/UML:Model/UML:Namespace.ownedElement/UML:Package">
                        <xsl:sort select="@name"/>
                        <xsl:sort select="imf:get-alias(.,'P')"/>
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </imvert:packages>
    </xsl:template>
  
    <!-- all selected packages result in schema's -->
    <xsl:template match="UML:Package">
        <xsl:param name="parent-is-derived" select="false()"/>
        
        <xsl:variable name="package-name" select="@name" as="xs:string"/>
        <xsl:variable name="package-id" select="@xmi.id" as="xs:string"/>
        <xsl:variable name="namespace" select="imf:get-alias(.,'P')"/>
        <xsl:variable name="metamodel" select="imf:get-tagged-value(.,'metamodel')"/>
        
        <xsl:variable name="supplier-info" select="imf:get-supplier-info(.,$parent-is-derived)" as="element()*"/>
        <xsl:variable name="is-derived" select="imf:boolean($supplier-info[self::imvert:derived])"/>
        <imvert:package>
            <!--<xsl:sequence select="imf:msg(.,'STATUS','Processing package',@name)"/>-->
            <xsl:sequence select="imf:get-id-info(.,'P')"/>
            <xsl:sequence select="$supplier-info"/>
            <xsl:sequence select="imf:create-output-element('imvert:namespace',$namespace)"/>
            <xsl:sequence select="imf:create-output-element('imvert:metamodel',$metamodel)"/>
            <xsl:sequence select="imf:get-element-documentation-info(.)"/>
            <xsl:sequence select="imf:get-history-info(.)"/>
            <xsl:sequence select="imf:get-svn-info(.)"/>
            <xsl:sequence select="imf:get-stereotypes-info(.,'my')"/>
            <xsl:sequence select="imf:get-external-resources-info(.)"/>
            <xsl:sequence select="imf:get-config-info(.)"/>
            <xsl:for-each select="UML:Namespace.ownedElement/UML:Class"> <!-- was: [not(imf:get-stereotype-local-names(*/UML:Stereotype/@name)='enumeration')] -->
                <xsl:sort select="replace(@name,'_','')"/>
                <xsl:apply-templates select="." mode="class-normal"/>
            </xsl:for-each>
            <xsl:for-each select="UML:Namespace.ownedElement/UML:Package">
                <xsl:sort select="@name"/>
                <xsl:sort select="imf:get-alias(.,'P')"/>
                <xsl:apply-templates select=".">
                    <xsl:with-param name="parent-is-derived" select="$is-derived"/>
                </xsl:apply-templates>
            </xsl:for-each>
            <!-- add info on import dependecy relations (always to external packages) -->
            <xsl:for-each select="UML:Namespace.ownedElement/UML:Dependency[imf:get-stereotype-local-names(UML:ModelElement.stereotype/UML:Stereotype/@name)='import' and @client=$package-id]">
                <xsl:sequence select="imf:create-output-element('imvert:imported-package-id',@supplier)"/>
            </xsl:for-each>
            <xsl:sequence select="imf:fetch-additional-tagged-values(.)"/>

            <!-- check if xlinks must be included -->
            <xsl:if test="imf:get-stereotypes(.)=imf:get-config-stereotypes('stereotype-name-project-package') and not(exists($document-packages[imf:get-normalized-name(@name,'package-name') = imf:get-normalized-name('xlinks','package-name')]))" >
                <imvert:package>
                    <imvert:found-name>Xlinks</imvert:found-name>
                    <imvert:short-name>xlinks</imvert:short-name>
                    <imvert:id>XLINKS</imvert:id>
                    <imvert:namespace>http://www.w3.org/1999/xlink</imvert:namespace>
                    <imvert:documentation>
                        <body xmlns="http://www.w3.org/1999/xhtml">XLinks is an external specification. For documentation please consult http://www.w3.org/TR/xlink/</body>
                    </imvert:documentation>
                    <imvert:created>2014-10-30T17:01:50</imvert:created>
                    <imvert:modified>2014-10-30T17:01:50</imvert:modified>
                    <imvert:version>1.0.0</imvert:version>
                    <imvert:phase>3</imvert:phase>
                    <imvert:author>Simon Cox</imvert:author>
                    <imvert:svn-string>Id: xlinks.xml 346 2013-05-06 08:34:33Z loeffa </imvert:svn-string>
                    <imvert:stereotype>
                        <xsl:value-of select="imf:get-normalized-name('system','stereotype-name')"/>
                    </imvert:stereotype>
                    <imvert:location>http://schemas.opengis.net/xlink/1.0.0/xlinks.xsd</imvert:location>
                    <imvert:release>20010627</imvert:release>
                </imvert:package>
            </xsl:if>
        </imvert:package>
    </xsl:template>
    
    <xsl:template match="UML:Package[imf:get-stereotypes(.) = imf:get-config-stereotypes('stereotype-name-recyclebin')]">
        <!-- IM-86: skip! -->
    </xsl:template>
    
    <xsl:template match="UML:Class" mode="class-normal">
        <xsl:variable name="id" select="@xmi.id"/>
        <xsl:variable name="supertype-ids" select="$document-generalizations-type[@subtype=$id]/@supertype"/>
        <xsl:variable name="attributes" select="UML:Classifier.feature/UML:Attribute"/>
        <xsl:variable name="stereotypes" select="imf:get-stereotypes(.)" as="xs:string*"/>
        <xsl:variable name="associations" select="imf:get-key('key-document-associations-type',$id)"/>
        <xsl:variable name="is-abstract" select="if (imf:boolean(@isAbstract)) then 'true' else 'false'"/>
        <xsl:variable name="is-datatype" select="$stereotypes=imf:get-config-stereotypes('stereotype-name-datatype') or imf:get-tagged-value(.,'ea_stype')='DataType'"/>
        <xsl:variable name="is-complextype" select="$stereotypes=imf:get-config-stereotypes('stereotype-name-complextype')"/>
        <!-- TODO overal de referenties naar expliciete stereotype names vervangen door imf:get-config-stereotypes('stereotype-name-*') -->
        <xsl:variable name="class-cardinality" select="imf:get-class-cardinality-bounds(.)"/>
        <xsl:variable name="designation">
            <xsl:choose>
                <xsl:when test="imf:get-tagged-value(.,'ea_stype')='DataType'">datatype</xsl:when>
                <xsl:when test="$stereotypes[imf:get-normalized-name(.,'class-name') = imf:get-normalized-name('datatype','class-name')]">datatype</xsl:when>
                <xsl:when test="$stereotypes[imf:get-normalized-name(.,'stereotype-name') = imf:get-normalized-name('enumeration','stereotype-name')]">enumeration</xsl:when>
                <xsl:when test="imf:get-tagged-value(.,'ea_stype')='Class'">class</xsl:when>
                <xsl:when test="$document-associations/UML:ModelElement.taggedValue/UML:TaggedValue[@tag='associationclass']/@value=$id">associationclass</xsl:when>
                <xsl:otherwise>other</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$designation != 'other'">
            <imvert:class>
                <xsl:sequence select="imf:get-id-info(.,'C')"/>
                <xsl:sequence select="imf:create-output-element('imvert:designation',$designation)"/>
                <xsl:sequence select="imf:create-output-element('imvert:abstract',$is-abstract)"/>
                <xsl:sequence select="imf:get-element-documentation-info(.)"/>
                <xsl:sequence select="imf:get-history-info(.)"/>
                <xsl:sequence select="imf:get-stereotypes-info(.,'my')"/>
                <xsl:sequence select="imf:get-external-resources-info(.)"/>
                <xsl:for-each select="$supertype-ids">
                    <xsl:variable name="supertype-id" select="."/>
                    <xsl:variable name="supertype" select="imf:element-by-id($supertype-id)"/>
                    
                    <xsl:variable name="generalization" select="imf:get-key('key-document-generalizations', concat($id,'#',$supertype-id))"/>
                    <xsl:variable name="stereotypes" select="imf:get-stereotypes($generalization)"/>
                    
                    <xsl:choose>
                        <xsl:when test="$stereotypes=imf:get-config-stereotypes('stereotype-name-static-liskov')">
                            <imvert:substitution>
                                <xsl:sequence select="imf:create-output-element('imvert:supplier',$supertype/@name)"/>
                                <xsl:sequence select="imf:create-output-element('imvert:supplier-id',$supertype-id)"/>
                                <xsl:sequence select="imf:create-output-element('imvert:supplier-package',imf:get-package-name($supertype-id))"/>
                                <xsl:sequence select="for $s in $stereotypes return imf:create-output-element('imvert:stereotype',$s)"/>
                                <xsl:sequence select="imf:create-output-element('imvert:position',imf:get-position-value($generalization,'100'))"/>
                            </imvert:substitution>     
                        </xsl:when>
                        <xsl:otherwise>
                            <imvert:supertype>
                                <xsl:sequence select="imf:create-output-element('imvert:type-name',$supertype/@name)"/>
                                <xsl:sequence select="imf:create-output-element('imvert:type-id',$supertype-id)"/>
                                <xsl:sequence select="imf:create-output-element('imvert:type-package',imf:get-package-name($supertype-id))"/>
                                <xsl:sequence select="for $s in $stereotypes return imf:create-output-element('imvert:stereotype',$s)"/>
                                <xsl:sequence select="imf:create-output-element('imvert:position',imf:get-position-value($generalization,'100'))"/>
                            </imvert:supertype>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                
                <xsl:sequence select="imf:create-output-element('imvert:min-occurs',$class-cardinality[1])"/>
                <xsl:sequence select="imf:create-output-element('imvert:max-occurs',$class-cardinality[2])"/>
                <xsl:choose>
                    <xsl:when test="$is-datatype or $is-complextype">
                        <xsl:sequence select="imf:get-datatype-info(.)"/>
                        <imvert:attributes>
                            <xsl:for-each select="$attributes">
                                <imvert:attribute>
                                    <xsl:sequence select="imf:get-id-info(.,'A')"/>
                                    <xsl:sequence select="imf:get-attribute-info(.)"/>
                                    <xsl:sequence select="imf:get-attribute-documentation-info(.)"/>
                                    <!-- <xsl:sequence select="imf:get-history-info(.)"/> not available for attribute -->
                                    <xsl:sequence select="imf:get-stereotypes-info(.,'my')"/>
                                    <xsl:sequence select="imf:get-constraint-info(.)"/>
                                    <xsl:sequence select="imf:get-external-resources-info(.)"/>
                                    <xsl:sequence select="imf:fetch-additional-tagged-values(.)"/>
                                </imvert:attribute>
                            </xsl:for-each>
                        </imvert:attributes>
                    </xsl:when>
                    <xsl:otherwise>
                        <imvert:attributes>
                            <xsl:for-each select="$attributes">
                                <imvert:attribute>
                                    <xsl:sequence select="imf:get-id-info(.,'A')"/>
                                    <xsl:sequence select="imf:get-attribute-info(.)"/>
                                    <xsl:sequence select="imf:get-attribute-documentation-info(.)"/>
                                    <!-- <xsl:sequence select="imf:get-history-info(.)"/> not available for attribute -->
                                    <xsl:sequence select="imf:get-stereotypes-info(.,'my')"/>
                                    <xsl:sequence select="imf:get-constraint-info(.)"/>
                                    <xsl:sequence select="imf:get-external-resources-info(.)"/>
                                    <xsl:sequence select="imf:fetch-additional-tagged-values(.)"/>
                                </imvert:attribute>
                            </xsl:for-each>
                        </imvert:attributes>
                        <imvert:associations>
                            <xsl:for-each select="$associations">
                                <imvert:association>
                                    <xsl:sequence select="imf:get-id-info(.,'R')"/>
                                    <xsl:sequence select="imf:get-association-info(.)"/>
                                    <xsl:sequence select="imf:get-association-documentation-info(.)"/>
                                    <!-- <xsl:sequence select="imf:get-history-info(.)"/>-->
                                    <xsl:sequence select="imf:get-stereotypes-info(.,'my')"/>
                                    <xsl:sequence select="imf:get-stereotypes-info(.,'src')"/>
                                    <xsl:sequence select="imf:get-stereotypes-info(.,'dst')"/>
                                    <xsl:sequence select="imf:get-constraint-info(.)"/>
                                    <xsl:sequence select="imf:get-association-class-info(.)"/>
                                    <xsl:sequence select="imf:fetch-additional-tagged-values(.)"/>
                                </imvert:association>                            
                            </xsl:for-each>
                        </imvert:associations>
                        <xsl:if test="$designation='associationclass'">
                            <!--TODO enhance: check correct implementation of association class -->
                            <xsl:variable name="association" select="$document-associations[imf:get-tagged-value(.,'associationclass')=$id]"/>
                            <imvert:associates>
                                <xsl:variable name="source-localid" select="$association/*/UML:AssociationEnd[imf:get-tagged-value(.,'ea_end')='source']/@type"/>
                                <xsl:variable name="source" select="imf:element-by-id($source-localid)"/>
                                <xsl:variable name="target-localid" select="$association/*/UML:AssociationEnd[imf:get-tagged-value(.,'ea_end')='target']/@type"/>
                                <xsl:variable name="target" select="imf:element-by-id($target-localid)"/>
                                <imvert:source>
                                    <xsl:sequence select="imf:get-id-info($source,'C')"/>
                                </imvert:source>
                                <imvert:target>
                                    <xsl:sequence select="imf:get-id-info($target,'C')"/>
                                </imvert:target>
                            </imvert:associates>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:sequence select="imf:get-constraint-info(.)"/>
                <xsl:sequence select="imf:fetch-additional-tagged-values(.)"/>
            </imvert:class>     
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="UML:Class" mode="class-enumeration">
        <imvert:class>
            <xsl:sequence select="imf:get-id-info(.,'C')"/>
            <xsl:sequence select="imf:create-output-element('imvert:designation','enumeration')"/>
            <xsl:sequence select="imf:get-element-documentation-info(.)"/>
            <xsl:sequence select="imf:get-history-info(.)"/>
            <xsl:sequence select="imf:get-stereotypes-info(.,'my')"/>
            <xsl:sequence select="imf:get-constraint-info(.)"/>
            <xsl:sequence select="imf:get-external-resources-info(.)"/>
            <xsl:for-each select="*/UML:Attribute">
                <xsl:sequence select="imf:create-output-element('imvert:enum',@name)"/>
            </xsl:for-each>
            <xsl:sequence select="imf:fetch-additional-tagged-values(.)"/>
        </imvert:class>
    </xsl:template>
    
    <xsl:template match="*|@*|text()">
      <xsl:apply-templates/>  
    </xsl:template>
    
    <xsl:function name="imf:element-by-id" as="node()*">
        <xsl:param name="id" as="xs:string?"/>
        <xsl:if test="$id">
            <xsl:sequence select="imf:get-key('key-construct-by-id',$id)"/>
        </xsl:if>
    </xsl:function>
  
    <xsl:function name="imf:get-custom-values" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:variable name="id" select="$this/@xmi:id"/>
        <xsl:variable name="customs" select="($document-thecustomprofile[@*=$id], $document-EAUML[@*=$id])"/>
        <xsl:for-each select="$customs">
            <xsl:variable name="name" select="local-name(.)"/>
            <custom xmlns="" name="{$name}">
                <xsl:variable name="value" select="@*[local-name()=$name]"/>
                <xsl:if test="$value">
                    <xsl:attribute name="value" select="$value"/>
                </xsl:if>
            </custom>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="imf:get-stereotypes" as="xs:string*">
        <xsl:param name="this" as="element()"/>
        <xsl:variable name="local-stereotype" select="imf:get-tagged-value($this,('stereotype','destStereotype'))"/> <!-- destStereotype only for association destinations -->
        <xsl:variable name="xref-stereotype" select="imf:get-stereotypes($this,'my')"/>
        <!-- if stereotypes have been stored in xref stereotype string, then this also holds the local stereotypes -->
        <xsl:variable name="stereotypes" select="for $s in ($xref-stereotype,$local-stereotype) return imf:get-normalized-name($s,'stereotype-name')"/>
        <xsl:sequence select="imf:get-stereotype-local-names(distinct-values($stereotypes))"/>
    </xsl:function>
    
    <xsl:function name="imf:get-stereotypes" as="xs:string*">
        <xsl:param name="this" as="element()"/>
        <xsl:param name="origin" as="xs:string"/>
        <xsl:variable name="stereotypes" as="xs:string*">
            <!-- stereotypes are sometimes set on the relation as a tagged value, as well as within a xref string -->
            <xsl:sequence select="if ($origin = 'my') then imf:get-tagged-value($this,'stereotype') else ()"/> 
            <!-- if stereotypes have been stored in xref stereotype string, then this also holds the local stereotypes -->
            <xsl:sequence select="$parsed-xref-properties[@id=generate-id($this) and @origin=$origin]/imvert:props/imvert:stereos/imvert:name"/>
        </xsl:variable>
        <xsl:variable name="stereotypes" select="distinct-values(for $s in $stereotypes return imf:get-normalized-name($s,'stereotype-name'))"/>
        <xsl:sequence select="imf:get-stereotype-local-names($stereotypes)"/>
    </xsl:function>
    
    <xsl:function name="imf:get-stereotypes-info" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="origin" as="xs:string"/>
        <xsl:variable name="stereotypes" select="imf:get-stereotypes($this,$origin)"/>
        <xsl:for-each select="$stereotypes">
            <xsl:sort select="."/>
            <xsl:choose>
                <xsl:when test="$origin = 'my'">
                    <xsl:sequence select="imf:create-output-element('imvert:stereotype',imf:get-normalized-name(.,'stereotype-name'))"/>
                </xsl:when>
                <xsl:when test="$origin = 'dst'">
                    <xsl:sequence select="imf:create-output-element('imvert:target-stereotype',imf:get-normalized-name(.,'stereotype-name'))"/>
                </xsl:when>
                <xsl:when test="$origin = 'src'">
                    <xsl:sequence select="imf:create-output-element('imvert:source-stereotype',imf:get-normalized-name(.,'stereotype-name'))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="imf:get-element-documentation-info" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:sequence select="imf:get-documentation-info($this,'documentation')"/>
    </xsl:function>
   
    <xsl:function name="imf:get-attribute-documentation-info" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:sequence select="imf:get-documentation-info($this,'description')"/>
    </xsl:function>
  
    <xsl:function name="imf:get-association-documentation-info" as="node()*">
        <xsl:param name="this" as="node()"/> <!-- UML:Association -->
        <xsl:sequence select="imf:get-documentation-info($this,'documentation')"/> 
    </xsl:function>
    
    <xsl:function name="imf:get-documentation-info" as="item()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="name" as="xs:string"/>
        <xsl:variable name="doctext" select="imf:get-tagged-value($this,$name,'')"/>
        <xsl:variable name="relevant-doc-string" select="if (contains($doctext,imf:get-config-parameter('documentation-separator'))) then substring-before($doctext,imf:get-config-parameter('documentation-separator')) else $doctext"/>
        <xsl:variable name="parsed-doc-struct" select="imf:eadoc-to-xhtml($relevant-doc-string)"/>
        <xsl:if test="exists($doctext) and normalize-space($relevant-doc-string)">
            <imvert:documentation xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml">
                <xsl:sequence select="$parsed-doc-struct/*"/>
            </imvert:documentation>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="imf:get-history-info" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:sequence select="imf:create-output-element('imvert:created',imf:date-to-isodate(imf:get-tagged-value($this,'date_created')))"/>
        <xsl:sequence select="imf:create-output-element('imvert:modified',imf:date-to-isodate(imf:get-tagged-value($this,'date_modified')))"/>
        <xsl:sequence select="imf:create-output-element('imvert:version',imf:get-tagged-value($this,'version'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:phase', imf:get-phase-description(imf:get-tagged-value($this,'phase'))[1])"/>
        <xsl:sequence select="imf:create-output-element('imvert:author',imf:get-tagged-value($this,'author'))"/>
    </xsl:function>
 
    <xsl:function name="imf:get-external-resources-info" as="node()*">
        <xsl:param name="this" as="node()"/>
        <!-- 
            Wanneer referentie naar externe data (waardenlijst), haal URI op.
            Als die niet is gespecificeerd op de relatie, neem dan de data locatie van de gerefereneerde waardelijst klasse op.
        -->
        <xsl:variable name="type-id" select="$this/UML:StructuralFeature.type/UML:Classifier/@xmi.idref"/>
        <xsl:variable name="vl" select="imf:element-by-id($type-id)"/>
        <xsl:variable name="dataloc" select="if (exists($vl)) then (imf:get-tagged-value($vl,'data-location'),imf:get-tagged-value($vl,'Data locatie')) else ()"/>
        <xsl:variable name="webloc" select="if (exists($vl)) then (imf:get-tagged-value($vl,'web-location'),imf:get-tagged-value($vl,'Web locatie')) else ()"/>
        <xsl:sequence select="imf:create-output-element('imvert:data-location',(imf:get-tagged-value($this,'data-location'),imf:get-tagged-value($this,'Data locatie'),$dataloc)[1])"/>
        <xsl:sequence select="imf:create-output-element('imvert:web-location',(imf:get-tagged-value($this,'web-location'),imf:get-tagged-value($this,'Web locatie'),$webloc)[1])"/>
    </xsl:function>
   
    <xsl:function name="imf:get-xsd-filepath" as="xs:string">
        <xsl:param name="this" as="node()"/>
        <xsl:value-of select="(imf:get-tagged-value($this,'location'),imf:get-tagged-value($this,'xsd-location'))[1]"/>
    </xsl:function>
    
    <xsl:function name="imf:get-client-release" as="xs:string">
        <xsl:param name="this" as="node()"/>
        <xsl:value-of select="imf:get-tagged-value($this,'release')[1]"/>
    </xsl:function>
    
    <xsl:function name="imf:get-id-info" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="type" as="xs:string"/><!-- Class, Attribute, Relation, Package --> 
        <xsl:variable name="name" select="distinct-values(($this/@name, $this/*/UML:AssociationEnd[imf:get-tagged-value(.,'ea_end')='target']/@name))"/> <!-- 2nd option only for associations, deprecated when following RSB profile -->
        <xsl:variable name="xref-isid" select="$parsed-xref-properties[@id=generate-id($this)]/imvert:props/imvert:des[imvert:name = 'isID']/imvert:valu = '1'"/>
        <xsl:if test="$name[1]">
            <xsl:sequence select="imf:create-output-element('imvert:found-name',normalize-space($name[1]))"/>
            <xsl:if test="$this/self::UML:Package">
                <xsl:sequence select="imf:create-output-element('imvert:short-name',imf:get-short-name($name[1]))"/>
            </xsl:if>
        </xsl:if>
        <xsl:sequence select="imf:create-output-element('imvert:alias',imf:get-alias($this,$type))"/>
        <xsl:variable name="id" select="distinct-values(($this/@xmi.id, imf:get-tagged-value($this,'ea_guid')))"/> 
        <xsl:sequence select="imf:create-output-element('imvert:id',$id[1])"/>
        <xsl:sequence select="imf:create-output-element('imvert:keywords',imf:get-tagged-value($this,'keywords'))"/> 
        <xsl:sequence select="imf:create-output-element('imvert:is-value-derived',if (imf:get-tagged-value($this,'derived') = '1') then 'true' else ())"/> 
        <xsl:sequence select="imf:create-output-element('imvert:is-id',if ($xref-isid) then 'true' else ())"/> 
        <xsl:sequence select="imf:create-output-element('imvert:trace',imf:get-trace-id($this,$type))"/> 
        
    </xsl:function>

    <xsl:function name="imf:get-supplier-info" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="parent-is-derived" as="xs:boolean"/>
        
        <xsl:variable name="supplier-info" as="element()*">
            <xsl:sequence select="imf:create-output-element('imvert:supplier-name',imf:get-tagged-value($this,'supplier-name'))"/>
            <xsl:sequence select="imf:create-output-element('imvert:supplier-project',imf:get-tagged-value($this,'supplier-project'))"/>
            <xsl:sequence select="imf:create-output-element('imvert:supplier-release',imf:get-tagged-value($this,'supplier-release'))"/>
            <xsl:sequence select="imf:create-output-element('imvert:supplier-package-name',imf:get-tagged-value($this,'supplier-package-name'))"/>
        </xsl:variable>
        <xsl:variable name="derived" select="imf:get-tagged-value($this,'derived')"/>
        
        <xsl:sequence select="$supplier-info"/>
        <xsl:variable name="derived-because-stated" select="(exists($derived) and imf:boolean($derived))"/>
        <xsl:variable name="not-derived-because-stated" select="(exists($derived) and not(imf:boolean($derived)))"/>
        
        <xsl:sequence select="imf:create-output-element('imvert:derived',
            if (exists($supplier-info) and $not-derived-because-stated) then 'false' 
            else if ($derived-because-stated) then 'true' 
            else if (exists($supplier-info)) then 'true' 
            else if ($parent-is-derived and $not-derived-because-stated) then 'false' 
            else if ($parent-is-derived) then 'true' 
            else    'false')"/>
    </xsl:function>
   
    <xsl:function name="imf:get-config-info" as="node()*">
        <xsl:param name="this" as="node()"/> 
        <xsl:sequence select="imf:create-output-element('imvert:location',imf:get-xsd-filepath($this))"/>
        <xsl:sequence select="imf:create-output-element('imvert:release',imf:get-client-release($this))"/>
        <xsl:sequence select="imf:create-output-element('imvert:ref-version',imf:get-tagged-value($this,'ref-version'))"/> <!-- optional -->
        <xsl:sequence select="imf:create-output-element('imvert:ref-release',imf:get-tagged-value($this,'ref-release'))"/> <!-- optional -->
    </xsl:function>
    
    <xsl:function name="imf:get-datatype-info" as="node()*">
        <xsl:param name="this" as="node()"/> <!-- packagedElement -->
        <!-- IM-69 introduceer de mogelijkheid datatypen naar systeem typen te mappen -->
        <xsl:sequence select="imf:create-output-element('imvert:primitive',imf:get-tagged-value($this,'primitive'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:pattern',imf:get-tagged-value($this,('pattern','patroon')))"/>
        <xsl:sequence select="imf:create-output-element('imvert:min-length',imf:get-tagged-value($this,'minLength'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:max-length',imf:get-tagged-value($this,'maxLength'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:union',imf:get-tagged-value($this,'union'))"/>
    </xsl:function>
    
    <xsl:function name="imf:get-attribute-info" as="node()*">
        <xsl:param name="this" as="node()"/> <!-- an UML:Attribute -->
        <xsl:variable name="type-id" select="$this/UML:StructuralFeature.type/UML:Classifier/@xmi.idref"/>
        <xsl:variable name="type" select="imf:element-by-id($type-id)"/>
        <xsl:variable name="type-fullname" select="$type/@name"/>
        <xsl:variable name="type-modifier" select="if (contains($type-fullname,'?')) then '?' else if (contains($type-fullname,'+P')) then '+P' else ()"/> 
        <xsl:variable name="type-name" select="if (exists($type-modifier)) then substring-before($type-fullname,$type-modifier) else $type-fullname"/>
        <xsl:variable name="type-normname" select="imf:get-normalized-name($type-name,'baretype-name')"/>
        <xsl:choose>
            <xsl:when test="not($type-name)">
                <!-- this is an enumeration (value), skip -->
            </xsl:when>
            <!-- process the baretypes -->
            <xsl:when test="$type-id and imf:is-baretype($type-name)">
                <!-- a type such as TXT, AN, N10, AN10, N8.2 or N8,2. Baretypes are translated to local type declarations -->
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-name)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-package','Info_Types_Package')"/>
                
                <xsl:analyze-string select="$type-name" regex="{$baretype-pattern}">
                    <xsl:matching-substring>
                        <xsl:variable name="type" select="regex-group(1)"/>
                        <xsl:variable name="positions" select="regex-group(2)"/>
                        <xsl:variable name="decimals" select="regex-group(4)"/>
                        <xsl:variable name="pattern" select="regex-group(5)"/>
                        <!--<xsl:message select="string-join(($type-name, $type, $positions, $decimals,$pattern),', ')"></xsl:message>-->
                        <xsl:choose>
                            <xsl:when test="$type='AN'">
                                <xsl:sequence select="imf:create-output-element('imvert:type-name','string')"/><!-- used to be 'char' -->
                                <xsl:sequence select="imf:create-output-element('imvert:max-length',$positions)"/>
                            </xsl:when>
                            <xsl:when test="$type='N' and not($decimals)">
                                <xsl:sequence select="imf:create-output-element('imvert:type-name','integer')"/>
                                <xsl:sequence select="imf:create-output-element('imvert:total-digits',$positions)"/>
                            </xsl:when>
                            <xsl:when test="$type='N'">
                                <xsl:sequence select="imf:create-output-element('imvert:type-name','decimal')"/>
                                <xsl:sequence select="imf:create-output-element('imvert:fraction-digits',$decimals)"/>
                                <xsl:sequence select="imf:create-output-element('imvert:total-digits',xs:string(xs:integer($positions) + xs:integer($decimals)))"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:sequence select="imf:create-output-element('imvert:type-modifier',$type-modifier)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <!-- process the scalars: -->
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname='ANY'"><!-- TODO welk metamodel? -->
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-normname)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','#any')"/>
            </xsl:when>
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname='MIX'"><!-- TODO welk metamodel? -->
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-normname)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','#mix')"/>
            </xsl:when>
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname = ('DATUM', 'DT') and $type-modifier = '?'">
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-normname)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','datetime')"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-modifier',$type-modifier)"/>
            </xsl:when>
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname = ('TIJD','T')">
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-normname)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','time')"/>
            </xsl:when>
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname = ('JAAR', 'JAARMAAND', 'DATUM', 'DT')">
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-normname)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','datetime')"/>
            </xsl:when>
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname = ('URI')">
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-normname)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','uri')"/>
            </xsl:when>
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname = ('TXT','POSTCODE')"> <!-- TODO postcode opnemen als native type is niet juist -->
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-normname)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','string')"/>
            </xsl:when>
            <xsl:when test="substring($type-id,1,5) = ('eaxmi') and $type-normname = ('INDIC','INDICATIE')">
                <xsl:sequence select="imf:create-output-element('imvert:baretype','INDIC')"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name','boolean')"/>
            </xsl:when>
            
            <!-- process the typed attributes, referencing type object types -->
            <xsl:when test="$type-id">
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-name)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name',$type-name)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-id',$type-id)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-package',imf:get-package-name($type-id))"/>
            </xsl:when>
            <!-- unexpected other constructs?? -->
            <xsl:otherwise>
                <xsl:sequence select="imf:msg('ERROR',concat('Unexpected attribute type: ', $type-name))"/>
                <xsl:sequence select="imf:create-output-element('imvert:baretype',$type-name)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-name',$this/type/@href)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="lbound" select="imf:get-tagged-value($this,'lowerBound')"/>
        <xsl:variable name="ubound" select="imf:get-tagged-value($this,'upperBound')"/>
        <xsl:sequence select="imf:create-output-element('imvert:min-occurs',$lbound)"/>
        <xsl:sequence select="imf:create-output-element('imvert:max-occurs',if ($ubound='*') then 'unbounded' else $ubound)"/>
        <xsl:sequence select="imf:create-output-element('imvert:position',imf:get-position-value($this,'100'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:pattern',imf:get-tagged-value($this,('pattern','patroon')))"/>
        <xsl:sequence select="imf:create-output-element('imvert:min-length',imf:get-tagged-value($this,'minLength'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:max-length',imf:get-tagged-value($this,'maxLength'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:any-from-package',imf:get-tagged-value($this,'package'))"/>
    </xsl:function>
    
    <xsl:function name="imf:get-association-info" as="node()*">
        <xsl:param name="this" as="node()"/> <!-- UML:Association -->
        
        <xsl:variable name="source" select="$this/*/UML:AssociationEnd[*/UML:TaggedValue[@tag='ea_end' and @value='source']]"/>
        <xsl:variable name="target" select="$this/*/UML:AssociationEnd[*/UML:TaggedValue[@tag='ea_end' and @value='target']]"/>
        
        <xsl:variable name="type-id" select="$target/@type"/>
        <xsl:variable name="type" select="imf:element-by-id($type-id)"/>
        
        <xsl:variable name="source-bounds" select="imf:get-association-end-bounds($source)"/>
        <xsl:variable name="target-bounds" select="imf:get-association-end-bounds($target)"/>
        
        <xsl:variable name="source-role" select="$source/@name"/>
        <xsl:variable name="target-role" select="$target/@name"/>
        
        <xsl:variable name="aggregation" select="$source/@aggregation"/>
        
        <xsl:sequence select="imf:create-output-element('imvert:type-name',$type/@name)"/>
        <xsl:sequence select="imf:create-output-element('imvert:type-id',$type-id)"/> 
        <xsl:sequence select="imf:create-output-element('imvert:type-package',imf:get-package-name($type-id))"/>
        <xsl:sequence select="imf:create-output-element('imvert:role-source',$source-role)"/>
        <xsl:sequence select="imf:create-output-element('imvert:role-target',$target-role)"/>
        <xsl:sequence select="imf:create-output-element('imvert:min-occurs',$target-bounds[1])"/>
        <xsl:sequence select="imf:create-output-element('imvert:max-occurs',$target-bounds[2])"/>
        <xsl:sequence select="imf:create-output-element('imvert:min-occurs-source',$source-bounds[1])"/>
        <xsl:sequence select="imf:create-output-element('imvert:max-occurs-source',$source-bounds[2])"/>
        <xsl:sequence select="imf:create-output-element('imvert:position',imf:get-position-value($this,'200'))"/>
        <xsl:sequence select="imf:create-output-element('imvert:aggregation',if (not($aggregation='none')) then $aggregation else '')"/>
     
        <xsl:variable name="source-parse" select="imf:parse-style($source/*/UML:TaggedValue[@tag='sourcestyle']/@value)"/>
        <xsl:variable name="target-parse" select="imf:parse-style($target/*/UML:TaggedValue[@tag='deststyle']/@value)"/>
        
        <xsl:sequence select="imf:create-output-element('imvert:source-alias',normalize-space($source-parse[@name='alias']))"/>
        <xsl:sequence select="imf:create-output-element('imvert:target-alias',normalize-space($target-parse[@name='alias']))"/>
        
        <xsl:sequence select="imf:create-output-element('imvert:source-navigable',if ($source-parse[@name='Navigable'] = 'Navigable') then 'true' else 'false')"/>
        <xsl:sequence select="imf:create-output-element('imvert:target-navigable',if ($target-parse[@name='Navigable'] = 'Navigable') then 'true' else 'false')"/>
        
                
    </xsl:function>
    
    <xsl:function name="imf:get-association-end-bounds" as="xs:string*">
        <xsl:param name="this" as="node()"/>
        <xsl:variable name="mult" select="$this/@multiplicity"/> <!-- vorm: 1..*, 1..2, 1, 4, null -->
        <xsl:variable name="mult-tokens" select="tokenize($mult,'\.+')"/>
        <xsl:choose>
            <xsl:when test="$mult-tokens[2]">
                <xsl:sequence select="($mult-tokens[1],if ($mult-tokens[2]='*') then 'unbounded' else $mult-tokens[2])"/>
            </xsl:when>
            <xsl:when test="$mult-tokens[1]">
                <xsl:sequence select="($mult-tokens[1],$mult-tokens[1])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="('1','1')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="imf:get-association-class-info" as="node()*">
        <xsl:param name="this" as="node()"/> <!-- UML:Association -->
        <xsl:variable name="association-id" select="imf:get-tagged-value($this,'associationclass')"/>
        <xsl:variable name="association-class" select="imf:element-by-id($association-id)"/>
        <xsl:if test="$association-class">
            <imvert:association-class>
                <xsl:sequence select="imf:create-output-element('imvert:type-name',$association-class/@name)"/>
                <xsl:sequence select="imf:create-output-element('imvert:type-id',$association-id)"/> 
                <xsl:sequence select="imf:create-output-element('imvert:type-package',imf:get-package-name($association-id))"/>
            </imvert:association-class>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="imf:get-package-by-namespace" as="node()*">
        <xsl:param name="package-namespace" as="xs:string"/>
        <xsl:variable name="element" select="imf:get-key('key-packages-by-alias',$package-namespace)"/>
        <xsl:choose>
            <xsl:when test="$element">
                <xsl:variable name="id" select="$element/@xmi:idref" as="xs:string"/>
                <xsl:if test="not($id)">
                    <xsl:sequence select="imf:msg('ERROR','No such package namespace (alias): [1]', $package-namespace)"/>
                </xsl:if>
                <xsl:sequence select="imf:get-uml-model-info($id)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="imf:msg('ERROR','Configured namespace alias not found in XMI: [1]', $package-namespace)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="imf:get-uml-model-info" as="node()*">
        <xsl:param name="id" as="xs:string"/>
        <xsl:sequence select="imf:element-by-id($id)"/>
    </xsl:function>
    <xsl:function name="imf:get-uml-element-info" as="node()*">
        <xsl:param name="id" as="xs:string"/>
        <xsl:sequence select="imf:get-key('key-construct-by-idref',$id)[self::element]"/>
    </xsl:function>
    <xsl:function name="imf:get-uml-connector-info" as="node()*">
        <xsl:param name="id" as="xs:string"/>
        <xsl:sequence select="imf:get-key('key-construct-by-idref',$id)[self::connector]"/>
    </xsl:function>
    <xsl:function name="imf:get-uml-attribute-info" as="node()*">
        <xsl:param name="id" as="xs:string"/>    
        <xsl:sequence select="imf:get-key('key-construct-by-idref',$id)[self::attribute]"/>
    </xsl:function>
    
    <!-- 
        Tagged values komen binnen subelement 
        .//UML:ModelElement.taggedValue voor, 
        en zo niet, dan terugvallen op
        /XMI/XMI.content/UML:TaggedValue
        
        Als niet beschikbaar op package zelf, dan wellicht wel op UML:ClassifierRole? 
        Voorbeeld:
        <UML:ClassifierRole name="Package5" xmi.id="EAID_877368D3_AF62_4cf7_8FF7_230ED08FEA87" ..> 
        <UML:Package        name="Package5" xmi.id="EAPK_877368D3_AF62_4cf7_8FF7_230ED08FEA87" ..>
    -->
 
    <xsl:function name="imf:get-tagged-value" as="item()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="tagged-value-name" as="xs:string*"/>
        <xsl:sequence select="imf:get-tagged-value($this,$tagged-value-name,'space')"/>
    </xsl:function>
    
    <xsl:function name="imf:get-tagged-value" as="item()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="tagged-value-name" as="xs:string*"/>
        <xsl:param name="normalized" as="xs:string?"/>
        <xsl:sequence select="imf:get-tagged-values($this,$tagged-value-name,$normalized)"/>
    </xsl:function>
    
    <xsl:function name="imf:get-tagged-values" as="item()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="tagged-value-name" as="xs:string*"/>
        <!-- 
            this implements the equivalent of:
            if ($local-value) then $local-value else 
            if ($global-value) then $global-value else 
            if ($local-cr-value) then $local-cr-value else 
            if ($global-cr-value) then $global-cr-value else 
            if ($root-model-value) then $root-model-value else 
            ()
        -->
        <xsl:variable name="tagged-values" select="$this/UML:ModelElement.taggedValue/UML:TaggedValue[imf:name-match(@tag,$tagged-value-name,'tv-name')]"/>
        <xsl:variable name="local-value" select="$tagged-values[1]"/>
        <xsl:choose>
            <xsl:when test="exists($local-value)">
                 <xsl:sequence select="$local-value"/>   
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="tagged-values" select="$content/UML:TaggedValue[@modelElement=$this/@xmi.id and imf:name-match(@tag,$tagged-value-name,'tv-name')]"/>
                <xsl:if test="$tagged-values[2]"> 
                   <xsl:sequence select="imf:msg('WARN','Duplicate assignment of tagged value (2) [1] at [2]', ($tagged-value-name, $this/@name))"/>
                </xsl:if>
                <xsl:variable name="global-value" select="$tagged-values[1]"/>
                <xsl:choose>
                    <xsl:when test="exists($global-value)">
                        <xsl:sequence select="$global-value"/>   
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="crole" select="imf:get-classifier-role($this)"/>
                        <xsl:variable name="tagged-values" select="$crole/UML:ModelElement.taggedValue/UML:TaggedValue[imf:name-match(@tag,$tagged-value-name,'tv-name')]"/>
                        <xsl:if test="$tagged-values[2]"> 
                            <xsl:sequence select="imf:msg('WARN','Duplicate assignment of tagged value [1] within classifier role [2]', ($tagged-value-name,$crole/@name))"/>
                        </xsl:if>
                        <xsl:variable name="local-cr-value" select="$tagged-values[1]"/>
                        <xsl:choose>
                            <xsl:when test="exists($local-cr-value)">
                                <xsl:sequence select="$local-cr-value"/>   
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="tagged-values" select="$content/UML:TaggedValue[@modelElement=$crole/@xmi.id and imf:name-match(@tag,$tagged-value-name,'tv-name')]"/>
                                <xsl:if test="$tagged-values[2]"> 
                                    <xsl:sequence select="imf:msg('WARN','Duplicate assignment of tagged value [1] at classifier role [2]', ($tagged-value-name,$crole/@name))"/>
                                </xsl:if>
                                <xsl:variable name="global-cr-value" select="$tagged-values[1]"/>
                                <xsl:choose>
                                    <xsl:when test="exists($global-cr-value)">
                                        <xsl:sequence select="$global-cr-value"/>   
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="root-model" select="$content/UML:Model"/>
                                        <xsl:variable name="tagged-values" select="$content/UML:TaggedValue[@modelElement=$root-model/@xmi.id and imf:name-match(@tag,$tagged-value-name,'tv-name')]"/>
                                        <xsl:if test="$tagged-values[2]"> 
                                            <xsl:sequence select="imf:msg('WARN','Duplicate assignment of tagged value [1] at root model [2]', ($tagged-value-name,$root-model/@name))"/>
                                        </xsl:if>
                                        <xsl:variable name="root-model-value" select="$tagged-values[1]"/>
                                        <xsl:choose>
                                            <xsl:when test="exists($root-model-value)">
                                                <xsl:sequence select="$root-model-value"/>   
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="imf:get-tagged-values">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="tagged-value-name" as="xs:string*"/>
        <xsl:param name="normalized" as="xs:string"/>
        <xsl:sequence select="for $tv in imf:get-tagged-values($this,$tagged-value-name) return imf:get-tagged-value-norm($tv,$normalized)"/>
    </xsl:function>
    
    <!-- return normalized string value, or HTML content when applicable -->
    <xsl:function name="imf:get-tagged-value-norm" as="item()*"> 
        <xsl:param name="tv" as="element()?"/>
        <xsl:param name="norm" as="xs:string?"/>
       
        <xsl:variable name="value" select="$tv/@value"/>
        <xsl:if test="normalize-space($value)">
            <!-- 
                OPTIONS:
                1/    value
                2/    <memo>#NOTES#value
                3.    value#NOTES#note
            -->        
            <xsl:variable name="tokens" select="tokenize($value,'#NOTES#')"/> 
            <xsl:variable name="value-select" select="
                if (exists($tokens[2]))
                then 
                    if ($tokens[1] = '&lt;memo&gt;')
                    then $tokens[2]
                    else $tokens[1]
                else
                    if ($tokens[1] = '&lt;memo&gt;')
                    then $tv/XMI.extension/UML:Comment/@name
                    else $tokens[1]
            "/>
            <xsl:sequence select="
                if (exists($value-select))
                then 
                    imf:get-tagged-value-norm-by-scheme($value-select,$norm,'tv')
                else
                    ()"/>
        </xsl:if>
   </xsl:function>
    
    <xsl:function name="imf:get-position-value" as="xs:string?">
            <xsl:param name="this" as="node()"/>
            <xsl:param name="default" as="xs:string"/>
        <xsl:variable name="positions" select="imf:get-tagged-values($this,'position')"/>
        <xsl:value-of select="
            if ($this/self::UML:Generalization and $positions[1]) then $positions[1] else
            if ($this/self::UML:Association and $positions[1]) then $positions[1] else
            if ($positions[2]) then $positions[2] 
            else $default
        "/>
    </xsl:function> 
    
    <xsl:function name="imf:get-custom-value" as="xs:string?">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="custom-value-name" as="xs:string*"/>
        <xsl:variable name="element" select="imf:get-custom-values($this)"/>
        <xsl:value-of select="$element[@name=$custom-value-name]/@value"/>
    </xsl:function>
 
    <xsl:function name="imf:get-extension-element-value" as="xs:string?">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="extension-value-name" as="xs:string*"/> 
        <xsl:variable name="element" select="$extension-elements[@xmi:idref=$this/@xmi:id]"/>
        <xsl:value-of select="imf:get-extension-info($element,$extension-value-name,'')"/>
    </xsl:function>
    <xsl:function name="imf:get-extension-element-value" as="xs:string?">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="extension-value-name" as="xs:string*"/> 
        <xsl:param name="base-element" as="xs:string"/> 
        <xsl:variable name="element" select="$extension-elements[@xmi:idref=$this/@xmi:id]"/>
        <xsl:value-of select="imf:get-extension-info($element,$extension-value-name,$base-element)"/>
    </xsl:function>
    
    <xsl:function name="imf:get-extension-attribute-value" as="xs:string?">
        <xsl:param name="this" as="node()"/> <!-- must be an ownedAttribute node -->
        <xsl:param name="extension-value-name" as="xs:string*"/> 
        <xsl:variable name="attribute" select="$extension-attributes[@xmi:idref=$this/@xmi:id]"/>
        <xsl:value-of select="imf:get-extension-info($attribute,$extension-value-name,'')"/>
    </xsl:function>
  
    <xsl:function name="imf:get-extension-connector-value" as="xs:string?">
        <xsl:param name="this" as="node()"/> <!-- must be an ownedAttribute node -->
        <xsl:param name="extension-value-name" as="xs:string*"/>
        <xsl:variable name="connector" select="$extension-connectors[@xmi:idref=$this/@association]"/>
        <xsl:value-of select="imf:get-extension-info($connector,$extension-value-name,'')"/>
    </xsl:function>

    <xsl:function name="imf:get-extension-info" as="xs:string?">
        <xsl:param name="this" as="node()?"/> <!-- any node in extension part -->
        <xsl:param name="extension-value-name" as="xs:string*"/>
        <xsl:param name="base-element" as="xs:string?"/>
        <xsl:if test="$this">
            <xsl:choose>
                <xsl:when test="$base-element">
                    <xsl:value-of select="$this/*[local-name()=$base-element]/@*[local-name()=$extension-value-name]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="element" select="$this/*[local-name()=$extension-value-name]"/>
                    <xsl:variable name="node" select="if ($element) then $element else $this/*/@*[local-name()=$extension-value-name]"/>
                    <xsl:value-of select="if ($node/@value) then $node/@value else $node"/> 
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:function>

    <xsl:function name="imf:get-package-name" as="xs:string">
        <xsl:param name="type-id" as="xs:string?"/>
        <xsl:variable name="class" select="imf:get-key('key-construct-by-id',$type-id)"/>
        <xsl:value-of select="imf:get-canonical-name(($class/ancestor-or-self::UML:Package)[last()]/@name)"/>
    </xsl:function>
    
    <xsl:function name="imf:date-to-isodate" as="xs:string?">
        <xsl:param name="date" as="xs:string?"/>
        <xsl:if test="$date">
            <xsl:analyze-string select="$date" regex="^(.+)\s(.+)$">
                <!-- 2005-11-07 16:49:09 -->
                <xsl:matching-substring>
                    <xsl:value-of select="concat(regex-group(1),'T',regex-group(2))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="imf:is-baretype" as="xs:boolean">
        <xsl:param name="type" as="xs:string"/>
        <xsl:copy-of select="matches($type,$baretype-pattern)"/>
    </xsl:function>
    
    <!-- XMI 1.1 ADDITIONS -->
    
    <xsl:variable name="content" select="/XMI/XMI.content"/>
    
    <xsl:key name="key-document-generalizations" match="//UML:Generalization" use="concat(@subtype,'#', @supertype)"/>
    
    <xsl:variable name="document-generalizations-merge" select="//UML:Generalization[imf:get-stereotypes(.)=imf:get-config-stereotypes('stereotype-name-variant-merge')]"/>
    <xsl:variable name="document-generalizations-copy-down" select="//UML:Generalization[imf:get-stereotypes(.)=imf:get-config-stereotypes('stereotype-name-static-generalization')]"/>
    <xsl:variable name="document-generalizations-type" select="//UML:Generalization except $document-generalizations-merge"/>
    <xsl:variable name="document-associations" select="//UML:Association"/>
    <xsl:key name="key-document-associations-type" 
        match="//UML:Association" 
        use="UML:Association.connection/UML:AssociationEnd[UML:ModelElement.taggedValue/UML:TaggedValue[@tag='ea_end' and @value='source']]/@type"/>
    
    <xsl:variable name="main-package-stereotypes" select="(
        imf:get-config-stereotypes('stereotype-name-base-package'), 
        imf:get-config-stereotypes('stereotype-name-variant-package'), 
        imf:get-config-stereotypes('stereotype-name-application-package')
        )"></xsl:variable>
    
    <!-- tagged values $ea_xref_property zijn complexe strings; deze worden voor gemakkelijke herkenning omgezet naar een interne XML struktuur -->
    <xsl:variable name="parsed-xref-properties" as="node()*">
        <xsl:for-each select="$content//UML:Package | $content//UML:Class | $content//UML:Attribute | $content//UML:Association | $content//UML:ClassifierRole | $content//UML:Generalization">
            <xsl:variable name="my-property" select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='$ea_xref_property']"/>
            <xsl:variable name="dst-property" select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='$ea_dst_xref_property']"/>
            <xsl:variable name="src-property" select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='$ea_src_xref_property']"/>
            <xsl:sequence select="imf:parse-xref-property-props(., if ($my-property) then $my-property/@value else ())"/>
            <xsl:sequence select="imf:parse-xref-property-props(., if ($dst-property) then $dst-property/@value else (),'dst')"/>
            <xsl:sequence select="imf:parse-xref-property-props(., if ($src-property) then $src-property/@value else (),'src')"/>
        </xsl:for-each>
    </xsl:variable>
    
    
    <!-- 
        Het volgende is een grammatica voor het uiteenpluizen van xrefprop, dus de string in content van:
        
        <UML:TaggedValue tag="$ea_xref_property" value="$XREFPROP=$XID={98........REF;"/>
        
        Dit geeft toegang tot bijv. meerdere stereotypes.
     
        Voorbeeld van de parse is:
        <imvert:xrefprop id="d2e9904" type="UML:Class">
            <imvert:props>
                <imvert:xid>{7C3FF6B4-114B-41de-9AAC-E119BCEE2284}</imvert:xid>
                <imvert:nam>CustomProperties</imvert:nam>
                <imvert:typ>element property</imvert:typ>
                <imvert:vis>Public</imvert:vis>
                <imvert:clt>{EBEAF581-57BC-4bf7-938D-AE0E1C5C1DBA}</imvert:clt>
                <imvert:des>
                    <imvert:name>isActive</imvert:name>
                    <imvert:type-name>Boolean</imvert:type>
                </imvert:des>
                <imvert:stereos/>
            </imvert:props>
            <imvert:props>
                <imvert:xid>{20B412B9-1FDE-432a-85A3-62C06BF01496}</imvert:xid>
                <imvert:nam>Stereotypes</imvert:nam>
                <imvert:typ>element property</imvert:typ>
                <imvert:vis>Public</imvert:vis>
                <imvert:par>0</imvert:par>
                <imvert:clt>{EBEAF581-57BC-4bf7-938D-AE0E1C5C1DBA}</imvert:clt>
                <imvert:sup>&lt;none&gt;</imvert:sup>
                <imvert:des/>
                <imvert:stereos>
                    <imvert:name>dataType</imvert:name>
                    <imvert:name>nog-een-stereo</imvert:name>
                </imvert:stereos>
            </imvert:props>
        </imvert:xrefprop>
     -->
     
    <xsl:function name="imf:parse-xref-property-props" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="xrefprop" as="xs:string?"/>
        <xsl:sequence select="imf:parse-xref-property-props($this,$xrefprop,'my')"/>
    </xsl:function>
    
    <xsl:function name="imf:parse-xref-property-props" as="node()*">
        <xsl:param name="this" as="node()"/>
        <xsl:param name="xrefprop" as="xs:string?"/>
        <xsl:param name="origin" as="xs:string?"/>
        <xsl:if test="$xrefprop">
            <!-- als de property wordt gezet op een ClassifierRole en de base is een package, dan betreft het de base van deze role. -->
            <xsl:variable name="base" as="element()?">
                <xsl:variable name="package-id" select="imf:get-tagged-value($this,'package2')"/>
                <xsl:variable name="package-id-corrected" select="replace($package-id,'^EAID_','EAPK_')"/> <!-- EA specific! -->
                <xsl:choose>
                    <xsl:when test="$this/self::UML:ClassifierRole and $package-id-corrected">
                        <xsl:sequence select="imf:element-by-id($package-id-corrected)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$this"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="exists($base)">
                <imvert:xrefprop id="{generate-id($base)}" type="{name($base)}" origin="{$origin}">
                    <xsl:analyze-string select="$xrefprop" regex="\$XREFPROP=(.+?)\$ENDXREF;">
                        <xsl:matching-substring>
                            <xsl:variable name="props" select="regex-group(1)"/>
                            <imvert:props>
                                <xsl:sequence select="imf:create-output-element('imvert:xid',imf:parse-xref-property-prop($props,'XID'))"/>
                                <xsl:sequence select="imf:create-output-element('imvert:nam',imf:parse-xref-property-prop($props,'NAM'))"/>
                                <xsl:sequence select="imf:create-output-element('imvert:typ',imf:parse-xref-property-prop($props,'TYP'))"/>
                                <xsl:sequence select="imf:create-output-element('imvert:vis',imf:parse-xref-property-prop($props,'VIS'))"/>
                                <xsl:sequence select="imf:create-output-element('imvert:par',imf:parse-xref-property-prop($props,'PAR'))"/>
                                <xsl:sequence select="imf:create-output-element('imvert:clt',imf:parse-xref-property-prop($props,'CLT'))"/>
                                <xsl:sequence select="imf:create-output-element('imvert:sup',imf:parse-xref-property-prop($props,'SUP'))"/>
                                <xsl:variable name="des" select="imf:parse-xref-property-prop($props,'DES')"/>
                                <xsl:if test="exists($des)">
                                    <xsl:analyze-string select="$des" regex="@PROP=(.+?)@ENDPROP;">
                                        <xsl:matching-substring>
                                            <imvert:des>
                                                <xsl:variable name="des-sub" select="regex-group(1)"/>
                                                <xsl:sequence select="imf:create-output-element('imvert:name',imf:parse-xref-property-des($des-sub,'NAME'))"/>
                                                <xsl:sequence select="imf:create-output-element('imvert:type',imf:parse-xref-property-des($des-sub,'TYPE'))"/>
                                                <xsl:sequence select="imf:create-output-element('imvert:valu',imf:parse-xref-property-des($des-sub,'VALU'))"/>
                                                <xsl:sequence select="imf:create-output-element('imvert:prmt',imf:parse-xref-property-des($des-sub,'PRMT'))"/>
                                            </imvert:des>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                    <imvert:stereos>
                                        <xsl:variable name="stereo" select="imf:parse-xref-property-des($des,'STEREO')"/>
                                        <xsl:for-each select="$stereo">
                                            <xsl:sequence select="imf:create-output-element('imvert:name',imf:parse-xref-property-des-att(.,'Name'))"/>
                                        </xsl:for-each>
                                    </imvert:stereos>
                                </xsl:if>
                            </imvert:props>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </imvert:xrefprop>
            </xsl:if>    
              </xsl:if>
    </xsl:function>
    
    <xsl:function name="imf:parse-xref-property-prop" as="node()?">
        <xsl:param name="props" as="xs:string"/>
        <xsl:param name="name" as="xs:string"/>
        <xsl:analyze-string select="$props" regex="{concat('\$',$name,'=','(.+?)','\$',$name,';')}">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:function name="imf:parse-xref-property-des" as="node()*">
        <xsl:param name="props" as="xs:string"/>
        <xsl:param name="name" as="xs:string"/>
        <xsl:analyze-string select="$props" regex="{concat('@',$name,'[=;]','(.+?)','@END',$name,';')}">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xsl:function name="imf:parse-xref-property-des-att" as="node()*">
        <xsl:param name="props" as="xs:string"/>
        <xsl:param name="name" as="xs:string"/>
        <xsl:analyze-string select="concat(';',$props)" regex="{concat(';',$name,'=','(.+?)',';')}">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>

    <xsl:function name="imf:get-classifier-role" as="node()?">
        <xsl:param name="this" as="node()"/>
        <xsl:variable name="role" select="imf:element-by-id(concat('EAID_',substring($this/@xmi.id,6)))"/>
        <xsl:variable name="id" select="concat('EAID_', substring($this/@xmi.id,6))"/>
        <!-- classifier role may also be identified through package2 tagged value. Take any classifier role with package2 is same as the ID -->
        <xsl:variable name="croles" select="$content//UML:ClassifierRole[UML:ModelElement.taggedValue/UML:TaggedValue[@tag='package2' and @value=$id]]"/>
        <xsl:sequence select="if (exists($role)) then $role else $croles"/>
    </xsl:function>
    
    <!-- return the lower and upper bound of a class. This is only applicable when stereotype is union. 
        We pass this informsation on such that for all other stereotrypes this can be checked and reported, 
        if the values are set. 
        The format is 2..* or 1..1 or empty or the like. 
    -->
    <xsl:function name="imf:get-class-cardinality-bounds" as="xs:string+">
        <xsl:param name="this" as="node()"/> <!-- a class -->
        <xsl:variable name="cardinality" select="tokenize(imf:get-tagged-value($this,'cardinality'),'\.\.')"/>
        <xsl:variable name="lbound" select="$cardinality[1]"/>
        <xsl:variable name="ubound" select="$cardinality[2]"/>
        <xsl:value-of select="if ($lbound) then $lbound else ''"/>
        <xsl:value-of select="if ($ubound) then (if ($ubound='*') then 'unbounded' else $ubound) else ''"/>
    </xsl:function>
    
    <xsl:function name="imf:get-svn-info" as="node()*">
        <xsl:param name="this" as="node()"/> <!-- a package -->
        <!-- [dollar]Id: tester-base-pack_package1.xml 4186 2012-01-05 16:02:47Z arjan [dollar] -->
        <xsl:variable name="id" select="imf:get-tagged-value($this,'svnid')"/>
        <xsl:if test="$id">
            <xsl:sequence select="imf:create-output-element('imvert:svn-string',substring($id,2,string-length($id) - 2))"/>
            <xsl:analyze-string select="$id" regex="\$Id: (.+) (\d+) ([0-9\-]+) ([0-9:Z]+) (.+)\$">
                <xsl:matching-substring>
                    <xsl:sequence select="imf:create-output-element('imvert:svn-file',regex-group(1))"/>
                    <xsl:sequence select="imf:create-output-element('imvert:svn-revision',regex-group(2))"/>
                    <xsl:sequence select="imf:create-output-element('imvert:svn-date',regex-group(3))"/>
                    <xsl:sequence select="imf:create-output-element('imvert:svn-time',regex-group(4))"/>
                    <xsl:sequence select="imf:create-output-element('imvert:svn-user',regex-group(5))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:if>
    </xsl:function>
    
    <!--
        Get the tagged values that are specified anywhere in this metamodel. 
        A test if the tagged value is appropriate is performed later in validation
    -->
    <xsl:function name="imf:fetch-additional-tagged-values" as="element()*">
        <xsl:param name="this" as="element()"/>
        <imvert:tagged-values>
            <xsl:for-each-group select="$additional-tagged-values" group-by="@id"> <!-- a set of tv elements, for a particular name -->
                <xsl:for-each select="current-group()[last()]">
                    <xsl:variable name="n" select="name"/> <!-- a normalized name <n original="">name ; may be multiple and may be duplicate -->
                    <xsl:for-each select="$n">
                        <xsl:variable name="nname" select="."/>
                        <xsl:variable name="norm" select="../@norm"/>
                        <!-- TODO solve a duplicate (redundant) call here --> 
                        <xsl:variable name="value-orig" select="imf:get-tagged-value($this,$nname)"/>
                        <xsl:variable name="value-norm" select="imf:get-tagged-value($this,$nname,$norm)"/>
                        <xsl:if test="exists($value-orig)">
                            <imvert:tagged-value>
                                <imvert:name original="{$nname/@original}">
                                    <xsl:value-of select="$nname"/>         
                                </imvert:name>
                                <imvert:value original="{$value-orig}">
                                    <xsl:sequence select="$value-norm"/>
                                </imvert:value>
                            </imvert:tagged-value>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each-group>
        </imvert:tagged-values>
    </xsl:function>
    
    <xsl:function name="imf:get-stereotype-local-names" as="xs:string*">
        <xsl:param name="stereotypes" as="xs:string*"/>
        <xsl:sequence select="for $s in $stereotypes return imf:get-stereotype-local-name($s)"/>
    </xsl:function>

    <xsl:function name="imf:get-stereotype-local-name" as="xs:string?">
        <xsl:param name="stereotype" as="xs:string?"/>
        <xsl:variable name="parts" select="if (exists($stereotype)) then tokenize($stereotype,'::') else ()"/>
        <xsl:sequence select="if ($parts[2]) then $parts[2] else $parts[1]"/>
    </xsl:function>

    <!--  IM-77 - OCL / constraints opnemen in imvert en documentatie -->
    <xsl:function name="imf:get-constraint-info" as="element()*">
        <xsl:param name="this" as="element()"/>
        <xsl:variable name="constraints" select="$this/UML:ModelElement.constraint/UML:Constraint"/>
        <xsl:if test="exists($constraints)">
            <imvert:constraints>
                <xsl:for-each select="$constraints">
                    <imvert:constraint>
                        <xsl:sequence select="imf:create-output-element('imvert:name',@name)"/>
                        <xsl:sequence select="imf:create-output-element('imvert:type',imf:get-tagged-value(.,'type'))"/>
                        <xsl:sequence select="imf:create-output-element('imvert:weight',imf:get-tagged-value(.,'weight'))"/>
                        <xsl:sequence select="imf:create-output-element('imvert:status',imf:get-tagged-value(.,'status'))"/>
                        <xsl:variable name="relevant-doc-string" select="if (contains(.,imf:get-config-parameter('documentation-separator'))) then substring-before(.,imf:get-config-parameter('documentation-separator')) else ."/>
                        <xsl:sequence select="imf:create-output-element('imvert:documentation',imf:get-tagged-value($relevant-doc-string,'description'))"/>
                    </imvert:constraint>
                </xsl:for-each>
            </imvert:constraints>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="imf:get-alias" as="xs:string?">
        <xsl:param name="this"/>
        <xsl:param name="type"/><!-- Class, Attribute, Relation, Package -->
        <xsl:choose>
            <xsl:when test="$type='P'">
                <xsl:variable name="tv" select="imf:get-tagged-value($this,'alias')"/>
                <xsl:value-of select="$tv"/>
            </xsl:when>
            <xsl:when test="$type='C'">
                <xsl:variable name="tv" select="imf:get-tagged-value($this,'alias')"/>
                <xsl:value-of select="$tv"/>
            </xsl:when>
            <xsl:when test="$type='A'">
                <xsl:variable name="tv" select="imf:get-tagged-value($this,'style')"/>
                <xsl:value-of select="$tv"/>
            </xsl:when>
            <xsl:when test="$type='R'">
                <xsl:variable name="tv" select="imf:get-tagged-value($this,'styleex')"/>
                <xsl:value-of select="if ($tv) then imf:parse-xref-property-des-att($tv,'alias') else ''"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="imf:parse-style" as="element()*">
        <xsl:param name="parsestring"/>
        <xsl:analyze-string select="$parsestring" regex="(.*?)=(.*?);">
            <xsl:matching-substring>
                <s name="{regex-group(1)}">
                    <xsl:value-of select="regex-group(2)"/>
                </s>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <!-- return all nodes the result from parsing the EA note string. This is a sequence of text line .-->  
    <xsl:function name="imf:import-ea-note" as="item()*">
        <xsl:param name="note-ea" as="xs:string"/>
        <xsl:value-of select="$note-ea"/><!-- pass as-is -->
    </xsl:function>
    
    <!-- 
        Get the ID of the construct that is the target of the trace, starting in the construct supplied. 
        For example, if class1 has a trace relation with class2, return the ID of class2.
    -->   

    <xsl:variable name="document-association-traces" select="$document-associations[UML:ModelElement.stereotype/UML:Stereotype/@name = 'trace']"/>
    
    <xsl:function name="imf:get-trace-id" as="xs:string*">
        <xsl:param name="construct"/>
        <xsl:param name="type"/>
        <xsl:variable name="construct-id" select="$construct/@xmi.id"/>
        <xsl:choose>
            <xsl:when test="$type = 'C' and $construct/self::UML:Class">
                <xsl:variable name="trace-connection" select="$document-association-traces/UML:Association.connection[
                    UML:AssociationEnd[@type = $construct-id and UML:ModelElement.taggedValue/UML:TaggedValue[@tag='ea_end' and @value='source']]
                    ]"/>
                <xsl:variable name="target" select="$trace-connection/UML:AssociationEnd[UML:ModelElement.taggedValue/UML:TaggedValue[@tag='ea_end' and @value='target']]"/> 
                <xsl:value-of select="$target/@type"/>
            </xsl:when>
            <xsl:when test="$type = 'P'">
                
            </xsl:when>   
            <xsl:when test="$type = 'A'">
                <xsl:variable name="trace-connection" select="imf:get-tagged-value($construct,'sourceAttribute')"/>
                <xsl:value-of select="$trace-connection"/>
            </xsl:when>   
            <xsl:when test="$type = 'R'">
                <xsl:variable name="trace-connection" select="imf:get-tagged-value($construct,'sourceAssociation')"/>
                <xsl:value-of select="$trace-connection"/>
            </xsl:when>   
            <xsl:otherwise>
                <xsl:sequence select="imf:msg('FATAL','Invalid trace request: type [1] called at [2]', ($type, name($construct)))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>
