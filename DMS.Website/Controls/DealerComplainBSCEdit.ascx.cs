using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;
using System.Text;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerComplainBSCEdit")]
    public partial class DealerComplainBSCEdit : BaseUserControl
    {
        #region 数据字典

        //private IDictionary<string, string> _DIC_CONTACTMETHOD = null;
        //public IDictionary<string, string> DIC_CONTACTMETHOD
        //{
        //    get
        //    {
        //        if (_DIC_CONTACTMETHOD == null)
        //        {
        //            _DIC_CONTACTMETHOD = new Dictionary<string, string>();
        //            _DIC_CONTACTMETHOD.Add("1", "CNF");
        //            _DIC_CONTACTMETHOD.Add("2", "电子 CNF");
        //            _DIC_CONTACTMETHOD.Add("3", "电子邮件");
        //            _DIC_CONTACTMETHOD.Add("4", "传真");
        //            _DIC_CONTACTMETHOD.Add("5", "现场服务代表");
        //            _DIC_CONTACTMETHOD.Add("6", "邮件");
        //            _DIC_CONTACTMETHOD.Add("7", "电话");
        //            _DIC_CONTACTMETHOD.Add("8", "语音邮件");

        //        }
        //        return _DIC_CONTACTMETHOD;
        //    }
        //}

        //private IDictionary<string, string> _DIC_COMPLAINTSOURCE = null;
        //public IDictionary<string, string> DIC_COMPLAINTSOURCE
        //{
        //    get
        //    {
        //        if (_DIC_COMPLAINTSOURCE == null)
        //        {
        //            _DIC_COMPLAINTSOURCE = new Dictionary<string, string>();
        //            _DIC_COMPLAINTSOURCE.Add("1", "公司代表");
        //            _DIC_COMPLAINTSOURCE.Add("2", "消费者");
        //            _DIC_COMPLAINTSOURCE.Add("3", "经销商");
        //            _DIC_COMPLAINTSOURCE.Add("4", "外部");
        //            _DIC_COMPLAINTSOURCE.Add("5", "医疗专家");
        //            _DIC_COMPLAINTSOURCE.Add("6", "文献资料");
        //            _DIC_COMPLAINTSOURCE.Add("7", "研究");
        //            _DIC_COMPLAINTSOURCE.Add("8", "用户设备");
        //            _DIC_COMPLAINTSOURCE.Add("9", "其他 － 请说明");

        //        }
        //        return _DIC_COMPLAINTSOURCE;
        //    }
        //}

        //private IDictionary<string, string> _DIC_PRODUCTTYPE = null;
        //public IDictionary<string, string> DIC_PRODUCTTYPE
        //{
        //    get
        //    {
        //        if (_DIC_PRODUCTTYPE == null)
        //        {
        //            _DIC_PRODUCTTYPE = new Dictionary<string, string>();
        //            _DIC_PRODUCTTYPE.Add("1", "现金订货");
        //            _DIC_PRODUCTTYPE.Add("2", "寄售产品");
        //            _DIC_PRODUCTTYPE.Add("3", "短期借货");
        //            _DIC_PRODUCTTYPE.Add("4", "北京/广州 _FSL 借货");
        //            _DIC_PRODUCTTYPE.Add("5", "样品");
        //            _DIC_PRODUCTTYPE.Add("6", "机器/机器配件");
        //        }
        //        return _DIC_PRODUCTTYPE;
        //    }
        //}

        private IDictionary<string, string> _DIC_RETURNTYPE = null;
        public IDictionary<string, string> DIC_RETURNTYPE
        {
            get
            {
                if (_DIC_RETURNTYPE == null)
                {
                    _DIC_RETURNTYPE = new Dictionary<string, string>();
                    _DIC_RETURNTYPE.Add("10", "换货");
                    _DIC_RETURNTYPE.Add("11", "退款");
                    _DIC_RETURNTYPE.Add("12", "只退不换");
                    //_DIC_RETURNTYPE.Add("13", "仅投诉事件");
                    //_DIC_RETURNTYPE.Add("14", "已上报投诉仅换货");
                }
                return _DIC_RETURNTYPE;
            }
        }

        //private IDictionary<string, string> _DIC_SINGLEUSE = null;
        //public IDictionary<string, string> DIC_SINGLEUSE
        //{
        //    get
        //    {
        //        if (_DIC_SINGLEUSE == null)
        //        {
        //            _DIC_SINGLEUSE = new Dictionary<string, string>();
        //            _DIC_SINGLEUSE.Add("1", "是");
        //            _DIC_SINGLEUSE.Add("2", "否");
        //        }
        //        return _DIC_SINGLEUSE;
        //    }
        //}

        //private IDictionary<string, string> _DIC_RESTERILIZED = null;
        //public IDictionary<string, string> DIC_RESTERILIZED
        //{
        //    get
        //    {
        //        if (_DIC_RESTERILIZED == null)
        //        {
        //            _DIC_RESTERILIZED = new Dictionary<string, string>();
        //            _DIC_RESTERILIZED.Add("1", "是");
        //            _DIC_RESTERILIZED.Add("2", "否");
        //            _DIC_RESTERILIZED.Add("3", "不知道");
        //            _DIC_RESTERILIZED.Add("4", "不适用");
        //        }
        //        return _DIC_RESTERILIZED;
        //    }
        //}

        //private IDictionary<string, string> _DIC_USEDEXPIRY = null;
        //public IDictionary<string, string> DIC_USEDEXPIRY
        //{
        //    get
        //    {
        //        if (_DIC_USEDEXPIRY == null)
        //        {
        //            _DIC_USEDEXPIRY = new Dictionary<string, string>();
        //            _DIC_USEDEXPIRY.Add("1", "是");
        //            _DIC_USEDEXPIRY.Add("2", "否");
        //            _DIC_USEDEXPIRY.Add("4", "不适用");
        //        }
        //        return _DIC_USEDEXPIRY;
        //    }
        //}

        //private IDictionary<string, string> _DIC_UPNEXPECTED = null;
        //public IDictionary<string, string> DIC_UPNEXPECTED
        //{
        //    get
        //    {
        //        if (_DIC_UPNEXPECTED == null)
        //        {
        //            _DIC_UPNEXPECTED = new Dictionary<string, string>();
        //            _DIC_UPNEXPECTED.Add("1", "是");
        //            _DIC_UPNEXPECTED.Add("2", "否");
        //            _DIC_UPNEXPECTED.Add("3", "不知道");
        //        }
        //        return _DIC_UPNEXPECTED;
        //    }
        //}

        //private IDictionary<string, string> _DIC_NORETURN = null;
        //public IDictionary<string, string> DIC_NORETURN
        //{
        //    get
        //    {
        //        if (_DIC_NORETURN == null)
        //        {
        //            _DIC_NORETURN = new Dictionary<string, string>();
        //            _DIC_NORETURN.Add("10", "已污染");
        //            _DIC_NORETURN.Add("20", "已丢弃");
        //            _DIC_NORETURN.Add("30", "已植入");
        //            _DIC_NORETURN.Add("40", "保留在医院");
        //            _DIC_NORETURN.Add("50", "不适用");
        //            _DIC_NORETURN.Add("99", "其他 - 请说明");
        //        }
        //        return _DIC_NORETURN;
        //    }
        //}

        //private IDictionary<string, string> _DIC_POUTCOME = null;
        //public IDictionary<string, string> DIC_POUTCOME
        //{
        //    get
        //    {
        //        if (_DIC_POUTCOME == null)
        //        {
        //            _DIC_POUTCOME = new Dictionary<string, string>();
        //            _DIC_POUTCOME.Add("1", "使用此器械完成");
        //            _DIC_POUTCOME.Add("2", "使用另一件相同器械完成");
        //            _DIC_POUTCOME.Add("3", "使用其他器械完成");
        //            _DIC_POUTCOME.Add("4", "由于此事件而未能完成");
        //            _DIC_POUTCOME.Add("5", "由于缺乏相同器械而未能完成");
        //            _DIC_POUTCOME.Add("6", "由于其他原因而未能完成");
        //            _DIC_POUTCOME.Add("99", "不清楚");
        //        }
        //        return _DIC_POUTCOME;
        //    }
        //}

        //private IDictionary<string, string> _DIC_IVUS = null;
        //public IDictionary<string, string> DIC_IVUS
        //{
        //    get
        //    {
        //        if (_DIC_IVUS == null)
        //        {
        //            _DIC_IVUS = new Dictionary<string, string>();
        //            _DIC_IVUS.Add("1", "是");
        //            _DIC_IVUS.Add("2", "否");
        //        }
        //        return _DIC_IVUS;
        //    }
        //}

        //private IDictionary<string, string> _DIC_GENERATOR = null;
        //public IDictionary<string, string> DIC_GENERATOR
        //{
        //    get
        //    {
        //        if (_DIC_GENERATOR == null)
        //        {
        //            _DIC_GENERATOR = new Dictionary<string, string>();
        //            _DIC_GENERATOR.Add("1", "是");
        //            _DIC_GENERATOR.Add("2", "否");
        //        }
        //        return _DIC_GENERATOR;
        //    }
        //}

        //private IDictionary<string, string> _DIC_PCONDITION = null;
        //public IDictionary<string, string> DIC_PCONDITION
        //{
        //    get
        //    {
        //        if (_DIC_PCONDITION == null)
        //        {
        //            _DIC_PCONDITION = new Dictionary<string, string>();
        //            _DIC_PCONDITION.Add("1", "稳定");
        //            _DIC_PCONDITION.Add("2", "接受手术治疗");
        //            _DIC_PCONDITION.Add("3", "死亡");
        //            _DIC_PCONDITION.Add("99", "其他");
        //        }
        //        return _DIC_PCONDITION;
        //    }
        //}

        //private IDictionary<string, string> _DIC_WHEREOCCUR = null;
        //public IDictionary<string, string> DIC_WHEREOCCUR
        //{
        //    get
        //    {
        //        if (_DIC_WHEREOCCUR == null)
        //        {
        //            _DIC_WHEREOCCUR = new Dictionary<string, string>();
        //            _DIC_WHEREOCCUR.Add("1", "患者体内");
        //            _DIC_WHEREOCCUR.Add("2", "患者体外");
        //            _DIC_WHEREOCCUR.Add("80", "不适用");
        //            _DIC_WHEREOCCUR.Add("99", "不清楚");
        //        }
        //        return _DIC_WHEREOCCUR;
        //    }
        //}

        //private IDictionary<string, string> _DIC_WHENNOTICED = null;
        //public IDictionary<string, string> DIC_WHENNOTICED
        //{
        //    get
        //    {
        //        if (_DIC_WHENNOTICED == null)
        //        {
        //            _DIC_WHENNOTICED = new Dictionary<string, string>();
        //            _DIC_WHENNOTICED.Add("1", "打开包装时");
        //            _DIC_WHENNOTICED.Add("2", "准备手术时");
        //            _DIC_WHENNOTICED.Add("3", "插入时");
        //            _DIC_WHENNOTICED.Add("4", "手术过程中");
        //            _DIC_WHENNOTICED.Add("5", "退出时");
        //            _DIC_WHENNOTICED.Add("6", "手术结束时");
        //            _DIC_WHENNOTICED.Add("7", "术后");
        //            _DIC_WHENNOTICED.Add("99", "不清楚");
        //        }
        //        return _DIC_WHENNOTICED;
        //    }
        //}

        //private IDictionary<string, string> _DIC_WITHLABELEDUSE = null;
        //public IDictionary<string, string> DIC_WITHLABELEDUSE
        //{
        //    get
        //    {
        //        if (_DIC_WITHLABELEDUSE == null)
        //        {
        //            _DIC_WITHLABELEDUSE = new Dictionary<string, string>();
        //            _DIC_WITHLABELEDUSE.Add("1", "是");
        //            _DIC_WITHLABELEDUSE.Add("2", "否");
        //        }
        //        return _DIC_WITHLABELEDUSE;
        //    }
        //}

        //private IDictionary<string, string> _DIC_EVENTRESOLVED = null;
        //public IDictionary<string, string> DIC_EVENTRESOLVED
        //{
        //    get
        //    {
        //        if (_DIC_EVENTRESOLVED == null)
        //        {
        //            _DIC_EVENTRESOLVED = new Dictionary<string, string>();
        //            _DIC_EVENTRESOLVED.Add("1", "是");
        //            _DIC_EVENTRESOLVED.Add("2", "否");
        //            _DIC_EVENTRESOLVED.Add("5", "不清楚");
        //        }
        //        return _DIC_EVENTRESOLVED;
        //    }
        //}

        #endregion

        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerComplainBLL _business = new DealerComplainBLL();
        private IPurchaseOrderBLL _businessPurchaseOrder = new PurchaseOrderBLL();
        private QueryInventoryBiz _businessQueryInv = new QueryInventoryBiz();
        private Hospitals _hospital = new Hospitals();
      
        private ICfns _cfn = new Cfns();
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        #endregion

        #region 公开属性
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

        public String ShowType
        {
            get
            {
                return this.hidShowType.Text;
            }
            set
            {
                this.hidShowType.Text = value.ToString();
            }
        }
        #endregion

        #region 数据绑定

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                BindDictionary();
                //if (IsDealer)
                //{
                //    //this.Bind_WarehouseByDealerAndType(WarehouseStore, _context.User.CorpId.Value, "");
                    
                //}
                //else
                //{
                    
                //}
            }
        }

        #endregion

        #region Ajax Method

        public void Show(Guid id,String type)
        {
           
            this.InstanceId = id;
            this.ShowType = type;
            this.Panel71.Show();
            Clear(BorderLayout2);
            if (type=="New" && id == Guid.Empty)
            {
                InitInput();
                SetEnable(BorderLayout2, false);
                this.FSLog.Hidden= true;
            }
            else if (type == "New" && id != Guid.Empty)
            {   
                InitInput();
                CopyBSCInfo();
                SetEnable(BorderLayout2, false);
                this.FSLog.Hidden = true;
            }
            else
            {
                //if (!IsDealer)
                //{
                    //获取仓库
                    Hashtable param = new Hashtable();
                    param.Add("DC_ID", this.InstanceId);
                    param.Add("ComplainType", "BSC");
                    DataRow r = _business.DealerComplainInfo(param).Rows[0];
                    this.Bind_WarehouseByDealerAndType(WarehouseStore, new Guid(r["DC_CorpId"].ToString()), "Complain");
                //}
                //else
                //{
                //    this.Bind_WarehouseByDealerAndType(WarehouseStore, _context.User.CorpId.Value, "Complain");
                //}

                LoadBSCInfo();
                SetEnable(BorderLayout2, true);
                SubmitButton.Visible = true;
                this.FSLog.Hidden = false;
                //RowLayoutTop.Hidden = true;

            }
            this.DetailWindow.Show();
            this.DetailWindow.Maximize();
        }

        [AjaxMethod]
        public void DoSubmit()
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            Hashtable chkCondition = new Hashtable();
            chkCondition.Add("WHMID", new Guid(cbWarehouse.SelectedItem.Value.ToString()));
            chkCondition.Add("DMAID", _context.User.CorpId.Value);
            chkCondition.Add("UPN", this.cbUPN.SelectedItem.Value);
            chkCondition.Add("LOT", this.cbLOT.SelectedItem.Value);
            chkCondition.Add("RETURNNUM", Convert.ToDecimal(TBNUM.Text.Trim()));
            chkCondition.Add("ImplantDate", this.INITIALPDATE.SelectedDate);
            chkCondition.Add("EventDate", this.EDATE.SelectedDate);
            chkCondition.Add("ComplainType", "BSC");
            _business.CheckUPNAndDate(chkCondition, out rtnVal, out rtnMsg);

            if (rtnVal.Equals("Success"))
            {
                Hashtable dealerComplainInfo = new Hashtable();
                dealerComplainInfo.Add("UserId", _context.User.Id);
                dealerComplainInfo.Add("CorpId", _context.User.CorpId.Value);
                dealerComplainInfo.Add("ComplainType", "BSC");
                dealerComplainInfo.Add("ComplainInfo", GenerateInfoXML());
                dealerComplainInfo.Add("Result", "");

                rtnVal = _business.DealerComplainSave(dealerComplainInfo);
                this.hidRtnVal.Text = rtnVal;
            }
            else
            {
                this.hidRtnVal.Text = rtnMsg;
            }
           
        }

        [AjaxMethod]
        public void DoCancel()
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("CarrierNumber", this.tbRemark.Text);
            dealerComplainInfo.Add("ComplainType", "BSC");
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("Status", "Revoke");
            dealerComplainInfo.Add("DMSBSCCode", "");
            _business.UpdateBSCRevoke(dealerComplainInfo);          
        }

        [AjaxMethod]
        public void DoConfirm()
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("ComplainType", "BSC");
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("CarrierNumber", null);
            dealerComplainInfo.Add("Status", "DealerCompleted");
            dealerComplainInfo.Add("DMSBSCCode", "");

            _business.DealerComplainConfirm(dealerComplainInfo);
        }

        [AjaxMethod]
        public void ShowCarrierWindow()
        {
            this.tbRemark.Clear();
            //Show Window
            this.windowCarrier.Show();
        }

        [AjaxMethod]
        public void SubmitCarrier()
        {
            Hashtable dealerComplainInfo = new Hashtable();
            dealerComplainInfo.Add("UserId", _context.User.Id);
            dealerComplainInfo.Add("CarrierNumber", this.tbRemark.Text);
            dealerComplainInfo.Add("ComplainType", "BSC");
            dealerComplainInfo.Add("InstanceId", this.InstanceId);
            dealerComplainInfo.Add("Status", "UploadCarrier");
            dealerComplainInfo.Add("DMSBSCCode", "");
            _business.UpdateBSCCarrierNumber(dealerComplainInfo);

            //修改信息
            windowCarrier.Hide();
        }

        [AjaxMethod]
        public void AuotCompleteUPNInfo()
        {
            //获取产品信息
            try
            {
                Hashtable condition = new Hashtable();
                condition.Add("LOT", this.cbLOT.SelectedItem.Value);
                condition.Add("UPN", this.cbUPN.SelectedItem.Value);
                IList<ProductDataForQAComplain> prdData = _cfn.QueryProductDataInfoByUPN(condition);
                if (prdData.Count > 0)
                {
                    this.BU.Text = prdData[0].ProductLine;
                    this.DESCRIPTION.Text = prdData[0].CNName;
                    this.ConvertFactor.Text = prdData[0].ConvertFactor.ToString();
                    this.TBNUM.Text = prdData[0].FactorNumber.ToString();
                    this.UPNExpDate.Text = prdData[0].UPNExpDate.ToString();
                    this.txtQrCode.Text = this.cbLOT.SelectedItem.Value.Split(new char[2] { '@', '@' })[2].ToString();

                    this.txtRegistration.Text = prdData[0].Registration.ToString();
                    if (!string.IsNullOrEmpty(prdData[0].SalesDate.ToString()))
                    {
                        this.SalesDate.SelectedDate = Convert.ToDateTime(prdData[0].SalesDate.ToString());
                    }
                    this.SalesDate.Enabled = string.IsNullOrEmpty(prdData[0].SalesDate.ToString());
                }
            } catch (Exception ex)
            {
                
            }
        }

        [AjaxMethod]
        public void CheckInitialDate()
        {
           //产品有效期不能大于
        }

        [AjaxMethod]
        public void CheckEDate()
        {

        }

        [AjaxMethod]
        public void CheckUPNAndDate()
        {
            //String rtnValue = String.Empty;

            ////判断是否填写内容
            //if (String.IsNullOrEmpty(this.cbUPN.SelectedItem.Value))
            //{
            //    this.hidCheckUPNRtnVal.Text = "请填写产品型号";
            //}
            //else if (String.IsNullOrEmpty(this.cbLOT.SelectedItem.Value))
            //{
            //    this.hidCheckUPNRtnVal.Text = "请填写产品批号";
            //}
            //else if (String.IsNullOrEmpty(this.INITIALPDATE.IsNull ? "" : this.INITIALPDATE.SelectedDate.ToString("yyyyMMdd")))
            //{
            //    this.hidCheckUPNRtnVal.Text = "请填写首次手术日期";
            //}
            //else if (String.IsNullOrEmpty(this.EDATE.IsNull ? "" : this.EDATE.SelectedDate.ToString("yyyyMMdd")))
            //{
            //    this.hidCheckUPNRtnVal.Text = "请填写事件日期";
            //}
            //else  //对填写的信息进行校验
            //{
            //    //校验UPN是否存在、对应的LOT是否存在；同时校验是否有对应的销售记录
            //    //校验手术日期是否大于产品有效期，同时校验事件日期是否大于手术日期

            //    Hashtable chkCondition = new Hashtable();
            //    chkCondition.Add("DMAID", _context.User.CorpId.Value);
            //    chkCondition.Add("UPN", this.cbUPN.SelectedItem.Value);
            //    chkCondition.Add("LOT", this.cbLOT.SelectedItem.Value);
            //    chkCondition.Add("ImplantDate", this.INITIALPDATE.SelectedDate);
            //    chkCondition.Add("EventDate", this.EDATE.SelectedDate);
            //    chkCondition.Add("ComplainType", "BSC");

            //    string rtnVal = string.Empty;
            //    string rtnMsg = string.Empty;

            //    _business.CheckUPNAndDate(chkCondition, out rtnVal, out rtnMsg);
            //    if (rtnVal.Equals("Success"))
            //    {
            //        //获取产品信息

            //        IList<ProductData> prdData = _cfn.QueryProductDataInfoByUPN(this.cbUPN.SelectedItem.Value);
            //        if (prdData.Count > 0)
            //        {
            //            this.BU.Text = prdData[0].ProductLine;
            //            this.DESCRIPTION.Text = prdData[0].CNName;
            //        }
            //        this.TBUPN.Text = this.cbUPN.SelectedItem.Value;
            //        this.TBLOT.Text = this.cbLOT.SelectedItem.Value;
            //        this.TBINITIALPDATE.Text = this.INITIALPDATE.SelectedDate.ToString();
            //        this.TBEDATE.Text = this.EDATE.SelectedDate.ToString();



            //        this.hidCheckUPNRtnVal.Text = rtnVal;
            //    }
            //    else
            //    {
            //        this.hidCheckUPNRtnVal.Text = rtnMsg;
            //    }
            //}

        }



        [AjaxMethod]
        public void CancelCheckUPNAndDate()
        {

        }

        [AjaxMethod]
        public void CheckReturnType()
        {
            string warehouse = this.cbWarehouse.SelectedItem.Value;
            if (!string.IsNullOrEmpty(warehouse) && warehouse != "00000000-0000-0000-0000-000000000000")
            {
                string whmtype = _business.GetWarehouseTypeById(new Guid(warehouse)).Tables[0].Rows[0]["TypeFrom"].ToString();
                if (_context.User.CorpType == DealerType.T2.ToString() && this.RETURNTYPE.SelectedItem.Value != "11" && this.RETURNTYPE.SelectedItem.Value != "13" && whmtype == "LP" )
                {
                    this.RETURNTYPE.Value = "11";
                    //Ext.Msg.Alert("Failure", "平台物权产品只能选择退款或仅投诉事件").Show();
                    Ext.Msg.Alert("Failure", "平台物权产品只能选择退款").Show();
                }
                else if (_context.User.CorpType == DealerType.T2.ToString() && whmtype == "T2" && Convert.ToDecimal(ConvertFactor.Text) > 1)
                {
                    this.RETURNTYPE.Value = "11";
                    Ext.Msg.Alert("Failure", "二级物权产品的多片包装产品只能选择退款").Show();
                }
                else if (whmtype == "BSC" && this.RETURNTYPE.SelectedItem.Value != "12" && Convert.ToDecimal(ConvertFactor.Text) == 1)
                {
                    this.RETURNTYPE.Value = "12";
                    Ext.Msg.Alert("Failure", "波科物权产品只能选择只退不换").Show();
                }
                else if (whmtype == "BSC" && Convert.ToDecimal(ConvertFactor.Text) > 1)
                {
                    this.RETURNTYPE.Value = "11";
                    Ext.Msg.Alert("Message", "波科物权产品请先整盒买断后单片退款").Show();
                }
            }
            else if (warehouse == "00000000-0000-0000-0000-000000000000")//销售到医院
            {
                if (this.RETURNTYPE.SelectedItem.Value != "11" && Convert.ToDecimal(ConvertFactor.Text) > 1)
                {
                    this.RETURNTYPE.Value = "11";
                    Ext.Msg.Alert("Failure", "医院物权产品多片包装只能选择退款").Show();
                }
                else if (this.RETURNTYPE.SelectedItem.Value != "10" && Convert.ToDecimal(ConvertFactor.Text) == 1)
                {
                    this.RETURNTYPE.Value = "10";
                    Ext.Msg.Alert("Failure", "医院物权产品整盒装只能选择换货").Show();
                }
            }
        }

        public void PRODUCTTYPE_25_CheckedChanged(object sender, EventArgs e)
        {
            Ext.Msg.Alert("Message", "如果物权是平台或T1，或为多包装产品，请选择退款处理").Show();
        }

        public void UPNEXPECTED1_Check(object sender, AjaxEventArgs e)
        {
            if (this.UPNEXPECTED_1.Checked)
            {
                this.UPNQUANTITY.Text = "1";
            }
            else
            {
                this.UPNQUANTITY.Text = "0";
            }

        }

        public void UPNEXPECTED2_Check(object sender, AjaxEventArgs e)
        {
            if (this.UPNEXPECTED_2.Checked)
            {
                this.UPNQUANTITY.Text = "0";
            }
            else
            {
                this.UPNQUANTITY.Text = "1";
            }
        }

        #endregion

        #region 页面私有方法

        private String GenerateInfoXML()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<DealerComplain>");

            //sb.Append("<DC_ID>" + DC_ID + "</DC_ID>");
            //sb.Append("<DC_ComplainNbr>" + DC_ComplainNbr + "</DC_ComplainNbr>");
            //sb.Append("<DC_Status>" + DC_Status + "</DC_Status>");
            //sb.Append("<DC_CreatedBy>" + DC_CreatedBy + "</DC_CreatedBy>");
            //sb.Append("<DC_CreatedDate>" + DC_CreatedDate + "</DC_CreatedDate>");
            //sb.Append("<DC_LastModifiedBy>" + DC_LastModifiedBy + "</DC_LastModifiedBy>");
            //sb.Append("<DC_LastModifiedDate>" + DC_LastModifiedDate + "</DC_LastModifiedDate>");
            sb.Append("<EID>" + _context.User.Id + "</EID>");
            sb.Append("<REQUESTDATE>" + REQUESTDATE.Text.Trim() + "</REQUESTDATE>");
            sb.Append("<INITIALNAME>" + INITIALNAME.Text.Trim() + "</INITIALNAME>");
            sb.Append("<INITIALPHONE>" + INITIALPHONE.Text.Trim() + "</INITIALPHONE>");
            sb.Append("<INITIALJOB>" + INITIALJOB.Text.Trim() + "</INITIALJOB>");
            sb.Append("<INITIALEMAIL>" + INITIALEMAIL.Text.Trim() + "</INITIALEMAIL>");
            sb.Append("<PHYSICIAN>" + PHYSICIAN.Text.Trim() + "</PHYSICIAN>");
            sb.Append("<PHYSICIANPHONE>" + PHYSICIANPHONE.Text.Trim() + "</PHYSICIANPHONE>");
            sb.Append("<FIRSTBSCNAME>" + BSCSalesName.Text.Trim() + "</FIRSTBSCNAME>");
            //sb.Append("<BSCAWAREDATE>" +(BSCAWAREDATE.IsNull ? "" : BSCAWAREDATE.SelectedDate.ToString("yyyyMMdd")) + "</BSCAWAREDATE>");
            sb.Append("<BSCAWAREDATE>" + DateTime.Now.ToString() + "</BSCAWAREDATE>");            
            sb.Append("<NOTIFYDATE>" + NOTIFYDATE.Text.Trim() + "</NOTIFYDATE>");
            sb.Append("<CONTACTMETHOD>" + GetCheckboxGroupValue(CONTACTMETHOD) + "</CONTACTMETHOD>");
            sb.Append("<COMPLAINTSOURCE>" + GetCheckboxGroupValue(COMPLAINTSOURCE) + "</COMPLAINTSOURCE>");
            sb.Append("<FEEDBACKREQUESTED>" + GetRadioGroupValue(FEEDBACKREQUESTED) + "</FEEDBACKREQUESTED>");
            sb.Append("<FEEDBACKSENDTO>" + FEEDBACKSENDTO.Text.Trim() + "</FEEDBACKSENDTO>");
            sb.Append("<COMPLAINTID>" + COMPLAINTID.Text.Trim() + "</COMPLAINTID>");
            sb.Append("<REFERBOX>" + REFERBOX.Text.Trim() + "</REFERBOX>");
            sb.Append("<PRODUCTTYPE>" + GetRadioGroupValue(PRODUCTTYPE) + "</PRODUCTTYPE>");
            sb.Append("<RETURNTYPE>" + RETURNTYPE.SelectedItem.Value + "</RETURNTYPE>");
            sb.Append("<ISPLATFORM>" + GetRadioGroupValue(ISPLATFORM) + "</ISPLATFORM>");
            sb.Append("<BSCSOLDTOACCOUNT>" + BSCSOLDTOACCOUNT.Text.Trim() + "</BSCSOLDTOACCOUNT>");
            sb.Append("<BSCSOLDTONAME>" + BSCSOLDTONAME.Text.Trim() + "</BSCSOLDTONAME>");
            sb.Append("<BSCSOLDTOCITY>" + BSCSOLDTOCITY.Text.Trim() + "</BSCSOLDTOCITY>");
            sb.Append("<SUBSOLDTONAME>" + SUBSOLDTONAME.Text.Trim() + "</SUBSOLDTONAME>");
            sb.Append("<SUBSOLDTOCITY>" + SUBSOLDTOCITY.Text.Trim() + "</SUBSOLDTOCITY>");
            //sb.Append("<DISTRIBUTORCUSTOMER>" + DISTRIBUTORCUSTOMER.Text.Trim() + "</DISTRIBUTORCUSTOMER>");
            sb.Append("<DISTRIBUTORCUSTOMER>" + cbHospital.SelectedItem.Value.Trim() + "</DISTRIBUTORCUSTOMER>");
            sb.Append("<DISTRIBUTORCITY>" + DISTRIBUTORCITY.Text.Trim() + "</DISTRIBUTORCITY>");
            sb.Append("<UPN>" + cbUPN.SelectedItem.Value.Trim() + "</UPN>");
            //sb.Append("<UPN>644471-218</UPN>");
            sb.Append("<DESCRIPTION>" + DESCRIPTION.Text.Trim() + "</DESCRIPTION>");
            sb.Append("<LOT>" + cbLOT.SelectedItem.Value.Trim() + "</LOT>");
            sb.Append("<BU>" + BU.Text.Trim() + "</BU>");
            sb.Append("<SINGLEUSE>" + GetRadioGroupValue(SINGLEUSE) + "</SINGLEUSE>");
            sb.Append("<RESTERILIZED>" + GetRadioGroupValue(RESTERILIZED) + "</RESTERILIZED>");
            sb.Append("<PREPROCESSOR>" + PREPROCESSOR.Text.Trim() + "</PREPROCESSOR>");
            sb.Append("<USEDEXPIRY>" + GetRadioGroupValue(USEDEXPIRY) + "</USEDEXPIRY>");
            sb.Append("<UPNEXPECTED>" + GetRadioGroupValue(UPNEXPECTED) + "</UPNEXPECTED>");
            sb.Append("<UPNQUANTITY>" + UPNQUANTITY.Text.Trim() + "</UPNQUANTITY>");
            sb.Append("<NORETURN>" + GetCheckboxGroupValue(NORETURN) + "</NORETURN>");
            sb.Append("<NORETURNREASON>" + NORETURNREASON.Text.Trim() + "</NORETURNREASON>");
            sb.Append("<INITIALPDATE>" + (INITIALPDATE.IsNull ? "" : INITIALPDATE.SelectedDate.ToString("yyyyMMdd")) + "</INITIALPDATE>");
            sb.Append("<PNAME>" + PNAME.Text.Trim() + "</PNAME>");
            sb.Append("<INDICATION>" + INDICATION.Text.Trim() + "</INDICATION>");
            sb.Append("<IMPLANTEDDATE>" + (IMPLANTEDDATE.IsNull ? "" : IMPLANTEDDATE.SelectedDate.ToString("yyyyMMdd")) + "</IMPLANTEDDATE>");
            sb.Append("<EXPLANTEDDATE>" + (EXPLANTEDDATE.IsNull ? "" : EXPLANTEDDATE.SelectedDate.ToString("yyyyMMdd")) + "</EXPLANTEDDATE>");
            sb.Append("<POUTCOME>" + GetCheckboxGroupValue(POUTCOME) + "</POUTCOME>");
            sb.Append("<IVUS>" + GetRadioGroupValue(IVUS) + "</IVUS>");
            sb.Append("<GENERATOR>" + GetRadioGroupValue(GENERATOR) + "</GENERATOR>");
            sb.Append("<GENERATORTYPE>" + GENERATORTYPE.Text.Trim() + "</GENERATORTYPE>");
            sb.Append("<GENERATORSET>" + GENERATORSET.Text.Trim() + "</GENERATORSET>");
            sb.Append("<PCONDITION>" + GetRadioGroupValue(PCONDITION) + "</PCONDITION>");
            sb.Append("<PCONDITIONOTHER>" + PCONDITIONOTHER.Text.Trim() + "</PCONDITIONOTHER>");
            sb.Append("<EDATE>" + (EDATE.IsNull ? "" : EDATE.SelectedDate.ToString("yyyyMMdd")) + "</EDATE>");
            sb.Append("<WHEREOCCUR>" + GetCheckboxGroupValue(WHEREOCCUR) + "</WHEREOCCUR>");
            sb.Append("<WHENNOTICED>" + GetCheckboxGroupValue(WHENNOTICED) + "</WHENNOTICED>");
            sb.Append("<EDESCRIPTION>" + EDESCRIPTION.Text.Trim() + "</EDESCRIPTION>");
            sb.Append("<WITHLABELEDUSE>" + GetRadioGroupValue(WITHLABELEDUSE) + "</WITHLABELEDUSE>");
            sb.Append("<NOLABELEDUSE>" + NOLABELEDUSE.Text.Trim() + "</NOLABELEDUSE>");
            sb.Append("<EVENTRESOLVED>" + GetRadioGroupValue(EVENTRESOLVED) + "</EVENTRESOLVED>");

            //add by songweiming on 2014-4-24 增加销售人员信息、单据编号
            sb.Append("<BSCSALESNAME>" + BSCSalesName.Text.Trim() + "</BSCSALESNAME>");
            sb.Append("<BSCSALESPHONE>" + BSCSalesPhone.Text.Trim() + "</BSCSALESPHONE>");

            sb.Append("<WHMID>" + cbWarehouse.SelectedItem.Value.ToString() + "</WHMID>");
            sb.Append("<RETURNNUM>" + TBNUM.Text.Trim() + "</RETURNNUM>");
            sb.Append("<CONVERTFACTOR>" + ConvertFactor.Text.Trim() + "</CONVERTFACTOR>");
            sb.Append("<UPNEXPDATE>" + UPNExpDate.Text.Trim() + "</UPNEXPDATE>");

            sb.Append("<EFINSTANCECODE></EFINSTANCECODE>");

            sb.Append("<REGISTRATION>" + txtRegistration.Text.Trim() + "</REGISTRATION>");
            sb.Append("<SALESDATE>" + (SalesDate.IsNull ? "" : SalesDate.SelectedDate.ToString("yyyyMMdd")) + "</SALESDATE>");
            //获取单据编号
            AutoNumberBLL auto = new AutoNumberBLL();
            String autoNbr = auto.GetNextAutoNumber(_context.User.CorpId.Value, OrderType.Next_ComplainNbr);
            sb.Append("<COMPLAINNBR>" + autoNbr + "</COMPLAINNBR>");

            sb.Append("</DealerComplain>");
            return sb.ToString();
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

        private void BindDictionary()
        {
            //    foreach (var item in DIC_CONTACTMETHOD)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "CONTACTMETHOD_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        CONTACTMETHOD.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_COMPLAINTSOURCE)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "COMPLAINTSOURCE_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        COMPLAINTSOURCE.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_PRODUCTTYPE)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "PRODUCTTYPE_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        PRODUCTTYPE.Items.Add(cb);
            //    }

            StoreRETURNTYPE.DataSource = DIC_RETURNTYPE;
            StoreRETURNTYPE.DataBind();


            //Hashtable ht = new Hashtable();
            //if ( IsDealer){
            //    ht.Add("CorpId", _context.User.CorpId.Value);
            //}            
            //StoreUPN.DataSource = _business.GetDealerComplainUPN(ht);
            //StoreUPN.DataBind();

            //    foreach (var item in DIC_SINGLEUSE)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "SINGLEUSE_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        SINGLEUSE.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_RESTERILIZED)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "RESTERILIZED_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        RESTERILIZED.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_USEDEXPIRY)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "USEDEXPIRY_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        USEDEXPIRY.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_UPNEXPECTED)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "UPNEXPECTED_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        UPNEXPECTED.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_NORETURN)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "NORETURN_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        NORETURN.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_POUTCOME)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "POUTCOME_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        POUTCOME.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_IVUS)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "IVUS_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        IVUS.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_GENERATOR)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "GENERATOR_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        GENERATOR.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_PCONDITION)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "PCONDITION_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        PCONDITION.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_WHEREOCCUR)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "WHEREOCCUR_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        WHEREOCCUR.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_WHENNOTICED)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "WHENNOTICED_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        WHENNOTICED.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_WITHLABELEDUSE)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "WITHLABELEDUSE_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        WITHLABELEDUSE.Items.Add(cb);
            //    }

            //    foreach (var item in DIC_EVENTRESOLVED)
            //    {
            //        Checkbox cb = new Checkbox();
            //        cb.ID = "EVENTRESOLVED_" + item.Key;
            //        cb.BoxLabel = item.Value;
            //        EVENTRESOLVED.Items.Add(cb);
            //    }
        }

        private void Clear(Control c)
        {
            foreach (Control cc in c.Controls)
            {
                if (cc is TextField)
                {
                    (cc as TextField).Text = "";
                }
                else if (cc is DateField)
                {
                    (cc as DateField).Value = "";
                }
                else if (cc is NumberField)
                {
                    (cc as NumberField).Text = "";
                }
                else if (cc is ComboBox)
                {
                    (cc as ComboBox).Value = null;
                }
                else if (cc is CheckboxGroup)
                {
                    foreach (Checkbox cb in (cc as CheckboxGroup).Items)
                    {
                        cb.Checked = false;
                    }
                }
                else if (cc is RadioGroup)
                {
                    foreach (Radio r in (cc as RadioGroup).Items)
                    {
                        r.Checked = false;
                    }
                }
                else
                {
                    Clear(cc);
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
                else if (cc is ComboBox)
                {
                    if ((cc as ComboBox).Attributes["noedit"] != "TRUE")
                    {
                        (cc as ComboBox).Enabled = !b;
                    }
                }
                else if (cc is CheckboxGroup)
                {
                    foreach (Checkbox cb in (cc as CheckboxGroup).Items)
                    {
                        if (cb.Attributes["noedit"] != "TRUE")
                        {
                            cb.Enabled = !b;
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
                else
                {
                    SetEnable(cc, b);
                }
            }
        }

        private void InitInput()
        {
            EID.Text = _context.User.FullName;
            REQUESTDATE.Text = DateTime.Now.ToString("yyyy-MM-dd");
            INITIALJOB.Text = "代理商";
            NOTIFYDATE.Text = DateTime.Now.ToString("yyyy-MM-dd");

            CONTACTMETHOD_1.Checked = true;
            COMPLAINTSOURCE_3.Checked = true;

            //波科确认产品换货或退款选择项不显示
            //this.Panel71.Visible = false;
            this.Panel71.Hide();

            //绑定批次下拉框
            this.Bind_LotByDealer(_context.User.CorpId.Value);

            if (_context.User.CorpType.ToUpper() == DealerType.LP.ToString() || _context.User.CorpType.ToUpper() == DealerType.LS.ToString())
            {
                ISPLATFORM_1.Checked = true;
                BSCSOLDTONAME.Text = _context.User.CorpName;

                DealerMaster lp = _dealers.GetDealerMaster(_context.User.CorpId.Value);
                BSCSOLDTOCITY.Text = lp.City;
                BSCSOLDTOACCOUNT.Text = lp.SapCode;
            }
            else if (_context.User.CorpType.ToUpper() == DealerType.T1.ToString())
            {
                ISPLATFORM_2.Checked = true;
                BSCSOLDTONAME.Text = _context.User.CorpName;

                DealerMaster t1 = _dealers.GetDealerMaster(_context.User.CorpId.Value);
                BSCSOLDTOCITY.Text = t1.City;
                BSCSOLDTOACCOUNT.Text = t1.SapCode;
            }
            else if (_context.User.CorpType.ToUpper() == DealerType.T2.ToString())
            {
                ISPLATFORM_2.Checked = true;
                SUBSOLDTONAME.Text = _context.User.CorpName;

                DealerMaster t = new DealerMaster();
                t.Id = _context.User.CorpId.Value;
                DealerMaster t2 = _dealers.QueryForDealerMaster(t)[0];
                SUBSOLDTOCITY.Text = t2.City;

                if (t2.ParentDmaId != null)
                {
                    DealerMaster t1 = _dealers.GetDealerMaster(t2.ParentDmaId.Value);
                    BSCSOLDTONAME.Text = t1.ChineseName;
                    BSCSOLDTOCITY.Text = t1.City;
                    BSCSOLDTOACCOUNT.Text = t1.SapCode;
                }
            }            
        }

        private void LoadBSCInfo()
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", this.InstanceId);
            param.Add("ComplainType", "BSC");
            DataRow r = _business.DealerComplainInfo(param).Rows[0];

            EID.Text = r["IDENTITY_NAME"].ToString();
            APPLYNO.Text = r["DC_ComplainNbr"].ToString();
            BSCSalesName.Text = r["BSCSALESNAME"].ToString();
            BSCSalesPhone.Text = r["BSCSALESPHONE"].ToString();
            REQUESTDATE.Text = Convert.ToDateTime(r["REQUESTDATE"]).ToString("yyyy-MM-dd");
            INITIALNAME.Text = r["INITIALNAME"].ToString();
            INITIALPHONE.Text = r["INITIALPHONE"].ToString();
            INITIALJOB.Text = r["INITIALJOB"].ToString();
            INITIALEMAIL.Text = r["INITIALEMAIL"].ToString();
            PHYSICIAN.Text = r["PHYSICIAN"].ToString();
            PHYSICIANPHONE.Text = r["PHYSICIANPHONE"].ToString();
            //FIRSTBSCNAME.Text = r["FIRSTBSCNAME"].ToString();
            //if (r["BSCAWAREDATE"] != null && !String.IsNullOrEmpty(r["BSCAWAREDATE"].ToString()))
            //{
            //    BSCAWAREDATE.SelectedDate = Convert.ToDateTime(r["BSCAWAREDATE"]);
            //}
            NOTIFYDATE.Text = Convert.ToDateTime(r["NOTIFYDATE"]).ToString("yyyy-MM-dd");
            SetCheckboxGroupValue(CONTACTMETHOD, r["CONTACTMETHOD"].ToString());
            SetCheckboxGroupValue(COMPLAINTSOURCE, r["COMPLAINTSOURCE"].ToString());

            //FEEDBACKREQUESTED.Text = r["FEEDBACKREQUESTED"].ToString();
            SetRadioGroupValue(FEEDBACKREQUESTED, r["FEEDBACKREQUESTED"].ToString());
            FEEDBACKSENDTO.Text = r["FEEDBACKSENDTO"].ToString();
            COMPLAINTID.Text = r["COMPLAINTID"].ToString();
            REFERBOX.Text = r["REFERBOX"].ToString();
            DN.Text = r["DN"].ToString();
            SetRadioGroupValue(PRODUCTTYPE, r["PRODUCTTYPE"].ToString());
            RETURNTYPE.SetValue(r["RETURNTYPE"].ToString());
            CFMRETURNTYPE.SetValue(r["CONFIRMRETURNTYPE"].ToString());
            SetRadioGroupValue(ISPLATFORM, r["ISPLATFORM"].ToString());
            BSCSOLDTOACCOUNT.Text = r["BSCSOLDTOACCOUNT"].ToString();
            BSCSOLDTONAME.Text = r["BSCSOLDTONAME"].ToString();
            BSCSOLDTOCITY.Text = r["BSCSOLDTOCITY"].ToString();
            SUBSOLDTONAME.Text = r["SUBSOLDTONAME"].ToString();
            SUBSOLDTOCITY.Text = r["SUBSOLDTOCITY"].ToString();
            //DISTRIBUTORCUSTOMER.Text = r["DISTRIBUTORCUSTOMER"].ToString();
            cbHospital.SelectedItem.Value = r["DISTRIBUTORCUSTOMER"].ToString();
            DISTRIBUTORCITY.Text = r["DISTRIBUTORCITY"].ToString();
            cbWarehouse.SelectedItem.Value=r["WHM_ID"].ToString();
            cbUPN.SelectedItem.Value = r["UPN"].ToString();
            if (IsDealer)
            {
                cbLOT.SelectedItem.Value = r["LOT"].ToString();
            }
            else {
                cbLOT.SelectedItem.Value = r["LOT"].ToString().Split('@')[0];
            }
       
            txtQrCode.Text = r["LOT"].ToString().Substring(r["LOT"].ToString().LastIndexOf("@")+1);
            //cbUPN.SetValue(r["UPN"].ToString());
            //TBUPN.SetValue(r["UPN"].ToString());
            DESCRIPTION.Text = r["DESCRIPTION"].ToString();
            //cbLOT.SelectedItem.Value = r["LOT"].ToString();
            //TBLOT.Text = r["LOT"].ToString();
            BU.Text = r["BU"].ToString();
            SetRadioGroupValue(SINGLEUSE, r["SINGLEUSE"].ToString());
            SetRadioGroupValue(RESTERILIZED, r["RESTERILIZED"].ToString());
            PREPROCESSOR.Text = r["PREPROCESSOR"].ToString();
            SetRadioGroupValue(USEDEXPIRY, r["USEDEXPIRY"].ToString());
            SetRadioGroupValue(UPNEXPECTED, r["UPNEXPECTED"].ToString());
            UPNQUANTITY.Text = r["UPNQUANTITY"].ToString();
            SetCheckboxGroupValue(NORETURN, r["NORETURN"].ToString());
            NORETURNREASON.Text = r["NORETURNREASON"].ToString();
            if (r["INITIALPDATE"] != null && !String.IsNullOrEmpty(r["INITIALPDATE"].ToString()))
            {
                INITIALPDATE.SelectedDate = Convert.ToDateTime(r["INITIALPDATE"]);
                //TBINITIALPDATE.Text = r["INITIALPDATE"].ToString();
            }
            PNAME.Text = r["PNAME"].ToString();
            INDICATION.Text = r["INDICATION"].ToString();
            if (r["IMPLANTEDDATE"] != null && !String.IsNullOrEmpty(r["IMPLANTEDDATE"].ToString()))
            {
                IMPLANTEDDATE.SelectedDate = Convert.ToDateTime(r["IMPLANTEDDATE"]);
            }
            if (r["EXPLANTEDDATE"] != null && !String.IsNullOrEmpty(r["EXPLANTEDDATE"].ToString()))
            {
                EXPLANTEDDATE.SelectedDate = Convert.ToDateTime(r["EXPLANTEDDATE"]);
            }
            SetCheckboxGroupValue(POUTCOME, r["POUTCOME"].ToString());
            SetRadioGroupValue(IVUS, r["IVUS"].ToString());
            SetRadioGroupValue(GENERATOR, r["GENERATOR"].ToString());
            GENERATORTYPE.Text = r["GENERATORTYPE"].ToString();
            GENERATORSET.Text = r["GENERATORSET"].ToString();
            SetRadioGroupValue(PCONDITION, r["PCONDITION"].ToString());
            PCONDITIONOTHER.Text = r["PCONDITIONOTHER"].ToString();
            if (r["EDATE"] != null && !String.IsNullOrEmpty(r["EDATE"].ToString()))
            {
                EDATE.SelectedDate = Convert.ToDateTime(r["EDATE"]);
                //TBEDATE.Text = r["EDATE"].ToString();
            }
            SetCheckboxGroupValue(WHEREOCCUR, r["WHEREOCCUR"].ToString());
            SetCheckboxGroupValue(WHENNOTICED, r["WHENNOTICED"].ToString());
            EDESCRIPTION.Text = r["EDESCRIPTION"].ToString();
            SetRadioGroupValue(WITHLABELEDUSE, r["WITHLABELEDUSE"].ToString());
            NOLABELEDUSE.Text = r["NOLABELEDUSE"].ToString();
            SetRadioGroupValue(EVENTRESOLVED, r["EVENTRESOLVED"].ToString());
            TBNUM.Text = r["RETURNNUM"].ToString();
            ConvertFactor.Text = r["CONVERTFACTOR"].ToString();
            UPNExpDate.Text = r["UPNEXPDATE"].ToString();
            if (r["SALESDATE"] != null && !String.IsNullOrEmpty(r["SALESDATE"].ToString()))
            {
                SalesDate.SelectedDate = Convert.ToDateTime(r["SALESDATE"]);
                //TBEDATE.Text = r["EDATE"].ToString();
            }
            txtRegistration.Text = r["REGISTRATION"].ToString();

        }

        private void CopyBSCInfo()
        {
            Hashtable param = new Hashtable();
            param.Add("DC_ID", this.InstanceId);
            param.Add("ComplainType", "BSC");
            DataRow r = _business.DealerComplainInfo(param).Rows[0];

            //EID.Text = r["IDENTITY_NAME"].ToString();
            //APPLYNO.Text = r["DC_ComplainNbr"].ToString();
            BSCSalesName.Text = r["BSCSALESNAME"].ToString();
            BSCSalesPhone.Text = r["BSCSALESPHONE"].ToString();
            //REQUESTDATE.Text = Convert.ToDateTime(r["REQUESTDATE"]).ToString("yyyy-MM-dd");
            INITIALNAME.Text = r["INITIALNAME"].ToString();
            INITIALPHONE.Text = r["INITIALPHONE"].ToString();
            //INITIALJOB.Text = r["INITIALJOB"].ToString();
            INITIALEMAIL.Text = r["INITIALEMAIL"].ToString();
            PHYSICIAN.Text = r["PHYSICIAN"].ToString();
            PHYSICIANPHONE.Text = r["PHYSICIANPHONE"].ToString();           
            //NOTIFYDATE.Text = Convert.ToDateTime(r["NOTIFYDATE"]).ToString("yyyy-MM-dd");
            //SetCheckboxGroupValue(CONTACTMETHOD, r["CONTACTMETHOD"].ToString());
            //SetCheckboxGroupValue(COMPLAINTSOURCE, r["COMPLAINTSOURCE"].ToString());           
            SetRadioGroupValue(FEEDBACKREQUESTED, r["FEEDBACKREQUESTED"].ToString());
            FEEDBACKSENDTO.Text = r["FEEDBACKSENDTO"].ToString();
            //COMPLAINTID.Text = r["COMPLAINTID"].ToString();
            REFERBOX.Text = r["REFERBOX"].ToString();
            //DN.Text = r["DN"].ToString();
            SetRadioGroupValue(PRODUCTTYPE, r["PRODUCTTYPE"].ToString());
            RETURNTYPE.SetValue(r["RETURNTYPE"].ToString());
            //SetRadioGroupValue(ISPLATFORM, r["ISPLATFORM"].ToString());
            //BSCSOLDTOACCOUNT.Text = r["BSCSOLDTOACCOUNT"].ToString();
            //BSCSOLDTONAME.Text = r["BSCSOLDTONAME"].ToString();
            //BSCSOLDTOCITY.Text = r["BSCSOLDTOCITY"].ToString();
            //SUBSOLDTONAME.Text = r["SUBSOLDTONAME"].ToString();
            //SUBSOLDTOCITY.Text = r["SUBSOLDTOCITY"].ToString();
            //DISTRIBUTORCUSTOMER.Text = r["DISTRIBUTORCUSTOMER"].ToString();
            cbHospital.SelectedItem.Value = r["DISTRIBUTORCUSTOMER"].ToString();
            DISTRIBUTORCITY.Text = r["DISTRIBUTORCITY"].ToString();
            cbWarehouse.SelectedItem.Value = r["WHM_ID"].ToString();
            cbUPN.SelectedItem.Value = r["UPN"].ToString();
            cbLOT.SelectedItem.Value = r["LOT"].ToString();
           
            DESCRIPTION.Text = r["DESCRIPTION"].ToString();
          
            BU.Text = r["BU"].ToString();
            SetRadioGroupValue(SINGLEUSE, r["SINGLEUSE"].ToString());
            SetRadioGroupValue(RESTERILIZED, r["RESTERILIZED"].ToString());
            PREPROCESSOR.Text = r["PREPROCESSOR"].ToString();
            SetRadioGroupValue(USEDEXPIRY, r["USEDEXPIRY"].ToString());
            SetRadioGroupValue(UPNEXPECTED, r["UPNEXPECTED"].ToString());
            UPNQUANTITY.Text = r["UPNQUANTITY"].ToString();
            SetCheckboxGroupValue(NORETURN, r["NORETURN"].ToString());
            NORETURNREASON.Text = r["NORETURNREASON"].ToString();
            if (r["INITIALPDATE"] != null && !String.IsNullOrEmpty(r["INITIALPDATE"].ToString()))
            {
                INITIALPDATE.SelectedDate = Convert.ToDateTime(r["INITIALPDATE"]);
            }
            PNAME.Text = r["PNAME"].ToString();
            INDICATION.Text = r["INDICATION"].ToString();
            if (r["IMPLANTEDDATE"] != null && !String.IsNullOrEmpty(r["IMPLANTEDDATE"].ToString()))
            {
                IMPLANTEDDATE.SelectedDate = Convert.ToDateTime(r["IMPLANTEDDATE"]);
            }
            if (r["EXPLANTEDDATE"] != null && !String.IsNullOrEmpty(r["EXPLANTEDDATE"].ToString()))
            {
                EXPLANTEDDATE.SelectedDate = Convert.ToDateTime(r["EXPLANTEDDATE"]);
            }
            SetCheckboxGroupValue(POUTCOME, r["POUTCOME"].ToString());
            SetRadioGroupValue(IVUS, r["IVUS"].ToString());
            SetRadioGroupValue(GENERATOR, r["GENERATOR"].ToString());
            GENERATORTYPE.Text = r["GENERATORTYPE"].ToString();
            GENERATORSET.Text = r["GENERATORSET"].ToString();
            SetRadioGroupValue(PCONDITION, r["PCONDITION"].ToString());
            PCONDITIONOTHER.Text = r["PCONDITIONOTHER"].ToString();
            if (r["EDATE"] != null && !String.IsNullOrEmpty(r["EDATE"].ToString()))
            {
                EDATE.SelectedDate = Convert.ToDateTime(r["EDATE"]);
            }
            SetCheckboxGroupValue(WHEREOCCUR, r["WHEREOCCUR"].ToString());
            SetCheckboxGroupValue(WHENNOTICED, r["WHENNOTICED"].ToString());
            EDESCRIPTION.Text = r["EDESCRIPTION"].ToString();
            SetRadioGroupValue(WITHLABELEDUSE, r["WITHLABELEDUSE"].ToString());
            NOLABELEDUSE.Text = r["NOLABELEDUSE"].ToString();
            SetRadioGroupValue(EVENTRESOLVED, r["EVENTRESOLVED"].ToString());
            TBNUM.Text = r["RETURNNUM"].ToString();
            ConvertFactor.Text = r["CONVERTFACTOR"].ToString();
            UPNExpDate.Text = r["UPNEXPDATE"].ToString();
            if (r["SALESDATE"] != null && !String.IsNullOrEmpty(r["SALESDATE"].ToString()))
            {
                SalesDate.SelectedDate = Convert.ToDateTime(r["SALESDATE"]);
                //TBEDATE.Text = r["EDATE"].ToString();
            }
            txtRegistration.Text = r["REGISTRATION"].ToString();

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

        private void SetRadioGroupValue(RadioGroup rg, String value)
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

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _businessPurchaseOrder.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        protected void HospitalStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {

            if (IsDealer)
            {
                this.HospitalStore.DataSource = _hospital.SelectHospitalByAuthorization(_context.User.CorpId.Value);
            }
            else
            {
                this.HospitalStore.DataSource = _hospital.GetAllHospitals();
            }
            this.HospitalStore.DataBind();
        }

        protected internal virtual void Store_AllLotByWHMId(object sender, StoreRefreshDataEventArgs e)
        {
            //获取LotID

            Hashtable param = new Hashtable();            

            Guid WHMId = Guid.Empty;
            if (e.Parameters["WHMId"] != null && !string.IsNullOrEmpty(e.Parameters["WHMId"].ToString()))
            {
                WHMId = new Guid(e.Parameters["WHMId"].ToString());
                param.Add("WHMId", WHMId);

                DataSet ds = null;
                ds = _businessQueryInv.SelectInventoryLotForQABSCComplainsDataSet(param);

                if (sender is Store)
                {
                    Store store1 = (sender as Store);

                    store1.DataSource = ds;
                    store1.DataBind();
                }
            }

            
        }

        protected void Bind_LotByDealer(Guid dealerId)
        {
            Hashtable param = new Hashtable();
            param.Add("DealerID", dealerId);
            param.Add("OwnerIdentityType", "Dealer");
            DataSet ds = null;
            ds = _businessQueryInv.SelectInventoryLotForQABSCComplainsDataSet(param);

            LotStore.DataSource = ds;
            LotStore.DataBind();
        }

        protected internal virtual void Store_AllUPNByLot(object sender, StoreRefreshDataEventArgs e)
        {
            //获取UPN

            Hashtable param = new Hashtable();
            Guid WHMId = Guid.Empty;
            String LotNumber = "";
            if (e.Parameters["LotId"] != null && !string.IsNullOrEmpty(e.Parameters["LotId"].ToString()))
            {
                LotNumber = e.Parameters["LotId"].ToString();
                if (IsDealer)
                {
                    param.Add("DealerID", _context.User.CorpId.Value);
                    param.Add("OwnerIdentityType", "Dealer");
                }
                else
                {
                    param.Add("OwnerIdentityType", "User");
                }
                param.Add("LotNumber", LotNumber);

                DataSet ds = null;
                ds = _businessQueryInv.SelectInventoryUPNForQABSCComplainsDataSet(param);

                if (sender is Store)
                {
                    Store store1 = (sender as Store);

                    store1.DataSource = ds;
                    store1.DataBind();
                }
            }


        }

        protected internal virtual void Store_AllWHMByLotUPN(object sender, StoreRefreshDataEventArgs e)
        {
            //获取UPN

            Hashtable param = new Hashtable();
            String UPNId ="";
            String LotNumber = "";
            if (e.Parameters["LotId"] != null && !string.IsNullOrEmpty(e.Parameters["LotId"].ToString()) && e.Parameters["UPNId"] != null && !string.IsNullOrEmpty(e.Parameters["UPNId"].ToString()))
            {
                UPNId =e.Parameters["UPNId"].ToString();
                LotNumber = e.Parameters["LotId"].ToString();

                param.Add("UPN", UPNId);
                if (IsDealer)
                {
                    param.Add("DealerID", _context.User.CorpId.Value);
                    param.Add("OwnerIdentityType", "Dealer");
                }
                else
                {
                    param.Add("OwnerIdentityType", "User");
                }
                param.Add("LotNumber", LotNumber);

                DataSet ds = null;
                ds = _businessQueryInv.SelectInventoryWHMForQABSCComplainsDataSet(param);

                if (sender is Store)
                {
                    Store store1 = (sender as Store);

                    store1.DataSource = ds;
                    store1.DataBind();
                }
            }


        }

        #endregion

     
    }
}