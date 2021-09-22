using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using DMS.Business;
using Coolite.Ext.Web;
using DMS.Model;
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Shipment
{
    public partial class ShipmentPrintSetting : BasePage
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

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                //权限控制
                Permissions pers = this._context.User.GetPermissions();
                
                //this.btnSave.Visible = pers.IsPermissible(Business.ShipmentBLL.Action_PrintSetting, PermissionType.Write);

                InitDetailWindow();
            }
        }

        #endregion


        #region 页面私有方法
        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            DealerCommonSetting dcSetting = business.QueryGetDealerCommonSetting(_context.User.CorpId.Value);
            if (dcSetting == null)
            {
                this.hidIsNew.Text = "True";
                this.hidInstanceId.Text = Guid.NewGuid().ToString();
                dcSetting = GetNewDealerCommonSetting();
            }
            else
            {
                this.hidIsNew.Text = "False";
                this.hidInstanceId.Text = dcSetting.Id.ToString();
            }
            //页面赋值
            SetFormValue(dcSetting);

        }

        private void SetFormValue(DealerCommonSetting dcSetting)
        {
            if (dcSetting.SettingValue != null)
            {
                //this.cbWarehouse.Checked = dcSetting.SettingValue.Contains('0');
                this.cbCertificateName.Checked = dcSetting.SettingValue.Contains('0');
                this.cbProductType.Checked = dcSetting.SettingValue.Contains('1');
                this.cbLot.Checked = dcSetting.SettingValue.Contains('2');
                this.cbExpiryDate.Checked = dcSetting.SettingValue.Contains('3');
                this.cbShipmentQty.Checked = dcSetting.SettingValue.Contains('4');
                this.cbUnit.Checked = dcSetting.SettingValue.Contains('5');
                this.cbUnitPrice.Checked = dcSetting.SettingValue.Contains('6');
                this.cbCertificateNo.Checked = dcSetting.SettingValue.Contains('7');
                this.cbcbCertificateENNo.Checked=dcSetting.SettingValue.Contains('8');
                this.cbStartDate.Checked=dcSetting.SettingValue.Contains('9');
                this.cbExpireDate.Checked = dcSetting.SettingValue.Contains('a');
                this.cbEnglishName.Checked = dcSetting.SettingValue.Contains('b');
                
                
            }
        }


        private DealerCommonSetting GetFormValue()
        {
            DealerCommonSetting dcSetting = new DealerCommonSetting();
            dcSetting.Id = new Guid(this.hidInstanceId.Text);
            dcSetting.DmaId = _context.User.CorpId.Value;
            dcSetting.SettingValue = "";
            //if (cbWarehouse.Checked)
            //{
            //    dcSetting.SettingValue += "0,";
            //}
            if (cbCertificateName.Checked)
            {
                dcSetting.SettingValue += "0,";
            }

            if (cbProductType.Checked)
            {
                dcSetting.SettingValue += "1,";
            }
            if (cbLot.Checked)
            {
                dcSetting.SettingValue += "2,";
            }
            if (cbExpiryDate.Checked)
            {
                dcSetting.SettingValue += "3,";
            }
            //if (cbInventoryQty.Checked)
            //{
            //    dcSetting.SettingValue += "4,";
            //}
            if (cbShipmentQty.Checked)
            {
                dcSetting.SettingValue += "4,";
            }

            if (cbUnit.Checked)
            {
                dcSetting.SettingValue += "5,";
            }
            if (cbUnitPrice.Checked)
            {
                dcSetting.SettingValue += "6,";
            }

            if (cbCertificateNo.Checked)
            {
                dcSetting.SettingValue += "7,";
            }
           
            if (cbcbCertificateENNo.Checked)
            {
                dcSetting.SettingValue += "8,";
            }
            if (cbStartDate.Checked)
            {
                dcSetting.SettingValue += "9,";
            }
            if (cbExpireDate.Checked)
            {
                dcSetting.SettingValue += "a,";
            }
            if (cbEnglishName.Checked)
            {
                dcSetting.SettingValue += "b,";
            }
          
            if (!String.IsNullOrEmpty(dcSetting.SettingValue))
            {
                dcSetting.SettingValue = dcSetting.SettingValue.Substring(0, dcSetting.SettingValue.Length - 1);
            }
            return dcSetting;
        }

        private DealerCommonSetting GetNewDealerCommonSetting()
        {
            DealerCommonSetting dcSetting = new DealerCommonSetting();
            dcSetting.Id = new Guid(this.hidInstanceId.Text);
            dcSetting.DmaId = _context.User.CorpId.Value;
            return dcSetting;
        }

        #endregion

        [AjaxMethod]
        protected void btnSave_OnClick(object sender, AjaxEventArgs e)
        {
            DealerCommonSetting dcSetting = this.GetFormValue();
            dcSetting.ActiveFlag = true;
            dcSetting.SettingName = "销售单打印设定";

            if (this.hidIsNew.Text == "True")
            {
                business.InsertDealerCommonSetting(dcSetting);
                this.hidIsNew.Text = "False";
            }
            else
            {
                business.UpdateDealerCommonSetting(dcSetting);
            }
        }

        [AjaxMethod]
        protected void btnChoseAll_OnClick(object sender, AjaxEventArgs e)
        {
            //this.cbWarehouse.Checked = true;
            this.cbProductType.Checked = true;
            this.cbEnglishName.Checked = true;
            this.cbLot.Checked = true;
            this.cbExpiryDate.Checked = true;
            //this.cbInventoryQty.Checked = true;
            this.cbShipmentQty.Checked = true;
            this.cbUnitPrice.Checked = true;
            this.cbCertificateNo.Checked = true;
            this.cbCertificateName.Checked = true;
            //this.cbCertificateType.Checked = true;
            this.cbcbCertificateENNo.Checked = true;
            this.cbStartDate.Checked = true;
            this.cbExpireDate.Checked = true;
            this.cbUnit.Checked = true;



            //this.cbWarehouse.Checked = false;
            //this.cbProductType.Checked = false;
            //this.cbLot.Checked = false;
            //this.cbExpiryDate.Checked = false;
            //this.cbInventoryQty.Checked = false;
            //this.cbShipmentQty.Checked = false;
            //this.cbUnitPrice.Checked = false;
            //this.cbCertificateNo.Checked = false;
            //this.cbCertificateName.Checked = false;
            //this.cbCertificateType.Checked = false;
        }


    }
}
