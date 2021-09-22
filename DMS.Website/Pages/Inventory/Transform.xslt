<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:user="urn:my-scripts"
	xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel"
	xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" >

  <xsl:template match="Order">

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
        <Style ss:ID="s22">
          <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
          <Font ss:Bold="1"/>
          <Interior ss:Color="#99CCFF" ss:Pattern="Solid"/>
        </Style>
        <Style ss:ID="s23" ss:Name="Currency">
          <NumberFormat
           ss:Format="_(&quot;$&quot;* #,##0.00_);_(&quot;$&quot;* \(#,##0.00\);_(&quot;$&quot;* &quot;-&quot;??_);_(@_)"/>
        </Style>
        <Style ss:ID="s24">
          <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>
        </Style>
        <Style ss:ID="s25">
          <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
        </Style>
      </Styles>

      <Worksheet>
        <xsl:attribute name="ss:Name">
          <xsl:value-of select='concat("Order #", Customer/OrderID)'/>
        </xsl:attribute>
        <Table ss:ExpandedColumnCount="3">
          <xsl:attribute name="ss:ExpandedRowCount" >
            <xsl:value-of select="count(Items)+10"/>
          </xsl:attribute>

          <Column ss:AutoFitWidth="0" ss:Width="250"/>
          <Column ss:AutoFitWidth="0" ss:Width="100"/>
          <Column ss:AutoFitWidth="0" ss:Width="75"/>

          <xsl:apply-templates select="Customer"/>

          <Row>
            <Cell ss:StyleID="s21">
              <Data ss:Type="String">Item</Data>
            </Cell>
            <Cell ss:StyleID="s21">
              <Data ss:Type="String">Quantity</Data>
            </Cell>
            <Cell ss:StyleID="s21">
              <Data ss:Type="String">Total</Data>
            </Cell>
          </Row>

          <xsl:apply-templates select="Items"/>

          <Row>
            <Cell ss:Index="2">
              <Data ss:Type="String">Subtotal</Data>
            </Cell>
            <Cell ss:StyleID="s23" ss:Formula="=SUM(R8C:R[-1]C)"/>
          </Row>
          <Row>
            <Cell ss:Index="2">
              <Data ss:Type="String">Freight</Data>
            </Cell>
            <Cell ss:StyleID="s23">
              <Data ss:Type="Number">
                <xsl:value-of select="Customer/Freight"/>
              </Data>
            </Cell>
          </Row>
          <Row>
            <Cell ss:Index="2">
              <Data ss:Type="String">Total</Data>
            </Cell>
            <Cell ss:StyleID="s23" ss:Formula="=R[-2]C+R[-1]C"/>
          </Row>
        </Table>
      </Worksheet>
    </Workbook>

  </xsl:template>

  <xsl:template match="Customer">
    <Row>
      <Cell>
        <Data ss:Type="String">
          <xsl:value-of select="CompanyName"/>
        </Data>
      </Cell>
    </Row>
    <Row>
      <Cell>
        <Data ss:Type="String">
          <xsl:value-of select="Address"/>
        </Data>
      </Cell>
    </Row>
    <Row>
      <Cell>
        <Data ss:Type="String">
          <xsl:value-of select='concat(City, ", ", Region, " ", PostalCode)'/>
        </Data>
      </Cell>
    </Row>
    <Row>
      <Cell>
        <Data ss:Type="String">
          <xsl:value-of select="Country"/>
        </Data>
      </Cell>
    </Row>
    <Row ss:Index="6">
      <Cell ss:MergeAcross="2" ss:StyleID="s22">
        <Data ss:Type="String">
          Order #<xsl:value-of select="OrderID"/>
        </Data>
      </Cell>
    </Row>
  </xsl:template>

  <xsl:template match="Items">
    <Row>
      <Cell>
        <Data ss:Type="String">
          <xsl:value-of select="ProductName"/>
        </Data>
      </Cell>
      <Cell ss:StyleID="s25">
        <Data ss:Type="Number">
          <xsl:value-of select="Quantity"/>
        </Data>
      </Cell>
      <Cell ss:StyleID="s24">
        <Data ss:Type="Number">
          <xsl:value-of select="ItemTotal"/>
        </Data>
      </Cell>
    </Row>
  </xsl:template>

</xsl:stylesheet>
