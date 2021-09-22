using Coolite.Ext.Web;
using DMS.Business;
using DMS.Business.Contract;
using DMS.Business.EKPWorkflow;
using DMS.Common;
using DMS.Model;
using DMS.Model.EKPWorkflow;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Contract
{
    public partial class TenderAuthorizationInfoRead : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        TenderAuthorizationListBLL Bll = new TenderAuthorizationListBLL();
        EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

        public string MainId
        {
            get
            {
                return this.hidDtmId.Text;
            }
            set
            {
                this.hidDtmId.Text = value.ToString();
            }
        }
        public string DthId
        {
            get
            {
                return this.hidDthId.Text;
            }
            set
            {
                this.hidDthId.Text = value.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.Bind_ProductLine(this.ProductLineStore);
                //主信息
                if (!string.IsNullOrEmpty(Request.QueryString["FormId"]))
                {
                    MainId = Request.QueryString["FormId"].ToString();

                    AuthorizationTenderMain Head = Bll.GetTenderMainById(new Guid(MainId));
                    if (Head != null)
                    {
                        this.AtuNo.Text = Head.No;
                        if (Head.ProductLineId != null)
                        {
                            this.cbProductLine.SelectedItem.Value = Head.ProductLineId.ToString();
                        }
                        this.cbDealerType.SelectedItem.Value = Head.Remark2;
                        this.AtuApplyUser.Text = Head.CreateUser;
                        if (Head.CreateDate != null)
                        {
                            this.AtuApplyDate.Text = Head.CreateDate.Value.ToString();
                        }
                        if (Head.BeginDate != null)
                        {
                            this.AtuBeginDate.SelectedDate = Head.BeginDate.Value;
                        }
                        if (Head.EndDate != null)
                        {
                            this.AtuEndDate.SelectedDate = Head.EndDate.Value;
                        }
                        this.AtuDealerName.Text = Head.DealerName;

                        if (Head.LicenceType != null && !Head.LicenceType.Value)
                        {
                            this.AtulicenseTypeYes.Checked = false;
                            this.AtulicenseTypeNo.Checked = true;
                        }
                        else
                        {
                            this.AtulicenseTypeYes.Checked = true;
                            this.AtulicenseTypeNo.Checked = false;
                        }
                        this.AtuRemark.Text = Head.Remark1;
                        if (Head.DealerType != null)
                        {
                            this.cbDealerType.SelectedItem.Value = Head.DealerType.ToString();
                        }
                        this.AtuMailAddress.Text = Head.DealerAddress;

                        this.atuDealerRemark.Text = Head.Remark2;
                    }

                }

                this.gpProduct.Reload();
                this.gpAttachment.Reload();
            }
            
            this.approvalIframe1.formInstanceId = Request.QueryString["FormId"];
            this.BtnApprove.Hidden = this.approvalIframe1.handler_pass_show;
            this.BtnRefuse.Hidden = this.approvalIframe1.handler_refuse_show;
            this.BtnPress.Hidden = this.approvalIframe1.drafter_press_show;
            this.BtnAbandon.Hidden = this.approvalIframe1.drafter_abandon_show;
        }

        //授权产品
        protected void ProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //string DtmId = Request.QueryString["DtmId"].ToString();
            string dthid = "00000000-0000-0000-0000-000000000000";
            Hashtable obj = new Hashtable();
            obj.Add("DthId", dthid);
            obj.Add("DtmId", MainId);
            obj.Add("BeginDate", this.AtuBeginDate.SelectedDate);
            obj.Add("EndDate", this.AtuEndDate.SelectedDate);
            obj.Add("OperType", "Query");

            obj.Add("start", (e.Start == -1 ? 0 : e.Start / this.PagingToolBar2.PageSize));
            obj.Add("limit", this.PagingToolBar2.PageSize);
            DataSet query = Bll.GetTenderHospitalProductQuery(obj);
            DataTable dtCount = query.Tables[0];
            DataTable dtValue = query.Tables[1];
            (this.ProductStore.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());
            this.ProductStore.DataSource = dtValue;
            this.ProductStore.DataBind();
        }


        //附件信息
        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            //string DtmId = Request.QueryString["DtmId"].ToString();
            int totalCount = 0;
            Hashtable tb = new Hashtable();
            tb.Add("MainId", MainId);
            DataTable dt = Bll.GetTenderFileQuery(tb, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }


        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType;
                DealerTypeStore.DataBind();
            }
        }

        [AjaxMethod]
        public string remarkValue()
        {
            return this.approvalIframe1.remarkValue;

        }
    }
}