using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business;
using DMS.Model.Data;
using System.Data;
using DMS.Common;
using DMS.Model;
using DMS.Business.Cache;
using System.Collections;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ConsignmentMasterWindow")]
    public partial class ConsignmentMasterWindow : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IConsignmentMasterBLL consignment = new ConsignmentMasterBLL();
        private IConsignmentDealerBLL Dell = new ConsignmentDealerBLL();
        #endregion
        public const string DMA_ID = "FB62D945-C9D7-4B0F-8D26-4672D2C728B7";

        #region 公开属性
        public bool IsPageNew
        {
            get
            {
                return (this.hidIsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsPageNew.Text = value.ToString();
            }
        }

        public bool IsModified
        {
            get
            {
                return (this.hidIsModified.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsModified.Text = value.ToString();
            }
        }

        public bool IsSaved
        {
            get
            {
                return (this.hidIsSaved.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsSaved.Text = value.ToString();
            }
        }

        public Guid InstanceId
        {
            get
            {
                return new Guid(this.hidInstanceId.Text);
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }


        public ConsignmentType PageStatus
        {
            get
            {
                return (ConsignmentType)Enum.Parse(typeof(ConsignmentType), this.hidOrderStatus.Text, true);
            }
            set
            {
                this.hidOrderStatus.Text = value.ToString();
            }
        }

        public DateTime LatestAuditDate
        {
            get
            {
                return string.IsNullOrEmpty(this.hidLatestAuditDate.Text) ? DateTime.MaxValue : DateTime.Parse(this.hidLatestAuditDate.Text);
            }
        }
        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                PageStatus = ConsignmentType.Draft;
                RefreshOrderTypeStore();
                
            }
            //this.RefreshOrderTypeStore(this.OrderTypeStore, SR.Const_Consignment_Rule);
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = consignment.GetConsignmentCfnById(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

        }

        public void ConsignmenDealerStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = consignment.SelectConsignmentMasterByealer(InstanceId.ToString(), (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.ConsignmenDealerStore.DataSource = ds;
            this.ConsignmenDealerStore.DataBind();
        }

        protected void OrderTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshOrderTypeStore();
        }

        public void RefreshOrderTypeStore()
        {
           
            
            this.Bind_Dictionary(this.OrderTypeStorewin, SR.Const_Consignment_Rule);
            //IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Const_Consignment_Rule);
            ////如果单据状态是草稿状态,则只显示普通订单、寄售订单
            //if (this.PageStatus.ToString().Equals(ConsignmentMasterType.Draft.ToString()))
            //{
            //    this.OrderTypeStore.DataSource = (from t in dicts
            //                                      where (t.Key == NearEffectiveRule.ThreeMonth.ToString() ||
            //                                             t.Key == NearEffectiveRule.SixMonth.ToString() ||
            //                                             t.Key == NearEffectiveRule.UnEffective.ToString() )
            //                                      select t);

            //}
            //else
            //{
            //    this.OrderTypeStore.DataSource = (from t in dicts select t);
            //}
            //this.OrderTypeStore.DataBind();

        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _business.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        #endregion

        #region Ajax Method
        [AjaxMethod]
        public void Show(string id)
        {
            this.IsPageNew = (id == Guid.Empty.ToString());
            this.IsModified = false;
            this.IsSaved = false;
            this.InstanceId = (id == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(id));
            this.InitDetailWindow();
            this.DetailWindow.Show();
        }

        [AjaxMethod]
        public void SaveDraft()
        {
            ConsignmentMaster header = this.GetFormValue();
            bool result = consignment.SaveDraft(header);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void DeleteDraft()
        {
            bool result = consignment.DeleteDraft(this.InstanceId);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void DeletePlineItem(string id)
        {
            bool result = Dell.DelletePling(new Guid(id));
        }
        [AjaxMethod]
        public void CheckedSubmit()
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string RtnRegMsg = string.Empty;
            bool result = consignment.CheckedSubmit(InstanceId, cbProductLine.SelectedItem.Value,txtConsignmentName.Text.Trim(), out rtnVal, out rtnMsg, out RtnRegMsg);
           this.hidRtnVal.Text = rtnVal;
           this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>");
        }
        [AjaxMethod]
        public void Submit()
        {
            ConsignmentMaster header = this.GetFormValue();
            bool result = consignment.Submit(header, DMA_ID);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void ChangeProductLine()
        {
            //更换产品组，删除订单原产品组下的所有产品
            bool result = consignment.DeleteCfns(this.InstanceId);
            //删除原有销售
            DeleteConsignmentDealer();
        }

        [AjaxMethod]
        public void DeleteItem(string id)
        {
         bool result = Dell.DeleteDealer(new Guid(id));
        }

        [AjaxMethod]
        public void UpdateItem(string qty)
        {
            Guid detailId = new Guid(this.hidEditItemId.Text);
            ConsignmentCfn detail = consignment.GetConsignmentCfnById(detailId);

            if (!string.IsNullOrEmpty(qty))
            {
                detail.Qty = Convert.ToDecimal(qty);
                detail.Amount = detail.Qty * detail.Price;
            }

            bool result = consignment.UpdateCfn(detail);
        }



        [AjaxMethod]
        public void InitBtnCfnAdd()
        {
            SetAddCfnSetBtnHidden();
            
        }

        public void SetAddCfnSetBtnHidden()
        {

            try
            {
                if (this.PageStatus == ConsignmentType.Draft)
                {

                    
                    Renderer r = new Renderer();
                   
                    this.gpDetail.ColumnModel.SetRenderer(4, r);
                    this.gpDetail.ColumnModel.SetEditable(4, true);
                    
                    this.gpDetail.ColumnModel.SetHidden(9, false);
                    
                    this.DealerPanel.ColumnModel.SetHidden(4, false);

                }
                else
                {
                    
                    Renderer r = new Renderer();
                   
                    this.gpDetail.ColumnModel.SetRenderer(4, r);

                    if (this.PageStatus == ConsignmentType.Submit)
                    {
                        this.gpDetail.ColumnModel.SetEditable(4, true);
                        this.gpDetail.ColumnModel.SetHidden(9, false);
                        this.DealerPanel.ColumnModel.SetHidden(4, false);
                    }

                    if (this.PageStatus == ConsignmentType.Cancel)
                    {
                        this.gpDetail.ColumnModel.SetEditable(4, false);
                        this.gpDetail.ColumnModel.SetHidden(9, true);
                        this.DealerPanel.ColumnModel.SetHidden(4, true);
                    }
                    

                }
                
            }
            catch (Exception ex)
            {


            }
            finally
            {

            }
        }

        [AjaxMethod]
        public void Revoke()
        {
            bool result = consignment.RevokeOrder(this.InstanceId);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("Revoke.Alert.Title").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Revoke.Alert.ErrorBody").ToString()).Show();
            }
        }
       
        #endregion

        #region 页面私有方法
        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            //产品线
            this.cbProductLine.Disabled = false;
            this.cbOrderType.Disabled = false;
            //表头
            this.txtOrderNo.ReadOnly = true;
            this.txtSubmitDate.ReadOnly = true;
            this.txtOrderStatus.ReadOnly = true;

            //汇总信息
            this.txtRemark.ReadOnly = false;

            //切换到第一个面板
            this.TabPanel1.ActiveTabIndex = 0;

            //所有按钮都有效
            ////--this.btnAddCfn.Disabled = false;
            this.Toolbar1.Disabled = false;
            this.Toolbar2.Disabled = false;
            //this.btnAddCfnSet.Disabled = false;          
            //this.btnAvaiableProduct.Disabled = false;
            this.btnSaveDraft.Disabled = false;
            this.btnDeleteDraft.Disabled = false;
            this.btnSubmit.Disabled = false;
            this.btnRevoke.Disabled = false;
            this.btnSaveDraft.Disabled = false;
            this.btnSaveDraft.Show();
            this.btnDeleteDraft.Show();
            this.btnSubmit.Show();
            this.btnRevoke.Show();
            //所有面板都可见
            this.TabDetail.Disabled = false;
            this.TabLog.Disabled = false;
            this.dtStartDate.Disabled = false;
            this.dtEndDate.Disabled = false;
            this.txtDelayTime.ReadOnly = false;
            this.gpDetail.ColumnModel.SetEditable(4, false);//不可修改金额
            this.gpDetail.ColumnModel.SetEditable(5, false);//不可修改金额
            this.gpDetail.ColumnModel.SetHidden(9, true);
            this.DealerPanel.ColumnModel.SetHidden(4, true);
            txtConsignmentName.ReadOnly = false;
            txtConsignmentDay.ReadOnly = false;
            cbConsignmentDay.SelectedItem.Value = string.Empty;
            txtRemark.ReadOnly = false;
            txtConsignmentDay.Text = string.Empty;
            btnRevoke.Show();
        }

        /// <summary>
        /// 设置页面控件状态
        /// </summary>
        private void SetDetailWindow(ConsignmentMaster header)
        {
            //如果单据状态是“草稿”，则可以修改
            if (this.PageStatus == ConsignmentType.Draft)
            {
                this.btnRevoke.Hide();

                this.txtDelayTime.ReadOnly = false;
                this.gpDetail.ColumnModel.SetEditable(4, true);
                this.DealerPanel.ColumnModel.SetHidden(4, false);
                this.gpDetail.ColumnModel.SetHidden(9, false);
                this.dtStartDate.Disabled = false;
                this.dtEndDate.Disabled = false;
                txtConsignmentName.ReadOnly = false;
                txtConsignmentDay.ReadOnly = false;
                txtRemark.ReadOnly = false;
                cbConsignmentDay.Disabled = false;
            }
            else if (this.PageStatus == ConsignmentType.Submit)
            {

                this.txtDelayTime.ReadOnly = true;
                this.gpDetail.ColumnModel.SetHidden(9, false);
                this.gpDetail.ColumnModel.SetEditable(4, true);
                this.DealerPanel.ColumnModel.SetHidden(4, false);
                this.cbProductLine.Disabled = true;
                this.cbOrderType.Disabled = true;
                //this.cbTerritory.Disabled = true;

                this.txtRemark.ReadOnly = true;
                
                //this.Toolbar1.Disabled = true;
               // this.Toolbar2.Disabled = true;
                this.btnSaveDraft.Hide();
                this.btnDeleteDraft.Hide();
                this.btnSubmit.Hide();
                this.dtStartDate.Disabled = true;
                this.dtEndDate.Disabled = true;
                txtConsignmentName.ReadOnly = true;
                txtConsignmentDay.ReadOnly = true;
                txtRemark.ReadOnly = true;
                cbConsignmentDay.Disabled = true;
            }
            else if (this.PageStatus == ConsignmentType.Cancel)
            {
                this.txtDelayTime.ReadOnly = true;

                this.gpDetail.ColumnModel.SetEditable(4, false);
                this.DealerPanel.ColumnModel.SetHidden(4, true);
                this.cbProductLine.Disabled = true;
                this.cbOrderType.Disabled = true;
                //this.cbTerritory.Disabled = true;
                this.gpDetail.ColumnModel.SetHidden(9, true);
                this.txtRemark.ReadOnly = true;

                this.Toolbar1.Disabled = true;

                this.btnSaveDraft.Hide();
                this.btnDeleteDraft.Hide();
                this.btnSubmit.Hide();
                this.dtStartDate.Disabled = true;
                this.dtEndDate.Disabled = true;
                txtConsignmentName.ReadOnly = true;
                txtConsignmentDay.ReadOnly = true;
                txtRemark.ReadOnly = true;
                btnRevoke.Hide();
                cbConsignmentDay.Disabled = true;
                this.Toolbar2.Disabled = true;
            }
        }
        public void SetCfnHiddenBtn()
        {
            //if (this.PageStatus == ConsignmentType.Draft)
            //{
            //    if (this.TabPanel1.ActiveTabIndex == 1)
            //    {

            //        BtnDeclareAdd.Disabled = false;

            //    }
                
            //    if (this.TabPanel1.ActiveTabIndex == 2)
            //    {

            //        btnAddCfnSet.Disabled = false;
            //        btnAddCfn.Disabled = false;

            //    }
              
            //}
            //else {
            //    if (this.TabPanel1.ActiveTabIndex == 1)
            //    {


            //        BtnDeclareAdd.Disabled = true;
            //    }
            //    if (this.TabPanel1.ActiveTabIndex == 2)
            //    {

            //        btnAddCfnSet.Disabled = true;
            //        btnAddCfn.Disabled = true;

            //    }
            //}
        }

        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            ConsignmentMaster header = null;
            if (IsPageNew)
            {
                header = GetNewConsignmentMaster();
            }
            else
            {
                header = consignment.SelectConsignmentMasterById(this.InstanceId);
            }
            //页面赋值
            ClearFormValue();
            ClearDetailWindow();
            SetFormValue(header);
            //页面控件状态
           
            SetDetailWindow(header);
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.hidProductLine.Clear();
            this.hidOrderStatus.Clear();
            this.hidEditItemId.Clear();
            this.hidLatestAuditDate.Clear();
            this.hidOrderType.Clear();
            this.hidPriceType.Clear();

            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
            this.hidRtnRegMsg.Clear();

            this.cbProductLine.SelectedItem.Value = "";
            this.cbOrderType.SelectedItem.Value = "";
            this.txtOrderNo.Clear();
            this.txtOrderStatus.Clear();
            this.txtSubmitDate.Clear();
            //this.cbTerritory.SelectedItem.Value = "";
            txtConsignmentDay.Hide();
            cbConsignmentDay.Disabled = false;
            this.txtRemark.Clear();

           
        }
        public void DeleteConsignmentDealer()
        {
            consignment.DeleteConsignmentDealerby(InstanceId.ToString());
        }
        private void SetFormValue(ConsignmentMaster header)
        {
            //表头信息
            this.hidProductLine.Text = header.ProductLineId.HasValue ? header.ProductLineId.Value.ToString() : "";
            this.PageStatus = (ConsignmentType)Enum.Parse(typeof(ConsignmentType), header.OrderStatus, true);
            this.hidLatestAuditDate.Text = header.UpdateDate.HasValue ? header.UpdateDate.Value.ToString() : "";

            this.hidOrderType.Text = header.OrderType;
            this.txtOrderNo.Text = header.OrderNo;
            this.txtOrderStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Const_Consignment_Type, header.OrderStatus);
          
            this.txtSubmitDate.Text = header.CreateDate.HasValue ? header.CreateDate.Value.ToString("yyyy-MM-dd HH:mm:ss") : "";

            this.cbOrderType.SelectedItem.Value = header.OrderType;

            //汇总信息
            this.txtRemark.Text = header.Remark;
            this.txtConsignmentName.Text = header.ConsignmentName;
            this.txtConsignmentDay.Text = header.ConsignmentDay.HasValue ? header.ConsignmentDay.ToString() : "";
            this.dtStartDate.Value = header.StartDate.HasValue ? header.StartDate.Value.ToString("yyyy-MM-dd") : "";
            if (header.ConsignmentDay.HasValue)
            {

                if (header.ConsignmentDay != 15 && header.ConsignmentDay != 30)
                {
                    txtConsignmentDay.Show();
                    txtConsignmentDay.Text = header.ConsignmentDay.ToString();

                    cbConsignmentDay.SelectedItem.Value = "0";
                }
                else
                {
                    cbConsignmentDay.SelectedItem.Value = header.ConsignmentDay.ToString();
                }
            }
            else {
                txtConsignmentDay.Hide();
            }
            this.dtEndDate.Value = header.EndDate.HasValue ? header.EndDate.Value.ToString("yyyy-MM-dd") : "";
            txtDelayTime.Text = header.DelayTime.ToString();
            
        }

        private ConsignmentMaster GetNewConsignmentMaster()
        {
            ConsignmentMaster header = new ConsignmentMaster();
            header.Id = this.InstanceId;
            header.OrderStatus = PurchaseOrderStatus.Draft.ToString();
            header.CreateUser = new Guid(_context.User.Id);
            header.CreateDate = DateTime.Now;


            consignment.InsertPurchaseOrderHeader(header);
            return header;
        }

        private ConsignmentMaster GetFormValue()
        {
            DateTime bgdt;
            DateTime endt;
            ConsignmentMaster header = consignment.SelectConsignmentMasterById(this.InstanceId);
            header.ProductLineId = string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value) ? null as Guid? : new Guid(this.cbProductLine.SelectedItem.Value);
            header.OrderType = string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value) ? "" : this.cbOrderType.SelectedItem.Value;
            //header.TerritoryCode = this.cbTerritory.SelectedItem.Value;
            //汇总信息
            header.Remark = this.txtRemark.Text;
            if (txtConsignmentDay.Text != string.Empty)
            {
                header.ConsignmentDay = Convert.ToInt32(this.txtConsignmentDay.Text);
            }
           
            header.ConsignmentName = this.txtConsignmentName.Text.Trim();
            header.DelayTime = string.IsNullOrEmpty(this.txtDelayTime.Text) ? 0 : Convert.ToInt32(this.txtDelayTime.Text);
            if (!dtStartDate.IsNull)
            {
                header.StartDate = dtStartDate.SelectedDate;
            }
           if(!dtEndDate.IsNull)
           {
               header.EndDate = dtEndDate.SelectedDate;
           }
          
            header.CreateDate = DateTime.Now;
            header.CreateUser = new Guid(_context.User.Id);
          
            return header;
        }

     

        #endregion
    }
}