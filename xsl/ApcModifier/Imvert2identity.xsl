<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    SVN: $Id: Imvert2identity.xsl 7205 2015-08-24 13:10:30Z arjan $ 
-->

<!-- identity transformation -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>