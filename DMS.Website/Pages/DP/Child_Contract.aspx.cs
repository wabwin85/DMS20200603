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
    public partial class Child_Contract : BasePage
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
                param.Add("ParentModleID", "90A5C181-A46E-4B8F-8D78-289808EF96B7");
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
            DataTable dtContractCopy = DealerGridDataAll.Copy();
            DataTable dtContract = DealerGridDataAll.Clone();
            DataRow[] drContract = dtContractCopy.Select("ModleName='合同记录'");
            foreach (DataRow row in drContract)
            {
                dtContract.Rows.Add(row.ItemArray);
            }
            Session["dtContract"] = dtContract;

            DataTable dtFileCopy = DealerGridDataAll.Copy();
            DataTable dtFile = DealerGridDataAll.Clone();
            DataRow[] drFile = dtFileCopy.Select("ModleName='文件记录'");
            foreach (DataRow row in drFile)
            {
                dtFile.Rows.Add(row.ItemArray);
            }
            Session["dtFile"] = dtFile;
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
                    DataRow[] dr1 = dt.Select("ModleName='合同记录' and ArchiveType=1 ");
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
                    DataRow[] dr1 = dt.Select("ModleName='文件记录' and ArchiveType=1 ");
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
                    DataRow[] dr1 = dt.Select("ModleName='合同记录' and ArchiveType=2 ");
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
                    DataRow[] dr1 = dt.Select("ModleName='文件记录' and ArchiveType=2 ");
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

        protected void Contract_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(tfContractBegin.Text))
            {
                sql += "and Column3 >='" + tfContractBegin.Text + "'";
            }
            if (!string.IsNullOrEmpty(tfContractEnd.Text))
            {
                sql += "and Column4 <='" + tfContractEnd.Text + "'";
            }
            if (Session["dtContract"] != null)
            {
                DataTable dt = Session["dtContract"] as DataTable;
                DataTable dtContract = dt.Clone();
                DataRow[] drContract = dt.Select(sql);
                foreach (DataRow row in drContract)
                {
                    dtContract.Rows.Add(row.ItemArray);
                }
                this.Store_Contract.DataSource = dtContract;
                this.Store_Contract.DataBind();
            }
        }

        protected void File_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(tfFileCode.Text))
            {
                sql += "and Column1 ='" + tfFileCode.Text + "'";
            }
            if (!string.IsNullOrEmpty(tfFileBegin.Text))
            {
                sql += "and Column4 >='" + tfFileBegin.Text + "'";
            }
            if (!string.IsNullOrEmpty(tfFileEnd.Text))
            {
                sql += "and Column5 <='" + tfFileEnd.Text + "'";
            }
            if (Session["dtFile"] != null)
            {
                DataTable dt = Session["dtFile"] as DataTable;
                DataTable dtFile = dt.Clone();
                DataRow[] drFile = dt.Select(sql);
                foreach (DataRow row in drFile)
                {
                    dtFile.Rows.Add(row.ItemArray);
                }
                this.Store_File.DataSource = dtFile;
                this.Store_File.DataBind();
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
            obj.Add("ParentModleID", "90A5C181-A46E-4B8F-8D78-289808EF96B7");
            DataTable dt = DpRightService.GetSecondClassPermissions(obj).Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string Getvalue = dt.Rows[i]["ModleID"].ToString();
                if (Getvalue.Trim().ToUpper() == "D301046A-5B52-465F-8DB9-F7633FA1E8CA")
                {
                    this.Tab1.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "9E4402B6-CE05-4CF5-B1DD-A7126B3795A6")
                {
                    this.Tab2.Hidden = false;
                }
            }
        }
        #endregion
    }
}
