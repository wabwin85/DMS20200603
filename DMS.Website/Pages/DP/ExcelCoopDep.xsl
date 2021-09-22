<xsl:stylesheet version="1.0"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 xmlns:user="urn:my-scripts"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" >

  <xsl:template match="/">
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
      xmlns:html="http://www.w3.org/TR/REC-html40">

      <Styles>
        <Style ss:ID="Default" ss:Name="Normal">
          <Alignment ss:Vertical="Bottom"/>
          <Borders/>
          <Font/>
          <Interior/>
          <NumberFormat/>
          <Protection/>
        </Style>
        <Style ss:ID="s21">
          <Font ss:Bold="1"/>
          <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
        </Style>
      </Styles>

      <xsl:apply-templates/>

    </Workbook>
  </xsl:template>


  <xsl:template match="/*">
    <Worksheet>
      <xsl:attribute name="ss:Name">
        <xsl:value-of select="local-name(/*/*)" />
      </xsl:attribute>
      <Table x:FullColumns="1" x:FullRows="1">

        <Column ss:AutoFitWidth="0" ss:Width="0"/>
        <Column ss:AutoFitWidth="0" ss:Width="150"/>
        <Column ss:AutoFitWidth="0" ss:Width="200"/>
        <Column ss:AutoFitWidth="0" ss:Width="75"/>
        <Column ss:AutoFitWidth="0" ss:Width="85"/>
        <Column ss:AutoFitWidth="0" ss:Width="100"/>
        <Column ss:AutoFitWidth="1" ss:Width="70"/>
        <Column ss:AutoFitWidth="1" ss:Width="50"/>
        <Column ss:AutoFitWidth="1" ss:Width="50"/>

        <Row>
          <xsl:for-each select="*[position() = 1]/*">
            <Cell ss:StyleID="s21">
              <Data ss:Type="String">
                <xsl:if test="local-name() = 'Id'">编号</xsl:if>
                <xsl:if test="local-name() = 'Column1'">Franchise</xsl:if>
                <xsl:if test="local-name() = 'Column2'">BU</xsl:if>
                <xsl:if test="local-name() = 'Column3'">分销商子代码</xsl:if>
                <xsl:if test="local-name() = 'Column4'">分销商子名称</xsl:if>
                <xsl:if test="local-name() = 'Column5'">级别</xsl:if>
                <xsl:if test="local-name() = 'Column6'">开始合作日期</xsl:if>
                <xsl:if test="local-name() = 'Column7'">终止合作日期</xsl:if>
                <xsl:if test="local-name() = 'Column8'">合作状态</xsl:if>
              </Data>
            </Cell>
          </xsl:for-each>
        </Row>
        <xsl:apply-templates/>
      </Table>
    </Worksheet>
  </xsl:template>


  <xsl:template match="/*/*">
    <Row>
      <xsl:apply-templates/>
    </Row>
  </xsl:template>


  <xsl:template match="/*/*/*">
    <Cell>
      <Data ss:Type="String">
        <xsl:value-of select="." />
      </Data>
    </Cell>
  </xsl:template>


</xsl:stylesheet>
