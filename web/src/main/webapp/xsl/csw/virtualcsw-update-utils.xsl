<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template mode="script" match="/" name="user-admin-js"></xsl:template>
	
	<xsl:template name="virtualcswinfofields">
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/any"/></th>
					<td class="padded"><input class="content" type="text" name="any" value="{/root/gui/services/filter/any}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/title"/> (*)</th>
					<td class="padded"><input class="content" type="text" name="title" value="{/root/gui/services/filter/title}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/abstract"/></th>
					<td class="padded"><input class="content" type="text" name="abstract" value="{/root/gui/services/filter/abstract}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/keyword"/></th>
					<td class="padded"><input class="content" type="text" name="keyword" value="{/root/gui/services/filter/keyword}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/denominatorFrom"/></th>
					<td class="padded"><input class="content" type="text" name="denominatorFrom" value="{/root/gui/services/filter/denominatorFrom}" size="8"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/denominatorTo"/></th>
					<td class="padded"><input class="content" type="text" name="denominatorTo" value="{/root/gui/services/filter/denominatorTo}"/></td>
				</tr>
								

	</xsl:template>
	
</xsl:stylesheet>

