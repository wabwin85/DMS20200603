using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Data;
using System.Collections;
namespace DMS.Website.Pages.MasterDatas
{
    public partial class TerritoryList : BasePage
    {

        #region 公用方法
        private ITerritoryBLL _business = null;
        [Dependency]
        public ITerritoryBLL business
        {
            get { return _business; }
            set { _business = value; }
        }

        protected string SelectedCatagory
        {
            get
            {
                return this.hiddenSelectedCatagory.Text.Trim();
            }

            set
            {
                this.hiddenSelectedCatagory.Text = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        #endregion

        #region Store
        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!string.IsNullOrEmpty(this.SelectedCatagory))
            {
                string ProvinceId = this.SelectedCatagory;
                int total = 0;
                DataSet ds = business.GetTerritoryByProvinceId(ProvinceId, e.Start, e.Limit, out total);
                (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = total;
                this.Store1.DataSource = ds;
                this.Store1.DataBind();
            }
        }

        protected void WinDealerStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int total = 0;
            string temid = this.hiddenTemId.Text.Trim();
            if (temid != "")
            {
                DataSet ds = business.GetDealerTerritoryByTemId(temid, e.Start, e.Limit, out total);
                (this.WinDealerStore.Proxy[0] as DataSourceProxy).TotalCount = total;
                this.WinDealerStore.DataSource = ds;
                this.WinDealerStore.DataBind();
            }
        }

        protected void WinSelectDealerStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int total = 0;
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(this.txtWinSelectSAPCode.Text.Trim()))
            {
                ht.Add("SapCode", this.txtWinSelectSAPCode.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtWinSelectDealer.Text.Trim()))
            {
                ht.Add("ChineseName", this.txtWinSelectDealer.Text.Trim());
            }
            if (!string.IsNullOrEmpty(hiddenTemId.Text.Trim())) //用它过滤已经添加的经销商
            {
                ht.Add("TemId", hiddenTemId.Text);
            }
            DataSet ds = business.GetDealerByTerritory(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar4.PageSize : e.Limit), out total);
            e.TotalCount = total;
            this.WinSelectDealerStore.DataSource = ds.Tables[0];
            this.WinSelectDealerStore.DataBind();
        }

        protected void WinTerritoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(this.txtWinCode.Text))
            {
                ht.Add("TemCode", this.txtWinCode.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.txtWinName.Text))
            {
                ht.Add("TemName", this.txtWinName.Text);
            }
            if (!string.IsNullOrEmpty(this.cbWinDistribution.SelectedItem.Text.Trim())) //是否分配
            {
                ht.Add("ParentIDFlag", this.cbWinDistribution.SelectedItem.Value);
            }
            int total = 0;
            DataSet ds = business.GetTerritoryByFilter(ht, e.Start, e.Limit, out total);
            (this.WinTerritoryStore.Proxy[0] as DataSourceProxy).TotalCount = total;
            this.WinTerritoryStore.DataSource = ds;
            this.WinTerritoryStore.DataBind();

        }
        #endregion

        #region 私有方法

        protected void SelectedNodeClick(object sender, AjaxEventArgs e)
        {
            //树单击后得到NodeId 赋给隐藏框
            this.SelectedCatagory = e.ExtraParams["selectedCatagory"];
            hiddenlEVEL.Text = "";
            if (SelectedCatagory != "")
            {
                hiddenlEVEL.Text = business.GetLevel(this.SelectedCatagory, 0); //得到当前节点的层级
            }
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildTree(Coolite.Ext.Web.TreeNodeCollection nodes)
        {
            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }
            Coolite.Ext.Web.TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
            rootNode.Text = "Synthes";
            rootNode.NodeID = "Synthes";
            rootNode.Icon = Icon.FolderHome;
            rootNode.Expanded = true;
            nodes.Add(rootNode);
            DataSet ds = business.GetBUList();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                node.Text = dr["ATTRIBUTE_NAME"].ToString();
                node.NodeID = dr["Id"].ToString();
                rootNode.Nodes.Add(node);

                BuildNode(node.NodeID, node);
            }
            return nodes;
        }

        /// <summary>
        /// 递归构造分类树子节点
        /// </summary>
        /// <param name="list"></param>
        /// <param name="lineId"></param>
        /// <param name="currentNode"></param>
        private void BuildNode(string lineId, Coolite.Ext.Web.TreeNode currentNode)
        {
            DataSet ds = business.GetChildNode(lineId);

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();

                node.Text = dr["ATTRIBUTE_NAME"].ToString();
                node.NodeID = dr["Id"].ToString();

                //ConfigItem extProperty1 = new ConfigItem("description", item.Description);
                //node.CustomAttributes.Add(extProperty1);

                currentNode.Nodes.Add(node);

                this.BuildNode(node.NodeID, node);
            }

        }
        #endregion

        #region AjaxMethod

        [AjaxMethod]
        public string RefreshLines()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildTree(null);
            return nodes.ToJson();
        }

        /// <summary>
        /// 添加区域
        /// </summary>
        /// <param name="param"></param>
        [AjaxMethod]
        public bool AddTerritoryItem(string param)
        {
            param = param.Substring(0, param.Length - 1);
            bool rel = business.AddTerritory(SelectedCatagory, param.Split(','));
            return rel;
        }

        [AjaxMethod]
        public bool Adddealer(string param)
        {
            param = param.Substring(0, param.Length - 1);
            string temid = this.hiddenTemId.Text.Trim();
            bool rel = false;
            if (temid != "")
            {
                rel = business.InsertDealerTerritory(temid, param.Split(','));
            }
            return rel;
        }

        /// <summary>
        /// 删除区域
        /// </summary>
        /// <param name="param"></param>
        [AjaxMethod]
        public bool DeleteTerritory(string param)
        {
            param = param.Substring(0, param.Length - 1);
            bool rel = business.deleteTerritory(param.Split(','));
            return rel;
        }

        [AjaxMethod]
        public void deleteDealerTerritory(string DTid)
        {
            business.deleteDealerTerritory(DTid);
        }
        #endregion

    }
}
