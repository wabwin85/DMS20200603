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

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PromotionPolicyRuleCondition")]
    public partial class PromotionPolicyRuleCondition : BaseUserControl
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
                return (this.hidWd5IsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidWd5IsPageNew.Text = value.ToString();
            }
        }

        public string PolicyId
        {
            get
            {
                return this.hidWd5PolicyId.Text;
            }
            set
            {
                this.hidWd5PolicyId.Text = value.ToString();
            }
        }

        public string PolicyRuleId
        {
            get
            {
                return this.hidWd5PolicyRuleId.Text;
            }
            set
            {
                this.hidWd5PolicyRuleId.Text = value.ToString();
            }
        }

        public string PolicyRuleConditionId
        {
            get
            {
                return this.hidWd5PolicyRuleConditionId.Text;
            }
            set
            {
                this.hidWd5PolicyRuleConditionId.Text = value.ToString();
            }
        }

        /// <summary>
        /// 因素ID隐藏字段，每次修改都是从1增长
        /// </summary>
        public int UsePageId
        {
            get
            {
                return (this.hidWd5UsePageId.Text == "" ? 0 : Convert.ToInt32(this.hidWd5UsePageId.Text));
            }
            set
            {
                this.hidWd5UsePageId.Text = value.ToString();
            }
        }

        public string PageType
        {
            get
            {
                return this.hidWd5PageType.Text;
            }
            set
            {
                this.hidWd5PageType.Text = value.ToString();
            }
        }

        public string PromotionState
        {
            get
            {
                return this.hidWd5PromotionState.Text;
            }
            set
            {
                this.hidWd5PromotionState.Text = value.ToString();
            }
        }
        #endregion
       

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ConditionFacterRuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable factorUi = new Hashtable();
            factorUi.Add("PolicyId", PolicyId);
            factorUi.Add("CurrUser", _context.User.Id);
            DataSet PolicyFactorUiList = _business.GetSillPolicyFactorUi(factorUi);
            ConditionFacterRuleStore.DataSource = PolicyFactorUiList;
            ConditionFacterRuleStore.DataBind();
        }

        protected void CompareFacterStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable factorUi = new Hashtable();
            factorUi.Add("PolicyId", PolicyId);
            factorUi.Add("CurrUser", _context.User.Id);
            DataSet PolicyFactorUiList = _business.GetSillPolicyFactorUi(factorUi);
            CompareFacterStore.DataSource = PolicyFactorUiList;
            CompareFacterStore.DataBind();
        }

        protected void SymbolStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> Symbol = DictionaryHelper.GetDictionary(SR.PRO_ProRoleSymbol);
            SymbolStore.DataSource = Symbol;
            SymbolStore.DataBind();
        }

        protected void ValueTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> LogicType = DictionaryHelper.GetDictionary(SR.PRO_LogicType);
            ValueTypeStore.DataSource = LogicType;
            ValueTypeStore.DataBind();
        }

        protected void ValueStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> TargetType = DictionaryHelper.GetDictionary(SR.PRO_TargetType);
            ValueStore.DataSource = TargetType;
            ValueStore.DataBind();
        }


        #region Ajax Method
        [AjaxMethod]
        public void Show(string policyId, string ruleId, string ruleConditiconId, string pagetype, string state)
        {
            this.IsPageNew = (ruleConditiconId == String.Empty);
            this.PolicyId = (policyId == String.Empty) ? "" : policyId;
            this.PolicyRuleId = (ruleId == String.Empty) ? "" : ruleId;
            this.PolicyRuleConditionId = (ruleConditiconId == String.Empty) ? (UsePageId += 1).ToString() : ruleConditiconId;

            this.PageType = pagetype;
            this.PromotionState = state;

            this.InitDetailWindow();
            this.wd5PolicyRuleCondition.Show();

        }

        [AjaxMethod]
        public void SaveRuleFactor()
        {
            ProPolicyRuleFactorUi RuleFactor = new ProPolicyRuleFactorUi();
            RuleFactor.RuleFactorId =Convert.ToInt32(PolicyRuleConditionId);
            RuleFactor.RuleId = Convert.ToInt32(PolicyRuleId);
            RuleFactor.PolicyFactorId = Convert.ToInt32(this.cbWd5PolicyConditionFacter.SelectedItem.Value.ToString());
            RuleFactor.LogicType = this.cbWd5ValueType.SelectedItem.Value.ToString();
            RuleFactor.LogicSymbol = this.cbWd5Symbol.SelectedItem.Value.ToString();
            if (!this.nfWd5Value1.Value.ToString().Equals(""))
            {
                RuleFactor.AbsoluteValue1 = Convert.ToDecimal(this.nfWd5Value1.Value.ToString());
            }
            if (!this.nfWd5Value2.Value.ToString().Equals(""))
            {
                RuleFactor.AbsoluteValue2 = Convert.ToDecimal(this.nfWd5Value2.Value.ToString());
            }
            if (!String.IsNullOrEmpty(this.cbWd5Value1.SelectedItem.Value))
            {
                RuleFactor.RelativeValue1 = this.cbWd5Value1.SelectedItem.Value;
            }
            if (!String.IsNullOrEmpty(this.cbWd5Value2.SelectedItem.Value))
            {
                RuleFactor.RelativeValue2 = this.cbWd5Value2.SelectedItem.Value;
            }
            if (!String.IsNullOrEmpty(this.cbWd5CompareFacter.SelectedItem.Value))
            {
                RuleFactor.OtherPolicyFactorId = Convert.ToInt32(this.cbWd5CompareFacter.SelectedItem.Value);
            }
            if (!this.nbWd5CompareFacterRatio.Value.ToString().Equals(""))
            {
                RuleFactor.OtherPolicyFactorIdRatio = Convert.ToDecimal(this.nbWd5CompareFacterRatio.Value.ToString());
            }
            RuleFactor.CreateBy = _context.User.Id;
            RuleFactor.CreateTime = DateTime.Now;
            RuleFactor.ModifyBy = _context.User.Id;
            RuleFactor.ModifyDate = DateTime.Now;
            RuleFactor.CurrUser = _context.User.Id;
            _business.InsertPolicyRuleConditionUi(RuleFactor, IsPageNew);
        }
        #endregion

        #region 页面私有方法
        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            DataTable dtConditicon = new DataTable();
            if (!IsPageNew)
            {
                Hashtable obj = new Hashtable();
                obj.Add("RuleFactorId", PolicyRuleConditionId);
                obj.Add("RuleId", PolicyRuleId);
                obj.Add("CurrUser", _context.User.Id);
                dtConditicon = _business.GetPolicyRuleConditionUi(obj).Tables[0];
            }
            //页面赋值
            ClearFormValue();
            SetFormValue(dtConditicon);
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow(dtConditicon);
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.cbWd5PolicyConditionFacter.SelectedItem.Value = "";
            this.cbWd5Symbol.SelectedItem.Value = "";
            this.cbWd5ValueType.SelectedItem.Value = "";
            this.cbWd5Value1.SelectedItem.Value = "";
            this.cbWd5Value2.SelectedItem.Value = "";
            this.hidWd5PolicyConditionFacter.Value = "";
            this.hidWd5CompareFacter.Value = "";
            this.hidWd5Symbol.Value = "";
            this.nfWd5Value1.Clear();
            this.nfWd5Value2.Clear();
            this.cbWd5CompareFacter.SelectedItem.Value = "";
            this.nbWd5CompareFacterRatio.Clear();
            
        }

        private void SetFormValue(DataTable dtConditicon)
        {
            if (dtConditicon != null && dtConditicon.Rows.Count > 0)
            {
                DataRow drValues = dtConditicon.Rows[0];

                //this.cbWd5PolicyConditionFacter.SelectedItem.Value = drValues["PolicyFactorId"].ToString();
                this.hidWd5PolicyConditionFacter.Value = drValues["PolicyFactorId"].ToString();
                //this.cbWd5Symbol.SelectedItem.Value = drValues["LogicSymbol"] != null ? drValues["LogicSymbol"].ToString() : "";
                this.hidWd5Symbol.Value = drValues["LogicSymbol"] != null ? drValues["LogicSymbol"].ToString() : "";
                this.cbWd5ValueType.SelectedItem.Value = drValues["LogicType"] != null ? drValues["LogicType"].ToString() : "";
                this.cbWd5Value1.SelectedItem.Value = drValues["RelativeValue1"] != null ? drValues["RelativeValue1"].ToString() : "";
                this.cbWd5Value2.SelectedItem.Value = drValues["RelativeValue2"] != null ? drValues["RelativeValue2"].ToString() : "";
                this.nfWd5Value1.Text = drValues["AbsoluteValue1"] != null ? drValues["AbsoluteValue1"].ToString() : "";
                this.nfWd5Value2.Text = drValues["AbsoluteValue2"] != null ? drValues["AbsoluteValue2"].ToString() : "";
                //this.cbWd5CompareFacter.SelectedItem.Value = drValues["OtherPolicyFactorId"] != null ? drValues["OtherPolicyFactorId"].ToString() : "";
                this.hidWd5CompareFacter.Value = drValues["OtherPolicyFactorId"] != null ? drValues["OtherPolicyFactorId"].ToString() : "";
                this.nbWd5CompareFacterRatio.Text = drValues["OtherPolicyFactorIdRatio"] != null ? drValues["OtherPolicyFactorIdRatio"].ToString() : "";
              
            }
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            this.cbWd5Value1.Hidden = true;
            this.cbWd5Value2.Hidden = true;
            this.nfWd5Value1.Hidden = true;
            this.nfWd5Value2.Hidden = true;
            this.cbWd5CompareFacter.Hidden = true;
            this.nbWd5CompareFacterRatio.Hidden = true;


            this.btnWd2AddFactor.Disabled = false;
        }

        /// <summary>
        /// 设定控件状态
        /// </summary>
        private void SetDetailWindow(DataTable dtConditicon)
        {
            if (dtConditicon != null && dtConditicon.Rows.Count > 0)
            {
                if (dtConditicon.Rows[0]["LogicType"] != null) 
                {
                    string logicType = dtConditicon.Rows[0]["LogicType"].ToString();
                    if (logicType.Equals("AbsoluteValue")) 
                    {
                        this.nfWd5Value1.Hidden = false;
                        this.nfWd5Value2.Hidden = false;
                    }
                    if (logicType.Equals("RelativeValue"))
                    {
                        this.cbWd5Value1.Hidden = false;
                        this.cbWd5Value2.Hidden = false;
                    }
                    if (logicType.Equals("OtherFactor"))
                    {
                        this.cbWd5CompareFacter.Hidden = false;
                        this.nbWd5CompareFacterRatio.Hidden = false;
                    }
                }
            }

            if (PageType == "View")
            {
                this.btnWd2AddFactor.Disabled = true;
            }
            else if (PageType == "Modify" && !PromotionState.Equals(SR.PRO_Status_Approving) && !PromotionState.Equals(SR.PRO_Status_Draft))
            {
                this.btnWd2AddFactor.Disabled = true;
            }
        }
        #endregion

        #endregion
    }
}