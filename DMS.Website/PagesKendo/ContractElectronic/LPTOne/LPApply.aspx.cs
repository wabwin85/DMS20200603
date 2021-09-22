using Coolite.Ext.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.ContractKendo
{
    public partial class LPApply : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string GetContractType()
        {
            List<Data> list = new List<Data>();
            list.Add(new Data() { ProjectID = "1", ProjectName = "经销商协议_LP", Discontinued = false });
            list.Add(new Data() { ProjectID = "2", ProjectName = "经销商协议_LP_附件一", Discontinued = false });
            list.Add(new Data() { ProjectID = "3", ProjectName = "经销商协议_LP_附件二", Discontinued = false });
            list.Add(new Data() { ProjectID = "4", ProjectName = "经销商协议_LP_附件三", Discontinued = false });
            list.Add(new Data() { ProjectID = "5", ProjectName = "设备采购附件", Discontinued = false });
            list.Add(new Data() { ProjectID = "6", ProjectName = "医疗器械质量保证协议-LP", Discontinued = false });
            list.Add(new Data() { ProjectID = "7", ProjectName = "数据质量保证函", Discontinued = true });

            return JSON.Serialize(list);
        }
    }
    public class Data
    {
        public string ProjectID { get; set; }
        public string ProjectName { get; set; }
        public bool Discontinued { get; set; }
    }
}