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
using DMS.Model;
using DMS.Business.Cache;
using System;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "UC")]
    public partial class TransferUnfreezeDialog : BaseUserControl
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




        protected void CurrentInvStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string[] strCriteria;
            int iCriteriaNbr;
            ICurrentInvBLL business = new CurrentInvBLL();

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.hiddenDialogDealerFromId.Text))
            {
                param.Add("DealerId", this.hiddenDialogDealerFromId.Text);
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

            if (!string.IsNullOrEmpty(this.txtUPN.Text))
            {
                iCriteriaNbr = 0;
                strCriteria = this.PageBase.oneRecord(this.txtUPN.Text);
                foreach (string strUPN in strCriteria)
                {
                    if (!string.IsNullOrEmpty(strUPN))
                    {
                        iCriteriaNbr++;
                        param.Add(string.Format("ProductUPN{0}", iCriteriaNbr), strUPN);
                    }
                }
                if (iCriteriaNbr > 0) param.Add("ProductUPN", "HasUPNCriteria");
            }

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
            if (this.hiddenDialogTransferType.Text == TransferType.Transfer.ToString() || this.hiddenDialogTransferType.Text == TransferType.Rent.ToString())
            {
                string[] list = new string[1];
                list[0] = WarehouseType.Frozen.ToString();
                param.Add("QryWarehouseType", list);
            }
            else if (this.hiddenDialogTransferType.Text == TransferType.RentConsignment.ToString())
            {
                if (_context.User.CorpType == DealerType.HQ.ToString())
                {
                    param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                }
                else
                {
                    //string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(',')
                    //param.Add("QryWarehouseType", WarehouseType.LP_Consignment.ToString().Split(','));
                    param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                }
            }
            else
            {
                if (_context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.LS.ToString() || _context.User.CorpType == DealerType.T1.ToString())
                {
                    param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                }
                else
                {
                    param.Add("QryWarehouseType", WarehouseType.LP_Consignment.ToString().Split(','));
                }
            }


            DataTable ds = business.QueryCurrentInv(param).Tables[0];

            this.CurrentInvStore.DataSource = ds;
            this.CurrentInvStore.DataBind();

        }

        public void Show(TransferType type, Guid id, Guid dealerFromId, Guid productLineId, Guid dealerToId, Guid? dealerToDefaultWarehouseId)
        {
            this.hiddenDialogTransferId.Text = id.ToString();
           this.hiddenDialogDealerFromId.Text = dealerFromId.ToString();
            this.hiddenDialogDealerToId.Text = dealerToId.ToString();
            this.hiddenDialogProductLineId.Text = productLineId.ToString();
            this.hiddenDialogDealerToDefaultWarehouseId.Text = dealerToDefaultWarehouseId.ToString();
            this.hiddenDialogTransferType.Text = type.ToString();

            System.Diagnostics.Debug.WriteLine(string.Format("ShowDialog Parameters : \nhiddenDialogTransferId = {0}\nhiddenDialogDealerFromId = {1}\nhiddenDialogDealerToId = {2}\nhiddenDialogProductLineId = {3}\nhiddenDialogDealerToDefaultWarehouseId = {4}",
                this.hiddenDialogTransferId.Text,
                this.hiddenDialogDealerFromId.Text,
                this.hiddenDialogDealerToId.Text,
                this.hiddenDialogProductLineId.Text,
                this.hiddenDialogDealerToDefaultWarehouseId.Text));
            string warehousetype = string.Empty;
            if (type.ToString() == TransferType.Transfer.ToString())
            {
                warehousetype = "Frozen";
            }
            else if (type.ToString() == TransferType.Rent.ToString())
            {
                warehousetype = "Normal";
            }
            else
            {
                warehousetype = "Consignment";
            }


            if (type.ToString() == TransferType.Transfer.ToString())
            {
                if (_context.User.LoginId.Contains("_99"))
                {
                    this.Bind_TransferWarehouseByDealerAndType(WarehouseStore, dealerFromId, warehousetype);
                }
                else
                {
                    this.Bind_TransferWarehouseByDealerAndTypeWithoutDWH(WarehouseStore, dealerFromId, productLineId, warehousetype);
                }
            }
            else
            {
                this.Bind_TransferWarehouseByDealerAndType(WarehouseStore, dealerFromId, warehousetype);
            }
           
            //this.WarehouseStore.DataBind();
            this.DialogWindow.Show();
        }


        [AjaxMethod]
        public void DoAddItems(string param)
        {
            Ext.Msg.Confirm("消息", "确认要添加选中的产品", new MessageBox.ButtonsConfig
            {
                Yes = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.UC.DoYes('" + param + "')",
                    Text = "Yes"
                },
                No = new MessageBox.ButtonConfig
                {
                    Handler = "Coolite.AjaxMethods.UC.DoNo()",
                    Text = "No"
                }
            }).Show();
        }

        [AjaxMethod]
        public void DoYes(string param)
        {
            System.Diagnostics.Debug.WriteLine("AddItems : Param = " + param);

            param = param.Substring(0, param.Length - 1);

            ITransferBLL business = new TransferBLL();
            bool result;

            //modified by bozhenfei on 20100607
            result = business.AddItemsByType(this.hiddenDialogTransferType.Text,
                   new Guid(this.hiddenDialogTransferId.Text),
                   new Guid(this.hiddenDialogDealerFromId.Text),
                   new Guid(this.hiddenDialogDealerToId.Text),
                   new Guid(this.hiddenDialogProductLineId.Text),
                   param.Split(','),
                   (new Guid(this.hiddenDialogDealerToDefaultWarehouseId.Text))
                   );
            //if (string.IsNullOrEmpty(this.hiddenDialogDealerToDefaultWarehouseId.Text))
            //{
            // result = business.AddItemsByType(this.hiddenDialogTransferType.Text, 
            //    new Guid(this.hiddenDialogTransferId.Text), 
            //    new Guid(this.hiddenDialogDealerFromId.Text), 
            //    new Guid(this.hiddenDialogDealerToId.Text), 
            //    new Guid(this.hiddenDialogProductLineId.Text), 
            //    param.Split(','), 
            //    null
            //    );
            //}
            //else
            //{
            //    result = business.AddItemsByType(this.hiddenDialogTransferType.Text,
            //       new Guid(this.hiddenDialogTransferId.Text),
            //       new Guid(this.hiddenDialogDealerFromId.Text),
            //       new Guid(this.hiddenDialogDealerToId.Text),
            //       new Guid(this.hiddenDialogProductLineId.Text),
            //       param.Split(','),
            //       (new Guid(this.hiddenDialogDealerToDefaultWarehouseId.Text))
            //        //null
            //       );
            //}
            //Ext.Msg.Alert(GetLocalResourceObject("DoYes.Alert.title").ToString(), GetLocalResourceObject("DoYes.Alert.body").ToString()).Show();

            this.GridStore.DataBind();
            //this.DialogWindow.Hide();
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
                    //this.ImportWindow.Hide();

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

            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.hiddenDialogDealerFromId.Text))
            {
                param.Add("DealerId", this.hiddenDialogDealerFromId.Text);
            }
            if (!string.IsNullOrEmpty(this.hiddenDialogProductLineId.Text))
            {
                param.Add("ProductLine", this.hiddenDialogProductLineId.Text);
            }
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                param.Add("WarehouseId", this.cbWarehouse.SelectedItem.Value);
            }
           
            if (this.hiddenDialogTransferType.Text == TransferType.Transfer.ToString() || this.hiddenDialogTransferType.Text == TransferType.Rent.ToString())
            {
                string[] list = new string[1];
                list[0] = WarehouseType.Frozen.ToString();
                param.Add("QryWarehouseType", list);
            }
            else if (this.hiddenDialogTransferType.Text == TransferType.RentConsignment.ToString())
            {
                if (_context.User.CorpType == DealerType.HQ.ToString())
                {
                    param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                }
                else
                {
                    //string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(',')
                    //param.Add("QryWarehouseType", WarehouseType.LP_Consignment.ToString().Split(','));
                    param.Add("QryWarehouseType", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                }
            }
            else
            {
                if (_context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.LS.ToString() || _context.User.CorpType == DealerType.T1.ToString())
                {
                    param.Add("QryWarehouseType", WarehouseType.Consignment.ToString().Split(','));
                }
                else
                {
                    param.Add("QryWarehouseType", WarehouseType.LP_Consignment.ToString().Split(','));
                }
            }

            if (!string.IsNullOrEmpty(this.hiddenQrCodes.Text))
            {
                param.Add("QrCodes", this.hiddenQrCodes.Text);
                if (param.Contains("WarehouseId"))
                {
                    param.Remove("WarehouseId");
                }
            }
            
            DataTable ds = business.QueryCurrentInv(param).Tables[0];

            this.CurrentInvStore.DataSource = ds;
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