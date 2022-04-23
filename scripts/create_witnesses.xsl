<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:variable name="poem" select="current()"/>
        <xsl:variable name="author" select="base-uri(.) => substring-after('poemas/') => substring-before('/')"/>
        <xsl:variable name="folderName" select="base-uri(.) => substring-after('poemas/') => 
            replace('/', '_') => substring-before('.xml')"/>
        <xsl:variable name="path" select="base-uri(.) => substring-before('/poemas') || '/canciones/' || $author"/>
        <xsl:variable name="title" select="$folderName => substring-before('_')"/>
        <xsl:result-document href="{$folderName}/poema.txt">
            <xsl:apply-templates select="//l"/>
        </xsl:result-document>
        <xsl:for-each select="collection($path)//TEI[descendant::person[@role eq 'poet']/bibl/normalize-space(replace(., '[\[\]]+', '')) = $poem/descendant::titleStmt/title/normalize-space(replace(., '[\[\]]+', ''))]">
            <xsl:variable name="id" select="base-uri(.) => substring-after('_')"/>
            <xsl:result-document href="{$folderName}/cancion_{$id}.txt"><xsl:apply-templates select="//l"/></xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="l">
        <xsl:apply-templates/><xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>