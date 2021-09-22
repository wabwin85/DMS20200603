using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using Microsoft.Practices.Unity;
    using DMS.Business.MasterData;
    using Lafite.RoleModel.Security;
    using Coolite.Ext.Web;
    using DMS.Website.Common;
    using DMS.Common;
    using DMS.Business;
    using System.Data;
    using DMS.Model.Data;

    public partial class ProductFileDownlode : BasePage
    {
        #region 公共
        private IAttachmentBLL _attachBll = null;

        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }

        protected string SelectedLevelID
        {
            get
            {
                return this.hiddenSelectedlevelID.Text.Trim();
            }

            set
            {
                this.hiddenSelectedlevelID.Text = value;
            }
        }

        private IProductLevelRelationship _productLevelRelationship = null;
        private IProductLevelRelationship PLRelationship
        {
            get
            {
                if (_productLevelRelationship == null)
                {
                    _productLevelRelationship = new ProductLevelRelationship();
                }
                return _productLevelRelationship;
            }
        }


        #endregion
        private IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Ext.IsAjaxRequest && !IsPostBack)
            {
                this.hiddenSelectedlevelID.Text = "00000000-0000-0000-0000-000000000000";
                const string template = "refreshTree({0});";

                this.TreePanel1.AddScript(template, this.TreePanel1.ClientID);
            }
        }

        #region 分类树

        [AjaxMethod]
        public string RefreshTrees()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildTree(null);
            return nodes.ToJson();
        }

        /// <summary>
        /// 构造分类树
        /// </summary>
        /// <param name="nodes"></param>
        /// <returns></returns>
        private TreeNodeCollection BuildTree(TreeNodeCollection nodes)
        {
            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            
            DataTable dtLevel = PLRelationship.GetProductlevelRelation().Tables[0];
            DataTable dtLevel_1 = null;
            if (dtLevel.Rows.Count > 0)
            {
                TreeNode rootNode0 = new Coolite.Ext.Web.TreeNode();
                rootNode0.NodeID = "00000000-0000-0000-0000-000000000000";
                rootNode0.Text = "产品层级";
                rootNode0.Expanded = true;
                rootNode0.Qtip = "产品层级";

                rootNode0.Icon = Icon.FolderHome;
                nodes.Add(rootNode0);



                dtLevel_1 = dtLevel.Clone();
                DataRow[] dr_1 = dtLevel.Select("PLR_Level=1");
                foreach (DataRow row in dr_1)
                {
                    dtLevel_1.Rows.Add(row.ItemArray);
                }

                for (int i = 0; i < dtLevel_1.Rows.Count; i++)
                {
                    TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
                    rootNode.NodeID = dtLevel.Rows[i]["PLR_ID"].ToString();
                    rootNode.Text = dtLevel.Rows[i]["PLR_LevelDesc"].ToString();
                    rootNode.Qtip = dtLevel.Rows[i]["PLR_LevelCode"].ToString();
                    rootNode.Leaf = false;
                    rootNode.Expanded = false;
                    rootNode0.Nodes.Add(rootNode);

                    #region 绑定二级一下产品线
                    DataTable dtLevel_2 = null;
                    dtLevel_2 = dtLevel.Clone();
                    DataRow[] dr_2 = dtLevel.Select("PLR_Level=2 and PLR_ParLevelCode= '" + rootNode.NodeID + "'");
                    foreach (DataRow row in dr_2)
                    {
                        dtLevel_2.Rows.Add(row.ItemArray);
                    }
                    for (int a = 0; a < dtLevel_2.Rows.Count; a++)
                    {
                        TreeNode rootNode2 = new Coolite.Ext.Web.TreeNode();
                        rootNode2.NodeID = dtLevel_2.Rows[a]["PLR_ID"].ToString();
                        rootNode2.Text = dtLevel_2.Rows[a]["PLR_LevelDesc"].ToString();
                        rootNode2.Expanded = false;
                        rootNode2.Qtip = dtLevel_2.Rows[a]["PLR_LevelCode"].ToString();
                        rootNode.Nodes.Add(rootNode2);

                        DataTable dtLevel_3 = null;
                        dtLevel_3 = dtLevel.Clone();
                        DataRow[] dr_3 = dtLevel.Select("PLR_Level=3 and PLR_ParLevelCode= '" + rootNode2.NodeID + "'");
                        foreach (DataRow row in dr_3)
                        {
                            dtLevel_3.Rows.Add(row.ItemArray);
                        }
                        for (int h = 0; h < dtLevel_3.Rows.Count; h++)
                        {
                            TreeNode rootNode3 = new Coolite.Ext.Web.TreeNode();
                            rootNode3.NodeID = dtLevel_3.Rows[h]["PLR_ID"].ToString();
                            rootNode3.Text = dtLevel_3.Rows[h]["PLR_LevelDesc"].ToString();
                            rootNode3.Expanded = false;
                            rootNode3.Qtip = dtLevel_3.Rows[h]["PLR_LevelCode"].ToString();
                            rootNode2.Nodes.Add(rootNode3);

                            DataTable dtLevel_4 = null;
                            dtLevel_4 = dtLevel.Clone();
                            DataRow[] dr_4 = dtLevel.Select("PLR_Level=4 and PLR_ParLevelCode= '" + rootNode3.NodeID + "'");
                            foreach (DataRow row in dr_4)
                            {
                                dtLevel_4.Rows.Add(row.ItemArray);
                            }
                            for (int m = 0; m < dtLevel_4.Rows.Count; m++)
                            {
                                TreeNode rootNode4 = new Coolite.Ext.Web.TreeNode();
                                rootNode4.NodeID = dtLevel_4.Rows[m]["PLR_ID"].ToString();
                                rootNode4.Text = dtLevel_4.Rows[m]["PLR_LevelDesc"].ToString();
                                rootNode4.Expanded = false;
                                rootNode4.Qtip = dtLevel_4.Rows[m]["PLR_LevelCode"].ToString();
                                rootNode3.Nodes.Add(rootNode4);

                                DataTable dtLevel_5 = null;
                                dtLevel_5 = dtLevel.Clone();
                                DataRow[] dr_5 = dtLevel.Select("PLR_Level=5 and PLR_ParLevelCode= '" + rootNode4.NodeID + "'");
                                foreach (DataRow row in dr_5)
                                {
                                    dtLevel_5.Rows.Add(row.ItemArray);
                                }
                                for (int n = 0; n < dtLevel_5.Rows.Count; n++)
                                {
                                    TreeNode rootNode5 = new Coolite.Ext.Web.TreeNode();
                                    rootNode5.NodeID = dtLevel_5.Rows[n]["PLR_ID"].ToString();
                                    rootNode5.Text = dtLevel_5.Rows[n]["PLR_LevelDesc"].ToString();
                                    rootNode5.Expanded = false;
                                    rootNode5.Qtip = dtLevel_5.Rows[n]["PLR_LevelCode"].ToString();
                                    rootNode4.Nodes.Add(rootNode5);
                                }
                            }
                        }
                    }

                    #endregion
                }
            }
            return nodes;
        }

       

        protected void SelectedNodeClick(object sender, AjaxEventArgs e)
        {
            this.SelectedLevelID = e.ExtraParams["selectedlevelID"];
        }

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(new Guid(this.hiddenSelectedlevelID.Text), AttachmentType.ProductDescription, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }

        protected void UseManualStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(new Guid(this.hiddenSelectedlevelID.Text), AttachmentType.ProductManual, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            UseManualStore.DataSource = ds;
            UseManualStore.DataBind();
        }

        #endregion
    }
}
