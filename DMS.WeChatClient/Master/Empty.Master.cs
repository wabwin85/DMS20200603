using System;

namespace DMS.WeChatClient.Master
{
    public partial class Empty : MasterBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                InitPage();
            }
        }

        public void InitPage()
        {
            this.hdfOpenID.Value = this.form1.Attributes["data-openid"];
            this.hidKey.Value = Common.Config.Key;
            this.hidIV.Value = Common.Config.Iv;
            this.hidApiUrl.Value = Common.Config.ApiUrl;
        }
    }
}