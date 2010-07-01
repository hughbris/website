<?xml version="1.0"?>

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>
	
<xsl:output
	method="xml"
	indent="yes"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	/>

<xsl:param name="todaysDate" select="' '"/> <!-- TODO: use date-and-time web service for default (or maybe just fallback) parameter -->
<xsl:param name="ns" select="' '"/> <!-- CHECKME: if this is required, this should have no default to force runtime error?? -->
<xsl:param name="tt" select="' '"/> <!-- CHECKME: as above?? what is this anyway? -->
<xsl:param name="header"/> <!-- executive decision: this should error if not supplied -->

<xsl:variable name="heading" select="document($header)"/>

<xsl:template match="/">
  <html>
    <head>
      <title>
	<xsl:apply-templates select="$heading/H1/Title"/>
      </title>
      <xsl:comment>#exec cgi="/cgi-bin/metawriter.cgi" </xsl:comment>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
      <link rel="stylesheet" href="/css/default.css" type="text/css" />
    </head>
    <body>
      <xsl:comment>#include virtual="/ssi/header.shtml" </xsl:comment>
	  <xsl:apply-templates select="$heading/H1" mode="docinfo" />
      <xsl:apply-templates select="dc"/>
      <xsl:comment>#include virtual="/ssi/footer.shtml" </xsl:comment>
    </body>
  </html>
</xsl:template>

<xsl:template match="H1/Title">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="H1" mode="docinfo">
	<table cellspacing="0" class="docinfo">
		<xsl:apply-templates mode="docinfo" />
	</table>
</xsl:template>

<xsl:template match="H1/*" mode="docinfo">
	<!-- TODO: make this a definition list -->
  <tr>
    <th><xsl:value-of select="translate(local-name(), '-', ' ')" />:</th>
    <td>
      <xsl:choose>
	<xsl:when test="(starts-with(., 'http://')) or (starts-with(., 'mailto:'))"> <!-- TODO: create isURL named template for this -->
	  <xsl:choose>
	    <xsl:when test="@label">
	      <a>
		<xsl:attribute name="href">
		  <xsl:apply-templates />
		</xsl:attribute>
		<xsl:value-of select="@label"/>
	      </a>
	    </xsl:when>
	    <xsl:otherwise>
	      <a>
		<xsl:attribute name="href">
		  <xsl:apply-templates />
		</xsl:attribute>
		<xsl:apply-templates />
	      </a>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates />
	</xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</xsl:template>

<xsl:template match="dc">
  <h1>DCMI Type Vocabulary</h1>
  <table cellspacing="0" class="border">
    <xsl:apply-templates select="term[not(Is-Replaced-By)]">
      <xsl:sort select="Name"/>
    </xsl:apply-templates>
  </table>
</xsl:template>

<xsl:template match="term">
  <xsl:if test="(Namespace = $ns) or ($ns = 'any')">
    <tr id="{Anchor}">
      <th colspan="2">
	<xsl:text>Term Name: </xsl:text>
	<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
	<xsl:value-of select="Name"/>
      </th>
    </tr>
	<xsl:apply-templates />
  </xsl:if>
</xsl:template>

<xsl:template match="Type-of-Term | Status">
  <tr>
    <td>
      <xsl:value-of select="translate(local-name(), '-', ' ')"/>:
    </td>
    <td>
      <a>
	<xsl:attribute name="href">
	  <xsl:apply-templates />
	</xsl:attribute>
	<xsl:choose>
	  <xsl:when test="contains(., '#')">
	    <xsl:value-of select="substring-after(., '#')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates />
	  </xsl:otherwise>
	</xsl:choose>
      </a>
    </td>
  </tr>
</xsl:template>

 <!-- skip processing these ones, we could have gone the other way (listed the elements to process, not ignore, but this list is enumerated already by the legacy code -->
 <!-- relies on priority attribute in other template, unfortunately -->
<xsl:template match="Anchor
	| Namespace
	| Publisher
	| Replaces
	| Qualifies
	| Is-Replaced-By
	| Date-Issued
	| Date-Modified
	| Decision
	| Status
	| term/Name-for-Table
	| Name
	" 
	/>

<!-- apply to all children of term for which there are not specific templates, -->
<!-- thought this would have a default priority lower than templates above, but unfortunately needs @priority (slight hack) -->
<xsl:template match="term/*"	priority="-1">
	<tr>
		<td>
			<xsl:value-of select="translate(local-name(), '-', ' ')"/>:
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="(starts-with(., 'http://')) or (starts-with(., 'mailto:'))"> <!-- TODO: create isURL named template for this -->
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="."/>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="@label">
								<xsl:value-of select="@label"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates />
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>
