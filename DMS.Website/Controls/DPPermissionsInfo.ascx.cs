using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Coolite.Ext.Web;
using DMS.Model;
using DMS.Website.Common;
using DMS.Common;
using DMS.Business;
using Lafite.RoleModel.Security;
using DMS.Business.DP;
using System.Data;

namespace DMS.Website.Controls
{
    public partial class DPPermissionsInfo : BaseUserControl
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        private IDpRightService _DpRightService = null;
        private IDpRightService DpRightService
        {
            get
            {
                if (_DpRightService == null)
                {
                    _DpRightService = new DpRightService();
                }
                return _DpRightService;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.tfLastUpdateUser.Text = _context.User.Id;
            }
        }
        public void SaveButton_Click(object sender, EventArgs e)
        {
            string aa = this.tfRoleName.Text;
            string bb = this.hdRoleID.Text;
            string cc = this.tfLastUpdateUser.Text;
            BindTree();
        }


        [AjaxMethod]
        private void BindTree() 
        {
            DataTable dt=  DpRightService.GetAllModularAndPermissions(this.hdRoleID.Text).Tables[0];
            if (dt.Rows.Count > 0) 
            {
                for (int i = 0; i < dt.Rows.Count; i++) 
                {
                    if (dt.Rows[i]["DICT_LEVEL"].ToString().Equals("1")) 
                    {
                        Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                        node.NodeID = dt.Rows[i]["Id"].ToString();
                        node.Text = dt.Rows[i]["ModleName"].ToString();
                        this.TreePanel1.Root.Add(node);
                        for (int a=0; a < dt.Rows.Count; a++) 
                        {
                            if (dt.Rows[a]["DICT_LEVEL"].ToString().Equals("2") && dt.Rows[a]["PID"].ToString().Equals(node.NodeID)) 
                            {
                                Coolite.Ext.Web.TreeNode nodeChild = new Coolite.Ext.Web.TreeNode();
                                nodeChild.NodeID = dt.Rows[a]["Id"].ToString();
                                nodeChild.Text = dt.Rows[a]["ModleName"].ToString();
                                node.Nodes.Add(nodeChild);
                            }
                        }
                    }
                }
            }
        }

     
    }
}