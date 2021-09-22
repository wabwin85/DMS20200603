using Coolite.Ext.Web;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ApprovalIframe")]
    public partial class ApprovalIframe : EkpBaseUserControl
    {
        EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        /// <summary>
        /// 是否显示审批备注
        /// </summary>
        [Browsable(true)]
        [Description("是否显示审批备注"), Category("canHideRemark"), DefaultValue(false)]
        public bool hideRemark
        {
            get
            {
                return this.panelEkpApproveRemark.Hidden;
            }
            set
            {
                this.panelEkpApproveRemark.Hidden = value;
            }
        }

        /// <summary>
        /// 备注值
        /// </summary>
        public string remarkValue
        {
            get
            {
                return this.ekpApproveRemark.Text;
            }
            set
            {
                this.ekpApproveRemark.Text = value;
            }
        }

        /// <summary>
        /// 审批通过状态
        /// </summary>
        public bool handler_pass_show
        {
            get
            {
                if (string.IsNullOrEmpty(this.hidden_handler_pass.Value))
                {
                    return false;
                }
                else
                {
                    bool isShow = false;
                    bool.TryParse(this.hidden_handler_pass.Value, out isShow);
                    return isShow;
                }
            }
            set
            {
                this.hidden_handler_pass.Value = value.ToString();
            }
        }

        /// <summary>
        /// 审批驳回状态
        /// </summary>
        public bool handler_refuse_show
        {
            get
            {
                if (string.IsNullOrEmpty(this.hidden_handler_refuse.Value))
                {
                    return false;
                }
                else
                {
                    bool isShow = false;
                    bool.TryParse(this.hidden_handler_refuse.Value, out isShow);
                    return isShow;
                }
            }
            set
            {
                this.hidden_handler_refuse.Value = value.ToString();
            }
        }

        /// <summary>
        /// 申请人催办状态
        /// </summary>
        public bool drafter_press_show
        {
            get
            {
                if (string.IsNullOrEmpty(this.hidden_drafter_press.Value))
                {
                    return false;
                }
                else
                {
                    bool isShow = false;
                    bool.TryParse(this.hidden_drafter_press.Value, out isShow);
                    return isShow;
                }
            }
            set
            {
                this.hidden_drafter_press.Value = value.ToString();
            }
        }

        /// <summary>
        /// 申请人催办状态
        /// </summary>
        public bool drafter_abandon_show
        {
            get
            {
                if (string.IsNullOrEmpty(this.hidden_drafter_abandon.Value))
                {
                    return false;
                }
                else
                {
                    bool isShow = false;
                    bool.TryParse(this.hidden_drafter_abandon.Value, out isShow);
                    return isShow;
                }
            }
            set
            {
                this.hidden_drafter_abandon.Value = value.ToString();
            }
        }

        public string formInstanceId
        {
            get
            {
                return this.hiddenFormInstanceId.Value;
            }
            set
            {
                this.hiddenFormInstanceId.Value = value;
            }
        }

        public bool isEkpAccess
        {
            get
            {
                if (string.IsNullOrEmpty(this.hiddenIsEkpAccess.Value))
                {
                    return false;
                }
                else
                {
                    bool isEkp = false;
                    bool.TryParse(this.hiddenIsEkpAccess.Value, out isEkp);
                    return isEkp;
                }
            }
            set
            {
                this.hiddenIsEkpAccess.Value = value.ToString();
            }
        }

        public string ekpNodeId
        {
            get
            {
                return this.hiddenEkpNodeId.Value;
            }
            set
            {
                this.hiddenEkpNodeId.Value = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.ReloadEkpHistoryPage(this.formInstanceId);
            if (Request.QueryString["isEkpAccess"] != null)
                this.isEkpAccess = true;
            else
                this.isEkpAccess = false;
        }

        protected override void OnEkpAuthenticate()
        {
            if (base.operationList != null)
            {
                this.ekpNodeId = base.operationList.Count() > 0 ? base.operationList.First<EkpOperParam>().nodeId : string.Empty;
                this.handler_pass_show = base.operationList.Where<EkpOperParam>(p => p.operationType == EkpOperType.handler_pass.ToString()).Count() > 0 ? false : true;
                this.handler_refuse_show = base.operationList.Where<EkpOperParam>(p => p.operationType == EkpOperType.handler_refuse.ToString()).Count() > 0 ? false : true;
                this.drafter_press_show = base.operationList.Where<EkpOperParam>(p => p.operationType == EkpOperType.drafter_press.ToString()).Count() > 0 ? false : true;
                this.drafter_abandon_show = base.operationList.Where<EkpOperParam>(p => p.operationType == EkpOperType.drafter_abandon.ToString()).Count() > 0 ? false : true;

                this.panelEkpApproveRemark.Hidden = base.operationList.Where<EkpOperParam>(p => p.operationType == EkpOperType.handler_pass.ToString()
                    || p.operationType == EkpOperType.handler_refuse.ToString()).Count() > 0 ? false : true;
            }
        }

        private void ReloadEkpHistoryPage(string mainId)
        {
            if (!string.IsNullOrEmpty(mainId))
            {
                string url = ekpBll.GetEkpHistoryLogByInstanceId(mainId, _context.User.LoginId);
                if (!string.IsNullOrEmpty(url))
                {
                    this.historyIrfame.Attributes.Remove("src");
                    this.historyIrfame.Attributes.Add("src", url);
                }
                else
                {
                    this.historyIrfame.Attributes.Remove("height");
                    this.historyIrfame.Attributes.Add("height", "0");
                }
            }
            else
            {
                this.historyIrfame.Attributes.Remove("height");
                this.historyIrfame.Attributes.Add("height", "0");
            }
        }

        #region EKP Ajax Methods

        /// <summary>
        /// 审批人通过
        /// </summary>
        [AjaxMethod]
        public void Approve()
        {
            ekpBll.DoAgree(_context.User.LoginId, this.formInstanceId, this.remarkValue);
        }

        /// <summary>
        /// 审批人驳回
        /// </summary>
        [AjaxMethod]
        public void Refuse()
        {
            ekpBll.DoReject(_context.User.LoginId, this.formInstanceId, this.remarkValue);
        }

        /// <summary>
        /// 申请人催办
        /// </summary>
        [AjaxMethod]
        public void Press()
        {
            ekpBll.DoPress(_context.User.LoginId, this.formInstanceId, this.remarkValue);
        }

        /// <summary>
        /// 申请人撤销
        /// </summary>
        [AjaxMethod]
        public void Abandon()
        {
            ekpBll.DoAbandon(_context.User.LoginId, this.formInstanceId, this.remarkValue);
        }

        #endregion
    }
}