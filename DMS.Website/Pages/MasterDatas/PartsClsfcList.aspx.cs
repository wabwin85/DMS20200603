using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.MasterDatas
{
    using Coolite.Ext.Web;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using Lafite.RoleModel.Security;

    public partial class PartsClsfcList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private ICfns _cfns = Global.ApplicationContainer.Resolve<ICfns>();
        private IProductClassifications _partsBiz = Global.ApplicationContainer.Resolve<IProductClassifications>();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {

            }

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

            IList<PartsClassification> list = _partsBiz.GetClassificationByLine(lineId);

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

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!string.IsNullOrEmpty(this.SelectedLine) && !string.IsNullOrEmpty(this.SelectedCatagory))
            {

                Guid saleId = new Guid(this.SelectedCatagory);

                Cfn param = new Cfn();
                param.ProductCatagoryPctId = new Guid(this.SelectedCatagory);

                int total = 0;
                IList<Cfn> query = _cfns.SelectByFilter(param, e.Start, e.Limit, out total);

                this.StoreRecords = query;

                (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = total;
                this.Store1.DataSource = query;
                this.Store1.DataBind();

            }
        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            if (!string.IsNullOrEmpty(this.SelectedLine) && !string.IsNullOrEmpty(this.SelectedCatagory))
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Cfn> data = dataHandler.CustomObjectData<Cfn>();

                Guid catagoryId = new Guid(this.SelectedCatagory);
                Guid lineId = new Guid(this.SelectedLine);

                _cfns.SaveCfnOfCatagory(data, catagoryId, lineId);

                e.Cancel = true;
            }
        }

        #region Tree 操作

        [AjaxMethod]
        public string DeleteSelectNode(string id)
        {
            string result = string.Empty;

            if (!string.IsNullOrEmpty(id))
            {
                int row = _partsBiz.Delete(new Guid(id));

                if (row > 0)
                    result = "ok";
            }

            return result;
        }


        protected void DeleteNode_Click(object sender, AjaxEventArgs e)
        {
            string id = e.ExtraParams["id"];

            if (!string.IsNullOrEmpty(id))
            {
                try
                {
                    this.DeleteSelectNode(id);
                    e.Success = true;

                    return;
                }
                catch
                {

                }

            }

            e.ErrorMessage = GetLocalResourceObject("DeleteNode_Click.ErrorMessage").ToString();
            e.Success = false;
        }

        #endregion

        #region 包含产品操作
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.CFNSearchDialog1.AfterSelectedHandler += OnAfterSelectedRow;
        }


        protected void SelectedNodeClick(object sender, AjaxEventArgs e)
        {
            this.SelectedCatagory = e.ExtraParams["selectedCatagory"];
        }

        /// <summary>
        /// 选择后，添加数据
        /// </summary>
        /// <param name="e"></param>
        protected void OnAfterSelectedRow(SelectedEventArgs e)
        {
            IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            IList<Cfn> sellist = e.ToList<Cfn>();

            //在已选择的数据中排除已经存在的，准备待添加的数据
            var waitingAdd = selectedRows.Where<IDictionary<string, string>>(p => !IsExistsStoreRecords(p["Id"])).ToArray<IDictionary<string, string>>();

            //更新已有关系的记录集
            if (this.StoreRecords != null)
            {
                var records = sellist.Where<Cfn>(p => !IsExistsStoreRecords(p.Id.ToString()));
                this.StoreRecords = this.StoreRecords.Concat<Cfn>(records).ToList<Cfn>();
            }

            //添加已选择的数据

            foreach (IDictionary<string, string> row in waitingAdd)
            {
                this.GridPanel1.AddRecord(row);
            }
        }

        /// <summary>
        /// 检查指定Id是否存在
        /// </summary>
        /// <param name="hosId"></param>
        /// <returns></returns>
        public bool IsExistsStoreRecords(string id)
        {
            Cfn hos = null;

            if (this.StoreRecords != null)
            {
                hos = this.StoreRecords.FirstOrDefault(p => p.Id.ToString() == id);
            }
            if (hos != null)
                return true;
            else
                return false;
        }

        public IList<Cfn> StoreRecords
        {
            get
            {
                object obj = this.Session["CfnOfCatagory_StoreRecords"];
                return (obj == null) ? null : (IList<Cfn>)this.Session["CfnOfCatagory_StoreRecords"];
            }
            set
            {
                this.Session["CfnOfCatagory_StoreRecords"] = value;
            }
        }

        protected string SelectedLine
        {
            get
            {
                return this.cbCatories.SelectedItem.Value;
            }
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

        #endregion

        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.menuDelete.Visible = pers.IsPermissible(Business.ProductClassifications.Action_ProductClassifications, PermissionType.Delete);
            this.menuEdit.Visible = pers.IsPermissible(Business.ProductClassifications.Action_ProductClassifications, PermissionType.Write);
            this.menuAdd.Visible = this.menuEdit.Visible;

            this.btnAdd.Visible = pers.IsPermissible(Business.Cfns.Action_Cfns, PermissionType.Write);
            this.btnDelete.Visible = this.btnAdd.Visible;
            this.btnSave.Visible = this.btnAdd.Visible;

        }
    }
}
