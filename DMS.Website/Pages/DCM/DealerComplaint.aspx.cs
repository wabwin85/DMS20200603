using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.DCM
{
    using DMS.Common;
    using DMS.Website.Common;
    using DMS.Model;
    using Coolite.Ext.Web;
    using System.Collections;
    using System.Data;
    using DMS.Model.Data;
    using Lafite.RoleModel.Security;
    using DMS.Business.Cache;
    using Microsoft.Practices.Unity;
    using DMS.Business;

    public partial class DealerComplaint : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;

        private IDealerQABLL _bll = null;

        [Dependency]
        public IDealerQABLL bll
        {
            get { return _bll; }
            set { _bll = value; }
        }

        #endregion

        private static string queryStr = HttpContext.Current.Request.Url.Query;
        private static string absoluteUri = HttpContext.Current.Request.Url.AbsoluteUri;
        private static string absolutePath = HttpContext.Current.Request.Url.AbsolutePath;
        private string HostUrl = string.IsNullOrEmpty(queryStr) ? absoluteUri.Replace(absolutePath, "") : absoluteUri.Replace(queryStr, "").Replace(absolutePath, "");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.cbDealer.Hidden = IsDealer;
                this.btnInsert.Hidden = !IsDealer;

                this.Store_DealerList(DealerStore);
                this.Bind_Dictionary(DealerComplaintTypeStore, SR.Consts_DealerComplaint_Type.ToString());
                this.DealerComplaintStatusStore_Refresh(DealerComplaintStatusStore);

                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.DealerQABLL.Action_DealerQA, PermissionType.Read);
                this.btnInsert.Visible = pers.IsPermissible(Business.DealerQABLL.Action_DealerQA, PermissionType.Write);
            }
        }

        #region Store
        private void DealerComplaintStatusStore_Refresh(Store stores)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_DealerComplaint_Status.ToString());

            dicts.Remove("Draft");

            if (IsDealer)
            {
                dicts.Add("Draft", "草稿");
            }
            stores.DataSource = dicts;
            stores.DataBind();
        }

        private void Store_DealerList(Store stores)
        {
            //Clears the dealer's cache
            DMS.Business.Cache.DealerCacheHelper.FlushCache();

            //Gets all dealers
            IList<DealerMaster> dataSource = DMS.Business.Cache.DealerCacheHelper.GetDealers();
            var query = from p in dataSource
                        where p.HostCompanyFlag != true
                        select p;

            dataSource = query.ToList<DealerMaster>();
            
            stores.DataSource = dataSource;
            stores.DataBind();
            
        }

        public void ResultStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable table = new Hashtable();

            if (!string.IsNullOrEmpty(this.tfTitle.Text.Trim()))
                table.Add("Title", this.tfTitle.Text.Trim());

            if (this.cbStatus.SelectedItem.Value != "")
                table.Add("Status", this.cbStatus.SelectedItem.Value);

            if (this.cbType.SelectedItem.Value != "")
                table.Add("Type", this.cbType.SelectedItem.Value);

            if (!this.dfAnswerBeginDate.IsNull)
                table.Add("AnswerBeginDate", this.dfAnswerBeginDate.SelectedDate.ToString("yyyyMMdd"));

            if (!this.dfAnswerEndDate.IsNull)
                table.Add("AnswerEndDate", this.dfAnswerEndDate.SelectedDate.ToString("yyyyMMdd"));

            if (!this.dfQuestionBeginDate.IsNull)
                table.Add("QuestionBeginDate", this.dfQuestionBeginDate.SelectedDate.ToString("yyyyMMdd"));

            if (!this.dfQuestionEndDate.IsNull)
                table.Add("QuestionEndDate", this.dfQuestionEndDate.SelectedDate.ToString("yyyyMMdd"));

            table.Add("Category", ((int)DealerQACategory.Complaint).ToString());

            DataSet data = null;
            if (IsDealer)
            {
                //被授权的经销商用户都可以查看到该经销商旗下的所有状态的回答（包括草稿以及修改草稿）
                table.Add("DealerId", _context.User.CorpId.Value.ToString());

                data = bll.QuerySelectDealerQAByFilterForDealer(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            }
            else
            {
                if (this.cbDealer.SelectedItem.Value != "")
                    table.Add("DealerId", this.cbDealer.SelectedItem.Value);

                data = bll.QuerySelectDealerQAByFilter(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
             
            }
            e.TotalCount = totalCount;

            ResultStore.DataSource = data;
            ResultStore.DataBind();
        }
        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public void Show(string id)
        {
            ClearValue();
            SetStatus();

            this.hidId.Text = id;

            if (new Guid(id) == Guid.Empty)
            {
                this.cbTypeWin.Disabled = false;
                this.tfTitleWin.ReadOnly = false;
                this.taBodyWin.ReadOnly = false;

                this.btnDelete.Hide();
                this.tfStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerComplaint_Status, DealerComplaintStatus.Draft.ToString());
            }
            else
            {
                SetValue(id);
            }

        }

        [AjaxMethod]
        public void SaveItem(string status)
        {

            Hashtable table = new Hashtable();

            Dealerqa qa = new Dealerqa();

            if (IsDealer)
            {
                if (new Guid(this.hidId.Text) == Guid.Empty)
                    qa.Id = Guid.NewGuid();
                else
                    qa.Id = new Guid(this.hidId.Text);

                qa.QuestionDate = DateTime.Now;
                qa.QuestionUserId = new Guid(_context.User.Id);
                qa.DealerId = _context.User.CorpId.Value;
                qa.Type = this.cbTypeWin.SelectedItem.Value;
                qa.Status = status;
                qa.Title = this.tfTitleWin.Text;
                qa.Body = this.taBodyWin.Text;
                qa.Category = ((int)DealerQACategory.Complaint).ToString();

                bll.InsertQuestionInfo(qa, HostUrl);
            }
            else
            {
                //BSC回答，更新状态和回答内容
                qa.Id = new Guid(this.hidId.Text);
                qa.Answer = this.taAnswerWin.Text;
                qa.AnswerUserId = new Guid(_context.User.Id);
                qa.AnswerDate = DateTime.Now;
                qa.Status = status;

                bll.InsertAnswer(qa);
            }
        }

        [AjaxMethod]
        public void DeleteItem()
        {
            bool reslut = bll.DeleteItem(new Guid(this.hidId.Text));
        }
        #endregion

        #region 页面私有方法
        private void ClearValue()
        {
            this.cbDealerWin.SelectedItem.Value = "";
            this.tfQuestionDateWin.Clear();
            this.cbTypeWin.SelectedItem.Value = "";
            this.tfStatusWin.Clear();
            this.tfTitleWin.Clear();
            this.taBodyWin.Clear();
            this.hidId.Clear();
            this.taAnswerWin.Clear();
            this.tfQuestionDateWin.Clear();

            this.btnReplied.Hide();
            this.btnSubmit.Hide();
            this.btnSave.Hide();
            this.btnDelete.Hide();

            this.cbTypeWin.Disabled = true;
            this.tfTitleWin.ReadOnly = true;
            this.taBodyWin.ReadOnly = true;
        }

        private void SetStatus()
        {
            if (IsDealer)
            {
                this.cbDealerWin.Hide();
                this.tfQuestionDateWin.Hide();
                this.cbTypeWin.Disabled = true;
                this.taAnswerWin.ReadOnly = true;
                this.tfTitleWin.ReadOnly = true;
                this.taBodyWin.ReadOnly = true;

                this.AnswerPanel.Hide();
                this.btnSubmit.Show();
                this.btnSave.Show();
                this.btnDelete.Show();
            }
            else
            {
                this.cbTypeWin.Disabled = true;
                this.tfTitleWin.ReadOnly = true;
                this.taBodyWin.ReadOnly = true;
                this.taAnswerWin.ReadOnly = true;

                this.AnswerPanel.Show();
                this.btnReplied.Show();
            }
        }

        private void SetValue(string id)
        {
            Dealerqa qa = bll.GetObject(new Guid(id));

            this.cbDealerWin.SelectedItem.Value = !string.IsNullOrEmpty(qa.DealerId.ToString()) ? qa.DealerId.ToString() : "";
            this.cbTypeWin.SelectedItem.Value = !string.IsNullOrEmpty(qa.Type) ? qa.Type : "";
            this.tfStatusWin.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerComplaint_Status, qa.Status);
            this.tfTitleWin.Text = !string.IsNullOrEmpty(qa.Title) ? qa.Title : "";
            this.taBodyWin.Text = !string.IsNullOrEmpty(qa.Body) ? qa.Body : "";
            this.tfQuestionDateWin.Text = qa.QuestionDate.ToString("yyyy/MM/dd");

            //状态为草稿
            if (qa.Status == DealerComplaintStatus.Draft.ToString())
            {
                this.tfTitleWin.ReadOnly = false;
                this.taBodyWin.ReadOnly = false;

                this.cbTypeWin.Disabled = false;
                this.tfTitleWin.ReadOnly = false;
                this.taBodyWin.ReadOnly = false;
            }
            //状态为已提交
            else if (qa.Status == DealerComplaintStatus.Submitted.ToString())
            {
                this.taAnswerWin.ReadOnly = false;

                this.btnSubmit.Hide();
                this.btnSave.Hide();
                this.btnDelete.Hide();
            }
            //状态为以回复
            else if (qa.Status == DealerComplaintStatus.Replied.ToString())
            {
                this.btnSubmit.Hide();
                this.btnSave.Hide();
                this.btnDelete.Hide();
                this.btnReplied.Hide();

                this.AnswerPanel.Show();
                this.taAnswerWin.Text = !string.IsNullOrEmpty(qa.Answer) ? qa.Answer : "";
            }
        }
        #endregion
    }
}
