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
using System.Xml;
using System.Xml.Xsl;
using Microsoft.Practices.Unity;
using DMS.Business.DP;


namespace DMS.Website.Pages.DP
{
    public partial class DealerMaster : BasePage
    {
        #region 公共

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
                if (Request.QueryString["Dearid"] == null && Request.QueryString["UdstrCd"] == null)
                {
                    //throw new Exception("请选择查看经销商");
                    //ClientScript.RegisterClientScriptBlock(typeof(Page), new Guid().ToString(), "alert('请选择查看经销商！');window.opener=null;window.close();", true);
                }
                else
                {
                    this.hfDearId.Value = Request.QueryString["Dearid"].ToString();
                    this.hfUdstrCd.Value = Request.QueryString["UdstrCd"].ToString();
                    DataTable dt = DealerInfo.GetDealerNameByID(this.hfDearId.Value.ToString()).Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        this.Panel_Body.Title = "经销商综合信息查询—" + dt.Rows[0]["DMA_ChineseName"].ToString();
                    }
                }
                GetFModulePermissions();

                //根据权限判断PageLode加载页面
                PageLodeBindChildPage();

            }
        }

        protected void Store_VersionList(object sender, StoreRefreshDataEventArgs e)
        {
            BindVersion();
        }

        [AjaxMethod]
        public void OnSelectIndexChanged()
        {
            try
            {
                if (this.hfParentModleID.Value.Equals("92DFFF9E-099E-494B-970D-5FFC42EFEB75"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_BasicInfo.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }
                if (this.hfParentModleID.Value.Equals("25E12BC7-275B-4EDB-A356-B02FC7674DCF"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Organization.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }

                if (this.hfParentModleID.Value.Equals("1E5AFB22-133F-45A0-A153-C07CEF492E24"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_DandB.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }
                if (this.hfParentModleID.Value.Equals("2E4E184B-553F-4BE9-A554-0E6077A1AAB2"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Certificate.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }
                if (this.hfParentModleID.Value.Equals("B9474B90-5636-4E73-8DB1-79E9925646A6"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Rename.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }
                if (this.hfParentModleID.Value.Equals("90A5C181-A46E-4B8F-8D78-289808EF96B7"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Contract.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }
                if (this.hfParentModleID.Value.Equals("00D8ED6D-5C9F-4FFB-B070-24D6755CA285"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_KPI.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }
                if (this.hfParentModleID.Value.Equals("C7DA827F-11E8-4661-9CD7-01C549DCE034"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Course.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }

                if (this.hfParentModleID.Value.Equals("387DAF1C-BB30-432A-9015-C94460DB4CDF"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Award.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }
                if (this.hfParentModleID.Value.Equals("7F71492E-42A4-49E7-8555-09CE35A065AA"))
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Audit.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value + "&Version=" + this.ddlVersion.SelectedItem.Value;
                }


                this.TabPanel1.LoadContent();

            }
            catch (Exception e)
            {
                Coolite.Ext.Web.ScriptManager.AjaxSuccess = false;
                Coolite.Ext.Web.ScriptManager.AjaxErrorMessage = e.Message;
            }
        }

        private void BindVersion()
        {
            Hashtable ht = new Hashtable();
            ht.Add("Cust_CD", this.hfDearId.Value);
            ht.Add("ParentModleID", this.hfParentModleID.Value);

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


        public void Button_Click(object sender, EventArgs e)
        {
            Coolite.Ext.Web.LinkButton button = (Coolite.Ext.Web.LinkButton)sender;
            if (button.ID == "Button1")
            {
                this.TabPanel1.AutoLoad.Url = "Child_BasicInfo.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>常用信息-版本：</b>";
                this.hfParentModleID.Value = "92DFFF9E-099E-494B-970D-5FFC42EFEB75";

            }
            if (button.ID == "Button2")
            {
                this.TabPanel1.AutoLoad.Url = "Child_Organization.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;


                this.ttiVersion.Text = "<b>架构发展-版本：</b>";

                this.hfParentModleID.Value = "25E12BC7-275B-4EDB-A356-B02FC7674DCF";


            }
            if (button.ID == "Button3")
            {
                this.TabPanel1.AutoLoad.Url = "Child_DandB.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>邓白氏信息-版本：</b>";
                this.hfParentModleID.Value = "1E5AFB22-133F-45A0-A153-C07CEF492E24";
            }
            if (button.ID == "Button4")
            {
                this.TabPanel1.AutoLoad.Url = "Child_Certificate.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>证照信息-版本：</b>";

                this.hfParentModleID.Value = "2E4E184B-553F-4BE9-A554-0E6077A1AAB2";

            }
            if (button.ID == "Button5")
            {
                this.TabPanel1.AutoLoad.Url = "Child_Rename.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>更名记录-版本：</b>";

                this.hfParentModleID.Value = "B9474B90-5636-4E73-8DB1-79E9925646A6";

            }
            if (button.ID == "Button6")
            {
                this.TabPanel1.AutoLoad.Url = "Child_Contract.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>合同信息-版本：</b>";
                this.hfParentModleID.Value = "90A5C181-A46E-4B8F-8D78-289808EF96B7";

            }
            if (button.ID == "Button7")
            {
                this.TabPanel1.AutoLoad.Url = "Child_KPI.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>关键绩效-版本：</b>";
                this.hfParentModleID.Value = "00D8ED6D-5C9F-4FFB-B070-24D6755CA285";

            }
            if (button.ID == "Button8")
            {
                this.TabPanel1.AutoLoad.Url = "Child_Course.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>培训记录-版本：</b>";
                this.hfParentModleID.Value = "C7DA827F-11E8-4661-9CD7-01C549DCE034";

            }
            if (button.ID == "Button9")
            {
                this.TabPanel1.AutoLoad.Url = "Child_Award.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>奖惩记录-版本：</b>";
                this.hfParentModleID.Value = "387DAF1C-BB30-432A-9015-C94460DB4CDF";

            }
            if (button.ID == "Button10")
            {
                this.TabPanel1.AutoLoad.Url = "Child_Audit.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.ttiVersion.Text = "<b>审计记录-版本：</b>";
                this.hfParentModleID.Value = "7F71492E-42A4-49E7-8555-09CE35A065AA";

            }
            //this.TabPanel1.Reload();
            this.TabPanel1.LoadContent();

            BindVersion();
        }

        protected void BtVersion_Click(object sender, AjaxEventArgs e)
        {
            string modleID = this.hfParentModleID.Text;
            //PageContext.RegisterStartupScript(WindowVersion.GetShowReference("../VersionComparisonConfirm.aspx?ModleID=" + this.hfModleID.Text + "&UdstrCd=" + this.hfUser_code.Text));
            WindowComparisonConfirm.AutoLoad.Url = "VersionComparisonConfirm.aspx?ModleID=" + this.hfParentModleID.Text + "&UdstrCd=" + this.hfDearId.Text;
            this.WindowComparisonConfirm.LoadContent();
            this.WindowComparisonConfirm.Show();

        }

        private void PageLodeBindChildPage()
        {
            if (this.Button1.Hidden == true)
            {
                if (this.Button2.Hidden == true)
                {
                    if (this.Button3.Hidden == true)
                    {
                        if (this.Button4.Hidden == true)
                        {
                            if (this.Button5.Hidden == true)
                            {
                                if (this.Button6.Hidden == true)
                                {
                                    if (this.Button8.Hidden == true)
                                    {
                                        if (this.Button9.Hidden == true)
                                        {
                                            if (this.Button10.Hidden == true)
                                            {
                                                Ext.Msg.Alert("出错", "请联系管理员分配访问权限");
                                            }
                                            else
                                            {
                                                this.TabPanel1.AutoLoad.Url = "Child_Audit.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                                                this.ttiVersion.Text = "<b>审计记录-版本：</b>";
                                                this.hfParentModleID.Value = "25E12BC7-275B-4EDB-A356-B02FC7674DCF";
                                            }
                                        }
                                        else
                                        {
                                            this.TabPanel1.AutoLoad.Url = "Child_Award.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                                            this.ttiVersion.Text = "<b>奖惩记录-版本：</b>";
                                            this.hfParentModleID.Value = "B9474B90-5636-4E73-8DB1-79E9925646A6";
                                        }
                                    }
                                    else
                                    {
                                        this.TabPanel1.AutoLoad.Url = "Child_Course.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                                        this.ttiVersion.Text = "<b>培训记录-版本：</b>";
                                        this.hfParentModleID.Value = "90A5C181-A46E-4B8F-8D78-289808EF96B7";
                                    }
                                }
                                else
                                {
                                    this.TabPanel1.AutoLoad.Url = "Child_Contract.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                                    this.ttiVersion.Text = "<b>合同信息-版本：</b>";
                                    this.hfParentModleID.Value = "1E5AFB22-133F-45A0-A153-C07CEF492E24";
                                }
                            }
                            else
                            {
                                this.TabPanel1.AutoLoad.Url = "Child_Rename.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                                this.ttiVersion.Text = "<b>更名记录-版本：</b>";

                                this.hfParentModleID.Value = "92DFFF9E-099E-494B-970D-5FFC42EFEB75";
                            }
                        }
                        else
                        {
                            this.TabPanel1.AutoLoad.Url = "Child_Certificate.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                            this.ttiVersion.Text = "<b>证照信息-版本：</b>";

                            this.hfParentModleID.Value = "00D8ED6D-5C9F-4FFB-B070-24D6755CA285";
                        }
                    }
                    else
                    {
                        this.TabPanel1.AutoLoad.Url = "Child_DandB.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                        this.ttiVersion.Text = "<b>邓白氏信息-版本：</b>";
                        this.hfParentModleID.Value = "2E4E184B-553F-4BE9-A554-0E6077A1AAB2";
                    }
                }
                else
                {
                    this.TabPanel1.AutoLoad.Url = "Child_Organization.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;
                    this.ttiVersion.Text = "<b>架构发展-版本：</b>";
                    this.hfParentModleID.Value = "7F71492E-42A4-49E7-8555-09CE35A065AA";
                }
            }
            else
            {
                this.TabPanel1.AutoLoad.Url = "Child_BasicInfo.aspx?UdstrCd=" + this.hfUdstrCd.Value + "&UdstrID=" + this.hfDearId.Value;

                this.hfParentModleID.Value = "C7DA827F-11E8-4661-9CD7-01C549DCE034";
                this.ttiVersion.Text = "<b>常用信息-版本：</b>";
            }
        }
        private void GetFModulePermissions()
        {
            IRoleModelContext context = RoleModelContext.Current;
            LoginUser user = context.User;
            Hashtable obj = new Hashtable();
            obj.Add("Roles", user.Roles);
            DataTable dt = DpRightService.GetFristClassPermissions(obj).Tables[0];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (dt.Rows[i]["PID"].ToString().Equals("C7DA827F-11E8-4661-9CD7-01C549DCE034"))
                    {
                        this.Button1.Hidden = false;
                    }
                    if (dt.Rows[i]["PID"].ToString().Equals("7F71492E-42A4-49E7-8555-09CE35A065AA"))
                    {
                        this.Button2.Hidden = false;
                    }
                    if (dt.Rows[i]["PID"].ToString().Equals("2E4E184B-553F-4BE9-A554-0E6077A1AAB2"))
                    {
                        this.Button3.Hidden = false;
                    }
                    if (dt.Rows[i]["PID"].ToString().Equals("00D8ED6D-5C9F-4FFB-B070-24D6755CA285"))
                    {
                        this.Button4.Hidden = false;
                    }
                    if (dt.Rows[i]["PID"].ToString().Equals("92DFFF9E-099E-494B-970D-5FFC42EFEB75"))
                    {
                        this.Button5.Hidden = false;
                    }
                    if (dt.Rows[i]["PID"].ToString().Equals("1E5AFB22-133F-45A0-A153-C07CEF492E24"))
                    {
                        this.Button6.Hidden = false;
                    }
                    //if (dt.Rows[i]["PID"].ToString().Equals("387DAF1C-BB30-432A-9015-C94460DB4CDF"))
                    //{
                    //    this.Button7.Hidden = false;
                    //}
                    if (dt.Rows[i]["PID"].ToString().Equals("90A5C181-A46E-4B8F-8D78-289808EF96B7"))
                    {
                        this.Button8.Hidden = false;
                    }
                    if (dt.Rows[i]["PID"].ToString().Equals("B9474B90-5636-4E73-8DB1-79E9925646A6"))
                    {
                        this.Button9.Hidden = false;
                    }
                    if (dt.Rows[i]["PID"].ToString().Equals("25E12BC7-275B-4EDB-A356-B02FC7674DCF"))
                    {
                        this.Button10.Hidden = false;
                    }
                }
            }
        }
    }
}
