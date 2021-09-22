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
    public partial class Child_BasicInfo : BasePage
    {
        #region 公共
        DataTable SecondClass;
        DataTable DealerGridDataAll;
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
                BindSecondDisGrid();
                BindAboutDisGrid();
                BindCoopDepGrid();
                GetAllLink();

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
                param.Add("ParentModleID", "92dfff9e-099e-494b-970d-5ffc42efeb75");
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

                // SecondClass = detailDS.Tables[0];
                DealerGridDataAll = detailDS.Tables[0];
                BinddtValues = detailDS.Tables[1];
                AllLink = detailDS.Tables[2];


                //SecondClass = dpModuleService.GetModuleSecondByPMID("92dfff9e-099e-494b-970d-5ffc42efeb75").Tables[0];
                //ContentAll = dpContentService.GetSecondClassContentByPMID("92dfff9e-099e-494b-970d-5ffc42efeb75").Tables[0];
                //SystemDpContentAdd = dpContentService.GetSystemDpContentAddByPMID("92dfff9e-099e-494b-970d-5ffc42efeb75").Tables[0];
                //GetAllLink = dpArchiveService.GetDpArchiveByPMID(param).Tables[0];
                //GridMappingAll = dpContentService.GetGridMappingByPMID("92dfff9e-099e-494b-970d-5ffc42efeb75").Tables[0];
                //DealerGridDataAll = dmService.GetDealerGridDataByPMID(param).Tables[0];
                //BinddtContent = dpContentService.GetDPContentWithColumnByPMID("92dfff9e-099e-494b-970d-5ffc42efeb75").Tables[0];
                //BinddtValues = dmService.GetDealerLatestDataByPMID(param).Tables[0];

            }


        }

        #region 绑定非列表小类页面数据
        private void BindPageDate()
        {
            DataTable dtBase = BinddtValues.Clone();
            DataRow[] drBase = BinddtValues.Select("ModleID='8DEB68F1-CCB8-4248-BEED-FF4F67759F80'");
            foreach (DataRow row in drBase)
            {
                dtBase.Rows.Add(row.ItemArray);
            }

            if (dtBase.Rows.Count > 0)
            {
                this.tfEName.Text = dtBase.Rows[0]["Column1"].ToString();
                this.tfCpCode.Text = dtBase.Rows[0]["Column4"].ToString();
                this.tfAddress.Text = dtBase.Rows[0]["Column7"].ToString();
                this.tfDisType.Text = dtBase.Rows[0]["Column2"].ToString();
                this.tfProvince.Text = dtBase.Rows[0]["Column5"].ToString();
                this.tfCoopType.Text = dtBase.Rows[0]["Column3"].ToString();
                this.tfCity.Text = dtBase.Rows[0]["Column6"].ToString();
            }
        }

        #endregion

        #region 获取各列表小类数据
        //存储二级经销商
        private void BindSecondDisGrid()
        {
            DataTable dtSecondDis = DealerGridDataAll.Clone();
            DataRow[] drSecondDis = DealerGridDataAll.Select("ModleName='二级经销商信息'");
            foreach (DataRow row in drSecondDis)
            {
                dtSecondDis.Rows.Add(row.ItemArray);
            }
            Session["dtSecondDis"] = dtSecondDis;

            //this.Store_SCDealer.DataSource = dtSecondDis;
            //this.Store_SCDealer.DataBind();

        }
        //存储关联经销商
        private void BindAboutDisGrid()
        {
            DataTable dtAboutDis = DealerGridDataAll.Clone();
            DataRow[] drAboutDis = DealerGridDataAll.Select("ModleName='关联经销商信息'");
            foreach (DataRow row in drAboutDis)
            {
                dtAboutDis.Rows.Add(row.ItemArray);
            }
            Session["dtBindAboutDis"] = dtAboutDis;
        }

        //存储合作业务部门
        private void BindCoopDepGrid()
        {
            DataTable dtBindCoopDep = DealerGridDataAll.Clone();
            DataRow[] drBindCoopDep = DealerGridDataAll.Select("ModleName='合作业务部门'");
            foreach (DataRow row in drBindCoopDep)
            {
                dtBindCoopDep.Rows.Add(row.ItemArray);
            }
            Session["dtBindCoopDep"] = dtBindCoopDep;
        }

        //存储附件链接
        private void GetAllLink()
        {
            Session["dtAllLink"] = AllLink;
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
                    DataRow[] dr1 = dt.Select("ModleName='主要信息' and ArchiveType=1 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='二级经销商信息' and ArchiveType=1 ");
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
                    DataTable dt3 = dt.Clone();
                    DataRow[] dr3 = dt.Select("ModleName='关联经销商信息' and ArchiveType=1 ");
                    foreach (DataRow row in dr3)
                    {
                        dt3.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore3.DataSource = dt3;
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
                    DataTable dt4 = dt.Clone();
                    DataRow[] dr4 = dt.Select("ModleName='合作业务部门' and ArchiveType=1 ");
                    foreach (DataRow row in dr4)
                    {
                        dt4.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore4.DataSource = dt4;
                    this.LinkStore4.DataBind();
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
                    DataRow[] dr1 = dt.Select("ModleName='主要信息' and ArchiveType=2 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='二级经销商信息' and ArchiveType=2 ");
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
                    DataTable dt3 = dt.Clone();
                    DataRow[] dr3 = dt.Select("ModleName='关联经销商信息' and ArchiveType=2 ");
                    foreach (DataRow row in dr3)
                    {
                        dt3.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex3.DataSource = dt3;
                    this.StoreAnnex3.DataBind();
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
                    DataTable dt4 = dt.Clone();
                    DataRow[] dr4 = dt.Select("ModleName='合作业务部门' and ArchiveType=2 ");
                    foreach (DataRow row in dr4)
                    {
                        dt4.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex4.DataSource = dt4;
                    this.StoreAnnex4.DataBind();
                }
            }
        }
        #endregion

        #region 绑定列表小类数据
        protected void Store_FranchiseRefresh(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtSecondDis"] != null)
            {
                DataTable dt = Session["dtSecondDis"] as DataTable;

                DataTable dtFranchise = new DataTable();
                dtFranchise.Columns.Add("Franchise");
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        DataTable dtFranchiseCheck = dtFranchise.Clone();
                        DataRow[] drFranchiseCheck = dtFranchise.Select("Franchise = '" + dt.Rows[i]["Column1"].ToString() + "' ");
                        foreach (DataRow row in drFranchiseCheck)
                        {
                            dtFranchiseCheck.Rows.Add(row.ItemArray);
                        }

                        if (dtFranchiseCheck.Rows.Count == 0)
                        {
                            dtFranchise.Rows.Add(dt.Rows[i]["Column1"].ToString());
                        }
                    }
                }
                this.cbFranchise.Items.Clear();
                this.FranchiseStore.DataSource = dtFranchise;
                this.FranchiseStore.DataBind();
            }
        }
        protected void Store_BuRefresh(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtSecondDis"] != null)
            {
                DataTable dt = Session["dtSecondDis"] as DataTable;

                DataTable dtBu = new DataTable();
                dtBu.Columns.Add("Bu");
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        DataTable dtFranchiseCheck = dtBu.Clone();
                        DataRow[] drFranchiseCheck = dtBu.Select("Bu = '" + dt.Rows[i]["Column2"].ToString() + "' ");
                        foreach (DataRow row in drFranchiseCheck)
                        {
                            dtFranchiseCheck.Rows.Add(row.ItemArray);
                        }

                        if (dtFranchiseCheck.Rows.Count == 0)
                        {
                            dtBu.Rows.Add(dt.Rows[i]["Column2"].ToString());
                        }
                    }
                }
                this.cbBu.Items.Clear();
                this.BuStore.DataSource = dtBu;
                this.BuStore.DataBind();
            }
        }
        protected void SCDealer_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(cbFranchise.SelectedItem.Value))
            {
                sql += "and Column1='" + cbFranchise.SelectedItem.Value + "'";
            }
            if (!string.IsNullOrEmpty(cbBu.SelectedItem.Value))
            {
                sql += "and Column2='" + cbBu.SelectedItem.Value + "'";
            }

            if (Session["dtSecondDis"] != null)
            {
                DataTable dt = Session["dtSecondDis"] as DataTable;
                DataTable dtSCDealer = dt.Clone();
                DataRow[] drSCDealer = dt.Select(sql);
                foreach (DataRow row in drSCDealer)
                {
                    dtSCDealer.Rows.Add(row.ItemArray);
                }
                this.Store_SCDealer.DataSource = dtSCDealer;
                this.Store_SCDealer.DataBind();
            }
        }

        protected void AboutDis_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(this.tfDisName.Text))
            {
                sql += "and Column2='" + this.tfDisName.Text + "'";
            }
            if (!this.FromDate.IsNull)
            {
                sql += "and Column3 >='" + this.FromDate.SelectedDate.ToString("yyyyMMdd") + "'";
            }
            if (!this.ToDate.IsNull)
            {
                sql += "and Column4 <='" + this.ToDate.SelectedDate.ToString("yyyyMMdd") + "'";
            }

            if (Session["dtBindAboutDis"] != null)
            {
                DataTable dt = Session["dtBindAboutDis"] as DataTable;
                DataTable dtAboutDis = dt.Clone();
                DataRow[] drAboutDis = dt.Select(sql);
                foreach (DataRow row in drAboutDis)
                {
                    dtAboutDis.Rows.Add(row.ItemArray);
                }
                this.Store_AboutDis.DataSource = dtAboutDis;
                this.Store_AboutDis.DataBind();
            }
        }

        protected void Store_CoopFranchiseRefresh(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtBindCoopDep"] != null)
            {
                DataTable dt = Session["dtBindCoopDep"] as DataTable;

                DataTable dtFranchise = new DataTable();
                dtFranchise.Columns.Add("Franchise");
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        DataTable dtFranchiseCheck = dtFranchise.Clone();
                        DataRow[] drFranchiseCheck = dtFranchise.Select("Franchise = '" + dt.Rows[i]["Column1"].ToString() + "' ");
                        foreach (DataRow row in drFranchiseCheck)
                        {
                            dtFranchiseCheck.Rows.Add(row.ItemArray);
                        }

                        if (dtFranchiseCheck.Rows.Count == 0)
                        {
                            dtFranchise.Rows.Add(dt.Rows[i]["Column1"].ToString());
                        }
                    }
                }
                this.cbCoopFranchise.Items.Clear();
                this.StoreCoopFranch.DataSource = dtFranchise;
                this.StoreCoopFranch.DataBind();
            }
        }
        protected void Store_CoopBuRefresh(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtBindCoopDep"] != null)
            {
                DataTable dt = Session["dtBindCoopDep"] as DataTable;

                DataTable dtBu = new DataTable();
                dtBu.Columns.Add("Bu");
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        DataTable dtFranchiseCheck = dtBu.Clone();
                        DataRow[] drFranchiseCheck = dtBu.Select("Bu = '" + dt.Rows[i]["Column2"].ToString() + "' ");
                        foreach (DataRow row in drFranchiseCheck)
                        {
                            dtFranchiseCheck.Rows.Add(row.ItemArray);
                        }

                        if (dtFranchiseCheck.Rows.Count == 0)
                        {
                            dtBu.Rows.Add(dt.Rows[i]["Column2"].ToString());
                        }
                    }
                }
                this.cbCoopBu.Items.Clear();
                this.StoreCoopBu.DataSource = dtBu;
                this.StoreCoopBu.DataBind();
            }
        }
        protected void CoopDep_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(cbCoopFranchise.SelectedItem.Value))
            {
                sql += "and Column1='" + cbCoopFranchise.SelectedItem.Value + "'";
            }
            if (!string.IsNullOrEmpty(cbCoopBu.SelectedItem.Value))
            {
                sql += "and Column2='" + cbCoopBu.SelectedItem.Value + "'";
            }

            if (Session["dtBindCoopDep"] != null)
            {
                DataTable dt = Session["dtBindCoopDep"] as DataTable;
                DataTable dtCoopDep = dt.Clone();
                DataRow[] drCoopDep = dt.Select(sql);
                foreach (DataRow row in drCoopDep)
                {
                    dtCoopDep.Rows.Add(row.ItemArray);
                }
                this.Store_CoopDep.DataSource = dtCoopDep;
                this.Store_CoopDep.DataBind();
            }
        }


        #endregion

        #region 导出列表小类数据

        protected void Store_SCDealer_Submit(object sender, StoreSubmitDataEventArgs e)
        {
            XmlNode xml = e.Xml;

            this.Response.Clear();
            this.Response.ContentType = "application/vnd.ms-excel";
            this.Response.AddHeader("Content-Disposition", "attachment;filename=SCDealer.xls");
            XslCompiledTransform xtExcel = new XslCompiledTransform();
            xtExcel.Load(Server.MapPath("Excel.xsl"));
            xtExcel.Transform(xml, null, Response.OutputStream);
            this.Response.End();

        }

        protected void Store_AboutDis_Submit(object sender, StoreSubmitDataEventArgs e)
        {
            XmlNode xml = e.Xml;

            this.Response.Clear();
            this.Response.ContentType = "application/vnd.ms-excel";
            this.Response.AddHeader("Content-Disposition", "attachment;filename=AboutDis.xls");
            XslCompiledTransform xtExcel = new XslCompiledTransform();
            xtExcel.Load(Server.MapPath("ExcelAboutDis.xsl"));
            xtExcel.Transform(xml, null, Response.OutputStream);
            this.Response.End();

        }

        protected void Store_CoopDep_Submit(object sender, StoreSubmitDataEventArgs e)
        {
            XmlNode xml = e.Xml;

            this.Response.Clear();
            this.Response.ContentType = "application/vnd.ms-excel";
            this.Response.AddHeader("Content-Disposition", "attachment;filename=CoopDep.xls");
            XslCompiledTransform xtExcel = new XslCompiledTransform();
            xtExcel.Load(Server.MapPath("ExcelCoopDep.xsl"));
            xtExcel.Transform(xml, null, Response.OutputStream);
            this.Response.End();

        }

        #endregion

        #region 判断权限
        private void GetPermissions()
        {
            IRoleModelContext context = RoleModelContext.Current;
            LoginUser user = context.User;
            Hashtable obj = new Hashtable();
            obj.Add("Roles", user.Roles);
            obj.Add("ParentModleID", "92dfff9e-099e-494b-970d-5ffc42efeb75");
            DataTable dt = DpRightService.GetSecondClassPermissions(obj).Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string Getvalue = dt.Rows[i]["ModleID"].ToString();
                if (Getvalue.Trim().ToUpper() == "8DEB68F1-CCB8-4248-BEED-FF4F67759F80")
                {
                    this.Tab1.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "75D85CA3-1DE9-43C4-981C-89114D7D38C6")
                {
                    this.Tab2.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "1F30DA82-7393-40D3-8950-5E0A5EADBDA6")
                {
                    this.Tab3.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "A958AF3A-485D-4676-89C0-EA63BB8986A1")
                {
                    this.Tab4.Hidden = false;
                }
            }
        }
        #endregion

    }
}
