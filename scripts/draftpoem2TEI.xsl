<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:for-each select="descendant::div[@type eq 'poem']">
            <xsl:variable name="nr">
                <xsl:number/>
            </xsl:variable>
            <xsl:variable name="author"
                select="descendant::author/persName => replace('\s+', '') => encode-for-uri()"/>
            <xsl:variable name="title"
                select="title[not(@type)] => replace('\s+', '') => encode-for-uri()"/>
            <xsl:result-document href="../poemas/{$author}/{$title}_{$nr}.xml">
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>
                                    <xsl:value-of select="title[not(@type)]"/>
                                </title>
                                <author>
                                    <xsl:value-of select="author/persName"/>
                                </author>
                            </titleStmt>
                            <publicationStmt>
                                <authority>UNED</authority>
                            </publicationStmt>
                            <sourceDesc>
                                <bibl type="book">
                                    <title>
                                        <xsl:value-of select="descendant::title[@type]"/>
                                    </title>
                                    <date>
                                        <xsl:attribute name="cert">
                                            <xsl:choose>
                                                <xsl:when test="descendant::bib/cert = ('1', 'Sí')">
                                                  <xsl:text>high</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:text>low</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </date>
                                    <pubPlace>
                                        <xsl:value-of select="descendant::bib/place"/>
                                    </pubPlace>
                                    <xsl:apply-templates select="descendant::bib/editor"/>

                                </bibl>
                            </sourceDesc>
                        </fileDesc>
                        <profileDesc>
                            <textClass n="genre">
                                <keywords>
                                    <xsl:apply-templates select="genre"/>
                                </keywords>
                            </textClass>
                            <textClass n="topic">
                                <keywords>
                                    <list>
                                        <xsl:apply-templates select="topic"/>
                                    </list>
                                </keywords>
                            </textClass>
                            <particDesc>
                                <listPerson>
                                    <person role="poet">
                                        <persName>
                                            <xsl:value-of select="author/persName"/>
                                        </persName>
                                        <xsl:copy-of select="author/idno" copy-namespaces="no"/>
                                        <xsl:copy-of select="author/nationality"
                                            copy-namespaces="no"/>
                                        <birth>
                                            <date>
                                                <xsl:attribute name="cert">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="author/date[@type eq 'birth'] eq 'Sí'">
                                                  <xsl:text>high</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>low</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:value-of select="author/date[@type eq 'birth']"
                                                />
                                            </date>
                                        </birth>
                                        <death>
                                            <date>
                                                <xsl:attribute name="cert">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="author/date[@type eq 'death'] eq 'Sí'">
                                                  <xsl:text>high</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>low</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:value-of select="author/date[@type eq 'death']"
                                                />
                                            </date>
                                        </death>
                                        <floruit>
                                            <xsl:value-of select="descendant::period"/>
                                        </floruit>
                                    </person>
                                </listPerson>
                            </particDesc>
                        </profileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <div>
                                <lg type="poem">
                                    <xsl:apply-templates select="lg/lg"/>
                                </lg>
                            </div>
                            <xsl:copy-of select="descendant::note" copy-namespaces="no"/>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="editor">
        <publisher n="{@type}">
            <xsl:apply-templates/>
        </publisher>
    </xsl:template>
    <xsl:template match="genre">
        <xsl:if test="current() ne ''">
            <term>
                <xsl:apply-templates/>
            </term>
        </xsl:if>
    </xsl:template>
    <xsl:template match="topic">
        <item>
            <xsl:apply-templates/>
        </item>
    </xsl:template>
    <xsl:template match="lg">
        <lg>
            <xsl:apply-templates/>
        </lg>
    </xsl:template>
    <xsl:template match="l">
        <l>
            <xsl:apply-templates/>
        </l>
    </xsl:template>
    <xsl:template match="sp">
        <sp>
            <xsl:apply-templates/>
        </sp>
    </xsl:template>
    <xsl:template match="speaker">
        <speaker><xsl:apply-templates/></speaker>
    </xsl:template>
</xsl:stylesheet>
