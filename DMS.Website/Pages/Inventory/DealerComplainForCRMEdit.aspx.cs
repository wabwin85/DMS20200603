using Coolite.Ext.Web;
using DMS.Business;
using DMS.Business.Cache;
using DMS.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Inventory
{
    public partial class DealerComplainForCRMEdit : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerComplainBLL _business = new DealerComplainBLL();
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IAttachmentBLL attachBll = new AttachmentBLL();
        private IPurchaseOrderBLL _businessPurchaseOrder = new PurchaseOrderBLL();
        private QueryInventoryBiz _businessQueryInv = new QueryInventoryBiz();
        private const string CONST_COMPLAIN_TYPE = "CRM";
        #endregion

        #region 属性
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
        #endregion

        #region 页面事件        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.InitForm();
                this.LoadCRMInfo();
                this.LoadDealerInfo();
                this.SetControlStatus();

                this.ShowTextBoxWhenChecked();
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.CFNSearchForComplainDialog1.AfterSelectedCfnHandler += OnCfnAfterSelectedRow;
            this.CFNSearchForComplainDialog1.AfterSelectedQrCodeHandler += OnQrCodeAfterSelectedRow;
            this.HospitalSearchForComplainDialog1.AfterSelectedHandler += OnHospitalAfterSelectedHandler;
        }

        /// <summary>
        /// 选择后，添加数据
        /// </summary>
        /// <param name="e"></param>
        protected void OnCfnAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            if (selectedRows.Count() > 0)
            {
                this.hiddenLot.Text = selectedRows[0]["LotName"];
                this.txtLot.Text = this.hiddenLot.Text;
                this.hiddenUPN.Text = selectedRows[0]["UpnName"];
                this.txtUPN.Text = this.hiddenUPN.Text;

                this.hiddenDescription.Text = selectedRows[0]["SkuDesc"];
                this.DESCRIPTION.Text = this.hiddenDescription.Text;

                this.Model.Text = selectedRows[0]["Property1"];
                this.Registration.Text = selectedRows[0]["Property5"];

                this.hiddenConvertFactor.Text = selectedRows[0]["ConvertFactor"];
                this.hiddenCFN_Property4.Text = selectedRows[0]["Property4"];

                this.hiddenBu.Text = selectedRows[0]["BU"];
                this.hiddenBuCode.Text = selectedRows[0]["BUCode"];

                BindBscEmployeeMaster();
            }
        }

        protected void OnQrCodeAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            if (selectedRows.Count() > 0)
            {
                this.hiddenWarehouseId.Text = selectedRows[0]["WarehouseId"];
                this.txtWarehouse.Text = selectedRows[0]["WarehouseName"];

                this.hiddenQrCode.Text = selectedRows[0]["QrCode"];
                this.txtQrCode.Text = this.hiddenQrCode.Text;

                this.hiddenExpiredDate.Text = selectedRows[0]["ExpiredDate"];
                this.txtExpiredDate.Text = this.hiddenExpiredDate.Text;

                Hashtable table = new Hashtable();

                table.Add("UPN", this.hiddenUPN.Text.Trim());
                table.Add("LotNumer", string.Format("{0}@@{1}", this.hiddenLot.Text.Trim(), this.hiddenQrCode.Text));
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
                        returnType = "2"; //退款
                    }
                    if (right == PropertyRightsType.波科物权.ToString())
                    {
                        returnType = "5"; //仅上报投诉，只退不换
                    }
                    if (right == PropertyRightsType.波科内部使用.ToString())
                    {
                        returnType = "5"; //仅上报投诉，只退不换
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
                            returnType = "2"; //退款
                        }
                        if (right == PropertyRightsType.波科物权.ToString())
                        {
                            returnType = "5"; //仅上报投诉，只退不换
                        }
                        if (right == PropertyRightsType.波科内部使用.ToString())
                        {
                            returnType = "5"; //仅上报投诉，只退不换
                        }
                    }
                    else
                    {
                        //单包装
                        if (right == PropertyRightsType.T2物权.ToString() ||
                            right == PropertyRightsType.T1物权.ToString() ||
                            right == PropertyRightsType.医院物权.ToString())
                        {
                            returnType = "1"; //换货
                        }
                        if (right == PropertyRightsType.平台物权.ToString())
                        {
                            returnType = "2"; //退款
                        }
                        if (right == PropertyRightsType.波科物权.ToString() ||
                            right == PropertyRightsType.波科内部使用.ToString())
                        {
                            returnType = "5"; //仅上报投诉，只退不换
                        }
                    }
                }
            }
            return returnType;
        }

        private string getPropertyRights()
        {
            string prodType = this.GetRadioGroupValue(PRODUCTTYPE);

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

        protected void OnHospitalAfterSelectedHandler(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            if (selectedRows.Count() > 0)
            {

                this.hiddenDistributorCustomer.Text = selectedRows[0]["HosKeyAccount"];
                this.hiddenDistributorCustomerName.Text = selectedRows[0]["HosHospitalName"];
                this.hiddenDistributorCity.Text = selectedRows[0]["HosCity"];

                this.DISTRIBUTORCUSTOMER.Text = this.hiddenDistributorCustomer.Text;
                this.DISTRIBUTORCITY.Text = this.hiddenDistributorCity.Text;
                this.PhysicianHospital.Text = this.hiddenDistributorCustomerName.Text;
                BindBscEmployeeMaster();
            }
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
                    if (this.hiddenAttachmentUpload.Text == AttachmentType.DealerComplainCRMRtn.ToString())
                    {
                        filderPath = "\\Upload\\UploadFile\\DealerComplainCRMRtn\\";
                    }
                    else
                    {
                        filderPath = "\\Upload\\UploadFile\\DealerComplainCRM\\";
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
                    attach.Type = this.hiddenAttachmentUpload.Text == AttachmentType.DealerComplainCRMRtn.ToString() ? AttachmentType.DealerComplainCRMRtn.ToString() : AttachmentType.DealerComplainCRM.ToString();
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

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(this.InstanceId, AttachmentType.DealerComplainCRM, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }

        protected void AttachmentRtnStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(this.InstanceId, AttachmentType.DealerComplainCRMRtn, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentRtnStore.DataSource = ds;
            AttachmentRtnStore.DataBind();
        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _businessPurchaseOrder.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        #endregion

        #region Ajax Methods
        [AjaxMethod]
        public void DeleteAttachment(string attachmentType, string id, string fileName)
        {
            try
            {
                attachBll.DelAttachment(new Guid(id));
                string uploadFile = string.Empty;
                if (attachmentType == AttachmentType.DealerComplainCRMRtn.ToString())
                {
                    uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DealerComplainCRMRtn");
                }
                else
                {
                    uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\DealerComplainCRM");
                }
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持" + "\r\n" + ex.Message).Show();
            }
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
        public string DoSave(string saveType)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string complainStatus = string.Empty;
            try
            {
                if (saveType == "doSubmit")
                {
                    complainStatus = "Submit";

                    Hashtable table = new Hashtable();
                    table.Add("WHMID", Guid.Empty.ToString());
                    table.Add("DMAID", this.hiddenInitDealerId.Value);
                    table.Add("UPN", this.hiddenUPN.Text);
                    table.Add("Lot", this.hiddenLot.Text);
                    table.Add("QrCode", this.hiddenQrCode.Text);
                    table.Add("EventDate", this.DateEvent.SelectedDate);
                    if (!this.DateDealer.IsNull) { table.Add("DealerDate", this.DateDealer.SelectedDate); }
                    table.Add("ComplainType", "DealerComplain");

                    DateTime minImplanDate = DateTime.Now;
                    if (!this.PulseImplant.IsNull) { minImplanDate = this.PulseImplant.SelectedDate; }
                    if (!this.Leads1Implant.IsNull)
                    {
                        if (DateTime.Compare(this.Leads1Implant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.Leads1Implant.SelectedDate; }
                    }
                    if (!this.Leads2Implant.IsNull)
                    {
                        if (DateTime.Compare(this.Leads2Implant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.Leads2Implant.SelectedDate; }
                    }
                    if (!this.Leads3Implant.IsNull)
                    {
                        if (DateTime.Compare(this.Leads3Implant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.Leads3Implant.SelectedDate; }
                    }
                    if (!this.AccessoryImplant.IsNull)
                    {
                        if (DateTime.Compare(this.AccessoryImplant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.AccessoryImplant.SelectedDate; }
                    }
                    table.Add("ImplanDate", minImplanDate);
                    _business.CheckUPNAndDateCRMForEkp(table, out rtnVal, out rtnMsg);
                }
                else if (saveType == "doSaveDraft")
                {
                    complainStatus = "Draft";
                    rtnVal = "Success";
                    
                }

                if (rtnVal.Equals("Success"))
                {
                    this.SaveComplainCrmInfo(complainStatus);
                }
                else
                {
                    rtnVal = rtnMsg;

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return rtnVal;
        }

        /// <summary>
        /// 导出Word
        /// </summary>
        [AjaxMethod]
        public string DoExportForm()
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", this.InstanceId);
            param.Add("ComplainType", "CRM");
            var table = _business.DealerComplainInfo_SpecialDateFormat(param);
            if (table.Rows.Count == 0)
                throw new Exception("单据不存在");

            string rtnVal = _business.DealerComplainCRMExportForm(table);

            return JsonHelper.Serialize(new { ComplainNbr = (string.IsNullOrEmpty(table.Rows[0]["DC_ComplainNbr"].ToString()) ? "DealerComplainCRM" : table.Rows[0]["DC_ComplainNbr"].ToString()), FilePath = rtnVal });
        }

        [AjaxMethod]
        public string DoSaveReturn(string saveType)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string returnStatus = string.Empty;
            try
            {
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
                        table.Add("UPN", this.hiddenUPN.Text);
                        table.Add("Lot", this.hiddenLot.Text);
                        table.Add("QrCode", this.hiddenQrCode.Text);
                        if (!this.DateEvent.IsNull) { table.Add("EventDate", this.DateEvent.SelectedDate); }
                        if (!this.DateDealer.IsNull) { table.Add("DealerDate", this.DateDealer.SelectedDate); }
                        /*添加植入时间*/
                        DateTime minImplanDate = DateTime.Now;
                        if (!this.PulseImplant.IsNull) { minImplanDate= this.PulseImplant.SelectedDate;}
                        if (!this.Leads1Implant.IsNull)
                        {
                            if (DateTime.Compare(this.Leads1Implant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.Leads1Implant.SelectedDate; }
                        }
                        if (!this.Leads2Implant.IsNull)
                        {
                            if (DateTime.Compare(this.Leads2Implant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.Leads2Implant.SelectedDate; }
                        }
                        if (!this.Leads3Implant.IsNull)
                        {
                            if (DateTime.Compare(this.Leads3Implant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.Leads3Implant.SelectedDate; }
                        }
                        if (!this.AccessoryImplant.IsNull)
                        {
                            if (DateTime.Compare(this.AccessoryImplant.SelectedDate, minImplanDate) < 0) { minImplanDate = this.AccessoryImplant.SelectedDate; }
                        }

                        table.Add("ImplanDate", minImplanDate);
                        table.Add("ComplainType", "DealerReturn");

                        _business.CheckUPNAndDateCRMForEkp(table, out rtnVal, out rtnMsg);
                    }
                }
                else if (saveType == "doSaveDraft")
                {
                    returnStatus = "Draft";
                    rtnVal = "Success";
                }

                if (rtnVal.Equals("Success"))
                {
                    this.SaveReturnCrmInfo(returnStatus);
                }
                else
                {
                    rtnVal = rtnMsg;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return rtnVal;
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
            this.UpdateComplainStatus("Reject", this.ComplainApprovelRemark.Text.Trim());
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

        #endregion

        #region 私有方法
        private void InitForm()
        {
            //绑定经销商
            base.Bind_AllDealerList(DealerStore, true);
            this.cbDealer.Disabled = true;
            this.CompletedName.Disabled = false;

            this.hidInstanceId.Value = this.InstanceId;

            if (_context.User.IdentityType == IdentityType.User.ToString())
            {
                //this.CompletedName.SelectedItem.Value = _context.User.LoginId;
                this.cbDealer.Disabled = false;
                this.CompletedName.Disabled = true;
                this.hiddenBscUserId.Text = _context.User.LoginId.ToUpper();
            }
            else
            {
                this.hiddenInitDealerId.Value = _context.User.CorpId.Value.ToString();
            }

            this.ConfirmUpdateDate = DateTime.Now;
            this.LastUpdateDate = DateTime.Now;
            this.hiddenInitUserId.Text = _context.User.Id.ToUpper();

            //时间发生国家默认为China
            this.EventCountry.Text = "China";
            this.DateReceipt.SelectedDate = DateTime.Now;
            this.txtComplainStatus.Text = "草稿";
            this.hiddenCompalinStatus.Text = "Draft";

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

            
           
        }

        private void BindBscEmployeeMaster()
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.hiddenInitDealerId.Value.ToString()) && !string.IsNullOrEmpty(this.hiddenUPN.Text))
                //!string.IsNullOrEmpty(this.hiddenBuCode.Text))
            {
                //param.Add("DmaId", new Guid(this.hiddenInitDealerId.Value.ToString()));

                //param.Add("BU", this.hiddenBu.Text);
                //param.Add("BUCode", this.hiddenBuCode.Text);
                param.Add("UPN", this.hiddenUPN.Text);
                param.Add("HosCode", this.DISTRIBUTORCUSTOMER.Text);
            }

            //如果是新增或草稿，则只能选择有效的员工
            if (this.hiddenCompalinStatus.Text == "Draft")
            {
                param.Add("IsActive", "True");
            }

            DataSet ds = _business.SelectBscSrForComplain(param);

            this.BscUserStore.DataSource = ds;
            this.BscUserStore.DataBind();
        }

        private void LoadCRMInfo()
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", this.InstanceId);
            param.Add("ComplainType", "CRM");
            DataTable dt = _business.DealerComplainInfo(param);

            this.SetRadioGroupValue(this.ISPLATFORM, "");
            this.SetRadioGroupValue(NeedSupport, "");
            this.SetRadioGroupValue(this.Witnessed, "");
            this.SetRadioGroupValue(this.RelatedBSC, "");
            this.SetRadioGroupValue(this.IsForBSCProduct, "");
            this.SetRadioGroupValue(this.Leads1Position, "");
            this.SetRadioGroupValue(this.Leads2Position, "");
            this.SetRadioGroupValue(this.Leads3Position, "");
            this.SetRadioGroupValue(this.RemainsService, "");
            this.SetRadioGroupValue(this.RemovedService, "");
            this.SetRadioGroupValue(this.PRODUCTTYPE, "");
            this.SetRadioGroupValue(this.HasFollowOperation, "");
            this.SetRadioGroupValue(this.FollowOperationStaff, "");

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];

                if (r["DC_CorpId"] != DBNull.Value)
                {
                    this.hiddenInitDealerId.Value = r["DC_CorpId"].ToString();
                }

                if (r["DC_ConfirmUpdateDate"] != DBNull.Value)
                {
                    this.ConfirmUpdateDate = DateTime.Parse(r["DC_ConfirmUpdateDate"].ToString());
                }
                this.LastUpdateDate = DateTime.Parse(r["DC_LastModifiedDate"].ToString());
                this.hiddenInitUserId.Text = r["DC_CreatedBy"].ToString().ToUpper();
                this.hiddenCompalinStatus.Text = r["DC_Status"].ToString();
                this.txtComplainStatus.Text = DictionaryHelper.GetDictionaryNameById(SR.CONST_QAComplainReturn_Status, this.hiddenCompalinStatus.Text);

                this.txtComplainNo.Text = r["DC_ComplainNbr"].ToString();

                this.SetRadioGroupValue(this.ISPLATFORM, r["ISPLATFORM"].ToString());
                this.BSCSOLDTOACCOUNT.Text = r["BSCSOLDTOACCOUNT"].ToString();
                this.BSCSOLDTONAME.Text = r["BSCSOLDTONAME"].ToString();
                this.BSCSOLDTOCITY.Text = r["BSCSOLDTOCITY"].ToString();
                this.SUBSOLDTONAME.Text = r["SUBSOLDTONAME"].ToString();
                this.SUBSOLDTOCITY.Text = r["SUBSOLDTOCITY"].ToString();

                this.DISTRIBUTORCUSTOMER.Text = r["DISTRIBUTORCUSTOMER"].ToString();
                this.DISTRIBUTORCITY.Text = r["DISTRIBUTORCITY"].ToString();

                this.hiddenDistributorCustomer.Text = r["DISTRIBUTORCUSTOMER"].ToString();
                this.hiddenDistributorCity.Text = r["DISTRIBUTORCITY"].ToString();

                this.txtUPN.Text = r["Serial"].ToString();
                this.hiddenUPN.Text = r["Serial"].ToString();

                if (IsDealer)
                {
                    this.txtLot.Text = r["Lot"].ToString();
                    this.hiddenLot.Text = r["Lot"].ToString();
                }
                else
                {
                    this.txtLot.Text = r["Lot"].ToString().Split('@')[0];
                    this.hiddenLot.Text = r["Lot"].ToString().Split('@')[0];
                }

                this.Model.Text = r["Model"].ToString();

                this.hiddenDescription.Text = r["ProductDescription"].ToString();
                this.DESCRIPTION.Text = this.hiddenDescription.Text;

                this.PI.Text = r["PI"].ToString();
                this.IAN.Text = r["IAN"].ToString();
                this.RN.Text = r["RN"].ToString();

                //this.CompletedName.SelectedItem.Value = r["CompletedName"].ToString();
                this.hiddenBscUserId.Text = r["CompletedName"].ToString();
                this.CompletedTitle.Text = r["CompletedTitle"].ToString();

                this.CompletedEmail.Text = r["CompletedEmail"].ToString();
                this.CompletedPhone.Text = r["CompletedPhone"].ToString();

                this.NonBostonName.Text = r["NonBostonName"].ToString();
                this.NonBostonCompany.Text = r["NonBostonCompany"].ToString();
                this.NonBostonAddress.Text = r["NonBostonAddress"].ToString();
                this.NonBostonCity.Text = r["NonBostonCity"].ToString();
                this.NonBostonCountry.Text = r["NonBostonCountry"].ToString();
                this.DateBSC.Text = r["DateBSC"].ToString();
                if (r["DateEvent"] != DBNull.Value && !String.IsNullOrEmpty(r["DateEvent"].ToString()))
                {
                    this.DateEvent.SelectedDate = DateTime.ParseExact(r["DateEvent"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                if (r["DateDealer"] != DBNull.Value && !String.IsNullOrEmpty(r["DateDealer"].ToString()))
                {
                    this.DateDealer.SelectedDate = DateTime.ParseExact(r["DateDealer"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }

                if (r["DC_Status"].ToString().Equals("Draft"))
                {
                    this.DateReceipt.SelectedDate = DateTime.Now;
                }
                else
                {
                    if (r["DateReceipt"] != DBNull.Value && !String.IsNullOrEmpty(r["DateReceipt"].ToString()))
                    {
                        this.DateReceipt.SelectedDate = DateTime.ParseExact(r["DateReceipt"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                    }
                }


                
                this.EventCountry.Text = r["EventCountry"].ToString();
                this.OtherCountry.Text = r["OtherCountry"].ToString();
                this.SetRadioGroupValue(NeedSupport, r["NeedSupport"].ToString());
                this.PatientName.Text = r["PatientName"].ToString();
                this.PatientNum.Text = r["PatientNum"].ToString();
                this.PatientSex.Text = r["PatientSex"].ToString();
                this.PatientSexInvalid.Checked = Convert.ToBoolean(r["PatientSexInvalid"].ToString());
                if (r["PatientBirth"] != DBNull.Value && !String.IsNullOrEmpty(r["PatientBirth"].ToString()))
                {
                    this.PatientBirth.SelectedDate = DateTime.ParseExact(r["PatientBirth"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.PatientBirthInvalid.Checked = Convert.ToBoolean(r["PatientBirthInvalid"].ToString());
                this.PatientWeight.Text = r["PatientWeight"].ToString();
                this.PatientWeightInvalid.Checked = Convert.ToBoolean(r["PatientWeightInvalid"].ToString());
                this.PhysicianName.Text = r["PhysicianName"].ToString();
                this.PhysicianHospital.Text = r["PhysicianHospital"].ToString();
                this.hiddenDistributorCustomerName.Text = r["PhysicianHospital"].ToString();
                this.PhysicianTitle.Text = r["PhysicianTitle"].ToString();
                this.PhysicianAddress.Text = r["PhysicianAddress"].ToString();
                this.PhysicianCity.Text = r["PhysicianCity"].ToString();
                this.PhysicianZipcode.Text = r["PhysicianZipcode"].ToString();
                this.PhysicianCountry.Text = r["PhysicianCountry"].ToString();
                SetCheckboxGroupValue(this.PatientStatus, r["PatientStatus"].ToString());
                if (r["DeathDate"] != DBNull.Value && !String.IsNullOrEmpty(r["DeathDate"].ToString()))
                {
                    this.DeathDate.SelectedDate = DateTime.ParseExact(r["DeathDate"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.DeathTime.Text = r["DeathTime"].ToString();
                this.DeathCause.Text = r["DeathCause"].ToString();
                this.SetRadioGroupValue(this.Witnessed, r["Witnessed"].ToString());
                this.SetRadioGroupValue(this.RelatedBSC, r["RelatedBSC"].ToString());
                this.SetRadioGroupValue(this.IsForBSCProduct, r["IsForBSCProduct"].ToString());
                this.SetCheckboxGroupValue(this.ReasonsForProduct, r["ReasonsForProduct"].ToString());
                this.SetRadioGroupValue(this.Returned, r["Returned"].ToString());
                this.ReturnedDay.Text = r["ReturnedDay"].ToString();
                this.SetRadioGroupValue(this.AnalysisReport, r["AnalysisReport"].ToString());
                this.RequestPhysicianName.Text = r["RequestPhysicianName"].ToString();
                this.SetRadioGroupValue(this.Warranty, r["Warranty"].ToString());
                this.SetCheckboxGroupValue(this.Panel7, "Pulse", r["Pulse"].ToString(), 15);
                this.Pulsebeats.Text = r["Pulsebeats"].ToString();
                this.SetCheckboxGroupValue(this.Panel7, "Leads", r["Leads"].ToString(), 11);
                this.LeadsFracture.Text = r["LeadsFracture"].ToString();
                this.LeadsIssue.Text = r["LeadsIssue"].ToString();
                this.LeadsDislodgement.Text = r["LeadsDislodgement"].ToString();
                this.LeadsMeasurements.Text = r["LeadsMeasurements"].ToString();
                this.LeadsThresholds.Text = r["LeadsThresholds"].ToString();
                this.LeadsBeats.Text = r["LeadsBeats"].ToString();
                this.LeadsNoise.Text = r["LeadsNoise"].ToString();
                this.LeadsLoss.Text = r["LeadsLoss"].ToString();
                this.SetCheckboxGroupValue(this.Panel7, "Clinical", r["Clinical"].ToString(), 12);
                this.ClinicalPerforation.Text = r["ClinicalPerforation"].ToString();
                this.ClinicalBeats.Text = r["ClinicalBeats"].ToString();
                this.PulseModel.Text = r["PulseModel"].ToString();
                this.PulseSerial.Text = r["PulseSerial"].ToString();
                if (r["PulseImplant"] != DBNull.Value && !String.IsNullOrEmpty(r["PulseImplant"].ToString()))
                {
                    this.PulseImplant.SelectedDate = DateTime.ParseExact(r["PulseImplant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.Leads1Model.Text = r["Leads1Model"].ToString();
                this.Leads1Serial.Text = r["Leads1Serial"].ToString();
                if (r["Leads1Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Leads1Implant"].ToString()))
                {
                    this.Leads1Implant.SelectedDate = DateTime.ParseExact(r["Leads1Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.SetRadioGroupValue(this.Leads1Position, r["Leads1Position"].ToString());
                this.Leads2Model.Text = r["Leads2Model"].ToString();
                this.Leads2Serial.Text = r["Leads2Serial"].ToString();
                if (r["Leads2Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Leads2Implant"].ToString()))
                {
                    this.Leads2Implant.SelectedDate = DateTime.ParseExact(r["Leads2Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.SetRadioGroupValue(this.Leads2Position, r["Leads2Position"].ToString());
                this.Leads3Model.Text = r["Leads3Model"].ToString();
                this.Leads3Serial.Text = r["Leads3Serial"].ToString();
                if (r["Leads3Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Leads3Implant"].ToString()))
                {
                    this.Leads3Implant.SelectedDate = DateTime.ParseExact(r["Leads3Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.SetRadioGroupValue(this.Leads3Position, r["Leads3Position"].ToString());
                this.AccessoryModel.Text = r["AccessoryModel"].ToString();
                this.AccessorySerial.Text = r["AccessorySerial"].ToString();
                if (r["AccessoryImplant"] != DBNull.Value && !String.IsNullOrEmpty(r["AccessoryImplant"].ToString()))
                {
                    this.AccessoryImplant.SelectedDate = DateTime.ParseExact(r["AccessoryImplant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.AccessoryLot.Text = r["AccessoryLot"].ToString();
                if (r["ExplantDate"] != DBNull.Value && !String.IsNullOrEmpty(r["ExplantDate"].ToString()))
                {
                    this.ExplantDate.SelectedDate = DateTime.ParseExact(r["ExplantDate"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.SetRadioGroupValue(this.RemainsService, r["RemainsService"].ToString());
                this.SetRadioGroupValue(this.RemovedService, r["RemovedService"].ToString());
                this.Replace1Model.Text = r["Replace1Model"].ToString();
                this.Replace1Serial.Text = r["Replace1Serial"].ToString();
                if (r["Replace1Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Replace1Implant"].ToString()))
                {
                    this.Replace1Implant.SelectedDate = DateTime.ParseExact(r["Replace1Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.Replace2Model.Text = r["Replace2Model"].ToString();
                this.Replace2Serial.Text = r["Replace2Serial"].ToString();
                if (r["Replace2Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Replace2Implant"].ToString()))
                {
                    this.Replace2Implant.SelectedDate = DateTime.ParseExact(r["Replace2Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.Replace3Model.Text = r["Replace3Model"].ToString();
                this.Replace3Serial.Text = r["Replace3Serial"].ToString();
                if (r["Replace3Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Replace3Implant"].ToString()))
                {
                    Replace3Implant.SelectedDate = DateTime.ParseExact(r["Replace3Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.Replace4Model.Text = r["Replace4Model"].ToString();
                this.Replace4Serial.Text = r["Replace4Serial"].ToString();
                if (r["Replace4Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Replace4Implant"].ToString()))
                {
                    this.Replace4Implant.SelectedDate = DateTime.ParseExact(r["Replace4Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.Replace5Model.Text = r["Replace5Model"].ToString();
                this.Replace5Serial.Text = r["Replace5Serial"].ToString();
                if (r["Replace5Implant"] != DBNull.Value && !String.IsNullOrEmpty(r["Replace5Implant"].ToString()))
                {
                    this.Replace5Implant.SelectedDate = DateTime.ParseExact(r["Replace5Implant"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.ProductExpDetail.Text = r["ProductExpDetail"].ToString();
                this.CustomerComment.Text = r["CustomerComment"].ToString();
                this.Registration.Text = r["REGISTRATION"].ToString();


                this.txtLotNumber.Text = this.txtLot.Text;
                this.txtModel.Text = this.Model.Text;
                this.txtWarehouse.Text = r["WarehouseName"] != DBNull.Value ? r["WarehouseName"].ToString() : string.Empty;
                this.hiddenWarehouseId.Text = r["WHMID"] != DBNull.Value ? r["WHMID"].ToString() : string.Empty;
                this.txtQrCode.Text = r["QrCode"] != DBNull.Value ? r["QrCode"].ToString() : string.Empty;
                this.hiddenQrCode.Text = this.txtQrCode.Text;
                this.txtRegistration.Text = this.Registration.Text;
                this.txtExpiredDate.Text = r["UPNExpDate"] != DBNull.Value ? r["UPNExpDate"].ToString() : string.Empty;
                this.hiddenExpiredDate.Text = this.txtExpiredDate.Text;

                if (r["SalesDate"] != DBNull.Value && !String.IsNullOrEmpty(r["SalesDate"].ToString()))
                {
                    this.SalesDate.SelectedDate = DateTime.ParseExact(r["SalesDate"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                    this.hiddenSalesDate.Text = r["SalesDate"].ToString();
                }

                if (r["HasSalesDate"] != null && !String.IsNullOrEmpty(r["HasSalesDate"].ToString()))
                {
                    this.hiddenHasSalesDate.Text = Convert.ToBoolean(r["HasSalesDate"].ToString()) ? "1" : "0";
                }
                else
                {
                    this.hiddenHasSalesDate.Text = "0";
                }

                this.hiddenReturnStatus.Text = r["DC_ComplainStatus"] != DBNull.Value ? r["DC_ComplainStatus"].ToString() : string.Empty;
                this.txtReturnStatus.Text = DictionaryHelper.GetDictionaryNameById(SR.CONST_QAComplainReturn_Status, this.hiddenReturnStatus.Text);
                this.SetRadioGroupValue(this.PRODUCTTYPE, r["ProductType"] != DBNull.Value ? r["ProductType"].ToString() : string.Empty);
                this.hiddenRETURNTYPE.Text = r["RETURNTYPE"] != DBNull.Value ? r["RETURNTYPE"].ToString() : string.Empty;
                this.RETURNTYPE.SelectedItem.Value = this.hiddenRETURNTYPE.Text;

                this.DNNo.Text = r["DN"].ToString();
                this.CarrierNumber.Text = r["CarrierNumber"] == DBNull.Value ? string.Empty : r["CarrierNumber"].ToString();
                this.REMARK.Text = r["REMARK"] == DBNull.Value ? string.Empty : r["REMARK"].ToString();
                this.ComplainApprovelRemark.Text = r["ComplainApprovelRemark"] == DBNull.Value ? string.Empty : r["ComplainApprovelRemark"].ToString();

                this.SetRadioGroupValue(HasFollowOperation, r["HasFollowOperation"].ToString());
                this.SetRadioGroupValue(FollowOperationStaff, r["FollowOperationStaff"].ToString());
                if (r["FollowOperationDate"] != DBNull.Value && !String.IsNullOrEmpty(r["FollowOperationDate"].ToString()))
                {
                    this.FollowOperationDate.SelectedDate = DateTime.ParseExact(r["FollowOperationDate"].ToString(), "yyyyMMdd", CultureInfo.CurrentCulture);
                }
                this.CourierCompany.Text = r["CourierCompany"] == DBNull.Value ? string.Empty : r["CourierCompany"].ToString();
                this.ProductDescription.Text = r["ProductDescription"].ToString();
                this.ReturnProductRegisterNo.Text = r["RN"].ToString();
                this.ConfirmReturnOrRefund.Text = r["ConfirmReturnOrRefund"] == DBNull.Value ? string.Empty : r["ConfirmReturnOrRefund"].ToString();
                this.PropertyRights.Text = r["PropertyRights"] == DBNull.Value ? string.Empty : r["PropertyRights"].ToString();
                hiddenConvertFactor.Text = r["CONVERTFACTOR"].ToString();
                hiddenCFN_Property4.Text = r["CFN_Property4"].ToString();

                this.txtProductExpiredDate.Text = r["UPNEXPDATE"] != DBNull.Value ? r["UPNEXPDATE"].ToString() : string.Empty;
                this.txtQRCodeView.Text = r["QrCode"] != DBNull.Value ? r["QrCode"].ToString() : string.Empty;
            }
            //绑定波科人员
            if (this.hiddenCompalinStatus.Text != "Draft")
            {
                this.BindBscEmployeeMaster();
            }
        }

        private void SetControlStatus()
        {
            this.SalesDate.Disabled = this.hiddenHasSalesDate.Text == "1" ? true : false;

            if (this.hiddenCompalinStatus.Text != "Draft")
            {
                this.btnExportForm.Disabled = false;
                this.btnExportForm.Hidden = false;

                this.btnUploadAttachment.Disabled = true;
                this.btnUploadAttachment.Hidden = true;
                this.imbtnSearchProduct.Disabled = true;
                this.imbtnSearchProduct.Hidden = true;
                this.imbtnSearchHospital.Disabled = true;
                this.imbtnSearchHospital.Hidden = true;
                this.imbtnSearchQrCode.Disabled = true;
                this.imbtnSearchQrCode.Hidden = true;

                this.gpAttachment.ColumnModel.SetHidden(5, true);
            }

            //登录人为创建人、销售或者为经销商用户且Corp_ID等于申请单中的经销商ID
            if (this.hiddenBscUserId.Text.ToUpper() == _context.User.LoginId.ToUpper()
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
                    }
                }
            }
            else if (_context.User.IdentityType == IdentityType.User.ToString()
                && (_context.IsInRole("Administrators")))
            //QA权限可以使用
            {
                //投诉已收到
                if (this.hiddenCompalinStatus.Text == "Accept")
                {
                    this.btnExportForm.Disabled = false;
                    this.btnQaSaveDraft.Disabled = false;
                    this.btnQASubmit.Disabled = false;
                    this.btnQAReject.Disabled = false;

                    this.btnExportForm.Hidden = false;
                    this.btnQaSaveDraft.Hidden = false;
                    this.btnQASubmit.Hidden = false;
                    this.btnQAReject.Hidden = false;

                    this.PI.Disabled = false;
                    this.IAN.Disabled = false;
                    this.RN.Disabled = false;
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

            if (this.hiddenCompalinStatus.Text != "Submit")
            {
                this.returnPanel.Hide();
            }

            if (this.hiddenReturnStatus.Text == "Draft"
                && this.hiddenCompalinStatus.Text == "Submit"
                && _context.User.IdentityType == IdentityType.Dealer.ToString()
                && !string.IsNullOrEmpty(this.hiddenInitDealerId.Text)
                && _context.User.CorpId.Value == new Guid(this.hiddenInitDealerId.Text))
            {
                this.btnSaveReturnDraft.Disabled = false;
                this.btnSubmitReturn.Disabled = false;
                this.imbtnSearchQrCode.Disabled = false;

                this.btnSaveReturnDraft.Hidden = false;
                this.btnSubmitReturn.Hidden = false;
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

            //如果单据状态时草稿，且申请人是user不是经销商，且非波科人员的上报中姓名、联系电话、联系邮箱为空，则将内容置为N/A
            if (this.hiddenCompalinStatus.Text == "Draft" && _context.User.IdentityType == IdentityType.User.ToString())
            {
                if (string.IsNullOrEmpty(this.NonBostonName.Text))
                {
                    this.NonBostonName.Text = "N/A";
                }

                if (string.IsNullOrEmpty(this.CompletedPhone.Text))
                {
                    this.CompletedPhone.Text = "N/A";
                }

                if (string.IsNullOrEmpty(this.CompletedEmail.Text))
                {
                    this.CompletedEmail.Text = "N/A";
                }   
            }
        }

        private String GenerateInfoXML()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<DealerComplain>");

            sb.Append("<PRODUCTTYPE></PRODUCTTYPE>");
            sb.Append("<RETURNTYPE></RETURNTYPE>");
            sb.Append("<ISPLATFORM>" + GetRadioGroupValue(ISPLATFORM) + "</ISPLATFORM>");
            sb.Append("<BSCSOLDTOACCOUNT>" + BSCSOLDTOACCOUNT.Text.Trim() + "</BSCSOLDTOACCOUNT>");
            sb.Append("<BSCSOLDTONAME>" + BSCSOLDTONAME.Text.Trim() + "</BSCSOLDTONAME>");
            sb.Append("<BSCSOLDTOCITY>" + BSCSOLDTOCITY.Text.Trim() + "</BSCSOLDTOCITY>");
            sb.Append("<SUBSOLDTONAME>" + SUBSOLDTONAME.Text.Trim() + "</SUBSOLDTONAME>");
            sb.Append("<SUBSOLDTOCITY>" + SUBSOLDTOCITY.Text.Trim() + "</SUBSOLDTOCITY>");

            sb.Append("<DISTRIBUTORCUSTOMER>" + this.hiddenDistributorCustomer.Text.Trim() + "</DISTRIBUTORCUSTOMER>");
            sb.Append("<DISTRIBUTORCITY>" + this.hiddenDistributorCity.Text.Trim() + "</DISTRIBUTORCITY>");

            sb.Append("<Model>" + this.Model.Text.Trim() + "</Model>");
            sb.Append("<Serial>" + this.hiddenUPN.Text.Trim() + "</Serial>");
            sb.Append("<Lot>" + this.hiddenLot.Text.Trim() + "</Lot>");
            sb.Append("<DESCRIPTION>" + this.hiddenDescription.Text.Trim() + "</DESCRIPTION>");
            sb.Append("<UPNExpDate></UPNExpDate>");
            sb.Append("<PI>" + PI.Text.Trim() + "</PI>");
            sb.Append("<IAN>" + IAN.Text.Trim() + "</IAN>");
            sb.Append("<CompletedName>" + this.hiddenBscUserId.Text.Trim() + "</CompletedName>");
            sb.Append("<CompletedTitle>" + CompletedTitle.Text.Trim() + "</CompletedTitle>");
            sb.Append("<NonBostonName>" + NonBostonName.Text.Trim() + "</NonBostonName>");
            sb.Append("<NonBostonCompany>" + NonBostonCompany.Text.Trim() + "</NonBostonCompany>");
            sb.Append("<NonBostonAddress>" + NonBostonAddress.Text.Trim() + "</NonBostonAddress>");
            sb.Append("<NonBostonCity>" + NonBostonCity.Text.Trim() + "</NonBostonCity>");
            sb.Append("<NonBostonCountry>" + NonBostonCountry.Text.Trim() + "</NonBostonCountry>");
            sb.Append("<DateEvent>" + (DateEvent.IsNull ? "" : DateEvent.SelectedDate.ToString("yyyyMMdd")) + "</DateEvent>");
            //sb.Append("<DateBSC>" + (DateBSC.IsNull ? DateTime.Now.ToString() : DateBSC.SelectedDate.ToString("yyyyMMdd")) + "</DateBSC>");
            sb.Append("<DateDealer>" + (DateDealer.IsNull ? "" : DateDealer.SelectedDate.ToString("yyyyMMdd")) + "</DateDealer>");
            sb.Append("<EventCountry>" + EventCountry.Text.Trim() + "</EventCountry>");
            sb.Append("<OtherCountry>" + OtherCountry.Text.Trim() + "</OtherCountry>");
            sb.Append("<NeedSupport>" + GetRadioGroupValue(NeedSupport) + "</NeedSupport>");
            sb.Append("<PatientName>" + PatientName.Text.Trim() + "</PatientName>");
            sb.Append("<PatientNum>" + PatientNum.Text.Trim() + "</PatientNum>");
            sb.Append("<PatientSex>" + PatientSex.Text.Trim() + "</PatientSex>");
            sb.Append("<PatientSexInvalid>" + PatientSexInvalid.Checked + "</PatientSexInvalid>");
            sb.Append("<PatientBirth>" + (PatientBirth.IsNull ? "" : PatientBirth.SelectedDate.ToString("yyyyMMdd")) + "</PatientBirth>");
            sb.Append("<PatientBirthInvalid>" + PatientBirthInvalid.Checked + "</PatientBirthInvalid>");
            sb.Append("<PatientWeight>" + PatientWeight.Text.Trim() + "</PatientWeight>");
            sb.Append("<PatientWeightInvalid>" + PatientWeightInvalid.Checked + "</PatientWeightInvalid>");
            sb.Append("<PhysicianName>" + PhysicianName.Text.Trim() + "</PhysicianName>");
            sb.Append("<PhysicianHospital>" + this.hiddenDistributorCustomerName.Text.Trim() + "</PhysicianHospital>");
            sb.Append("<PhysicianTitle>" + PhysicianTitle.Text.Trim() + "</PhysicianTitle>");
            sb.Append("<PhysicianAddress>" + PhysicianAddress.Text.Trim() + "</PhysicianAddress>");
            sb.Append("<PhysicianCity>" + PhysicianCity.Text.Trim() + "</PhysicianCity>");
            sb.Append("<PhysicianZipcode>" + PhysicianZipcode.Text.Trim() + "</PhysicianZipcode>");
            sb.Append("<PhysicianCountry>" + PhysicianCountry.Text.Trim() + "</PhysicianCountry>");
            sb.Append("<PatientStatus>" + GetCheckboxGroupValue(PatientStatus) + "</PatientStatus>");
            sb.Append("<DeathDate>" + (DeathDate.IsNull ? "" : DeathDate.SelectedDate.ToString("yyyyMMdd")) + "</DeathDate>");
            sb.Append("<DeathTime>" + DeathTime.Text.Trim() + "</DeathTime>");
            sb.Append("<DeathCause>" + DeathCause.Text.Trim() + "</DeathCause>");
            sb.Append("<Witnessed>" + GetRadioGroupValue(Witnessed) + "</Witnessed>");
            sb.Append("<RelatedBSC>" + GetRadioGroupValue(RelatedBSC) + "</RelatedBSC>");
            sb.Append("<ISFORBSCPRODUCT>" + GetRadioGroupValue(IsForBSCProduct) + "</ISFORBSCPRODUCT>");
            sb.Append("<ReasonsForProduct>" + GetCheckboxGroupValue(ReasonsForProduct) + "</ReasonsForProduct>");
            sb.Append("<Returned>" + GetRadioGroupValue(Returned) + "</Returned>");
            sb.Append("<ReturnedDay>" + ReturnedDay.Text.Trim() + "</ReturnedDay>");
            sb.Append("<AnalysisReport>" + GetRadioGroupValue(AnalysisReport) + "</AnalysisReport>");
            sb.Append("<RequestPhysicianName>" + RequestPhysicianName.Text.Trim() + "</RequestPhysicianName>");
            sb.Append("<Warranty>" + GetRadioGroupValue(Warranty) + "</Warranty>");
            sb.Append("<Pulse>" + GetCheckboxGroupValue(this.Panel7, "Pulse", 15) + "</Pulse>");
            sb.Append("<Pulsebeats>" + Pulsebeats.Text.Trim() + "</Pulsebeats>");
            sb.Append("<Leads>" + GetCheckboxGroupValue(this.Panel7, "Leads", 11) + "</Leads>");
            sb.Append("<LeadsFracture>" + LeadsFracture.Text.Trim() + "</LeadsFracture>");
            sb.Append("<LeadsIssue>" + LeadsIssue.Text.Trim() + "</LeadsIssue>");
            sb.Append("<LeadsDislodgement>" + LeadsDislodgement.Text.Trim() + "</LeadsDislodgement>");
            sb.Append("<LeadsMeasurements>" + LeadsMeasurements.Text.Trim() + "</LeadsMeasurements>");
            sb.Append("<LeadsThresholds>" + LeadsThresholds.Text.Trim() + "</LeadsThresholds>");
            sb.Append("<LeadsBeats>" + LeadsBeats.Text.Trim() + "</LeadsBeats>");
            sb.Append("<LeadsNoise>" + LeadsNoise.Text.Trim() + "</LeadsNoise>");
            sb.Append("<LeadsLoss>" + LeadsLoss.Text.Trim() + "</LeadsLoss>");
            sb.Append("<Clinical>" + GetCheckboxGroupValue(this.Panel7, "Clinical", 12) + "</Clinical>");
            sb.Append("<ClinicalPerforation>" + ClinicalPerforation.Text.Trim() + "</ClinicalPerforation>");
            sb.Append("<ClinicalBeats>" + ClinicalBeats.Text.Trim() + "</ClinicalBeats>");
            sb.Append("<PulseModel>" + PulseModel.Text.Trim() + "</PulseModel>");
            sb.Append("<PulseSerial>" + PulseSerial.Text.Trim() + "</PulseSerial>");
            sb.Append("<PulseImplant>" + (PulseImplant.IsNull ? "" : PulseImplant.SelectedDate.ToString("yyyyMMdd")) + "</PulseImplant>");
            sb.Append("<Leads1Model>" + Leads1Model.Text.Trim() + "</Leads1Model>");
            sb.Append("<Leads1Serial>" + Leads1Serial.Text.Trim() + "</Leads1Serial>");
            sb.Append("<Leads1Implant>" + (Leads1Implant.IsNull ? "" : Leads1Implant.SelectedDate.ToString("yyyyMMdd")) + "</Leads1Implant>");
            sb.Append("<Leads1Position>" + GetRadioGroupValue(Leads1Position) + "</Leads1Position>");
            sb.Append("<Leads2Model>" + Leads2Model.Text.Trim() + "</Leads2Model>");
            sb.Append("<Leads2Serial>" + Leads2Serial.Text.Trim() + "</Leads2Serial>");
            sb.Append("<Leads2Implant>" + (Leads2Implant.IsNull ? "" : Leads2Implant.SelectedDate.ToString("yyyyMMdd")) + "</Leads2Implant>");
            sb.Append("<Leads2Position>" + GetRadioGroupValue(Leads2Position) + "</Leads2Position>");
            sb.Append("<Leads3Model>" + Leads3Model.Text.Trim() + "</Leads3Model>");
            sb.Append("<Leads3Serial>" + Leads3Serial.Text.Trim() + "</Leads3Serial>");
            sb.Append("<Leads3Implant>" + (Leads3Implant.IsNull ? "" : Leads3Implant.SelectedDate.ToString("yyyyMMdd")) + "</Leads3Implant>");
            sb.Append("<Leads3Position>" + GetRadioGroupValue(Leads3Position) + "</Leads3Position>");
            sb.Append("<AccessoryModel>" + AccessoryModel.Text.Trim() + "</AccessoryModel>");
            sb.Append("<AccessorySerial>" + AccessorySerial.Text.Trim() + "</AccessorySerial>");
            sb.Append("<AccessoryImplant>" + (AccessoryImplant.IsNull ? "" : AccessoryImplant.SelectedDate.ToString("yyyyMMdd")) + "</AccessoryImplant>");
            sb.Append("<AccessoryLot>" + AccessoryLot.Text.Trim() + "</AccessoryLot>");
            sb.Append("<ExplantDate>" + (ExplantDate.IsNull ? "" : ExplantDate.SelectedDate.ToString("yyyyMMdd")) + "</ExplantDate>");
            sb.Append("<RemainsService>" + GetRadioGroupValue(RemainsService) + "</RemainsService>");
            sb.Append("<RemovedService>" + GetRadioGroupValue(RemovedService) + "</RemovedService>");
            sb.Append("<Replace1Model>" + Replace1Model.Text.Trim() + "</Replace1Model>");
            sb.Append("<Replace1Serial>" + Replace1Serial.Text.Trim() + "</Replace1Serial>");
            sb.Append("<Replace1Implant>" + (Replace1Implant.IsNull ? "" : Replace1Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace1Implant>");
            sb.Append("<Replace2Model>" + Replace2Model.Text.Trim() + "</Replace2Model>");
            sb.Append("<Replace2Serial>" + Replace2Serial.Text.Trim() + "</Replace2Serial>");
            sb.Append("<Replace2Implant>" + (Replace2Implant.IsNull ? "" : Replace2Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace2Implant>");
            sb.Append("<Replace3Model>" + Replace3Model.Text.Trim() + "</Replace3Model>");
            sb.Append("<Replace3Serial>" + Replace3Serial.Text.Trim() + "</Replace3Serial>");
            sb.Append("<Replace3Implant>" + (Replace3Implant.IsNull ? "" : Replace3Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace3Implant>");
            sb.Append("<Replace4Model>" + Replace4Model.Text.Trim() + "</Replace4Model>");
            sb.Append("<Replace4Serial>" + Replace4Serial.Text.Trim() + "</Replace4Serial>");
            sb.Append("<Replace4Implant>" + (Replace4Implant.IsNull ? "" : Replace4Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace4Implant>");
            sb.Append("<Replace5Model>" + Replace5Model.Text.Trim() + "</Replace5Model>");
            sb.Append("<Replace5Serial>" + Replace5Serial.Text.Trim() + "</Replace5Serial>");
            sb.Append("<Replace5Implant>" + (Replace5Implant.IsNull ? "" : Replace5Implant.SelectedDate.ToString("yyyyMMdd")) + "</Replace5Implant>");
            sb.Append("<ProductExpDetail>" + ProductExpDetail.Text.Trim() + "</ProductExpDetail>");
            sb.Append("<CustomerComment>" + CustomerComment.Text.Trim() + "</CustomerComment>");

            sb.Append("<ISPLATFORM>" + GetRadioGroupValue(ISPLATFORM) + "</ISPLATFORM>");
            sb.Append("<BSCSOLDTOACCOUNT>" + BSCSOLDTOACCOUNT.Text.Trim() + "</BSCSOLDTOACCOUNT>");
            sb.Append("<BSCSOLDTONAME>" + BSCSOLDTONAME.Text.Trim() + "</BSCSOLDTONAME>");
            sb.Append("<BSCSOLDTOCITY>" + BSCSOLDTOCITY.Text.Trim() + "</BSCSOLDTOCITY>");
            sb.Append("<SUBSOLDTONAME>" + SUBSOLDTONAME.Text.Trim() + "</SUBSOLDTONAME>");
            sb.Append("<SUBSOLDTOCITY>" + SUBSOLDTOCITY.Text.Trim() + "</SUBSOLDTOCITY>");

            sb.Append("<DISTRIBUTORCITY>" + DISTRIBUTORCITY.Text.Trim() + "</DISTRIBUTORCITY>");

            sb.Append("<COMPLAINNBR></COMPLAINNBR>");
            sb.Append("<WHMID>" + Guid.Empty.ToString() + "</WHMID>");
            sb.Append("<EFINSTANCECODE></EFINSTANCECODE>");
            sb.Append("<REGISTRATION>" + this.Registration.Text.Trim() + "</REGISTRATION>");
            sb.Append("<SALESDATE></SALESDATE>");

            sb.Append("<RN>" + this.RN.Text.Trim() + "</RN>");
            sb.Append("<DATERECEIPT>" + this.DateReceipt.SelectedDate.ToString("yyyyMMdd") + "</DATERECEIPT>");
            sb.Append("<COMPLETEDPHONE>" + this.CompletedPhone.Text.Trim() + "</COMPLETEDPHONE>");
            sb.Append("<COMPLETEDEMAIL>" + this.CompletedEmail.Text.Trim() + "</COMPLETEDEMAIL>");
            sb.Append("<REMARK>" + String.Empty + "</REMARK>");
            sb.Append("<COMPLAINAPPROVELREMARK>" + this.ComplainApprovelRemark.Text.Trim() + "</COMPLAINAPPROVELREMARK>");

            sb.Append("<HasFollowOperation>" + GetRadioGroupValue(HasFollowOperation) + "</HasFollowOperation>");
            sb.Append("<FollowOperationDate>" + (FollowOperationDate.IsNull ? "" : FollowOperationDate.SelectedDate.ToString("yyyyMMdd")) + "</FollowOperationDate>");
            sb.Append("<FollowOperationStaff>" + GetRadioGroupValue(FollowOperationStaff) + "</FollowOperationStaff>");

            //包装数
            sb.Append("<ConvertFactor>" + this.hiddenConvertFactor.Text.Trim() + "</ConvertFactor>");
            //是否停产
            sb.Append("<CFN_Property4>" + this.hiddenCFN_Property4.Text.Trim() + "</CFN_Property4>");

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
            sb.Append("<PRODUCTTYPECRM>" + this.GetRadioGroupValue(this.PRODUCTTYPE) + "</PRODUCTTYPECRM>");
            sb.Append("<RETURNTYPECRM>" + this.hiddenRETURNTYPE.Text.Trim() + "</RETURNTYPECRM>");
            sb.Append("<HasSalesDateCRM>" + this.hiddenHasSalesDate.Text.Trim() + "</HasSalesDateCRM>");
            sb.Append("<CARRIERNUMBER>" + this.CarrierNumber.Text.Trim() + "</CARRIERNUMBER>");
            sb.Append("<REMARK>" + this.REMARK.Text.Trim() + "</REMARK>");
            sb.Append("<CourierCompany>" + this.CourierCompany.Text.Trim() + "</CourierCompany>");
            sb.Append("<ConfirmReturnOrRefund>" + this.hiddenRETURNTYPE.Text.Trim() + "</ConfirmReturnOrRefund>");
            sb.Append("<PropertyRights>" + this.PropertyRights.Text.Trim() + "</PropertyRights>");
            sb.Append("</DealerComplainReturn>");
            return sb.ToString();
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
                for (int i = 0; i < cg.Items.Count; i++)
                {
                    if (cg.Items[i] is CheckboxColumn)
                    {
                        CheckboxColumn cc = cg.Items[i] as CheckboxColumn;
                        for (int j = 0; j < cc.Items.Count; j++)
                        {
                            if (cc.Items[j] is Checkbox)
                            {
                                Checkbox cb = cc.Items[j] as Checkbox;
                                if (cb.Attributes["cvalue"].ToString() == v)
                                {
                                    cb.Checked = true;
                                }
                            }
                        }
                    }
                    else if (cg.Items[i] is Checkbox)
                    {
                        Checkbox cb = cg.Items[i];
                        if (cb.Attributes["cvalue"].ToString() == v)
                        {
                            cb.Checked = true;
                        }
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

        private void ShowTextBoxWhenChecked()
        {
            if (this.Pulse_9.Checked)
                this.Pulsebeats.Show();
            else
                this.Pulsebeats.Hide();

            if (this.Leads_1.Checked)
                this.LeadsFracture.Show();
            else
                this.LeadsFracture.Hide();

            if (this.Leads_2.Checked)
                this.LeadsIssue.Show();
            else
                this.LeadsIssue.Hide();

            if (this.Leads_3.Checked)
                this.LeadsDislodgement.Show();
            else
                this.LeadsDislodgement.Hide();

            if (this.Leads_4.Checked)
                this.LeadsMeasurements.Show();
            else
                this.LeadsMeasurements.Hide();

            if (this.Leads_6.Checked)
                this.LeadsThresholds.Show();
            else
                this.LeadsThresholds.Hide();

            if (this.Leads_7.Checked)
                this.LeadsBeats.Show();
            else
                this.LeadsBeats.Hide();

            if (this.Leads_8.Checked)
                this.LeadsNoise.Show();
            else
                this.LeadsNoise.Hide();

            if (this.Leads_9.Checked)
                this.LeadsLoss.Show();
            else
                this.LeadsLoss.Hide();

            if (this.Clinical_1.Checked)
                this.ClinicalPerforation.Show();
            else
                this.ClinicalPerforation.Hide();

            if (this.Clinical_3.Checked)
                this.ClinicalBeats.Show();
            else
                this.ClinicalBeats.Hide();

            if (this.PatientStatus_6.Checked)
            {
                this.deathTable1.Attributes["Style"] = "";
                this.deathTable2.Attributes["Style"] = "";
            }
            else
            {
                this.deathTable1.Attributes["Style"] = "display:none;";
                this.deathTable2.Attributes["Style"] = "display:none;";
            }

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

            if (this.AnalysisReport_1.Checked)
            {
                tdlblRequestPhysicianName.Attributes["Style"] = "";
                tdRequestPhysicianName.Attributes["Style"] = "";
            }
            else
            {
                tdlblRequestPhysicianName.Attributes["Style"] = "visibility:hidden;";
                tdRequestPhysicianName.Attributes["Style"] = "visibility:hidden;";
            }

            if (this.Returned_1.Checked)
            {
                tdlblReturnedDay.Attributes["Style"] = "";
                tdReturnedDay.Attributes["Style"] = "";
            }
            else
            {
                tdlblReturnedDay.Attributes["Style"] = "visibility:hidden;";
                tdReturnedDay.Attributes["Style"] = "visibility:hidden;";
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

        private void UpdateComplainStatus(string Status, string ComplainApprovelRemark = "")
        {
            String rtnVal = string.Empty;
            String rtnMsg = string.Empty;

            _business.UpdateDealerComplainStatusByFilter(CONST_COMPLAIN_TYPE, Status, ComplainApprovelRemark, this.InstanceId, this.LastUpdateDate, out rtnVal, out rtnMsg);

            if (rtnVal != "Success")
            {
                throw new Exception((string.IsNullOrEmpty(rtnMsg) ? "单据状态已改变，请刷新！" : "rtnMsg"));
            }
        }

        private void SaveComplainCrmInfo(string complainStatus)
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("CorpId", this.hiddenInitDealerId.Value);
            dealerComplainInfo.Add("ComplainType", "CRM");
            dealerComplainInfo.Add("ComplainStatus", complainStatus);
            dealerComplainInfo.Add("ComplainInfo", GenerateInfoXML());
            dealerComplainInfo.Add("Result", "");

            if (_business.ValidateComplainCanUpdate("CRM", this.InstanceId, this.LastUpdateDate))
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
                    param.Add("ComplainType", "CRM");
                    DataTable table = _business.DealerComplainInfo_SpecialDateFormat(param);

                    if (table.Rows.Count > 0)
                    {
                        //发送邮件及附件。
                        string rtnValMail = _business.DealerComplainCRMSendMailWithAttachment(table);

                        if (rtnValMail != "Success")
                        {
                            throw new Exception(rtnValMail);
                        }
                    }

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
            dealerComplainInfo.Add("ComplainType", "CRM");
            dealerComplainInfo.Add("ReturnStatus", returnStatus);
            dealerComplainInfo.Add("ComplainInfo", this.GenerateReturnInfoXML());
            dealerComplainInfo.Add("Result", "");

            if (_business.ValidateReturnCanUpdate("CRM", this.InstanceId, this.ConfirmUpdateDate))
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

        //private string CheckReturnType()
        //{
        //    string rtnMsg = "Success";
        //    string warehouse = this.hiddenWarehouseId.Text;
        //    if (!string.IsNullOrEmpty(warehouse) && warehouse != "00000000-0000-0000-0000-000000000000")
        //    {
        //        DataTable dt = _business.GetWarehouseTypeById(new Guid(warehouse)).Tables[0];


        //        string whmType = dt.Rows[0]["TypeFrom"].ToString();
        //        string dealerType = dt.Rows[0]["DealerType"].ToString();

        //        if (dealerType == DealerType.T2.ToString() && this.RETURNTYPE.SelectedItem.Value != "2" && this.RETURNTYPE.SelectedItem.Value != "3" && whmType == "LP")
        //        {
        //            this.RETURNTYPE.Value = "2";
        //            rtnMsg = "平台物权产品只能选择退款";
        //        }
        //        else if (whmType == "BSC" && this.RETURNTYPE.SelectedItem.Value != "5")
        //        {
        //            this.RETURNTYPE.Value = "5";
        //            rtnMsg = "波科物权产品只能选择只退不换";
        //        }
        //    }
        //    return rtnMsg;
        //}

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
        #endregion
    }
}