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
using System.Xml;
using System.Xml.Xsl;
using Lafite.RoleModel.Security;

namespace DMS.Website.Pages.DP
{
    public partial class Child_DandB : BasePage
    {
        #region 公共
        DataTable BinddtValues;
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
                BindPageDate();
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
                param.Add("ParentModleID", "1E5AFB22-133F-45A0-A153-C07CEF492E24");
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

                //BinddtValues = detailDS.Tables[2];
                //AllLink = detailDS.Tables[3];

                //DealerGridDataAll = detailDS.Tables[0];
                BinddtValues = detailDS.Tables[1];
                AllLink = detailDS.Tables[2];
            }
        }

        #region 绑定非列表小类页面数据
        private void BindPageDate()
        {
            //基本信息
            DataTable dt1 = BinddtValues.Clone();
            DataRow[] dr1 = BinddtValues.Select("ModleID='A2310F7E-0392-449E-80EA-F118FD1C3C4F'");
            foreach (DataRow row in dr1)
            {
                dt1.Rows.Add(row.ItemArray);
            }

            if (dt1.Rows.Count > 0)
            {
                this.Column1.Text = dt1.Rows[0]["Column1"].ToString();
                this.Column2.Text = dt1.Rows[0]["Column2"].ToString();
                this.Column3.Text = dt1.Rows[0]["Column3"].ToString();
                this.Column4.Text = dt1.Rows[0]["Column4"].ToString();
                this.Column5.Text = dt1.Rows[0]["Column5"].ToString();
                this.Column6.Text = dt1.Rows[0]["Column6"].ToString();
                this.Column7.Text = dt1.Rows[0]["Column7"].ToString();
                this.Column8.Text = dt1.Rows[0]["Column8"].ToString();
            }

            //邓白氏风险评估
            DataTable dt2 = BinddtValues.Clone();
            DataRow[] dr2 = BinddtValues.Select("ModleID='D28C727D-521D-4D5F-AFD8-246220577C87'");
            foreach (DataRow row in dr2)
            {
                dt2.Rows.Add(row.ItemArray);
            }
            if (dt2.Rows.Count > 0)
            {
                this.tfWarning.Text = dt2.Rows[0]["Column1"].ToString();
                this.tfDBPay.Text = dt2.Rows[0]["Column2"].ToString();
                this.tfDBStrength.Text = dt2.Rows[0]["Column3"].ToString();
                this.tfDBAssess.Text = dt2.Rows[0]["Column4"].ToString();
            }

            //财务概要
            DataTable dt3 = BinddtValues.Clone();
            DataRow[] dr3 = BinddtValues.Select("ModleID='193EBFBD-8929-4874-88D4-23D91670AA9D'");
            foreach (DataRow row in dr3)
            {
                dt3.Rows.Add(row.ItemArray);
            }

            if (dt3.Rows.Count > 0)
            {
                this.tb_Currency.Text = dt3.Rows[0]["Column1"].ToString();
                this.tb_Registration.Text = dt3.Rows[0]["Column2"].ToString();
                this.tb_OperatingIncome.Text = dt3.Rows[0]["Column3"].ToString();
                this.tb_Income.Text = dt3.Rows[0]["Column4"].ToString();
                this.tb_TotalAssets.Text = dt3.Rows[0]["Column5"].ToString();
                this.tb_NetWorth.Text = dt3.Rows[0]["Column6"].ToString();
                this.tb_IsNoRep.Text = dt3.Rows[0]["Column7"].ToString();
            }

            //财务详细信息
            DataTable dt4 = BinddtValues.Clone();
            DataRow[] dr4 = BinddtValues.Select("ModleID='1EEB99DA-5A87-4E2A-BE74-852BD2A9261E'");
            foreach (DataRow row in dr4)
            {
                dt4.Rows.Add(row.ItemArray);
            }

            if (dt4.Rows.Count > 0)
            {
                this.tb_FinancialYearRep.Text = dt4.Rows[0]["Column1"].ToString();
                this.tb_Assets.Text = dt4.Rows[0]["Column2"].ToString();
                this.tb_Liabilities.Text = dt4.Rows[0]["Column3"].ToString();
                this.tb_ReturnCycle.Text = dt4.Rows[0]["Column4"].ToString();
                this.tb_InventoryCycle.Text = dt4.Rows[0]["Column5"].ToString();
                this.tb_PayCycle.Text = dt4.Rows[0]["Column6"].ToString();
                this.tb_CurrentRatio.Text = dt4.Rows[0]["Column7"].ToString();
                this.tb_QuickRatio.Text = dt4.Rows[0]["Column8"].ToString();
                this.tb_DebtRatio.Text = dt4.Rows[0]["Column9"].ToString();
                this.tb_TurnoverRate.Text = dt4.Rows[0]["Column10"].ToString();
                this.tb_EMargin.Text = dt4.Rows[0]["Column11"].ToString();
                this.tb_BMargin.Text = dt4.Rows[0]["Column12"].ToString();
                this.tb_ShareholderYield.Text = dt4.Rows[0]["Column13"].ToString();
                this.tb_AssetsYield.Text = dt4.Rows[0]["Column14"].ToString();
            }

            //营业概况
            DataTable dt5 = BinddtValues.Clone();
            DataRow[] dr5 = BinddtValues.Select("ModleID='5A324ECA-B887-4B18-879D-35A90918BEEC'");
            foreach (DataRow row in dr5)
            {
                dt5.Rows.Add(row.ItemArray);
            }

            if (dt5.Rows.Count > 0)
            {
                this.tb_Address.Text = dt5.Rows[0]["Column1"].ToString();
                this.tb_Buys.Text = dt5.Rows[0]["Column2"].ToString();
                this.tb_CustomerType.Text = dt5.Rows[0]["Column3"].ToString();
                this.tb_OperatingPeriod.Text = dt5.Rows[0]["Column4"].ToString();
                this.tb_OfBusiness.Text = dt5.Rows[0]["Column5"].ToString();
                this.tb_SalesArea.Text = dt5.Rows[0]["Column6"].ToString();
            }

            //公共记录
            DataTable dt6 = BinddtValues.Clone();
            DataRow[] dr6 = BinddtValues.Select("ModleID='EC6857C5-74C9-4567-AD6C-530A987354CE'");
            foreach (DataRow row in dr6)
            {
                dt6.Rows.Add(row.ItemArray);
            }

            if (dt6.Rows.Count > 0)
            {
                this.tb_Internet.Text = dt6.Rows[0]["Column1"].ToString();
                this.tb_Litigation.Text = dt6.Rows[0]["Column2"].ToString();
                this.tb_Media.Text = dt6.Rows[0]["Column3"].ToString();
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
                    DataRow[] dr1 = dt.Select("ModleName='基本信息' and ArchiveType=2 ");
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
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='邓白氏风险评估' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex2.DataSource = dt2;
                    this.StoreAnnex2.DataBind();
                }
            }
        }

        protected void Annex3_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='财务概要' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex3.DataSource = dt2;
                    this.StoreAnnex4.DataBind();
                }
            }
        }
        protected void Annex4_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='财务详细信息' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex4.DataSource = dt2;
                    this.StoreAnnex4.DataBind();
                }
            }
        }
        protected void Annex5_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='营业概况' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex5.DataSource = dt2;
                    this.StoreAnnex5.DataBind();
                }
            }
        }
        protected void Annex6_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='公共记录' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex6.DataSource = dt2;
                    this.StoreAnnex6.DataBind();
                }
            }
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
                    DataRow[] dr1 = dt.Select("ModleName='基本信息' and ArchiveType=1 ");
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
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='邓白氏风险评估' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore2.DataSource = dt2;
                    this.LinkStore2.DataBind();
                }
            }
        }

        protected void Link3_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='财务概要' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore3.DataSource = dt2;
                    this.LinkStore3.DataBind();
                }
            }
        }
        protected void Link4_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='财务详细信息' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore4.DataSource = dt;
                    this.LinkStore4.DataBind();
                }
            }
        }
        protected void Link5_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='营业概况' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore5.DataSource = dt2;
                    this.LinkStore5.DataBind();
                }
            }
        }
        protected void Link6_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='公共记录' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore6.DataSource = dt2;
                    this.LinkStore6.DataBind();
                }
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
            obj.Add("ParentModleID", "1E5AFB22-133F-45A0-A153-C07CEF492E24");
            DataTable dt = DpRightService.GetSecondClassPermissions(obj).Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string Getvalue = dt.Rows[i]["ModleID"].ToString();
                if (Getvalue.Trim().ToUpper() == "A2310F7E-0392-449E-80EA-F118FD1C3C4F")
                {
                    this.Tab1.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "D28C727D-521D-4D5F-AFD8-246220577C87")
                {
                    this.Tab2.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "193EBFBD-8929-4874-88D4-23D91670AA9D")
                {
                    this.Tab3.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "1EEB99DA-5A87-4E2A-BE74-852BD2A9261E")
                {
                    this.Tab4.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "5A324ECA-B887-4B18-879D-35A90918BEEC")
                {
                    this.Tab5.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "EC6857C5-74C9-4567-AD6C-530A987354CE")
                {
                    this.Tab6.Hidden = false;
                }
            }
        }
        #endregion
    }
}
