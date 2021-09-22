using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business.Cache;
using Lafite.RoleModel.Security;
using DMS.Business.DPInfo;
using System.Data;
using DMS.Model;
using System.Collections;
using Fulper.ExpressionParser;
using System.Globalization;

namespace DMS.Website.Pages.DPInfo
{
    public partial class DPScoreCardView : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        public Guid DealerId
        {
            get
            {
                return new Guid(this.hidDealerId.Text);
            }
            set
            {
                this.hidDealerId.Text = value.ToString();
            }
        }

        public Guid InstanceId
        {
            get
            {
                return new Guid(this.hidInstanceId.Text);
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["DealerId"] == null || string.IsNullOrEmpty(Request.QueryString["DealerId"].ToString()))
                    throw new Exception("传递参数错误");
                this.DealerId = new Guid(Request.QueryString["DealerId"].ToString());
                if (!String.IsNullOrEmpty(Request.QueryString["VersionId"]))
                {
                    this.InstanceId = new Guid(Request.QueryString["VersionId"].ToString());
                }
                else
                {
                    this.InstanceId = Guid.Empty;
                }
                InitData();
            }
        }

        private void InitData()
        {
            if (this.InstanceId != Guid.Empty)
            {
                DealerMaster dealer = DealerCacheHelper.GetDealerById(this.DealerId);
                this.tbDealerCode.Text = dealer.SapCode;
                this.tbDealerName.Text = dealer.ChineseName;

                DpScoreCardBLL bll = new DpScoreCardBLL();
                DpStatementScorecardHeader head = bll.SelectDpStatementScorecardHeader(InstanceId);
                tbCreateDate.Text = head.CreateDate.Value.ToString("yyyy-MM-dd");

                DpStatementScorecard sc = new DpStatementScorecard();
                sc.SthId = InstanceId;
                IList<DpStatementScorecard> list = bll.SelectByFilter(sc);
                if (list.Count > 0)
                {
                    TextField ctrl = null;
                    foreach (DpStatementScorecard detail in list)
                    {
                        ctrl = this.Page.FindControl("tb" + detail.Key) as TextField;
                        if (ctrl != null)
                        {
                            ctrl.Text = detail.Value;
                        }
                    }
                }
            }

            if (IsDealer)
            {
                Pnl1.Hidden = true;
                Pnl2.Hidden = true;
                Pnl3.Hidden = true;
                Pnl4.Hidden = true;
                Pnl5.Hidden = true;
            }
            else
            {
                //系统管理员、DRM人员、财务人员
                if (_context.IsInRole("DP 系统管理员") || _context.IsInRole("DP DRM人员") || _context.IsInRole("DP 财务人员"))
                {
                    Pnl1.Hidden = false;
                    Pnl2.Hidden = false;
                    Pnl3.Hidden = false;
                    Pnl4.Hidden = false;
                    Pnl5.Hidden = false;
                }
                else
                {
                    Pnl1.Hidden = true;
                    Pnl2.Hidden = true;
                    Pnl3.Hidden = true;
                    Pnl4.Hidden = true;
                    Pnl5.Hidden = true;
                }
            }
        }
    }
}
