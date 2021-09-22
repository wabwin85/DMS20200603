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
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business.DP;
using Lafite.RoleModel.Security;
using DMS.Model;

namespace DMS.Website.Pages.DP
{
    public partial class DPPermissionsInfo : BasePage
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
            if (!IsPostBack)
            {
                if (Request.QueryString["RoleID"] != null && Request.QueryString["RoleName"] != null)
                {
                    this.tfRoleName.Text = Request.QueryString["RoleName"].ToString();
                    this.tfRoleID.Text = Request.QueryString["RoleID"].ToString();
                }
                this.tfLastUpdateUser.Text = _context.User.Id;
                this.BuildTree(TreePanel1.Root);
            }
        }

        [AjaxMethod]
        public string RefreshMenu()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildTree(null);
            return nodes.ToJson();
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildTree(Coolite.Ext.Web.TreeNodeCollection nodes)
        {
            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            Coolite.Ext.Web.TreeNode root = new Coolite.Ext.Web.TreeNode();
            root.Text = "Root";
            nodes.Add(root);

            DataTable dt = DpRightService.GetAllModularAndPermissions(this.tfRoleID.Text).Tables[0];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (dt.Rows[i]["DICT_LEVEL"].ToString().Equals("1"))
                    {
                        Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                        node.NodeID = dt.Rows[i]["Id"].ToString();
                        node.Text = dt.Rows[i]["ModleName"].ToString();
                        node.Expanded = true;
                        root.Expanded = true;
                        root.Nodes.Add(node);
                        for (int a = 0; a < dt.Rows.Count; a++)
                        {
                            if (dt.Rows[a]["DICT_LEVEL"].ToString().Equals("2") && dt.Rows[a]["PID"].ToString().Equals(node.NodeID))
                            {
                                Coolite.Ext.Web.TreeNode nodeChild = new Coolite.Ext.Web.TreeNode();
                                nodeChild.NodeID = dt.Rows[a]["Id"].ToString();
                                nodeChild.Text = dt.Rows[a]["ModleName"].ToString();
                                nodeChild.Leaf = true;
                                if (!dt.Rows[a]["RoleID"].ToString().Equals(""))
                                {
                                    nodeChild.Checked = ThreeStateBool.True;
                                }
                                else
                                {
                                    nodeChild.Checked = ThreeStateBool.False;
                                }
                                node.Nodes.Add(nodeChild);
                            }
                        }
                    }
                }
            }
            return nodes;
        }

        [AjaxMethod]
        public void btnSubmitDate(string ModleId)
        {
            try
            {
                //删除原有权限
                int re = DpRightService.DeletePermissionsByRoleId(this.tfRoleID.Text);

                //维护当前设置权限
                DpRight dpRight = new DpRight();
                dpRight.Roleid = new Guid(this.tfRoleID.Text);
                dpRight.IsAction = true;
                dpRight.CreateBy = this.tfLastUpdateUser.Text;
                dpRight.CreateDate = DateTime.Now;
                dpRight.IsDelete = false;

                string[] arrId = ModleId.Split(',');
                for (int i = 0; i < arrId.Length; i++)
                {
                    dpRight.Id = Guid.NewGuid();
                    dpRight.Modleid = new Guid(arrId[i].ToString());
                    DpRightService.InsertDpRight(dpRight);
                }
            }
            catch (Exception ex) 
            {
                Coolite.Ext.Web.ScriptManager.AjaxSuccess = false;
                Coolite.Ext.Web.ScriptManager.AjaxErrorMessage = ex.Message;
            }
        }
    }
}
