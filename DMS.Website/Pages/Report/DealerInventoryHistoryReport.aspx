<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerInventoryHistoryReport.aspx.cs"
    Inherits="DMS.Website.Pages.Report.DealerInventoryHistoryReport" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }
    </style>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Date.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />

    <script type="text/javascript">
    function CheckCondition()
     {
     
        var Inventdate = <%=dfInventDate.ClientID%>.getValue();
        if (Inventdate == "")
        {
            alert('请填写库存日期！');
            return false;
        }
        
        return true;
     }
     
     function SelectValue(e) {
        var filterField = 'ChineseName';  //需进行模糊查询的字段
        var combo = e.combo;
        combo.collapse();
        if (!e.forceAll) {
           var value = e.query;
            if (value != null && value != '') {
                combo.store.filterBy(function (record, id) {
                    var text = record.get(filterField);
                    if (text != null && text != "") {
                        // 用自己的过滤规则,如写正则式
                        return (text.indexOf(value) != -1);
                    }
                    else {
                       return false;
                    }
                });
            } else {
                combo.store.clearFilter();
            }
            combo.onLoad(); //不加第一次会显示不出来  
            combo.expand();
            return false;
        }
     }  
    
    </script>

     <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                        BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                   <ext:ComboBox ID="cboDealer" runat="server" EmptyText="<%$ Resources: Dealer.Empty %>" Width="300"
                                                        Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id" 
                                                        DisplayField="ChineseName" Mode="Local"  FieldLabel="<%$ Resources: Dealer.Label %>" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Dealer.Clear %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <BeforeQuery Fn="SelectValue" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:DateField ID="dfInventDate" runat="server" Width="150"  FieldLabel="<%$ Resources: InventDate.Label %>">
                                                    </ext:DateField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy" AutoPostBack="true" OnClientClick="var result = CheckCondition(); if (!result) return false;">
                                <AjaxEvents>
                                    <Click OnEvent="btnSearch_Click">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel12" runat="server" Height="300" Header="false">
                        <Body>
                            <rsweb:ReportViewer ID="ReportViewer1" runat="server" ProcessingMode="Remote">
                            </rsweb:ReportViewer>
                              <script language="javascript" type="text/javascript">
                                ResizeReport();
                                function ResizeReport() {
                                    var viewer = document.getElementById("<%= ReportViewer1.ClientID %>");
                                    var htmlheight = document.documentElement.clientHeight;
                                    viewer.style.height = (htmlheight - 187) + "px";
                                }
                                window.onresize = function resize() { ResizeReport(); }
                            </script>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>
     <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
   </script>
</body>
</html>
