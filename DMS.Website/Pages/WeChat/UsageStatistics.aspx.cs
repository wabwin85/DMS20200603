using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DMS.Common;
using System.Xml.Xsl;
using System.Xml;

namespace DMS.Website.Pages.WeChat
{
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using DMS.Business;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    using DMS.Common;
    using DMS.Model.Data;
    using DMS.Business.Cache;
    using Microsoft.Practices.Unity;
    using System.Text;
    using System.Collections;

    public partial class UsageStatistics : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private WeChatBaseBLL _business = null;
        [Dependency]
        public WeChatBaseBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {

            }
            if (IsDealer)
            {
                this.btnDownloadWechatInfo.Hide();
                this.btnDownloadWechatRegister.Hide();
            }
            else
            {
                this.btnDownloadWechatInfo.Show();
                this.btnDownloadWechatRegister.Show();
            }

        }

        #region 微信使用情况

        protected void DownloadInfo(object sender, EventArgs e)
        {
            DataTable dt = GetUsageInfo().Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=微信使用情况.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        public string AddExcelHead()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:x=\"urn:schemas-microsoft-com:office:excel\">");
            //sb.Append("<?xmlversion='1.0' encoding='utf-8'?>");
            sb.Append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            sb.Append(" <head>");
            sb.Append(" <!--[if gte mso 9]><xml>");
            sb.Append("<x:ExcelWorkbook>");
            sb.Append("<x:ExcelWorksheets>");
            sb.Append("<x:ExcelWorksheet>");
            sb.Append("<x:Name>微信使用情况</x:Name>");
            sb.Append("<x:WorksheetOptions>");
            sb.Append("<x:Print>");
            sb.Append("<x:ValidPrinterInfo />");
            sb.Append(" </x:Print>");
            sb.Append("</x:WorksheetOptions>");
            sb.Append("</x:ExcelWorksheet>");
            sb.Append("</x:ExcelWorksheets>");
            sb.Append("</x:ExcelWorkbook>");
            sb.Append("</xml>");
            sb.Append("<![endif]-->");
            sb.Append(" </head>");
            sb.Append("<body>");
            return sb.ToString();

        }

        private DataSet GetUsageInfo()
        {
            Hashtable param = new Hashtable();

            if (!startDate.IsNull)
            {
                param.Add("startDate", this.startDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!endDate.IsNull)
            {
                param.Add("endDate", this.endDate.SelectedDate.ToString("yyyyMMdd"));
            }
            DataSet ds = business.ExportUsageInfo(param);

            return ds;
        }

        #endregion

        #region 微信注册情况

        protected void DownloadRegister(object sender, EventArgs e)
        {
            DataTable dt = GetRegisterInfo().Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=微信注册情况.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(AddRegisterExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        public string AddRegisterExcelHead()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:x=\"urn:schemas-microsoft-com:office:excel\">");
            //sb.Append("<?xmlversion='1.0' encoding='utf-8'?>");
            sb.Append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            sb.Append(" <head>");
            sb.Append(" <!--[if gte mso 9]><xml>");
            sb.Append("<x:ExcelWorkbook>");
            sb.Append("<x:ExcelWorksheets>");
            sb.Append("<x:ExcelWorksheet>");
            sb.Append("<x:Name>微信注册情况</x:Name>");
            sb.Append("<x:WorksheetOptions>");
            sb.Append("<x:Print>");
            sb.Append("<x:ValidPrinterInfo />");
            sb.Append(" </x:Print>");
            sb.Append("</x:WorksheetOptions>");
            sb.Append("</x:ExcelWorksheet>");
            sb.Append("</x:ExcelWorksheets>");
            sb.Append("</x:ExcelWorkbook>");
            sb.Append("</xml>");
            sb.Append("<![endif]-->");
            sb.Append(" </head>");
            sb.Append("<body>");
            return sb.ToString();

        }

        private DataSet GetRegisterInfo()
        {
            DataSet ds = business.ExportRegisterInfo();

            return ds;
        }

        #endregion

        public void ResultStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {

        }
    }
}
