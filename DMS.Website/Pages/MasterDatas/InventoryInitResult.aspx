<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryInitResult.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.InventoryInitResult" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>产品明细信息 Product Detail Information</title>
    <link href="../../resources/css/css.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin-top: 10px; margin-bottom: 10px; margin-left: 10px; margin-right: 10px;">
    <form id="frmProductDetail" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div id="divHead" class="divCommon" style="margin: 0 auto; width: 780px; height: 30px;">
        <table class="tableHeader" style="width: 780px; height: 30px; border-collapse: collapse;"
            border="1" cellpadding="0" cellspacing="0">
            <tr id="trTitle">
                <td colspan="4">
                    <asp:Label ID="lbTitleChinese" runat="server">产品明细信息</asp:Label>
                </td>
            </tr>
        </table>
    </div>
    <!-- Info panel to be displayed as a flyout when the button is clicked -->
    <div id="divProcessing" style="position: absolute; left: 50%; top: 50%; width: 150px;
        height: 136px; z-index: 1; background-color: #FFFFFF; layer-background-color: #FFFFCC;
        border: 1px   none   #000000; display: none;" class="small3">
        <table style="height: 136px; width: 150px;" align="center" cellpadding="0" cellspacing="0"
            class="tdborder03">
            <tr>
                <td align="center">
                    <asp:Image ID="imgProcess" runat="server" ImageUrl="~/resources/images/gears_an.gif"
                        AlternateText="Processing" />
                </td>
            </tr>
            <tr>
                <td align="center">
                    处理中请稍后....
                </td>
            </tr>
        </table>
    </div>
    <div id="divDetailInfo" class="divCommon" runat="server" style="margin: 0 auto; width: 780px; overflow: visible;">
        <asp:UpdatePanel ID="upPanel" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gvDetail" runat="server" CssClass="gvTable" AutoGenerateColumns="False"
                    DataKeyNames="Id" Width="100%" ShowFooter="true" AllowPaging="False" 
                    EmptyDataRowStyle-CssClass="gvRow" AlternatingRowStyle-CssClass="gvRowAlt" RowStyle-CssClass="gvRow"
                    FooterStyle-CssClass="gvRowFooter" OnRowCancelingEdit="gvDetail_RowCancelingEdit"
                    OnRowDeleting="gvDetail_RowDeleting" OnRowEditing="gvDetail_RowEditing" OnRowUpdating="gvDetail_RowUpdating"
                    OnRowDeleted="gvDetail_RowDeleted" OnRowUpdated="gvDetail_RowUpdated" OnRowCommand="gvDetail_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="行号">
                            <HeaderStyle CssClass="gvHeadPM" Width="50" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellPM" Width="50" HorizontalAlign="Center" VerticalAlign="Middle"  Wrap="false"/>
                            <ItemTemplate>
                                <asp:Label ID="lbLineNbr" runat="server" Text='<%# Bind("LineNbr") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="lbLineNbr" runat="server" Text='<%# Bind("LineNbr") %>'></asp:Label>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="经销商代码">
                            <HeaderStyle CssClass="gvHeadPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle"  Wrap="false"/>
                            <ItemTemplate>
                                <asp:Label ID="lbSapCode" runat="server" Text='<%# Bind("SapCode") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox  runat="server" ID="tbSapCode" Text='<%# Bind("SapCode") %>' MaxLength="50" Width="98"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvSapCode" runat="server" ControlToValidate="tbSapCode" 
                                Display="None" EnableClientScript="true" ErrorMessage="经销商代码不允许为空" ValidationGroup="Update"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceSapCode" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvSapCode">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox  runat="server" ID="tbSapCode" Text='' MaxLength="50" Width="98"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvSapCode" runat="server" ControlToValidate="tbSapCode" 
                                Display="None" EnableClientScript="true" ErrorMessage="经销商代码不允许为空" ValidationGroup="Insert"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceSapCode" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvSapCode">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="仓库名称">
                            <HeaderStyle CssClass="gvHeadPM" Width="150" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellPM" Width="150" HorizontalAlign="Center" VerticalAlign="Middle"  Wrap="false"/>
                            <ItemTemplate>
                                <asp:Label ID="lbWhmName" runat="server" Text='<%# Bind("WhmName") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox  runat="server" ID="tbWhmName" Text='<%# Bind("WhmName") %>' MaxLength="50" Width="148"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvWhmName" runat="server" ControlToValidate="tbWhmName" 
                                Display="None" EnableClientScript="true" ErrorMessage="仓库名称不允许为空" ValidationGroup="Update"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceWhmName" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvWhmName">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox  runat="server" ID="tbWhmName" Text='' MaxLength="50" Width="148"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvWhmName" runat="server" ControlToValidate="tbWhmName" 
                                Display="None" EnableClientScript="true" ErrorMessage="仓库名称不允许为空" ValidationGroup="Insert"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceWhmName" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvWhmName">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="产品型号">
                            <HeaderStyle CssClass="gvHeadPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle"  Wrap="false"/>
                            <ItemTemplate>
                                <asp:Label ID="lbCfn" runat="server" Text='<%# Bind("Cfn") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox  runat="server" ID="tbCfn" Text='<%# Bind("Cfn") %>' MaxLength="200" Width="98"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCfn" runat="server" ControlToValidate="tbCfn" 
                                Display="None" EnableClientScript="true" ErrorMessage="产品型号不允许为空" ValidationGroup="Update"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceCfn" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvCfn">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox  runat="server" ID="tbCfn" Text='' MaxLength="200" Width="98"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCfn" runat="server" ControlToValidate="tbCfn" 
                                Display="None" EnableClientScript="true" ErrorMessage="产品型号不允许为空" ValidationGroup="Insert"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceCfn" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvCfn">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="产品批次号">
                            <HeaderStyle CssClass="gvHeadPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle"  Wrap="false"/>
                            <ItemTemplate>
                                <asp:Label ID="lbLtmLotNumber" runat="server" Text='<%# Bind("LtmLotNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox  runat="server" ID="tbLtmLotNumber" Text='<%# Bind("LtmLotNumber") %>' MaxLength="20" Width="98"></asp:TextBox>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox  runat="server" ID="tbLtmLotNumber" Text='' MaxLength="20" Width="98"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="产品有效期">
                            <HeaderStyle CssClass="gvHeadPM" Width="80" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellPM" Width="80" HorizontalAlign="Center" VerticalAlign="Middle"  Wrap="false"/>
                            <ItemTemplate>
                                <asp:Label ID="lbLtmExpiredDate" runat="server" Text='<%# Bind("LtmExpiredDate") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox  runat="server" ID="tbLtmExpiredDate" Text='<%# Bind("LtmExpiredDate") %>' Width="78"></asp:TextBox>
                                <ajaxtoolkit:CalendarExtender ID="ceLtmExpiredDate" runat="server" Format="yyyy-MM-dd" TargetControlID="tbLtmExpiredDate" />
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceLtmExpiredDate" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="revLtmExpiredDate">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                                <asp:RegularExpressionValidator ID="revLtmExpiredDate" runat="server" ControlToValidate="tbLtmExpiredDate" Display="None" EnableClientScript="True" 
                                    ErrorMessage="日期格式不正确(yyyy-mm-dd)" ValidationExpression="^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$" ValidationGroup="Update"></asp:RegularExpressionValidator>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox  runat="server" ID="tbLtmExpiredDate" Text='' Width="78"></asp:TextBox>
                                <ajaxtoolkit:CalendarExtender ID="ceLtmExpiredDate" runat="server" Format="yyyy-MM-dd" TargetControlID="tbLtmExpiredDate" />
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceLtmExpiredDate" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="revLtmExpiredDate">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                                <asp:RegularExpressionValidator ID="revLtmExpiredDate" runat="server" ControlToValidate="tbLtmExpiredDate" Display="None" EnableClientScript="True" 
                                    ErrorMessage="日期格式不正确(yyyy-mm-dd)" ValidationExpression="^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$" ValidationGroup="Insert"></asp:RegularExpressionValidator>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="数量">
                            <HeaderStyle CssClass="gvHeadPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellPM" Width="100" HorizontalAlign="Center" VerticalAlign="Middle"  Wrap="false"/>
                            <ItemTemplate>
                                <asp:Label ID="lbQty" runat="server" Text='<%# Bind("Qty") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox  runat="server" ID="tbQty" Text='<%# Bind("Qty") %>' MaxLength="20" Width="98"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvQty" runat="server" ControlToValidate="tbQty" 
                                Display="None" EnableClientScript="true" ErrorMessage="数量不允许为空" ValidationGroup="Update"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceQty" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvQty">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                                <asp:RangeValidator ID="rvQty" runat="server" Display="None" EnableClientScript="true"
                                  ErrorMessage="数量格式不正确（0 - 999999999）" MaximumValue="999999999" MinimumValue="1" Type="Integer"
                                  ControlToValidate="tbQty" ValidationGroup="Update"></asp:RangeValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceQtyFormat" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rvQty">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox  runat="server" ID="tbQty" Text='' MaxLength="20" Width="98"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvQty" runat="server" ControlToValidate="tbQty" 
                                Display="None" EnableClientScript="true" ErrorMessage="数量不允许为空" ValidationGroup="Insert"></asp:RequiredFieldValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceQty" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvQty">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                                <asp:RangeValidator ID="rvQty" runat="server" Display="None" EnableClientScript="true"
                                  ErrorMessage="数量格式不正确（0 - 999999999）" MaximumValue="999999999" MinimumValue="1" Type="Integer"
                                  ControlToValidate="tbQty" ValidationGroup="Insert"></asp:RangeValidator>
                                <ajaxtoolkit:ValidatorCalloutExtender ID="vceQtyFormat" runat="server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rvQty">
                                </ajaxtoolkit:ValidatorCalloutExtender>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="操作">
                            <HeaderStyle CssClass="gvHeadAction" Width="100" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemStyle CssClass="gvCellAction" Width="100" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <FooterStyle CssClass="gvCellAction" HorizontalAlign="Center" VerticalAlign="Middle" Wrap="false" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imgEdit" runat="server" ImageAlign="AbsMiddle" ImageUrl="~/resources/images/edititem.gif"
                                    CommandName="Edit" AlternateText="Edit" CausesValidation="false"/>
                                <asp:ImageButton ID="imgDel" runat="server" ImageAlign="AbsMiddle" ImageUrl="~/resources/images/delitem.gif"
                                    CommandName="Delete" AlternateText="Delete" CausesValidation="false" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:ImageButton ID="imgCancel" runat="server" ImageAlign="AbsMiddle" ImageUrl="~/resources/images/cancelitem.gif"
                                    CommandName="Cancel" AlternateText="Cancel" CausesValidation="false" />
                                <asp:ImageButton ID="imgUpdate" runat="server" ImageAlign="AbsMiddle" ImageUrl="~/resources/images/saveitem.gif"
                                    CommandName="Update" AlternateText="Update" ValidationGroup="Update" />
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:ImageButton ID="imgUpdateInsert" runat="server" ImageAlign="AbsMiddle" ImageUrl="~/resources/images/saveitem.gif"
                                    CommandName="Insert" AlternateText="Insert" ValidationGroup="Insert" />
                                <asp:ImageButton ID="imgCancelInsert" runat="server" ImageAlign="AbsMiddle" ImageUrl="~/resources/images/cancelitem.gif"
                                    CommandName="Cancel" AlternateText="Reset" CausesValidation="false" />
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <webdiyer:AspNetPager ID="AspNetPager1" runat="server" HorizontalAlign="Center" OnPageChanged="AspNetPager1_PageChanged"
                    Width="100%" AlwaysShow="true" ShowPageIndexBox="Never" PageSize="10">
                </webdiyer:AspNetPager>                                            
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <ajaxtoolkit:UpdatePanelAnimationExtender ID="upae" BehaviorID="animation" runat="server"
        TargetControlID="upPanel">
        <Animations>
                <OnUpdating>
                    <Sequence>
                        <%-- Store the original height of the panel --%>
                        <%-- ScriptAction Script="var b = $find('animation'); b._originalHeight = b._element.offsetHeight;" /--%>
                        <StyleAction AnimationTarget="divProcessing" Attribute="display" Value="block"/>
                        <%-- Disable all the controls --%>
                        <Parallel duration="0">
                            <EnableAction AnimationTarget="gvDetail" Enabled="false" />
                            <EnableAction AnimationTarget="btnSave" Enabled="false" />
                            <%--EnableAction AnimationTarget="rdlSize" Enabled="false" /--%>
                            <EnableAction AnimationTarget="rdlEditType" Enabled="false" />
                            <EnableAction AnimationTarget="dlFields" Enabled="false" />
                        </Parallel>
                    </Sequence>
                </OnUpdating>
                <OnUpdated>
                    <Sequence>
                        <%-- Enable all the controls --%>
                        <Parallel duration="0">
                            <EnableAction AnimationTarget="rdlEditType" Enabled="true" />
                            <EnableAction AnimationTarget="dlFields" Enabled="true" />
                            <%--EnableAction AnimationTarget="rdlSize" Enabled="true" /--%>
                            <EnableAction AnimationTarget="btnSave" Enabled="true" />
                            <EnableAction AnimationTarget="gvDetail" Enabled="true" />
                        </Parallel>                            
                        <StyleAction AnimationTarget="divProcessing" Attribute="display" Value="none"/>
                    </Sequence>
                </OnUpdated>
        </Animations>
    </ajaxtoolkit:UpdatePanelAnimationExtender>
    </form>
</body>
</html>
