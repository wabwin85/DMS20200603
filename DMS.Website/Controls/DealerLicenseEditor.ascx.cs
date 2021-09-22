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
using System.IO;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;
using System.Text;

namespace DMS.Website.Controls
{

    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerLicenseEditor")]
    public partial class DealerLicenseEditor : BaseUserControl
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

        public Guid NewApplyId
        {
            get
            {
                return new Guid(this.hiddenNewApplyId.Text);
            }
            set
            {
                this.hiddenNewApplyId.Text = value.ToString();
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

        public String NewSecondClassCatagory
        {
            get
            {
                return this.hidNewSecondClassCatagory.Text;
            }
            set
            {
                this.hidNewSecondClassCatagory.Text = value.ToString();
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

        public String NewThirdClassCatagory
        {
            get
            {
                return this.hidNewThirdClassCatagory.Text;
            }
            set
            {
                this.hidNewThirdClassCatagory.Text = value.ToString();
            }
        }

        public Guid DialogDealerId
        {
            get
            {
                return new Guid(this.hiddenDialogDealerId.Text);
            }
            set
            {
                this.hiddenDialogDealerId.Text = value.ToString();
            }
        }

        public String DialogCatagoryType
        {
            get
            {
                return this.hiddenDialogCatagoryType.Text;
            }
            set
            {
                this.hiddenDialogCatagoryType.Text = value.ToString();
            }
        }

        public String DialogCatagoryID
        {
            get
            {
                return this.hiddenDialogCatagoryID.Text;
            }
            set
            {
                this.hiddenDialogCatagoryID.Text = value.ToString();
            }
        }

        public String DialogCatagoryName
        {
            get
            {
                return this.hiddenDialogCatagoryName.Text;
            }
            set
            {
                this.hiddenDialogCatagoryName.Text = value.ToString();
            }
        }
        public String LatestApptoveUpdate
        {
            get
            {
                return hiddenLatestApptoveUpdate.Text;
            }
            set
            {
                this.hiddenLatestApptoveUpdate.Text = value.ToString();
            }
        }

        #endregion



        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
              
             
            }
        }

        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            //初始化
            this.CurSecondClassCatagory = "";
            this.NewSecondClassCatagory = "";
            this.CurThirdClassCatagory = "";
            this.NewThirdClassCatagory = "";
            this.DialogCatagoryID = "";
            this.DialogCatagoryName = "";
            this.DialogCatagoryType = "";
            this.NewApplyId = Guid.NewGuid();
            this.hiddenLatestApptoveUpdate.Clear();
          

            this.CurLicenseNo.Clear();
            this.CurLicenseNoValidFrom.Clear();
            this.CurLicenseNoValidTo.Clear();
            this.CurFilingNo.Clear();
            this.CurFilingNoValidFrom.Clear();
            this.CurFilingNoValidTo.Clear();
           
            this.CurRespPerson.Clear();
            this.CurLegalPerson.Clear();
            
            this.SecondClass2002CatagoryStore.RemoveAll();
            this.ThirdClass2002CatagoryStore.RemoveAll();          
            this.SecondClass2017CatagoryStore.RemoveAll();
            this.ThirdClass2017CatagoryStore.RemoveAll();
            this.TabPanel1.ActiveTabIndex = 0;
        }

        //显示页面
        public void Show(Guid dealerId)
        {
            //获取经销商编号
            this.DealerId = dealerId;
           
            this.InitDetailWindow();

            if (this.DealerId != null)
            {
                this.DetailWindow.Title = "CFDA证照信息申请及审批(" + DealerCacheHelper.GetDealerName(DealerId) + ")";
            }


            //根据经销商ID获取经销商证照相关信息
            if (dealerId != null)
            {
                DealerMasterLicense dml = _dealersBLL.QueryDealerMasterLicenseByDealerId(dealerId);
                if (dml != null)
                {
                    //给当前的控件赋值
                   
                    this.CurLicenseNo.Text = string.IsNullOrEmpty(dml.CurLicenseNo) ? "" : dml.CurLicenseNo;
                    this.CurRespPerson.Text = string.IsNullOrEmpty(dml.CurRespPerson) ? "" : dml.CurRespPerson;
                    
                    this.CurLegalPerson.Text = string.IsNullOrEmpty(dml.CurLegalPerson) ? "" : dml.CurLegalPerson;
                   

                  
                    if (dml.CurLicenseValidFrom != null && !String.IsNullOrEmpty(dml.CurLicenseValidFrom.ToString()))
                    {
                        CurLicenseNoValidFrom.SelectedDate = Convert.ToDateTime(dml.CurLicenseValidFrom);

                    }
                    if (dml.CurLicenseValidTo != null && !String.IsNullOrEmpty(dml.CurLicenseValidTo.ToString()))
                    {
                        CurLicenseNoValidTo.SelectedDate = Convert.ToDateTime(dml.CurLicenseValidTo);

                    }

                    this.CurFilingNo.Text = string.IsNullOrEmpty(dml.CurFilingNo) ? "" : dml.CurFilingNo;
                    if (dml.CurFilingValidFrom != null && !String.IsNullOrEmpty(dml.CurFilingValidFrom.ToString()))
                    {
                        CurFilingNoValidFrom.SelectedDate = Convert.ToDateTime(dml.CurFilingValidFrom);

                    }
                    if (dml.CurFilingValidTo != null && !String.IsNullOrEmpty(dml.CurFilingValidTo.ToString()))
                    {
                        CurFilingNoValidTo.SelectedDate = Convert.ToDateTime(dml.CurFilingValidTo);

                    }
                    hiddenLatestApptoveUpdate.Value = !dml.NewApplyDate.HasValue ? "" : dml.NewApplyDate.Value.ToString();

                    if (!String.IsNullOrEmpty(dml.CurSecondClassCatagory))
                    {
                        this.CurSecondClassCatagory = dml.CurSecondClassCatagory;
                        this.Bind_CurSecondClassCatagory(this.CurSecondClassCatagory);
                    }

                    if (!String.IsNullOrEmpty(dml.NewSecondClassCatagory))
                    {
                        this.NewSecondClassCatagory = dml.NewSecondClassCatagory;
                        this.Bind_NewSecondClassCatagory(this.NewSecondClassCatagory);
                    }


                    if (!String.IsNullOrEmpty(dml.CurThirdClassCatagory))
                    {
                        this.CurThirdClassCatagory = dml.CurThirdClassCatagory;
                        this.Bind_CurThirdClassCatagory(this.CurThirdClassCatagory);
                    }

                    if (!String.IsNullOrEmpty(dml.NewThirdClassCatagory))
                    {
                        this.NewThirdClassCatagory = dml.NewThirdClassCatagory;
                        this.Bind_NewThirdClassCatagory(this.NewThirdClassCatagory);
                    }

                    if (dml.NewApplyid != null)
                    {
                        this.NewApplyId = dml.NewApplyid.Value;
                    }
                }

                //this.gpNewAttachment.Reload();
                this.gpCurAttachmentDonwload.Reload();

                //如果是经销商，且单据状态是“待QA审批”，则提交按钮不可见（审批通过、审批拒绝按钮也不可见）
                //如果是用户，先判断是否为QA，如果是QA，则可以审批，如果不是QA则不可以审批，用户都不能提交

                this.GridPanel1.Reload();
                this.DetailWindow.Show();
                

            }
            else
            {
                Ext.MessageBox.Alert("警告", "无法获取当前经销商编号").Show();
            }

        }


        //绑定产品分类代码
        protected void Bind_CurSecondClassCatagory(String strCurSecondCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strCurSecondCatId, LicenseCatagoryLevel.二类.ToString(), "2002版");

            this.SecondClass2002CatagoryStore.DataSource = ds;
            this.SecondClass2002CatagoryStore.DataBind();
        }

        protected void Bind_NewSecondClassCatagory(String strNewSecondCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strNewSecondCatId, LicenseCatagoryLevel.二类.ToString(), "2017版");

            this.SecondClass2017CatagoryStore.DataSource = ds;
            this.SecondClass2017CatagoryStore.DataBind();
        }

        protected void Bind_CurThirdClassCatagory(String strCurThirdCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strCurThirdCatId, LicenseCatagoryLevel.三类.ToString(), "2002版");

            this.ThirdClass2002CatagoryStore.DataSource = ds;
            this.ThirdClass2002CatagoryStore.DataBind();
        }

        protected void Bind_NewThirdClassCatagory(String strNewThirdCatId)
        {
            DataSet ds = null;
            ds = _dealersBLL.GetDealerLicenseCatagoryByCatId(strNewThirdCatId, LicenseCatagoryLevel.三类.ToString(), "2017版");

            this.ThirdClass2017CatagoryStore.DataSource = ds;
            this.ThirdClass2017CatagoryStore.DataBind();
        }

        protected void CurAttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {

            int totalCount = 0;

            DataSet ds = _attachBll.GetAttachmentByMainId(this.DealerId, AttachmentType.DealerLicense, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarCurAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            int op = ds.Tables[0].Rows.Count;
            CurAttachmentStore.DataSource = ds;
            CurAttachmentStore.DataBind();
        }



        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = this.DealerId;
            int totalCount = 0;
            DataSet ds = _logbll.QueryPurchaseOrderLogByHeaderId(tid, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarLog.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        //绑定产品分类代码
        protected void LicenseCatagoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.DialogCatagoryType))
            {
                param.Add("catType", this.DialogCatagoryType);
            }
            if (!string.IsNullOrEmpty(this.DialogCatagoryID))
            {
                param.Add("catId", this.DialogCatagoryID);
            }
            if (!string.IsNullOrEmpty(this.DialogCatagoryName))
            {
                param.Add("catName", this.DialogCatagoryName);
            }

            DataSet ds = null;
            ds = _dealersBLL.GetLicenseCatagoryByCatType(param);

            this.LicenseCatagoryStore.DataSource = ds;
            this.LicenseCatagoryStore.DataBind();


        }



        [AjaxMethod]
        public void ShowDialog(string dealerId, string catagoryType)
        {
            this.DialogDealerId = new Guid(dealerId);
            this.DialogCatagoryID = "";
            this.DialogCatagoryName = "";
            this.DialogCatagoryType = catagoryType;

            //清空选择框

            this.DialogCatagoryWindow.Show();
            this.gpDialogCatagory.Reload();
        }

     


        [AjaxMethod]
        public void RefreshNewCatagoryGrid(string strCatId, string catagoryType)
        {
            if (catagoryType.Equals("三类"))
            {
                this.NewThirdClassCatagory = strCatId;
                this.Bind_NewThirdClassCatagory(strCatId);
            }
            else
            {
                this.NewSecondClassCatagory = strCatId;
                this.Bind_NewSecondClassCatagory(strCatId);
            }
            this.DialogCatagoryWindow.Hide();
        }

        protected void Querylog(object sender, AjaxEventArgs e)
        {
            this.WindowLog.Show();
            this.gpLog.Reload();
        }


        protected void ShipToAddress_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet dt =_dealersBLL.SelectSAPWarehouseAddress(this.DealerId);
            if (dt.Tables[0].Rows.Count > 0)
            {
                this.ShipToAddress.DataSource = dt;
                this.ShipToAddress.DataBind();
            }
        }
    }
}