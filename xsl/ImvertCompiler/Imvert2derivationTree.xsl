<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2derivationTree.xsl 7395 2016-01-26 10:35:23Z arjan $ 
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 

    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:ext="http://www.imvertor.org/xsl/extensions"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- 
         Create a listing of all dependencies between packages.
    -->
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    <xsl:import href="../common/Imvert-common-validation.xsl"/>
    
    <xsl:variable name="stylesheet">Imvert2derivationTree</xsl:variable>
    <xsl:variable name="stylesheet-version">$Id: Imvert2derivationTree.xsl 7395 2016-01-26 10:35:23Z arjan $</xsl:variable>
   
    <xsl:variable name="application-project" select="/imvert:packages/imvert:project" as="xs:string"/>
    <xsl:variable name="application-name" select="/imvert:packages/imvert:application" as="xs:string"/>
    <xsl:variable name="application-release" select="/imvert:packages/imvert:release" as="xs:string"/>
    
    <xsl:variable name="config-tagged-values" select="imf:get-config-tagged-values()"/>
    
    <xsl:template match="/">
        <xsl:variable name="layers" as="element()">
            <imvert:layers-set>
                <xsl:for-each select="imvert:packages/imvert:package[imvert:stereotype=imf:get-config-stereotypes('stereotype-name-domain-package')]">
                    <imvert:layer>
                        <imvert:supplier project="{$application-project}" application="{$application-name}" release="{$application-release}">
                            <xsl:apply-templates select="."/>
                        </imvert:supplier>
                        <xsl:sequence select="imf:get-full-derivation-sub(.,1)"/>
                    </imvert:layer>
                </xsl:for-each>
            </imvert:layers-set>
        </xsl:variable>
        <!-- now set the layered name for each component in de layers --> 
        <xsl:apply-templates select="$layers" mode="layered-name"/>
    </xsl:template>
    
    <xsl:template match="imvert:package | imvert:class | imvert:attribute | imvert:association">
        <xsl:copy>
            <xsl:attribute name="display-name" select="imf:get-display-name(.)"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="imvert:tagged-value">
        <xsl:variable name="name" select="imvert:name/@original"/>
        <xsl:choose>
            <xsl:when test="$config-tagged-values[name = $name and derive='yes']">
                <xsl:sequence select="."/>
            </xsl:when>
            <xsl:otherwise>
                <!-- skip -->
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>
    
    <xsl:function name="imf:get-full-derivation-sub" as="element()*">
        <xsl:param name="package" as="element()"/>
        <xsl:param name="level" as="xs:integer"/>
        <!-- 
                Determine which package is the supplier.
                Validation concerns the relation supplier-client.
                
                Supplier name is set explicitly for the package itself, or the same name as this package.
                Supplier project set explicitly for the package itself, or taken from parent.
                Supplier release set explicitly for the package itself, or taken from parent.
        -->
        <xsl:variable name="supplier-application"  select="if ($package/imvert:supplier-name) then $package/imvert:supplier-name else $package/../imvert:supplier-name"/>
        <xsl:variable name="supplier-project"      select="if ($package/../imvert:supplier-project) then $package/../imvert:supplier-project else $package/imvert:supplier-project"/>
        <xsl:variable name="supplier-release"      select="if ($package/../imvert:supplier-release) then $package/../imvert:supplier-release else $package/imvert:supplier-release"/>
        <xsl:variable name="supplier-package-name" select="$package/imvert:supplier-package-name"/>
        
        <xsl:choose>
            <xsl:when test="not(imf:boolean($package/imvert:derived))">
                <!-- okay, skip. Explicitly specified that the package is not to be considered "derived" -->
            </xsl:when>
         
            <xsl:when test="empty($package/imvert:supplier-name) and not(imf:boolean($package/imvert:derived))">
                <!-- okay, skip. This occurs only for base packages, that have no supplier (BOM!) -->
            </xsl:when>
            
            <xsl:when test="exists($supplier-application) and empty($supplier-project)">
                <xsl:sequence select="imf:report-error($package,true(),'No supplier project specified for supplier [1]', $supplier-application)"/>
            </xsl:when>
            
            <xsl:when test="exists($supplier-application) and empty($supplier-release)">
                <xsl:sequence select="imf:report-error($package,true(),'No supplier release specified for supplier [1]', $supplier-application)"/>
            </xsl:when>
                
            <xsl:when test="exists($supplier-application)">
                <!-- 
                    Check where supplier info is found. 
                     
                -->
                <xsl:variable name="path" select="imf:get-imvert-etc-filepath($supplier-project, $supplier-application, $supplier-release)"/> 
                <xsl:variable name="path-found" select="unparsed-text-available($path)"/>
                
                <xsl:sequence select="imf:report-error($package,not($supplier-project),'No supplier project specified')"/>
                <xsl:sequence select="imf:report-error($package,not($supplier-release),'No supplier release specified')"/>
                
                <xsl:variable name="supplier-document" select="imf:document($path)"/>
                <xsl:variable name="supplier-mapped-name" select="if ($supplier-package-name) then $supplier-package-name else $package/imvert:name"/>
                <xsl:variable name="supplier-package" select="$supplier-document/imvert:packages/imvert:package[imvert:stereotype=imf:get-config-stereotypes('stereotype-name-domain-package') and imvert:name=$supplier-mapped-name]"/>
                
                <xsl:choose>
                    <xsl:when test="not($path-found)">
                        <xsl:if test="$level eq 1">
                            <xsl:sequence select="imf:report-warning($package,true(),'No supplier Imvert information found; not validating this derivation')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not($supplier-package)">
                        <xsl:if test="$level eq 1">
                            <xsl:sequence select="imf:report-warning($package,true(),'No supplier package found; not validating this derivation')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <imvert:supplier application="{$supplier-application}" project="{$supplier-project}" release="{$supplier-release}">
                            <xsl:sequence select="$supplier-package"/>
                        </imvert:supplier>
                        <xsl:sequence select="imf:get-full-derivation-sub($supplier-package, $level + 1)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="imf:report-warning($package,true(),'No supplier name specified, assuming this package is not derived.')"/>
            </xsl:otherwise>
        </xsl:choose>
      
    </xsl:function>
    
    <xsl:function name="imf:get-imvert-etc-filepath" as="xs:string">
        <xsl:param name="project" as="xs:string"/>
        <xsl:param name="application" as="xs:string"/>
        <xsl:param name="release" as="xs:string"/>
        <xsl:variable name="path" select="concat(imf:file-to-url($applications-folder-path),'/',$project,'/',$application,'/',$release,'/etc/',$application,'.system.imvert.xml')"/>
        <xsl:value-of select="$path"/>
    </xsl:function>
    
    <xsl:template match="*" mode="#default layered-name">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="imvert:package | imvert:class | imvert:attribute | imvert:association" mode="layered-name">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="layered-name" select="imf:get-layered-display-names(.)[last()]"/>
            <xsl:apply-templates mode="layered-name"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="imf:get-layered-display-names" as="xs:string+">
        <xsl:param name="construct" as="element()"/>
        
        <xsl:value-of select="imf:get-layered-display-name($construct)"/>
                
        <xsl:variable name="type" select="name($construct)"/>
        <xsl:variable name="name" select="($construct/imvert:name, $construct/imvert:supplier-package-name)"/>
        <xsl:variable name="client" select="$construct/ancestor::imvert:supplier"/>
        <xsl:variable name="supplier" select="$client/following-sibling::imvert:supplier[1]"/>
        <xsl:variable name="supplier-construct" select="($supplier/descendant::*[name(.) = $type][imvert:name = $name])[1]"/>
        <xsl:if test="exists($supplier-construct)">
            <xsl:sequence select="imf:get-layered-display-names($supplier-construct)"/>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="imf:get-layered-display-name" as="xs:string">
        <xsl:param name="construct" as="element()"/>
        <xsl:value-of select="string-join((
            $construct/ancestor-or-self::imvert:package/imvert:name,
            $construct/ancestor-or-self::imvert:class/imvert:name,
            $construct/ancestor-or-self::imvert:attribute/imvert:name,
            $construct/ancestor-or-self::imvert:association/imvert:name),'_')"/>
    </xsl:function>
 </xsl:stylesheet>
