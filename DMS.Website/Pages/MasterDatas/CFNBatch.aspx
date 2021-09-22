<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CFNBatch.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.CFNBatch" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>FormPanel - Coolite Toolkit Examples</title>
    <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />
    
 
    <style type="text/css">
        #fi-button-msg {
            border: 2px solid #ccc;
            padding: 5px 10px;
            background: #eee;
            margin: 5px;
            float: left;
        }
    </style>
    
    <script type="text/javascript">
        var showFile = function (fb, v) {
            var el = Ext.fly('fi-button-msg');
            el.update('<b>Selected:</b> ' + v);
            if (!el.isVisible()) {
                el.slideIn('t', {
                    duration: .2,
                    easing: 'easeIn',
                    callback: function() {
                        el.highlight();
                    }
                });
            } else {
                el.highlight();
            }
        }            
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        
            
        <ext:FormPanel 
            ID="BasicForm" 
            runat="server"
            Width="500"
            Frame="true"
            Title="产品批量导入"
            AutoHeight="true"
            MonitorValid="true"
            BodyStyle="padding: 10px 10px 0 10px;">                
            <Defaults>
                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
            </Defaults>
            <Body>
                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="50">

                    <ext:Anchor>
                        <ext:FileUploadField 
                            ID="FileUploadField1" 
                            runat="server" 
                            EmptyText="选择产品导入文件(Excel格式)"
                            FieldLabel="文件"
                            ButtonText=""
                            Icon="ImageAdd">
                        </ext:FileUploadField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Listeners>
                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
            </Listeners>
            <Buttons>
                <ext:Button ID="SaveButton" runat="server" Text="导入产品数据">
                    <AjaxEvents>
                        <Click 
                            OnEvent="UploadClick"
                            Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                Ext.Msg.wait('正在导入文件...', '文件上传导入');"
                                
                            Failure="Ext.Msg.show({ 
                                title   : '错误', 
                                msg     : '上传中发生错误', 
                                minWidth: 200, 
                                modal   : true, 
                                icon    : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK 
                            });">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="Button2" runat="server" Text="清除">
                    <Listeners>
                        <Click Handler="#{BasicForm}.getForm().reset();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            
            
            
        </ext:FormPanel>
        
    </form>
</body>
</html>