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
using System.IO;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PromotionPolicyDialog")]
    public partial class PromotionPolicyDialog : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        #endregion


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

        public string InstanceId
        {
            get
            {
                return this.hidInstanceId.Text;
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }

        public string PageType
        {
            get
            {
                return this.hidPageType.Text;
            }
            set
            {
                this.hidPageType.Text = value.ToString();
            }
        }

        public string PolicyStyle
        {
            get
            {
                return this.hidPolicyStyle.Text;
            }
            set
            {
                this.hidPolicyStyle.Text = value.ToString();
            }
        }

        public string PolicyStyleSub
        {
            get
            {
                return this.hidPolicyStyleSub.Text;
            }
            set
            {
                this.hidPolicyStyleSub.Text = value.ToString();
            }
        }

        //public PurchaseOrderStatus PageStatus
        //{
        //    get
        //    {
        //        return (PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), this.hidOrderStatus.Text, true);
        //    }
        //    set
        //    {
        //        this.hidOrderStatus.Text = value.ToString();
        //    }
        //}

        //public DateTime LatestAuditDate
        //{
        //    get
        //    {
        //        return string.IsNullOrEmpty(this.hidLatestAuditDate.Text) ? DateTime.MaxValue : DateTime.Parse(this.hidLatestAuditDate.Text);
        //    }
        //}
        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void TypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> proType = DictionaryHelper.GetDictionary(SR.PRO_Type);
            TypeStore.DataSource = proType;
            TypeStore.DataBind();
        }
        protected void PeriodStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> proPeriod = DictionaryHelper.GetDictionary(SR.PRO_Period);
            PeriodStore.DataSource = proPeriod;
            PeriodStore.DataBind();
        }

        protected void SubBUStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet dsSubBu = _business.GetSubBU(this.hidProductLine.Value.ToString());
            SubBUStore.DataSource = dsSubBu;
            SubBUStore.DataBind();
        }


        protected void ConvertStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> proConvert = DictionaryHelper.GetDictionary(SR.PRO_IsGiftConvter);
            ConvertStore.DataSource = proConvert;
            ConvertStore.DataBind();
        }
        protected void ProTOStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> ProTO = DictionaryHelper.GetDictionary(SR.PRO_TO);
            ProTOStore.DataSource = ProTO;
            ProTOStore.DataBind();
        }
        protected void ProToTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> ProTOType = DictionaryHelper.GetDictionary(SR.PRO_ToType);
            ProToTypeStore.DataSource = ProTOType;
            ProToTypeStore.DataBind();
        }
        protected void TopTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> ProTopType = DictionaryHelper.GetDictionary(SR.PRO_TopType);
            TopTypeStore.DataSource = ProTopType;
            TopTypeStore.DataBind();
        }
        protected void MinusLastGiftStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> ProYesOrNo = DictionaryHelper.GetDictionary(SR.PRO_YesOrNo);
            MinusLastGiftStore.DataSource = ProYesOrNo;
            MinusLastGiftStore.DataBind();
        }
        protected void IncrementStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> ProYesOrNo = DictionaryHelper.GetDictionary(SR.PRO_YesOrNo);
            IncrementStore.DataSource = ProYesOrNo;
            IncrementStore.DataBind();
        }
        protected void AddLastLeftStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> ProYesOrNo = DictionaryHelper.GetDictionary(SR.PRO_YesOrNo);
            AddLastLeftStore.DataSource = ProYesOrNo;
            AddLastLeftStore.DataBind();
        }
        protected void CarryTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> ProCarryType = DictionaryHelper.GetDictionary(SR.PRO_CarryType);
            CarryTypeStore.DataSource = ProCarryType;
            CarryTypeStore.DataBind();
        }
        protected void AcquisitionStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> acquisition = DictionaryHelper.GetDictionary(SR.PRO_YesOrNo);
            BusinessAcquisitionStore.DataSource = acquisition;
            BusinessAcquisitionStore.DataBind();
        }
        //protected void RebateStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    IDictionary<string, string> rebate = DictionaryHelper.GetDictionary(SR.PRO_YesOrNo);
        //    RebateStore.DataSource = rebate;
        //    RebateStore.DataBind();
        //}

        protected void PolicyClassStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> PolicyClass = DictionaryHelper.GetDictionary(SR.PRO_PolicyClass);
            PolicyClassStore.DataSource = PolicyClass;
            PolicyClassStore.DataBind();
        }
        //protected void FolicyFactorStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    int totalCount = 0;

        //    ProPolicyFactorUi factorUi = new ProPolicyFactorUi();
        //    factorUi.PolicyId = Convert.ToInt32(InstanceId);
        //    factorUi.CurrUser = _context.User.Id;
        //    DataSet PolicyFactorUiList = _business.QueryUIPolicyFactorAndGift(factorUi, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
        //    (this.FolicyFactorStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
        //    FolicyFactorStore.DataSource = PolicyFactorUiList;
        //    FolicyFactorStore.DataBind();

        //}
        protected void FactorRuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyId", InstanceId);

            DataTable query = _business.QueryFactorRuleUi(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarFactorRule.PageSize : e.Limit), out totalCount).Tables[0];
            (this.FactorRuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            FactorRuleStore.DataSource = query;
            FactorRuleStore.DataBind();
        }

        //封顶值设定
        protected void PolicyTopValueStoreStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyId", this.InstanceId);
            int totalCount = 0;
            this.PolicyTopValueStore.DataSource = _business.QueryTopValue(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            this.PolicyTopValueStore.DataBind();
            e.TotalCount = totalCount;
        }

        protected void AttachmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("PolicyId", this.InstanceId);
            obj.Add("Type", "Policy");
            int totalCount = 0;
            this.AttachmentStore.DataSource = _business.QueryPolicyAttachment(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachment.PageSize : e.Limit), out totalCount);
            this.AttachmentStore.DataBind();
            e.TotalCount = totalCount;
        }

        //加价率
        protected void PointRatioStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("CurrUser", _context.User.Id);
            obj.Add("PolicyId", this.InstanceId);
            int totalCount = 0;
            this.PointRatioStore.DataSource = _business.QueryPointRatio(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.PointRatioStore.DataBind();
            e.TotalCount = totalCount;
        }



        #endregion

        #region Ajax Method  (Dialog Detial)
        [AjaxMethod]
        public void Show(string policyId, string pagetype, string prolicytype, string prolicytypeSub)
        {
            this.IsPageNew = (policyId == String.Empty);
            this.IsModified = false;
            this.IsSaved = false;
            this.InstanceId = (policyId == String.Empty) ? "" : policyId;
            this.PageType = pagetype;
            this.PolicyStyle = prolicytype;
            this.PolicyStyleSub = prolicytypeSub;

            this.InitDetailWindow();
            this.PolicyDetailWindow.Show();

            //绑定Store
            //this.Bind_OrderTypeForLP(this.OrderTypeStore, SR.Consts_Order_Type);
        }

        [AjaxMethod]
        public string SaveDraft()
        {
            string massage = "";
            ProPolicy header = this.GetFormValue();
            header.Status = "草稿";
            bool result = Save(header, "SaveDraft", out massage);
            if (result)
            {
                IsSaved = true;
            }
            return massage;
        }

        [AjaxMethod]
        public string Submit()
        {
            string massage = "";
            ProPolicy header = this.GetFormValue();
            header.Status = "有效";
            bool result = Save(header, "Submit", out massage);
            if (result)
            {
                IsSaved = true;
            }
            return massage;
        }

        [AjaxMethod]
        public void DeleteDraft()
        {
            int i = _business.DeletePolicy(InstanceId);
        }

        [AjaxMethod]
        public void Close()
        {
            bool result = true;
            if (result)
            {
                Ext.MessageBox.Alert("Message", "政策已撤销").Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", "政策无法撤销<BR/>可能政策状态已经改变，请刷新！").Show();
            }
        }

        [AjaxMethod]
        public void Copy()
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            bool result = _business.PolicyCopy(this.InstanceId, _context.User.Id);

            if (result)
            {
                IsSaved = true;
            }
        }


        //[AjaxMethod]
        //public string DeletePolicyFactor(string policyFactorId, string isGift)
        //{
        //    string retValue = "";
        //    Hashtable obj = new Hashtable();
        //    obj.Add("PolicyFactorId", policyFactorId);
        //    obj.Add("PolicyId", InstanceId);
        //    obj.Add("CurrUser", _context.User.Id);
        //    //判断是否被其他因素关联
        //    if (_business.CheckFactorHasRelation(policyFactorId, _context.User.Id))
        //    {
        //        //该因素是否被规则引用+++++（还没有加）
        //        Hashtable obj2 = new Hashtable();
        //        obj2.Add("JudgePolicyFactorId", policyFactorId);
        //        obj2.Add("CurrUser", _context.User.Id);
        //        if (_business.CheckPolicyRuleUiHasFactor(obj2))
        //        {
        //            bool result = _business.DeleteProPolicyFactorUi(obj, isGift);
        //        }
        //        else
        //        {
        //            retValue = "该因素已被促销规则使用，不能删除";  
        //        }
        //    }
        //    else 
        //    {
        //        retValue = "已被其他因素设置为关系因素，不能删除";
        //    }
        //    return retValue;
        //}

        [AjaxMethod]
        public void DeletePolicyRule(string ruleId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("RuleId", ruleId);
            obj.Add("PolicyId", InstanceId);
            obj.Add("CurrUser", _context.User.Id);
            _business.DeletePolicyRuleUi(obj);
        }

        [AjaxMethod]
        public void ChangePolicyType(string policyType)
        {
            if (this.IsPageNew)
            {
                Hashtable obj = new Hashtable();
                obj.Add("PolicyFactorId", 2);
                obj.Add("PolicyId", InstanceId);
                obj.Add("CurrUser", _context.User.Id);

                //该因素是否被规则引用
                Hashtable obj2 = new Hashtable();
                obj2.Add("JudgePolicyFactorId", 2);
                obj2.Add("CurrUser", _context.User.Id);
                if (_business.CheckPolicyRuleUiHasFactor(obj2))
                {
                    bool result = _business.DeleteProPolicyFactorUi(obj, "N", "N");
                }

                ProPolicyFactorUi PolicyFactorUi = new ProPolicyFactorUi();
                PolicyFactorUi.PolicyFactorId = 2;
                PolicyFactorUi.PolicyId = Convert.ToInt32(InstanceId);
                PolicyFactorUi.CurrUser = _context.User.Id;


                if (policyType.Equals("采购赠"))
                {
                    if (this.PolicyStyleSub == "金额百分比积分")
                    {
                        PolicyFactorUi.FactId = 13;
                        PolicyFactorUi.FactDesc = "指定产品商业采购金额";
                    }
                    else
                    {
                        PolicyFactorUi.FactId = 9;
                        PolicyFactorUi.FactDesc = "指定产品商业采购量";
                    }

                    _business.InsertProPolicyFactorUi(PolicyFactorUi, "N", "N");
                }
                else if (policyType.Equals("植入赠"))
                {
                    if (this.PolicyStyleSub == "金额百分比积分")
                    {
                        PolicyFactorUi.FactId = 12;
                        PolicyFactorUi.FactDesc = "指定产品医院植入金额";
                    }
                    else
                    {
                        PolicyFactorUi.FactId = 8;
                        PolicyFactorUi.FactDesc = "指定产品医院植入量";
                    }

                    _business.InsertProPolicyFactorUi(PolicyFactorUi, "N", "N");
                }
            }
        }
        #endregion

        #region 页面私有方法 (Dialog Detial)
        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            //将正式表同步到UI表
            ProPolicy policyHrader = null;
            _business.UpdateProlicyInit(_context.User.Id, InstanceId, PolicyStyle, PolicyStyleSub);
            policyHrader = _business.GetUIPolicyHeader(_context.User.Id);

            //页面赋值
            ClearFormValue();
            SetFormValue(policyHrader);
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow(policyHrader);
            //初始化因素
            SetPolicyFact();
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.hidProductLine.Clear(); //产品线
            this.hidSubBU.Clear();  //SubBU
            this.hidPeriod.Clear(); //结算周期
            this.hidType.Clear();   //促销类型
            this.hidConvert.Clear();    //赠品转积分
            this.hidProTO.Clear();  //选择结算对象
            this.hidMinusLastGift.Clear();  //扣除上期赠品
            this.hidIncrement.Clear();  //增量计算
            this.hidAddLastLeft.Clear();    //累计上期余量
            this.hidCarryType.Clear();  //进位方式
            this.hidProToType.Clear();  //指定类型
            this.hidTopType.Clear();    //封顶类型
            this.hidAcquisition.Clear();    //赠品计入商业采购就按
            //this.hidRebate.Clear();    //赠品计入返利计算

            this.txtWdPolicyNo.Clear();
            this.cbWdProductLine.SelectedItem.Value = "";
            this.txtWdPolicyName.Clear();
            this.dfWdBeginDate.Clear();
            this.cbWdPeriod.SelectedItem.Value = "";
            this.cbWdProTO.SelectedItem.Value = "";
            this.cbWdTopType.SelectedItem.Value = "";
            this.cbWdMinusLastGift.SelectedItem.Value = "";
            this.cbWdIncrement.SelectedItem.Value = "";
            this.cbWdPolicyType.SelectedItem.Value = "";
            this.cbWdSubBU.SelectedItem.Value = "";
            this.txtWdPolicyGroupName.Clear();
            this.dfWdEndDate.Clear();
            this.cbWdIfConvert.SelectedItem.Value = "";
            this.cbWdProToType.SelectedItem.Value = "";
            this.txtWdTopValue.Clear();
            this.cbWdAddLastLeft.SelectedItem.Value = "";
            this.cbWdCarryType.SelectedItem.Value = "";
            this.cbWdAcquisition.SelectedItem.Value = "";
            //this.cbWdRebate.SelectedItem.Value = "";

            //积分
            this.cbWdPointValidDateDurationForLP.SelectedItem.Value = "";
            this.cbWdPointValidDateTypeForLP.SelectedItem.Value = "";
            this.dfWdPointValidDateAbsoluteForLP.Clear();
            this.CheckboxUseProductForLP.Checked = false;
            this.cbYTDOption.SelectedItem.Value = "";
            this.numbMJRatio.Clear();

            this.hidPromotionState.Clear();
        }

        private void SetFormValue(ProPolicy policyHrader)
        {
            if (policyHrader.PolicyStyle != null && policyHrader.PolicySubStyle != null)
            {
                this.PolicyDetailWindow.Title = "促销政策维护(" + policyHrader.PolicyStyle + "-" + policyHrader.PolicySubStyle + ")";
            }
            else
            {
                this.PolicyDetailWindow.Title = "促销政策维护";
            }

            if (IsPageNew)
            {
                this.InstanceId = policyHrader.PolicyId.ToString();
                this.hidPromotionState.Value = SR.PRO_Status_Draft;
                this.cbWdPeriod.SelectedItem.Value = "季度";
                this.cbWdProTO.SelectedItem.Value = "ByDealer";
                this.cbWdMinusLastGift.SelectedItem.Value = "Y";
                this.cbWdIncrement.SelectedItem.Value = "N";
                this.cbWdAcquisition.SelectedItem.Value = "N";

                if (this.PolicyStyle == "即时买赠")
                {
                    this.cbWdPolicyType.SelectedItem.Value = "采购赠";
                }
                else
                {
                    this.cbWdPolicyType.SelectedItem.Value = "植入赠";
                }
                this.cbWdIfConvert.SelectedItem.Value = "N";
                this.cbWdAddLastLeft.SelectedItem.Value = "N";
                this.cbWdCarryType.SelectedItem.Value = "KeepValue";
                //this.cbWdRebate.SelectedItem.Value = "N";
                if (this.PolicyStyle.Equals("积分"))
                {
                    this.cbWdPointValidDateTypeForLP.SelectedItem.Value = "Always";
                    this.cbWdPointValidDateType.SelectedItem.Value = "Always";
                    this.CheckboxUseProductForLP.Checked = false;
                }
                this.cbYTDOption.SelectedItem.Value = "N";
            }
            else
            {
                this.hidPromotionState.Value = policyHrader.Status;
                this.hidProductLine.Value = policyHrader.ProductLineId; //产品线
                this.hidSubBU.Value = policyHrader.SubBu;  //SubBU
                this.hidPeriod.Value = policyHrader.Period; //结算周期
                this.cbWdPeriod.SelectedItem.Value = policyHrader.Period;

                this.hidType.Value = policyHrader.PolicyType;   //促销类型
                this.cbWdPolicyType.SelectedItem.Value = policyHrader.PolicyType;

                this.hidConvert.Value = policyHrader.ifConvert;    //赠品转积分
                this.cbWdIfConvert.SelectedItem.Value = policyHrader.ifConvert;

                this.hidProTO.Value = policyHrader.CalType;  //选择结算对象
                this.cbWdProTO.SelectedItem.Value = policyHrader.CalType;

                this.hidMinusLastGift.Value = policyHrader.ifMinusLastGift;  //扣除上期赠品
                this.cbWdMinusLastGift.SelectedItem.Value = policyHrader.ifMinusLastGift;

                this.hidIncrement.Value = policyHrader.ifIncrement;  //增量计算
                this.cbWdIncrement.SelectedItem.Value = policyHrader.ifIncrement;

                this.hidAddLastLeft.Value = policyHrader.ifAddLastLeft;    //累计上期余量
                this.cbWdAddLastLeft.SelectedItem.Value = policyHrader.ifAddLastLeft;

                this.hidCarryType.Value = policyHrader.CarryType;  //进位方式
                this.cbWdCarryType.SelectedItem.Value = policyHrader.CarryType;

                this.hidAcquisition.Value = policyHrader.ifCalPurchaseAR;  //赠送是否计入商业采购
                this.cbWdAcquisition.SelectedItem.Value = policyHrader.ifCalPurchaseAR;

                //this.hidRebate.Value = policyHrader.ifCalRebateAR;  //赠送是否计入返利计算
                //this.cbWdRebate.SelectedItem.Value = policyHrader.ifCalRebateAR;

                this.hidPolicyClass.Value = policyHrader.PolicyClass;
                if (policyHrader.CalType != null && policyHrader.CalType.Equals("ByDealer"))
                {
                    this.hidProToType.Value = policyHrader.ProDealerType;  //指定类型
                    this.cbWdProToType.SelectedItem.Value = policyHrader.ProDealerType;
                }

                this.hidTopType.Value = policyHrader.TopType;    //封顶类型

                this.txtWdPolicyNo.Value = policyHrader.PolicyNo;
                this.txtWdPolicyName.Value = policyHrader.PolicyName;

                if (policyHrader.StartDateTime != null)
                {
                    this.dfWdBeginDate.SelectedDate = policyHrader.StartDateTime.Value;
                }
                if (policyHrader.EndDate != null)
                {
                    this.dfWdEndDate.SelectedDate = policyHrader.EndDateTime.Value;
                }
                this.txtWdPolicyGroupName.Value = policyHrader.PolicyGroupName;
                if (policyHrader.TopValue != null)
                {
                    this.txtWdTopValue.Number = Convert.ToDouble(policyHrader.TopValue.Value);
                }
                //促销类型
                this.PolicyStyle = (policyHrader.PolicyStyle == null) ? "" : policyHrader.PolicyStyle;
                this.PolicyStyleSub = (policyHrader.PolicySubStyle == null) ? "" : policyHrader.PolicySubStyle;

                //积分
                if (policyHrader.PointValidDateAbsolute2 != null)
                {
                    this.dfWdPointValidDateAbsoluteForLP.SelectedDate = policyHrader.PointValidDateAbsolute2.Value;
                }
                if (policyHrader.PointValidDateAbsolute != null)
                {
                    this.dfWdPointValidDateAbsolute.SelectedDate = policyHrader.PointValidDateAbsolute.Value;
                }
                this.cbWdPointValidDateTypeForLP.SelectedItem.Value = policyHrader.PointValidDateType2;
                this.cbWdPointValidDateType.SelectedItem.Value = policyHrader.PointValidDateType;

                this.cbWdPointValidDateDurationForLP.SelectedItem.Value = (policyHrader.PointValidDateDuration2 == null ? "" : policyHrader.PointValidDateDuration2.ToString());
                this.cbWdPointValidDateDuration.SelectedItem.Value = (policyHrader.PointValidDateDuration == null ? "" : policyHrader.PointValidDateDuration.ToString());

                if (policyHrader.PointUseRange != null && policyHrader.PointUseRange.Equals("BU"))
                {
                    this.CheckboxUseProductForLP.Checked = true;
                }
                else
                {
                    this.CheckboxUseProductForLP.Checked = false;
                }
                if (policyHrader.YTDOption != null)
                {
                    this.cbYTDOption.SelectedItem.Value = policyHrader.YTDOption;
                }
                else
                {
                    this.cbYTDOption.SelectedItem.Value = "N";
                }
                if (policyHrader.MjRatio != null)
                {
                    this.numbMJRatio.Number = Convert.ToDouble(policyHrader.MjRatio.Value);
                }

            }
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            this.cbWdPolicyType.Enabled = true;
            this.cbWdProToType.Enabled = true;
            this.cbWdProTO.Enabled = true;

            this.cbWdObjectAdd.Hidden = false;
            this.btnWdTopType.Hidden = true;
            //this.txtWdTopValue.Visible = false;

            this.cbWdAddLastLeft.Hidden = false;
            this.lvWdRemarkAddLastLeft.Hidden = false;

            this.cbWdPeriod.Hidden = false;
            this.cbWdTopType.Hidden = false;
            this.txtWdTopValue.Hidden = false;
            this.txtlabTop.Hidden = false;
            this.cbWdMinusLastGift.Hidden = false;
            this.lbWdRemarkMinusLastGift.Hidden = false;
            this.cbWdIncrement.Hidden = false;
            this.lbWdRemarkIncrement.Hidden = false;
            this.cbWdAcquisition.Hidden = false;
            this.lbWdAcquisition.Hidden = false;
            this.cbWdCarryType.Hidden = false;
            this.cbYTDOption.Hidden = false;
            this.lbWdCarryType.Hidden = false;

            //积分页面控件控制
            this.FormPanelHard2.Hidden = true;
            this.cbWdPointValidDateDurationForLP.Hidden = true;
            this.dfWdPointValidDateAbsoluteForLP.Hidden = true;
            this.FormPanelHard3.Hidden = true;
            this.cbWdPointValidDateDuration.Hidden = true;
            this.dfWdPointValidDateAbsolute.Hidden = true;
            this.btnWdPointRatio.Hidden = true;//加价率维护
            this.CheckboxUseProductForLP.Hidden = true;
            this.numbMJRatio.Hidden = true;

            this.btnSaveDraft.Hidden = true;
            this.btnDeleteDraft.Hidden = true;
            this.btnSubmit.Hidden = true;
            this.btnCopy.Hidden = true;
            this.btnRevoke.Hidden = true;
            this.btnClose.Hidden = true;

            //切换到第一个面板
            this.TabPanel1.ActiveTabIndex = 0;

            //新增因素规则按钮
            //this.btnAddFolicyFactor.Hidden = false;
            //this.btnAddFactorRule.Hidden = false;

            //this.GridFolicyFactor.ColumnModel.SetHidden(4, false);
            //this.GridFactorRule.ColumnModel.SetHidden(2, false);
        }

        private void SetDetailWindow(ProPolicy policyHrader)
        {
            if (PageType == "Modify")
            {
                if (policyHrader.Status == SR.PRO_Status_Draft)  //草稿
                {
                    this.btnSaveDraft.Hidden = false;
                    this.btnDeleteDraft.Hidden = false;
                    this.btnSubmit.Hidden = false;
                    this.btnCopy.Hidden = false;
                }
                if (policyHrader.Status == SR.PRO_Status_Approving) // 审批中
                {
                    this.btnCopy.Hidden = false;
                }
                if (policyHrader.Status == SR.PRO_Status_Reject) // 审批拒绝
                {
                    this.btnCopy.Hidden = false;
                }
                if (policyHrader.Status == SR.PRO_Status_Dffective) // 有效
                {
                    this.btnCopy.Hidden = false;
                }
                if (policyHrader.Status == SR.PRO_Status_Invalid) // 无效
                {
                    this.btnCopy.Hidden = false;
                }
            }
            else {
                if (policyHrader.Status == SR.PRO_Status_Dffective) // 有效
                {
                    this.btnCopy.Hidden = false;
                }
            }

            if (policyHrader.PolicyType != null && policyHrader.PolicyType.ToString().Equals("采购赠"))
            {
                this.cbWdProTO.Enabled = false;
            }

            //积分政策
            if (this.PolicyStyle == "积分")
            {
                this.FormPanelHard2.Hidden = false;
                this.FormPanelHard3.Hidden = false;
                if (policyHrader.PointValidDateType2 != null && policyHrader.PointValidDateType2.Equals("AbsoluteDate"))
                {
                    this.dfWdPointValidDateAbsoluteForLP.Hidden = false;
                }
                if (policyHrader.PointValidDateType2 != null && policyHrader.PointValidDateType2.Equals("AccountMonth"))
                {
                    this.cbWdPointValidDateDurationForLP.Hidden = false;
                }

                if (policyHrader.PointValidDateType != null && policyHrader.PointValidDateType.Equals("AbsoluteDate"))
                {
                    this.dfWdPointValidDateAbsolute.Hidden = false;
                }
                if (policyHrader.PointValidDateType != null && policyHrader.PointValidDateType.Equals("AccountMonth"))
                {
                    this.cbWdPointValidDateDuration.Hidden = false;
                }

                this.btnWdPointRatio.Hidden = false;//加价率
                this.CheckboxUseProductForLP.Hidden = false; //平台积分使用范围
                this.cbWdAddLastLeft.Hidden = true; //累计上期余量
                this.lvWdRemarkAddLastLeft.Hidden = true;
                if (this.PolicyStyleSub == "促销赠品转积分")
                {
                    this.numbMJRatio.Hidden = false;
                }
            }
            else if (this.PolicyStyle == "即时买赠")
            {
                this.cbWdPolicyType.Enabled = false;
                this.cbWdProTO.Enabled = false;

                this.cbWdPeriod.Hidden = true;
                this.cbWdTopType.Hidden = true;
                this.txtWdTopValue.Hidden = true;
                this.txtlabTop.Hidden = true;
                this.cbWdMinusLastGift.Hidden = true;
                this.lbWdRemarkMinusLastGift.Hidden = true;
                this.cbWdIncrement.Hidden = true;
                this.lbWdRemarkIncrement.Hidden = true;
                this.cbWdAcquisition.Hidden = true;
                this.lbWdAcquisition.Hidden = true;
                this.cbWdCarryType.Hidden = true;
                this.cbWdAddLastLeft.Hidden = true; //累计上期余量
                this.lvWdRemarkAddLastLeft.Hidden = true;
                this.cbYTDOption.Hidden = true;
                this.lbWdCarryType.Hidden = true;
            }

        }

        private ProPolicy GetFormValue()
        {
            //PolicyName	Description	PolicyGroupName	Period	StartDate	EndDate	BU	SubBu	TopType	TopValue	CalType	IsPrePrice
            ProPolicy policy = _business.GetUIPolicyHeader(_context.User.Id);
            policy.ProductLineId = this.cbWdProductLine.SelectedItem.Value;
            if (!String.IsNullOrEmpty(this.cbWdSubBU.SelectedItem.Value.ToString()))
            {
                policy.SubBu = this.cbWdSubBU.SelectedItem.Value;
            }
            if (this.PolicyStyle == "即时买赠")
            {
                policy.PolicyType = "采购赠";
            }
            else
            {
                policy.PolicyType = this.cbWdPolicyType.SelectedItem.Value;   //促销类型
            }
            policy.ifConvert = this.cbWdIfConvert.SelectedItem.Value;    //赠品转积分
            if (this.cbWdPolicyType.SelectedItem.Value.Equals("植入赠"))
            {
                policy.CalType = this.cbWdProTO.SelectedItem.Value;  //选择结算对象
            }
            else
            {
                policy.CalType = "ByDealer";
            }

            policy.ProDealerType = this.cbWdProToType.SelectedItem.Value;
            if (this.txtWdPolicyNo.Text != "")
            {
                policy.PolicyNo = this.txtWdPolicyNo.Text;
            }
            policy.PolicyName = this.txtWdPolicyName.Text;
            if (!this.dfWdBeginDate.IsNull)
            {
                policy.StartDate = this.dfWdBeginDate.SelectedDate.Year.ToString() + (this.dfWdBeginDate.SelectedDate.Month < 10 ? ("0" + this.dfWdBeginDate.SelectedDate.Month.ToString()) : this.dfWdBeginDate.SelectedDate.Month.ToString());
            }
            if (!this.dfWdEndDate.IsNull)
            {
                policy.EndDate = this.dfWdEndDate.SelectedDate.Year.ToString() + (this.dfWdEndDate.SelectedDate.Month < 10 ? ("0" + this.dfWdEndDate.SelectedDate.Month.ToString()) : this.dfWdEndDate.SelectedDate.Month.ToString());
            }
            policy.PolicyGroupName = this.txtWdPolicyGroupName.Text;
            if (this.txtWdTopValue.Text != "")
            {
                policy.TopValue = Convert.ToDecimal(this.txtWdTopValue.Number);
            }
            policy.PolicyId = Convert.ToInt32(InstanceId);
            policy.ModifyBy = _context.User.Id;
            policy.ModifyDate = DateTime.Now;
            //policy.ifCalRebateAR = this.cbWdRebate.SelectedItem.Value;

            policy.TopType = this.cbWdTopType.SelectedItem.Value;
            policy.Period = this.cbWdPeriod.SelectedItem.Value;
            policy.ifMinusLastGift = this.cbWdMinusLastGift.SelectedItem.Value;  //扣除上期赠品
            policy.ifIncrement = this.cbWdIncrement.SelectedItem.Value;  //增量计算
            policy.ifAddLastLeft = this.cbWdAddLastLeft.SelectedItem.Value;    //累计上期余量
            policy.CarryType = this.cbWdCarryType.SelectedItem.Value;  //进位方式
            policy.PolicyClass = this.cbWdPolicyClass.SelectedItem.Value;
            policy.ifCalPurchaseAR = this.cbWdAcquisition.SelectedItem.Value;
            //积分
            if (!string.IsNullOrEmpty(this.cbWdPointValidDateTypeForLP.SelectedItem.Value))
            {
                policy.PointValidDateType2 = this.cbWdPointValidDateTypeForLP.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.cbWdPointValidDateDurationForLP.SelectedItem.Value))
            {
                policy.PointValidDateDuration2 = Convert.ToInt32(this.cbWdPointValidDateDurationForLP.SelectedItem.Value);
            }
            if (!this.dfWdPointValidDateAbsoluteForLP.IsNull)
            {
                policy.PointValidDateAbsolute2 = this.dfWdPointValidDateAbsoluteForLP.SelectedDate;
            }
            if (!string.IsNullOrEmpty(this.cbWdPointValidDateType.SelectedItem.Value))
            {
                policy.PointValidDateType = this.cbWdPointValidDateType.SelectedItem.Value;
            }
            if (!string.IsNullOrEmpty(this.cbWdPointValidDateDuration.SelectedItem.Value))
            {
                policy.PointValidDateDuration = Convert.ToInt32(this.cbWdPointValidDateDuration.SelectedItem.Value);
            }
            if (!this.dfWdPointValidDateAbsolute.IsNull)
            {
                policy.PointValidDateAbsolute = this.dfWdPointValidDateAbsolute.SelectedDate;
            }
            if (policy.PolicyStyle != null && policy.PolicyStyle.Equals("积分"))
            {
                policy.PointUseRange = (this.CheckboxUseProductForLP.Checked ? "BU" : "PRODUCT");
            }
            if (!string.IsNullOrEmpty(this.cbYTDOption.SelectedItem.Value))
            {
                policy.YTDOption = this.cbYTDOption.SelectedItem.Value.ToString();
            }
            else
            {
                policy.YTDOption = "N";
            }

            if (!this.numbMJRatio.Text.Equals(""))
            {
                policy.MjRatio = Convert.ToDecimal(this.numbMJRatio.Number);
            }

            return policy;
        }

        private bool Save(ProPolicy policyui, string Type, out string massage)
        {
            bool ret = true;
            string Result = "";
            massage = "";

            //保存临时表
            ret = _business.SavePolicyUi(policyui);

            if (!ret)
            {
                massage = "临时数据保存失败";
                return ret;
            }

            //保存临时表到正式表
            Hashtable obj = new Hashtable();
            obj.Add("UserId", _context.User.Id);
            obj.Add("Command", Type);
            obj.Add("Result", string.Empty);
            if (Type == "SaveDraft")
            {
                Result = _business.SubmintPolicy(obj);
                if (Result == "Failed")
                {
                    massage = "保存草稿失败";
                    ret = false;
                }
            }
            if (Type == "Submit")
            {
                //1. 校验
                Result = _business.SubmintPolicyCheck(obj);
                if (!Result.Equals("Success") && !Result.Equals("Half")) //Half 表示是没有规制的政策,不计算到最终结果
                {
                    ret = false;
                    massage = Result;
                }
                else
                {
                    //2. 保存
                    Result = _business.SubmintPolicy(obj);
                    if (Result == "Failed")
                    {
                        massage = "提交审批失败";
                        ret = false;
                        return ret;
                    }
                    else
                    {
                        //向E-workflow发起流程申请
                        _business.SendEWorkflow(policyui.PolicyId);

                    }
                }
            }
            return ret;
        }

        private void SetPolicyFact()
        {
            if (this.IsPageNew)
            {
                //添加产品因素（默认是赠品）
                ProPolicyFactorUi PolicyFactorUi = new ProPolicyFactorUi();
                PolicyFactorUi.PolicyFactorId = 1;
                PolicyFactorUi.PolicyId = Convert.ToInt32(InstanceId);
                PolicyFactorUi.FactId = 1;
                if (this.PolicyStyle == "赠品")
                {
                    PolicyFactorUi.FactDesc = "政策所包含产品";
                }
                else if (this.PolicyStyle == "积分")
                {
                    PolicyFactorUi.FactDesc = "政策所包含产品";
                }
                else
                {
                    PolicyFactorUi.FactDesc = "政策所包含产品";
                }
                PolicyFactorUi.CurrUser = _context.User.Id;

                string isGift = "N";
                string isPoint = "N";
                if (this.PolicyStyle == "赠品")
                {
                    isGift = "Y";
                    isPoint = "N";
                }
                else if (this.PolicyStyle == "即时买赠")
                {
                    isGift = "Y";
                    isPoint = "N";
                }
                else if (this.PolicyStyle == "积分" && this.PolicyStyleSub == "促销赠品转积分")
                {
                    isGift = "Y";
                    isPoint = "Y";
                }
                else
                {
                    isGift = "N";
                    isPoint = "Y";
                }

                _business.InsertProPolicyFactorUi(PolicyFactorUi, isGift, isPoint);

                //添加植入量因素（默认与指定产品关系产品）

                ProPolicyFactorUi PolicyFactorUi2 = new ProPolicyFactorUi();
                PolicyFactorUi2.PolicyFactorId = 2;
                PolicyFactorUi2.PolicyId = Convert.ToInt32(InstanceId);
                if (this.PolicyStyleSub == "金额百分比积分")
                {
                    PolicyFactorUi2.FactId = 12;
                    PolicyFactorUi2.FactDesc = "指定产品医院植入金额";
                }
                else
                {
                    if (this.PolicyStyle == "即时买赠")
                    {
                        PolicyFactorUi2.FactId = 13;
                        PolicyFactorUi2.FactDesc = "指定产品商业采购金额";
                    }
                    else
                    {
                        PolicyFactorUi2.FactId = 8;
                        PolicyFactorUi2.FactDesc = "指定产品医院植入量";
                    }
                }
                PolicyFactorUi2.CurrUser = _context.User.Id;

                _business.InsertProPolicyFactorUi(PolicyFactorUi2, "N", "N");
            }
        }



        #endregion


        #region Ajax Method  (Top Value)
        [AjaxMethod]
        public void TopValuesShow(string policyId)
        {
            ClearTopValuePage();
            SetTopValuePage();
            this.wd6PolicyTopValue.Show();
        }

        [AjaxMethod]
        public void TopValuesClaer()
        {
            _business.DeleteTopValueByUserId();
        }

        #endregion

        #region 页面私有方法 (Top Value)
        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            _business.DeleteTopValueByUserId();

            if (this.FileUploadField1.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请使用正确的模板文件，模板文件为EXCEL文件!"
                    });

                    return;
                }



                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\PROTopValueInit\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 5)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();

                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        if (_business.TopValueImport(dt, InstanceId, this.cbWdTopType.SelectedItem.Value))
                        {
                            string IsValid = string.Empty;
                            if (_business.VerifyTopValue(out IsValid, this.cbWdTopType.SelectedItem.Value))
                            {
                                if (IsValid == "Error")
                                {
                                    Ext.Msg.Alert("", "数据包含错误或警告信息，请确认后导入！").Show();
                                }
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert("错误", "Excel数据格式错误!").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "没有数据可导入!").Show();
                    }

                    #endregion

                }
            }

            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传!"
                });


            }
        }

        private void ClearTopValuePage()
        {
            this.GridWd6RuleDetail.ColumnModel.SetHidden(0, false);//Dealer
            this.GridWd6RuleDetail.ColumnModel.SetHidden(1, false);//Dealer
            this.GridWd6RuleDetail.ColumnModel.SetHidden(2, false);//Hospital
            this.GridWd6RuleDetail.ColumnModel.SetHidden(3, false);//Hospital
            this.GridWd6RuleDetail.ColumnModel.SetHidden(4, false);//Period
        }

        private void SetTopValuePage()
        {
            if (this.cbWdTopType.SelectedItem.Value.ToString().Equals("Dealer"))
            {
                this.GridWd6RuleDetail.ColumnModel.SetHidden(2, true);//Hospital
                this.GridWd6RuleDetail.ColumnModel.SetHidden(3, true);//Hospital
                this.GridWd6RuleDetail.ColumnModel.SetHidden(4, true);//Period
            }
            if (this.cbWdTopType.SelectedItem.Value.ToString().Equals("DealerPeriod"))
            {
                this.GridWd6RuleDetail.ColumnModel.SetHidden(2, true);//Hospital
                this.GridWd6RuleDetail.ColumnModel.SetHidden(3, true);//Hospital
            }
            if (this.cbWdTopType.SelectedItem.Value.ToString().Equals("Hospital"))
            {
                this.GridWd6RuleDetail.ColumnModel.SetHidden(0, true);//Dealer
                this.GridWd6RuleDetail.ColumnModel.SetHidden(1, true);//Dealer
                this.GridWd6RuleDetail.ColumnModel.SetHidden(4, true);//Period
            }
        }

        #endregion


        #region Ajax Method  (Attachment)
        [AjaxMethod]
        public void AttachmentShow()
        {
            this.wdAttachment.Show();
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                //逻辑删除
                _business.DeletePolicyAttachment(id);
                //物理删除
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\Promotion");
                File.Delete(uploadFile + "\\" + fileName);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除失败").Show();
            }
        }


        #endregion

        #region 页面私有方法 (Attachment)

        protected void UploadAttachmentClick(object sender, AjaxEventArgs e)
        {
            if (this.ufUploadAttachment.HasFile)
            {

                bool error = false;

                string fileName = ufUploadAttachment.PostedFile.FileName;
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

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\Promotion\\" + newFileName);


                //文件上传
                ufUploadAttachment.PostedFile.SaveAs(file);

                Hashtable obj = new Hashtable();
                obj.Add("PolicyId", this.InstanceId);
                obj.Add("Name", fileExtention);
                obj.Add("Url", newFileName);
                obj.Add("UploadUser", _context.User.Id);
                obj.Add("UploadDate", DateTime.Now.ToShortDateString());
                obj.Add("Type", "Policy");
                //维护附件信息
                _business.InsertPolicyAttachment(obj);

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "已成功上传文件！"
                });
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }
        #endregion

        #region Ajax Method（加价率）
        [AjaxMethod]
        public void PolicyPointRatio(string policyId)
        {
            this.wdPolicyPointRatio.Show();
        }
        #endregion

        #region 页面私有方法 (加价率)
        protected void PointRatioUploadClick(object sender, AjaxEventArgs e)
        {
            //先删除上传人之前的数据
            _business.DeletePolicyPointRatioByUserId();

            if (this.FileUploadFieldPointRatio.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadFieldPointRatio.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请使用正确的模板文件，模板文件为EXCEL文件!"
                    });

                    return;
                }



                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\PROOther\\" + newFileName);


                //文件上传
                FileUploadFieldPointRatio.PostedFile.SaveAs(file);

                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                #endregion

                #region 读取文件到中间表
                //导入到中间表
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                //根据列数量判断文件模板是否正确
                if (dt.Columns.Count < 4)
                {
                    Ext.Msg.Alert("错误", "请使用正确的模板!").Show();

                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        if (_business.PointRatioImport(dt, InstanceId))
                        {
                            string IsValid = string.Empty;
                            if (_business.VerifyRatioImport(out IsValid))
                            {
                                if (IsValid == "Error")
                                {
                                    Ext.Msg.Alert("Error", "数据包含错误或警告信息，请确认后导入！").Show();
                                }
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert("错误", "Excel数据格式错误!").Show();
                        }
                    }
                    else
                    {
                        Ext.Msg.Alert("错误", "没有数据可导入!").Show();
                    }

                    #endregion

                }
            }

            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传!"
                });


            }
        }

        #endregion


    }
}