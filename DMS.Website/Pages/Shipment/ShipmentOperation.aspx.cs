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
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Shipment
{
    public partial class ShipmentOperation : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IShipmentBLL _business = null;
        [Dependency]
        public IShipmentBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //控制保存按钮按钮
                if (Request["DateCheck"] == null || Request["DateCheck"].ToString() == string.Empty)
                {
                    throw new Exception(GetLocalResourceObject("Page_Load.Exception").ToString());
                }
                else
                {
                    if (Request["DateCheck"] == "true")
                    {
                        this.btnSave.Disabled = false;
                        this.txtOfficeName.Disabled = false;
                        this.txtDoctorName.Disabled = false;
                        this.txtPatientName.Disabled = false;
                        this.cbPatientGender.Disabled = false;
                        this.txtPatientPIN.Disabled = false;
                        this.txtHospitalNo.Disabled = false;  
                    }
                    else
                    {
                        this.btnSave.Disabled = true;
                        this.btnSave.Disabled = true;
                        this.txtOfficeName.Disabled = true;
                        this.txtDoctorName.Disabled = true;
                        this.txtPatientName.Disabled = true;
                        this.cbPatientGender.Disabled = true;
                        this.txtPatientPIN.Disabled = true;
                        this.txtHospitalNo.Disabled = true;  
                    }
                    
                }
                
                //获取前一个页面的参数
                if (Request["SPHID"] == null || Request["SPHID"].ToString() == string.Empty)
                {
                    throw new Exception("传递单据参数错误！");
                }
                else
                {
                    this.hiddenSPHID.Text = Request["SPHID"].ToString();                    
                    this.txtDealerName.Text = Request["DealerName"].ToString();
                    this.txtHospitalName.Text = Request["HospitalName"].ToString();
                    String aa = Request["OrderNumber"].ToString();
                    this.txtOrderNumber.Text = Request["OrderNumber"].ToString();
                    this.txtShipmentDate.Text = Request["ShipmentDate"].ToString();
                    this.txtInvoice.Text = Request["Invoice"].ToString();
                }
                

                //获取报台信息
                IList<DMS.Model.ShipmentOperation> list = business.GetShipmentOperationByHeaderId(new Guid(Request["SPHID"].ToString()));
                DMS.Model.ShipmentOperation DMSO = null;
                if (list.Count > 0 )
                {
                    DMSO = list[0];
                }
                else
                {
                    //新增记录
                    DMSO = new DMS.Model.ShipmentOperation();
                    DMSO.Id = Guid.NewGuid();
                    DMSO.SphId = new Guid(Request["SPHID"].ToString());
                    business.InsertShipmentOperation(DMSO);
                }
                this.hiddenSOID.Text = DMSO.Id.ToString();
                this.hiddenSPHID.Text = DMSO.SphId.ToString();
                this.txtOfficeName.Text = DMSO.OfficeName;
                this.txtDoctorName.Text = DMSO.DoctorName;
                this.txtPatientName.Text = DMSO.PatientName;
                this.cbPatientGender.SelectedItem.Value = DMSO.PatientGender;
                this.txtPatientPIN.Text = DMSO.Patientpin;
                this.txtHospitalNo.Text = DMSO.HospitalNo;                
            }
        }



        [AjaxMethod]
        public void Save()
        {
            DMS.Model.ShipmentOperation DMSO = new DMS.Model.ShipmentOperation();
            DMSO.Id  = new Guid(this.hiddenSOID.Text);
            DMSO.SphId = new Guid(this.hiddenSPHID.Text);
            DMSO.OfficeName = this.txtOfficeName.Text;
            DMSO.DoctorName = this.txtDoctorName.Text;
            DMSO.PatientName = this.txtPatientName.Text;
            DMSO.PatientGender = this.cbPatientGender.SelectedItem.Value;
            DMSO.Patientpin = this.txtPatientPIN.Text;
            DMSO.HospitalNo = this.txtHospitalNo.Text;
            business.UpdateShipmentOperation(DMSO);
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Guid sphId = new Guid(this.hiddenSPHID.Text);

            int totalCount = 0;

            Hashtable param = new Hashtable();

            param.Add("HeaderId", sphId);

            DataSet ds = business.QueryShipmentLot(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

            this.txtTotalAmount.Text = business.GetShipmentTotalAmount(sphId).ToString();
            //this.txtTotalQty.Text = business.GetShipmentTotalQty(tid).ToString();
        }
    }
}
