using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;

    public partial class PartsSelectorDialog : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        #region 分类树

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

            if (this.cbCatories.SelectedItem.Value == string.Empty) return nodes;

            Guid lineId = new Guid(this.cbCatories.SelectedItem.Value);

            IList<PartsClassification> list = this.GetParts(lineId);

            TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
            rootNode.Text = GetLocalResourceObject("BuildTree.rootNode.Text").ToString();//this.cbCatories.SelectedItem.Text;
            rootNode.NodeID = this.cbCatories.SelectedItem.Value;
            rootNode.Icon = Icon.FolderHome;
            rootNode.Expanded = true;
            nodes.Add(rootNode);


            var roots = from p in list
                        where p.ParentId == null
                        select p;

            foreach (PartsClassification item in roots)
            {
                TreeNode node = new TreeNode();
                node.Text = item.Name;
                node.NodeID = item.Id.Value.ToString();
                node.Qtip = item.Description;

                rootNode.Nodes.Add(node);

                BuildNode(list, item.Id.Value, node);
            }
            return nodes;
        }

        [AjaxMethod]
        public string RefreshLines()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildTree(null);
            return nodes.ToJson();
        }

        /// <summary>
        /// 获取分类列表
        /// </summary>
        /// <param name="lineId"></param>
        /// <param name="root"></param>
        /// <returns></returns>
        private IList<PartsClassification> GetParts(Guid lineId)
        {

            IProductClassifications bll = new ProductClassifications();
            IList<PartsClassification> list = bll.GetClassificationByLine(lineId);

            return list;
        }


        /// <summary>
        /// 递归构造分类树子节点
        /// </summary>
        /// <param name="list"></param>
        /// <param name="lineId"></param>
        /// <param name="currentNode"></param>
        private void BuildNode(IList<PartsClassification> list, Guid lineId, TreeNode currentNode)
        {
            var query = from p in list
                        where p.ParentId == lineId
                        select p;

            foreach (PartsClassification item in query)
            {
                TreeNode node = new TreeNode();

                node.Text = item.Name;
                node.NodeID = item.Id.Value.ToString();
                node.Qtip = item.Description;

                //ConfigItem extProperty1 = new ConfigItem("description", item.Description);
                //node.CustomAttributes.Add(extProperty1);

                currentNode.Nodes.Add(node);

                this.BuildNode(list, item.Id.Value, node);
            }

        }
        #endregion

        /// <summary>
        /// Selecteds the node click.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="Coolite.Ext.Web.AjaxEventArgs"/> instance containing the event data.</param>
        protected void SelectedNodeClick(object sender, AjaxEventArgs e)
        {
            this.hiddenSelectedCatagory.Text = e.ExtraParams["selectedCatagory"];
            this.hiddenSelectedCatagoryName.Text = e.ExtraParams["selectedCatagoryName"];
        }


        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {
            ParameterCollection paramCollection = new ParameterCollection();
            paramCollection.AddRange(e.ExtraParams);

            if (AfterSelectedHandler != null)
            {
                SelectedEventArgs eventArgs = new SelectedEventArgs(paramCollection);
                AfterSelectedHandler(eventArgs);
                e.Success = eventArgs.Success;
                e.ErrorMessage = eventArgs.ErrorMessage;
            }
            else 
                e.Success = true;
        }

        /// <summary>
        /// AfterSelectedHandler
        /// </summary>
        public AfterSelectedRow AfterSelectedHandler;

        /// <summary>
        /// Gets the selected catagory.
        /// </summary>
        /// <value>The selected catagory.</value>
        public string SelectedCatagory
        {
            get
            {
                return this.hiddenSelectedCatagory.Text;
            }
        }

        /// <summary>
        /// Gets the name of the selected catagory.
        /// </summary>
        /// <value>The name of the selected catagory.</value>
        public string SelectedCatagoryName
        {
            get
            {
                return this.hiddenSelectedCatagoryName.Text; 
            }        
        }

        /// <summary>
        /// Gets the selected product line.
        /// </summary>
        /// <value>The selected product line.</value>
        public string SelectedProductLine
        {
            get
            {
                return this.cbCatories.SelectedItem.Value;
            }
        }

        public string SelectedProductLineName
        {
            get
            {
                return this.cbCatories.SelectedItem.Text;
            }
        }
    }
}