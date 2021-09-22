using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using System.Xml;
using System.Xml.Xsl;

namespace DMS.Website.Pages.Home
{
    public partial class MedtronicHomePage : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    throw new Exception("请以Medtronic用户身份登录");
                }
                BuildTree(TreePanel1.Root);
            }
        }

        private int GetPendingAuditCount()
        {
            IInventoryAdjustBLL business = new InventoryAdjustBLL();
            return business.GetPendingAuditCount();
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

            Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("待审批 (<b><font color='red'>{0}</font></b>)", GetPendingAuditCount().ToString());
            node.Icon = Icon.PackageIn;
            //node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/InventoryAdjustAudit.aspx','subMenu77','库存调整审批');";
             node.Listeners.Click.Handler = "top.createTab({id: 'subMenu77',title: '库存调整审批',url: 'Pages/Inventory/InventoryAdjustAudit.aspx'});";
            root.Nodes.Add(node);

            return nodes;
        }

        [AjaxMethod]
        public string RefreshTree()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = BuildTree(null);
            return nodes.ToJson();
        }

        protected void DeliveryNoteStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            IDeliveryNotes business = new DeliveryNotes();

            Hashtable param = new Hashtable();

            param.Add("TopCount", 10);

            DataSet ds = business.QueryDeliveryNote(param);

            this.DeliveryNoteStore.DataSource = ds;
            this.DeliveryNoteStore.DataBind();
        }
    }
}
