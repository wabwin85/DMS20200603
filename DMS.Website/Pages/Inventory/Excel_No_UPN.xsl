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

        <Column ss:AutoFitWidth="0" ss:Width="150"/>
        <Column ss:AutoFitWidth="0" ss:Width="200"/>
        <Column ss:AutoFitWidth="0" ss:Width="100"/>
        <!--<Column ss:AutoFitWidth="0" ss:Width="85"/>-->
        <Column ss:AutoFitWidth="0" ss:Width="150"/>
        <Column ss:AutoFitWidth="0" ss:Width="100"/>
        <Column ss:AutoFitWidth="1" ss:Width="70"/>
        <Column ss:AutoFitWidth="1" ss:Width="50"/>
        <Column ss:AutoFitWidth="1" ss:Width="50"/>

        <Row>
          <xsl:for-each select="*[position() = 1]/*">
            <Cell ss:StyleID="s21">
              <Data ss:Type="String">
                <xsl:if test="local-name() = 'DealerName'">经销商名称</xsl:if>
                <xsl:if test="local-name() = 'WarehouseName'">仓库</xsl:if>
                <xsl:if test="local-name() = 'CustomerFaceNbr'">产品型号</xsl:if>
                <xsl:if test="local-name() = 'CFNChineseName'">产品中文名</xsl:if>
                <!--<xsl:if test="local-name() = 'Upn'">条形码</xsl:if>-->
                <xsl:if test="local-name() = 'LotNumber'">序列号/批号</xsl:if>
                <xsl:if test="local-name() = 'ExpiredDate'">有效期</xsl:if>
                <xsl:if test="local-name() = 'UnitOfMeasure'">单位</xsl:if>
                <xsl:if test="local-name() = 'OnHandQty'">库存数量</xsl:if>
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
