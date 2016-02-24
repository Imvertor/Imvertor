<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    
    xmlns:imvert="http://www.imvertor.org/schema/system"
    xmlns:imf="http://www.imvertor.org/xsl/functions"
    
    version="2.0">
    
    <xsl:import href="../common/Imvert-common.xsl"/>
    
    <!--
        This stylesheet grabs processing information on some (attempted) release from the readme file. 
        It stores this info to the config file as appinfo parameters, all starting with "previous-".
        
        This is a poor solution and should be replace by a robust way of passing run info to future imvertor runs.
    -->
    
    <!-- TODO Improve the readme analyzer; mut be a separate doument (signature file) that holds this info. -->
    
    <xsl:template match="/|*">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="i[@class='appinfo']">
        <xsl:analyze-string select="." regex="(#.+?):([^#]+)">
            <xsl:matching-substring>
                <!-- example: #ph:2#ts:release#er:8#re:20150601#dt:2015-07-08 16:50:35# -->
                <xsl:choose>
                    <xsl:when test="regex-group(1)='ph'">
                        <xsl:sequence select="imf:set-config-string('appinfo','previous-phase',regex-group(2))"/>
                    </xsl:when>
                    <xsl:when test="regex-group(1)='ts'">
                        <xsl:sequence select="imf:set-config-string('appinfo','previous-task',regex-group(2))"/>
                    </xsl:when>
                    <xsl:when test="regex-group(1)='er'">
                        <xsl:sequence select="imf:set-config-string('appinfo','previous-errors',regex-group(2))"/>
                    </xsl:when>
                    <xsl:when test="regex-group(1)='re'">
                        <xsl:sequence select="imf:set-config-string('appinfo','previous-release',regex-group(2))"/>
                    </xsl:when>
                    <xsl:when test="regex-group(1)='dt'">
                        <xsl:sequence select="imf:set-config-string('appinfo','previous-date',regex-group(2))"/>
                    </xsl:when>
                    <xsl:when test="regex-group(1)='id'">
                        <xsl:sequence select="imf:set-config-string('appinfo','previous-id',regex-group(2))"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>