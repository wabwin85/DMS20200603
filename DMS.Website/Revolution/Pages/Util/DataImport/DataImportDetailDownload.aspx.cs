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
using DMS.ViewModel.Util.DataImport;
using DMS.Common.Extention;
using DMS.BusinessService.Util.DataImport;

namespace DMS.Website.Revolution.Pages.Util.DataImport
{
    public partial class DataImportDetailDownload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataImportDetailDownloadVO model = new DataImportDetailDownloadVO();

                String Business = Request.QueryString["Business"].ToSafeString();
                String DownloadCookie = Request.QueryString["DownloadCookie"].ToSafeString();
                String InstanceId = Request.QueryString["InstanceId"].ToSafeString();

                if (Business.IsNullOrEmpty() || DownloadCookie.IsNullOrEmpty())
                {
                    throw new Exception("Empty of Business/Cookie/InstanceId");
                }
                else
                {
                    model.InstanceId = InstanceId;
                    model.DownloadCookie = DownloadCookie;

                    IApplicationContext iac = ContextRegistry.GetContext();
                    IDataImportFac check = iac.GetObject(Business + "_Service") as IDataImportFac;

                    check.CreateDataImport().DownloadDetail(model);
                }
            }
        }
    }
}