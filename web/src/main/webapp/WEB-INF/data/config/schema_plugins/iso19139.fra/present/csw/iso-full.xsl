<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
										xmlns:dc ="http://purl.org/dc/elements/1.1/"
										xmlns:dct="http://purl.org/dc/terms/"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
                    xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:geonet="http://www.fao.org/geonetwork">

	<xsl:param name="displayInfo"/>
	
	<!-- ============================================================================= -->
<!--
	<xsl:template match="gmd:MD_Metadata">
		<csw:IsoRecord>
			<xsl:apply-templates select="*"/>
		</csw:IsoRecord>
	</xsl:template>
-->
	<!-- ============================================================================= -->

	<xsl:template match="*[@gco:isoType]" priority="100">
		<xsl:element name="{@gco:isoType}">
			<xsl:attribute name="namespace">
				<!-- FIXME : Map element prefix to namespace,
					creating attribute with prefix does not set namespace.
					For now only gmd's element are extended by profile.
				-->
				<xsl:choose>
					<xsl:when test="contains(@gco:isoType, 'gmd')">http://www.isotc211.org/2005/gmd</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates select="*"/>
		</xsl:element>
	</xsl:template>

  <xsl:template match="fra:*[not(@gco:isoType)]" priority="50"/>

	<xsl:template match="@*|node()[name(.)!='geonet:info']">
		<xsl:variable name="info" select="geonet:info"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()[name(.)!='geonet:info']"/>
			<!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
			<xsl:if test="$displayInfo = 'true'">
				<xsl:copy-of select="$info"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
