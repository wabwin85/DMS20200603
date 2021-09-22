using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.Order
{

    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    using System.Text;

    public partial class PromotionPolicyT2 : BasePage
    {

        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = null;
        [Dependency]
        public IPurchaseOrderBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(ProductLineStore);
                this.Bind_DealerListByFilter(DealerStore, true);

                if (IsDealer)
                {
                    this.GridPanel1.ColumnModel.SetEditable(10, false);
                    this.GridPanel1.ColumnModel.SetEditable(11, false);


                    if (RoleModelContext.Current.User.CorpType != DealerType.HQ.ToString() && RoleModelContext.Current.User.CorpType != DealerType.LP.ToString() && RoleModelContext.Current.User.CorpType != DealerType.LS.ToString())
                    {
                        this.cmbDealers.Disabled = true;
                        this.hiddenInitDealerId.Text = RoleModelContext.Current.User.CorpId.Value.ToString();
                        this.cmbDealers.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        this.cmbApprovalStatus.Disabled = true;
                        this.cmbApprovalStatus.SelectedItem.Value = "Approved";
                    }




                }
                else
                {
                    //this.GridPanel1.ColumnModel.SetEditable(10, true);
                    //this.GridPanel1.ColumnModel.SetEditable(11, true);
                    this.GridPanel1.ColumnModel.SetEditable(10, false);
                    this.GridPanel1.ColumnModel.SetEditable(11, false);
                }

            }


        }
        public void ResultStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.txtPromotionCode.Text))
            {
                param.Add("Code", txtPromotionCode.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtPromotionName.Text))
            {
                param.Add("PRName", txtPromotionName.Text.Trim());
            }
            if (this.dtPromotionEndate.SelectedDate != DateTime.MinValue)
            {
                param.Add("EndDate", this.dtPromotionEndate.SelectedDate);
            }
            if (this.dfBeginDate.SelectedDate != DateTime.MinValue)
            {
                param.Add("BeginDate", this.dfBeginDate.SelectedDate);
            }
            if (!string.IsNullOrEmpty(this.cmbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineId", this.cmbProductLine.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.cmbApprovalStatus.SelectedItem.Value))
            {
                param.Add("IsApproved", this.cmbApprovalStatus.SelectedItem.Value);
            }

            if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
            {
                param.Add("ParentDealerId", RoleModelContext.Current.User.CorpId.Value.ToString());
            }

            if (!string.IsNullOrEmpty(this.cmbDealers.SelectedItem.Value))
            {
                param.Add("Dmaid", this.cmbDealers.SelectedItem.Value);
            }
            //this.GridPanel1.ColumnModel.SetEditable(11, true);
            DataSet ds = null;

            if (RoleModelContext.Current.User.CorpType == DealerType.HQ.ToString() || !IsDealer)
            {
                ds = business.QueryPromotionPolicyT2(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PageToolBar2.PageSize : e.Limit), out totalCount);
            }
            else
            {
                ds = business.QueryPromotionPolicyForT2(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PageToolBar2.PageSize : e.Limit), out totalCount);

            }
            e.TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();




        }


        /// <summary>
        /// Download the promotion policy info of T1 and LP
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DownloadInfo(object sender, EventArgs e)
        {
            DataTable dt = GetPolicyInfo().Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=促销政策列表.xls");
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
            sb.Append("<x:Name>促销政策列表</x:Name>");
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

        private DataSet GetPolicyInfo()
        {

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.txtPromotionCode.Text))
            {
                param.Add("Code", txtPromotionCode.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtPromotionName.Text))
            {
                param.Add("PRName", txtPromotionName.Text.Trim());
            }
            if (this.dtPromotionEndate.SelectedDate != DateTime.MinValue)
            {
                param.Add("EndDate", this.dtPromotionEndate.SelectedDate);
            }
            if (this.dfBeginDate.SelectedDate != DateTime.MinValue)
            {
                param.Add("BeginDate", this.dfBeginDate.SelectedDate);
            }
            if (!string.IsNullOrEmpty(this.cmbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineId", this.cmbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cmbDealers.SelectedItem.Value))
            {
                param.Add("Dmaid", this.cmbDealers.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cmbApprovalStatus.SelectedItem.Value))
            {
                param.Add("IsApproved", this.cmbApprovalStatus.SelectedItem.Value);
            }

            DataSet ds = null;
            if (RoleModelContext.Current.User.CorpType == DealerType.HQ.ToString() || !IsDealer)
            {
                ds = business.ExportPromotionPolicyT2(param);

            }
            else
            {
                ds = business.ExportPromotionPolicyForT2(param);
            }

            return ds;
        }

        /// <summary>
        /// Alter Qty
        /// </summary>
        /// <param name="qty"></param>
        /// <param name="remark"></param>
        [AjaxMethod]
        public void SaveItem(string qty, string remark)
        {


            Ext.Msg.Confirm("", "确定要调整当前可用数量", new MessageBox.ButtonsConfig
            {
                Yes = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.DoYes('" + qty + "','" + remark + "')",
                    Text = "Yes"
                },
                No = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.DoNo()",
                    Text = "No"
                }
            }).Show();



            //if (result)
            //{
            //    this.ResultStore.DataBind();
            //}
            //else
            //{
            //    Ext.Msg.Alert("Error", "error").Show();
            //}
        }

        [AjaxMethod]
        public void DoYes(string qty, string remark)
        {
            decimal adjustqty = string.IsNullOrEmpty(qty) ? 0 : Convert.ToDecimal(qty);

            business.SaveItemForT2(adjustqty, remark, this.hiddenCurrentEditId.Text.ToString());
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        public void DoNo()
        {
            this.ResultStore.DataBind();
        }

    }
}

