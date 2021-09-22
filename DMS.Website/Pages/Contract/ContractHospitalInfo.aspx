<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractHospitalInfo.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractHospitalInfo" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript" language="javascript">
       function getIsErrRowClass(record, index) {
        if (record.data.ISErr==1)
        {
           return 'yellow-row';
        }
    }
    </script>

    <style type="text/css">
        .yellow-row
        {
            background: #FFD700;
        }
    </style>
    <ext:Store ID="HospitalUploadStore" runat="server" OnRefreshData="HospitalUploadStore_RefreshData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="HospitalCode" />
                    <ext:RecordField Name="HospitalName" />
                    <ext:RecordField Name="Depart" />
                    <ext:RecordField Name="DepartRemark" />
                    <ext:RecordField Name="ErrMsg" />
                    <ext:RecordField Name="ISErr" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidMarktingType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidContractId" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North Collapsible="false" Split="True">
                    <ext:Hidden ID="hidHospitalUploadDatId" runat="server">
                    </ext:Hidden>
                </North>
                <Center>
                    <ext:Panel ID="plSearch" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:FormLayout ID="FormLayout1" runat="server">
                                <ext:Anchor>
                                    <ext:FormPanel ID="FPHospital" runat="server" Frame="true" Header="false" AutoHeight="true"
                                        MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                                        <Defaults>
                                            <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                                            <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                            <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                                        </Defaults>
                                        <Body>
                                            <ext:FormLayout ID="FormLayout17" runat="server" LabelWidth="50">
                                                <ext:Anchor>
                                                    <ext:FileUploadField ID="FileUploadHospital" runat="server" EmptyText="选择授权医院文件"
                                                        FieldLabel="文件" Width="500" ButtonText="" Icon="ImageAdd">
                                                    </ext:FileUploadField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                        <Listeners>
                                            <ClientValidation Handler="#{SaveButtonHospitalinit}.setDisabled(!valid);" />
                                        </Listeners>
                                        <Buttons>
                                            <ext:Button ID="SaveButtonHospitalinit" runat="server" Text="上传授权医院">
                                                <AjaxEvents>
                                                    <Click OnEvent="HospitalUploadClick" Before="if(!#{FPHospital}.getForm().isValid()) { return false; } 
                                                        Ext.Msg.wait('正在上传授权医院...', '传授权医院上传');" Success="#{PagingToolBarHospital}.changePage(1);#{FileUploadHospital}.setValue('');
                                                            Ext.Msg.show({ 
                                                            title   : '成功', 
                                                            msg     : '上传成功', 
                                                            minWidth: 200, 
                                                            modal   : true, 
                                                            buttons : Ext.Msg.OK })">
                                                    </Click>
                                                </AjaxEvents>
                                            </ext:Button>
                                            <ext:Button ID="Button3Hos" runat="server" Text="清除">
                                                <Listeners>
                                                    <Click Handler="#{FPHospital}.getForm().reset();#{SaveButtonHospitalinit}.setDisabled(true);" />
                                                </Listeners>
                                            </ext:Button>
                                            <ext:Button ID="Button4Hos" runat="server" Text="下载模板">
                                                <Listeners>
                                                    <Click Handler="window.open('../../Upload/ExcelTemplate/Template_DCMSHospital.xls')" />
                                                </Listeners>
                                            </ext:Button>
                                        </Buttons>
                                    </ext:FormPanel>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:Panel ID="PanelWd6AddTopValue" runat="server" BodyBorder="false" Header="false"
                                        FormGroup="true">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout4" runat="server">
                                                <ext:GridPanel ID="GridWd6HospitalInit" runat="server" StoreID="HospitalUploadStore"
                                                    Border="false" Title="医院列表" Icon="Lorry" StripeRows="true" Height="300" AutoScroll="true">
                                                    <ColumnModel ID="ColumnModel3" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Align="Left" Header="医院编码"
                                                                Width="80">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Align="Left" Header="医院名称">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="Depart" DataIndex="Depart" Align="Left" Header="科室">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="DepartRemark" DataIndex="DepartRemark" Align="Left" Header="科室备注">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息" Width="200">
                                                            </ext:Column>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <View>
                                                        <ext:GridView ID="GridView1" runat="server">
                                                            <GetRowClass Fn="getIsErrRowClass" />
                                                        </ext:GridView>
                                                    </View>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBarHospital" runat="server" PageSize="10" StoreID="HospitalUploadStore"
                                                            DisplayInfo="true" />
                                                    </BottomBar>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" />
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="ButtonSubmintHospital" runat="server" Text="提交" Icon="Disk">
                                <Listeners>
                                    <Click Handler=" Coolite.AjaxMethods.SubmintProductHospital({success:function(result)
                                                                                { if(result=='1') { window.parent.closeUploadHospitalWindow();} else if(result=='0') { Ext.Msg.alert('Error', '医院包含错误数据，请修改后重新上传!'); }
                                                                                  else { Ext.Msg.alert('Error', result);} 
                                                                                 },failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
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
