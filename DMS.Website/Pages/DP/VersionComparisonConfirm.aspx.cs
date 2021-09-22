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
    public partial class VersionComparisonConfirm : BasePage
    {
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


        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                if (Request.QueryString["ModleID"] != null && Request.QueryString["UdstrCd"] != null)
                {
                    this.hfUser_Code.Text = Request.QueryString["UdstrCd"].ToString();
                    this.hfModleID.Text = Request.QueryString["ModleID"].ToString();
                }
            }
        }

        protected void Version_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Cust_CD", this.hfUser_Code.Text);
            ht.Add("ParentModleID", this.hfModleID.Text);

            DataSet ds = DealerInfo.GetVersionByCustCD(ht);

            if (ds.Tables[0].Rows.Count == 0)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Version");
                dt.Rows.Add(new object[] { "未维护数据" });
                VersionStore.DataSource = dt;
                VersionStore.DataBind();
            }
            else
            {
                this.ddlVersion.Items.Clear();
                VersionStore.DataSource = ds;
                VersionStore.DataBind();
            }
        }

        protected void VersionComp_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Cust_CD", this.hfUser_Code.Text);
            ht.Add("ParentModleID", this.hfModleID.Text);

            DataSet ds = DealerInfo.GetVersionByCustCD(ht);

            if (ds.Tables[0].Rows.Count == 0)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Version");
                dt.Rows.Add(new object[] { "未维护数据" });
                VersionCompStore.DataSource = dt;
                VersionCompStore.DataBind();
            }
            else
            {
                this.ddlVersion.Items.Clear();
                VersionCompStore.DataSource = ds;
                VersionCompStore.DataBind();
            }
        }

        protected void ComparisonList_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            if (ddlVersion.SelectedItem.Value.Equals("未维护数据") || ddlVersion.SelectedItem.Value.Equals(""))
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "比较出错",
                    Message = "请选择版本！"
                });
                return;
            }
            else
            {
                if (ddlVersionComp.SelectedItem.Value.Equals("未维护数据") || ddlVersionComp.SelectedItem.Value.Equals(""))
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = "比较出错",
                        Message = "请选择比较版本！"
                    });
                    return;
                }
                else
                {

                    IRoleModelContext context = RoleModelContext.Current;
                    LoginUser user = context.User;

                    
                    Hashtable ht = new Hashtable();
                    ht.Add("mCust_CD", this.hfUser_Code.Text);
                    ht.Add("mMainGrpModleID", this.hfModleID.Text);
                    ht.Add("mVersionSrc", this.ddlVersion.SelectedItem.Value);
                    ht.Add("mVersionTag", this.ddlVersionComp.SelectedItem.Value);
                    ht.Add("mUserID", user.Id);
                    ht.Add("mIsValid", null);
                    DataTable dt = DealerInfo.GetVersionComparison(ht).Tables[0];

                    DataTable newdt = new DataTable();
                    newdt.Columns.Add("ID");
                    newdt.Columns.Add("MainGrpModleName");
                    newdt.Columns.Add("MinorGrpModleName");
                    newdt.Columns.Add("ControlName");
                    newdt.Columns.Add("VerSrcValue");
                    newdt.Columns.Add("VerTagValue");
                    newdt.Columns.Add("DiffType");
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (dt.Rows[i]["DiffType"].Equals("UPDATE"))
                        {
                            newdt.Rows.Add(
                            dt.Rows[i]["ID"].ToString(),
                            dt.Rows[i]["MainGrpModleName"].ToString(),
                            dt.Rows[i]["MinorGrpModleName"].ToString(),
                            dt.Rows[i]["ControlName"].ToString(),

                             "<span style='width:100%; background:#00EC00; display:block';><font color='#000000'>" + dt.Rows[i]["VerSrcValue"].ToString() + "</font></span>",
                             "<span style='width:100%; background:#00EC00; display:block';><font color='#000000'>" + dt.Rows[i]["VerTagValue"].ToString() + "</font></span>",
                            dt.Rows[i]["DiffType"].ToString());
                        }
                        if (dt.Rows[i]["DiffType"].Equals("NOCHANGE"))
                        {

                            newdt.Rows.Add(
                            dt.Rows[i]["ID"].ToString(),
                            dt.Rows[i]["MainGrpModleName"].ToString(),
                            dt.Rows[i]["MinorGrpModleName"].ToString(),
                            dt.Rows[i]["ControlName"].ToString(),
                            dt.Rows[i]["VerSrcValue"].ToString(),
                            dt.Rows[i]["VerTagValue"].ToString(),
                            dt.Rows[i]["DiffType"].ToString()
                             );
                        }
                        if (dt.Rows[i]["DiffType"].Equals("DELETE"))
                        {
                            newdt.Rows.Add(
                            dt.Rows[i]["ID"].ToString(),
                            dt.Rows[i]["MainGrpModleName"].ToString(),
                            dt.Rows[i]["MinorGrpModleName"].ToString(),
                            dt.Rows[i]["ControlName"].ToString(),

                              "<span style='width:100%; background:#FF0000; display:block';><font color='#000000'>" + dt.Rows[i]["VerSrcValue"].ToString() + "</font></span>",
                              "<span style='width:100%; background:#FF0000; display:block';><font color='#000000'>" + dt.Rows[i]["VerTagValue"].ToString() + "</font></span>",
                             dt.Rows[i]["DiffType"].ToString()
                             );
                        }
                        if (dt.Rows[i]["DiffType"].Equals("ADD"))
                        {
                            newdt.Rows.Add(
                             dt.Rows[i]["ID"].ToString(),
                             dt.Rows[i]["MainGrpModleName"].ToString(),
                             dt.Rows[i]["MinorGrpModleName"].ToString(),
                             dt.Rows[i]["ControlName"].ToString(),

                             "<span style='width:100%; background:#66B3FF; display:block'><font color='#000000'>" + dt.Rows[i]["VerSrcValue"].ToString() + "</font></span>",
                             "<span style='width:100%; background:#66B3FF; display:block'><font color='#000000'>" + dt.Rows[i]["VerTagValue"].ToString() + "</font></span>",
                             dt.Rows[i]["DiffType"].ToString()
                             );
                        }
                    }

                    this.ComparisonListStore.DataSource = newdt;
                    this.ComparisonListStore.DataBind();
                }
            }

        }
    }
}
