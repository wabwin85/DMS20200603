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
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Home
{
    public partial class DealerHomePage : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;

        private IBulletinSearchBLL _BulletinBLL = null;
        private IIssuesListBLL _IssuesListBLL = null;
        private IDealerQABLL _DealerQABLL = null;
        private IAttachmentBLL _attachBll = null;
        private IDealerMasters _DealerMasters = null;
        private IShipmentBLL business = new ShipmentBLL();
        private IQueryInventoryBiz businessInventory = new QueryInventoryBiz();
        private IDealerContracts businessDealerContracts = new DealerContracts();

        [Dependency]
        public IBulletinSearchBLL BulletinBLL
        {
            get { return _BulletinBLL; }
            set { _BulletinBLL = value; }
        }
        [Dependency]
        public IIssuesListBLL IssuesListBLL
        {
            get { return _IssuesListBLL; }
            set { _IssuesListBLL = value; }
        }
        [Dependency]
        public IDealerQABLL DealerQABLL
        {
            get { return _DealerQABLL; }
            set { _DealerQABLL = value; }
        }
        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }

        [Dependency]
        public IDealerMasters DealerMasters
        {
            get { return _DealerMasters; }
            set { _DealerMasters = value; }
        }
        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (!IsDealer)
                {
                    throw new Exception(GetLocalResourceObject("Page_Load.Exception").ToString());
                }
                BuildTree(TreePanel1.Root);
                ShowMassage();
                ShowShipmentMassage();
                ShowNearEffectInventoryMassage();
            }
        }

        public void BulletinStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            table.Add("Status", BulletinStatus.Published.ToString());
            table.Add("ExpirationDate", DateTime.Now.ToString("yyyyMMdd"));
            table.Add("DealerId", _context.User.CorpId.Value);

            DataSet data = BulletinBLL.QueryTopTenBulletinMainOnLogin(table);
            e.TotalCount = totalCount;

            BulletinStore.DataSource = data;
            BulletinStore.DataBind();
        }

        public void IssueListStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            table.Add("DeleteFlag", "0");

            DataSet data = IssuesListBLL.QueryTopTenIssuesListOnLogin(table);
            e.TotalCount = totalCount;

            IssueListStore.DataSource = data;
            IssueListStore.DataBind();
        }

        //public void DealerQAListStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    int totalCount = 0;
        //    Hashtable table = new Hashtable();

        //    if (IsDealer)
        //    {
        //        //被授权的经销商用户都可以查看到该经销商旗下的所有状态的回答（包括草稿以及修改草稿）
        //        table.Add("DealerId", _context.User.CorpId.Value.ToString());
        //        table.Add("Category", ((int)DealerQACategory.QA).ToString());


        //        DataSet data = DealerQABLL.QueryDealerQAOnLoginForDealer(table);
        //        e.TotalCount = totalCount;

        //        DealerQAListStore.DataSource = data;
        //        DealerQAListStore.DataBind();
        //    }
        //}

        //protected void DealerqaStatusStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        //{
        //    IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(e.Parameters["Type"].ToString());

        //    dicts.Remove("Draft");

        //    if (IsDealer)
        //    {
        //        dicts.Add("Draft", "草稿");
        //    }

        //    DealerQAStatusStore.DataSource = dicts;
        //    DealerQAStatusStore.DataBind();
        //}

        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            //Gets all dealers
            IList<DealerMaster> dataSource = DMS.Business.Cache.DealerCacheHelper.GetDealers();
            var query = from p in dataSource
                        where p.HostCompanyFlag != true
                        select p;

            dataSource = query.ToList<DealerMaster>();
            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(new Guid(this.hfBulletinMainId.Text), AttachmentType.Bulletin, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }

        protected void IssueAttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            DataSet ds = attachBll.GetAttachmentByMainId(new Guid(this.hfIssueListId.Text), AttachmentType.Issues, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.ptbIssueAttachment.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            IssueAttachmentStore.DataSource = ds;
            IssueAttachmentStore.DataBind();
        }


        #region AjaxMethod
        [AjaxMethod]
        public void BulletinDetailShow(string id)
        {
            BulletinClearValue();
            BulletinSetValue(id);
            //阅读更新,只记录第一次阅读的状态
            if (!this.BulletinIsRead.Checked)
            {
                try
                {
                    BulletinUpdateRead(id);
                    GridPanelBulletin.Reload();
                }
                catch (Exception e)
                {
                    Ext.Msg.Alert(GetLocalResourceObject("BulletinDetailShow.Alert.Title").ToString(), e.ToString()).Show();
                }
            }
        }

        [AjaxMethod]
        public void BulletinUpdateConfirm(string id)
        {
            //确认更新
            Hashtable table = new Hashtable();
            table.Add("BumId", id);
            table.Add("DealerDmaId", _context.User.CorpId.Value);
            table.Add("IsConfirm", "true");
            table.Add("ConfirmUser", _context.User.Id);
            table.Add("ConfirmDate", DateTime.Now.ToString());

            BulletinBLL.UpdateConfirm(table);
        }

        [AjaxMethod]
        public void IssueListShow(string id)
        {
            //this.ClearWindow();

            this.hfIssueListId.Text = id;
            this.hfIssueListSortNo.Text = "0";

            //修改
            if (id != Guid.Empty.ToString())
            {
                this.IssueListSetValue(id);
            }
            else //新增
            {
                this.nfIssueListSortNo.Text = (IssuesListBLL.getMaxSortNo() + 1).ToString();
                this.hfIssueListSortNo.Text = this.nfIssueListSortNo.Text;
            }

        }

        [AjaxMethod]
        public string RefreshTree()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = BuildTree(null);
            return nodes.ToJson();
        }

        //[AjaxMethod]
        //public void SaveDealerQAItem(string status)
        //{
        //    Hashtable table = new Hashtable();

        //    Dealerqa qa = new Dealerqa();

        //    if (IsDealer)
        //    {
        //        if (new Guid(this.hfDealerQAId.Text) == Guid.Empty)
        //            qa.Id = Guid.NewGuid();
        //        else
        //            qa.Id = new Guid(this.hfDealerQAId.Text);

        //        qa.QuestionDate = DateTime.Now;
        //        qa.QuestionUserId = new Guid(_context.User.Id);
        //        qa.DealerId = _context.User.CorpId.Value;
        //        qa.Type = this.cbTypeWin.SelectedItem.Value;
        //        qa.Status = status;
        //        qa.Title = this.tfTitleWin.Text;
        //        qa.Body = this.taBodyWin.Text;
        //        qa.Category = ((int)DealerQACategory.QA).ToString();

        //        DealerQABLL.InsertQuestionInfo(qa);
        //    }
        //}

        //[AjaxMethod]
        //public void DeleteDealerQAItem()
        //{
        //    bool reslut = DealerQABLL.DeleteItem(new Guid(this.hfDealerQAId.Text));
        //}

        //[AjaxMethod]
        //public void DealerQAShow(string id)
        //{
        //    ClearDealerQAValue();
        //    SetDealerQAStatus();

        //    this.hfDealerQAId.Text = id;

        //    if (new Guid(id) == Guid.Empty)
        //    {
        //        this.cbTypeWin.Disabled = false;
        //        this.tfTitleWin.ReadOnly = false;
        //        this.taBodyWin.ReadOnly = false;

        //        this.btnDelete.Hide();
        //        this.tfStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerQA_Status, DealerQAStatus.Draft.ToString());
        //    }
        //    else
        //    {
        //        SetValue(id);
        //    }

        //}
        #endregion

        #region 页面私有方法
        private void BulletinClearValue()
        {
            this.BulletinUrgentDegree.SelectedItem.Value = "";
            this.BulletinPublishedUser.Clear();
            this.BulletinPublishedDate.Clear();
            this.BulletinTitle.Clear();
            this.BulletinBody.Clear();

            this.BulletinIsRead.Checked = false;
            this.BulletinIsConfirm.Checked = false;
            this.BulletinReadFlag.Checked = false;

            this.hfBulletinMainId.Clear();

            this.btnBulletinConfirm.Hide();

            this.TabPanel1.ActiveTabIndex = 0;
            this.TabPanel2.ActiveTabIndex = 0;
        }

        private void BulletinSetValue(string MainId)
        {
            this.hfBulletinMainId.Text = MainId;

            Hashtable table = new Hashtable();
            table.Add("BumId", MainId);
            table.Add("DealerDmaId", _context.User.CorpId.Value.ToString());

            DataSet ds = BulletinBLL.GetBulletinMainById(table);

            this.BulletinUrgentDegree.SelectedItem.Value = ds.Tables[0].Rows[0][3].ToString();
            this.BulletinReadFlag.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][4].ToString());
            this.BulletinPublishedUser.Text = ds.Tables[0].Rows[0][8].ToString();
            this.BulletinPublishedDate.SelectedDate = Convert.ToDateTime(ds.Tables[0].Rows[0][9].ToString());
            this.BulletinTitle.Text = ds.Tables[0].Rows[0][1].ToString();
            this.BulletinBody.Text = ds.Tables[0].Rows[0][2].ToString();

            this.BulletinIsRead.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][10].ToString());
            this.BulletinIsConfirm.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][11].ToString());


            //如果是必须确认的，显示按钮
            if (this.BulletinReadFlag.Checked)
            {
                //如果还没有确认的才显示按钮
                if (!this.BulletinIsConfirm.Checked)
                {
                    this.btnBulletinConfirm.Show();
                }
            }
        }
        private void BulletinUpdateRead(string MainId)
        {
            Hashtable table = new Hashtable();
            table.Add("BumId", MainId);
            table.Add("DealerDmaId", _context.User.CorpId.Value);
            table.Add("IsRead", "true");
            table.Add("ReadUser", _context.User.Id);
            table.Add("ReadDate", DateTime.Now.ToString());
            BulletinBLL.UpdateRead(table);
        }
        private void IssueListClearWindow()
        {
            this.hfIssueListId.Clear();
            this.hfIssueListSortNo.Clear();

            this.taIssueListQuestion.Clear();
            this.taIssueListAnswer.Clear();
            this.nfIssueListSortNo.Clear();
        }
        private void IssueListSetValue(string id)
        {
            DMS.Model.IssuesList issues = IssuesListBLL.GetObject(new Guid(id));

            this.nfIssueListSortNo.Text = issues.SortNo.ToString();
            this.hfIssueListSortNo.Text = this.nfIssueListSortNo.Text;

            this.taIssueListAnswer.Text = issues.Answer;
            this.taIssueListQuestion.Text = issues.Question;

            this.hfIssueListId.Text = id;

        }
        private int GetPOReceiptCount()
        {
            IPOReceipt business = new DMS.Business.POReceipt();
            return business.GetPoReceiptCountByDealer(RoleModelContext.Current.User.CorpId.Value);
        }

        private int GetIssuesListCount()
        {
            Hashtable param = new Hashtable();
            IDealerQABLL business = new DMS.Business.DealerQABLL();
            param.Add("DealerId", RoleModelContext.Current.User.CorpId.Value);
            param.Add("Status", DealerQAStatus.Submitted.ToString());
            return business.GetConutByStatus(param);
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildTree(Coolite.Ext.Web.TreeNodeCollection nodes)
        {
            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            IList<WaitProcessTask> list = this.GetAllTaskData();

            WaitProcessTask POReceiptHeader = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.POReceiptHeader.ToString()).First();
            //WaitProcessTask DealerComplaint = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.DealerComplaint.ToString()).First();
            WaitProcessTask DealerQA = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.DealerQA.ToString()).First();
            WaitProcessTask UploadInventory = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadInventory.ToString()).First();
            WaitProcessTask UploadLog = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadLog.ToString()).First();
            WaitProcessTask ShipmentHeader = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentHeader.ToString()).First();
            WaitProcessTask OrderQT = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.OrderQT.ToString()).First();
            WaitProcessTask ShipmentQT = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentQT.ToString()).First();
            WaitProcessTask ShipmentReversedQT = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentReversedQT.ToString()).First();
            WaitProcessTask ShipmentICQT = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentICQT.ToString()).First();
            WaitProcessTask TransferQT = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.TransferQT.ToString()).First();
            WaitProcessTask InventoryAdjustQT = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.InventoryAdjustQT.ToString()).First();

            WaitProcessTask NormalInventory = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.NormalInventory.ToString()).First();
            WaitProcessTask ConsignmentInventory = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ConsignmentInventory.ToString()).First();
            WaitProcessTask BorrowInventory = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.BorrowInventory.ToString()).First();
            WaitProcessTask SystemHoldInventory = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.SystemHoldInventory.ToString()).First();
            WaitProcessTask HasOrderStrategy = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.HasOrderStrategy.ToString()).First();
            WaitProcessTask UploadSalesForecast = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadSalesForecast.ToString()).First();

            WaitProcessTask UploadInvoice = list.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadInvoice.ToString()).First();

            Coolite.Ext.Web.TreeNode root = new Coolite.Ext.Web.TreeNode();
            root.Text = "Root";
            nodes.Add(root);

            //待收货
            Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format(GetLocalResourceObject("PendingReceive").ToString()
                + " (<b><font color='red'>{0}</font></b>)", POReceiptHeader.RecordCount);
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/POReceipt/POReceiptList.aspx','subMenu107','" + GetLocalResourceObject("POReceiptList.TabName").ToString() + "');";
            root.Nodes.Add(node);

            //投诉回复
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format(GetLocalResourceObject("AnswerQuestion").ToString()
                + " (<b><font color='red'>{0}</font></b>)", DealerQA.RecordCount);
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/DCM/DealerQAList.aspx','subMenu302','经销商问答');";
            root.Nodes.Add(node);

            if (UploadInventory.RecordCount == "0")
            {
                //需要上传库存数据
                node = new Coolite.Ext.Web.TreeNode();
                node.Text = string.Format(" <b><font color='red'>{0}</font></b>", "需要上传库存数据");
                node.Icon = Icon.PackageIn;
                node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/InventoryImport.aspx','subMenu301','库存数据批量上传');";
                root.Nodes.Add(node);
            }

            if (UploadLog.RecordCount == "0" && ShipmentHeader.RecordCount == "0")
            {
                //需要填写销售数据
                node = new Coolite.Ext.Web.TreeNode();
                node.Text = string.Format(" <b><font color='red'>{0}</font></b>", "需要填写销售数据");
                node.Icon = Icon.PackageIn;
                node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Shipment/ShipmentList.aspx','subMenu75','销售出库单');";
                root.Nodes.Add(node);
            }

            //先判断登录人员是否具有订单管理菜单的权限
            if (Convert.ToInt16(HasOrderStrategy.ItemQty) > 0)
            {
                //本月已采购数量（订单：数量、金额）
                node = new Coolite.Ext.Web.TreeNode();
                node.Text = string.Format("本月已采购总数量:{0};总金额:{1}", Convert.ToDouble(OrderQT.ItemQty), Convert.ToDouble(OrderQT.TotalAmount));
                node.Icon = Icon.PackageIn;
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString())
                            || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Order/OrderApplyLP.aspx','subMenu294','平台及一级经销商订单申请');";
                    }
                    else
                    {
                        node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Order/OrderApply.aspx','subMenu206','二级经销商订单申请');";
                    }
                }
            }
            root.Nodes.Add(node);

            //本月累计销售（销售单：数量、金额）
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("本月累计销售总数量:{0};总金额:{1}", Convert.ToDouble(ShipmentQT.ItemQty), Convert.ToDouble(ShipmentQT.TotalAmount));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Shipment/ShipmentList.aspx','subMenu75','销售出库单');";
            root.Nodes.Add(node);

            //本月累计冲红（冲红销售单：数量、金额）
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("本月累计冲红总数量:{0};总金额:{1}", Convert.ToDouble(ShipmentReversedQT.ItemQty), Convert.ToDouble(ShipmentReversedQT.TotalAmount));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Shipment/ShipmentList.aspx','subMenu75','销售出库单');";
            root.Nodes.Add(node);

            //本月累计IC产品线发票金额（有发票销售单：金额）
            //node = new Coolite.Ext.Web.TreeNode();
            //node.Text = string.Format("本月累计IC产品线发票总金额:{0}", Convert.ToDouble(ShipmentICQT.TotalAmount));
            //node.Icon = Icon.PackageIn;
            //node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Shipment/ShipmentList.aspx','subMenu75','销售出库单');";
            //root.Nodes.Add(node);

            //本月累计借货出库（借货出库单：数量）
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("本月累计借货出库总数量:{0}", Convert.ToDouble(TransferQT.ItemQty));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Transfer/TransferList.aspx','subMenu81','借货出库');";
            root.Nodes.Add(node);

            //本月累计退货（审批通过的退货单：数量）
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("本月累计退货总数量:{0}", Convert.ToDouble(InventoryAdjustQT.ItemQty));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/InventoryReturn.aspx','subMenu296','退货申请');";
            root.Nodes.Add(node);

            //当前经销商普通库库存数（包括缺省仓库）
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("当前经销商普通库库存数(包括缺省仓库):{0}", Convert.ToDouble(NormalInventory.ItemQty));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/QueryInventoryPage.aspx','subMenu79','库存查询');";
            root.Nodes.Add(node);

            //当前经销商寄售库库存数
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("当前经销商寄售库库存数:{0}", Convert.ToDouble(ConsignmentInventory.ItemQty));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/QueryInventoryPage.aspx','subMenu79','库存查询');";
            root.Nodes.Add(node);


            //当前经销商借货库库存数
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("当前经销商借货库库存数:{0}", Convert.ToDouble(BorrowInventory.ItemQty));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/QueryInventoryPage.aspx','subMenu79','库存查询');";
            root.Nodes.Add(node);

            //当前经销商在途库库存数
            node = new Coolite.Ext.Web.TreeNode();
            node.Text = string.Format("当前经销商在途库库存数:{0}", Convert.ToDouble(SystemHoldInventory.ItemQty));
            node.Icon = Icon.PackageIn;
            node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/QueryInventoryPage.aspx','subMenu79','库存查询');";
            root.Nodes.Add(node);


            if (UploadSalesForecast.RecordCount != "0")
            {
                //需要填写销售预测数据
                node = new Coolite.Ext.Web.TreeNode();
                node.Text = string.Format(" <b><font color='red'>{0}</font></b>", "需要填写经销商采购预测数据");
                node.Icon = Icon.PackageIn;
                node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Order/PurchasingForecastReport.aspx','subMenu378','经销商采购预测');";
                root.Nodes.Add(node);
            }
            //超过九十天未上传发票的销量
            if (UploadInvoice.RecordCount != "0")
            {
                node = new Coolite.Ext.Web.TreeNode();
                node.Text = string.Format(" <b><font color='red'>{0}</font></b>", "您有超期未上传发票的销量单据");
                node.Icon = Icon.PackageIn;
                node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Shipment/ShipmentList.aspx','subMenu75','销售出库单');";
                root.Nodes.Add(node);

            }
            return nodes;
        }

        //private void ClearDealerQAValue()
        //{
        //    this.cbDealerWin.SelectedItem.Value = "";
        //    this.tfQuestionDateWin.Clear();
        //    this.cbTypeWin.SelectedItem.Value = "";
        //    this.tfStatusWin.Clear();
        //    this.tfTitleWin.Clear();
        //    this.taBodyWin.Clear();
        //    this.hfDealerQAId.Clear();
        //    this.taAnswerWin.Clear();
        //    this.tfQuestionDateWin.Clear();

        //    this.btnSubmit.Hide();
        //    this.btnSave.Hide();
        //    this.btnDelete.Hide();

        //    this.cbTypeWin.Disabled = true;
        //    this.tfTitleWin.ReadOnly = true;
        //    this.taBodyWin.ReadOnly = true;
        //}

        //private void SetDealerQAStatus()
        //{
        //    if (IsDealer)
        //    {
        //        this.cbDealerWin.Hide();
        //        this.tfQuestionDateWin.Hide();
        //        this.cbTypeWin.Disabled = true;
        //        this.taAnswerWin.ReadOnly = true;
        //        this.tfTitleWin.ReadOnly = true;
        //        this.taBodyWin.ReadOnly = true;

        //        this.AnswerPanel.Hide();
        //        this.btnSubmit.Show();
        //        this.btnSave.Show();
        //        this.btnDelete.Show();
        //    }
        //    else
        //    {
        //        this.cbTypeWin.Disabled = true;
        //        this.tfTitleWin.ReadOnly = true;
        //        this.taBodyWin.ReadOnly = true;
        //        this.taAnswerWin.ReadOnly = true;

        //        this.AnswerPanel.Show();
        //    }
        //}

        //private void SetValue(string id)
        //{
        //    Dealerqa qa = DealerQABLL.GetObject(new Guid(id));

        //    this.cbDealerWin.SelectedItem.Value = !string.IsNullOrEmpty(qa.DealerId.ToString()) ? qa.DealerId.ToString() : "";
        //    this.cbTypeWin.SelectedItem.Value = !string.IsNullOrEmpty(qa.Type) ? qa.Type : "";
        //    this.tfStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerQA_Status, qa.Status);
        //    this.tfTitleWin.Text = !string.IsNullOrEmpty(qa.Title) ? qa.Title : "";
        //    this.taBodyWin.Text = !string.IsNullOrEmpty(qa.Body) ? qa.Body : "";
        //    this.tfQuestionDateWin.Text = qa.QuestionDate.ToString("yyyy/MM/dd");

        //    //状态为草稿
        //    if (qa.Status == DealerQAStatus.Draft.ToString())
        //    {
        //        this.tfTitleWin.ReadOnly = false;
        //        this.taBodyWin.ReadOnly = false;

        //        this.cbTypeWin.Disabled = false;
        //        this.tfTitleWin.ReadOnly = false;
        //        this.taBodyWin.ReadOnly = false;
        //    }
        //    //状态为已提交
        //    else if (qa.Status == DealerQAStatus.Submitted.ToString())
        //    {
        //        this.taAnswerWin.ReadOnly = false;

        //        this.btnSubmit.Hide();
        //        this.btnSave.Hide();
        //        this.btnDelete.Hide();
        //    }
        //    //状态为以回复
        //    else if (qa.Status == DealerQAStatus.Replied.ToString())
        //    {
        //        this.btnSubmit.Hide();
        //        this.btnSave.Hide();
        //        this.btnDelete.Hide();

        //        this.AnswerPanel.Show();
        //        this.taAnswerWin.Text = !string.IsNullOrEmpty(qa.Answer) ? qa.Answer : "";
        //    }
        //}

        private IList<WaitProcessTask> GetAllTaskData()
        {
            Hashtable table = new Hashtable();
            table.Add("DealerId", _context.User.CorpId);
            table.Add("OwnerId", new Guid(this._context.User.Id));
            IList<WaitProcessTask> ds = DealerQABLL.QueryWaitForProcessByDealer(table);
            return ds;
        }
        #endregion

        #region 消息提示框
        private void ShowMassage() 
        {
            if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
            {
                Hashtable table = new Hashtable();
                table.Add("dealerId", _context.User.CorpId.Value);
                table.Add("insertDate", (DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString().PadLeft(2, '0')));
                if (DealerMasters.GetHomePageMessage(table))
                {
                    this.WindowRemind.Show();
                }
            }
        }
        private void ShowShipmentMassage()
        {
            if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
            {
                Hashtable table = new Hashtable();
                table.Add("dealerId", _context.User.CorpId.Value);
                DataTable dt = business.GetShipmentInitNoConfirm(table).Tables[0];
                if (dt.Rows.Count>0)
                {
                    DataRow dr = dt.Rows[0];
                    this.hidShiomentInitNo.Text = dr["InitNo"].ToString();
                    string massage = "";
                    massage += "销售单批量导入编号：" + dr["InitNo"].ToString() + " 已完成系统校验。";
                    if (dr["InitStatus"].ToString().Equals("Completed"))
                    {
                        massage += "请知晓!";
                    }
                    if (dr["InitStatus"].ToString().Equals("PartCompleted"))
                    {
                        massage += "上传数据中<font size='2' color='red'>包含部分错误数据</font> ，请及时调整，并重新上传（仅针对错误数据）。";
                    }
                    if (dr["InitStatus"].ToString().Equals("Error"))
                    {
                        massage += "上传数据中<font size='2' color='red'>包含错误数据</font> ，请及时调整，并重新上传。";
                    }
                    this.spanShipment1.InnerHtml = massage;
                    this.WindowRemindShipment.Show();
                }
            }
        }
        [AjaxMethod]
        public void SubmentShipmenInit()
        {
            int i = business.ConfirmShipmenInit(this.hidShiomentInitNo.Text);
        }

        private void ShowNearEffectInventoryMassage()
        {
            if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
            {
                //判断是否包含CRM 授权
                Hashtable obj = new Hashtable();
                obj.Add("ActiveFlag", "1");
                obj.Add("DealerId", _context.User.CorpId.Value);
                obj.Add("Division", "19");
                DataSet ds = businessDealerContracts.SelectByDealerDealerContractActiveFlag(obj);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.GridPanelNearEffectInventory.Reload();
                    this.WindowNearEffectInventory.Show();
                }
            }
        }
        protected void InventoryStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("DealerId", _context.User.CorpId.Value);
            table.Add("PageNum", (e.Start == -1 ? 0 : e.Start / this.PagingToolbar1.PageSize));
            table.Add("PageSize", this.PagingToolbar1.PageSize);
            DataSet ds = businessInventory.SelectNearEffectInventoryDataSet(table);

            DataTable dtCount = ds.Tables[0];
            DataTable dtValue = ds.Tables[1];

            (this.InventoryStore.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["TotalCount"].ToString());
            this.InventoryStore.DataSource = dtValue;
            this.InventoryStore.DataBind();
        }
        #endregion

    }
}
