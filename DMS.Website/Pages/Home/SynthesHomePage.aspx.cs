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
    public partial class SynthesHomePage : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;

        private IBulletinSearchBLL _BulletinBLL = null;
        private IIssuesListBLL _IssuesListBLL = null;
        private IDealerQABLL _DealerQABLL = null;
        private IAttachmentBLL _attachBll = null;

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
            set { _DealerQABLL  = value; }
        }
        [Dependency]
        public IAttachmentBLL attachBll
        {
            get { return _attachBll; }
            set { _attachBll = value; }
        }
        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    throw new Exception(GetLocalResourceObject("Page_Load.Exception").ToString());
                }
                BuildTree(TreePanel1.Root);
            }
        }

        public void BulletinStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            table.Add("Status", BulletinStatus.Published.ToString());
            table.Add("ExpirationDate", DateTime.Now.ToString("yyyyMMdd"));
            //table.Add("DealerId", _context.User.CorpId.Value);

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
            try
            {
                //BulletinUpdateRead(id);
                GridPanelBulletin.Reload();
            }
            catch (Exception e)
            {
                Ext.Msg.Alert(GetLocalResourceObject("BulletinDetailShow.Alert.Title").ToString(), e.ToString()).Show();
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

        #endregion

        #region 页面私有方法
        private void BulletinClearValue()
        {
            this.BulletinUrgentDegree.SelectedItem.Value = "";
            this.BulletinPublishedUser.Clear();
            this.BulletinPublishedDate.Clear();
            this.BulletinTitle.Clear();
            this.BulletinBody.Clear();

            //this.BulletinIsRead.Checked = false;
            //this.BulletinIsConfirm.Checked = false;
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
            //table.Add("DealerDmaId", _context.User.CorpId.Value.ToString());

            DataSet ds = BulletinBLL.GetBulletinMainUsedBySynthesHome(table);

            this.BulletinUrgentDegree.SelectedItem.Value = ds.Tables[0].Rows[0][3].ToString();
            this.BulletinReadFlag.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][4].ToString());
            this.BulletinPublishedUser.Text = ds.Tables[0].Rows[0][8].ToString();
            this.BulletinPublishedDate.SelectedDate = Convert.ToDateTime(ds.Tables[0].Rows[0][9].ToString());
            this.BulletinTitle.Text = ds.Tables[0].Rows[0][1].ToString();
            this.BulletinBody.Text = ds.Tables[0].Rows[0][2].ToString();

            //this.BulletinIsRead.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][10].ToString());
            //this.BulletinIsConfirm.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0][11].ToString());


            ////如果是必须确认的，显示按钮
            //if (this.BulletinReadFlag.Checked)
            //{
            //    //如果还没有确认的才显示按钮
            //    if (!this.BulletinIsConfirm.Checked)
            //    {
            //        this.btnBulletinConfirm.Show();
            //    }
            //}
        }
        //private void BulletinUpdateRead(string MainId)
        //{
        //    Hashtable table = new Hashtable();
        //    table.Add("BumId", MainId);
        //    table.Add("DealerDmaId", _context.User.CorpId.Value);
        //    table.Add("IsRead", "true");
        //    table.Add("ReadUser", _context.User.Id);
        //    table.Add("ReadDate", DateTime.Now.ToString());
        //    BulletinBLL.UpdateRead(table);
        //}
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
            node.Text = string.Format(GetLocalResourceObject("PendingAudit").ToString() + " (<b><font color='red'>{0}</font></b>)", GetPendingAuditCount().ToString());
            node.Icon = Icon.PackageIn;
            //node.Listeners.Click.Handler = "window.parent.loadExample('/Pages/Inventory/InventoryAdjustAudit.aspx','subMenu77','" + GetLocalResourceObject("InventoryAdjustAudit.TabName").ToString() + "');";
            node.Listeners.Click.Handler = "top.createTab({id: 'subMenu77',title: '导入',url: 'Pages/Inventory/InventoryAdjustAudit.aspx'});";
        

             root.Nodes.Add(node);


            return nodes;
        }

        //private void DealerQASetValue(string id)
        //{
        //    DMS.Model.Dealerqa dealerQa = DealerQABLL.GetObject(new Guid(id));

        //    this.cbDealerWin.SelectedItem.Value = !string.IsNullOrEmpty(dealerQa.DealerId.ToString()) ? dealerQa.DealerId.ToString() : "";
        //    this.cbTypeWin.SelectedItem.Value = !string.IsNullOrEmpty(dealerQa.Type) ? dealerQa.Type : "";
        //    this.tfStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerQA_Status, dealerQa.Status);
        //    this.tfTitleWin.Text = !string.IsNullOrEmpty(dealerQa.Title) ? dealerQa.Title : "";
        //    this.taBodyWin.Text = !string.IsNullOrEmpty(dealerQa.Body) ? dealerQa.Body : "";
        //    this.tfQuestionDateWin.Text = dealerQa.QuestionDate.ToString("yyyy/MM/dd");

        //     //状态为已提交
        //    if (dealerQa.Status == DealerQAStatus.Submitted.ToString())
        //    {
        //        this.cbTypeWin.Disabled = true;
        //        this.tfTitleWin.ReadOnly = true;
        //        this.taBodyWin.ReadOnly = true;
        //        this.taAnswerWin.ReadOnly = false;
        //        this.AnswerPanel.Show();
        //        this.taAnswerWin.Text = string.Empty;

        //        this.btnSubmit.Show();
        //    }
        //    //状态为以回复
        //    else if (dealerQa.Status == DealerQAStatus.Replied.ToString())
        //    {
        //        this.cbTypeWin.Disabled = true;
        //        this.tfTitleWin.ReadOnly = true;
        //        this.taBodyWin.ReadOnly = true;
        //        this.taAnswerWin.ReadOnly = true;
        //        this.AnswerPanel.Show();
                
        //        this.taAnswerWin.Text = !string.IsNullOrEmpty(dealerQa.Answer) ? dealerQa.Answer : "";
                
        //        this.btnSubmit.Hide();
        //    }
        //}
        #endregion



    }
}
