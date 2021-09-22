using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.Website.Common
{
    public class EkpBasePage : BasePage
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
                    throw new Exception("参数不正确，请重新进入！");
                }

                FormInstanceMaster om = ekpBLL.GetFormInstanceMasterByApplyId(Request.QueryString["FormId"]);
                operationList = ekpBLL.GetEkpParamList(_context.User.LoginId, Request.QueryString["FormId"]);
                if ((om == null || om.CreateUser.Trim().ToUpper() != _context.User.LoginId.Trim().ToUpper()) 
                    && (operationList == null || operationList.Count() == 0))
                    throw new Exception("您没有审批的权限");
            }
        }
    }
}