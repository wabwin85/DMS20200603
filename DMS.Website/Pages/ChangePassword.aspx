<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="DMS.Website.Pages.ChangePassword" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="lbTitle" runat="server" Text="Label"></asp:Label>
        <asp:ChangePassword ID="ChangePassword1" runat="server" CancelButtonText="<%$ Resources: ChangePassword1.CancelButtonText %>" 
            ChangePasswordButtonText="<%$ Resources: ChangePassword1.ChangePasswordButtonText %>" ChangePasswordTitleText="<%$ Resources: ChangePassword1.ChangePasswordTitleText %>" 
            ConfirmNewPasswordLabelText="<%$ Resources: ChangePassword1.ConfirmNewPasswordLabelText %>" 
            ConfirmPasswordCompareErrorMessage="<%$ Resources: ChangePassword1.ConfirmPasswordCompareErrorMessage %>" 
            ConfirmPasswordRequiredErrorMessage="<%$ Resources: ChangePassword1.ConfirmPasswordRequiredErrorMessage %>" ContinueButtonText="<%$ Resources: ChangePassword1.ContinueButtonText %>" 
            NewPasswordLabelText="<%$ Resources: ChangePassword1.NewPasswordLabelText %>" 
            NewPasswordRegularExpressionErrorMessage="<%$ Resources: ChangePassword1.NewPasswordRegularExpressionErrorMessage %>" 
            NewPasswordRequiredErrorMessage="<%$ Resources: ChangePassword1.NewPasswordRequiredErrorMessage %>" PasswordLabelText="<%$ Resources: ChangePassword1.PasswordLabelText %>" 
            PasswordRequiredErrorMessage="<%$ Resources: ChangePassword1.PasswordRequiredErrorMessage %>" SuccessText="<%$ Resources: ChangePassword1.SuccessText %>" 
            SuccessTitleText="<%$ Resources: ChangePassword1.SuccessTitleText %>" BackColor="#F7F7DE" BorderColor="#CCCC99" 
            BorderStyle="Solid" BorderWidth="1px" Font-Names="Verdana" Font-Size="10pt" 
            SuccessPageUrl="~/Default.aspx" 
            onchangedpassword="ChangePassword1_ChangedPassword">
            <TitleTextStyle BackColor="#6B696B" Font-Bold="True" ForeColor="#FFFFFF" />
        </asp:ChangePassword>
    
    </div>
    </form>
</body>
</html>
