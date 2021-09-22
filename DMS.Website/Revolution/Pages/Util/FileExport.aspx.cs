using DMS.BusinessService;
using Spring.Context;
using Spring.Context.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Revolution.Pages.Util
{
    public partial class FileExport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                String Business = Request.QueryString["Business"];
                String DownloadCookie = Request.QueryString["DownloadCookie"];

                if (string.IsNullOrEmpty( Business) || string.IsNullOrEmpty(DownloadCookie))
                {
                    throw new Exception("Empty of Business/Cookie");
                }
                else
                {
                    IApplicationContext iac = ContextRegistry.GetContext();
                    IQueryExport export = iac.GetObject(Business.Trim() + "_Service") as IQueryExport;

                    export.Export(Request.QueryString, DownloadCookie.Trim());
                }
            }
        }
    }
}