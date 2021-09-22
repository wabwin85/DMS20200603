using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business.DP;
using Lafite.RoleModel.Security;

namespace DMS.Website.Pages.DP
{
    public partial class Child_Award : BasePage
    {
        #region 公共
        DataTable DealerGridDataAll;
        DataTable AllLink;

        private IDealerInfoService _DealerInfo = null;
        private IDealerInfoService DealerInfo
        {
            get
            {
                if (_DealerInfo == null)
                {
                    _DealerInfo = new DealerInfoService();
                }
                return _DealerInfo;
            }
        }

        private IDpRightService _DpRightService = null;
        private IDpRightService DpRightService
        {
            get
            {
                if (_DpRightService == null)
                {
                    _DpRightService = new DpRightService();
                }
                return _DpRightService;
            }
        }


        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetAllLink();
                GetGridDate();
                GetPermissions();
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!String.IsNullOrEmpty(Request.QueryString["UdstrID"]))
                {
                    this.hdDisID.Value = Request.QueryString["UdstrID"].ToString();
                }

                Hashtable param = new Hashtable();
                param.Add("Cust_CD", this.hdDisID.Value);
                param.Add("ParentModleID", "387DAF1C-BB30-432A-9015-C94460DB4CDF");
                if (!String.IsNullOrEmpty(Request.QueryString["Version"]))
                {
                    param.Add("VersionID", Request.QueryString["Version"]);
                    this.hfVersion.Value = Request.QueryString["Version"].ToString();
                }
                else
                {
                    param.Add("VersionID", "NULL");
                }

                DataSet detailDS = DealerInfo.GetDealerDetailByPMID(param);
                //DealerGridDataAll = detailDS.Tables[1];
                //AllLink = detailDS.Tables[3];

                DealerGridDataAll = detailDS.Tables[0];
                //BinddtValues = detailDS.Tables[1];
                AllLink = detailDS.Tables[2];
            }
        }

        //存储附件链接
        private void GetAllLink()
        {
            Session["dtAllLink"] = AllLink;
        }

        #region 获取各列表小类数据
        //存储更名记录
        private void GetGridDate()
        {
            DataTable dtAwardCopy = DealerGridDataAll.Copy();
            DataTable dtAward = DealerGridDataAll.Clone();
            DataRow[] drAward = dtAwardCopy.Select("ModleName='奖励记录'");
            foreach (DataRow row in drAward)
            {
                dtAward.Rows.Add(row.ItemArray);
            }
            Session["dtAward"] = dtAward;

            DataTable dtPunishmentCopy = DealerGridDataAll.Copy();
            DataTable dtPunishment = DealerGridDataAll.Clone();
            DataRow[] drPunishment = dtPunishmentCopy.Select("ModleName='处罚记录'");
            foreach (DataRow row in drPunishment)
            {
                dtPunishment.Rows.Add(row.ItemArray);
            }
            Session["dtPunishment"] = dtPunishment;
        }
        #endregion

        #region 绑定参考链接
        protected void Link1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt1 = dt.Clone();
                    DataRow[] dr1 = dt.Select("ModleName='奖励记录' and ArchiveType=1 ");
                    foreach (DataRow row in dr1)
                    {
                        dt1.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore1.DataSource = dt1;
                    this.LinkStore1.DataBind();
                }
            }
        }

        protected void Link2_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt1 = dt.Clone();
                    DataRow[] dr1 = dt.Select("ModleName='处罚记录' and ArchiveType=1 ");
                    foreach (DataRow row in dr1)
                    {
                        dt1.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore2.DataSource = dt1;
                    this.LinkStore2.DataBind();
                }
            }
        }
        #endregion

        #region 绑定附件
        protected void Annex1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt1 = dt.Clone();
                    DataRow[] dr1 = dt.Select("ModleName='奖励记录' and ArchiveType=2 ");
                    foreach (DataRow row in dr1)
                    {
                        dt1.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex1.DataSource = dt1;
                    this.StoreAnnex1.DataBind();
                }
            }
        }
        protected void Annex2_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt1 = dt.Clone();
                    DataRow[] dr1 = dt.Select("ModleName='处罚记录' and ArchiveType=2 ");
                    foreach (DataRow row in dr1)
                    {
                        dt1.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex2.DataSource = dt1;
                    this.StoreAnnex2.DataBind();
                }
            }
        }
        #endregion

        #region 绑定列表小类数据

        protected void Award_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(tfAwardBegin.Text))
            {
                sql += "and Column2 >='" + tfAwardBegin.Text + "'";
            }
            if (!string.IsNullOrEmpty(tfAwardEnd.Text))
            {
                sql += "and Column2 <='" + tfAwardEnd.Text + "'";
            }
            if (Session["dtAward"] != null)
            {
                DataTable dt = Session["dtAward"] as DataTable;
                DataTable dtAward = dt.Clone();
                DataRow[] drAward = dt.Select(sql);
                foreach (DataRow row in drAward)
                {
                    dtAward.Rows.Add(row.ItemArray);
                }
                this.Store_Award.DataSource = dtAward;
                this.Store_Award.DataBind();
            }
        }

        protected void Punishment_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(tfPunishmentBegin.Text))
            {
                sql += "and Column2 <=" + tfPunishmentBegin.Text + "'";
            }
            if (!string.IsNullOrEmpty(tfPunishmentEnd.Text))
            {
                sql += "and Column2 >='" + tfPunishmentEnd.Text + "'";
            }

            if (Session["dtPunishment"] != null)
            {
                DataTable dt = Session["dtPunishment"] as DataTable;
                DataTable dtPunishment = dt.Clone();
                DataRow[] drPunishment = dt.Select(sql);
                foreach (DataRow row in drPunishment)
                {
                    dtPunishment.Rows.Add(row.ItemArray);
                }
                this.Store_Punishment.DataSource = dtPunishment;
                this.Store_Punishment.DataBind();
            }
        }
        #endregion

        #region 判断权限
        private void GetPermissions()
        {
            IRoleModelContext context = RoleModelContext.Current;
            LoginUser user = context.User;
            Hashtable obj = new Hashtable();
            obj.Add("Roles", user.Roles);
            obj.Add("ParentModleID", "387DAF1C-BB30-432A-9015-C94460DB4CDF");
            DataTable dt = DpRightService.GetSecondClassPermissions(obj).Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string Getvalue = dt.Rows[i]["ModleID"].ToString();
                if (Getvalue.Trim().ToUpper() == "C06BBE20-3F2E-45F4-A101-740B16FAE544")
                {
                    this.Tab1.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "2E32A71B-912F-4B59-A89A-E143F68A1EA6")
                {
                    this.Tab2.Hidden = false;
                }
            }
        }
        #endregion
    }
}
