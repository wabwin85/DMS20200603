using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Coolite.Ext.Web;

namespace DMS.Website.Common
{
    public class EkpBaseUserControl : BaseUserControl
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public EkpWorkflowBLL ekpBLL = new EkpWorkflowBLL();
        public List<EkpOperParam> operationList;
        public string currentNodeInfo;

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            if (!IsPostBack && !Coolite.Ext.Web.Ext.IsAjaxRequest)
            {
                CheckPageAccess();
                OnEkpAuthenticate();
            }
        }

        protected virtual void OnEkpAuthenticate()
        {
            //code
        }

        private void CheckPageAccess()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["FormId"]))
            {
                //判断FormId是不是GUID    
                Guid result = Guid.Empty;

                try
                {
                    result = new Guid(Request.QueryString["FormId"]);
                }
                catch
                {
                    Ext.Msg.Alert("错误", "参数不正确，请重新进入！", new JFunction("window.location.href ='/Default.aspx'")).Show();
                    //throw new Exception("参数不正确，请重新进入！");
                }

                bool canRead = ekpBLL.ValidateUserCanReadEkpProcess(result.ToString(), _context.User.LoginId);
                FormInstanceMaster om = ekpBLL.GetFormInstanceMasterByApplyId(result.ToString());
                operationList = ekpBLL.GetEkpParamList(_context.User.LoginId, result.ToString());
                if ((om == null || om.CreateUser.Trim().ToUpper() != _context.User.LoginId.Trim().ToUpper())
                    && (operationList == null || operationList.Count() == 0)
                    && canRead == false)
                    Ext.Msg.Alert("错误", "您没有此申请的阅读或审批权限！", new JFunction("window.location.href ='/Default.aspx'")).Show();
                //throw new Exception("您没有此申请的阅读或审批权限");
            }
        }
    }
}