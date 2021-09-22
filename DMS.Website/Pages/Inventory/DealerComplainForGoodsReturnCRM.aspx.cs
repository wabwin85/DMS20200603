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

namespace DMS.Website.Pages.Inventory
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerComplainForGoodsReturnCRM")]
    public partial class DealerComplainForGoodsReturnCRM : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerComplainBLL _business = new DealerComplainBLL();
        private IPurchaseOrderBLL _orderLogbusiness = new PurchaseOrderBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            this.hidCorpType.Text = "";
            this.Bind_DealerList(this.DealerStore);
            this.Bind_Status(this.AdjustStatusStore);

            if (IsDealer)
            {
                if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) 
                    || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) 
                    || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                {
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Disabled = true;
                    this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                }
                else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
                {
                    this.Bind_DealerListByFilter(this.DealerStore, false);
                    //this.GridPanel1.ColumnModel.SetHidden(11, false);
                    //this.GridPanel1.ColumnModel.SetHidden(12, false);
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                }

                this.hidCorpType.Text = RoleModelContext.Current.User.CorpType;
                this.btnInsertCRM.Show();
            }
            else
            {
                this.Bind_DealerList(this.DealerStore);
                if (_context.IsInRole("ApplyComplain"))
                {
                    this.btnInsertCRM.Show();
                }
                else
                {
                    this.btnInsertCRM.Hide();
                    this.GridPanel1.ColumnModel.SetHidden(11, true);
                    this.GridPanel1.ColumnModel.SetHidden(12, true);
                }
                

            }

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //控制查询按钮
                //Permissions pers = this._context.User.GetPermissions();
                //this.btnSearch.Visible = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderApply, PermissionType.Read);
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.cbAdjustStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbAdjustStatus.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtComplainNumber.Text))
            {
                param.Add("ComplainNumber", this.txtComplainNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtDN.Text))
            {
                param.Add("DN", this.txtDN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }

            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("ApplyDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("ApplyDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!String.IsNullOrEmpty(this.txtApplyUser.Text))
            {
                param.Add("ApplyUser", this.txtApplyUser.Text);
            }
            //param.Add("CorpId", RoleModelContext.Current.User.CorpId.Value);
            param.Add("ComplainType", "CRM");

            DataSet ds = _business.DealerComplainQuery(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        protected void ShowBSCEdit(object sender, AjaxEventArgs e)
        {
            Guid id = new Guid(e.ExtraParams["DC_ID"].ToString());

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
            }
            //显示窗口
            //this.DealerComplainBSCEdit.Show(Guid.Empty);
        }

        [AjaxMethod]
        protected void ShowCRMEdit(object sender, AjaxEventArgs e)
        {
            Guid id = new Guid(e.ExtraParams["DC_ID"].ToString());

            //若id为空，说明为新增，则生成新的id，并新增一条记录
            if (id == Guid.Empty)
            {
                id = Guid.NewGuid();
            }
            //显示窗口
            //this.DealerComplainCRMEdit.Show(Guid.Empty, "New");
        }

        [AjaxMethod]
        public void Show(string DC_ID, String type)
        {
            Guid id = new Guid(DC_ID);
            //this.DealerComplainCRMEdit.Show(id, type);           
        }

        protected void Bind_Status(Store store1)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.CONST_QAComplainReturn_Status);

            store1.DataSource = dicts;
            store1.DataBind();

        }

        [AjaxMethod]
        public void UpdateDealerComplain(string DC_ID)
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", DC_ID);
            param.Add("DC_Status", "SendRefund");
            _business.UpdateDealerComplainStatusCRM(param);
            _orderLogbusiness.InsertPurchaseOrderLog(new Guid(DC_ID), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Confirm, "平台确认已换货给T2或寄送退款协议给T2");
        }
        [AjaxMethod]
        public void ExpressEditShow(string DC_ID)
        {
            this.hidDcId.Value = DC_ID;
            //修改快递单号和快递公司
            this.ExpressEditWindows.Show();
        }
        [AjaxMethod]
        public void ExpressSave()
        {
            //保存快递单号和快递公司
            Hashtable param = new Hashtable();
            param.Add("DcId", this.hidDcId.Value);
            param.Add("CarrierNumber", this.tfCourierNumber.Text);
            param.Add("CourierCompany", this.tfCourierCompany.Text);
            param.Add("ComplainType", "CRM");
            _business.UpdateDealerComplainCourier(param);

            _orderLogbusiness.InsertPurchaseOrderLog(new Guid(this.hidDcId.Value.ToString()), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Confirm, "快递单号被修改");
        }

        [AjaxMethod]
        public void IANEditShow(string DC_ID)
        {
            this.hidWinDcId.Value = DC_ID;
            //修改全球投诉单号
            if (DC_ID != "")
            {
                DataTable dt = _business.GetDealerComplainBscInfo(new Guid(DC_ID));
                if (dt.Rows.Count > 0)
                {   
                    if (dt.Rows[0]["PI"] != null)
                        this.txtWinComplaintID.Text = dt.Rows[0]["PI"].ToString();
                    if (dt.Rows[0]["IAN"] != null)
                        this.txtWinIAN.Text = dt.Rows[0]["IAN"].ToString();
                }
            }
            this.IANEditWindow.Show();
        }
        [AjaxMethod]
        public void IANSave()
        {
            //保存全球单号
            Hashtable param = new Hashtable();
            param.Add("DcId", this.hidWinDcId.Value);
            param.Add("PI", this.txtWinComplaintID.Text);
            param.Add("IAN", this.txtWinIAN.Text);
            param.Add("ComplainType", "CRM");
            _business.UpdateDealerComplainIAN(param);

            _orderLogbusiness.InsertPurchaseOrderLog(new Guid(this.hidWinDcId.Value.ToString()), new Guid(RoleModelContext.Current.User.Id), PurchaseOrderOperationType.Confirm, "全球投诉单号被修改");
        }

        /// <summary>
        /// 导出信息
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ExportExcel(object sender, EventArgs e)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerId", this.cbDealer.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.cbAdjustStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbAdjustStatus.SelectedItem.Value);
            }

            if (!string.IsNullOrEmpty(this.txtComplainNumber.Text))
            {
                param.Add("ComplainNumber", this.txtComplainNumber.Text);
            }
            if (!string.IsNullOrEmpty(this.txtDN.Text))
            {
                param.Add("DN", this.txtDN.Text);
            }

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                param.Add("Upn", this.txtUPN.Text);
            }
            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                param.Add("LotNumber", this.txtLotNumber.Text);
            }

            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("ApplyDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("ApplyDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!String.IsNullOrEmpty(this.txtApplyUser.Text))
            {
                param.Add("ApplyUser", this.txtApplyUser.Text);
            }
            //param.Add("CorpId", RoleModelContext.Current.User.CorpId.Value);
            param.Add("ComplainType", "CRM");
            DataTable dt = _business.DealerComplainExport(param);

            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
    }
}
