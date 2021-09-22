using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Coolite.Ext.Web;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using System.Collections;
using DMS.Business;

namespace DMS.Website.Controls
{
    public partial class PromotionInitPointRuleSearch : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();

        private IGiftMaintainBLL _gift = new GiftMaintainBLL();
        #endregion

        #region 公开属性
        public bool IsPageNew
        {
            get
            {
                return (this.hidWd3IsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidWd3IsPageNew.Text = value.ToString();
            }
        }

        

        /// <summary>
        /// 政策因素控制条件
        /// </summary>
        public string FactConditionId
        {
            get
            {
                return this.hidWd3FactConditionId.Text;
            }
            set
            {
                this.hidWd3FactConditionId.Text = value.ToString();
            }
        }

        /// <summary>
        /// 政策因素控制条件
        /// </summary>
        public string FlowId
        {
            get
            {
                return this.hidFlowId.Text;
            }
            set
            {
                this.hidFlowId.Text = value.ToString();
            }
        }

        /// <summary>
        /// 因素ID隐藏字段，每次修改都是从1增长
        /// </summary>
        public int UsePageId
        {
            get
            {
                return (this.hidWd3UsePageId.Text == "" ? 0 : Convert.ToInt32(this.hidWd3UsePageId.Text));
            }
            set
            {
                this.hidWd3UsePageId.Text = value.ToString();
            }
        }


        /// <summary>
        /// 页面修改属性
        /// </summary>
        public string PageType
        {
            get
            {
                return this.hidWd3PageType.Text;
            }
            set
            {
                this.hidWd3PageType.Text = value.ToString();
            }
        }
        /// <summary>
        /// 政策状态属性
        /// </summary>
        public string PromotionState
        {
            get
            {
                return this.hidWd3PromotionState.Text;
            }
            set
            {
                this.hidWd3PromotionState.Text = value.ToString();
            }
        }
        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void FactorConditionStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            qutry = _business.GetFactorConditionByFactorId("1").Tables[0];
            
            this.FactorConditionStore.DataSource = qutry;
            this.FactorConditionStore.DataBind();
        }

        protected void FactorConditionTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable qutry = new DataTable();
            Hashtable obj = new Hashtable();
            obj.Add("FactId", "1");
            obj.Add("ConditionId", this.cbWd3FactorCondition.SelectedItem.Value.Equals("") ? "-1" : this.cbWd3FactorCondition.SelectedItem.Value);
            qutry = _business.GetFactorConditionType(obj).Tables[0];
            
            this.FactorConditionTypeStore.DataSource = qutry;
            this.FactorConditionTypeStore.DataBind();
        }

        #endregion


        protected void Wd3RuleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            hidWd3FactConditionId.Value = cbWd3FactorCondition.SelectedItem.Value;
            //维护产品类型
            Hashtable use = new Hashtable();
            use.Add("FlowId", FlowId);
            use.Add("UseRangeCondition", cbWd3FactorCondition.SelectedItem.Value);
            _gift.AddInitPointProductType(use);

            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("FactConditionId", cbWd3FactorCondition.SelectedItem.Value);
            obj.Add("ProductLineId", this.hidWd3ProductLine.Value);
            obj.Add("FlowId", FlowId);
            obj.Add("KeyValue", this.txtWd3KeyValue.Text);
            obj.Add("CurrUser", _context.User.Id);
            DataTable query = _gift.SelectUseRangeCondition(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.Wd3RuleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.Wd3RuleStore.DataSource = query;
            this.Wd3RuleStore.DataBind();
        }

        protected void Wd3RuleSeletedStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("FlowId", FlowId);
            DataTable query = _gift.QueryUseRangeSeleted(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount).Tables[0];
            (this.Wd3RuleSeletedStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.Wd3RuleSeletedStore.DataSource = query;
            this.Wd3RuleSeletedStore.DataBind();

        }


        #region Ajax Method
        [AjaxMethod]
        public void Show(string factConditionId, string productLineId, string subBU, string pagetype, string state)
        {
            this.IsPageNew = (factConditionId == String.Empty);
            this.FlowId = (factConditionId == String.Empty) ? (UsePageId += 1).ToString() : factConditionId;
            this.hidWd3ProductLine.Value = (productLineId == String.Empty) ? "" : productLineId;
            this.hidWd3SubBU.Value = (subBU == String.Empty) ? "" : subBU;
            
            this.PageType = pagetype;
            this.PromotionState = state;

            this.InitDetailWindow();
            this.wd3PolicyFactorCondition.Show();

        }

        [AjaxMethod]
        public void SavePolicyFactorCondition()
        {
            hidWd3FactConditionId.Value = cbWd3FactorCondition.SelectedItem.Value;
            //维护产品类型
            Hashtable obj = new Hashtable();
            obj.Add("FlowId", FlowId);
            obj.Add("UseRangeCondition", cbWd3FactorCondition.SelectedItem.Value);
            _gift.AddInitPointProductType(obj);
        }

        [AjaxMethod]
        public void AddRule(string valueId, string name)
        {
            Hashtable obj = new Hashtable();
            obj.Add("FlowId", FlowId);
            obj.Add("UPN", valueId);
            obj.Add("RangeType", cbWd3FactorConditionType.SelectedItem.Value);
            obj.Add("OperTag", cbWd3FactorCondition.SelectedItem.Value);

            int i = _gift.AddInitPointUPN(obj);
        }

        [AjaxMethod]
        public void DeleteRule(string valueId,string name)
        {
            Hashtable obj = new Hashtable();
            obj.Add("FlowId", FlowId);
            obj.Add("UPN", valueId );
            obj.Add("RangeType", cbWd3FactorConditionType.SelectedItem.Value);
            obj.Add("OperTag", cbWd3FactorCondition.SelectedItem.Value);
            _gift.DeleteInitPointUPN(obj);
        }

        [AjaxMethod]
        public void SavePolicyFactorRelation()
        {
            Hashtable obj = new Hashtable();
            //obj.Add("PolicyFactorId", PolicyFactorId);
            //obj.Add("ConditionPolicyFactorId", this.cbWd3PolicyFactorRelation.SelectedItem.Value);
            obj.Add("CurrUser", _context.User.Id);

            _business.InsertPolicyFactorRelation(obj);
        }

        #endregion

        #region 页面私有方法
        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            DataTable dtFactCondition = new DataTable();
            if (!IsPageNew)
            {
                Hashtable obj = new Hashtable();
                obj.Add("FactConditionId", FactConditionId);
                obj.Add("CurrUser", _context.User.Id);
                dtFactCondition = _business.QueryUIPolicyFactorCondition(obj).Tables[0];
            }
            //页面赋值
            ClearFormValue();
            SetFormValue(dtFactCondition);
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow(dtFactCondition);
            
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.cbWd3FactorCondition.SelectedItem.Value = "";
            this.cbWd3FactorConditionType.SelectedItem.Value = "";
            
        }

        private void SetFormValue(DataTable dtFactCondition)
        {
            if (dtFactCondition != null && dtFactCondition.Rows.Count > 0)
            {
                DataRow drValues = dtFactCondition.Rows[0];
                this.cbWd3FactorCondition.SelectedItem.Value = drValues["ConditionId"].ToString();
                this.cbWd3FactorConditionType.SelectedItem.Value = drValues["OperTag"] != null ? drValues["OperTag"].ToString() : "";
            }
        }

        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            //产品线
            this.cbWd3FactorCondition.Disabled = false;
            this.cbWd3FactorConditionType.Disabled = false;
            this.txtWd3KeyValue.Hidden = true;
            this.btnWd3FactorConditionQuery.Hidden = true;
            this.btnWd3AddFactorCondition.Hidden = false;
            this.PanelWd3AddFactorCondition.Hidden = true;
            this.PanelWd3AddFactorConditionSelected.Hidden = true;

            this.GridWd3FactorRuleCondition.ColumnModel.SetHidden(2, false);
            this.GridWd3FactorRuleConditionSeleted.ColumnModel.SetHidden(2, false);
        }

        /// <summary>
        /// 设定控件状态
        /// </summary>
        private void SetDetailWindow(DataTable dtFactCondition)
        {
            
                this.PanelWd3PolicyFactor.Hidden = false;
                this.PanelWd3AddFactorCondition.Hidden = false;
                this.PanelWd3AddFactorConditionSelected.Hidden = false;
                
                //this.cbWd3FactorCondition.Disabled = true;
                //this.cbWd3FactorConditionType.Disabled = true;
                this.txtWd3KeyValue.Hidden = false;
                this.btnWd3AddFactorCondition.Hidden = true;
                this.btnWd3FactorConditionQuery.Hidden = false;
                    
                
            

        }

        #endregion


    }
}