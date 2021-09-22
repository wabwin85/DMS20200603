using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Reflection;
using Spring.Context;
using Spring.Context.Support;
using DMS.Common.Extention;
using DMS.ViewModel.Util.DataImport;
using DMS.BusinessService.Util.DataImport;

namespace DMS.Website.Revolution.Pages.Util.DataImport
{
    public partial class DataImportTemplate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataImportTemplateVO model = new DataImportTemplateVO();

                String Business = Request.QueryString["Business"].ToSafeString();
                String DownloadCookie = Request.QueryString["DownloadCookie"].ToSafeString();

                if (Business.IsNullOrEmpty() || DownloadCookie.IsNullOrEmpty())
                {
                    throw new Exception("Empty of Service/Cookie");
                }
                else
                {
                    model.Parameters = Request.QueryString;
                    model.DownloadCookie = DownloadCookie;

                    IApplicationContext iac = ContextRegistry.GetContext();
                    IDataImportFac check = iac.GetObject(Business + "_Service") as IDataImportFac;

                    check.CreateDataImport().DownloadTemplate(model);
                }
            }
        }
    }
}