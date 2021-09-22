using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using System.Data;
using Lafite.RoleModel.Security;
using DMS.Business;
using Coolite.Ext.Web;
using DMS.Model.Data;
using DMS.Model;

namespace DMS.Website.Pages.DPInfo.DPIndexMaintain
{
    public partial class DPIndexQueryDealerLicense : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealersBLL = new DealerMasters();
        private IAttachmentBLL _attachBll = new AttachmentBLL();
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        #endregion

        #region 公开属性
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

        public String CurSecondClassCatagory
        {
            get
            {
                return this.hidCurSecondClassCatagory.Text;
            }
            set
            {
                this.hidCurSecondClassCatagory.Text = value.ToString();
            }
        }

        public String CurThirdClassCatagory
        {
            get
            {
                return this.hidCurThirdClassCatagory.Text;
            }
            set
            {
                this.hidCurThirdClassCatagory.Text = value.ToString();
            }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                Show(new Guid(Request.QueryString["DealerId"].ToString()));
            }
        }

        protected void CurAttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {

            int totalCount = 0;

            DataSet ds = _attachBll.GetAttachmentByMainId(this.DealerId, AttachmentType.DealerLicense, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarCurAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            CurAttachmentStore.DataSource = ds;
            CurAttachmentStore.DataBind();
        }

        private void InitDetailWindow()
        {
            //初始化
            this.CurLicenseNo.Clear();
            this.CurLicenseNoValidFrom.Clear();
            this.CurLicenseNoValidTo.Clear();
            this.CurFilingNo.Clear();
            this.CurFilingNoValidFrom.Clear();
            this.CurFilingNoValidTo.Clear();

            this.CurSecondClassCatagoryStore.RemoveAll();
            this.CurThirdClassCatagoryStore.RemoveAll();
        }

        //绑定产品分类代码
        protected void Bind_CurSecondClassCatagory(String strCurSecondCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strCurSecondCatId, LicenseCatagoryLevel.二类.ToString(),null);

            this.CurSecondClassCatagoryStore.DataSource = ds;
            this.CurSecondClassCatagoryStore.DataBind();
        }

        protected void Bind_CurThirdClassCatagory(String strCurThirdCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strCurThirdCatId, LicenseCatagoryLevel.三类.ToString(), null);

            this.CurThirdClassCatagoryStore.DataSource = ds;
            this.CurThirdClassCatagoryStore.DataBind();
        }

        public void Show(Guid dealerId)
        {
            //获取经销商编号
            this.DealerId = dealerId;

            this.InitDetailWindow();

            //根据经销商ID获取经销商证照相关信息
            if (dealerId != null)
            {
                DealerMasterLicense dml = _dealersBLL.QueryDealerMasterLicenseByDealerId(dealerId);
                if (dml != null)
                {
                    //给当前的控件赋值
                    this.CurLicenseNo.Text = string.IsNullOrEmpty(dml.CurLicenseNo) ? "" : dml.CurLicenseNo;
                    if (dml.CurLicenseValidFrom != null && !String.IsNullOrEmpty(dml.CurLicenseValidFrom.ToString()))
                    {
                        CurLicenseNoValidFrom.Text = dml.CurLicenseValidFrom.Value.ToString("yyyy/M/d");

                    }
                    if (dml.CurLicenseValidTo != null && !String.IsNullOrEmpty(dml.CurLicenseValidTo.ToString()))
                    {
                        CurLicenseNoValidTo.Text = dml.CurLicenseValidTo.Value.ToString("yyyy/M/d");

                    }

                    this.CurFilingNo.Text = string.IsNullOrEmpty(dml.CurFilingNo) ? "" : dml.CurFilingNo;
                    if (dml.CurFilingValidFrom != null && !String.IsNullOrEmpty(dml.CurFilingValidFrom.ToString()))
                    {
                        CurFilingNoValidFrom.Text = dml.CurFilingValidFrom.Value.ToString("yyyy/M/d");

                    }
                    if (dml.CurFilingValidTo != null && !String.IsNullOrEmpty(dml.CurFilingValidTo.ToString()))
                    {
                        CurFilingNoValidTo.Text = dml.CurFilingValidTo.Value.ToString("yyyy/M/d");

                    }
                    if (!String.IsNullOrEmpty(dml.CurSecondClassCatagory))
                    {
                        this.CurSecondClassCatagory = dml.CurSecondClassCatagory;
                        this.Bind_CurSecondClassCatagory(this.CurSecondClassCatagory);
                    }

                    if (!String.IsNullOrEmpty(dml.CurThirdClassCatagory))
                    {
                        this.CurThirdClassCatagory = dml.CurThirdClassCatagory;
                        this.Bind_CurThirdClassCatagory(this.CurThirdClassCatagory);
                    }
                }

                this.gpCurAttachmentDonwload.Reload();
            }
            else
            {
                Ext.MessageBox.Alert("警告", "无法获取当前经销商编号").Show();
            }

        }

    }
}
