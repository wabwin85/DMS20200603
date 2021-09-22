<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractTerritoryAreaQuery.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractTerritoryAreaQuery" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
     Ext.apply(Ext.util.Format, {            number: function(v, format) {                if(!format){                    return v;                }                                                v *= 1;                if(typeof v != 'number' || isNaN(v)){                    return '';                }                var comma = ',';                var dec = '.';                var i18n = false;                                if(format.substr(format.length - 2) == '/i'){                    format = format.substr(0, format.length-2);                    i18n = true;                    comma = '.';                    dec = ',';                }                var hasComma = format.indexOf(comma) != -1,                    psplit = (i18n ? format.replace(/[^\d\,]/g,'') : format.replace(/[^\d\.]/g,'')).split(dec);                if (1 < psplit.length) {                    v = v.toFixed(psplit[1].length);                }                else if (2 < psplit.length) {                    throw('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format);                }                else {                    v = v.toFixed(0);                }                var fnum = v.toString();                if (hasComma) {                    psplit = fnum.split('.');                    var cnum = psplit[0],                        parr = [],                        j = cnum.length,                        m = Math.floor(j / 3),                        n = cnum.length % 3 || 3;                    for (var i = 0; i < j; i += n) {                        if (i != 0) {n = 3;}                        parr[parr.length] = cnum.substr(i, n);                        m -= 1;                    }                    fnum = parr.join(comma);                    if (psplit[1]) {                        fnum += dec + psplit[1];                    }                }                return format.replace(/[\d,?\.?]+/, fnum);            },            numberRenderer : function(format){                return function(v){                    return Ext.util.Format.number(v, format);                };            }        });
        
        function refreshLines(tree) {
            Coolite.AjaxMethods.RefreshLines({
                success: function(result) {
                    var nodes = eval(result);
                    if (tree.root != null)
                        tree.root.ui.remove();
                    tree.initChildren(nodes);

                    if (tree.root != null)
                        tree.root.render();
                }
            });
        }

        function checkChange2(nodeid, node, value) {
            var checked = value.checkbox.checked; //获取节点上的checkbox控件
            node.expand(); //展开下面的节点
            node.attributes.checked = checked;
            node.eachChild(function(child) {
                child.ui.toggleCheck(checked);
                child.attributes.checked = checked;
                child.fireEvent('checkchange', child, checked);
            });
        }
        
     
        
       var ClosePage=function()
        {
            window.open('','_self');
            window.close();
        }
        
    </script>

    <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HosId">
                <Fields>
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalShortName" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosGrade" />
                    <ext:RecordField Name="HosKeyAccount" />
                    <ext:RecordField Name="HosProvince" />
                    <ext:RecordField Name="HosCity" />
                    <ext:RecordField Name="HosDistrict" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="AreaStore" runat="server" UseIdConfirmation="false" OnRefreshData="AreaStore_OnRefreshData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="TerId">
                <Fields>
                    <ext:RecordField Name="TerId" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="Selected" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:FitLayout ID="FitLayout1" runat="server">
                <ext:TabPanel ID="TabPanelDeatil" runat="server" ActiveTabIndex="0" Border="false">
                    <Tabs>
                        <ext:Tab ID="TabPartsClassification" runat="server" Title="授权产品分类" Icon="ChartOrganisation"
                            AutoShow="true">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout3" runat="server">
                                    <North Collapsible="True" MarginsSummary="0 5 5 5">
                                        <ext:Panel ID="Panel10" runat="server" Header="false" BodyBorder="false" Height="0">
                                            <Body>
                                            </Body>
                                        </ext:Panel>
                                    </North>
                                    <Center MarginsSummary="0 5 5 5">
                                        <ext:Panel runat="server" ID="Panel11" Border="false" Frame="true" Title="第一步：授权产品分类"
                                            Icon="HouseKey" Height="200" ButtonAlign="Left">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout6" runat="server">
                                                    <ext:TreePanel ID="menuTree" runat="server" Title="授权产品分类" Header="true" RootVisible="true">
                                                        <Tools>
                                                            <ext:Tool Type="Refresh" Handler="refreshLines(#{menuTree});" />
                                                        </Tools>
                                                        <Listeners>
                                                            <CheckChange Handler="checkChange2(node.id,node,node.getUI());" />
                                                        </Listeners>
                                                    </ext:TreePanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabArea" runat="server" Title="授权区域(省份)" Icon="ChartOrganisation" AutoShow="true">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout2" runat="server">
                                    <Center MarginsSummary="0 5 0 5">
                                        <ext:Panel ID="Panel1" runat="server" Title="第二步：授权区域(省份)" Icon="Basket" Height="280"
                                            ButtonAlign="Left" IDMode="Legacy">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout3" runat="server">
                                                    <ext:GridPanel ID="gpArea" runat="server" StoreID="AreaStore" Border="false" HideHeaders="true"
                                                        Collapsible="true" Icon="Lorry" StripeRows="true">
                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Description" DataIndex="Description" Header="省份" Width="230">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SaveMask ShowMask="true" />
                                                        <LoadMask ShowMask="true" Msg="Load" />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                    <South Collapsible="false" Split="True" MarginsSummary="0 5 5 5">
                                        <ext:Hidden runat="server" ID="hidAreaSelected">
                                        </ext:Hidden>
                                    </South>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabAuthorization" runat="server" Title="区域内排除医院" Icon="ChartOrganisation"
                            AutoShow="true">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout1" runat="server">
                                    <Center MarginsSummary="0 5 0 5">
                                        <ext:Panel ID="pnlSouth" runat="server" Title="第三步：区域内排除医院：" Icon="Basket" Height="280"
                                            IDMode="Legacy">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout2" runat="server">
                                                    <ext:GridPanel ID="gplAuthHospital" runat="server" Title="排除医院" Header="false" AutoExpandColumn="HosHospitalName"
                                                        StoreID="Store1" Border="false" ButtonAlign="Left" Icon="Lorry" StripeRows="true">
                                                        <Buttons>
                                                            <ext:Button ID="BtnSubmit" runat="server" Text="关闭" Icon="Disk" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Fn="ClosePage" />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Buttons>
                                                        <ColumnModel ID="ColumnModel2" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="HosId" Width="100" DataIndex="HosId" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosKeyAccount" Width="90" Header="医院编号">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HosHospitalName" Width="180" DataIndex="HosHospitalName" Header="医院名称">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosProvince" Width="90" Header="省份">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosCity" Width="70" Header="城市">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                    <South Collapsible="false" Split="True" MarginsSummary="0 5 5 5">
                                        <ext:Hidden runat="server" ID="hidSouth">
                                        </ext:Hidden>
                                    </South>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Tab>
                    </Tabs>
                </ext:TabPanel>
            </ext:FitLayout>
        </Body>
    </ext:ViewPort>
    <ext:Hidden ID="hidInstanceID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidProductLineId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidPartsContractCode" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidBeginDate" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidDivisionID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidContractType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidIsEmerging" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidProductAmend" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
