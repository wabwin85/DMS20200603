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
    using Lafite.RoleModel.Security;
    using DMS.Common;
    using Microsoft.Practices.Unity;
    


    public partial class TSRHospital : BasePage
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Ext.IsAjaxRequest && !IsPostBack)
            {
                //this.BuildTree(this.TreePanel1.Root);

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

            //Lafite.RoleModel.Security.Organization org = new Lafite.RoleModel.Security.Organization();
            //org.Load();

            Lafite.RoleModel.Security.OrganizationUnit rootUnit = null;

            //rootUnit = org.RootNode;
            rootUnit = _context.User.OrganizationUnit;

            if (rootUnit != null)
            {
                TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
                //rootNode.Text = "运营部";
                rootNode.Text = rootUnit.AttributeName;
                rootNode.NodeID = rootUnit.Id;
                rootNode.Qtip = rootUnit.Description;

                ConfigItem extProperty1 = new ConfigItem("attributeType", "\"" + rootUnit.AttributeType + "\"");
                rootNode.CustomAttributes.Add(extProperty1);
                ConfigItem extProperty2 = new ConfigItem("childType", "\"Organization\"");
                rootNode.CustomAttributes.Add(extProperty2);

                rootNode.Icon = Icon.FolderHome;
                rootNode.Expanded = true;
                nodes.Add(rootNode);

                this.BuildNode(rootUnit, rootNode, false);
            }

            return nodes;

        }

        /// <summary>
        /// 递归构造分类树子节点
        /// </summary>
        /// <param name="list"></param>
        /// <param name="lineId"></param>
        /// <param name="currentNode"></param>
        private void BuildNode(Lafite.RoleModel.Security.OrganizationUnit siteNode, TreeNode currentNode, bool allowUser)
        {
            if (allowUser)
                this.BuildUser(siteNode, currentNode);
            else
            {
                LoginUser item = _context.User;
                TreeNode child = new TreeNode(item.LoginId, Icon.User);
                child.NodeID = item.Id;
                child.Qtip = item.FullName;

                ConfigItem extProperty2 = new ConfigItem("childType", "\"User\"");
                child.CustomAttributes.Add(extProperty2);

                //child.IconCls = "icon-user";
                //child.Icon = Icon.User;
                child.IconFile = "../../resources/images/icons/user.png";

                currentNode.Nodes.Add(child);
            }

            foreach (Lafite.RoleModel.Security.OrganizationUnit item in siteNode.Childs)
            {
                TreeNode node = new TreeNode();

                node.Text = item.AttributeName;
                node.NodeID = item.Id.ToString();
                node.Qtip = item.Description;

                ConfigItem extProperty1 = new ConfigItem("attributeType", "\"" + item.AttributeType + "\"");
                node.CustomAttributes.Add(extProperty1);
                ConfigItem extProperty2 = new ConfigItem("childType", "\"Organization\"");
                node.CustomAttributes.Add(extProperty2);

                currentNode.Nodes.Add(node);

                this.BuildNode(item, node, true);


            }

        }

        private void BuildUser(Lafite.RoleModel.Security.OrganizationUnit siteNode, TreeNode currentNode)
        {
            IList<Lafite.RoleModel.Security.LoginUser> users = siteNode.GetUsers();

            if (users == null) return;
            if (users.Count < 1) return;

            foreach (Lafite.RoleModel.Security.LoginUser item in users)
            {
                TreeNode child = new TreeNode(item.LoginId, Icon.User);
                child.NodeID = item.Id;
                child.Qtip = item.FullName;

                ConfigItem extProperty2 = new ConfigItem("childType", "\"User\"");
                child.CustomAttributes.Add(extProperty2);

                //child.IconCls = "icon-user";
                //child.Icon = Icon.User;
                child.IconFile = "../../resources/images/icons/user.png";

                currentNode.Nodes.Add(child);
            }


        }
        #endregion


        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string prodlineId = string.Empty;

            if (string.IsNullOrEmpty(this.SelectedLine) && !string.IsNullOrEmpty(this.SelectedSale))
            {
                OrganizationUnit productline = null;
                IList<OrganizationUnit> list = _context.User.OrganizationUnits;
                foreach (var item in list)
                {
                    productline = OrganizationHelper.GetParentOrganizationUnit(SR.Organization_ProductLine, item.Id);

                    if (productline != null)
                        break;
                }

                if(productline != null)
                    prodlineId = productline.Id;
            }
            else
                prodlineId = this.SelectedLine;

            if (!string.IsNullOrEmpty(prodlineId) && !string.IsNullOrEmpty(this.SelectedSale))
            {

                Guid saleId = new Guid(this.SelectedSale);
                Guid lineId = new Guid(prodlineId);

                //IList<Hospital> query = bll.GetListBySales(saleId);

               // int total = 0;
                IList<Hospital> query = HospitalBiz.SelectBySales(null, ExistsState.IsExists, lineId , saleId);
                
                //(this.SalesOfHostapitalStore1.Proxy[0] as DataSourceProxy).TotalCount = total;
                this.StoreRecords = query;

                this.SalesOfHostapitalStore1.DataSource = query;
                this.SalesOfHostapitalStore1.DataBind();

            }
        }

        protected void Store1_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            //you can add own logic for save using one of above data representation and then set e.Cancel=true for canceling Store events

            if (!string.IsNullOrEmpty(this.SelectedLine) && !string.IsNullOrEmpty(this.SelectedSale))
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                Guid saleId = new Guid(this.SelectedSale);
                Guid lineId = new Guid(this.SelectedLine);

                HospitalBiz.SaveHospitalOfSalesChanges(data, lineId, saleId);

                e.Cancel = true;
            }
        }


        protected void SelectedNodeClick(object sender, AjaxEventArgs e)
        {
            this.SelectedSale = e.ExtraParams["selectedUser"];
            this.SelectedLine = e.ExtraParams["selectedLine"];

        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.HospitalSelectorDialog1.AfterSelectedHandler += OnAfterSelectedRow;
        }

        /// <summary>
        /// 选择医院后，添加数据
        /// </summary>
        /// <param name="e"></param>
        protected void OnAfterSelectedRow(SelectedEventArgs e)
        {
            //IDictionary<string, string>[] selectedRows = e.ToDictionarys();
            //IList<Hospital> sellist = e.ToList<Hospital>();

            ////在已选择的数据中排除已经存在的，准备待添加的数据
            //var waitingAdd = selectedRows.Where<IDictionary<string, string>>(p=> !IsExistsStoreRecords(p["HosId"])).ToArray<IDictionary<string, string>>();

            ////更新已有关系的记录集
            //if (this.StoreRecords != null)
            //{
            //    var records = sellist.Where<Hospital>(p=> !IsExistsStoreRecords(p.HosId.ToString()));
            //    this.StoreRecords = this.StoreRecords.Concat<Hospital>(records).ToList<Hospital>();
            //}

            ////添加已选择的数据
            //foreach (IDictionary<string, string> row in waitingAdd)
            //{
            //    this.GridPanel1.AddRecord(row);
            //}

            if (e.Parameters == null) return;

            SelectTerritoryType selectType = (SelectTerritoryType)Enum.Parse(typeof(SelectTerritoryType), e.Parameters["SelectType"]);

            IDictionary<string, string>[] sellist = e.ToDictionarys();
            IDictionary<string, string>[] disSellist = e.GetDisSelectDictionarys();

            IDictionary<string, string>[] selected = null;

            if (disSellist.Length > 0)
            {
                var query = from p in sellist
                            where disSellist.FirstOrDefault(c => c["Key"] == p["Key"]) == null
                            select p;

                selected = query.ToArray<IDictionary<string, string>>();
            }
            else
                selected = sellist;

            string hosProvince = e.Parameters["Province"];
            string hosCity = e.Parameters["City"];
            string hosDistrict = e.Parameters["District"];

            Guid saleId = new Guid(this.SelectedSale);
            Guid lineId = new Guid(this.SelectedLine);

            HospitalBiz.SaveHospitalOfSales(saleId, selected, selectType, hosProvince, hosCity, hosDistrict, lineId);

            this.GridPanel1.Reload();
        }

        /// <summary>
        /// 检查指定hosId是否存在
        /// </summary>
        /// <param name="hosId"></param>
        /// <returns></returns>
        public bool IsExistsStoreRecords(string hosId)
        {
            Hospital hos = null;

            if (this.StoreRecords != null)
            {
                hos = this.StoreRecords.FirstOrDefault(p => p.HosId.ToString() == hosId);
            }
            if (hos != null)
                return true;
            else
                return false;
        }

        /// <summary>
        /// Gets or sets the store records.
        /// </summary>
        /// <value>The store records.</value>
        public IList<Hospital> StoreRecords
        {
            get
            {
                object obj = this.Session["TsrOfHospital_StoreRecords"];
                return (obj == null) ? null : (IList<Hospital>)this.Session["TsrOfHospital_StoreRecords"];
            }
            set
            {
                this.Session["TsrOfHospital_StoreRecords"] = value;
            }
        }

        protected string SelectedLine
        {
            get
            {
                return this.hiddenSelectedLine.Text.Trim();
            }

            set
            {
                this.hiddenSelectedLine.Text = value;
            }
        }


        protected string SelectedSale
        {
            get
            {
                return this.hiddenSelectedSale.Text.Trim();
            }

            set
            {
                this.hiddenSelectedSale.Text = value;
            }
        }


        private IHospitals _hospitaBiz = null;

        [Dependency]
        public IHospitals HospitalBiz
        {
            get { return _hospitaBiz; }
            set { _hospitaBiz = value; }
        }


        /// <summary>
        /// Called when [authenticate].
        /// </summary>
        protected override void OnAuthenticate()
        {
            Permissions pers = this._context.User.GetPermissions();

            //正式使用权限时请使用Visible = false, 更安全;

            this.btnDelete.Visible = pers.IsPermissible(Business.Hospitals.Action_HospitalOfSales, PermissionType.Write);
            this.btnAdd.Visible = pers.IsPermissible(Business.Hospitals.Action_HospitalOfSales, PermissionType.Write);
            //this.btnSave.Visible = pers.IsPermissible(Business.Hospitals.Action_HospitalOfSales, PermissionType.Write);
            
        }

    }
}
