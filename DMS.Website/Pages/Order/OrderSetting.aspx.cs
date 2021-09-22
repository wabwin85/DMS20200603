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

namespace DMS.Website.Pages.Order
{
    public partial class OrderSetting : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = null;

        [Dependency]
        public IPurchaseOrderBLL business
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
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSave.Visible = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderSetting, PermissionType.Write);

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
            DealerOrderSetting ordersetting = business.QueryGetDealerOrderSetting(_context.User.CorpId.Value);
            if (ordersetting == null)
            {
                this.hidIsNew.Text = "True";
                this.hidInstanceId.Text = Guid.NewGuid().ToString();
                ordersetting = GetNewDealerOrderSetting();
            }
            else
            {
                this.hidIsNew.Text = "False";
                this.hidInstanceId.Text = ordersetting.Id.ToString();
            }
            //页面赋值
            SetFormValue(ordersetting);
            //控件状态
            SetControl(ordersetting);

        }

        private void SetFormValue(DealerOrderSetting ordersetting)
        {
            this.txtMaxAmount.Text = ordersetting.MaxAmount.ToString();
            if (ordersetting.ExecuteDay != null)
            {
                this.cbExecuteDay1.Checked = ordersetting.ExecuteDay.Contains('1');
                this.cbExecuteDay2.Checked = ordersetting.ExecuteDay.Contains('2');
                this.cbExecuteDay3.Checked = ordersetting.ExecuteDay.Contains('3');
                this.cbExecuteDay4.Checked = ordersetting.ExecuteDay.Contains('4');
                this.cbExecuteDay5.Checked = ordersetting.ExecuteDay.Contains('5');
                this.cbExecuteDay6.Checked = ordersetting.ExecuteDay.Contains('6');
                this.cbExecuteDay7.Checked = ordersetting.ExecuteDay.Contains('0');
            }
        }

        private void SetControl(DealerOrderSetting ordersetting)
        {
            this.cbIsOpen.Checked = ordersetting.IsOpen;
            this.txtMaxAmount.Disabled = !this.cbIsOpen.Checked;
            this.cbExecuteDay1.Disabled = !this.cbIsOpen.Checked;
            this.cbExecuteDay2.Disabled = !this.cbIsOpen.Checked;
            this.cbExecuteDay3.Disabled = !this.cbIsOpen.Checked;
            this.cbExecuteDay4.Disabled = !this.cbIsOpen.Checked;
            this.cbExecuteDay5.Disabled = !this.cbIsOpen.Checked;
            this.cbExecuteDay6.Disabled = !this.cbIsOpen.Checked;
            this.cbExecuteDay7.Disabled = !this.cbIsOpen.Checked;
        }

        private DealerOrderSetting GetFormValue()
        {
            DealerOrderSetting ordersetting = new DealerOrderSetting();
            ordersetting.Id = new Guid(this.hidInstanceId.Text);
            ordersetting.DmaId = _context.User.CorpId.Value;
            ordersetting.IsOpen = cbIsOpen.Checked;
            if (txtMaxAmount.Text == "")
            {
                ordersetting.MaxAmount = null;
            }
            else 
            {
                ordersetting.MaxAmount = Convert.ToDecimal(txtMaxAmount.Text); 
            }
            ordersetting.ExecuteDay = "";
            if (cbExecuteDay7.Checked)
            {
                ordersetting.ExecuteDay += "0,";
            }
            if (cbExecuteDay1.Checked)
            {
                ordersetting.ExecuteDay += "1,";
            }
            if (cbExecuteDay2.Checked)
            {
                ordersetting.ExecuteDay += "2,";
            }
            if (cbExecuteDay3.Checked)
            {
                ordersetting.ExecuteDay += "3,";
            }
            if (cbExecuteDay4.Checked)
            {
                ordersetting.ExecuteDay += "4,";
            }
            if (cbExecuteDay5.Checked)
            {
                ordersetting.ExecuteDay += "5,";
            }
            if (cbExecuteDay6.Checked)
            {
                ordersetting.ExecuteDay += "6,";
            }
            
            if (!String.IsNullOrEmpty(ordersetting.ExecuteDay))
            {
                ordersetting.ExecuteDay = ordersetting.ExecuteDay.Substring(0, ordersetting.ExecuteDay.Length - 1);
            }
            return ordersetting;
        }

        private DealerOrderSetting GetNewDealerOrderSetting()
        {
            DealerOrderSetting ordersetting = new DealerOrderSetting();
            ordersetting.Id = new Guid(this.hidInstanceId.Text);
            ordersetting.DmaId = _context.User.CorpId.Value;
            ordersetting.IsOpen = false;
            return ordersetting;
        }

        #endregion
        
        [AjaxMethod]
        protected void btnSave_OnClick(object sender, AjaxEventArgs e)
        {
            DealerOrderSetting ordersetting = this.GetFormValue();

            if (this.hidIsNew.Text == "True")
            {
                business.InsertDealerOrderSetting(ordersetting);
                this.hidIsNew.Text = "False";
            }
            else
            {
                business.UpdateDealerOrderSetting(ordersetting);
            }
        }
       
    }
}
