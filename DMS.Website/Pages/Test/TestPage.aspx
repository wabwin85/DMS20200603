<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestPage.aspx.cs" Inherits="DMS.Website.Pages.Test.TestPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>测试页面</title>
    <style type="text/css">
        .list-item
        {
            font: normal 9px tahoma, arial, helvetica, sans-serif;
            padding: 1px 1px 1px 1px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #bbbbbb;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: normal;
            font-size: 12px;
            color: #222;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="Store1" runat="server" UseIdConfirmation="true" AutoLoad="false">
        <Proxy>
            <ext:HttpProxy Method="POST" Url="TestSearch.ashx" />
        </Proxy>
        <Reader>
            <ext:JsonReader Root="result" TotalProperty="totalCount">
                <Fields>
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosAddress" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <BaseParams>
            <ext:Parameter Name="DealerId" Value="DealerId" Mode="Value" />
            <ext:Parameter Name="ProductLineId" Value="ProductLineId" Mode="Value" />
        </BaseParams>
        <Listeners>
            <Load Handler="alert('Loaded');" />
        </Listeners>
    </ext:Store>

    <ext:ComboBox ID="ComboBox1" runat="server" StoreID="Store1" DisplayField="HosHospitalName"
        ValueField="HosId" TypeAhead="false" LoadingText="Searching..." Width="570"
        PageSize="10" ItemSelector="div.list-item" MinChars="1">
        <Template ID="Template1" runat="server">
            <tpl for=".">
                <div class="list-item">
                     <h3>{HosHospitalName}</h3>
                     <p>1111&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{HosAddress}</p>   
                </div>
            </tpl>
        </Template>
    </ext:ComboBox>
    <ext:Button runat="server" ID="btn" Text="btn">
        <Listeners>
            <Click Handler="#{Store1}.reload()" />
        </Listeners>
    </ext:Button>
    </form>
</body>
</html>
