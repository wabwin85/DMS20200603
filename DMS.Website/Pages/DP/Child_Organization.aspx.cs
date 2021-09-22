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
    public partial class Child_Organization : BasePage
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
                param.Add("ParentModleID", "25E12BC7-275B-4EDB-A356-B02FC7674DCF");
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
            //公司架构
            DataTable dtFramework = BinddtValues.Clone();
            DataRow[] drFramework = BinddtValues.Select("ModleID='1F584B88-D787-47CE-B864-E1826F05EA38'");
            foreach (DataRow row in drFramework)
            {
                dtFramework.Rows.Add(row.ItemArray);
            }

            if (dtFramework.Rows.Count > 0)
            {
                this.Column1.Text = dtFramework.Rows[0]["Column1"].ToString();
                this.Column2.Text = dtFramework.Rows[0]["Column2"].ToString();
                this.Column3.Text = dtFramework.Rows[0]["Column3"].ToString();
                this.Column4.Text = dtFramework.Rows[0]["Column4"].ToString();
                this.Column5.Text = dtFramework.Rows[0]["Column5"].ToString();
                this.Column6.Text = dtFramework.Rows[0]["Column6"].ToString();
                this.Column7.Text = dtFramework.Rows[0]["Column7"].ToString();
                this.Column8.Text = dtFramework.Rows[0]["Column8"].ToString();
                this.Column9.Text = dtFramework.Rows[0]["Column9"].ToString();
                this.Column10.Text = dtFramework.Rows[0]["Column10"].ToString();
                this.Column11.Text = dtFramework.Rows[0]["Column11"].ToString();
                this.Column12.Text = dtFramework.Rows[0]["Column12"].ToString();
                this.Column13.Text = dtFramework.Rows[0]["Column13"].ToString();
                this.Column14.Text = dtFramework.Rows[0]["Column14"].ToString();
                this.Column15.Text = dtFramework.Rows[0]["Column15"].ToString();
                this.Column16.Text = dtFramework.Rows[0]["Column16"].ToString();
                this.Column17.Text = dtFramework.Rows[0]["Column17"].ToString();
                this.Column18.Text = dtFramework.Rows[0]["Column18"].ToString();
                this.Column19.Text = dtFramework.Rows[0]["Column19"].ToString();
                this.Column20.Text = dtFramework.Rows[0]["Column20"].ToString();
                this.Column21.Text = dtFramework.Rows[0]["Column21"].ToString();
                this.Column22.Text = dtFramework.Rows[0]["Column22"].ToString();
                this.Column23.Text = dtFramework.Rows[0]["Column23"].ToString();
                this.Column24.Text = dtFramework.Rows[0]["Column24"].ToString();
                this.Column25.Text = dtFramework.Rows[0]["Column25"].ToString();
                this.Column26.Text = dtFramework.Rows[0]["Column26"].ToString();
                this.Column27.Text = dtFramework.Rows[0]["Column27"].ToString();
                this.Column28.Text = dtFramework.Rows[0]["Column28"].ToString();
                this.Column29.Text = dtFramework.Rows[0]["Column29"].ToString();
                this.Column30.Text = dtFramework.Rows[0]["Column30"].ToString();
                this.Column31.Text = dtFramework.Rows[0]["Column31"].ToString();
                this.Column32.Text = dtFramework.Rows[0]["Column32"].ToString();
                this.Column33.Text = dtFramework.Rows[0]["Column33"].ToString();
                this.Column34.Text = dtFramework.Rows[0]["Column34"].ToString();
                this.Column35.Text = dtFramework.Rows[0]["Column35"].ToString();
                this.Column36.Text = dtFramework.Rows[0]["Column36"].ToString();
                this.Column37.Text = dtFramework.Rows[0]["Column37"].ToString();
                this.Column38.Text = dtFramework.Rows[0]["Column38"].ToString();
                this.Column39.Text = dtFramework.Rows[0]["Column39"].ToString();
                this.Column40.Text = dtFramework.Rows[0]["Column40"].ToString();
                this.Column41.Text = dtFramework.Rows[0]["Column41"].ToString();
                this.Column42.Text = dtFramework.Rows[0]["Column42"].ToString();
                this.Column43.Text = dtFramework.Rows[0]["Column43"].ToString();
                this.Column44.Text = dtFramework.Rows[0]["Column44"].ToString();
                this.Column45.Text = dtFramework.Rows[0]["Column45"].ToString();
                this.Column46.Text = dtFramework.Rows[0]["Column46"].ToString();

            }

            //公司发展方向及经营产品定位
            DataTable dtDevelopment = BinddtValues.Clone();
            DataRow[] drDevelopment = BinddtValues.Select("ModleID='56E8C93A-6CDF-45A8-ADA6-FAD47AF312F3'");
            foreach (DataRow row in drDevelopment)
            {
                dtDevelopment.Rows.Add(row.ItemArray);
            }

            if (dtDevelopment.Rows.Count > 0)
            {
                this.taDeveloping.Text = dtDevelopment.Rows[0]["Column1"].ToString();
                this.taPP.Text = dtDevelopment.Rows[0]["Column2"].ToString();
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
                    DataRow[] dr1 = dt.Select("ModleName='公司架构' and ArchiveType=2 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='公司发展方向与经营产品定位' and ArchiveType=2 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex2.DataSource = dt2;
                    this.StoreAnnex2.DataBind();
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
                    DataRow[] dr1 = dt.Select("ModleName='公司架构' and ArchiveType=1 ");
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
                    DataRow[] dr2 = dt.Select("ModleName='公司发展方向与经营产品定位' and ArchiveType=1 ");
                    foreach (DataRow row in dr2)
                    {
                        dt2.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore2.DataSource = dt2;
                    this.LinkStore2.DataBind();
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
            obj.Add("ParentModleID", "25E12BC7-275B-4EDB-A356-B02FC7674DCF");
            DataTable dt = DpRightService.GetSecondClassPermissions(obj).Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string Getvalue = dt.Rows[i]["ModleID"].ToString();
                if (Getvalue.Trim().ToUpper() == "1F584B88-D787-47CE-B864-E1826F05EA38")
                {
                    this.Tab1.Hidden = false;
                }
                if (Getvalue.Trim().ToUpper() == "56E8C93A-6CDF-45A8-ADA6-FAD47AF312F3")
                {
                    this.Tab2.Hidden = false;
                }
            }
        }
        #endregion

    }
}
