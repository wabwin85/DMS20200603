<%@ Page Language="C#" AutoEventWireup="true" Inherits="_Default" CodeBehind="Default.aspx.cs" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="~/Controls/TopControl.ascx" TagName="TopControl" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <% ///***
        ///<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
       /// ***/// %>
    <title><%=GetLocalResourceObject("Title").ToString()%></title>
    <% 
        if (SystemLanguage == "en-US")
        {
    %>
    <script type="text/javascript" src="resources/lang/en-US.js"></script>
    <%
        }
        else
        {
    %>
    <script type="text/javascript" src="resources/lang/zh-CN.js"></script>
    <%  
        }  
    %>
    <script type="text/javascript" src="resources/ExampleTab.js"></script>
    <script type='text/javascript' src='//webchat.7moor.com/javascripts/7moorInit.js?accessId=e9d396f0-16b1-11e7-b17f-e9b95a4993ef&autoShow=false' async='async'></script>

    <script type="text/javascript">
        var kendoWindow = null;

        var GetStringParam = function (str, name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = str.match(reg);
            if (r != null) return unescape(r[2]);
            return '';
        }

        var changeTheme = function () {
            Coolite.AjaxMethods.GetThemeUrl("Gray", {
                success: function (result) {
                    Coolite.Ext.setTheme(result);
                    ExampleTabs.items.each(function (el) {
                        if (!Ext.isEmpty(el.iframe)) {
                            el.iframe.dom.contentWindow.Coolite.Ext.setTheme(result);
                        }
                    });
                }
            });
        }

        var closeTab = function (id) {
            id = id.toUpperCase();
            var tab = ExampleTabs.getComponent(id);
            ExampleTabs.closeTab(id);
        }
        var loadExample = function (href, id, title) {
            id = id.toUpperCase();
            var tab = ExampleTabs.getComponent(id);

            if (tab) {
                ExampleTabs.setActiveTab(tab);
            } else {
                createExampleTab(id, href, title);
            }

            Coolite.AjaxMethods.WriteUserAccessLog(href, id, title, {
                success: function (result) {

                }
            });

        }

        var onItemClick = function (item) {

            var title = item.text;
            var url = item.href;

            if (url.indexOf("Contract/Pages/Home.aspx") >= 0 || url.indexOf("BscDp/Pages/Home.aspx") >= 0 || url.indexOf("PagesKendo/ContractElectronic/Homepage.aspx") >= 0) {
                window.open(url);
            } else if (url.indexOf("PagesKendo/Home.aspx") >= 0) {
                if (kendoWindow == null || kendoWindow.closed) {
                    kendoWindow = window.open(url, 'window1');
                } else {
                    kendoWindow.clickByPowerkey(GetStringParam(url.substr(url.indexOf('?') + 1), 'PowerKey'));
                    kendoWindow.focus();
                }
            } else {
                if (title == null) title = "Overview";
                if (url == null) url = "/Pages/FileNotFound.htm";
                item.href = null;

                //            var tb = item.findParentByType("tbbutton");

                //            for (t in tb) {
                //                alert(t);
                //            }
                //alert(item.ownerCt.text);

                loadExample(url, item.id, title);               
                
            }
        }

        function ItemClick(id, title, url) {

            if (title == null) title = "Overview";
            if (url == null) url = "/Pages/FileNotFound.htm";

            if (url.indexOf("Contract/Pages/Home.aspx") >= 0 || url.indexOf("BscDp/Pages/Home.aspx") >= 0 || url.indexOf("PagesKendo/ContractElectronic/Homepage.aspx") >= 0) {
                window.open(url);
            } else if (url.indexOf("PagesKendo/Home.aspx") >= 0) {
                if (kendoWindow == null || kendoWindow.closed) {
                    kendoWindow = window.open(url, 'window1');
                } else {
                    kendoWindow.clickByPowerkey(GetStringParam(url.substr(url.indexOf('?') + 1), 'PowerKey'));
                    kendoWindow.focus();
                }
            }
           
            else {
                loadExample(url, id, title);
                
            }

            //记录日志
        }

        var req;
        var url = "BSCDp/Pages/Refresh.aspx";
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) {
            req = new ActiveXObject("Microsoft.XMLHttp");
        }

        if (req) {
            req.open("POST", url, true);
            req.send(null);
        }
      
    </script>

    <link href="resources/css/main.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <style type="text/css">
        body {
            font-size: 12px;
            background-color: #577DA1;
            font-family: "Trebuchet MS",sans-serif;
        }
            
        #settingsWrapper {
            border-bottom: 0px solid transparent;
            background-image: url("/resources/images/bg0910.jpg"); 
            background-attachment: scroll;
            background-repeat: repeat-x;
            background-position-x: left;
            background-position-y: top;
            padding-left: 0px;
            margin: 0px;
            padding: 0px;
            display: block;
        }

        #logon {
            float: left;
            padding: 2px;
            border-bottom: 1px solid transparent;
            padding-left: 4px;
            text-align: left;
            clear: both;
        }

            #logon ul li {
            color: #fff;
            margin-right: 8px;
            line-height: 24px;
            padding: 2px;
            padding-left: 10px;
        }

        #settings {
            padding: 2px;
            border-bottom: 1px solid transparent;
            padding-right: 4px;
            text-align: left;
        }

            #settings ul li {
            display: inline;
            color: #fff;
            margin-right: 8px;
            line-height: 24px;
            padding: 2px;
            padding-left: 19px;
        }

                #settings ul li a, #settings ul li a:link {
            color: #fff;
            text-decoration: none;
        }

                    #settings ul li a:hover {
            text-decoration: underline;
        }

                #settings ul li logon {
            text-align: left;
            padding-left: 10px;
        }

                #settings ul li welcome {
            font-family: Verdana;
            font-style: italic;
            font-size: 13px;
        }

        #pageTitle {
            font-family: "Trebuchet MS",sans-serif;
            font-size: 17px;
            text-align: left;
            color: #fff;
            margin-top: 10px;
            margin-bottom: 10px;
            padding-left: 10px;
        }

        #mainMenu {
            margin-top: 0px;
            margin-bottom: 0px;
            clear: both;
        }

        #itemAddContent {
            background: url(<%= this.ScriptManager1.GetIconUrl(Icon.Add) %>) no-repeat 0 2px;
        }

        #itemComments {
            background: url(<%= this.ScriptManager1.GetIconUrl(Icon.Comment) %>) no-repeat 0 2px;
        }

        #itemActivities {
            background: url(<%= this.ScriptManager1.GetIconUrl(Icon.Star) %>) no-repeat 0 2px;
        }

        #itemContacts {
            background: url(<%= this.ScriptManager1.GetIconUrl(Icon.Vcard) %>) no-repeat 0 2px;
        }

        #itemLogout {
            background: url(<%= this.ScriptManager1.GetIconUrl(Icon.LockOpen) %>) no-repeat 0 2px;
        }

        #ExampleTabs ul.x-tab-strip-top {
            background-image: none !important;
            background-color: #577DA1;
        }

        UL.x-tab-strip-top {
            border-top-color: #577DA1 !important;
            border-right-color: #577DA1 !important;
            border-bottom-color: #577DA1 !important;
            border-left-color: #577DA1 !important;
        }

        .x-panel-dd-spacer {
            border: 2px dashed #284051;
        }

        .x-toolbar {
            background-image: url('') !important; /* ../resources/images/menu-bg.gif #284051!important;*/
            background-color: #9bb6d3 !important;
            border-top-color: # !important;
            border-bottom-color: # !important;
            border-left-color: # !important;
            border-right-color: # !important;
            border-bottom-width: 0px !important;
        }
        
        .x-tab-panel .x-border-panel .x-tab-panel-noborder {
            margin-top: 120px !important;
        }

        .notice-container {
            right: 0px;
            position: fixed !important;
            top:45px;
            width: auto;
            z-index: 12;
            display: block;
        }
    </style>

    <script type='text/javascript'>
        //var kfuId = document.getElementById('hidUserId').value
        //var kfuName = document.getElementById('hidUserName').value
       
        var qimoClientId = { "userId": "<%= Lafite.RoleModel.Security.RoleModelContext.Current.User.Id %>", "nickName": "<%= string.IsNullOrEmpty(Lafite.RoleModel.Security.RoleModelContext.Current.User.CorpName)?"BSC/"+Lafite.RoleModel.Security.RoleModelContext.Current.User.FullName:Lafite.RoleModel.Security.RoleModelContext.Current.User.CorpName %>", "agent": "8002" };
        
   </script>
    <script type='text/javascript' src='//webchat.7moor.com/javascripts/7moorInit.js?accessId=e0bd5be0-5717-11e7-8a41-d346af8ef189&autoShow=false' async='async'></script>
  

    <ext:Hidden ID="hidUserId" runat="server"></ext:Hidden>
    <ext:Hidden ID="hidUserName" runat="server"></ext:Hidden>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" StateProvider="None" Theme="Slate"></ext:ScriptManager>
        <div class="notice-container">
            <img style="cursor: pointer" src="resources/images/eBar-logo_gif.gif" onclick="qimoChatClick();" />
        </div>
    <div>
        <ext:ViewPort ID="ViewPort1" runat="server" StyleSpec="background-color: transparent;">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="false">
                        <ext:Panel ID="pnlNorth" runat="server" Height="70" Border="false" Header="false"
                            BodyStyle="background-color: transparent;">
                            <Body>
                                    <uc1:TopControl ID="TopControl1" runat="server" />
                            
                                    <table width="100%" cellpadding="0" border="0" cellspacing="0" style="border-collapse: collapse;">
                                    <tr>
                                            <td>
                                            <div id="mainMenu">
                                                <ext:Toolbar ID="Toolbar1" runat="server" AutoWidth="true">
                                                    <Items>
                                                    </Items>
                                                </ext:Toolbar>
                                            </div>
                                        </td>
                                            <td align="left" valign="top" style="width: 60px; background-color: #9bb6d3;">
                                                <img src="../resources/images/banner0911.png" alt="bg" style="margin: 0; padding: 0px; display: block;" />
                                        </td>
                                    </tr>
                                </table>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="5 5 5 0">
                        <ext:TabPanel ID="ExampleTabs" runat="server" Title="TabPanel" ActiveTabIndex="0" EnableTabScroll="true"
                            Border="false" BodyStyle="background-color: #4D778B; border: 1px solid #AABBCC; border-top: none;">
                            <Tabs>
                                <ext:Tab runat="server" Title="<%$ Resources: ExampleTabs.ctl2388.Title %>" Icon="House" ID="ctl2388">
                                    <AutoLoad ShowMask="true" Url="" Mode="IFrame"></AutoLoad>                                    
                                </ext:Tab>
                            </Tabs>
                            <Plugins>
                                <ext:GenericPlugin ID="GenericPlugin1" runat="server" InstanceOf="Ext.ux.plugins.TabCloseMenu" Path="~/resources/tabclosemenu.js" />
                            </Plugins>
                        </ext:TabPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    </form>
</body>
</html>
