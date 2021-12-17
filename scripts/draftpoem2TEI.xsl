<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:for-each select="descendant::div[@type eq 'poem']">
            <xsl:variable name="nr"><xsl:number></xsl:number></xsl:variable>
            <xsl:variable name="author" select="descendant::author/persName => replace('\s+', '')=> encode-for-uri()"/> 
            <xsl:variable name="title" select="title[not(@type)] => replace('\s+', '') => encode-for-uri()"/>
            <xsl:result-document href="{$author}/{$title}_{$nr}.xml">
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title><xsl:value-of select="title[not(@type)]"/></title>
                                <author><xsl:value-of select="author/persName"/></author>
                            </titleStmt>
                            <publicationStmt>
                                <authority>UNED</authority>
                            </publicationStmt>
                            <sourceDesc>
                                <bibl type="book">
                                    <title><xsl:value-of select="descendant::title[@type]"/></title>
                                    <publisher><xsl:value-of select="descendant::bib/editor"/></publisher>
                                    <date>
                                        <xsl:attribute name="cert">
                                            <xsl:choose>
                                                <xsl:when test="descendant::bibl/cert eq 'Sí'">
                                                    <xsl:text>high</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>low</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </date>
                                </bibl>
                                <bibl>
                                    <link target="{ref/@target}"></link>
                                </bibl>
                            </sourceDesc>
                        </fileDesc>
                        <profileDesc>
                            <textClass>
                                <keywords>
                                    <xsl:apply-templates select="genre"/>
                                </keywords>
                                
                            </textClass>
                            <particDesc>
                                <listPerson>
                                    <person role="performer">
                                        <persName><xsl:value-of select="person/persName"/></persName>
                                        <nationality><xsl:value-of select="person/nationality"/></nationality>
                                    </person>
                                    <person role="poet">
                                        <persName><xsl:value-of select="relation/author"/></persName>
                                        <bibl><xsl:value-of select="relation/title"/></bibl>
                                        <relation><xsl:value-of select="relation/relationType"/></relation>
                                    </person>
                                </listPerson>
                            </particDesc>
                        </profileDesc>                       
                    </teiHeader>
                    <text>
                        <body>
                            <div>
                                <lg type="lyrics">
                                    <xsl:apply-templates select="lg/lg"></xsl:apply-templates>
                                </lg>
                            </div>
                           <xsl:copy-of select="descendant::note"/>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>            
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="genre">
        <xsl:if test="current() ne ''">
            <term><xsl:apply-templates/></term>
        </xsl:if>
    </xsl:template>
    <xsl:template match="lg">
        <lg><xsl:apply-templates/></lg>
    </xsl:template>
    <xsl:template match="l">
        <l><xsl:apply-templates/></l>
    </xsl:template>
</xsl:stylesheet>