using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Reflection;
using System.Data;
using System.Configuration;
using System.Web.UI;
using System.Linq;

using Microsoft.Reporting.WebForms;

namespace DMS.Website.Common
{
    using Coolite.Ext.Web;

    using DMS.Common.WebControls;
    using DMS.Common;

    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Business.Cache;
    using Lafite.RoleModel.Security;
    using System.Threading;
    using System.Globalization;
    using DMS.Model.Data;
    using Business.EKPWorkflow;

    public class BasePage : System.Web.UI.Page
    {
        #region 页面方法
        public BasePage()
        {


        }
        private BaseService serviceBase = new BaseService();
        protected override void OnLoad(EventArgs e)
        {
            OnAuthenticate();

            base.OnLoad(e);
        }

        /// <summary>
        /// Called when [authenticate]. must be override this method when [authenticate]
        /// </summary>
        protected virtual void OnAuthenticate()
        {
            //code
        }

        //added by bozhenfei on 20100813
        public string SystemLanguage
        {
            get
            {
                return Session["SystemLanguage"].ToString();
            }
        }

        protected override void InitializeCulture()
        {
            if (Session["SystemLanguage"] == null || string.IsNullOrEmpty(Session["SystemLanguage"].ToString()))
            {
                if (CultureInfo.CurrentCulture.Name == SR.CONST_SYS_LANG_CN)
                {
                    Session["SystemLanguage"] = SR.CONST_SYS_LANG_CN;
                }
                else
                {
                    Session["SystemLanguage"] = SR.CONST_SYS_LANG_EN;
                }
            }

            if (Session["SystemLanguage"] != null && !string.IsNullOrEmpty(Session["SystemLanguage"].ToString()))
            {
                Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["SystemLanguage"].ToString());
                Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["SystemLanguage"].ToString());
            }
            base.InitializeCulture();
        }
        //end

        private WebTool _webTools = new WebTool();
        public virtual WebTool WebTools
        {
            get { return _webTools; }
        }
        #endregion

        #region Session属性
        public bool IsDealer
        {
            get { return (RoleModelContext.Current.User.IdentityType == SR.Consts_System_Dealer_User); }
        }
        public bool IsAdmin
        {
            get { return RoleModelContext.Current.IsInRole("Administrators"); }
        }
        #endregion

        #region 经销商仓库绑定

        /// <summary>
        /// 根据当前登录经销商的身份、传入经销商ID和仓库类型得到仓库列表
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_WarehouseByDealer(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;

            if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
            }

            //added by bozhenfei on 20130703 根据当前登陆用户的类型再过滤可显示的仓库
            //接收参数DealerWarehouseType表示单据对应的仓库类型 Normal Consignment Borrow
            string DealerWarehouseType = "Normal";

            if (e.Parameters["DealerWarehouseType"] != null && !string.IsNullOrEmpty(e.Parameters["DealerWarehouseType"].ToString()))
            {
                DealerWarehouseType = e.Parameters["DealerWarehouseType"].ToString();
            }

            Bind_WarehouseByDealer((Store)sender, DealerId, DealerWarehouseType);
        }

        /// <summary>
        /// 根据传入经销商ID和仓库类型得到仓库列表
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_WarehouseByDealerAndType(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;

            if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
            }

            //接收参数DealerWarehouseType表示单据对应的仓库类型 Normal Consignment Borrow
            string DealerWarehouseType = "Normal";

            if (e.Parameters["DealerWarehouseType"] != null && !string.IsNullOrEmpty(e.Parameters["DealerWarehouseType"].ToString()))
            {
                DealerWarehouseType = e.Parameters["DealerWarehouseType"].ToString();
            }

            Bind_WarehouseByDealerAndType((Store)sender, DealerId, DealerWarehouseType);
        }

        protected internal virtual void Store_WarehouseByDealerAndTypeWithoutDWH(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;
            Guid ProductLineId = Guid.Empty;

            if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
            }
            if (e.Parameters["ProductLineId"] != null && !string.IsNullOrEmpty(e.Parameters["ProductLineId"].ToString()))
            {
                ProductLineId = new Guid(e.Parameters["ProductLineId"].ToString());
            }

            //接收参数DealerWarehouseType表示单据对应的仓库类型 Normal Consignment Borrow
            string DealerWarehouseType = "Normal";

            if (e.Parameters["DealerWarehouseType"] != null && !string.IsNullOrEmpty(e.Parameters["DealerWarehouseType"].ToString()))
            {
                DealerWarehouseType = e.Parameters["DealerWarehouseType"].ToString();
            }

            Bind_WarehouseByDealerAndTypeWithoutDWH((Store)sender, DealerId, ProductLineId, DealerWarehouseType);
        }
        

        /// <summary>
        /// 根据传入的一级经销商ID得到仓库地址
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_SAPWarehouseAddress(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerId = Guid.Empty;

            if (e.Parameters["DealerId"] != null && !string.IsNullOrEmpty(e.Parameters["DealerId"].ToString()))
            {
                DealerId = new Guid(e.Parameters["DealerId"].ToString());
            }

            Bind_SAPWarehouseAddress((Store)sender, DealerId);
        }

        #endregion

        #region 仓库类型绑定
        protected internal virtual void Store_WarehouseType(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_WarehouseType);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }
        #endregion

        #region 经销商移库状态绑定
        protected internal virtual void Store_TransferStatus(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Status);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }
        #endregion

        #region 经销商借货出库状态绑定
        protected internal virtual void Store_DealerTransferStatus(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_DealerTransfer_Status);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }
        #endregion

        #region 收货状态绑定
        protected internal virtual void Store_ReceiptStatus(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Receipt_Status);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }
        #endregion

        #region 收货类型绑定
        protected internal virtual void Store_ReceiptType(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Receipt_Type);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }
        #endregion

        #region 医院等级绑定
        /// <summary>
        /// the StoreRefershData method for Hospital Grade
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_HospitalGrade(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Hospital_Grade);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }

        protected internal virtual Store CreateHospitalGradeStore(Coolite.Ext.Web.ComboBox comboBox)
        {
            string storeName = "HospitalGradeStore";

            Store myStore = ComboBoxStoreHelper.CreateDictionaryStore(this.Form, storeName);
            myStore.RefreshData += Store_HospitalGrade;

            if (comboBox != null)
                comboBox.StoreID = storeName;

            IDictionary<string, string> dataSet = DictionaryHelper.GetDictionary(SR.Consts_Hospital_Grade);
            myStore.DataSource = dataSet;
            myStore.DataBind();

            return myStore;
        }

        #endregion

        #region 字典表绑定
        //added by bozhenfei on 20100323
        protected internal virtual void Bind_Dictionary(Store store, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            store.DataSource = dicts;
            store.DataBind();
        }
        /// <summary>
        /// 查询字典表
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_RefreshDictionary(object sender, StoreRefreshDataEventArgs e)
        {
            Bind_Dictionary((Store)sender, e.Parameters["Type"].ToString());
        }
        #endregion

        #region 医院级别绑定
        /// <summary>
        /// 医院级别
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_HospitalLevel(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Hospital_Level);

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dicts;
                store1.DataBind();
            }
        }

        protected internal virtual Store CreateHospitalLevelStore(Coolite.Ext.Web.ComboBox comboBox)
        {
            string storeName = "HospitalLevelStore";

            Store myStore = ComboBoxStoreHelper.CreateDictionaryStore(this.Form, storeName);
            myStore.RefreshData += Store_HospitalLevel;

            if (comboBox != null)
                comboBox.StoreID = storeName;

            IDictionary<string, string> dataSet = DictionaryHelper.GetDictionary(SR.Consts_Hospital_Level);

            myStore.DataSource = dataSet;
            myStore.DataBind();

            return myStore;
        }

        #endregion

        #region 省市地区绑定
        /// <summary>
        /// 省份
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_RefreshProvinces(object sender, StoreRefreshDataEventArgs e)
        {
            ITerritorys bll = new Territorys();
            IList<Territory> provinces = bll.GetProvinces();

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = provinces;
                store1.DataBind();
            }
        }

        protected internal virtual Store CreateProvincesStore(Coolite.Ext.Web.ComboBox comboBox)
        {
            string storeName = "ProvincesStore";

            Store myStore = ComboBoxStoreHelper.CreateDictionaryStore(this.Form, storeName);
            myStore.RefreshData += Store_RefreshProvinces;

            if (comboBox != null)
                comboBox.StoreID = storeName;

            ITerritorys bll = new Territorys();
            IList<Territory> dataSet = bll.GetProvinces();

            myStore.DataSource = dataSet;
            myStore.DataBind();

            return myStore;
        }

        /// <summary>
        /// 地区
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected internal virtual void Store_RefreshTerritorys(object sender, StoreRefreshDataEventArgs e)
        {


            string parentId = e.Parameters["parentId"];

            if (!string.IsNullOrEmpty(parentId))
            {
                ITerritorys bll = new Territorys();

                IList<Territory> cities = bll.GetTerritorysByParent(new Guid(parentId));

                if (sender is Store)
                {
                    Store store1 = (sender as Store);
                    store1.DataSource = cities;
                    store1.DataBind();
                }
            }
        }

        protected internal virtual Store CreateCitiesStore(Coolite.Ext.Web.ComboBox comboBox)
        {
            string storeName = "CitiesStore";

            Store myStore = ComboBoxStoreHelper.CreateTerritoryStore(this.Form, storeName);
            myStore.RefreshData += Store_RefreshTerritorys;

            if (comboBox != null)
                comboBox.StoreID = storeName;

            return myStore;
        }

        protected internal virtual Store CreateDistrictsStore(Coolite.Ext.Web.ComboBox comboBox)
        {
            string storeName = "DistrictsStore";

            Store myStore = ComboBoxStoreHelper.CreateTerritoryStore(this.Form, storeName);
            myStore.RefreshData += Store_RefreshTerritorys;

            if (comboBox != null)
                comboBox.StoreID = storeName;
            return myStore;
        }

        #endregion

        #region 经销商绑定
        /// <summary>
        /// Bind Dealer
        /// </summary>
        /// <param name="store"></param>
        public virtual void Bind_DealerList(Store store)
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = serviceBase.GetCurrentProductLines();
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
                //dataSource = query.ToList<DealerMaster>();
            }

            store.DataSource = dataSource;
            store.DataBind();
        }

        public virtual void Bind_DealerListByFilter(Store store, bool showParent)
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是波科用户，则根据授权信息获得经销商列表
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = serviceBase.GetCurrentProductLines();
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
                //dataSource = query.ToList<DealerMaster>();
            }
            else
            {
                //如果是经销商用户
                if (showParent)
                {
                    //显示自己及下级经销商
                    dataSource = (from t in dataSource where t.Id.Value == context.User.CorpId.Value || (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
                else
                {
                    //显示下级经销商
                    dataSource = (from t in dataSource where (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
            }

            store.DataSource = dataSource;
            store.DataBind();
        }
        /// <summary>
        /// the StoreRefershData method for Dealer form cache
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Coolite.Ext.Web.StoreRefreshDataEventArgs"/> instance containing the event data.</param>
        public virtual void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            Bind_DealerList((Store)sender);
        }

        /// <summary>
        /// 根据条件过滤经销商
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public virtual void Store_DealerListByFilter(object sender, StoreRefreshDataEventArgs e)
        {
            //获取传递参数
            bool showParent = true;

            if (e.Parameters["ShowParent"] != null && !string.IsNullOrEmpty(e.Parameters["ShowParent"].ToString()))
            {
                showParent = bool.Parse(e.Parameters["ShowParent"].ToString());
            }
            Bind_DealerListByFilter((Store)sender, showParent);

        }

        public virtual void Bind_AllDealerList(Store store, bool showParent)
        {
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是波科用户，则根据授权信息获得经销商列表
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                dataSource = dataSource.OrderBy(d => d.ChineseName).ToList<DealerMaster>();
            }
            else
            {
                //如果是经销商用户
                if (showParent)
                {
                    //显示自己及下级经销商
                    dataSource = (from t in dataSource where t.Id.Value == context.User.CorpId.Value || (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
                else
                {
                    //显示下级经销商
                    dataSource = (from t in dataSource where (t.ParentDmaId.HasValue && t.ParentDmaId.Value == context.User.CorpId.Value) select t).ToList<DealerMaster>();
                }
            }

            store.DataSource = dataSource;
            store.DataBind();
        }
        #endregion

        #region 产品线绑定

        /// <summary>
        /// Gets the product line store data source.
        /// </summary>
        /// <returns></returns>
        private object GetProductLineStoreDataSource()
        {
            object datasource = null;


            IRoleModelContext context = RoleModelContext.Current;

            //普通用户登陆，从组织结构缓存中获取ProductLine
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                datasource = serviceBase.GetCurrentProductLines();
            }
            else
            {
                //经销商登陆 , 利用缓存中已有的信息，排除与登陆经销商不相关的
                if (context.User.CorpId.HasValue)
                {
                    IDealerContracts dealers = new DealerContracts();

                    DealerAuthorization param = new DealerAuthorization();

                    DealerAuthorization da = new DealerAuthorization();
                    da.DmaId = context.User.CorpId.Value;

                    IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(da);

                    IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                    var lines = from p in dataSet
                                where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                                select p;


                    datasource = lines.ToList<Lafite.RoleModel.Domain.AttributeDomain>();

                }

            }
            return datasource;
        }

        private object GetProductLineStoreDataSource_PO()
        {
            object datasource = null;


            IRoleModelContext context = RoleModelContext.Current;

            //普通用户登陆，从组织结构缓存中获取ProductLine
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                datasource = serviceBase.GetCurrentProductLines();
            }
            else
            {
                //经销商登陆 , 利用缓存中已有的信息，排除与登陆经销商不相关的
                if (context.User.CorpId.HasValue)
                {
                    datasource = (new POReceipt()).GetPoReceiptProductLine(context.User.CorpId.Value);
                }

            }
            return datasource;
        }

        private object GetProductLineStoreDataSource_PT()
        {
            object datasource = null;


            IRoleModelContext context = RoleModelContext.Current;

            //BSC用户PT部门登录，显示所有产品线
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                datasource = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);
            }
            else
            {
                //经销商登陆 , 利用缓存中已有的信息，排除与登陆经销商不相关的
                if (context.User.CorpId.HasValue)
                {
                    IDealerContracts dealers = new DealerContracts();

                    DealerAuthorization param = new DealerAuthorization();

                    DealerAuthorization da = new DealerAuthorization();
                    da.DmaId = context.User.CorpId.Value;

                    IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(da);

                    IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                    var lines = from p in dataSet
                                where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                                select p;


                    datasource = lines.ToList<Lafite.RoleModel.Domain.AttributeDomain>();

                }

            }
            return datasource;
        }

        private object GetLimitProductLineStoreDataSource()
        {
            object datasource = null;


            IRoleModelContext context = RoleModelContext.Current;

            //普通用户登陆，从组织结构缓存中获取ProductLine
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                datasource = serviceBase.GetCurrentProductLines();
            }
            else
            {
                //经销商登陆 , 利用缓存中已有的信息，排除与登陆经销商不相关的
                if (context.User.CorpId.HasValue)
                {
                    IDealerContracts dealers = new DealerContracts();

                    DealerAuthorization param = new DealerAuthorization();

                    DealerAuthorization da = new DealerAuthorization();
                    da.DmaId = context.User.CorpId.Value;

                    IList<DealerAuthorization> auths = dealers.GetLimitAuthorizationListByDealer(da);

                    IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                    var lines = from p in dataSet
                                where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                                select p;


                    datasource = lines.ToList<Lafite.RoleModel.Domain.AttributeDomain>();

                }

            }
            return datasource;
        }

        public virtual void Bind_ProductLine(Store store)
        {
            object datasource = GetProductLineStoreDataSource();
            store.DataSource = datasource;
            store.DataBind();
        }

        public virtual void Bind_ProductLine_PO(Store store)
        {
            object datasource = GetProductLineStoreDataSource_PO();
            store.DataSource = datasource;
            store.DataBind();
        }

        public virtual void Bind_ProductLine_PT(Store store)
        {
            object datasource = GetProductLineStoreDataSource_PT();
            store.DataSource = datasource;
            store.DataBind();
        }

        public virtual void Bind_LimitProductLine(Store store)
        {
            object datasource = GetLimitProductLineStoreDataSource();
            store.DataSource = datasource;
            store.DataBind();
        }
        /// <summary>
        /// 产品线
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Coolite.Ext.Web.StoreRefreshDataEventArgs"/> instance containing the event data.</param>
        public virtual void Store_RefreshProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            Bind_ProductLine((Store)sender);
        }

        public virtual void Store_RefreshProductLine_PO(object sender, StoreRefreshDataEventArgs e)
        {
            Bind_ProductLine_PO((Store)sender);
        }

        /// <summary>
        /// PT部门专用的产品线控件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public virtual void Store_RefreshProductLine_PT(object sender, StoreRefreshDataEventArgs e)
        {
            Bind_ProductLine_PT((Store)sender);
        }
        /// <summary>
        /// Creates the product lines store.
        /// </summary>
        /// <param name="container">The container.</param>
        /// <param name="comboBox">The combo box.</param>
        /// <returns></returns>
        public virtual Store CreateProductLinesStore(Control container, Coolite.Ext.Web.ComboBox comboBox)
        {
            string storeName = "ProductLinesStore";

            Store myStore = ComboBoxStoreHelper.CreateAttributeStore(container, storeName);
            myStore.RefreshData += Store_RefreshProductLine;

            if (comboBox != null)
                comboBox.StoreID = myStore.ClientID;

            object datasource = GetProductLineStoreDataSource();
            myStore.DataSource = datasource;
            myStore.DataBind();

            return myStore;
        }

        #endregion

        #region 报表属性绑定
        /// <summary>
        /// 财年
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Coolite.Ext.Web.StoreRefreshDataEventArgs"/> instance containing the event data.</param>
        public virtual void Store_RefreshFY(object sender, StoreRefreshDataEventArgs e)
        {

            //所有财年
            COPs b = new COPs();
            DataSet ds = b.SelectCOP_FY();

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }

        /// <summary>
        /// 财季
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Coolite.Ext.Web.StoreRefreshDataEventArgs"/> instance containing the event data.</param>
        public virtual void Store_RefreshFQ(object sender, StoreRefreshDataEventArgs e)
        {

            //所有财年
            COPs b = new COPs();
            DataSet ds = b.SelectCOP_FQ();

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }

        /// <summary>
        /// 财月
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="Coolite.Ext.Web.StoreRefreshDataEventArgs"/> instance containing the event data.</param>
        public virtual void Store_RefreshFM(object sender, StoreRefreshDataEventArgs e)
        {

            //所有财月
            COPs b = new COPs();
            DataSet ds = b.SelectCOP_FM();

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                store1.DataSource = ds;
                store1.DataBind();
            }
        }
        #endregion

        #region 报表页面方法
        public void initReportView(ReportViewer reportView)
        {


            ServerReport serverReport = reportView.ServerReport;

            //设置宽度和高度
            string width = CommonVariable.ReportViewWidth;
            if (!string.IsNullOrEmpty(width))
            {
                reportView.Width = new System.Web.UI.WebControls.Unit(width);
            }

            string height = CommonVariable.ReportViewHeight;
            if (!string.IsNullOrEmpty(height))
            {
                reportView.Height = new System.Web.UI.WebControls.Unit(height);
            }


            //不显示报表自带的查询条件
            reportView.ShowParameterPrompts = false;
        }
        #endregion

        #region 经销商仓库绑定

        public virtual void Bind_WarehouseByDealer(Store store, Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            if (context.User.IdentityType == IdentityType.Dealer.ToString())
            {

                if (dealerWarehouseType.Equals("Normal"))
                {
                    list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
                }
                else if (dealerWarehouseType.Equals("Consignment"))
                {
                    switch ((DealerType)Enum.Parse(typeof(DealerType), context.User.CorpType, true))
                    {
                        case DealerType.HQ:
                            //总部，波科公司，显示波科寄售库
                            list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LP:
                            //平台，显示平台寄售库
                            list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LS:
                            //配送商，保持与平台相同逻辑
                            list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T2:
                            //T2，显示寄售库
                            list = (from t in list where t.Type == WarehouseType.Consignment.ToString() || t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                            break;
                        default: break;
                    }
                }
                else if (dealerWarehouseType.Equals("Borrow"))
                {
                    switch ((DealerType)Enum.Parse(typeof(DealerType), context.User.CorpType, true))
                    {
                        case DealerType.HQ:
                            //总部，波科公司，显示波科借货库
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LP:
                            //平台，显示平台借货库
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.LS:
                            //配送商，保持与平台相同逻辑
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        case DealerType.T1:
                            //平台，显示平台借货库
                            list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                            break;
                        default: break;
                    }
                }
            }

            store.DataSource = list;
            store.DataBind();
        }


        public virtual void Bind_WarehouseByDealerAndType(Store store, Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //配送商，使用Borrow类型
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //配送商，保持与平台相同逻辑
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }

            else if (dealerWarehouseType.Equals("Noanddefault"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString()  select t).ToList<Warehouse>();
            }
            //限定只能是医院库
            else if (dealerWarehouseType.Equals("HospitalOnly"))
            {
                list = (from t in list where t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
            }


            //Added By Song Yuqi On 2015-11-27 End

            store.DataSource = list;
            store.DataBind();
        }

        public virtual void Bind_TransferWarehouseByDealerAndType(Store store, Guid dealerId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);


            if (dealerWarehouseType.Equals("Normal"))
            {
                list = (from t in list where t.Type == WarehouseType.DefaultWH.ToString() || t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            //Added By Song Yuqi On 2015-11-27 End
           
            store.DataSource = list;
            store.DataBind();
        }

        public virtual void Bind_WarehouseByDealerAndTypeWithoutDWH(Store store, Guid dealerId, Guid productlineId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);

            Hashtable ht = new Hashtable();
            ht.Add("ProductLineId", productlineId);
            ht.Add("DealerId", dealerId);
            DataTable dt = business.GetNoLimitWarehouse(ht).Tables[0];

            if (dealerWarehouseType.Equals("Normal"))
            {
                if(dt.Rows.Count > 0 && dt != null)
                {
                    if(dt.Rows[0]["cnt"].ToString() == "0")
                    {
                        //没有经销商或BU的限制，则允许显示主仓库
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() | t.Type == WarehouseType.DefaultWH.ToString() | t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
                    }
                    else
                    {
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() | t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
                    }
                }
               
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }

            else if (dealerWarehouseType.Equals("Frozen"))
            {
                
                list = (from t in list where t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            //Added By Song Yuqi On 2015-11-27 End

            store.DataSource = list;
            store.DataBind();
        }

        public virtual void Bind_NormalWarehousType(Store store, Guid dealerId, Guid productlineId, string dealerWarehouseType)
        {
            IRoleModelContext context = RoleModelContext.Current;
            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<Warehouse> list = business.GetWarehouseByDealer(dealerId);

            if (list == null)
                list = new List<Warehouse>();

            //获得经销商信息
            DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);
            

            if (dealerWarehouseType.Equals("Normal"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                   
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() || t.Type == WarehouseType.DefaultWH.ToString() select t).ToList<Warehouse>();
                        break;                    
                    default:
                        list = (from t in list where t.Type == WarehouseType.Normal.ToString() select t).ToList<Warehouse>();
                        break;
                }


                                 
            }
            else if (dealerWarehouseType.Equals("Consignment"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() | t.Type == WarehouseType.Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科借货库
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list where t.Type == WarehouseType.Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示平台借货库
                        list = (from t in list where t.Type == WarehouseType.LP_Borrow.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }
            else if (dealerWarehouseType.Equals("Complain"))
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.Empty;
                wh.Name = "销售到医院";

                list.Add(wh);
            }
            //Added By Song Yuqi On 2015-11-27 Begin For 短期寄售
            //寄售类型订单的仓库可加载出【Consignment】、【Borrow】类型的仓库
            else if (dealerWarehouseType.Equals("Consignment,Borrow"))
            {
                switch ((DealerType)Enum.Parse(typeof(DealerType), dealer.DealerType, true))
                {
                    case DealerType.LP:
                        //平台，显示波科寄售库
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.LS:
                        //与平台相同
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T1:
                        list = (from t in list
                                where t.Type == WarehouseType.Consignment.ToString()
                                     | t.Type == WarehouseType.Borrow.ToString()
                                select t).ToList<Warehouse>();
                        break;
                    case DealerType.T2:
                        //二级经销商，显示波科寄售库
                        list = (from t in list where t.Type == WarehouseType.LP_Consignment.ToString() select t).ToList<Warehouse>();
                        break;
                    default: break;
                }
            }

            else if (dealerWarehouseType.Equals("Frozen"))
            {

                list = (from t in list where t.Type == WarehouseType.Frozen.ToString() select t).ToList<Warehouse>();
            }
            //Added By Song Yuqi On 2015-11-27 End

            store.DataSource = list;
            store.DataBind();
        }
        public virtual void Bind_SAPWarehouseAddress(Store store, Guid dealerId)
        {
            IRoleModelContext context = RoleModelContext.Current;

            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<SapWarehouseAddress> list = business.QueryForWarehouse(dealerId);

            if (list == null)
                list = new List<SapWarehouseAddress>();

            store.DataSource = list;
            store.DataBind();
        }
        #endregion

        #region 页面公用方法
        /// <summary>
        /// Guid
        /// </summary>
        /// <returns></returns>
        public virtual Guid GetGuid()
        {
            return DMS.Common.DMSUtility.GetGuid();
        }

        /// <summary>
        /// Guid
        /// </summary>
        /// <returns></returns>
        public virtual string NewGuid()
        {
            return DMS.Common.DMSUtility.NewGuid();
        }

        public int iMaxCriteria = 10;
        public string[] oneRecord(string line)
        {
            //string[] aRec = new string[iMaxCriteria];
            //int iFieldCount = 0;

            //StringBuilder oneField = new StringBuilder();

            //for (int i = 0; i < line.Length; i++)
            //{
            //    if (nextField(line[i]))
            //    {
            //        aRec[iFieldCount] = (oneField.ToString());
            //        iFieldCount++;
            //        if (iFieldCount > iMaxCriteria)
            //        {
            //            line = line + string.Format("--最多只能处理{0}个模糊查找，后面的查找条件会省略。", iMaxCriteria);
            //            break;
            //        }
            //        oneField = new StringBuilder();
            //    }
            //    else
            //    {
            //        if (!omitchar(line[i])) oneField.Append(line[i]);
            //    }
            //}
            //if (oneField.Length != 0)
            //{
            //    aRec[iFieldCount] = (oneField.ToString());
            //}

            //return aRec;
            //if (line.LastIndexOf(',') == line.Length - 1)
            //{
            //    line = line.Substring(0, line.Length - 1);
            //}
            string[] aLine = line.Split(',');
            string[] aRec = new string[iMaxCriteria];
            int i = 0;
            int count = (aLine.Length > iMaxCriteria) ? iMaxCriteria : aLine.Length;
            while (i < count)
            {
                aRec[i] = aLine[i];
                i++;
            }
            return aRec;
        }

        private bool omitchar(char c)
        {
            switch (c)
            {
                case '"':
                    return true;
                default:
                    return false;
            }
        }

        private bool nextField(char c)
        {
            return (c == ',');
        }

        public string GetStringByInt(int? number)
        {
            return number.HasValue ? number.Value.ToString() : "0";
        }

        public string GetStringByDecimal(decimal? amount)
        {
            decimal value = amount.HasValue ? amount.Value : 0;
            return string.Format("{0:N}", value);
        }

        public string GetStringByDecimalToUSD(decimal? amount)
        {
            decimal value = amount.HasValue ? amount.Value : 0;
            return string.Format("{0:N}", value / Convert.ToDecimal(6.15));
        }

        public string GetStringByDecimal(object amount)
        {
            if (amount != null)
            {
                return string.Format("{0:N}", Convert.ToDecimal(amount));
            }
            else
            {
                return string.Format("{0:N}", Convert.ToDecimal("0"));
            }
        }

        /// <summary>
        /// format=null:default format yyyy-MM-dd
        /// </summary>
        /// <param name="dateTime"></param>
        /// <param name="format"></param>
        /// <returns></returns>
        public string GetStringByDate(DateTime? dateTime, string format)
        {
            if (string.IsNullOrEmpty(format))
                format = "yyyy-MM-dd";
            return dateTime.HasValue ? dateTime.Value.ToString(format) : string.Empty;

        }

        public string GetObjectDate(object value)
        {
            if (value != null)
            {
                return value.ToString();
            }
            else
            {
                return "";
            }
        }

        #endregion

        #region EKP审批日志
        [AjaxMethod]
        public string GetEkpHistoryPageUrl(string mainId)
        {
            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

            string url = ekpBll.GetEkpCommonPageUrlByInstanceId(mainId, RoleModelContext.Current.User.LoginId);
            return Page.ResolveUrl(url);
        }
        #endregion
    }

}

