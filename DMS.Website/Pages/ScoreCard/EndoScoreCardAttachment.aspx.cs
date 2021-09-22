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
using Microsoft.Practices.Unity;
using DMS.Business.ScoreCard;
namespace DMS.Website.Pages.ScoreCard
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class EndoScoreCardAttachment : BasePage
    {
        #region 公用
        private IEndoScoreCardBLL _endoScoreCard = new EndoScoreCardBLL();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.hiddenESCId.Value = this.Request.QueryString["InstanceID"];
                BindPageDate();
            }
        }

        protected void FileUploadStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string tid = this.hiddenESCId.Text;
            int totalCount = 0;
            DataSet ds = _endoScoreCard.QueryESCAttachmentByESCNo(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.FileUploadStore.DataSource = ds;
            this.FileUploadStore.DataBind();
        }

        private void BindPageDate() 
        {
            String tid = this.hiddenESCId.Text;
            DataTable ScoreCard = _endoScoreCard.QueryEndoScoreCardByIDForDS(tid).Tables[0];
            if (ScoreCard.Rows.Count > 0)
            {
                this.txtDealerWin.Text = ScoreCard.Rows[0]["DmaChineseName"].ToString();
                this.txtProductLineWin.Text = ScoreCard.Rows[0]["BumName"].ToString();
                this.txtStatusWin.Text = ScoreCard.Rows[0]["StatusName"].ToString();
                this.txtYearWin.Text = ScoreCard.Rows[0]["Year"].ToString();
                this.txtQuarterWin.Text = ScoreCard.Rows[0]["Quarter"].ToString();
                this.txtScoreCardNumberWin.Text = ScoreCard.Rows[0]["No"].ToString();
            }
        }
    }
}
