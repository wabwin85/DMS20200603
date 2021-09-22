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
    public partial class Child_Certificate : BasePage
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
                GetGridData();
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
                param.Add("ParentModleID", "2E4E184B-553F-4BE9-A554-0E6077A1AAB2");
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
            DataTable BinddtValuesCopy = new DataTable();
            //企业法人营业执照
            DataTable dt1 = BinddtValues.Clone();
            BinddtValuesCopy = BinddtValues.Copy();
            DataRow[] dr1 = BinddtValuesCopy.Select("ModleID='D451C1BA-4190-44C5-9AE7-965558A70BA5'");
            foreach (DataRow row in dr1)
            {
                dt1.Rows.Add(row.ItemArray);
            }

            if (dt1.Rows.Count > 0)
            {
                this.dp_bl_begin.Text = dt1.Rows[0]["Column1"].ToString();
                this.dp_bl_end.Text = dt1.Rows[0]["Column2"].ToString();
                this.tb_bl_Legal.Text = dt1.Rows[0]["Column3"].ToString();
                this.ddl_bl_isnoStamp.Text = dt1.Rows[0]["Column4"].ToString();
                this.tb_bl_Remarks.Text = dt1.Rows[0]["Column5"].ToString();
            }

            //企业组织机构代码证
            BinddtValuesCopy = BinddtValues.Copy();
            DataTable dt2 = BinddtValues.Clone();
            DataRow[] dr2 = BinddtValuesCopy.Select("ModleID='73BA1756-DA4B-4253-923F-6302A4F41304'");
            foreach (DataRow row in dr2)
            {
                dt2.Rows.Add(row.ItemArray);
            }
            if (dt2.Rows.Count > 0)
            {
                this.dp_occ_begin.Text = dt2.Rows[0]["Column1"].ToString();
                this.dp_occ_end.Text = dt2.Rows[0]["Column2"].ToString();
                this.tb_occ_Code.Text = dt2.Rows[0]["Column3"].ToString();
                this.ddl_occ_isnoStamp.Text = dt2.Rows[0]["Column4"].ToString();
                this.tb_occ_Remarks.Text = dt2.Rows[0]["Column5"].ToString();
            }

            //税务登记证（国税）
            BinddtValuesCopy = BinddtValues.Copy();
            DataTable dt3 = BinddtValues.Clone();
            DataRow[] dr3 = BinddtValuesCopy.Select("ModleID='89EF7DDA-DCF5-46BC-B3FB-602D088FE625'");
            foreach (DataRow row in dr3)
            {
                dt3.Rows.Add(row.ItemArray);
            }

            if (dt3.Rows.Count > 0)
            {
                this.dp_nt_begin.Text = dt3.Rows[0]["Column1"].ToString();
                this.dp_nt_end.Text = dt3.Rows[0]["Column2"].ToString();
                this.tb_nt_Code.Text = dt3.Rows[0]["Column3"].ToString();
                this.ddl_nt_isnoStamp.Text = dt3.Rows[0]["Column4"].ToString();
                this.ddl_nt_Type.Text = dt3.Rows[0]["Column5"].ToString();
                this.tb_nt_Remarks.Text = dt3.Rows[0]["Column6"].ToString();
            }

            //税务登记证（地税）
            BinddtValuesCopy = BinddtValues.Copy();
            DataTable dt4 = BinddtValues.Clone();
            DataRow[] dr4 = BinddtValuesCopy.Select("ModleID='07D60118-B5C9-4EE8-9A55-48F429D06191'");
            foreach (DataRow row in dr4)
            {
                dt4.Rows.Add(row.ItemArray);
            }

            if (dt4.Rows.Count > 0)
            {
                this.dp_lt_begin.Text = dt4.Rows[0]["Column1"].ToString();
                this.dp_lt_end.Text = dt4.Rows[0]["Column2"].ToString();
                this.tb_lt_Code.Text = dt4.Rows[0]["Column3"].ToString();
                this.ddl_lt_isnoStamp.Text = dt4.Rows[0]["Column4"].ToString();
                this.tb_lt_Remarks.Text = dt4.Rows[0]["Column5"].ToString();
            }

            //医疗器械经营企业许可证
            BinddtValuesCopy = BinddtValues.Copy();
            DataTable dt5 = BinddtValues.Clone();
            DataRow[] dr5 = BinddtValuesCopy.Select("ModleID='38F77606-2B36-4E7F-964D-7BA36D8F1510'");
            foreach (DataRow row in dr5)
            {
                dt5.Rows.Add(row.ItemArray);
            }

            if (dt5.Rows.Count > 0)
            {
                this.dp_ml_begin.Text = dt5.Rows[0]["Column1"].ToString();
                this.dp_ml_end.Text = dt5.Rows[0]["Column2"].ToString();
                this.tb_ml_Quality.Text = dt5.Rows[0]["Column3"].ToString();
                this.ddl_ml_isnoStamp.Text = dt5.Rows[0]["Column4"].ToString();
                this.tb_ml_Address.Text = dt5.Rows[0]["Column5"].ToString();
                this.tb_ml_Remarks.Text = dt5.Rows[0]["Column6"].ToString();
                this.tb_ml_Scope.Text = dt5.Rows[0]["Column7"].ToString();
            }

            //药品经营许可证
            BinddtValuesCopy = BinddtValues.Copy();
            DataTable dt6 = BinddtValues.Clone();
            DataRow[] dr6 = BinddtValuesCopy.Select("ModleID='0DFC3D5B-9C5C-44FE-8CB9-7D8F90041FA0'");
            foreach (DataRow row in dr6)
            {
                dt6.Rows.Add(row.ItemArray);
            }

            if (dt6.Rows.Count > 0)
            {
                this.dp_pt_begin.Text = dt6.Rows[0]["Column1"].ToString();
                this.dp_pt_end.Text = dt6.Rows[0]["Column2"].ToString();
                this.tb_pt_Quality.Text = dt6.Rows[0]["Column3"].ToString();
                this.ddl_pt_isnoStamp.Text = dt6.Rows[0]["Column4"].ToString();
                this.tb_pt_Address.Text = dt6.Rows[0]["Column5"].ToString();
                this.tb_pt_Remarks.Text = dt6.Rows[0]["Column6"].ToString();
                this.tb_pt_Scope.Text = dt6.Rows[0]["Column7"].ToString();
            }

            //危险化学品经营许可证
            BinddtValuesCopy = BinddtValues.Copy();
            DataTable dt7 = BinddtValues.Clone();
            DataRow[] dr7 = BinddtValuesCopy.Select("ModleID='132610D9-5B26-4EA0-8BB5-144DD55EF2DF'");
            foreach (DataRow row in dr7)
            {
                dt7.Rows.Add(row.ItemArray);
            }

            if (dt7.Rows.Count > 0)
            {
                this.dp_hc_begin.Text = dt7.Rows[0]["Column1"].ToString();
                this.dp_hc_end.Text = dt7.Rows[0]["Column2"].ToString();
                this.tb_hc_Quality.Text = dt7.Rows[0]["Column3"].ToString();
                this.ddl_hc_isnoStamp.Text = dt7.Rows[0]["Column4"].ToString();
                this.tb_hc_Scope.Text = dt7.Rows[0]["Column5"].ToString();
                this.tb_hc_Address.Text = dt7.Rows[0]["Column6"].ToString();
                this.tb_hc_Remarks.Text = dt7.Rows[0]["Column7"].ToString();
            }
        }
        #endregion

        #region 存储预警数据
        private void GetGridData()
        {
            Session["BinddtValues"] = BinddtValues;
        }
        #endregion

        #region 绑定列表小类数据

        protected void Warning_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["BinddtValues"] != null)
            {
                BinddtValues = Session["BinddtValues"] as DataTable;
                DataTable dtBind = new DataTable();
                dtBind.Columns.Add("ID");
                dtBind.Columns.Add("Name");
                dtBind.Columns.Add("BegDate");
                dtBind.Columns.Add("EndDate");
                dtBind.Columns.Add("Warning");
                int WarningDays = 0;
                DataTable dt = DealerInfo.GetReminderTime().Tables[0];
                if (dt.Rows.Count > 0)
                {
                    WarningDays = Convert.ToInt32(dt.Rows[0]["VALUE1"].ToString());
                }

                //企业法人营业执照
                DataTable dt1 = BinddtValues.Clone();
                DataRow[] dr1 = BinddtValues.Select("ModleID='D451C1BA-4190-44C5-9AE7-965558A70BA5'");
                foreach (DataRow row in dr1)
                {
                    dt1.Rows.Add(row.ItemArray);
                }
                if (dt1.Rows.Count > 0 && !dt1.Rows[0]["Column2"].ToString().Equals(""))
                {

                    DateTime enddate = Convert.ToDateTime(dt1.Rows[0]["Column2"].ToString());
                    DateTime dtUpcoming = DateTime.Now.AddDays(WarningDays);
                    if (enddate < DateTime.Now)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "企业法人营业执照", dt1.Rows[0]["Column1"].ToString(), dt1.Rows[0]["Column2"].ToString(), "已过期");
                        // return;
                    }
                    else if (enddate >= DateTime.Now && enddate <= dtUpcoming)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "企业法人营业执照", dt1.Rows[0]["Column1"].ToString(), dt1.Rows[0]["Column2"].ToString(), "即将过期");
                    }
                }

                //企业组织机构代码证
                DataTable dt2 = BinddtValues.Clone();
                DataRow[] dr2 = BinddtValues.Select("ModleID='73BA1756-DA4B-4253-923F-6302A4F41304'");
                foreach (DataRow row in dr2)
                {
                    dt2.Rows.Add(row.ItemArray);
                }
                if (dt2.Rows.Count > 0 && !dt2.Rows[0]["Column2"].ToString().Equals(""))
                {

                    DateTime enddate = Convert.ToDateTime(dt2.Rows[0]["Column2"].ToString());
                    DateTime dtUpcoming = DateTime.Now.AddDays(WarningDays);
                    if (enddate < DateTime.Now)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "企业组织机构代码证", dt2.Rows[0]["Column1"].ToString(), dt2.Rows[0]["Column2"].ToString(), "已过期");
                        // return;
                    }
                    else if (enddate >= DateTime.Now && enddate <= dtUpcoming)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "企业组织机构代码证", dt2.Rows[0]["Column1"].ToString(), dt2.Rows[0]["Column2"].ToString(), "即将过期");
                    }
                }

                //税务登记证（国税）
                DataTable dt3 = BinddtValues.Clone();
                DataRow[] dr3 = BinddtValues.Select("ModleID='89EF7DDA-DCF5-46BC-B3FB-602D088FE625'");
                foreach (DataRow row in dr3)
                {
                    dt3.Rows.Add(row.ItemArray);
                }
                if (dt3.Rows.Count > 0 && !dt3.Rows[0]["Column2"].ToString().Equals(""))
                {

                    DateTime enddate = Convert.ToDateTime(dt3.Rows[0]["Column2"].ToString());
                    DateTime dtUpcoming = DateTime.Now.AddDays(WarningDays);
                    if (enddate < DateTime.Now)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "税务登记证（国税）", dt3.Rows[0]["Column1"].ToString(), dt3.Rows[0]["Column2"].ToString(), "已过期");
                        // return;
                    }
                    else if (enddate >= DateTime.Now && enddate <= dtUpcoming)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "税务登记证（国税）", dt3.Rows[0]["Column1"].ToString(), dt3.Rows[0]["Column2"].ToString(), "即将过期");
                    }
                }

                //税务登记证（地税）
                DataTable dt4 = BinddtValues.Clone();
                DataRow[] dr4 = BinddtValues.Select("ModleID='07D60118-B5C9-4EE8-9A55-48F429D06191'");
                foreach (DataRow row in dr4)
                {
                    dt4.Rows.Add(row.ItemArray);
                }
                if (dt4.Rows.Count > 0 && !dt4.Rows[0]["Column2"].ToString().Equals(""))
                {

                    DateTime enddate = Convert.ToDateTime(dt4.Rows[0]["Column2"].ToString());
                    DateTime dtUpcoming = DateTime.Now.AddDays(WarningDays);
                    if (enddate < DateTime.Now)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "税务登记证（地税）", dt4.Rows[0]["Column1"].ToString(), dt4.Rows[0]["Column2"].ToString(), "已过期");
                        // return;
                    }
                    else if (enddate >= DateTime.Now && enddate <= dtUpcoming)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "税务登记证（地税）", dt4.Rows[0]["Column1"].ToString(), dt4.Rows[0]["Column2"].ToString(), "即将过期");
                    }
                }

                //医疗器械经营企业许可证
                DataTable dt5 = BinddtValues.Clone();
                DataRow[] dr5 = BinddtValues.Select("ModleID='38F77606-2B36-4E7F-964D-7BA36D8F1510'");
                foreach (DataRow row in dr5)
                {
                    dt5.Rows.Add(row.ItemArray);
                }
                if (dt5.Rows.Count > 0 && !dt5.Rows[0]["Column2"].ToString().Equals(""))
                {

                    DateTime enddate = Convert.ToDateTime(dt5.Rows[0]["Column2"].ToString());
                    DateTime dtUpcoming = DateTime.Now.AddDays(WarningDays);
                    if (enddate < DateTime.Now)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "医疗器械经营企业许可证", dt5.Rows[0]["Column1"].ToString(), dt5.Rows[0]["Column2"].ToString(), "已过期");
                    }
                    else if (enddate >= DateTime.Now && enddate <= dtUpcoming)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "医疗器械经营企业许可证", dt5.Rows[0]["Column1"].ToString(), dt5.Rows[0]["Column2"].ToString(), "即将过期");
                    }
                }

                //药品经营许可证
                DataTable dt6 = BinddtValues.Clone();
                DataRow[] dr6 = BinddtValues.Select("ModleID='0DFC3D5B-9C5C-44FE-8CB9-7D8F90041FA0'");
                foreach (DataRow row in dr6)
                {
                    dt6.Rows.Add(row.ItemArray);
                }
                if (dt6.Rows.Count > 0 && !dt6.Rows[0]["Column2"].ToString().Equals(""))
                {

                    DateTime enddate = Convert.ToDateTime(dt6.Rows[0]["Column2"].ToString());
                    DateTime dtUpcoming = DateTime.Now.AddDays(WarningDays);
                    if (enddate < DateTime.Now)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "药品经营许可证", dt6.Rows[0]["Column1"].ToString(), dt6.Rows[0]["Column2"].ToString(), "已过期");
                    }
                    else if (enddate >= DateTime.Now && enddate <= dtUpcoming)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "药品经营许可证", dt6.Rows[0]["Column1"].ToString(), dt6.Rows[0]["Column2"].ToString(), "即将过期");
                    }
                }

                //危险化学品经营许可证
                DataTable dt7 = BinddtValues.Clone();
                DataRow[] dr7 = BinddtValues.Select("ModleID='132610D9-5B26-4EA0-8BB5-144DD55EF2DF'");
                foreach (DataRow row in dr7)
                {
                    dt7.Rows.Add(row.ItemArray);
                }
                if (dt7.Rows.Count > 0 && !dt7.Rows[0]["Column2"].ToString().Equals(""))
                {

                    DateTime enddate = Convert.ToDateTime(dt7.Rows[0]["Column2"].ToString());
                    DateTime dtUpcoming = DateTime.Now.AddDays(WarningDays);
                    if (enddate < DateTime.Now)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "危险化学品经营许可证", dt7.Rows[0]["Column1"].ToString(), dt7.Rows[0]["Column2"].ToString(), "已过期");
                    }
                    else if (enddate >= DateTime.Now && enddate <= dtUpcoming)
                    {
                        dtBind.Rows.Add(Guid.NewGuid(), "危险化学品经营许可证", dt7.Rows[0]["Column1"].ToString(), dt7.Rows[0]["Column2"].ToString(), "即将过期");
                    }
                }

                if (dtBind.Rows.Count > 0)
                {
                    string sql = "1=1 ";
                    if (!this.tb_LicenseName.Text.Equals(""))
                    {
                        sql += "and Name like '%" + this.tb_LicenseName.Text + "%'";
                    }
                    DataTable NewdtBind = dtBind.Clone();
                    DataRow[] dr = dtBind.Select(sql);
                    foreach (DataRow row in dr)
                    {
                        NewdtBind.Rows.Add(row.ItemArray);
                    }
                    this.Store_Warning.DataSource = NewdtBind;
                    this.Store_Warning.DataBind();
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
                    DataRow[] dr1 = dt.Select("ModleName='企业法人营业执照' and ArchiveType=2 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='企业组织机构代码证' and ArchiveType=2 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='税务登记证（国税）' and ArchiveType=2 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='税务登记证（地税）' and ArchiveType=2 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='医疗器械经营企业许可证' and ArchiveType=2 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='药品经营许可证' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex6.DataSource = dt2;
                    this.StoreAnnex6.DataBind();
                }
            }
        }
        protected void Annex7_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='危险化学品经营许可证' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex7.DataSource = dt2;
                    this.StoreAnnex7.DataBind();
                }
            }
        }
        protected void Annex8_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='提醒及警告' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex8.DataSource = dt2;
                    this.StoreAnnex8.DataBind();
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
                    DataRow[] dr1 = dt.Select("ModleName='企业法人营业执照' and ArchiveType=1 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='企业组织机构代码证' and ArchiveType=1 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='税务登记证（国税）' and ArchiveType=1 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='税务登记证（地税）' and ArchiveType=1 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='医疗器械经营企业许可证' and ArchiveType=1 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='药品经营许可证' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore6.DataSource = dt2;
                    this.LinkStore6.DataBind();
                }
            }
        }
        protected void Link7_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='危险化学品经营许可证' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore7.DataSource = dt2;
                    this.LinkStore7.DataBind();
                }
            }
        }
        protected void Link8_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtAllLink"] != null)
            {
                DataTable dt = Session["dtAllLink"] as DataTable;
                if (dt.Rows.Count > 0)
                {
                    DataTable dt2 = dt.Clone();
                    DataRow[] dr2 = dt.Select("ModleName='提醒及警告' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore8.DataSource = dt2;
                    this.LinkStore8.DataBind();
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
            obj.Add("ParentModleID", "2E4E184B-553F-4BE9-A554-0E6077A1AAB2");
            DataTable dt = DpRightService.GetSecondClassPermissions(obj).Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string Getvalue = dt.Rows[i]["ModleID"].ToString();
                if (Getvalue.Trim().ToUpper() == "D451C1BA-4190-44C5-9AE7-965558A70BA5")
                {
                    this.Tab1.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "73BA1756-DA4B-4253-923F-6302A4F41304")
                {
                    this.Tab2.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "89EF7DDA-DCF5-46BC-B3FB-602D088FE625")
                {
                    this.Tab3.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "07D60118-B5C9-4EE8-9A55-48F429D06191")
                {
                    this.Tab4.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "38F77606-2B36-4E7F-964D-7BA36D8F1510")
                {
                    this.Tab5.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "0DFC3D5B-9C5C-44FE-8CB9-7D8F90041FA0")
                {
                    this.Tab6.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "132610D9-5B26-4EA0-8BB5-144DD55EF2DF")
                {
                    this.Tab7.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "C3D38B01-EB85-436F-AA57-55D8CCD2AFC6")
                {
                    this.Tab8.Hidden = false;
                }
            }
        }
        #endregion
    }
}
