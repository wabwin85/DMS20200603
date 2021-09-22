using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using DMS.Website.Common;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business;
using Coolite.Ext.Web;

namespace DMS.Website.Pages.Promotion
{
    public partial class PolicyFactorInfo : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();

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


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            {
                this.hidInstanceId.Text = Request.QueryString["InstanceId"].ToString();
                this.hidPageType.Text = Request.QueryString["PageType"].ToString();
                this.hidPromotionState.Text = Request.QueryString["PromotionState"].ToString();
                PageInit();
            }
        }

        protected void FolicyFactorStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            ProPolicyFactorUi factorUi = new ProPolicyFactorUi();
            factorUi.PolicyId = Convert.ToInt32(InstanceId);
            factorUi.CurrUser = _context.User.Id;
            DataSet PolicyFactorUiList = _business.QueryUIPolicyFactorAndGift(factorUi, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            (this.FolicyFactorStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            FolicyFactorStore.DataSource = PolicyFactorUiList;
            FolicyFactorStore.DataBind();

        }

        private void PageInit() 
        {
            SetDetailWindow();
        }

        /// <summary>
        /// 设定页面控件状态
        /// </summary>
        private void SetDetailWindow() 
        {
            string PageType = this.hidPageType.Value.ToString();
            string PromotionState = this.hidPromotionState.Value.ToString();
            if (PageType=="View")
            {
                this.GridFolicyFactor.ColumnModel.SetHidden(4,true);
                this.btnAddFolicyFactor.Disabled=true;
            }
            else if (PageType == "Modify" && (PromotionState == "审批中" || PromotionState == "有效" || PromotionState == "无效" || PromotionState == "审批拒绝"))
            {
                this.GridFolicyFactor.ColumnModel.SetHidden(4, true);
                this.btnAddFolicyFactor.Disabled = true;
            }
        }

        [AjaxMethod]
        public string DeletePolicyFactor(string policyFactorId, string isGift, string isPoint)
        {
            string retValue = "";
            Hashtable obj = new Hashtable();
            obj.Add("PolicyFactorId", policyFactorId);
            obj.Add("PolicyId", InstanceId);
            obj.Add("CurrUser", _context.User.Id);
            //判断是否被其他因素关联
            if (_business.CheckFactorHasRelation(policyFactorId, _context.User.Id))
            {
                //该因素是否被规则引用+++++（还没有加）
                Hashtable obj2 = new Hashtable();
                obj2.Add("JudgePolicyFactorId", policyFactorId);
                obj2.Add("CurrUser", _context.User.Id);
                if (_business.CheckPolicyRuleUiHasFactor(obj2))
                {
                    bool result = _business.DeleteProPolicyFactorUi(obj, isGift, isPoint);
                }
                else
                {
                    retValue = "该因素已被促销规则使用，不能删除";
                }
            }
            else
            {
                retValue = "已被其他因素设置为关系因素，不能删除";
            }
            return retValue;
        }
    }
}
