using DMS.Website.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using System.Collections;
using System.Data;
using System.Globalization;
using System.IO;
using DMS.Business;
using DMS.Model.Data;
using DMS.Model;
using System.Text;
using DMS.DataAccess;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;

namespace DMS.Website.Pages.Inventory
{
    public partial class DealerComplainForCNFEdit : BasePage
    {
        #region Field
        private IDealerComplainBLL _business = new DealerComplainBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IAttachmentBLL attachBll = new AttachmentBLL();
        private IPurchaseOrderBLL _businessPurchaseOrder = new PurchaseOrderBLL();
        private IMessageBLL _messageBLL = new MessageBLL();
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
        private const string CONST_COMPLAIN_TYPE = "BSC";
        #endregion

        #region Page Event
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.InitForm();
                this.LoadBSCInfo();
                this.LoadDealerInfo();
                this.SetControlStatus();
                this.ShowTextBoxWhenChecked();
                BindBscEmployeeMaster();
            }
        }
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.CFNSearchForComplainDialog1.AfterSelectedCfnHandler += OnCfnAfterSelectedRow;
            this.CFNSearchForComplainDialog1.AfterSelectedQrCodeHandler += OnQrCodeAfterSelectedRow;
            this.HospitalSearchForComplainDialog1.AfterSelectedHandler += OnHospitalAfterSelectedHandler;
        }
        private void OnQrCodeAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            if (selectedRows.Count() > 0)
            {
                //之前选择lot时间
                this.cbLOT_hid.Text = selectedRows[0]["LotName"];
                this.cbLOT.Text = this.cbLOT_hid.Text;
                this.cbUPN_hid.Text = selectedRows[0]["UpnName"];
                this.cbUPN.Text = this.cbUPN_hid.Text;

                this.hiddenProductLineId.Text = selectedRows[0]["ProductLineId"];
                this.BU.Text = selectedRows[0]["BU"];
                this.hiddenBu.Text = selectedRows[0]["BU"];
                this.hiddenBuCode.Text = selectedRows[0]["BUCode"];

                this.TBNUM.Text = selectedRows[0]["FactorNumber"];
                this.hiddenTBNUM.Text = selectedRows[0]["FactorNumber"];

                this.ConvertFactor.Text = selectedRows[0]["ConvertFactor"];
                this.hiddenConvertFactor.Text = selectedRows[0]["ConvertFactor"];
                this.hiddenCFN_Property4.Text = selectedRows[0]["Property4"];

                this.DESCRIPTION.Text = selectedRows[0]["SkuDesc"];
                this.hiddenDESCRIPTION.Text = selectedRows[0]["SkuDesc"];
                this.txtQRCodeView.Text = selectedRows[0]["QrCode"];
                //this.Model.Text = selectedRows[0]["Property1"];
                //this.Registration.Text = selectedRows[0]["Property5"];
                this.txtProductExpiredDate.Text = selectedRows[0]["ExpiredDate"];

                BindBscEmployeeMaster();


                this.hiddenWarehouseId.Text = selectedRows[0]["WarehouseId"];
                this.cbWarehouse.Text = selectedRows[0]["WarehouseName"];

                this.hiddenQrCode.Text = selectedRows[0]["QrCode"];
                this.txtQrCode.Text = this.hiddenQrCode.Text;

                this.hiddenExpiredDate.Text = selectedRows[0]["ExpiredDate"];
                this.UPNExpDate.Text = this.hiddenExpiredDate.Text;

                Hashtable table = new Hashtable();

                table.Add("UPN", this.cbUPN_hid.Text.Trim());
                table.Add("LotNumer", string.Format("{0}@@{1}", this.cbLOT_hid.Text.Trim(), this.hiddenQrCode.Text));
                table.Add("DealerId", this.hiddenInitDealerId.Text);

                DataSet ds = _business.QueryDealerComplainProductSaleDate(table);

                if (ds.Tables[0].Rows[0]["SalesDate"] != DBNull.Value)
                {
                    this.SalesDate.SelectedDate = DateTime.Parse(ds.Tables[0].Rows[0]["SalesDate"].ToString());
                    this.hiddenSalesDate.Text = DateTime.Parse(ds.Tables[0].Rows[0]["SalesDate"].ToString()).ToString("yyyyMMdd");
                    this.hiddenHasSalesDate.Text = "1";
                }
                else
                {
                    this.hiddenHasSalesDate.Text = "0";
                }

                this.SalesDate.Disabled = this.hiddenHasSalesDate.Text == "1" ? true : false;

                SetRadioGroupValue(PRODUCTTYPE, "13");  //产品类型
                this.PropertyRights.Text = getPropertyRights(); //物权类型
                this.hiddenRETURNTYPE.Text = GetReturnType();   //退货类型
                this.RETURNTYPE.SelectedItem.Value = this.hiddenRETURNTYPE.Text;
            }
        }
        private void OnHospitalAfterSelectedHandler(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            if (selectedRows.Count() > 0)
            {
                this.DISTRIBUTORCUSTOMER.Text = selectedRows[0]["HosKeyAccount"];
                this.DISTRIBUTORCITY.Text = selectedRows[0]["HosCity"];
                this.etfHospitalName_China.Text = selectedRows[0]["HosHospitalName"];
                BindBscEmployeeMaster();
            }

        }
        private void OnCfnAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            if (selectedRows.Count() > 0)
            {
                this.cbLOT_hid.Text = selectedRows[0]["LotName"];
                this.cbLOT.Text = this.cbLOT_hid.Text;
                this.cbUPN_hid.Text = selectedRows[0]["UpnName"];
                this.cbUPN.Text = this.cbUPN_hid.Text;

                this.hiddenProductLineId.Text = selectedRows[0]["ProductLineId"];
                this.BU.Text = selectedRows[0]["BU"];
                this.hiddenBu.Text = selectedRows[0]["BU"];
                this.hiddenBuCode.Text = selectedRows[0]["BUCode"];

                this.TBNUM.Text = selectedRows[0]["FactorNumber"];
                this.hiddenTBNUM.Text = selectedRows[0]["FactorNumber"];

                this.ConvertFactor.Text = selectedRows[0]["ConvertFactor"];
                this.hiddenConvertFactor.Text = selectedRows[0]["ConvertFactor"];
                this.hiddenCFN_Property4.Text = selectedRows[0]["Property4"];

                this.DESCRIPTION.Text = selectedRows[0]["SkuDesc"];
                this.hiddenDESCRIPTION.Text = selectedRows[0]["SkuDesc"];

                //this.Model.Text = selectedRows[0]["Property1"];
                //this.Registration.Text = selectedRows[0]["Property5"];

                BindBscEmployeeMaster();
            }
        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _businessPurchaseOrder.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }
        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(this.InstanceId, AttachmentType.DealerComplainCNF, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }

        protected void AttachmentRtnStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(this.InstanceId, AttachmentType.DealerComplainCNFRtn, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentRtnStore.DataSource = ds;
            AttachmentRtnStore.DataBind();
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            try
            {
                if (this.FileUploadField1.HasFile)
                {
                    bool error = false;

                    string fileName = FileUploadField1.PostedFile.FileName;
                    string fileExtention = string.Empty;
                    string fileExt = string.Empty;
                    if (fileName.LastIndexOf(".") < 0)
                    {
                        error = true;
                    }
                    else
                    {
                        fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                        fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    }

                    if (error)
                    {
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = "文件错误",
                            Message = "请上传正确的文件！"
                        });

                        return;
                    }

                    //构造文件名称

                    string uploadType = this.hiddenAttachmentUpload.Text;

                    string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;
                    string filderPath = string.Empty;
                    if (this.hiddenAttachmentUpload.Text == AttachmentType.DealerComplainCNFRtn.ToString())
                    {
                        filderPath = "\\Upload\\UploadFile\\DealerComplainCNFRtn\\";
                    }
                    else
                    {
                        filderPath = "\\Upload\\UploadFile\\DealerComplainCNF\\";
                    }
                    if (!Directory.Exists(Server.MapPath(filderPath)))
                    {
                        Directory.CreateDirectory(Server.MapPath(filderPath));
                    }

                    //上传文件在Upload文件夹
                    string file = Server.MapPath(filderPath + newFileName);

                    //文件上传
                    FileUploadField1.PostedFile.SaveAs(file);

                    Attachment attach = new Attachment();
                    attach.Id = Guid.NewGuid();
                    attach.MainId = this.InstanceId;
                    attach.Name = fileExtention;
                    attach.Url = newFileName;
                    attach.Type = this.hiddenAttachmentUpload.Text == AttachmentType.DealerComplainCNFRtn.ToString() ? AttachmentType.DealerComplainCNFRtn.ToString() : AttachmentType.DealerComplainCNF.ToString();
                    attach.UploadDate = DateTime.Now;
                    attach.UploadUser = new Guid(_context.User.Id);

                    attachBll.AddAttachment(attach);

                    e.Success = true;
                }
                else
                {
                    e.Success = false;
                    e.ErrorMessage = "请选择附件";
                }
            }
            catch (Exception ex)
            {
                e.Success = false;
                e.ErrorMessage = ex.Message;
            }
        }
        #endregion

        #region Public Attribute
        public Guid? _instanceId;
        public Guid InstanceId
        {
            get
            {
                if (!_instanceId.HasValue)
                {
                    _instanceId = new Guid(Request.QueryString["InstanceId"].ToString());
                }

                return _instanceId.Value;
            }
        }
        public DateTime ConfirmUpdateDate
        {
            get
            {
                return DateTime.Parse(this.hiddenConfirmUpdateDate.Text);
            }
            set
            {
                this.hiddenConfirmUpdateDate.Text = value.ToString();
            }
        }
        public DateTime LastUpdateDate
        {
            get
            {
                return DateTime.Parse(this.hiddenLastUpdateDate.Text);
            }
            set
            {
                this.hiddenLastUpdateDate.Text = value.ToString();
            }
        }
        #endregion

        #region AjaxMethod
        [AjaxMethod]
        //提交退货单
        public void DoSaveReturn(string saveType)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                string returnStatus = string.Empty;

                if (saveType == "doSubmit")
                {
                    rtnVal = this.CheckReturnType();
                    rtnMsg = rtnVal;

                    if (rtnVal == "Success")
                    {
                        returnStatus = "Submit";

                        Hashtable table = new Hashtable();
                        table.Add("WHMID", this.hiddenWarehouseId.Text);
                        table.Add("DMAID", this.hiddenInitDealerId.Text);
                        table.Add("UPN", this.cbUPN_hid.Text);
                        table.Add("Lot", this.cbLOT_hid.Text);
                        table.Add("QrCode", this.hiddenQrCode.Text);
                        table.Add("ReturnNum", this.hiddenTBNUM.Text == "" ? "0" : this.hiddenTBNUM.Text);
                        if (!this.INITIALPDATE.IsNull) { table.Add("ImplantDate", this.INITIALPDATE.SelectedDate); }
                        if (!this.EDATE.IsNull) { table.Add("EventDate", this.EDATE.SelectedDate); }
                        table.Add("ComplainType", "DealerReturn");

                        _business.CheckUPNAndDateCNFForEkp(table, out rtnVal, out rtnMsg);
                    }
                }
                else if (saveType == "doSaveDraft")
                {
                    returnStatus = "Draft";
                    rtnVal = "Success";
                }

                if (rtnVal.Equals("Success"))
                {
                    SaveReturnCrmInfo(returnStatus);
                }
                else
                {
                    throw new Exception(rtnMsg);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 经销商确认投诉
        /// </summary>
        [AjaxMethod]
        public void DoDealerConfirm()
        {
            this.UpdateComplainStatus("Confirmed");
        }

        /// <summary>
        /// QA确认投诉单
        /// </summary>
        [AjaxMethod]
        public void DoQAReceipt()
        {
            this.UpdateComplainStatus("Accept");
        }

        /// <summary>
        /// QA拒绝
        /// </summary>
        [AjaxMethod]
        public void DoQAReject()
        {
            this.UpdateComplainStatus("Reject");
        }

        /// <summary>
        /// QA保存
        /// </summary>
        [AjaxMethod]
        public void DoQASaveDraft()
        {
            //保存表单但是不该表状态
            this.SaveComplainCrmInfo(this.hiddenCompalinStatus.Text);
        }

        /// <summary>
        /// QA提交
        /// </summary>
        [AjaxMethod]
        public void DoQASubmit()
        {
            this.SaveComplainCrmInfo("DealerConfirm");
        }

        /// <summary>
        /// 导出Word
        /// </summary>
        [AjaxMethod]
        public string DoExportForm()
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", this.InstanceId);
            param.Add("ComplainType", "BSC");
            var table = _business.DealerComplainInfo_SpecialDateFormat(param);
            if (table.Rows.Count == 0)
                throw new Exception("单据不存在");

            string rtnVal = _business.DealerComplainCNFExportForm(table);

            return JsonHelper.Serialize(new { ComplainNbr = (string.IsNullOrEmpty(table.Rows[0]["DC_ComplainNbr"].ToString()) ? "DealerComplainCNF" : table.Rows[0]["DC_ComplainNbr"].ToString()), FilePath = rtnVal });
        }

        [AjaxMethod]
        public void DoSave(string saveType)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                string complainStatus = string.Empty;

                if (saveType == "doSubmit")
                {
                    complainStatus = "Submit";

                    Hashtable table = new Hashtable();
                    table.Add("WHMID", this.hiddenWarehouseId.Text);
                    table.Add("DMAID", this.hiddenInitDealerId.Text);
                    table.Add("UPN", this.cbUPN_hid.Text);
                    table.Add("Lot", this.cbLOT_hid.Text);
                    table.Add("QrCode", this.hiddenQrCode.Text);
                    table.Add("ReturnNum", this.hiddenTBNUM.Text == "" ? "0" : this.hiddenTBNUM.Text);
                    if (!this.INITIALPDATE.IsNull) { table.Add("ImplantDate", this.INITIALPDATE.SelectedDate); }
                    if (!this.EDATE.IsNull) { table.Add("EventDate", this.EDATE.SelectedDate); }
                    table.Add("ComplainType", "DealerComplain");

                    _business.CheckUPNAndDateCNFForEkp(table, out rtnVal, out rtnMsg);
                }
                else if (saveType == "doSaveDraft")
                {
                    complainStatus = "Draft";
                    rtnVal = "Success";
                }

                if (rtnVal.Equals("Success"))
                {
                    DoSaveReturn(saveType);
                    SaveComplainCrmInfo(complainStatus);                    
                }
                else
                {
                    throw new Exception(rtnMsg);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //[AjaxMethod]
        //public string CheckReturnType()
        //{
        //    string rtnMsg = "Success";
        //    string warehouse = this.hiddenWarehouseId.Text;

        //    if (!string.IsNullOrEmpty(warehouse) && warehouse != "00000000-0000-0000-0000-000000000000")
        //    {
        //        DataTable dt = _business.GetWarehouseTypeById(new Guid(warehouse)).Tables[0];

        //        string whmType = dt.Rows[0]["TypeFrom"].ToString();
        //        string dealerType = dt.Rows[0]["DealerType"].ToString();

        //        if (dealerType == DealerType.T2.ToString() && this.RETURNTYPE.SelectedItem.Value != "11" && this.RETURNTYPE.SelectedItem.Value != "13" && whmType == "LP")
        //        {
        //            this.RETURNTYPE.Value = "11";
        //            rtnMsg = "平台物权产品只能选择退款";
        //        }
        //        else if (_context.User.CorpType == DealerType.T2.ToString() && whmType == "T2" && Convert.ToDecimal(hiddenConvertFactor.Text) > 1)
        //        {
        //            this.RETURNTYPE.Value = "11";
        //            rtnMsg = "二级物权产品的多片包装产品只能选择退款";
        //        }
        //        else if (whmType == "BSC" && this.RETURNTYPE.SelectedItem.Value != "12" && Convert.ToDecimal(hiddenConvertFactor.Text) == 1)
        //        {
        //            this.RETURNTYPE.Value = "12";
        //            rtnMsg = "波科物权产品只能选择只退不换";
        //        }
        //        else if (whmType == "BSC" && Convert.ToDecimal(hiddenConvertFactor.Text) > 1)
        //        {
        //            this.RETURNTYPE.Value = "11";
        //            rtnMsg = "波科物权产品请先整盒买断后单片退款";
        //        }
        //    }
        //    else if (warehouse == "00000000-0000-0000-0000-000000000000")//销售到医院
        //    {
        //        if (this.RETURNTYPE.SelectedItem.Value != "11" && Convert.ToDecimal(hiddenConvertFactor.Text) > 1)
        //        {
        //            this.RETURNTYPE.Value = "11";
        //            rtnMsg = "医院物权产品多片包装只能选择退款";
        //        }
        //        else if (this.RETURNTYPE.SelectedItem.Value != "10" && Convert.ToDecimal(hiddenConvertFactor.Text) == 1)
        //        {
        //            this.RETURNTYPE.Value = "10";
        //            rtnMsg = "医院物权产品整盒装只能选择换货";
        //        }
        //    }

        //    return rtnMsg;
        //}

        private string GetReturnType()
        {
            string right = getPropertyRights();
            bool isScrappedCfn = this.hiddenCFN_Property4.Text.Trim() == "-1";
            decimal convertFact = Convert.ToDecimal(hiddenConvertFactor.Text);
            string returnType = string.Empty;

            if (!string.IsNullOrEmpty(right))
            {
                if (isScrappedCfn) //停产
                {
                    if (right == PropertyRightsType.T2物权.ToString() ||
                        right == PropertyRightsType.平台物权.ToString() ||
                        right == PropertyRightsType.T1物权.ToString() ||
                        right == PropertyRightsType.医院物权.ToString())
                    {
                        returnType = "11"; //退款
                    }
                    if (right == PropertyRightsType.波科物权.ToString())
                    {
                        returnType = "12"; //仅上报投诉，只退不换
                    }
                    if (right == PropertyRightsType.波科内部使用.ToString())
                    {
                        returnType = "12"; //仅上报投诉，只退不换
                    }
                }
                else
                {
                    if (convertFact > 1) //多包装
                    {
                        if (right == PropertyRightsType.T2物权.ToString() ||
                            right == PropertyRightsType.平台物权.ToString() ||
                            right == PropertyRightsType.T1物权.ToString() ||
                            right == PropertyRightsType.医院物权.ToString())
                        {
                            returnType = "11"; //退款
                        }
                        if (right == PropertyRightsType.波科物权.ToString())
                        {
                            returnType = "12"; //仅上报投诉，只退不换
                        }
                        if (right == PropertyRightsType.波科内部使用.ToString())
                        {
                            returnType = "12"; //仅上报投诉，只退不换
                        }
                    }
                    else
                    {
                        //单包装
                        if (right == PropertyRightsType.T2物权.ToString() ||
                            right == PropertyRightsType.T1物权.ToString() ||
                            right == PropertyRightsType.医院物权.ToString())
                        {
                            returnType = "10"; //换货
                        }
                        if (right == PropertyRightsType.平台物权.ToString())
                        {
                            returnType = "11"; //退款
                        }
                        if (right == PropertyRightsType.波科物权.ToString() ||
                            right == PropertyRightsType.波科内部使用.ToString())
                        {
                            returnType = "12"; //仅上报投诉，只退不换
                        }
                    }
                }
            }
            return returnType;
        }

        [AjaxMethod]
        public string CheckReturnType()
        {
            string rtnMsg = "Success";
            string returnType = GetReturnType();

            if (this.hiddenRETURNTYPE.Text != returnType)
            {
                rtnMsg = "产品退货或换货类型不正确";
            }

            return rtnMsg;
        }

        private string getPropertyRights()
        {
            string prodType = this.GetRadioGroupValue(PRODUCTTYPE);
            if (string.IsNullOrEmpty(prodType))
            {
                prodType = "13";
            }
            if (prodType != "")
            {
                if (prodType != "13")
                {
                    return PropertyRightsType.波科内部使用.ToString();
                }
                else
                {
                    string warehouse = this.hiddenWarehouseId.Text;

                    if (!string.IsNullOrEmpty(warehouse) && warehouse != "00000000-0000-0000-0000-000000000000")
                    {
                        DataTable dt = _business.GetWarehouseTypeById(new Guid(warehouse)).Tables[0];

                        string whmType = dt.Rows[0]["TypeFrom"].ToString();
                        string dealerType = dt.Rows[0]["DealerType"].ToString();
                        string propertyRight = string.Empty;

                        if (whmType == "T2")
                        {
                            if (dealerType == DealerType.T2.ToString())
                                return PropertyRightsType.T2物权.ToString();
                            if (dealerType == DealerType.T1.ToString())
                                return PropertyRightsType.T2物权.ToString();
                            if (dealerType == DealerType.LS.ToString())
                                return PropertyRightsType.平台物权.ToString();
                            if (dealerType == DealerType.LP.ToString())
                                return PropertyRightsType.平台物权.ToString();
                        }
                        if (whmType == "BSC")
                            return PropertyRightsType.波科物权.ToString();
                        if (whmType == "LP")
                            return PropertyRightsType.平台物权.ToString();
                        if (whmType == "Frozen")
                        {
                            if (dealerType == DealerType.T2.ToString())
                                return PropertyRightsType.T2物权.ToString();
                            if (dealerType == DealerType.T1.ToString())
                                return PropertyRightsType.T1物权.ToString();
                            if (dealerType == DealerType.LS.ToString())
                                return PropertyRightsType.平台物权.ToString();
                            if (dealerType == DealerType.LP.ToString())
                                return PropertyRightsType.平台物权.ToString();
                        }
                    }
                    else if (warehouse == "00000000-0000-0000-0000-000000000000") //销售到医院
                    {
                        return PropertyRightsType.医院物权.ToString();
                    }
                }
            }

            return "";
        }

        [AjaxMethod]
        public void LoadDealerInfo()
        {
            if (!string.IsNullOrEmpty(this.hiddenInitDealerId.Text))
            {
                BSCSOLDTONAME.Text = string.Empty;
                BSCSOLDTOCITY.Text = string.Empty;
                BSCSOLDTOACCOUNT.Text = string.Empty;
                SUBSOLDTONAME.Text = string.Empty;
                SUBSOLDTOCITY.Text = string.Empty;

                DealerMaster dealerInfo = _dealers.GetDealerMaster(new Guid(this.hiddenInitDealerId.Text));

                if (dealerInfo.DealerType == DealerType.LP.ToString())
                {
                    ISPLATFORM_1.Checked = true;
                    ISPLATFORM_2.Checked = false;
                    BSCSOLDTONAME.Text = dealerInfo.ChineseName;
                    BSCSOLDTOCITY.Text = dealerInfo.City;
                    BSCSOLDTOACCOUNT.Text = dealerInfo.SapCode;
                }
                else if (dealerInfo.DealerType == DealerType.T1.ToString())
                {
                    ISPLATFORM_1.Checked = false;
                    ISPLATFORM_2.Checked = true;
                    BSCSOLDTONAME.Text = dealerInfo.ChineseName;
                    BSCSOLDTOCITY.Text = dealerInfo.City;
                    BSCSOLDTOACCOUNT.Text = dealerInfo.SapCode;
                }
                else if (dealerInfo.DealerType == DealerType.LS.ToString())
                {
                    ISPLATFORM_1.Checked = false;
                    ISPLATFORM_2.Checked = true;
                    BSCSOLDTONAME.Text = dealerInfo.ChineseName;
                    BSCSOLDTOCITY.Text = dealerInfo.City;
                    BSCSOLDTOACCOUNT.Text = dealerInfo.SapCode;
                }
                else if (dealerInfo.DealerType == DealerType.T2.ToString())
                {
                    ISPLATFORM_1.Checked = false;
                    ISPLATFORM_2.Checked = true;
                    SUBSOLDTONAME.Text = dealerInfo.ChineseName;
                    SUBSOLDTOCITY.Text = dealerInfo.City;

                    if (dealerInfo.ParentDmaId.HasValue)
                    {
                        DealerMaster parentDmaInfo = _dealers.GetDealerMaster(dealerInfo.ParentDmaId.Value);
                        BSCSOLDTONAME.Text = parentDmaInfo.ChineseName;
                        BSCSOLDTOCITY.Text = parentDmaInfo.City;
                        BSCSOLDTOACCOUNT.Text = parentDmaInfo.SapCode;
                    }
                }
            }
        }

        [AjaxMethod]
        public void DeleteAttachment(string attachmentType, string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = string.Empty;
                if (attachmentType == AttachmentType.DealerComplainCNFRtn.ToString())
                {
                    uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DealerComplainCNFRtn");
                }
                else
                {
                    uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DealerComplainCNF");
                }
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持" + "\r\n" + ex.Message).Show();
            }
        }
        #endregion

        #region Private Method
        private void InitForm()
        {
            //绑定经销商
            base.Bind_AllDealerList(DealerStore, true);
            this.cbDealer.Disabled = true;
            this.CompletedName.Disabled = false;

            this.ConfirmUpdateDate = DateTime.Now;
            this.LastUpdateDate = DateTime.Now;
            this.DateReceipt.SelectedDate = DateTime.Now;

            this.EID.Text = _context.User.FullName;
            this.REQUESTDATE.SelectedDate = DateTime.Now;
            this.INITIALJOB.Text = "代理商";
            this.INITIALJOB.Enabled = false;
            this.NOTIFYDATE.Text = DateTime.Now.ToString("yyyy-MM-dd");
            this.NOTIFYDATE.Enabled = false;
            //this.REQUESTDATE.SelectedDate = DateTime.Now;
            this.hiddenInitUserId.Text = _context.User.Id.ToUpper();
            this.hidInstanceId.Value = this.InstanceId;

            if (_context.User.IdentityType == IdentityType.User.ToString())
            {
                //CompletedName.SelectedItem.Value = _context.User.LoginId;
                this.cbDealer.Disabled = false;
                this.CompletedName.Disabled = true;
                this.hiddenBscUserId.Text = _context.User.LoginId.ToUpper();
            }
            else
            {
                this.hiddenInitDealerId.Value = _context.User.CorpId.Value.ToString();
            }

            //初始化菜单
            this.btnExportForm.Disabled = true;
            this.btnQaReceipt.Disabled = true;
            this.btnQaSaveDraft.Disabled = true;
            this.btnQASubmit.Disabled = true;
            this.btnQAReject.Disabled = true;
            this.btnDealerConfirm.Disabled = true;
            this.btnSaveDraft.Disabled = true;
            this.btnCarrieSubmit.Disabled = true;

            this.btnSaveReturnDraft.Disabled = true;
            this.btnSubmitReturn.Disabled = true;

            //时间发生国家默认为China
            this.hiddenCompalinStatus.Text = "Draft";
            this.txtComplainStatus.Text = "草稿";
            this.LastUpdateDate = DateTime.Now;
            this.btnExportForm.Hidden = true;
            this.btnQaReceipt.Hidden = true;
            this.btnQaSaveDraft.Hidden = true;
            this.btnQASubmit.Hidden = true;
            this.btnQAReject.Hidden = true;
            this.btnDealerConfirm.Hidden = true;
            this.btnSaveDraft.Hidden = true;
            this.btnCarrieSubmit.Hidden = true;

            this.btnSaveReturnDraft.Hidden = true;
            this.btnSubmitReturn.Hidden = true;

            //医生尝试处理事件的行动和对患者造成的后果
            //this.etfOtherTreatDesc.Hidden = true;
            //this.etfBloodDesc.Hidden = true;
            //this.etfMedicationDesc.Hidden = true;
            //this.etfInPatientDesc.Hidden = true;
            //this.etfSurgeryDesc.Hidden = true;



        }
        private void LoadBSCInfo()
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", this.InstanceId);
            param.Add("ComplainType", "BSC");
            var table = _business.DealerComplainInfo(param);
            if (table.Rows.Count == 0) return;
            var r = table.Rows[0];

            if (r["DC_CorpId"] != DBNull.Value)
            {
                this.hiddenInitDealerId.Value = r["DC_CorpId"].ToString();
            }
            if (r["DC_ConfirmUpdateDate"] != DBNull.Value)
            {
                this.ConfirmUpdateDate = DateTime.Parse(r["DC_ConfirmUpdateDate"].ToString());
            }

            this.txtComplainNo.Text = r["DC_ComplainNbr"].ToString();
            this.txtQRCodeView.Text = r["QrCode"].ToString();
            this.hiddenCompalinStatus.Text = r["DC_Status"].ToString();
            this.txtComplainStatus.Text = DictionaryHelper.GetDictionaryNameById(SR.CONST_QAComplainReturn_Status, this.hiddenCompalinStatus.Text);



            this.hiddenBscUserId.Text = r["BSCSALESNAME"].ToString();

            this.LastUpdateDate = DateTime.Parse(r["DC_LastModifiedDate"].ToString());
            this.hiddenInitUserId.Text = r["DC_CreatedBy"].ToString().ToUpper();

            this.etfOtherDec.Text = r["NORETURNREASON"].ToString();

            #region TEXTFIELD
            EID.Text = r["IDENTITY_NAME"].ToString();
            BSCSalesPhone.Text = r["BSCSALESPHONE"].ToString();
            INITIALNAME.Text = r["INITIALNAME"].ToString();
            INITIALPHONE.Text = r["INITIALPHONE"].ToString();
            INITIALJOB.Text = r["INITIALJOB"].ToString();
            INITIALEMAIL.Text = r["INITIALEMAIL"].ToString();
            PHYSICIAN.Text = r["PHYSICIAN"].ToString();
            PHYSICIANPHONE.Text = r["PHYSICIANPHONE"].ToString();
            APPLYNO.Text = r["DC_ComplainNbr"].ToString();
            NOTIFYDATE.Text = Convert.ToDateTime(r["NOTIFYDATE"]).ToString("yyyy-MM-dd");
            COMPLAINTID.Text = r["COMPLAINTID"].ToString();
            REFERBOX.Text = r["REFERBOX"].ToString();



            BSCSOLDTOACCOUNT.Text = r["BSCSOLDTOACCOUNT"].ToString();
            BSCSOLDTONAME.Text = r["BSCSOLDTONAME"].ToString();
            BSCSOLDTOCITY.Text = r["BSCSOLDTOCITY"].ToString();
            SUBSOLDTONAME.Text = r["SUBSOLDTONAME"].ToString();
            SUBSOLDTOCITY.Text = r["SUBSOLDTOCITY"].ToString();
            DISTRIBUTORCUSTOMER.Text = r["DISTRIBUTORCUSTOMER"].ToString();
            DISTRIBUTORCITY.Text = r["DISTRIBUTORCITY"].ToString();
            cbUPN.Text = r["UPN"].ToString();
            cbUPN_hid.Text = r["UPN"].ToString();
            if (IsDealer)
            {
                cbLOT.Text = r["LOT"].ToString();
                this.cbLOT_hid.Text = r["LOT"].ToString();
            }
            else
            {
                cbLOT.Text = r["LOT"].ToString().Split('@')[0];
                this.cbLOT_hid.Text = r["LOT"].ToString().Split('@')[0];
            }
            DESCRIPTION.Text = r["DESCRIPTION"].ToString();
            hiddenDESCRIPTION.Text = DESCRIPTION.Text;
            BU.Text = r["BU"].ToString();
            //this.hiddenProductLineId.Text = selectedRows[0]["ProductLineId"];
            hiddenBu.Text = BU.Text;
            //hiddenBuCode.Text = r["BUCode"].ToString();
            TBNUM.Text = r["RETURNNUM"].ToString();
            hiddenTBNUM.Text = TBNUM.Text;
            ConvertFactor.Text = r["CONVERTFACTOR"].ToString();
            hiddenConvertFactor.Text = ConvertFactor.Text;
            hiddenCFN_Property4.Text = r["CFN_Property4"].ToString();

            PREPROCESSOR.Text = r["PREPROCESSOR"].ToString();
            UPNQUANTITY.Text = r["UPNQUANTITY"].ToString();
            PNAME.Text = r["PNAME"].ToString();
            INDICATION.Text = r["INDICATION"].ToString();
            GENERATORTYPE.Text = r["GENERATORTYPE"].ToString();
            GENERATORSET.Text = r["GENERATORSET"].ToString();
            EDESCRIPTION.Text = r["EDESCRIPTION"].ToString();
            NOLABELEDUSE.Text = r["NOLABELEDUSE"].ToString();

            etfHospitalName_China.Text = r["HospitalCn"].ToString();
            etfHospitalName_USA.Text = r["HospitalEn"].ToString();
            etfPatientID.Text = r["PatientName"].ToString();
            //etfPatientID.Text = r["PatientNum"].ToString();
            etfOCCurPatientAge.Text = r["PatientAge"].ToString();
            etfAgeUint.Text = r["PatientSexUom"].ToString();
            etfPatientWeight.Text = r["PatientWeight"].ToString();
            etfAnatomy.Text = r["AnatomicSite"].ToString();
            etfSurgeryDesc.Text = r["SurgeryRemark"].ToString();
            etfInPatientDesc.Text = r["HospitalizationRemark"].ToString();
            etfMedicationDesc.Text = r["MedicineRemark"].ToString();
            etfBloodDesc.Text = r["BloodTransfusionRemark"].ToString();
            etfOtherTreatDesc.Text = r["OtherInterventionalRemark"].ToString();

            PermanentDamageRemark.Text = r["PermanentDamageRemark"].ToString();
            SeriousRemark.Text = r["SeriousRemark"].ToString();
            NotSeriousRemark.Text = r["NotSeriousRemark"].ToString();

            #endregion

            #region CHECKBOXGROUP
            SetCheckboxGroupValue(NORETURN, r["NORETURN"].ToString());
            SetRadioGroupValue(POUTCOME, r["POUTCOME"].ToString());
            SetCheckboxGroupValue(WHENNOTICED, r["WHENNOTICED"].ToString());
            SetCheckboxGroupValue(CONTACTMETHOD, r["CONTACTMETHOD"].ToString());
            SetCheckboxGroupValue(COMPLAINTSOURCE, r["COMPLAINTSOURCE"].ToString());
            SetCheckboxGroupValue(this.Panel8, "Pulse", r["HandlingEvents"].ToString(), 8);
            #endregion

            #region RADIOGROUP
            //SetRadioGroupValue(this.Panel9, "Dead", r["Consequence"].ToString(), 6);\
            SetRadioGroupValue(WHEREOCCUR, r["WHEREOCCUR"].ToString());
            SetRadioGroupValue(Consequence, r["Consequence"].ToString());
            SetRadioGroupValue(RadioGroupPostmortem, r["DeathRemark"].ToString());
            SetRadioGroupValue(RadioGroupAdult, r["PatientIs18"].ToString());
            SetRadioGroupValue(RadioGroupWeightUint, r["PatientWeightUom"].ToString());
            SetRadioGroupValue(RadioGroupGender, r["PatientSex"].ToString());
            SetRadioGroupValue(EVENTRESOLVED, r["EVENTRESOLVED"].ToString());
            SetRadioGroupValue(WITHLABELEDUSE, r["WITHLABELEDUSE"].ToString());
            SetRadioGroupValue(IVUS, r["IVUS"].ToString());
            SetRadioGroupValue(GENERATOR, r["GENERATOR"].ToString());
            SetRadioGroupValue(PCONDITION, r["PCONDITION"].ToString());
            SetRadioGroupValue(USEDEXPIRY, r["USEDEXPIRY"].ToString());
            //如果是草稿状态，且能够退回的话，则将不能寄回厂家原因的控件置为不可编辑
            if (r["DC_Status"].ToString().Equals("Draft"))
            {
                SetRadioGroupValue(UPNEXPECTED, r["UPNEXPECTED"].ToString());
                if (r["UPNEXPECTED"].ToString().Equals("1"))
                {
                    this.UPNEXPECTED_1.Checked = true;
                    this.UPNQUANTITY.Value = "1";
                    this.NORETURN_10.Disabled = true;
                    this.NORETURN_20.Disabled = true;
                    this.NORETURN_30.Disabled = true;
                    this.NORETURN_40.Disabled = true;
                    this.NORETURN_99.Disabled = true;
                    this.NORETURN_50.Disabled = true;
                    this.etfOtherDec.Disabled = true;
                    this.NORETURN_50.Value = true;
                    this.etfOtherDec.Value = "1";
                }

            }
            else
            {
                SetRadioGroupValue(UPNEXPECTED, r["UPNEXPECTED"].ToString());
            }



            SetRadioGroupValue(SINGLEUSE, r["SINGLEUSE"].ToString());
            if (r["RESTERILIZED"].ToString().Equals("2"))
            {
                this.RESTERILIZED_2.Checked = true;
            }
            else
            {
                this.RESTERILIZED_2.Checked = false;
                SetRadioGroupValue(RESTERILIZED, r["RESTERILIZED"].ToString());
            }


            SetRadioGroupValue(PRODUCTTYPE, r["PRODUCTTYPE"] != DBNull.Value ? r["PRODUCTTYPE"].ToString() : string.Empty);
            SetRadioGroupValue(ISPLATFORM, r["ISPLATFORM"].ToString());
            SetRadioGroupValue(HasFollowOperation, r["HasFollowOperation"].ToString());
            SetRadioGroupValue(FollowOperationStaff, r["FollowOperationStaff"].ToString());
            SetRadioGroupValue(NeedOfferAnalyzeReport, r["NeedOfferAnalyzeReport"].ToString());
            SetRadioGroupValue(NoProblemButLesionNotPass, r["NoProblemButLesionNotPass"].ToString());
            #endregion

            #region ISNULL
            if (r["EDATE"] != null && !String.IsNullOrEmpty(r["EDATE"].ToString()))
            {
                EDATE.SelectedDate = Convert.ToDateTime(r["EDATE"]);
            }
            if (r["IMPLANTEDDATE"] != null && !String.IsNullOrEmpty(r["IMPLANTEDDATE"].ToString()))
            {
                IMPLANTEDDATE.SelectedDate = Convert.ToDateTime(r["IMPLANTEDDATE"]);
            }
            if (r["EXPLANTEDDATE"] != null && !String.IsNullOrEmpty(r["EXPLANTEDDATE"].ToString()))
            {
                EXPLANTEDDATE.SelectedDate = Convert.ToDateTime(r["EXPLANTEDDATE"]);
            }
            if (r["INITIALPDATE"] != null && !String.IsNullOrEmpty(r["INITIALPDATE"].ToString()))
            {
                INITIALPDATE.SelectedDate = Convert.ToDateTime(r["INITIALPDATE"]);
            }
            if (r["PatientBirth"] != null && !String.IsNullOrEmpty(r["PatientBirth"].ToString()))
            {
                edfPatientBrithDate.SelectedDate = Convert.ToDateTime(r["PatientBirth"]);
            }
            if (r["DeathDate"] != null && !String.IsNullOrEmpty(r["DeathDate"].ToString()))
            {
                edtDeadDate.SelectedDate = Convert.ToDateTime(r["DeathDate"]);
            }

            if (r["DC_Status"].ToString().Equals("Draft"))
            {
                this.DateReceipt.SelectedDate = DateTime.Now;
            }
            else
            {
                if (r["DateReceipt"] != null && !String.IsNullOrEmpty(r["DateReceipt"].ToString()))
                {
                    this.DateReceipt.SelectedDate = Convert.ToDateTime(r["DateReceipt"]);
                }
            }

            if (r["SALESDATE"] != null && !String.IsNullOrEmpty(r["SALESDATE"].ToString()))
            {
                this.SalesDate.SelectedDate = DateTime.ParseExact(r["SALESDATE"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                this.hiddenSalesDate.Text = r["SALESDATE"].ToString();
            }
            if (r["UPNEXPDATE"] != null && !String.IsNullOrEmpty(r["UPNEXPDATE"].ToString()))
            {
                this.UPNExpDate.Text = r["UPNEXPDATE"] != DBNull.Value ? r["UPNEXPDATE"].ToString() : string.Empty;
                this.hiddenExpiredDate.Text = this.UPNExpDate.Text;
            }
            if (r["HasSalesDate"] != null && !String.IsNullOrEmpty(r["HasSalesDate"].ToString()))
            {
                this.hiddenHasSalesDate.Text = Convert.ToBoolean(r["HasSalesDate"].ToString()) ? "1" : "0";
            }
            else
            {
                this.hiddenHasSalesDate.Text = "0";
            }
            if (r["REQUESTDATE"] != null && !String.IsNullOrEmpty(r["REQUESTDATE"].ToString()))
            {
                this.REQUESTDATE.SelectedDate = DateTime.Parse(r["REQUESTDATE"].ToString());
            }

            this.hiddenReturnStatus.Text = r["DC_ComplainStatus"] != DBNull.Value ? r["DC_ComplainStatus"].ToString() : string.Empty;
            this.txtReturnStatus.Text = DictionaryHelper.GetDictionaryNameById(SR.CONST_QAComplainReturn_Status, this.hiddenReturnStatus.Text);

            this.txtProductExpiredDate.Text = r["UPNEXPDATE"] != DBNull.Value ? r["UPNEXPDATE"].ToString() : string.Empty;
            if (r["FollowOperationDate"] != DBNull.Value && !String.IsNullOrEmpty(r["FollowOperationDate"].ToString()))
            {
                this.FollowOperationDate.SelectedDate = DateTime.ParseExact(r["FollowOperationDate"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
            }
            #endregion

            #region RETURN
            this.TW.Text = r["TWNbr"].ToString();
            //this.cbWarehouse.Text = r["WHM_ID"] != DBNull.Value ? r["WHM_ID"].ToString() : string.Empty;
            this.cbWarehouse.Text = r["WarehouseName"] != DBNull.Value ? r["WarehouseName"].ToString() : string.Empty;
            this.hiddenWarehouseId.Text = r["WHM_ID"] != DBNull.Value ? r["WHM_ID"].ToString() : string.Empty;

            this.txtRegistration.Text = r["REGISTRATION"].ToString();
            this.txtLotNumber.Text = this.cbLOT_hid.Text;
            this.Remark.Text = r["Remark"] == DBNull.Value ? string.Empty : r["Remark"].ToString();
            this.txtQrCode.Text = r["QrCode"] != DBNull.Value ? r["QrCode"].ToString() : string.Empty;
            this.hiddenQrCode.Text = this.txtQrCode.Text;
            this.DNNo.Text = r["DN"].ToString();
            this.CarrierNumber.Text = r["CarrierNumber"] == DBNull.Value ? string.Empty : r["CarrierNumber"].ToString();
            this.hiddenRETURNTYPE.Text = r["RETURNTYPE"] != DBNull.Value ? r["RETURNTYPE"].ToString() : string.Empty;
            this.RETURNTYPE.SelectedItem.Value = this.hiddenRETURNTYPE.Text;
            this.SetRadioGroupValue(this.PRODUCTTYPE, r["PRODUCTTYPE"] != DBNull.Value ? r["PRODUCTTYPE"].ToString() : string.Empty);
            this.PropertyRights.Text = r["PropertyRights"] == DBNull.Value ? string.Empty : r["PropertyRights"].ToString();

            this.ReturnProductRegisterNo.Text = r["REFERBOX"].ToString();
            this.CourierCompany.Text = r["CourierCompany"] == DBNull.Value ? string.Empty : r["CourierCompany"].ToString();
            this.ConfirmReturnOrRefund.SelectedItem.Value = r["ConfirmReturnOrRefund"] == DBNull.Value ? string.Empty : r["ConfirmReturnOrRefund"].ToString();
            this.ReturnFactoryTrackingNo.Text = r["ReturnFactoryTrackingNo"] == DBNull.Value ? string.Empty : r["ReturnFactoryTrackingNo"].ToString();
            this.SetRadioGroupValue(this.ReceiveReturnedGoods, r["ReceiveReturnedGoods"] != DBNull.Value ? r["ReceiveReturnedGoods"].ToString() : string.Empty);
            if (r["ReceiveReturnedGoodsDate"] != DBNull.Value && !String.IsNullOrEmpty(r["ReceiveReturnedGoodsDate"].ToString()))
            {
                this.ReceiveReturnedGoodsDate.SelectedDate = DateTime.Parse(r["ReceiveReturnedGoodsDate"].ToString());
            }
            #endregion

            //绑定波科人员
            if (this.hiddenCompalinStatus.Text != "Draft")
            {
                this.BindBscEmployeeMaster();
            }

        }
        private String GenerateInfoXML()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<DealerComplain>");

            sb.Append("<TW>" + this.TW.Text + "</TW>");
            sb.Append("<DateReceipt>" + (this.DateReceipt.IsNull ? "" : DateReceipt.SelectedDate.ToString("yyyy-MM-dd")) + "</DateReceipt>");

            //UPN
            sb.Append("<Serial>" + this.cbUPN_hid.Text.Trim() + "</Serial>");
            //Lot
            sb.Append("<Lot>" + this.cbLOT_hid.Text.Trim() + "</Lot>");
            //首次手术日期
            sb.Append("<INITIALPDATE>" + (INITIALPDATE.IsNull ? "" : INITIALPDATE.SelectedDate.ToString("yyyy-MM-dd")) + "</INITIALPDATE>");
            //事件发生日期
            sb.Append("<EDATE>" + (EDATE.IsNull ? "" : EDATE.SelectedDate.ToString("yyyy-MM-dd")) + "</EDATE>");
            //申请人
            sb.Append("<EID>" + _context.User.Id + "</EID>");
            //申请日期
            sb.Append("<REQUESTDATE>" + (REQUESTDATE.IsNull ? "" : REQUESTDATE.SelectedDate.ToString("yyyy-MM-dd")) + "</REQUESTDATE>");
            //销售人员姓名
            //sb.Append("<BSCSalesName>" + this.BSCSalesName.Text.Trim() + "</BSCSalesName>");
            sb.Append("<BSCSalesName>" + this.hiddenBscUserId.Text.Trim() + "</BSCSalesName>");
            // sb.Append("<CompletedTitle>" + CompletedTitle.Text.Trim() + "</CompletedTitle>");

            //销售人员电话
            sb.Append("<BSCSalesPhone>" + this.BSCSalesPhone.Text.Trim() + "</BSCSalesPhone>");
            //原报告人职业
            sb.Append("<INITIALJOB>" + this.INITIALJOB.Text.Trim() + "</INITIALJOB>");
            //原报告人姓名
            sb.Append("<INITIALNAME>" + this.INITIALNAME.Text.Trim() + "</INITIALNAME>");
            //原报告人电话
            sb.Append("<INITIALPHONE>" + this.INITIALPHONE.Text.Trim() + "</INITIALPHONE>");
            //医生电话
            sb.Append("<PHYSICIANPHONE>" + this.PHYSICIANPHONE.Text.Trim() + "</PHYSICIANPHONE>");
            //原报告人Email
            sb.Append("<INITIALEMAIL>" + this.INITIALEMAIL.Text.Trim() + "</INITIALEMAIL>");
            //医生姓名
            sb.Append("<PHYSICIAN>" + this.PHYSICIAN.Text.Trim() + "</PHYSICIAN>");
            //投诉通知日期
            sb.Append("<NOTIFYDATE>" + this.NOTIFYDATE.Text.Trim() + "</NOTIFYDATE>");
            //联系方式
            sb.Append("<CONTACTMETHOD>" + this.GetCheckboxGroupValue(CONTACTMETHOD) + "</CONTACTMETHOD>");
            //投诉来源
            sb.Append("<COMPLAINTSOURCE>" + this.GetCheckboxGroupValue(COMPLAINTSOURCE) + "</COMPLAINTSOURCE>");
            //是否是平台
            sb.Append("<ISPLATFORM>" + this.GetRadioGroupValue(ISPLATFORM) + "</ISPLATFORM>");
            //一级经销商账号
            sb.Append("<BSCSOLDTOACCOUNT>" + this.BSCSOLDTOACCOUNT.Text.Trim() + "</BSCSOLDTOACCOUNT>");
            //一级经销商名称
            sb.Append("<BSCSOLDTONAME>" + this.BSCSOLDTONAME.Text.Trim() + "</BSCSOLDTONAME>");
            //一级经销商所在城市
            sb.Append("<BSCSOLDTOCITY>" + this.BSCSOLDTOCITY.Text.Trim() + "</BSCSOLDTOCITY>");
            //二级经销商名称
            sb.Append("<SUBSOLDTONAME>" + this.SUBSOLDTONAME.Text.Trim() + "</SUBSOLDTONAME>");
            //二级经销商所在城市
            sb.Append("<SUBSOLDTOCITY>" + this.SUBSOLDTOCITY.Text.Trim() + "</SUBSOLDTOCITY>");
            //医院名称
            sb.Append("<DISTRIBUTORCUSTOMER>" + this.DISTRIBUTORCUSTOMER.Text.Trim() + "</DISTRIBUTORCUSTOMER>");
            //医院所在城市
            sb.Append("<DISTRIBUTORCITY>" + this.DISTRIBUTORCITY.Text.Trim() + "</DISTRIBUTORCITY>");
            //医院中文名称
            sb.Append("<etfHospitalName_China>" + this.etfHospitalName_China.Text.Trim() + "</etfHospitalName_China>");
            //医院英文城市
            sb.Append("<etfHospitalName_USA>" + this.etfHospitalName_USA.Text.Trim() + "</etfHospitalName_USA>");
            //UPN描述
            sb.Append("<DESCRIPTION>" + this.hiddenDESCRIPTION.Text.Trim() + "</DESCRIPTION>");
            //包装数
            sb.Append("<ConvertFactor>" + this.hiddenConvertFactor.Text.Trim() + "</ConvertFactor>");
            //是否停产
            sb.Append("<CFN_Property4>" + this.hiddenCFN_Property4.Text.Trim() + "</CFN_Property4>");
            //是否为一次性器械
            sb.Append("<SINGLEUSE>" + this.GetRadioGroupValue(SINGLEUSE) + "</SINGLEUSE>");
            //UPN所属业务部门
            sb.Append("<BU>" + this.hiddenBu.Text.Trim() + "</BU>");
            //产品数量
            sb.Append("<TBNUM>" + this.hiddenTBNUM.Text.Trim() + "</TBNUM>");
            //能否重复消毒
            sb.Append("<RESTERILIZED>" + this.GetRadioGroupValue(RESTERILIZED) + "</RESTERILIZED>");
            //如果该器械经过再次处理后用户患者
            sb.Append("<PREPROCESSOR>" + this.PREPROCESSOR.Text.Trim() + "</PREPROCESSOR>");
            //是否在有效期后使用
            sb.Append("<USEDEXPIRY>" + this.GetRadioGroupValue(USEDEXPIRY) + "</USEDEXPIRY>");
            //产品能否退回
            sb.Append("<UPNEXPECTED>" + this.GetRadioGroupValue(UPNEXPECTED) + "</UPNEXPECTED>");
            //退回的数量
            sb.Append("<UPNQUANTITY>" + this.UPNQUANTITY.Text.Trim() + "</UPNQUANTITY>");
            //不能寄回厂家的原因
            sb.Append("<NORETURN>" + this.GetCheckboxGroupValue(NORETURN) + "</NORETURN>");
            //其他 - 请说明
            sb.Append("<etfOtherDec>" + this.etfOtherDec.Text.Trim() + "</etfOtherDec>");
            //患者标识（ID）
            sb.Append("<etfPatientID>" + this.etfPatientID.Text.Trim() + "</etfPatientID>");
            //事件发生时患者的年龄
            sb.Append("<etfOCCurPatientAge>" + this.etfOCCurPatientAge.Text.Trim() + "</etfOCCurPatientAge>");
            //年龄单位
            sb.Append("<etfAgeUint>" + this.etfAgeUint.Text.Trim() + "</etfAgeUint>");
            //患者是否未满18岁
            sb.Append("<RadioGroupAdult>" + this.GetRadioGroupValue(RadioGroupAdult) + "</RadioGroupAdult>");
            //患者出生日期
            sb.Append("<edfPatientBrithDate>" + (edfPatientBrithDate.IsNull ? "" : edfPatientBrithDate.SelectedDate.ToString("yyyy-MM-dd")) + "</edfPatientBrithDate>");
            //患者性别
            sb.Append("<RadioGroupGender>" + this.GetRadioGroupValue(RadioGroupGender) + "</RadioGroupGender>");
            //患者体重
            sb.Append("<etfPatientWeight>" + this.etfPatientWeight.Text.Trim() + "</etfPatientWeight>");
            //体重单位
            sb.Append("<RadioGroupWeightUint>" + this.GetRadioGroupValue(RadioGroupWeightUint) + "</RadioGroupWeightUint>");
            //解剖部位/病变部位
            sb.Append("<etfAnatomy>" + this.etfAnatomy.Text.Trim() + "</etfAnatomy>");
            //手术名称
            sb.Append("<PNAME>" + this.PNAME.Text.Trim() + "</PNAME>");
            //手术指征
            sb.Append("<INDICATION>" + this.INDICATION.Text.Trim() + "</INDICATION>");
            //植入日期
            sb.Append("<IMPLANTEDDATE>" + (IMPLANTEDDATE.IsNull ? "" : IMPLANTEDDATE.SelectedDate.ToString("yyyy-MM-dd")) + "</IMPLANTEDDATE>");
            //移出日期
            sb.Append("<EXPLANTEDDATE>" + (EXPLANTEDDATE.IsNull ? "" : EXPLANTEDDATE.SelectedDate.ToString("yyyy-MM-dd")) + "</EXPLANTEDDATE>");
            //手术结果
            sb.Append("<POUTCOME>" + this.GetRadioGroupValue(POUTCOME) + "</POUTCOME>");
            //是否使用了IVUS
            sb.Append("<IVUS>" + this.GetRadioGroupValue(IVUS) + "</IVUS>");
            //是否使用了电刀
            sb.Append("<GENERATOR>" + this.GetRadioGroupValue(GENERATOR) + "</GENERATOR>");
            //电刀类型说明
            sb.Append("<GENERATORTYPE>" + this.GENERATORTYPE.Text.Trim() + "</GENERATORTYPE>");
            //电刀设置
            sb.Append("<GENERATORSET>" + this.GENERATORSET.Text.Trim() + "</GENERATORSET>");
            //患者术后状况如何
            sb.Append("<PCONDITION>" + this.GetRadioGroupValue(PCONDITION) + "</PCONDITION>");
            //问题发生在什么位置
            sb.Append("<WHEREOCCUR>" + this.GetRadioGroupValue(WHEREOCCUR) + "</WHEREOCCUR>");
            //发现问题的时间
            sb.Append("<WHENNOTICED>" + this.GetCheckboxGroupValue(WHENNOTICED) + "</WHENNOTICED>");
            //事件描述
            sb.Append("<EDESCRIPTION>" + this.EDESCRIPTION.Text.Trim() + "</EDESCRIPTION>");
            //是在按标示使用器械的<br />情况下发生该问题的吗
            sb.Append("<WITHLABELEDUSE>" + this.GetRadioGroupValue(WITHLABELEDUSE) + "</WITHLABELEDUSE>");
            //如果不是，请解释
            sb.Append("<NOLABELEDUSE>" + this.NOLABELEDUSE.Text.Trim() + "</NOLABELEDUSE>");
            //事情是否已解决
            sb.Append("<EVENTRESOLVED>" + this.GetRadioGroupValue(EVENTRESOLVED) + "</EVENTRESOLVED>");
            //观察

            sb.Append("<HandlingEvents>" + GetCheckboxGroupValue(Panel8, "Pulse", 8) + "</HandlingEvents>");
            //手术治疗（请说明）
            //请说明手术治疗
            sb.Append("<SurgeryRemark>" + this.etfSurgeryDesc.Text.Trim() + "</SurgeryRemark>");
            //住院或延长住院时间
            //请说明住院时间和原因
            sb.Append("<HospitalizationRemark>" + this.etfInPatientDesc.Text.Trim() + "</HospitalizationRemark>");
            //药物治疗
            //请说明药物治疗
            sb.Append("<MedicineRemark>" + this.etfMedicationDesc.Text.Trim() + "</MedicineRemark>");
            //取出器材
            //输血/血液制品
            //请说明输血/血液制品
            sb.Append("<BloodTransfusionRemark>" + this.etfBloodDesc.Text.Trim() + "</BloodTransfusionRemark>");
            //其他介入治疗（请说明）
            //请说明其他介入治疗
            sb.Append("<OtherInterventionalRemark>" + this.etfOtherTreatDesc.Text.Trim() + "</OtherInterventionalRemark>");
            //sb.Append("<Consequence>" + GetRadioGroupValue(Panel9, "Dead", 6) + "</Consequence>");
            sb.Append("<Consequence>" + GetRadioGroupValue(Consequence) + "</Consequence>");
            //死亡
            //死亡日期
            sb.Append("<edtDeadDate>" + (edtDeadDate.IsNull ? "" : edtDeadDate.SelectedDate.ToString("yyyy-MM-dd")) + "</edtDeadDate>");
            //如果是死亡请提供尸检报告/尸检证明
            sb.Append("<RadioGroupPostmortem>" + this.GetRadioGroupValue(RadioGroupPostmortem) + "</RadioGroupPostmortem>");
            //未严重受伤
            //请说明未严重受伤
            sb.Append("<NotSeriousRemark>" + this.NotSeriousRemark.Text.Trim() + "</NotSeriousRemark>");
            //严重受伤
            //请说明严重受伤
            sb.Append("<SeriousRemark>" + this.SeriousRemark.Text.Trim() + "</SeriousRemark>");
            //某项身体机能永久受损
            //请说明某项身体机能永久受损
            sb.Append("<PermanentDamageRemark>" + this.PermanentDamageRemark.Text.Trim() + "</PermanentDamageRemark>");
            //投诉号码
            sb.Append("<COMPLAINTID>" + this.COMPLAINTID.Text.Trim() + "</COMPLAINTID>");
            //收到返回产品登记号
            sb.Append("<REFERBOX>" + this.REFERBOX.Text.Trim() + "</REFERBOX>");




            //产品型号(UPN)请填写产品外包装号码
            sb.Append("<lbupn>" + this.cbUPN_hid.Text.Trim() + "</lbupn>");
            //仓库
            sb.Append("<cbWarehouse>" + Guid.Empty.ToString() + "</cbWarehouse>");
            //产品有效期
            sb.Append("<UPNExpDate></UPNExpDate>");
            //二维码
            sb.Append("<txtQrCode>" + this.hiddenQrCode.Text.Trim() + "</txtQrCode>");
            //注册证
            sb.Append("<txtRegistration>" + this.txtRegistration.Text.Trim() + "</txtRegistration>");
            //销售日期
            sb.Append("<SalesDate></SalesDate>");
            //产品类型
            sb.Append("<PRODUCTTYPE></PRODUCTTYPE>");
            //产品退货或换货
            sb.Append("<RETURNTYPE></RETURNTYPE>");
            //波科确认产品换货或退款
            sb.Append("<CFMRETURNTYPE></CFMRETURNTYPE>");
            //获取单据编号
            sb.Append("<COMPLAINNBR></COMPLAINNBR>");

            //获取是否有跟台
            sb.Append("<HasFollowOperation>" + GetRadioGroupValue(HasFollowOperation) + "</HasFollowOperation>");
            //获取跟台日期
            sb.Append("<FollowOperationDate>" + (FollowOperationDate.IsNull ? "" : FollowOperationDate.SelectedDate.ToString("yyyyMMdd")) + "</FollowOperationDate>");
            //获取跟台人员
            sb.Append("<FollowOperationStaff>" + GetRadioGroupValue(FollowOperationStaff) + "</FollowOperationStaff>");
            //获取是否提供分析报表
            sb.Append("<NeedOfferAnalyzeReport>" + GetRadioGroupValue(NeedOfferAnalyzeReport) + "</NeedOfferAnalyzeReport>");
            //获取是否仅无法通过病变，不存在其他问题
            sb.Append("<NoProblemButLesionNotPass>" + GetRadioGroupValue(NoProblemButLesionNotPass) + "</NoProblemButLesionNotPass>");

            sb.Append("</DealerComplain>");
            return sb.ToString();
        }
        private String GenerateReturnInfoXML()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<DealerComplainReturn>");
            sb.Append("<QrCode>" + this.hiddenQrCode.Text.Trim() + "</QrCode>");
            sb.Append("<WarehouseId>" + this.hiddenWarehouseId.Text.Trim() + "</WarehouseId>");
            sb.Append("<ExpiredDate>" + this.hiddenExpiredDate.Text.Trim() + "</ExpiredDate>");
            sb.Append("<SALESDATECRM>" + this.hiddenSalesDate.Text + "</SALESDATECRM>");
            string productType = this.GetRadioGroupValue(PRODUCTTYPE);
            sb.Append("<PRODUCTTYPECRM>" + (string.IsNullOrEmpty(productType)?"13": productType) + "</PRODUCTTYPECRM>");
            sb.Append("<RETURNTYPECRM>" + this.hiddenRETURNTYPE.Text.Trim() + "</RETURNTYPECRM>");
            sb.Append("<HasSalesDateCRM>" + this.hiddenHasSalesDate.Text.Trim() + "</HasSalesDateCRM>");
            sb.Append("<CARRIERNUMBER>" + this.CarrierNumber.Text.Trim() + "</CARRIERNUMBER>");
            sb.Append("<Remark>" + this.Remark.Text.Trim() + "</Remark>");

            sb.Append("<CourierCompany>" + this.CourierCompany.Text.Trim() + "</CourierCompany>");
            sb.Append("<ConfirmReturnOrRefund>" + this.hiddenRETURNTYPE.Text.Trim() + "</ConfirmReturnOrRefund>");
            sb.Append("<ReturnFactoryTrackingNo>" + this.ReturnFactoryTrackingNo.Text.Trim() + "</ReturnFactoryTrackingNo>");
            sb.Append("<ReceiveReturnedGoods>" + this.GetRadioGroupValue(ReceiveReturnedGoods) + "</ReceiveReturnedGoods>");
            sb.Append("<ReceiveReturnedGoodsDate>" + (ReceiveReturnedGoodsDate.IsNull ? "" : ReceiveReturnedGoodsDate.SelectedDate.ToString("yyyyMMdd")) + "</ReceiveReturnedGoodsDate>");
            if (string.IsNullOrEmpty(this.PropertyRights.Text.Trim()))
            {
                this.PropertyRights.Text = getPropertyRights();
            }
            sb.Append("<PropertyRights>" + this.PropertyRights.Text.Trim() + "</PropertyRights>");

            sb.Append("</DealerComplainReturn>");
            return sb.ToString();
        }
        private void BindBscEmployeeMaster()
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.hiddenInitDealerId.Value.ToString()) &&
               !string.IsNullOrEmpty(this.cbUPN_hid.Text))
            //!string.IsNullOrEmpty(this.hiddenBuCode.Text)
            {
                //param.Add("DmaId", new Guid(this.hiddenInitDealerId.Value.ToString()));
                param.Add("DealerID", new Guid(this.hiddenInitDealerId.Value.ToString()));//_context.User.CorpId.Value
                if (!string.IsNullOrEmpty(Convert.ToString(this.hiddenProductLineId.Value)))
                {
                    param.Add("BU", this.hiddenProductLineId.Value);
                }
                //param.Add("BU", this.hiddenBu.Text);
                //param.Add("BUCode", this.hiddenBuCode.Text);
                //param.Add("UPN", this.cbUPN_hid.Text);
                //param.Add("HosCode", this.DISTRIBUTORCUSTOMER.Text);
            }

            //如果是新增或草稿，则只能选择有效的员工
            //if (this.hiddenCompalinStatus.Text == "Draft")
            //{
            //    param.Add("IsActive", "True");
            //}
            DataSet ds = _business.SelectBscSrForComplain(param);

            this.BscUserStore.DataSource = ds;
            this.BscUserStore.DataBind();
        }
        private void SaveComplainCrmInfo(string complainStatus)
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("UserId", new Guid(_context.User.Id));
            dealerComplainInfo.Add("CorpId", new Guid(this.hiddenInitDealerId.Value.ToString()));
            dealerComplainInfo.Add("ComplainType", "BSC");
            dealerComplainInfo.Add("ComplainStatus", complainStatus);
            dealerComplainInfo.Add("ComplainInfo", GenerateInfoXML());
            dealerComplainInfo.Add("Result", "");

            if (_business.ValidateComplainCanUpdate("BSC", this.InstanceId, this.LastUpdateDate))
            {
                string rtnVal = _business.DealerComplainSaveForNew(dealerComplainInfo);

                if (rtnVal != "Success")
                {
                    throw new Exception(rtnVal);
                }

                if (complainStatus == "Submit")
                {
                    Hashtable param = new Hashtable();
                    param.Add("DC_ID", this.InstanceId);
                    param.Add("ComplainType", "BSC");
                    var table = _business.DealerComplainInfo_SpecialDateFormat(param);
                    /*
                    if (table.Rows.Count > 0)
                    {
                        //发送邮件及附件。
                        string rtnValMail = _business.DealerComplainCNFSendMailWithAttachment(table);

                        if (rtnValMail != "Success")
                        {
                            throw new Exception(rtnValMail);
                        }
                    }
                    */
                }
            }
            else
            {
                throw new Exception("单据状态已改变，请刷新！");
            }
        }
        private void SaveReturnCrmInfo(string returnStatus)
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("CorpId", this.hiddenInitDealerId.Value);
            dealerComplainInfo.Add("ComplainType", "BSC");
            dealerComplainInfo.Add("ReturnStatus", returnStatus);
            dealerComplainInfo.Add("ComplainInfo", this.GenerateReturnInfoXML());
            dealerComplainInfo.Add("Result", "");

            if (_business.ValidateReturnCanUpdate("BSC", this.InstanceId, this.ConfirmUpdateDate))
            {

                string rtnVal = _business.DealerComplainSaveReturn(dealerComplainInfo);

                if (rtnVal != "Success")
                {
                    throw new Exception(rtnVal);
                }
            }
            else
            {
                throw new Exception("单据状态已改变，请刷新！");
            }
        }
        private void UpdateComplainStatus(string Status)
        {
            String rtnVal = string.Empty;
            String rtnMsg = string.Empty;

            _business.UpdateDealerComplainStatusByFilter(CONST_COMPLAIN_TYPE, Status, string.Empty, this.InstanceId, this.LastUpdateDate, out rtnVal, out rtnMsg);

            if (rtnVal != "Success")
            {
                throw new Exception((string.IsNullOrEmpty(rtnMsg) ? "单据状态已改变，请刷新！" : "rtnMsg"));
            }
        }
        private void SetControlStatus()
        {
            this.SalesDate.Disabled = this.hiddenHasSalesDate.Text == "1" ? true : false;
            if (this.hiddenCompalinStatus.Text != "Draft")
            {
                this.btnExportForm.Disabled = false;
                this.btnExportForm.Hidden = false;

                //this.cbLOT_search.Disabled = true;
                //this.cbLOT_search.Hidden = true;
                this.imbtnSearchHospital.Disabled = true;
                this.imbtnSearchHospital.Hidden = true;
                this.imbtnSearchQrCode.Disabled = true;
                this.imbtnSearchQrCode.Hidden = true;

                this.btnUploadAttachment.Disabled = true;
                this.btnUploadAttachment.Hidden = true;
                this.gpAttachment.ColumnModel.SetHidden(5, true);
            }
            //创建人为登录人
            if (this.hiddenInitUserId.Text == _context.User.Id.ToUpper()
                || (_context.User.IdentityType == IdentityType.Dealer.ToString()
                && !string.IsNullOrEmpty(this.hiddenInitDealerId.Text)
                && _context.User.CorpId.Value == new Guid(this.hiddenInitDealerId.Text)))
            {
                if (this.hiddenCompalinStatus.Text == "Draft")
                {
                    this.btnSaveDraft.Disabled = false;
                    this.btnCarrieSubmit.Disabled = false;
                    this.btnSaveDraft.Hidden = false;
                    this.btnCarrieSubmit.Hidden = false;
                    //SetEnable(this.mainPanel, false);
                }
                else
                {
                    SetEnable(this.mainPanel, true);
                }

                //登录人为经销商且为单据中的经销商
                if (_context.User.IdentityType == IdentityType.Dealer.ToString()
                    && !string.IsNullOrEmpty(this.hiddenInitDealerId.Text)
                    && _context.User.CorpId.Value == new Guid(this.hiddenInitDealerId.Text))
                {
                    if (this.hiddenCompalinStatus.Text == "DealerConfirm")
                    {
                        this.btnDealerConfirm.Disabled = false;
                        this.btnDealerConfirm.Hidden = false;
                        //SetEnable(this.mainPanel, false);
                    }
                }
            }

            //QA权限可以使用
            else if (_context.User.IdentityType == IdentityType.User.ToString()
                && (_context.IsInRole("Administrators")|| _context.IsInRole("BP QA库存管理")))
            {
                //投诉已收到
                if (this.hiddenCompalinStatus.Text == "Accept")
                {
                    this.btnQaSaveDraft.Disabled = false;
                    this.btnQASubmit.Disabled = false;
                    this.btnQAReject.Disabled = false;

                    this.btnQaSaveDraft.Hidden = false;
                    this.btnQASubmit.Hidden = false;
                    this.btnQAReject.Hidden = false;

                    this.COMPLAINTID.Disabled = false;
                    this.REFERBOX.Disabled = false;
                    this.TW.Disabled = false;
                    this.cbDealer.Disabled = false;
                }
                else
                {
                    SetEnable(this.mainPanel, true);
                    //单据提交
                    if (this.hiddenCompalinStatus.Text == "Submit")
                    {
                        this.btnQaReceipt.Disabled = false;
                        this.btnQaReceipt.Hidden = false;
                    }
                }
            }
            else
            {
                SetEnable(this.mainPanel, true);
            }

            if (this.hiddenCompalinStatus.Text != "Submit" && this.hiddenCompalinStatus.Text != "Draft")
            {
                this.returnPanel.Hide();
            }

            if (this.hiddenReturnStatus.Text == "Draft" &&
                (this.hiddenCompalinStatus.Text == "Submit"|| this.hiddenCompalinStatus.Text == "Draft")
                && _context.User.IdentityType == IdentityType.Dealer.ToString()
                && !string.IsNullOrEmpty(this.hiddenInitDealerId.Text)
                && _context.User.CorpId.Value == new Guid(this.hiddenInitDealerId.Text))
            {
                //this.btnSaveReturnDraft.Disabled = false;
                //this.btnSubmitReturn.Disabled = false;
                this.imbtnSearchQrCode.Disabled = false;

                //this.btnSaveReturnDraft.Hidden = false;
                //this.btnSubmitReturn.Hidden = false;
                this.imbtnSearchQrCode.Hidden = false;

                this.btnUploadAttachment_Return.Disabled = false;
                this.btnUploadAttachment_Return.Hidden = false;
                this.gpAttachment_Return.ColumnModel.SetHidden(5, false);
            }
            else
            {
                SetEnable(this.returnPanel, true);

                this.btnUploadAttachment_Return.Disabled = true;
                this.btnUploadAttachment_Return.Hidden = true;
                this.gpAttachment_Return.ColumnModel.SetHidden(5, true);
            }

            //确定level2是否未stenets，如果是显示
            if (!string.IsNullOrEmpty(this.cbUPN.Text))
            {
                Cfns cfns = new Cfns();
                Cfn cfn = cfns.GetObjectByUPN(this.cbUPN.Text);
                if (!string.IsNullOrEmpty(cfn.Level2Code) && cfn.Level2Code == "040")
                {
                    this.hiddenUPNLevel2Code.Text = "040";
                    this.NoProblemButLesionNotPass.Hidden = false;
                    this.lblStents.Hidden = false;


                }
                else
                {
                    this.hiddenUPNLevel2Code.Text = "NULL";
                    this.NoProblemButLesionNotPass.Hidden = true;
                    this.lblStents.Hidden = true;

                }
            }

        }
        private void SetEnable(Control c, bool b)
        {
            foreach (Control cc in c.Controls)
            {
                if (cc is TextField)
                {
                    if ((cc as TextField).Attributes["noedit"] != "TRUE")
                    {
                        (cc as TextField).Enabled = !b;
                    }
                }
                else if (cc is DateField)
                {
                    if ((cc as DateField).Attributes["noedit"] != "TRUE")
                    {
                        (cc as DateField).Enabled = !b;
                    }
                }
                else if (cc is NumberField)
                {
                    if ((cc as NumberField).Attributes["noedit"] != "TRUE")
                    {
                        (cc as NumberField).Enabled = !b;
                    }
                }
                else if (cc is CheckboxColumn)
                {
                    foreach (CheckboxColumn ccc in (cc as CheckboxColumn).Items)
                    {
                        SetEnable(ccc, b);
                    }
                }
                else if (cc is Checkbox)
                {
                    if ((cc as Checkbox).Attributes["noedit"] != "TRUE")
                    {
                        (cc as Checkbox).Enabled = !b;
                    }
                }
                else if (cc is ComboBox)
                {
                    if ((cc as ComboBox).Attributes["noedit"] != "TRUE")
                    {
                        (cc as ComboBox).Enabled = !b;
                    }
                }
                else if (cc is CheckboxGroup)
                {
                    CheckboxGroup cg = cc as CheckboxGroup;
                    for (int i = 0; i < cg.Items.Count; i++)
                    {
                        if (cg.Items[i] is CheckboxColumn)
                        {
                            SetEnable(cg.Items[i], b);
                        }
                        else if (cg.Items[i] is Checkbox)
                        {
                            Checkbox ccc = cg.Items[i];
                            if (ccc.Attributes["noedit"] != "TRUE")
                            {
                                ccc.Enabled = !b;
                            }
                        }
                    }
                }
                else if (cc is RadioGroup)
                {
                    foreach (Radio r in (cc as RadioGroup).Items)
                    {
                        if (r.Attributes["noedit"] != "TRUE")
                        {
                            r.Enabled = !b;
                        }
                    }
                }
                else if (cc is TextArea)
                {
                    if ((cc as TextArea).Attributes["noedit"] != "TRUE")
                    {
                        (cc as TextArea).Enabled = !b;
                    }
                }
                else
                {
                    SetEnable(cc, b);
                }
            }
        }
        private void SetRadioGroupValue(RadioGroup rg, String value)
        {
            if (string.IsNullOrEmpty(value))
            {
                foreach (Radio r in rg.Items)
                {
                    r.Checked = false;
                }
            }
            else
            {
                String[] values = value.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                foreach (String v in values)
                {
                    foreach (Radio r in rg.Items)
                    {
                        if (r.Attributes["cvalue"].ToString() == v)
                        {
                            r.Checked = true;
                        }
                    }
                }
            }
        }
        private void SetCheckboxGroupValue(CheckboxGroup cg, String value)
        {
            String[] values = value.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            foreach (String v in values)
            {
                foreach (Checkbox cb in cg.Items)
                {
                    if (cb.Attributes["cvalue"].ToString() == v)
                    {
                        cb.Checked = true;
                    }
                }
            }
        }
        private void SetCheckboxGroupValue(Control parentPanel, string groupName, String value, int maxIndex)
        {
            String[] values = value.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            Checkbox checkbox;

            foreach (String v in values)
            {
                for (int i = 1; i <= maxIndex; i++)
                {
                    checkbox = (parentPanel.FindControl(string.Format("{0}_{1}", groupName, i.ToString())) as Checkbox);

                    if (checkbox.Attributes["cvalue"].ToString() == v)
                    {
                        checkbox.Checked = true;
                    }
                }
            }
        }
        private String GetCheckboxGroupValue(Control parentPanel, string groupName, int maxIndex)
        {
            String v = "";
            Checkbox checkbox;

            for (int i = 1; i <= maxIndex; i++)
            {
                checkbox = (parentPanel.FindControl(string.Format("{0}_{1}", groupName, i.ToString())) as Checkbox);

                if (checkbox.Checked)
                {
                    v += checkbox.Attributes["cvalue"].ToString() + ",";
                }
            }

            if (v != "")
            {
                v = v.Substring(0, v.Length - 1);
            }
            return v;
        }
        private String GetRadioGroupValue(RadioGroup rg)
        {
            String v = "";
            foreach (Radio r in rg.CheckedItems)
            {
                v += r.Attributes["cvalue"].ToString() + ",";
            }
            if (v != "")
            {
                v = v.Substring(0, v.Length - 1);
            }
            return v;
        }
        private String GetCheckboxGroupValue(CheckboxGroup cg)
        {
            String v = "";
            foreach (Checkbox cb in cg.CheckedItems)
            {
                v += cb.Attributes["cvalue"].ToString() + ",";
            }
            if (v != "")
            {
                v = v.Substring(0, v.Length - 1);
            }
            return v;
        }
        private void ShowTextBoxWhenChecked()
        {
            if (this.Dead_1.Checked)
                this.tr1.Attributes["Style"] = "";
            else
                this.tr1.Attributes["Style"] = "display:none;";
            if (this.Dead_2.Checked)
                this.tr2.Attributes["Style"] = "";
            else
                this.tr2.Attributes["Style"] = "display:none;";
            if (this.Dead_3.Checked)
                this.tr3.Attributes["Style"] = "";
            else
                this.tr3.Attributes["Style"] = "display:none;";
            if (this.Dead_4.Checked)
                this.tr4.Attributes["Style"] = "";
            else
                this.tr4.Attributes["Style"] = "display:none;";

            if (this.Pulse_2.Checked)
                this.etfSurgeryDesc.Show();
            else
                this.etfSurgeryDesc.Hide();
            if (this.Pulse_3.Checked)
                this.etfInPatientDesc.Show();
            else
                this.etfInPatientDesc.Hide();
            if (this.Pulse_4.Checked)
                this.etfMedicationDesc.Show();
            else
                this.etfMedicationDesc.Hide();
            if (this.Pulse_6.Checked)
                this.etfBloodDesc.Show();
            else
                this.etfBloodDesc.Hide();
            if (this.Pulse_7.Checked)
                this.etfOtherTreatDesc.Show();
            else
                this.etfOtherTreatDesc.Hide();

            if (this.HasFollowOperation_1.Checked)
            {
                tdlblFollowOperationDate.Attributes["Style"] = "";
                tdFollowOperationDate.Attributes["Style"] = "";
                tdlblFollowOperationStaff.Attributes["Style"] = "";
                tdFollowOperationStaff.Attributes["Style"] = "";
            }
            else
            {
                tdlblFollowOperationDate.Attributes["Style"] = "display:none;";
                tdFollowOperationDate.Attributes["Style"] = "display:none;";
                tdlblFollowOperationStaff.Attributes["Style"] = "display:none;";
                tdFollowOperationStaff.Attributes["Style"] = "display:none;";
            }

            if (this.WITHLABELEDUSE_2.Checked)
            {
                tdlblNOLABELEDUSE.Attributes["Style"] = "";
                tdNOLABELEDUSE.Attributes["Style"] = "";
            }
            else
            {
                tdlblNOLABELEDUSE.Attributes["Style"] = "display:none;";
                tdNOLABELEDUSE.Attributes["Style"] = "display:none;";
            }
        }
        #endregion
    }
}