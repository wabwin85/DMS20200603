using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Common;
using Lafite.RoleModel.Domain;

namespace DMS.Website.Pages.ELearning
{
    using Coolite.Ext.Web;
    using System.Data;
    using DMS.Website.Common;
    using Lafite.RoleModel.Security;
    using DMS.Business;
    using System.Collections;
    using Microsoft.Practices.Unity;
    using DMS.Model;

    public partial class ELearningMain : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        private IAttachmentBLL _attachmentBLL = null;
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                btnTrainCompliance.Visible = btnSurvey.Visible = IsDealer;
                btnTrainQuality.Visible = false;
            }
            cbCheckPage();
        }

        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            //DataTable dt = new DataTable();
            //dt.Columns.Add("Name");
            //dt.Columns.Add("Remark");
            //dt.Columns.Add("Url");
            //dt.Rows.Add("蓝威反腐败政策", "", "附件7 蓝威反腐败政策.pdf");
            //dt.Rows.Add("蓝威行为守则", "", "附件6 蓝威行为守则.pdf");

            int totalCount = 0;
            Hashtable tb = new Hashtable();
            tb.Add("MainId", "F8AA61AA-E863-4B3B-AA4E-6AB032FC20D0");

            DataTable dt = attachmentBLL.GetAttachmentOther(tb, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }

        protected void btnExam_OnClick(object sender, EventArgs e)
        {
            //UrlBind("goexam.aspx");
            UrlBind("login.aspx");
        }

        protected void btnUplodeFile_OnClick(object sender, EventArgs e)
        {
            UrlBind("download_file.aspx");
        }

        private void UrlBind(string urlPage) 
        {
            if (IsDealer)
            {
                //string DealerCode = RoleModelContext.Current.User.CorpId.Value.ToString();                
                //string UserName = RoleModelContext.Current.User.CorpName.ToString();
                //string DealerType = RoleModelContext.Current.User.CorpType;
                //string IsRenew = "";
                //Hashtable param = new Hashtable();
                //param.Add("DealerId", RoleModelContext.Current.User.CorpId.Value.ToString());
                //DataTable query = _dealers.GetDealerContract(param).Tables[0];
                //if (query.Rows.Count > 0)
                //{
                //    IsRenew = "1";
                //}
                //else
                //{
                //    IsRenew = "0";
                //}
                //string eLearningUrl = System.Configuration.ConfigurationManager.AppSettings["ELearningUrl"].ToString();
                //string Url = eLearningUrl + urlPage + "?code=" + DealerCode + "&datatype=dealer&dealertype=" + DealerType + "&examtype=legal&isrenew=" + IsRenew + "&UserName=" + Server.UrlEncode(UserName);
                string onlineLearningUrl = System.Configuration.ConfigurationManager.AppSettings["OnlineLearningUrl"].ToString();
                string Url = onlineLearningUrl + urlPage + "?UserId="+ RoleModelContext.Current.User.Id+ "&DealerId=" + RoleModelContext.Current.User.CorpId.Value.ToString();
                this.Response.Write(" <script language=javascript>window.opener=null;window.open('" + Url + "','_blank','height=600, width=800, toolbar =no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=no')</script> ");
            }
        }

        protected void cbCheckPage()
        {
            if (this.cbCheck.Checked)
            {
                this.ImageUplodeFile.Enabled = true;
            }
            else
            {
                this.ImageUplodeFile.Enabled = false;
            }
        }

        protected void btnTrainCompliance_OnClick(object sender, EventArgs e)
        {
            GotoUrlByType("TrainType_Compliance");
        }
        protected void btnTrainQuality_OnClick(object sender, EventArgs e)
        {
            GotoUrlByType("TrainType_Quality");
        }
        protected void btnSurvey_OnClick(object sender, EventArgs e)
        {
            GotoUrlByType("TrainType_Survey");
        }

        private void GotoUrlByType(string traintypeKey)
        {
            if (IsDealer)
            {
                DictionaryDomain dictDomain = new DictionaryDomain();
                dictDomain.DictType = SR.Consts_TrainType;
                dictDomain.DictKey = traintypeKey;
                IList<DictionaryDomain> dictList = DictionaryHelper.GetDomainListByFilter(dictDomain);
                if (dictList != null && dictList.Count > 0)
                {
                    DictionaryDomain dict = dictList.First<DictionaryDomain>();
                    string strTrainingUrl = dict.Value1;
                    string Url = strTrainingUrl+"&UserId=" + RoleModelContext.Current.User.Id + "&DealerId=" + RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.Response.Write(" <script language=javascript>window.opener=null;window.open('" + Url + "','_blank','height=600, width=800, toolbar =no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=no')</script> ");
                }
            }
        }
    }
}
