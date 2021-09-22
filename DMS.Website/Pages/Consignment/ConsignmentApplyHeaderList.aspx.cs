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
using DMS.Model.Consignment;
using System.Web.Services;

namespace DMS.Website.Pages.Consignment
{

    public partial class ConsignmentApplyHeaderList : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        IConsignmentDealerBLL CdelaBll = new ConsignmentDealerBLL();
        DealerMasters dm = new DealerMasters();
        IConsignmentApplyDetailsBLL DtBll = new ConsignmentApplyDetailsBLL();
        IConsignmentMasterBLL ConMastBll = new ConsignmentMasterBLL();
        private IConsignmentApplyHeaderBLL _bll = null;
        [Dependency]
        public IConsignmentApplyHeaderBLL bll
        {
            get { return _bll; }
            set { _bll = value; }
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

        public Guid DealerId
        {
            get
            {
                return new Guid(this.hidDealerId.Text);
            }
            set
            {
                this.hidDealerId.Text = value.ToString();
            }
        }

        public PurchaseOrderStatus PageStatus
        {
            get
            {
                return (PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), this.hidOrderStatus.Text, true);
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

        #region Store
        protected void Page_Load(object sender, EventArgs e)
        {
            this.hidCorpType.Text = "";
            hidPriceType.Text = "Dealer";
            hidOrderType.Text = "Normal";
            if (IsDealer)
            {
                this.hidCorpType.Text = RoleModelContext.Current.User.CorpType;

            }
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.btnInsert.Visible = IsDealer;
                this.BtnDelay.Visible = IsDealer;
                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_Dictionary(this.OrderStatusStore, SR.ConsignmentApply_Status);
                //this.Bind_Dictionary(this.DelayStore, SR.CONST_Delay_Status);
                this.Bind_Dictionary(this.OrderTypeStore, SR.ConsignmentApply_Order_Type);

                this.Bind_Dictionary(this.DelayStatusStore, SR.CONST_Delay_Status);
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ORDERNEW);
                    }
                    else
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, false);
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

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value.Trim()))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDate", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text.Trim()))
            {
                param.Add("OrderNo", this.txtOrderNo.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtCfn.Text.Trim()))
            {
                param.Add("Cfn", this.txtCfn.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.cbDelayStatus.SelectedItem.Value))
            {
                param.Add("DelayStatus", this.cbDelayStatus.SelectedItem.Value);
            }
            //if (!string.IsNullOrEmpty(this.txRemark.Text))
            //{
            //    param.Add("Remark", this.txRemark.Text);
            //}
            //BSC用户可以看所有订单，经销商用户只能看自己创建的订单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())))
            {
                param.Add("CreateUser", new Guid(_context.User.Id));
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
            {
                param.Add("IsHQ", "True");
            }
            DataSet ds = bll.QueryConsignmentApplyHeaderDealer(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();


        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = DtBll.SelectConsignmentApplyProList(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            DetailStore.DataSource = ds;
            DetailStore.DataBind();
            if (hidChanConsignment.Text == "Otherdealers")
            {
                gpDetail.ColumnModel.SetEditable(4, false);
            }
            else
            {
                gpDetail.ColumnModel.SetEditable(4, true);
            }

        }

        protected internal virtual void Bind_OrderTypeForLP(Store store, string type)
        {
            //物流平台、一级经销商可以查看普通订单、特殊价格订单、寄售订单、寄售销售订单、交接订单、清指定批号订单、成套设备订单
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            store.DataSource = (from t in dicts
                                where (
                                       t.Key == type
                                       )
                                select t);
            store.DataBind();

        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            IPurchaseOrderBLL _business = new PurchaseOrderBLL();
            int totalCount = 0;
            DataSet ds = _business.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        protected void OrderTrackStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            /*
            string RtnVal = string.Empty;
            string RtnMsg = string.Empty;

            DataSet ds = bll.QueryConsignmentTrackByOrderId(this.InstanceId, out RtnVal, out RtnMsg);

            this.OrderTrackStore.DataSource = ds;
            this.OrderTrackStore.DataBind();
            */
        }
        #endregion

        #region AjaxMetnods
        [AjaxMethod]
        public void Show(string id)
        {

            ClearValue();

            this.IsSaved = false;
            this.IsModified = false;
            ConsignmentApplyHeader header = new ConsignmentApplyHeader();
            this.InstanceId = (id == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(id));
            GetProductsource();
            InitializationFrom();

            DetailWindow.Show();
        }

        /// <summary>
        /// 删除订单明细
        /// </summary>
        /// <param name="id"></param>
        [AjaxMethod]
        public void DeleteItem(string id)
        {

            bool result = DtBll.DeleteCfn(new Guid(id));
        }

        [AjaxMethod]
        public void DeleteDraft()
        {

            bool result = bll.DeltetDraft(InstanceId);
            if (result)
            {
                IsSaved = true;
            }
        }

        /// <summary>
        /// 保存草稿
        /// </summary>
        /// <param name="qty"></param>
        /// <param name="cfnPrice"></param>
        /// <param name="upn"></param>
        [AjaxMethod]
        public void UpdateItem(string qty, string cfnPrice, string upn)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            Guid detailId = new Guid(this.hidEditItemId.Text);
            ConsignmentApplyDetails detail = new ConsignmentApplyDetails();

            detail = DtBll.GetConsignmentApplyDetailsSing(detailId);

            if (!string.IsNullOrEmpty(qty))
            {
                detail.Qty = Convert.ToDecimal(qty);
            }
            if (!string.IsNullOrEmpty(cfnPrice))
            {

                detail.Price = Convert.ToDecimal(cfnPrice);

            }

            detail.Amount = detail.Qty * detail.Price;


            bool result = DtBll.UpdateConsignmentApplyDetails(detail);
            rtnVal = "Success";
            //}
            this.hidRtnVal.Text = rtnVal;
        }

        public void InitializationFrom()
        {
            ConsignmentApplyHeader header = bll.GetConsignmentApplyHeaderSing(this.InstanceId);
            if (header == null)
            {
                header = NewConshead();
            }
            SetDetailWindow(header);

            AssignFrom(header);

        }

        public ConsignmentApplyHeader NewConshead()
        {
            ConsignmentApplyHeader header = new ConsignmentApplyHeader();
            header.Id = this.InstanceId;
            header.DmaId = _context.User.CorpId.Value;
            header.OrderStatus = "Draft";
            header.CreateUser = new Guid(_context.User.Id);
            header.CreateDate = DateTime.Now;
            bll.AddHeader(header);
            return header;
        }

        public ConsignmentApplyHeader GetFormValue()
        {
            ConsignmentApplyHeader Header = bll.GetConsignmentApplyHeaderSing(this.InstanceId);
            Header.DmaId = string.IsNullOrEmpty(cbDealer.SelectedItem.Value) ? null as Guid? : new Guid(cbDealer.SelectedItem.Value);
            Header.ProductLineId = string.IsNullOrEmpty(cbproline.SelectedItem.Value) ? null as Guid? : new Guid(cbproline.SelectedItem.Value);
            Header.OrderType = "DealerConsignmentApply";
            Header.SalesName = txtSalesName.Text;
            Header.SalesEmail = txtSalesEmail.Text;
            Header.SalesPhone = txtSalesPhone.Text;
            Header.Consignee = txtConsignee.Text;
            Header.ConsigneePhone = txtConsigneePhone.Text;
            Header.SendAddress = HospitalAddress.Text;
            Header.SendHospital= Texthospitalname.Text;
            if (dfRDD.SelectedDate != null && this.dfRDD.SelectedDate > DateTime.MinValue)
            {
                Header.Rdd = this.dfRDD.SelectedDate;
            }
            else
            {
                Header.Rdd = null;
            }
            Header.ShipToAddress = cbSAPWarehouseAddress.SelectedItem.Value;
            Header.Remark = txtRemark.Text;
            Header.Reason = txtConsignment.Text;
            if (!string.IsNullOrEmpty(txtRule.SelectedItem.Value))
            {
                Header.CmId = new Guid(txtRule.SelectedItem.Value);
                Header.CmConsignmentName = txtRule.SelectedItem.Text;
            }
            else
            {
                Header.CmId = null;
                Header.CmConsignmentName = null;
            }
            if (!string.IsNullOrEmpty(txtNumberDays.Text))
            {
                Header.CmConsignmentDay = int.Parse(txtNumberDays.Text);
            }
            if (cbSuorcePro.SelectedItem.Value != string.Empty)
            {
                Header.ConsignmentId = new Guid(cbSuorcePro.SelectedItem.Value);
            }
            else
            {
                Header.ConsignmentId = null;
            }
            //Header.CmType = txtNearlyvalidType.Text;
            Header.CmDelayNumber = int.Parse(txtDelaytimes.Text == "" ? "0" : txtDelaytimes.Text);
            Header.DelayDelayTime = int.Parse(txtDelaytimes.Text == "" ? "0" : txtDelaytimes.Text);
            //if (!string.IsNullOrEmpty(txtLateMoney.Text))
            //{
            //    Header.CmDailyFines =Convert.ToDecimal(txtLateMoney.Text);
            //}
            //if (!string.IsNullOrEmpty(txtMainMoney.Text))
            //{
            //    Header.CmLowestMargin = Convert.ToDecimal(txtMainMoney.Text);
            //}
            if (!string.IsNullOrEmpty(txtBeginData.Text))
            {
                Header.CmStartDate = Convert.ToDateTime(txtBeginData.Text);
            }
            if (!string.IsNullOrEmpty(txtEndData.Text))
            {
                Header.CmEndDate = Convert.ToDateTime(txtEndData.Text);
            }
            //if (!string.IsNullOrEmpty(txtTotalMoney.Text))
            //{
            //    Header.CmTotalAmount = Convert.ToDecimal(txtTotalMoney.Text);
            //}
            if (!string.IsNullOrEmpty(cbHospital.SelectedItem.Value))
            {
                Header.HospitalId = new Guid(cbHospital.SelectedItem.Value);
                Header.HospitalName = cbHospital.SelectedItem.Text;
            }
            Header.ConsignmentFrom = cbProductsource.SelectedItem.Value;

            //添加新寄售合同字段
            Header.IsFixedMoney = this.txtIsControlAmount.Text.Equals("是") ? true : false;
            Header.IsUseDiscount = this.txtIsDiscount.Text.Equals("是") ? true : false;
            Header.IsFixedQty = this.txtIsControlNumber.Text.Equals("是") ? true : false;
            Header.Iskb = this.txtIsKB.Text.Equals("是") ? true : false;

            return Header;
        }
        [AjaxMethod]
        public void HospitChange()
        {
            if (!string.IsNullOrEmpty(cbHospital.SelectedItem.Value))
            {
                DataSet ds = bll.SelectHospitSale(cbHospital.SelectedItem.Value, hidDivisionCode.Text);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    cbSale.SelectedItem.Value = ds.Tables[0].Rows[0]["Id"].ToString();
                }
                else
                {
                    cbSale.SelectedItem.Value = "";
                    txtSalesName.Clear();
                    txtSalesEmail.Clear();
                    txtSalesPhone.Clear();
                }
            }
        }
        [AjaxMethod]
        public void SaveDraft()
        {
            ConsignmentApplyHeader Header = GetFormValue();
            if (txtRule.SelectedItem.Value != string.Empty)
            {
                //ConsignmentMaster ComHeader = ConMastBll.GetConsignmentMasterKey(new Guid(txtRule.SelectedItem.Value));
                //调整为获取寄售合同数据绑定
                ContractHeaderPO Mast = ConMastBll.GetContractHeaderPOById(new Guid(txtRule.SelectedItem.Value));

                Header.IsFixedMoney = Mast.CCH_IsFixedMoney;
                Header.IsFixedQty = Mast.CCH_IsFixedQty;
                Header.Iskb = Mast.CCH_IsKB;
                Header.IsUseDiscount = Mast.CCH_IsUseDiscount;
                Header.CmStartDate = Mast.CCH_BeginDate;
                Header.CmEndDate = Mast.CCH_EndDate;
                Header.DelayDelayTime = Mast.CCH_DelayNumber;
                Header.CmDelayNumber = Mast.CCH_DelayNumber;
                Header.CmConsignmentDay = Mast.CCH_ConsignmentDay;
            }
            else
            {
                Header.IsFixedMoney = null;
                Header.IsFixedQty = null;
                Header.Iskb = null;
                Header.IsUseDiscount = null;
                Header.CmStartDate = null;
                Header.CmEndDate = null;
                Header.DelayDelayTime = null;
                Header.CmDelayNumber = null;
                Header.CmConsignmentDay = null;
            }
            //Header.DelayDelayTime = 0;
            DateTime time = DateTime.Now;
            Header.UpdateDate = time;
            bool result = bll.SaveDraft(Header);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void InitBtnCfnAdd()
        {
            SetAddCfnSetBtnHidden();
        }

        [AjaxMethod]
        public void CheckSubmit()
        {
            //Hashtable ht = new Hashtable();
            //ht.Add("CMID", txtRule.SelectedItem.Value);
            //ht.Add("ProductLineId", cbproline.SelectedItem.Value);
            //ht.Add("DMAId", _context.User.CorpId.Value);
            ContractHeaderPO Mast = ConMastBll.GetContractHeaderPOById((new Guid(txtRule.SelectedItem.Value)));

            IConsignmentMasterBLL Mastbll = new ConsignmentMasterBLL();
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string RtnRegMsg = string.Empty;
            string Texthospitalname = string.Empty;
            string HospitalAddress = string.Empty;

            //DataSet ds = Mastbll.SelecConsignmentdatetimeby(ht);
            if (Mast != null)
            {

                if (Convert.ToDateTime(Mast.CCH_BeginDate) <= DateTime.Now && Convert.ToDateTime(Mast.CCH_EndDate) > DateTime.Now)
                {

                    ConsignmentApplyHeader header = null;
                    header = bll.GetConsignmentApplyHeaderSing(InstanceId);
                    if (header != null)
                    {
                        hidorderState.Text = header.OrderStatus;
                        if (hidorderState.Text.Equals(ConsignmentOrderType.Draft.ToString()))
                        {

                            bool result = CdelaBll.ChcekCfnSumbit(this.InstanceId, _context.User.CorpId.Value, cbproline.SelectedItem.Value, txtRule.SelectedItem.Value, out rtnVal, out rtnMsg, out RtnRegMsg);//, out Texthospitalname,out HospitalAddress

                        }
                        else
                        {
                            rtnVal = "Error";
                            rtnMsg = "单据已被改变，请重新修改！";
                        }
                    }
                }
                else
                {
                    rtnVal = "Error";
                    rtnMsg = txtRule.SelectedItem.Text + "不在有效期范围内!";
                }
            }
            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>");

        }

        /// <summary>
        /// 提交申请
        /// </summary>
        [AjaxMethod]
        public string Submit()
        {
            string resMsg = string.Empty;
            AutoNumberBLL auto = new AutoNumberBLL();
            ConsignmentApplyHeader Header = GetFormValue();
            if (bll.SelectSalesSing(Header.SalesName, Header.SalesEmail))
            {
                //ConsignmentMaster ComHeader = ConMastBll.GetConsignmentMasterKey(new Guid(txtRule.SelectedItem.Value));
                //调整为获取寄售合同数据绑定
                ContractHeaderPO ComHeader = ConMastBll.GetContractHeaderPOById((new Guid(txtRule.SelectedItem.Value)));

                Header.CmConsignmentDay = ComHeader.CCH_ConsignmentDay;
                //Header.CmType = DictionaryCacheHelper.GetDictionaryNameById(SR.CONST_Consignment_Rule, ComHeader.OrderType == null ? "" : ComHeader.OrderType);
                Header.CmDelayNumber = ComHeader.CCH_DelayNumber;
                //Header.CmReturnTime = ComHeader.ReturnTime;
                Header.CmStartDate = ComHeader.CCH_BeginDate;
                Header.CmEndDate = ComHeader.CCH_EndDate;
                Header.DelayDelayTime = ComHeader.CCH_DelayNumber;
                Header.IsFixedMoney = ComHeader.CCH_IsFixedMoney;
                Header.IsFixedQty = ComHeader.CCH_IsFixedQty;
                Header.Iskb = ComHeader.CCH_IsKB;
                Header.IsUseDiscount = ComHeader.CCH_IsUseDiscount;
                DateTime time = DateTime.Now;
                Header.SubmitDate = time;
                Header.UpdateDate = time;
                //Header.DelayDelayTime = Header.DelayDelayTime + 1;
                //Header.OrderNo=auto.GetNextAutoNumber(this._context.User.CorpId.Value, OrderType.Next_ConsignmentApplyNbr, new Guid(cbproline.SelectedItem.Value));

                Header.OrderStatus = ConsignmentOrderType.Submitted.ToString();
                //Header.OrderStatus = ConsignmentOrderType.Approved.ToString();
                bool result = bll.Sumbit(Header, out resMsg);

                if (result)
                {
                    IsSaved = true;
                }
            }
            else
            {
                resMsg = "销售已不存在，请重新选择";
            }
            return resMsg;
        }

        /// <summary>
        /// 变更产品线
        /// </summary>
        [AjaxMethod]
        public void ChangeProductLine()
        {
            //更换产品线，删除订单原产品组下的所有产品
            bool result = DtBll.HeaderDtcfn(InstanceId);
            CdelaBindata(DealerConsignmentStore);

            //清空寄售规则
            txtRule.SelectedItem.Value = string.Empty;
            cbSale.SelectedItem.Value = string.Empty;
            ClearConsignmentinfo();
            ClearSaleInfo();
            SetConsignmentinfo();
            //变更产品线下的销售
            DealerConsignmentStoreBindata(SalesRepStor, cbproline.SelectedItem.Value);
            //获取产品线下的经销商
            GetProductLineDma();
            //获取产品线想的医院
            HospatBindata(HostitStore, cbproline.SelectedItem.Value);
            SetAddCfnSetBtnHidden();
            //更新Virtual DC          

        }

        /// <summary>
        /// 变更短期寄售规则
        /// </summary>
        [AjaxMethod]

        public void SetConsignment()
        {
            ClearConsignmentinfo();
            SetConsignmentinfo();
            SetAddCfnSetBtnHidden();
        }

        /// <summary>
        /// 变更销售
        /// </summary>
        [AjaxMethod]
        public void GetSaleList()
        {
            //清除收货人信息
            ClearSaleInfo();

        }


        [AjaxMethod]
        public void ChanConsignmentFrom(string id)
        {
            bool result = DtBll.HeaderDtcfn(InstanceId);
            hidChanConsignment.Clear();

            if (id == "Bsc")
            {
                if (this.TabPanel1.ActiveTabIndex == 2)
                {
                    btnAddOtherdealersCfn.Disabled = true;
                    btnAddCfnSet.Disabled = false;
                    btnAddCfn.Disabled = false;
                }
                cbSuorcePro.Hide();

            }
            else if (id == "Otherdealers")
            {
                cbSuorcePro.Show();
                if (this.TabPanel1.ActiveTabIndex == 2)
                {

                    btnAddOtherdealersCfn.Disabled = true;
                    btnAddCfnSet.Disabled = true;
                    btnAddCfn.Disabled = true;
                }
            }
            cbSuorcePro.SelectedItem.Value = string.Empty;


        }

        [AjaxMethod]
        public void ChangSuoresDelaer()
        {
            //bool result = DtBll.HeaderDtcfn(InstanceId);
            if (this.TabPanel1.ActiveTabIndex == 2)
            {
                btnAddOtherdealersCfn.Disabled = false;
            }

        }

        [AjaxMethod]
        public void btnDelayClick()
        {
            bool result = false;
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string errorMsg = string.Empty;
            ConsignmentApplyHeader header = new ConsignmentApplyHeader();
            header = bll.GetConsignmentApplyHeaderSing(InstanceId);
            if (bll.SelectSalesSing(header.SalesName, header.SalesEmail))
            {
                if (header.DelayOrderStatus == ConsignmentDelayStatus.Submitted.ToString())
                {
                    rtnVal = "Error";
                    rtnMsg = "状态已更新，请重新获取!";
                }
                else if (header.DelayDelayTime > 0)
                {

                    decimal totalAmount = 0;
                    DataSet ds = bll.SelecPOReceiptPriceSum(InstanceId.ToString());

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        totalAmount = ds.Tables[0].Rows[0]["TotalAmount"] == DBNull.Value ? 0 : decimal.Parse(ds.Tables[0].Rows[0]["TotalAmount"].ToString());
                    }
                    //延期申请时，库存产品总金额若为0，那么不允许申请延期
                    if (totalAmount == 0)
                    {
                        rtnVal = "Error";
                        rtnMsg = "库存为0不允许申请延期!";
                    }
                    else
                    {
                        header.DelayOrderStatus = ConsignmentDelayStatus.Submitted.ToString();
                        header.DelaySubmitUser = new Guid(_context.User.Id);
                        header.DelaySubmitDate = DateTime.Now;
                        result = bll.SetDelayStatus(header, out errorMsg);
                    }
                }
                else
                {
                    rtnVal = "Error";
                    rtnMsg = "延期次数已用完!";
                }
            }
            else
            {
                errorMsg = "销售已不存在，申请延期失败";
            }
            if (!string.IsNullOrEmpty(errorMsg))
            {
                rtnVal = "Error";
                rtnMsg = errorMsg;
            }

            hidRtnVal.Text = rtnVal;
            hidRtnMsg.Text = rtnMsg;
            if (result)
            {
                IsSaved = true;
            }
        }
        #endregion

        #region 私有方法

        /// <summary>
        /// 清除短期寄售规则信息
        /// </summary>
        public void ClearConsignmentinfo()
        {
            hidConsignment.Clear();
            txtNumberDays.Clear();
            txtIsControlAmount.Clear();
            txtDelaytimes.Clear();
            txtIsControlNumber.Clear();
            txtBeginData.Clear();
            txtEndData.Clear();
            txtTaoteprice.Clear();
            txtIsDiscount.Clear();
            txtIsKB.Clear();
        }

        [WebMethod]
        public void DoAddItem(string param1, string param2)
        {
            this.Texthospitalname.Text = param1;
            this.HospitalAddress.Text = param2;
            this.HospitalAddress.Enabled = true;
            //return new { param1, param2 };
        }

        public void ClearSaleInfo()
        {
            txtSalesName.Clear();
            txtSalesEmail.Clear();
            txtSalesPhone.Clear();
            Texthospitalname.Clear();
            HospitalAddress.Clear();
            //txtConsignee.Clear();
            //txtConsigneeAddress.Clear();
            //txtConsigneePhone.Clear();
        }

        public void GetProductLineDma()
        {

            if (!string.IsNullOrEmpty(cbproline.SelectedItem.Value))
            {
                DataSet ds = DtBll.SelectProductLineDma(cbproline.SelectedItem.Value);
                ProductLineDmaStore.DataSource = ds;
                ProductLineDmaStore.DataBind();
            }


        }

        public void DealerConsignmentStoreBindata(Store stor, string ProlineId)
        {

            DataSet ds = bll.GetProductLineVsDivisionCode(ProlineId);
            DataSet SalesRepDs;
            string code = string.Empty;
            if (ds.Tables[0].Rows.Count > 0)
            {

                code = ds.Tables[0].Rows[0]["DivisionCode"].ToString();

                hidDivisionCode.Text = ds.Tables[0].Rows[0]["DivisionCode"].ToString();
            }

            SalesRepDs = bll.GetDealerSale(code);
            stor.DataSource = SalesRepDs;
            stor.DataBind();

        }

        /// <summary>
        /// 选择短期寄售规则时对页面赋值(修改为选择寄售合同时对页面赋值)
        /// </summary>
        public void SetConsignmentinfo()
        {
            if (txtRule.SelectedItem != null && !string.IsNullOrEmpty(txtRule.SelectedItem.Value))
            {
                ContractHeaderPO Mast = ConMastBll.GetContractHeaderPOById((new Guid(txtRule.SelectedItem.Value)));

                if (Mast != null)
                {
                    txtNumberDays.Text = Mast.CCH_ConsignmentDay.ToString();
                    txtDelaytimes.Text = Mast.CCH_DelayNumber.ToString();
                    //txtNearlyvalidType.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.CONST_Consignment_Rule, Mast.OrderType == null ? "" : Mast.OrderType);
                    //txtReturnperiod.Text = Mast.ReturnTime.ToString();
                    txtIsControlAmount.Text = Mast.CCH_IsFixedMoney.Value ? "是" : "否";
                    txtIsControlNumber.Text = Mast.CCH_IsFixedQty.Value ? "是" : "否";
                    txtIsKB.Text = Mast.CCH_IsKB.Value ? "是" : "否";
                    txtIsDiscount.Text = Mast.CCH_IsUseDiscount.Value ? "是" : "否";

                    if (Mast.CCH_BeginDate != null)
                    {
                        txtBeginData.Text = Mast.CCH_BeginDate.Value.ToString("yyyy-MM-dd");
                    }
                    if (Mast.CCH_EndDate != null)
                    {
                        txtEndData.Text = Mast.CCH_EndDate.Value.ToString("yyyy-MM-dd");
                    }
                }
            }
        }

        /// <summary>
        /// 清除窗口原信息
        /// </summary>
        /// 
        public void ClearValue()
        {
            TextHospit.Hidden = true;
            cbHospital.Hidden = false;

            txtDealerName.Text = cbDealer.SelectedItem.Text;
            this.HiCfntype.Clear();
            this.txtApplyType.Clear();
            this.txtApplyNo.Clear();
            //this.txtDealerName.Clear();
            this.txtOrderState.Clear();
            this.txtSubmitDate.Clear();
            this.txtnumber.Clear();
            this.txtConsignment.Clear();
            this.txtRemark.Clear();
            this.txtSalesName.Clear();
            this.txtSalesEmail.Clear();
            this.txtSalesPhone.Clear();
            this.txtConsignee.Clear();
            this.cbSAPWarehouseAddress.SelectedItem.Text = string.Empty;
            this.txtConsigneePhone.Clear();
            this.dfRDD.Clear();
            this.txtNumberDays.Clear();
            //this.txtNearlyvalidType.Clear();
            //this.txtLateMoney.Clear();
            this.txtIsControlAmount.Clear();
            this.txtIsDiscount.Clear();
            this.txtDelaytimes.Clear();
            //this.txtReturnperiod.Clear();
            //this.txtMainMoney.Clear();
            this.txtIsControlNumber.Clear();
            this.txtIsKB.Clear();
            this.txtBeginData.Clear();
            this.txtEndData.Clear();
            //this.txtTotalMoney.Clear();
            this.hidProductLine.Clear();
            this.hidUpdateDate.Clear();
            this.TabHeader.Show();
            this.TabDetail.Hide();
            this.TabInvoice.Hide();
            this.TabLog.Hide();
            this.TabTrack.Hide();
            this.HiSourceDealer.Clear();
            this.Texthospitalname.Clear();
            this.HospitalAddress.Clear();
            txtRule.SelectedItem.Text = string.Empty;
            cbHospital.SelectedItem.Text = string.Empty;
            hidDivisionCode.Clear();
            HospId.Clear();
        }

        /// <summary>
        /// 产品来源
        /// </summary>
        public void GetProductsource()
        {
            this.Bind_Dictionary(this.ProductsourceStor, "Product_source");

        }

        /// <summary>
        /// 更改控件状态
        /// </summary>
        public void SetAddCfnSetBtnHidden()
        {
            if (hidorderState.Text == ConsignmentOrderType.Draft.ToString())
            {
                this.gpDetail.ColumnModel.SetEditable(4, true);
                this.gpDetail.ColumnModel.SetHidden(9, false);
                if (this.TabPanel1.ActiveTabIndex == 2)
                {





                    if (cbProductsource.SelectedItem.Value == "Bsc" || cbProductsource.SelectedItem.Value == string.Empty)
                    {
                        this.btnAddCfnSet.Disabled = false;
                        this.btnAddCfn.Disabled = false;
                        this.btnAddOtherdealersCfn.Disabled = true;
                        this.gpDetail.ColumnModel.SetEditable(4, true);
                    }
                    else if (cbProductsource.SelectedItem.Value == "Otherdealers")
                    {
                        this.btnAddCfnSet.Disabled = true;
                        this.btnAddCfn.Disabled = true;
                        this.btnAddOtherdealersCfn.Disabled = true;
                        this.gpDetail.ColumnModel.SetEditable(4, false);
                        if (cbSuorcePro.SelectedItem.Value != string.Empty)
                        {

                            this.btnAddOtherdealersCfn.Disabled = false;
                        }
                    }



                }
            }
            else
            {
                this.btnAddCfnSet.Disabled = true;
                this.btnAddCfn.Disabled = true;
                this.btnAddOtherdealersCfn.Disabled = true;
                this.gpDetail.ColumnModel.SetEditable(4, false);
                this.gpDetail.ColumnModel.SetHidden(9, true);
            }

        }


        private void SetDetailWindow(ConsignmentApplyHeader header)
        {
            String corpType = RoleModelContext.Current.User.CorpType;
            if (header != null)
            {
                HiDmaId.Text = header.DmaId.Value.ToString();
                if (IsDealer)
                {
                    //如果是T1或LP，且单据是“草稿”，则可以修改
                    if (header.OrderStatus == ConsignmentOrderType.Draft.ToString())
                    {
                        //隐藏复制、放弃修改按钮
                        cbHospital.Disabled = false;
                        cbproline.Disabled = false;
                        txtRule.Disabled = false;
                        cbSuorcePro.Disabled = false;
                        txtRule.Show();
                        txtConsignmentRule.Hide();
                        this.cbProductsource.Disabled = false;
                        this.txtDelayState.Hide();
                        //this.btnCopy.Hide();
                        this.cbSale.Show();
                        this.btnSave.Show();
                        this.btnDalt.Show();
                        this.btnSubmit.Show();
                        this.BtnDelay.Hide();
                        //this.CbDelayState.Hide();
                        this.gpDetail.ColumnModel.SetEditable(4, true);
                        this.gpDetail.ColumnModel.SetHidden(9, false);
                        txtConsignment.ReadOnly = false;
                        txtRemark.ReadOnly = false;
                        txtConsignee.ReadOnly = false;
                        cbSAPWarehouseAddress.ReadOnly = false;
                        txtConsigneePhone.ReadOnly = false;
                        dfRDD.ReadOnly = false;
                    }
                    else
                    {
                        cbSuorcePro.Disabled = true;
                        cbHospital.Disabled = true;
                        cbproline.Disabled = true;
                        txtRule.Disabled = true;
                        txtRule.Hide();
                        txtConsignmentRule.Show();
                        this.cbProductsource.Disabled = true;
                        this.txtDelayState.Show();
                        //this.btnCopy.Show();
                        this.cbSale.Hide();
                        this.btnSave.Hide();
                        this.btnDalt.Hide();
                        this.btnSubmit.Hide();
                        this.BtnDelay.Show();
                        if (header.OrderStatus == ConsignmentOrderType.Submitted.ToString())
                        {
                            this.BtnDelay.Hide();
                        }
                        else if (header.OrderStatus == ConsignmentOrderType.Approved.ToString())
                        {
                            this.BtnDelay.Show();
                            if (header.DelayOrderStatus == ConsignmentDelayStatus.Approved.ToString())
                            {
                                if (header.DelayDelayTime > 0)
                                {
                                    this.BtnDelay.Show();
                                }
                                else
                                {
                                    this.BtnDelay.Hide();
                                }
                            }
                            if (header.DelayOrderStatus == ConsignmentDelayStatus.Rejected.ToString())
                            {
                                this.BtnDelay.Show();
                            }
                            if (header.DelayOrderStatus == ConsignmentDelayStatus.Submitted.ToString())
                            {
                                this.BtnDelay.Hide();
                            }
                        }

                        txtConsignment.ReadOnly = true;
                        txtRemark.ReadOnly = true;
                        //this.CbDelayState.Show();
                        this.gpDetail.ColumnModel.SetEditable(4, false);
                        this.gpDetail.ColumnModel.SetHidden(9, true);
                        txtConsignee.ReadOnly = true;
                        cbSAPWarehouseAddress.ReadOnly = true;
                        txtConsigneePhone.ReadOnly = true;
                        dfRDD.ReadOnly = true;

                    }
                }
                else
                {
                    cbSuorcePro.Disabled = true;
                    this.cbproline.Disabled = true;
                    txtRule.Disabled = true;
                    this.cbProductsource.Disabled = true;
                    this.cbHospital.Disabled = true;
                    this.txtConsignment.ReadOnly = true;
                    this.txtRemark.ReadOnly = true;
                    this.cbSale.Disabled = true;
                    this.txtConsignee.ReadOnly = true;
                    this.cbSAPWarehouseAddress.ReadOnly = true;
                    this.txtConsigneePhone.ReadOnly = true;
                    this.dfRDD.ReadOnly = true;
                    txtRule.Hide();
                    this.btnSave.Hide();
                    this.btnDalt.Hide();
                    this.btnSubmit.Hide();
                    this.BtnDelay.Hide();
                }
            }
            //else {
            //    //this.btnCopy.Hide();
            //}
        }

        /// <summary>
        /// 窗口赋值
        /// </summary>
        /// <param name="header"></param>
        public void AssignFrom(ConsignmentApplyHeader header)
        {
            txtApplyType.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.ConsignmentApply_Order_Type, "DealerConsignmentApply");
            if (header != null)
            {

                DataSet ds = DtBll.SelecConsignmentApplyDetailsCfnSum(hidInstanceId.Text);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    txtnumber.Text = ds.Tables[0].Rows[0]["Qtysum"].ToString();
                    txtTaoteprice.Text = ds.Tables[0].Rows[0]["Pricesum"].ToString();
                }
                txtDealerName.Text = DealerCacheHelper.GetDealerById(header.DmaId.Value).ChineseName;
                cbSale.SelectedItem.Text = "";
                HostitStore.RemoveAll();
                cbproline.SelectedItem.Value = header.ProductLineId == null ? "" : header.ProductLineId.ToString();

                if (cbproline.SelectedItem.Value != string.Empty)
                {
                    if (header.OrderStatus == ConsignmentOrderType.Draft.ToString())
                    {

                        HospatBindata(HostitStore, cbproline.SelectedItem.Value);
                        cbHospital.SelectedItem.Value = header.HospitalId == null ? "" : header.HospitalId.ToString();
                        cbHospital.SelectedItem.Text = header.HospitalName;
                    }
                    else
                    {
                        TextHospit.Hidden = false;
                        cbHospital.Hidden = true;
                        TextHospit.Text = header.HospitalName;

                    }
                }
                else
                {
                    HospatBindata(HostitStore, Guid.Empty.ToString());//初始化医院cb
                    cbHospital.SelectedItem.Value = string.Empty;
                }
                if (cbDealer.SelectedItem.Value == string.Empty && header.ProductLineId != null)
                {
                    cbDealer.SelectedItem.Value = header.ProductLineId.Value.ToString();
                }
                CdelaBindata(DealerConsignmentStore);

                if (cbDealer.SelectedItem.Value != null)
                {
                    AddressBindata(SAPWarehouseAddressStore);
                }
                GetProductLineDma();
                txtSubmitDate.Text = header.SubmitDate == null ? "" : header.SubmitDate.ToString();
                txtApplyNo.Text = header.OrderNo == null ? "" : header.OrderNo;
                txtDelayState.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.CONST_Delay_Status, header.DelayOrderStatus == null ? "" : header.DelayOrderStatus);
                txtOrderState.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.ConsignmentApply_Status, header.OrderStatus == null ? "" : header.OrderStatus); ;
                txtConsignment.Text = header.Reason;
                txtRemark.Text = header.Remark;
                txtSalesName.Text = header.SalesName;
                txtSalesEmail.Text = header.SalesEmail;
                txtSalesPhone.Text = header.SalesPhone;
                txtConsignee.Text = header.Consignee;
                Texthospitalname.Text = header.SendHospital;
                HospitalAddress.Text = header.SendAddress;
                cbSAPWarehouseAddress.SelectedItem.Value = header.ShipToAddress;
                txtConsigneePhone.Text = header.ConsigneePhone;
                if (header.Rdd != null)
                {
                    dfRDD.SelectedDate = header.Rdd.Value;
                }
                txtNumberDays.Text = header.CmConsignmentDay.ToString();
                //txtNearlyvalidType.Text = header.CmType == null ? "" : header.CmType.ToString();
                txtDelaytimes.Text = header.DelayDelayTime == null ? "" : header.DelayDelayTime.ToString();
                //txtLateMoney.Text = header.CmDailyFines == null ? "" : header.CmDailyFines.ToString();
                //txtMainMoney.Text = header.CmLowestMargin == null ? "" : header.CmLowestMargin.ToString();
                txtBeginData.Text = !header.CmStartDate.HasValue ? "" : header.CmStartDate.Value.ToString("yyyy-MM-dd");
                txtEndData.Text = !header.CmEndDate.HasValue ? "" : header.CmEndDate.Value.ToString("yyyy-MM-dd");
                //txtTotalMoney.Text = header.CmTotalAmount==null?"":header.CmTotalAmount.ToString();
                if (header.IsFixedMoney.HasValue)
                {
                    txtIsControlAmount.Text = header.IsFixedMoney.Value ? "是" : "否";
                }
                if (header.IsFixedQty.HasValue)
                {
                    txtIsControlNumber.Text = header.IsFixedQty.Value ? "是" : "否";
                }
                if (header.IsUseDiscount.HasValue)
                {
                    txtIsDiscount.Text = header.IsUseDiscount.Value ? "是" : "否";
                }
                if (header.Iskb.HasValue)
                {
                    txtIsKB.Text = header.Iskb.Value ? "是" : "否";
                }

                hidProductLine.Text = header.ProductLineId.HasValue ? header.ProductLineId.Value.ToString() : "";
                HospId.Text = header.HospitalId == null ? "" : header.HospitalId.Value.ToString();
                txtRule.SelectedItem.Value = header.CmId == null ? "" : header.CmId.ToString();
                txtRule.SelectedItem.Text = header.CmConsignmentName;
                this.txtConsignmentRule.Text = header.CmConsignmentName;
                hidorderState.Text = header.OrderStatus;

                txtRule.SelectedItem.Value = header.CmId == null ? "" : header.CmId.ToString();
                hidConsignment.Value = header.CmId.ToString();
                hidUpdateDate.Text = header.UpdateDate.ToString();
                hidorderState.Text = header.OrderStatus;


                if (!string.IsNullOrEmpty(header.ConsignmentFrom))
                {
                    hidChanConsignment.Text = header.ConsignmentFrom;

                }
                else
                {
                    hidChanConsignment.Text = "Bsc";

                }
                cbProductsource.SelectedItem.Value = hidChanConsignment.Text;

                if (hidChanConsignment.Text == "Bsc")
                {
                    cbSuorcePro.Hide();
                }
                else
                {
                    cbSuorcePro.SelectedItem.Value = header.ConsignmentId != null ? header.ConsignmentId.ToString() : "";
                    cbSuorcePro.Show();
                }
                if (cbproline.SelectedItem.Value != string.Empty)
                {
                    DealerConsignmentStoreBindata(SalesRepStor, cbproline.SelectedItem.Value);
                }
                else
                {

                    DealerConsignmentStoreBindata(SalesRepStor, Guid.Empty.ToString());//初始化销售cb
                    cbSale.SelectedItem.Value = string.Empty;
                }

                if (hidChanConsignment.Text == "Otherdealers")
                {
                    gpDetail.ColumnModel.SetEditable(4, false);
                }
                else
                {
                    gpDetail.ColumnModel.SetEditable(4, true);
                }

            }
        }

        /// <summary>
        /// 获取操作日志
        /// </summary>
        /// <param name="store"></param>
        /// <param name="ProductLine"></param>
        public void HospatBindata(Store store, string ProductLine)
        {
            Hashtable table = new Hashtable();
            table.Add("DealerId", string.IsNullOrEmpty(HiDmaId.Text) ? Guid.Empty.ToString() : HiDmaId.Text);
            if (!string.IsNullOrEmpty(ProductLine))
            {
                table.Add("ProductLine", ProductLine);
            }
            table.Add("ShipmentDate", DateTime.Now);
            DataSet ds = dm.SelectHospitalForDealerByShipmentDate(table);
            store.DataSource = ds;
            store.DataBind();

        }

        private void CdelaBindata(Store stor)
        {
            Hashtable table = new Hashtable();

            if (cbDealer.SelectedItem.Value != string.Empty)
            {
                table.Add("DealerId", cbDealer.SelectedItem.Value);
                table.Add("Status", "Completed");
                table.Add("ProductLineId", cbproline.SelectedItem.Value == "" ? Guid.Empty.ToString() : cbproline.SelectedItem.Value);
                //获取符合条件的寄售合同
                //DataSet ds = CdelaBll.GetConsignmentDealer(table);
                DataSet ds = CdelaBll.GetConsignmentContractDealer(table);
                stor.DataSource = ds;
                stor.DataBind();
            }

        }

        private void AddressBindata(Store stor)
        {
            base.Bind_SAPWarehouseAddress(stor, new Guid(cbDealer.SelectedItem.Value));
        }

        #endregion
    }
}
