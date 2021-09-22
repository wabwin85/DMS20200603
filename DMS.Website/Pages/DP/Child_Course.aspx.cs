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
    public partial class Child_Course : BasePage
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
                BindCourseGrid();

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
                param.Add("ParentModleID", "C7DA827F-11E8-4661-9CD7-01C549DCE034");
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
                // BinddtValues = detailDS.Tables[1];
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
        private void BindCourseGrid()
        {
            DataTable dtCourse = DealerGridDataAll.Clone();
            DataRow[] drCourse = DealerGridDataAll.Select("ModleName='培训记录'");
            foreach (DataRow row in drCourse)
            {
                dtCourse.Rows.Add(row.ItemArray);
            }
            Session["dtCourse"] = dtCourse;
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
                    DataRow[] dr1 = dt.Select("ModleName='培训记录' and ArchiveType=1 ");
                    foreach (DataRow row in dr1)
                    {
                        dt1.Rows.Add(row.ItemArray);
                    }
                    this.LinkStore1.DataSource = dt1;
                    this.LinkStore1.DataBind();
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
                    DataRow[] dr1 = dt.Select("ModleName='培训记录' and ArchiveType=2 ");
                    foreach (DataRow row in dr1)
                    {
                        dt1.Rows.Add(row.ItemArray);
                    }
                    this.StoreAnnex1.DataSource = dt1;
                    this.StoreAnnex1.DataBind();
                }
            }
        }
        #endregion

        #region 绑定列表小类数据
        protected void Store_CourseTypeRefresh(object sender, StoreRefreshDataEventArgs e)
        {
            if (Session["dtCourse"] != null)
            {
                DataTable dt = Session["dtCourse"] as DataTable;

                DataTable dtType = new DataTable();
                dtType.Columns.Add("Type");
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        DataTable dtTypeCheck = dtType.Clone();
                        DataRow[] drTypeCheck = dtType.Select("Type = '" + dt.Rows[i]["Column4"].ToString() + "' ");
                        foreach (DataRow row in drTypeCheck)
                        {
                            dtTypeCheck.Rows.Add(row.ItemArray);
                        }

                        if (dtTypeCheck.Rows.Count == 0)
                        {
                            dtType.Rows.Add(dt.Rows[i]["Column4"].ToString());
                        }
                    }
                }
                this.cbDep.Items.Clear();
                this.StoreCourseType.DataSource = dtType;
                this.StoreCourseType.DataBind();
            }
        }

        protected void Course_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string sql = " 1=1 ";
            if (!string.IsNullOrEmpty(tfBegin.Text))
            {
                sql += "and Column2  > '" + this.tfBegin.Text + "'";
            }
            if (!string.IsNullOrEmpty(tfEnd.Text))
            {
                sql += "and Column2   <=  '" + this.tfEnd.Text + "'";
            }
            if (!string.IsNullOrEmpty(tfName.Text))
            {
                sql += "and Column1 like '%" + this.tfName.Text + "%'";
            }
            if (!string.IsNullOrEmpty(cbDep.SelectedItem.Value))
            {
                sql += "and Column4 ='" + cbDep.SelectedItem.Value + "'";
            }

            if (Session["dtCourse"] != null)
            {
                DataTable dt = Session["dtCourse"] as DataTable;
                DataTable dtCourse = dt.Clone();
                DataRow[] drCourse = dt.Select(sql);
                foreach (DataRow row in drCourse)
                {
                    dtCourse.Rows.Add(row.ItemArray);
                }
                this.Store_Course.DataSource = dtCourse;
                this.Store_Course.DataBind();
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
            obj.Add("ParentModleID", "C7DA827F-11E8-4661-9CD7-01C549DCE034");
            DataTable dt = DpRightService.GetSecondClassPermissions(obj).Tables[0];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string Getvalue = dt.Rows[i]["ModleID"].ToString();
                if (Getvalue.Trim().ToUpper() == "F0583C1B-F80E-45E0-9E87-C1A621B75851")
                {
                    this.Tab1.Hidden = false;
                }
            }
        }
        #endregion

    }
}
