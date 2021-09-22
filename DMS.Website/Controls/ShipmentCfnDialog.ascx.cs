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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ShipmentCfnDialog")]
    public partial class ShipmentCfnDialog : BaseUserControl
    {
        IRoleModelContext _context = RoleModelContext.Current;

        public Store GridStore
        {
            get;
            set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void CurrentInvStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
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
            if (!string.IsNullOrEmpty(this.cbWarehouseForInv.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouseForInv.SelectedItem.Value);
            }

            //可以有十个模糊查找的字段
            if (!string.IsNullOrEmpty(this.txtCfnForInv.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCfnForInv.Text);
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
            if (!string.IsNullOrEmpty(this.txtLotNumberForInv.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtLotNumberForInv.Text);
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

            if (!string.IsNullOrEmpty(this.txtQrCodeForInv.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtQrCodeForInv.Text);
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
            if (!string.IsNullOrEmpty(this.hiddenDialogHospitalId.Text))
            {
                param.Add("HospitalId", this.hiddenDialogHospitalId.Text);
            }

            if (!string.IsNullOrEmpty(this.cbExpireDateForInv.SelectedItem.Value))
            {
                param.Add("ExpireDateType", this.cbExpireDateForInv.SelectedItem.Value);
            }
            param.Add("LotInvQtyMin", 0);
            param.Add("ProductLineId", this.hiddenDialogProductLineId.Text);
            //param.Add("OnlyShowQR", 1);

            DataSet ds = null;
            if (!string.IsNullOrEmpty(this.cbWarehouseForInv.SelectedItem.Value))
            {
                ds = business.QueryCurrentInvForShipmentOrderNoAuth(param);
                this.CurrentInvStore.DataSource = ds;
            }
            this.CurrentInvStore.DataBind();
        }

        protected void ShipmentStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            string[] strCriteria;
            int iCriteriaNbr;
            IShipmentBLL shipmentBiz = new ShipmentBLL();

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.hiddenDialogDealerId.Text))
            {
                param.Add("DealerId", this.hiddenDialogDealerId.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogProductLineId.Text))
            {
                param.Add("ProductLineId", this.hiddenDialogProductLineId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbWarehouseForShipment.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouseForShipment.SelectedItem.Value);
            }

            //可以有十个模糊查找的字段
            if (!string.IsNullOrEmpty(this.txtCfnForShipment.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtCfnForShipment.Text);
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

            if (!string.IsNullOrEmpty(this.txtLotNumberForShipment.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtLotNumberForShipment.Text);
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

            if (!string.IsNullOrEmpty(this.txtQrCodeForShipment.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtQrCodeForShipment.Text);
                foreach (string strQrCode in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strQrCode))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductQrCode{0}", iCriteriaNbr), strQrCode);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductQrCode", "HasQrCodeCriteria");
            }

            if (!string.IsNullOrEmpty(this.txtShipmentNbrForShipment.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtShipmentNbrForShipment.Text);
                foreach (string strShipmentNbr in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strShipmentNbr))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ShipmentNbr{0}", iCriteriaNbr), strShipmentNbr);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ShipmentNbr", "HasShipmentNbrCriteria");
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogHospitalId.Text))
            {
                param.Add("HospitalId", this.hiddenDialogHospitalId.Text);
            }
            param.Add("ShipmentQtyMinQty", 0);
            //param.Add("OnlyShowQR", 1);

            DataSet ds = null;

            if (!string.IsNullOrEmpty(this.cbWarehouseForShipment.SelectedItem.Value))
            {
                ds = shipmentBiz.QueryShipmentLotByFilter(param);
                this.ShipmentStore.DataSource = ds;
            }
            this.ShipmentStore.DataBind();
        }

        public void Show(Guid OrderId, Guid DealerId, Guid ProductLineId, Guid HospitalId, string HospitalName, string type, int IsAuth, string ShipmentDate, string DialogType)
        {
            this.hiddenDialogOrderId.Text = OrderId.ToString();
            this.hiddenDialogHospitalId.Text = HospitalId.ToString();
            this.hiddenDialogDealerId.Text = DealerId.ToString();
            this.hiddenDialogProductLineId.Text = ProductLineId.ToString();
            this.hiddenIsAuth.Text = IsAuth.ToString();
            this.hiddenDealerType.Text = _context.User.CorpType;
            this.hiddenShipmentDate.Text = ShipmentDate;
            this.hiddenIdentityType.Text = _context.User.IdentityType;

            this.txtHospitalNameForShipment.Text = HospitalName;

            if (type == "销售出库单")
            {
                this.hiddenWareHouseType.Text = "Normal";
            }
            else if(type == "销售出库单医院库"){
                this.hiddenWareHouseType.Text = "HospitalOnly";
            }
            else if (type == "寄售产品销售单")
            {
                this.hiddenWareHouseType.Text = "Consignment";
            }
            else
            {
                this.hiddenWareHouseType.Text = "Borrow";
            }
            this.hiddenDialogType.Text = DialogType;
            if (DialogType == "Shipment")
            {
                this.WarehouseStoreForShipment.DataBind();
                this.ShipmentDialogWindow.Show();
            }
            else
            {
                this.WarehouseStoreForInv.DataBind();
                this.InventoryDialogWindow.Show();
            }

            //清空查询项
            this.cbWarehouseForShipment.SelectedItem.Value = string.Empty;
            this.txtShipmentNbrForShipment.Text = string.Empty;
            this.txtLotNumberForShipment.Text = string.Empty;
            //this.txtHospitalNameForShipment.Text = string.Empty;
            this.txtCfnForShipment.Text = string.Empty;
            this.txtQrCodeForShipment.Text = string.Empty;

            this.cbWarehouseForInv.SelectedItem.Value = string.Empty;
            this.txtCfnForInv.Text = string.Empty;
            this.txtQrCodeForInv.Text = string.Empty;
            this.txtLotNumberForInv.Text = string.Empty;
            this.cbExpireDateForInv.SelectedItem.Value = string.Empty;
        }

        [AjaxMethod]
        public void DoAddItems(string param, string type)
        {
            bool result = false;
            string RtnVal = string.Empty;
            string RtnMsg = string.Empty;

            if (string.IsNullOrEmpty(param))
            {
                Ext.Msg.Alert("Message", "请选择！").Show();
            }

            param = param.Substring(0, param.Length - 1);

            IShipmentBLL business = new ShipmentBLL();

            business.AddShipmentItems(new Guid(this.hiddenDialogOrderId.Text), new Guid(this.hiddenDialogDealerId.Text), new Guid(this.hiddenDialogHospitalId.Text), param, type, out RtnVal, out RtnMsg);

            if (RtnVal == "Success")
            {
                //this.GridStore.DataBind();
            }
            else if (RtnVal == "Failure")
            {
                Ext.Msg.Alert("Error", RtnMsg).Show();
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
                if (dt.Columns.Count < 1)
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
                    hiddenQrCodes.Text = QrCodes.Substring(0, QrCodes.Length - 1);
                    Ext.Msg.Alert("Message", "上传成功").Show();
                    this.ImportWindow.Hide();

                }
                else
                {
                    Ext.Msg.Alert("Message", "上传失败").Show();
                }
                #endregion
            }

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
            if (!string.IsNullOrEmpty(this.cbWarehouseForInv.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouseForInv.SelectedItem.Value);

            }

            if (!string.IsNullOrEmpty(this.hiddenQrCodes.Text))
            {
                param.Add("QrCodes", this.hiddenQrCodes.Text);
                if (param.Contains("WarehouseId"))
                {
                    param.Remove("WarehouseId");
                }
            }


            if (!string.IsNullOrEmpty(this.hiddenDialogHospitalId.Text))
            {
                param.Add("HospitalId", this.hiddenDialogHospitalId.Text);
            }

            param.Add("LotInvQtyMin", 0);

            DataSet ds = null;
            if (!string.IsNullOrEmpty(this.cbWarehouseForInv.SelectedItem.Value))
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
                    if (this.hiddenWareHouseType.Text == "Consignment")
                    {
                        param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));

                    }
                    else if (this.hiddenWareHouseType.Text == "Borrow")
                    {
                        param.Add("WarehouseTypes", string.Format("{0}", WarehouseType.Borrow.ToString()));

                    }
                    else
                    {
                        param.Add("WarehouseTypes", string.Format("{0},{1},{2}", WarehouseType.DefaultWH.ToString(), WarehouseType.Normal.ToString(), WarehouseType.Frozen.ToString()).Split(','));

                    }
                    ds = business.QueryCurrentInvForShipmentOrderNoAuth(param);
                }

                this.CurrentInvStore.DataSource = ds;
            }
            this.CurrentInvStore.DataBind();
        }

        //SongWeiming add 2019-02-12
        [AjaxMethod]
        public void ImportShow()
        {
            hiddenQrCodes.Clear();
            ImportWindow.Show();
        }
    }
}