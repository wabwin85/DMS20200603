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
using Lafite.RoleModel.Security;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ShipmentDialog")]
    public partial class ShipmentDialog : BaseUserControl
    {
        IRoleModelContext _context = RoleModelContext.Current;

        public Store GridStore
        {
            get;
            set;
        }

        public Store GridConsignmentStore
        {
            get;
            set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void CurrentInvStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string[] strCriteria;
            int iCriteriaNbr;
            ICurrentInvBLL business = new CurrentInvBLL();
            IShipmentBLL shipmentBiz = new ShipmentBLL();

            Hashtable param = new Hashtable();

            if (string.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                return;
            }
            if(!string.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                param.Add("ShipmentDate",this.hiddenShipmentDate.Text);
            }


            if (!string.IsNullOrEmpty(this.hiddenDialogDealerId.Text))
            {
                param.Add("DealerId", this.hiddenDialogDealerId.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogProductLineId.Text))
            {
                param.Add("ProductLine", this.hiddenDialogProductLineId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouse.SelectedItem.Value);

            }

            //可以有十个模糊查找的字段
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCFN.Text);
                foreach (string strCFN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strCFN))
                    {
                        iCriteriaNbr++;
                        if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                        {
                            param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                        }
                        else
                        {
                            param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                        }
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
            }

            //if (!string.IsNullOrEmpty(this.txtUPN.Text))
            //{
            //    iCriteriaNbr = 0;
            //    strCriteria = this.PageBase.oneRecord(this.txtUPN.Text);
            //    foreach (string strUPN in strCriteria)
            //    {
            //        if (!string.IsNullOrEmpty(strUPN))
            //        {
            //            iCriteriaNbr++;
            //            param.Add(string.Format("ProductUPN{0}", iCriteriaNbr), strUPN);
            //        }
            //    }
            //    if (iCriteriaNbr > 0) param.Add("ProductUPN", "HasUPNCriteria");
            //}

            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtLotNumber.Text);
                foreach (string strLot in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strLot))
                    {
                        iCriteriaNbr++;
                        if (strLot.Substring(0, 1) == "+" && strLot.Length > 2)
                        {
                            param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot.Substring(10, strLot.Length - 12));
                        }
                        else
                        {
                            param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot);
                        }
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductLotNumber", "HasLotCriteria");
            }
            
            if (!string.IsNullOrEmpty(this.txtQrCode.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtQrCode.Text);
                foreach (string strQrCode in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strQrCode))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("QrCode{0}", iCriteriaNbr), strQrCode);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("QrCode", "HasQrCodeCriteria");
            }
            //if (!string.IsNullOrEmpty(this.txtCFN.Text))
            //{
            //    param.Add("ProductCFN", this.txtCFN.Text);
            //}
            //if (!string.IsNullOrEmpty(this.txtUPN.Text))
            //{
            //    param.Add("ProductUPN", this.txtUPN.Text);
            //}
            //if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            //{
            //    param.Add("ProductLotNumber", txtLotNumber.Text);
            //}
            if (!string.IsNullOrEmpty(this.hiddenDialogHospitalId.Text))
            {
                param.Add("HospitalId", this.hiddenDialogHospitalId.Text);
            }

            if (!string.IsNullOrEmpty(this.cbExpiryDateTypeWin.SelectedItem.Value))
            {
                param.Add("ExpiryDateType", this.cbExpiryDateTypeWin.SelectedItem.Value);
            }

            DataSet ds = null;
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                //Edited By Song Yuqi On 20140317 Begin
                if (this.hiddenIsAuth.Text == "0")
                {
                    //二级经销商寄售
                    if (_context.User.CorpType == DealerType.T2.ToString() && this.hiddenWareHouseType.Text == "Consignment")
                    {
                        //平台寄售、波科寄售
                        param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                        ds = business.QueryCurrentInvForShipmentOrderByT2Consignment(param);
                    }
                    else if (shipmentBiz.IsAdminRole())
                    {
                        ds = business.QueryCurrentInvForShipmentOrderAdjust(param);
                    }
                    else
                    {
                        ds = business.QueryCurrentInvForShipmentOrder(param);
                    }
                }
                else
                {
                    ds = business.QueryCurrentInvForShipmentOrderNoAuth(param);
                }
                //Edited By Song Yuqi On 20140317 End

                this.CurrentInvStore.DataSource = ds;
            }
            this.CurrentInvStore.DataBind();


        }
        [AjaxMethod]
        public void SelectImportQrCode()
        {
           
            ICurrentInvBLL business = new CurrentInvBLL();
            IShipmentBLL shipmentBiz = new ShipmentBLL();

            Hashtable param = new Hashtable();

            if (string.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                return;
            }
            if (!string.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                param.Add("ShipmentDate", this.hiddenShipmentDate.Text);
            }

            if (!string.IsNullOrEmpty(this.hiddenDialogDealerId.Text))
            {
                param.Add("DealerId", this.hiddenDialogDealerId.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogProductLineId.Text))
            {
                param.Add("ProductLine", this.hiddenDialogProductLineId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouse.SelectedItem.Value);

            }

            if (!string.IsNullOrEmpty(this.hiddenQrCodes.Text))
            {
                param.Add("QrCodes", this.hiddenQrCodes.Text);
                int iCriteriaNbr = 0;
                string[] strCriteria = this.hiddenQrCodes.Text.Split(',');
                foreach (string strQrCode in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strQrCode))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("QrCode{0}", iCriteriaNbr), strQrCode);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("QrCode", "HasQrCodeCriteria");

                if (param.Contains("WarehouseId"))
                {
                    param.Remove("WarehouseId");
                }
            }

            if (!string.IsNullOrEmpty(this.hiddenDialogHospitalId.Text))
            {
                param.Add("HospitalId", this.hiddenDialogHospitalId.Text);
            }

            DataSet ds = null;
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                //Edited By Song Yuqi On 20140317 Begin
                if (this.hiddenIsAuth.Text == "0")
                {
                    //二级经销商寄售
                    if (_context.User.CorpType == DealerType.T2.ToString() && this.hiddenWareHouseType.Text == "Consignment")
                    {
                        //平台寄售、波科寄售
                        param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                        ds = business.QueryCurrentInvForShipmentOrderByT2Consignment(param);
                    }
                    else if (shipmentBiz.IsAdminRole())
                    {
                        ds = business.QueryCurrentInvForShipmentOrderAdjust(param);
                    }
                    else
                    {
                        ds = business.QueryCurrentInvForShipmentOrder(param);
                    }
                }
                else
                {
                    ds = business.QueryCurrentInvForShipmentOrderNoAuth(param);
                }
                //Edited By Song Yuqi On 20140317 End

                this.CurrentInvStore.DataSource = ds;
            }
            this.CurrentInvStore.DataBind();
        }
        [AjaxMethod]
        public void btnSearchClick()
        {
            string[] strCriteria;
            int iCriteriaNbr;
            ICurrentInvBLL business = new CurrentInvBLL();
            IShipmentBLL shipmentBiz = new ShipmentBLL();

            Hashtable param = new Hashtable();

            if (string.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                return;
            }
            if (!string.IsNullOrEmpty(this.hiddenShipmentDate.Text))
            {
                param.Add("ShipmentDate", this.hiddenShipmentDate.Text);
            }


            if (!string.IsNullOrEmpty(this.hiddenDialogDealerId.Text))
            {
                param.Add("DealerId", this.hiddenDialogDealerId.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogProductLineId.Text))
            {
                param.Add("ProductLine", this.hiddenDialogProductLineId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouse.SelectedItem.Value);
                this.hiddenWarehouseId.Text = this.cbWarehouse.SelectedItem.Value;
            }

            //可以有十个模糊查找的字段
            if (!string.IsNullOrEmpty(this.txtCFN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCFN.Text);
                this.hiddenCFN.Text = this.txtCFN.Text;
                foreach (string strCFN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strCFN))
                    {
                        iCriteriaNbr++;
                        if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                        {
                            param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                        }
                        else
                        {
                            param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                        }
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
            }

            //if (!string.IsNullOrEmpty(this.txtUPN.Text))
            //{
            //    iCriteriaNbr = 0;
            //    strCriteria = this.PageBase.oneRecord(this.txtUPN.Text);
            //    foreach (string strUPN in strCriteria)
            //    {
            //        if (!string.IsNullOrEmpty(strUPN))
            //        {
            //            iCriteriaNbr++;
            //            param.Add(string.Format("ProductUPN{0}", iCriteriaNbr), strUPN);
            //        }
            //    }
            //    if (iCriteriaNbr > 0) param.Add("ProductUPN", "HasUPNCriteria");
            //}

            if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtLotNumber.Text);
                foreach (string strLot in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strLot))
                    {
                        iCriteriaNbr++;
                        if (strLot.Substring(0, 1) == "+" && strLot.Length > 2)
                        {
                            param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot.Substring(10, strLot.Length - 12));
                        }
                        else
                        {
                            param.Add(string.Format("ProductLotNumber{0}", iCriteriaNbr), strLot);
                        }
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductLotNumber", "HasLotCriteria");
            }

            if (!string.IsNullOrEmpty(this.txtQrCode.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtQrCode.Text);
                foreach (string strQrCode in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strQrCode))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("QrCode{0}", iCriteriaNbr), strQrCode);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("QrCode", "HasQrCodeCriteria");
            }
            //if (!string.IsNullOrEmpty(this.txtCFN.Text))
            //{
            //    param.Add("ProductCFN", this.txtCFN.Text);
            //}
            //if (!string.IsNullOrEmpty(this.txtUPN.Text))
            //{
            //    param.Add("ProductUPN", this.txtUPN.Text);
            //}
            //if (!string.IsNullOrEmpty(this.txtLotNumber.Text))
            //{
            //    param.Add("ProductLotNumber", txtLotNumber.Text);
            //}
            if (!string.IsNullOrEmpty(this.hiddenDialogHospitalId.Text))
            {
                param.Add("HospitalId", this.hiddenDialogHospitalId.Text);
            }

            if (!string.IsNullOrEmpty(this.cbExpiryDateTypeWin.SelectedItem.Value))
            {
                param.Add("ExpiryDateType", this.cbExpiryDateTypeWin.SelectedItem.Value);
            }

            DataSet ds = null;
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                //Edited By Song Yuqi On 20140317 Begin
                if (this.hiddenIsAuth.Text == "0")
                {
                    //二级经销商寄售
                    if (_context.User.CorpType == DealerType.T2.ToString() && this.hiddenWareHouseType.Text == "Consignment")
                    {
                        //平台寄售、波科寄售
                        param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                        ds = business.QueryCurrentInvForShipmentOrderByT2Consignment(param);
                    }
                    else if (shipmentBiz.IsAdminRole())
                    {
                        ds = business.QueryCurrentInvForShipmentOrderAdjust(param);
                    }
                    else
                    {
                        ds = business.QueryCurrentInvForShipmentOrder(param);
                    }
                }
                else
                {
                    ds = business.QueryCurrentInvForShipmentOrderNoAuth(param);
                }
                //Edited By Song Yuqi On 20140317 End

                this.CurrentInvStore.DataSource = ds;
            }
            this.CurrentInvStore.DataBind();
        }
        public void Show(Guid OrderId, Guid DealerId, Guid ProductLineId, Guid HospitalId, string type, int IsAuth, string ShipmentDate)
        {
            this.hiddenDialogOrderId.Text = OrderId.ToString();
            this.hiddenDialogHospitalId.Text = HospitalId.ToString();
            this.hiddenDialogDealerId.Text = DealerId.ToString();
            this.hiddenDialogProductLineId.Text = ProductLineId.ToString();
            this.hiddenIsAuth.Text = IsAuth.ToString();
            //Added By Song Yuqi On 20140317 Begin
            this.hiddenDealerType.Text = _context.User.CorpType;
            //Added By Song Yuqi On 20140317 End
            this.hiddenShipmentDate.Text = ShipmentDate;
            this.hiddenIdentityType.Text = _context.User.IdentityType;
            hiddenQrCodes.Clear();

            //added by hxw
            if (type == "销售出库单")
            {
                this.hiddenWareHouseType.Text = "Normal";
            }
            else if (type == "寄售产品销售单")
            {
                this.hiddenWareHouseType.Text = "Consignment";
            }
            else
            {
                this.hiddenWareHouseType.Text = "Borrow";
            }

            this.txtCFN.Text = this.hiddenCFN.Text;

            this.WarehouseStore.DataBind();            
            this.DialogWindow.Show();
        }

        [AjaxMethod]
        public void DoAddItems(string param)
        {
            //Ext.Msg.Confirm(GetLocalResourceObject("DoAddItems.Confirm.title").ToString(), GetLocalResourceObject("DoAddItems.Confirm.body").ToString(), new MessageBox.ButtonsConfig
            //{
            //    Yes = new MessageBox.ButtonConfig
            //    {
            //        Handler = "Coolite.AjaxMethods.UC.DoYes('" + param + "')",
            //        Text = "Yes"
            //    },
            //    No = new MessageBox.ButtonConfig
            //    {
            //        Handler = "Coolite.AjaxMethods.UC.DoNo()",
            //        Text = "No"
            //    }
            //}).Show();

            DoYes(param);
        }

        [AjaxMethod]
        public void DoYes(string param)
        {
            System.Diagnostics.Debug.WriteLine("AddItems : Param = " + param);

            param = param.Substring(0, param.Length - 1);

            IShipmentBLL business = new ShipmentBLL();
            //Edited By Song Yuqi On 20140317 Begin
            bool result = false;

            //二级经销商寄售
            if (_context.User.CorpType == DealerType.T2.ToString() && this.hiddenWareHouseType.Text == "Consignment")
            {
                //根据物料分配规则，先扣除平台寄售仓库再扣除波科寄售仓库
                result = business.AddItems(new Guid(this.hiddenDialogOrderId.Text), new Guid(this.hiddenDialogDealerId.Text), new Guid(this.hiddenDialogHospitalId.Text), param.Split(','));
            }
            else
            {
                result = business.AddItems(new Guid(this.hiddenDialogOrderId.Text), new Guid(this.hiddenDialogDealerId.Text), new Guid(this.hiddenDialogHospitalId.Text), param.Split(','));
            }
            //Edited By Song Yuqi On 20140317 End

            if (result)
            {
                if (_context.User.CorpType == DealerType.T2.ToString() && this.hiddenWareHouseType.Text == "Consignment")
                {
                    this.GridStore.DataBind();
                   // this.GridConsignmentStore.DataBind();
                }
                else
                {
                    this.GridStore.DataBind();
                }
                // this.DialogWindow.Hide();
                // Ext.Msg.Alert(GetLocalResourceObject("DoAddItems.Alert.success.title").ToString(), GetLocalResourceObject("DoAddItems.Alert.success.body").ToString()).Show();
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("DoAddItems.Alert.fail.title").ToString(), GetLocalResourceObject("DoAddItems.Alert.fail.body").ToString()).Show();
            }
        }
        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {
                #region 上传文件至服务器
                System.Diagnostics.Debug.WriteLine("Upload Start : " + DateTime.Now.ToString());
                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                    if (fileExtention != "xls" && fileExtention != "xlsx")
                    {
                        error = true;
                    }
                }

                if (error)
                {
                   
                    return;
                }
                //构造文件名称

                string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\ShipmentQrCOde\\" + newFileName);
                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);
                System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");
                if (dt.Columns.Count <1)
                {
                    Ext.Msg.Alert("Message", "文件格式不正确").Show();
                    return;
                }
                if (dt.Rows.Count > 1)
                {
                    string QrCodes = string.Empty;
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0)
                        {
                            QrCodes = QrCodes + dt.Rows[i][0].ToString() + ",";
                        }
                    }
                   hiddenQrCodes.Text= QrCodes.Substring(0, QrCodes.Length - 1);
                   Ext.Msg.Alert("Message", "上传成功").Show();

                   this.ImportWindow.Hide();

                    SelectImportQrCode();
                }
                else {
                    Ext.Msg.Alert("Message", "上传失败").Show();
                }
               
              
              

           

                #endregion
            }
           
        }

        [AjaxMethod]
        public void DoNo()
        {

        }
        //lijie add 2016-02-29
        [AjaxMethod]
        public void ImportShow()
        {
            hiddenQrCodes.Clear();
            ImportWindow.Show();
        }
        protected void CloseWindow(object sender, AjaxEventArgs e)
        {
            this.DialogWindow.Hide();
        }
    }
}