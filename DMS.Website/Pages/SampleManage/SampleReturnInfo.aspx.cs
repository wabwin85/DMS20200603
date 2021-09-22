using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.SampleManage
{
    public partial class SampleReturnInfo : System.Web.UI.Page
    {
        SampleApplyBLL Bll = new SampleApplyBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["HeadId"]))
                {
                    IptSampleHeadId.Text = Request.QueryString["HeadId"].ToString();
                }
                if (!string.IsNullOrEmpty(IptSampleHeadId.Text))
                {
                    Bindata();
                }
            }
        }
        public void Bindata()
        {
            SampleReturnHead Head = Bll.GetSampleRetrunHeadById(new Guid(IptSampleHeadId.Text));
            IptSampleType.Text = Head.SampleType;
            IptReturnNo.Text = Head.ReturnNo;
            //IptReturnRequire.Text = Head.ReturnRequire;
            IptReturnDate.Text = Head.ReturnDate;
            IptReturnUser.Text = Head.ReturnUser;
            IptReturnHosp.Text = Head.ReturnHosp;
            IptApplyNo.Text = Head.ApplyNo;
            IptCourierNumber.Text = Head.CourierNumber;
            //IptReturnDept.Text = Head.ReturnDept;
            //IptReturnDivision.Text = Head.ReturnDivision;
            //IptDealerName.Text = Head.DealerName;
            //IptReturnReason.Text = Head.ReturnReason;
            IptReturnQuantity.Text = Head.ReturnQuantity;
            //IptProcessUser.Text = Head.ProcessUser;
            IptReturnMemo.Text = Head.ReturnMemo;
            IptReturnStatus.Text = DictionaryCacheHelper.GetDictionaryNameById("CONST_Sample_State", Head.ReturnStatus);

            if (Head.SampleType == "测试样品" && Head.ReturnStatus == "Approved"/* && _context.IsInRole("SAMPLE CS")*/)
            {
                BtnReceive.Hidden = false;
                RstUpn.ColumnModel.SetHidden(5, false);
            }
            else if (Head.SampleType == "商业样品")
            {
                RstUpn.ColumnModel.SetHidden(5, true);
            }
        }

        protected void StoUpn_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = Bll.GetSampleUpnList(new Guid(IptSampleHeadId.Text));
            StoUpn.DataSource = ds;
            StoUpn.DataBind();
        }

        protected void StoOperLog_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = Bll.GetOperLogList(new Guid(IptSampleHeadId.Text));
            StoOperLog.DataSource = ds;
            StoOperLog.DataBind();
        }

        [AjaxMethod]
        public void SaveReceive()
        {
            Hashtable condition = new Hashtable();
            condition.Add("ReturnNo", IptReturnNo.Text);
            condition.Add("ReceiveUser", new Guid(_context.User.Id));
            Bll.ReceiveReturnSample(condition);
        }
    }
}
