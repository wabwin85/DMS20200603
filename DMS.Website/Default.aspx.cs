using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Collections;
using System.Data;


using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;

using DMS.Business.Cache;
using DMS.Model.Data;

using Lafite.RoleModel.Security;
using Lafite.SiteMap.Provider;
using Lafite.RoleModel.Provider;

public partial class _Default : BasePage
{
    private IRoleModelContext _context = RoleModelContext.Current;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Ext.IsAjaxRequest)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                LoadMenu();
                if (IsDealer)
                {
                    ExampleTabs.Tabs[0].AutoLoad.Url = "~/Pages/Home/DealerHomePage.aspx";
                }
                else
                {
                    ExampleTabs.Tabs[0].AutoLoad.Url = "~/Pages/Home/SynthesHomePage.aspx";
                }
                //判断用户是否维护了微信用户信息
                IsConvertWeChateUser();
            }
        }

        ExampleTabs.Style.Add("top", "120px !important");

    }
    private void PageInit()
    {
        this.hidUserId.Text = _context.User.Id;
        this.hidUserName.Text = _context.User.CorpName;
    }

    protected void LoadMenu()
    {


        ISiteProvider siteProvider = null;

        //siteProvider = new DbSiteProvider();
        //Lafite.SiteMap.SiteNode rootNode = siteProvider.GetSiteNode(0, "Menu");

        Permissions list = _context.User.GetPermissions("Menu", null);
        var allowkeys = (from p in list select p.FunctionCode).ToList<string>();

        siteProvider = new UserSiteProvider(allowkeys);
        Lafite.SiteMap.SiteNode rootNode = siteProvider.GetSiteNode(0, "Menu");

        foreach (Lafite.SiteMap.SiteNode mainMenu in rootNode.Nodes)
        {
            //if (mainMenu.Title != "Administration" && mainMenu.ResourceKey != "KendoSite")
            if (mainMenu.Title != "Administration")
            {
                ToolbarButton toolButton = new ToolbarButton();
                toolButton.ID = string.Format("toolButton{0}", mainMenu.ItemId);
                string[] titles = mainMenu.Title.Split('|');//titles[0]为中文，titles[1]为英文
                if (SystemLanguage == SR.CONST_SYS_LANG_CN)
                {
                    toolButton.Text = titles[0];
                }
                else if (titles.Length > 1)
                {
                    toolButton.Text = titles[1];
                }
                else
                {
                    toolButton.Text = titles[0];
                }
                //toolButton.Text = mainMenu.Title;
                toolButton.Icon = Coolite.Ext.Web.Icon.NoteAdd;

                AddSubMenu(mainMenu, toolButton);

                this.Toolbar1.Items.Add(toolButton);
            }
        }
    }

    protected void AddSubMenu(Lafite.SiteMap.SiteNode mainMenu, ToolbarButton toolButton)
    {
        Coolite.Ext.Web.Menu menu = new Coolite.Ext.Web.Menu();
        menu.ID = string.Format("mainMenu{0}", mainMenu.ItemId);

        foreach (Lafite.SiteMap.SiteNode subMenu in mainMenu.Nodes)
        {
            //if (subMenu.ResourceKey != "KendoSite")
            //{
            if ((subMenu.Title == "-") || (subMenu.Title == string.Empty))
            {
                bool isNewSeparator = true;

                int index = menu.Items.Count;
                if (index > 0)
                    isNewSeparator = !(menu.Items[index - 1] is MenuSeparator);
                else
                    isNewSeparator = false;

                if (isNewSeparator)
                {
                    MenuSeparator menu1 = new MenuSeparator();
                    menu.Items.Add(menu1);
                }
            }
            else
            {
                Coolite.Ext.Web.MenuItem menu2 = new Coolite.Ext.Web.MenuItem();

                menu2.ID = string.Format("subMenu{0}", subMenu.ItemId);

                string[] titles = subMenu.Title.Split('|');//titles[0]为中文，titles[1]为英文
                if (SystemLanguage == SR.CONST_SYS_LANG_CN)
                {
                    menu2.Text = titles[0];
                }
                else if (titles.Length > 1)
                {
                    menu2.Text = titles[1];
                }
                else
                {
                    menu2.Text = titles[0];
                }
                //menu2.Text = subMenu.Title;
                if (!string.IsNullOrEmpty(subMenu.Url))
                    menu2.Href = Page.ResolveUrl(subMenu.Url.Trim());

                menu2.Icon = Coolite.Ext.Web.Icon.NoteGo;

                menu2.Href = string.Format("javascript:ItemClick('{0}','{1}','{2}')", menu2.ID, menu2.Text, menu2.Href);
                //menu2.Handler = "onItemClick";

                menu.Items.Add(menu2);
            }
            //}
        }
        toolButton.Menu.Add(menu);

    }
    private void IsConvertWeChateUser()
    {
        short needchangewechatuser = 0;
        LoginUser obj = RoleModelContext.Current.User;
        //仅仅检验经销商用户，不包含（HQ），以及临时经销商
        if (obj.IdentityType == SR.Consts_System_Dealer_User
            && obj.CorpType != DealerType.HQ.ToString()
            && obj.LoginId.Length < 10)
        {
            //不包含经销商支持账号99
            //检查是否维护过该经销商微信信息
            if (_context.UserName.Contains("_") && _context.UserName.Split('_')[1].ToString() != "99")
            {
                //非99结尾的账号都要校验微信维护
                IWeChatBaseBLL _WhatBase = new WeChatBaseBLL();

                Hashtable ht = new Hashtable();
                ht.Add("DealerId", obj.CorpId.Value);
                DataSet ds = _WhatBase.GetUser(ht);
                if (ds.Tables[0].Rows.Count <= 0)
                {
                    needchangewechatuser = 1;
                }
            }
        }



        if (needchangewechatuser > 0)
        {

            Ext.Msg.Show(new MessageBox.Config
            {
                Buttons = MessageBox.Button.OK,
                Icon = MessageBox.Icon.INFO,
                Title = "通告",
                Message = "<span style=\"color:Red;\">您没有维护微信用户信息，无法绑定蓝威服务入微微信平台，请尽快维护。服务入微功能简述：采购达成查询、渠道二维码上报、授权书二维码查询等</span>",
                Closable = false,
                Handler = "Coolite.AjaxMethods.DoYes({failure: function(err) {Ext.Msg.alert('Failure', err);}})"
            });
        }
    }
    [AjaxMethod]
    public void DoYes()
    {

        string changeUrl = string.Format("~/Pages/WeChat/WeChatUserList.aspx?pt={0}", "1");
        this.Response.Redirect(changeUrl);
    }
    [AjaxMethod]
    public string GetThemeUrl(string theme)
    {
        Theme temp = (Theme)Enum.Parse(typeof(Theme), theme);

        this.Session["Coolite.Theme"] = temp;

        return (temp == Coolite.Ext.Web.Theme.Default) ? "Default" : this.ScriptManager1.GetThemeUrl(temp);
    }

    //记录日志
    [AjaxMethod]
    public string WriteUserAccessLog(string url, string itmeId, string title)
    {
        DealerOperationLogDLL.instance.writeLog(title, itmeId);
        return "Success";

    }

}
