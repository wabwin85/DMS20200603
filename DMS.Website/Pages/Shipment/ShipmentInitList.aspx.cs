using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Shipment
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ShipmentInitList")]
    public partial class ShipmentInitList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IShipmentBLL business = new ShipmentBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_Dictionary(this.ShipmentStatusStore, "ShipmentInitStatus");

                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        this.cbDealer.Disabled = true;
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                }
            }
        }
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            else
            {
                param.Add("DmaId", "");
            }
            if (!string.IsNullOrEmpty(this.cbShipmentInitStatus.SelectedItem.Value))
            {
                param.Add("ShipmentStatus", this.cbShipmentInitStatus.SelectedItem.Value);
            }
            else
            {
                param.Add("ShipmentStatus", "");
            }
            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            else
            {
                param.Add("SubmitDateStart", "19900101");
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            else
            {
                param.Add("SubmitDateEnd", "20991231");
            }
            if (!string.IsNullOrEmpty(this.txtShipmentInitNo.Text))
            {
                param.Add("ShipmentInitNo", this.txtShipmentInitNo.Text);
            }
            else
            {
                param.Add("ShipmentInitNo", "");
            }
            //只能查询自己下的订单
            //BSC用户可以看所有订单，经销商用户只能看自己创建的订单
            if (IsDealer)
            {
                param.Add("UserType", "Dealer");
                param.Add("CreateUser", new Guid(_context.User.CorpId.Value.ToString()));
            }
            else
            {
                param.Add("UserType", "User");
                param.Add("CreateUser", new Guid(_context.User.CorpId.Value.ToString()));
            }


            param.Add("start", (e.Start == -1 ? 0 : e.Start / this.PagingToolBar1.PageSize));
            param.Add("limit", this.PagingToolBar1.PageSize);
            DataSet query = business.QueryShipmentInitList(param);
            DataTable dtCount = query.Tables[0];
            DataTable dtValue = query.Tables[1];
            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());
            this.ResultStore.DataSource = dtValue;
            this.ResultStore.DataBind();
        }

        #region 明细页面
        [AjaxMethod]
        public void Show(string initNo, string initStatus)
        {
            this.hiddenInitNo.Text = initNo;
            this.hiddenStatus.Text = initStatus;
            this.DetailWindow.Show();
        }
        protected void InitMassageStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = new DataSet();
            Hashtable param = new Hashtable();
            param.Add("No", this.hiddenInitNo.Text);

            if (this.hiddenStatus.Text == ShipmentInitStatus.Submitted.ToString())
            {
                ds = business.QueryShipmentInitProcessing(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }
            else
            {
                ds = business.QueryShipmentInitResult(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            }

            e.TotalCount = totalCount;

            this.InitMassageStore.DataSource = ds;
            this.InitMassageStore.DataBind();
            DisplayInitSumString(hiddenInitNo.Text, this.hiddenStatus.Text, ds.Tables[0]);
        }

        public void DisplayInitSumString(string initNo, string initStatus, DataTable dt)
        {
            this.lblResult.Text = "错误记录：0条";
            this.lblInvSum.Text = "正确记录：0条";
            this.lblProcessing.Text = "处理中记录：0条";
            this.lbTotal.Text = "销售总金额:0";
            this.lbQuantity.Text = "销售总数量:0";
            Hashtable obj = new Hashtable();
            obj.Add("No", initNo);
            obj.Add("Status", initStatus);

            DataTable tb = business.GetShipmentInitSum(obj).Tables[0];

            if (tb.Rows.Count > 0)
            {
                this.lblProcessing.Text = "处理中记录：" + tb.Rows[0]["ProcessingQuantity"].ToString() + "条";
                this.lblResult.Text = "错误记录：" + tb.Rows[0]["FailQuantity"].ToString() + "条";
                this.lblInvSum.Text = "正确记录：" + tb.Rows[0]["SuccessQuantity"].ToString() + "条";
                this.lbTotal.Text = "销售总金额：" + tb.Rows[0]["SumAmount"].ToString();
                this.lbQuantity.Text = "销售总数量：" + tb.Rows[0]["SumQuantity"].ToString();
            }
        }

        [AjaxMethod]
        protected void ExportDetail(object sender, EventArgs e)
        {
            Hashtable param = new Hashtable();
            //if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            //{
            //    param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            //}
            //if (!string.IsNullOrEmpty(this.cbShipmentInitStatus.SelectedItem.Value))
            //{
            //    param.Add("ShipmentStatus", this.cbShipmentInitStatus.SelectedItem.Value);
            //}
            //if (!this.txtSubmitDateStart.IsNull)
            //{
            //    param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            //}
            //if (!this.txtSubmitDateEnd.IsNull)
            //{
            //    param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            //}
            //if (!string.IsNullOrEmpty(this.txtShipmentInitNo.Text))
            //{
            //    param.Add("No", this.txtShipmentInitNo.Text);
            //}
            param.Add("No", this.hiddenInitNo.Text);
            param.Add("IsErr", "1");

            DataTable dt = business.ExportShipmentInitResult(param).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=ShipmentError.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
        #endregion
    }
}