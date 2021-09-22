using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.OleDb;
using System.IO;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;

namespace DMS.Website.Pages.Shipment
{
    public partial class ShipmentInit : BasePage
    {

        private IShipmentBLL business = new ShipmentBLL();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.ImportButton.Disabled = true;

            }
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            //判断队列中是否有未处理数据
            if (business.ShipmentInitCheck())
            {

                //先删除上传人之前的数据
                business.DeleteByUser();

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
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Title").ToString(),
                            Message = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Message").ToString()
                        });

                        return;
                    }



                    //构造文件名称

                    string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("\\Upload\\ShipmentInit\\" + newFileName);


                    //文件上传
                    FileUploadField1.PostedFile.SaveAs(file);

                    this.hiddenFileName.Text = newFileName;
                    System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                    #endregion

                    #region 读取文件到中间表
                    //导入到中间表
                    DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                    //根据列数量判断文件模板是否正确
                    if (dt.Columns.Count < 15)
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Body").ToString()).Show();

                    }
                    else
                    {

                        if (dt.Rows.Count > 0)
                        {
                            if (business.Import(dt, newFileName,"1"))
                            {
                                string IsValid = string.Empty;
                                //if (business.Verify(out IsValid, 0))
                                //{
                                //    if (IsValid == "Error")
                                //    {
                                //        Ext.Msg.Alert("", GetLocalResourceObject("ImportClick.IsValid.WarningError.Alert.Title").ToString()).Show();
                                //    }

                                //}
                                Ext.Msg.Alert("导入成功", "数据已在队列处理中").Show();
                            }
                            else
                            {
                                Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), GetLocalResourceObject("ImportClick.Alert.Body2").ToString()).Show();
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title3").ToString(), GetLocalResourceObject("ImportClick.Alert.Body3").ToString()).Show();
                        }

                        #endregion

                    }
                }

                else
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = GetLocalResourceObject("UploadClick.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("UploadClick.Msg.Show.Message").ToString()
                    });


                }
            }
            else {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "错误",
                    Message = "队列中包含未处理数据，不能导入销售单！请查看导入明细"
                });
            }

        }

        protected void VerificationClick(object sender, AjaxEventArgs e)
        {
            //判断队列中是否有未处理数据
            if (business.ShipmentInitCheck())
            {

                //先删除上传人之前的数据
                business.DeleteByUser();

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
                        Ext.Msg.Show(new MessageBox.Config
                        {
                            Buttons = MessageBox.Button.OK,
                            Icon = MessageBox.Icon.INFO,
                            Title = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Title").ToString(),
                            Message = GetLocalResourceObject("UploadClick.HasFile.Msg.Show.Message").ToString()
                        });

                        return;
                    }



                    //构造文件名称

                    string newFileName = Guid.NewGuid().ToString() + "." + fileExtention;

                    //上传文件在Upload文件夹

                    string file = Server.MapPath("\\Upload\\ShipmentInit\\" + newFileName);


                    //文件上传
                    FileUploadField1.PostedFile.SaveAs(file);

                    this.hiddenFileName.Text = newFileName;
                    System.Diagnostics.Debug.WriteLine("Upload Finish : " + DateTime.Now.ToString());
                    #endregion

                    #region 读取文件到中间表
                    //导入到中间表
                    DataTable dt = ExcelHelper.GetDataTable(file, "sheet1");

                    //根据列数量判断文件模板是否正确
                    if (dt.Columns.Count < 15)
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Success.Alert.Body").ToString()).Show();

                    }
                    else
                    {

                        if (dt.Rows.Count > 0)
                        {
                            if (business.Import(dt, newFileName,"0"))
                            {
                                string IsValid = string.Empty;
                                //if (business.Verify(out IsValid, 0))
                                //{
                                //    if (IsValid == "Error")
                                //    {
                                //        Ext.Msg.Alert("", GetLocalResourceObject("ImportClick.IsValid.WarningError.Alert.Title").ToString()).Show();
                                //    }

                                //}
                                Ext.Msg.Alert("导入成功", "数据已在队列处理中,且只校验不提交！").Show();
                            }
                            else
                            {
                                Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), GetLocalResourceObject("ImportClick.Alert.Body2").ToString()).Show();
                            }
                        }
                        else
                        {
                            Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title3").ToString(), GetLocalResourceObject("ImportClick.Alert.Body3").ToString()).Show();
                        }

                        #endregion

                    }
                }

                else
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.ERROR,
                        Title = GetLocalResourceObject("UploadClick.Msg.Show.Title").ToString(),
                        Message = GetLocalResourceObject("UploadClick.Msg.Show.Message").ToString()
                    });


                }
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "错误",
                    Message = "队列中包含未处理数据，不能导入销售单！请查看导入明细"
                });
            }

        }

        protected void UploadConfirm(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

                DMS.Model.ShipmentInit obj = business.SelectShipmentCount();
                this.hiddenLineNbr.Text = obj.LineNbr.ToString();
                this.hiddenQty.Text = Convert.ToDecimal(obj.Qty).ToString("0.00");
                this.hiddenPrice.Text = Convert.ToDecimal(obj.Price).ToString("0.00");
            }

        }


        [AjaxMethod]
        public void ImportClick()
        {
            ImportData();

            this.ResultStore.DataBind();

        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            this.ResultStore.DataSource = business.QueryErrorData((e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            this.ResultStore.DataBind();
            e.TotalCount = totalCount;
        }

        private void ImportData()
        {
            string IsValid = string.Empty;

            if (business.Verify(out IsValid, 1))
            {
                if (IsValid == "Success")
                {
                    try
                    {
                        string rtnVal = string.Empty;
                        string rtnMsg = string.Empty;
                        business.InsertImportData(out rtnVal, out rtnMsg);
                        if (rtnVal == "Success")
                        {
                            business.UpdateReportInventoryHistory();
                            business.DeleteByUser();

                            Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Error.Alert.Body").ToString()).Show();
                        }
                    }
                    catch
                    {
                        Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Alert.Body").ToString()).Show();
                    }
                }
                else if (IsValid == "Error")
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.IsValid.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.IsValid.Alert.Body").ToString()).Show();
                }
                else
                {
                    Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title").ToString(), GetLocalResourceObject("ImportClick.Alert.Body").ToString()).Show();
                }
            }
            else
            {
                Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title1").ToString(), GetLocalResourceObject("ImportClick.Alert.Body1").ToString()).Show();
            }

        }

        [AjaxMethod]
        public void Save(string id, string hospitalCode, string hosptialName, string hospitalOffice,
            string invoiceNumber, string invoiceDate, string invoiceTitle, string shipmentDate, string articleNumber, string chineseName, string lotNumber, string price,
             string qty, string Warehouse, string lotShipmentDate, string remark, string ConsignmentNbr,string QrCode)
        {
            DMS.Model.ShipmentInit init = new DMS.Model.ShipmentInit();
            init.Id = new Guid(id);
            init.HospitalCode = hospitalCode;
            init.HospitalName = hosptialName;
            init.HospitalOffice = hospitalOffice;
            init.InvoiceNumber = invoiceNumber;
            init.InvoiceDate = String.IsNullOrEmpty(invoiceDate) ? null : invoiceDate;
            init.ShipmentDate = shipmentDate;
            init.ArticleNumber = articleNumber;
            init.ChineseName = chineseName;
            init.LotNumber = lotNumber;
            init.QrCode = QrCode;
            init.Price = price;
            //init.Uom = uom;
            init.Qty = qty;
            init.Warehouse = Warehouse;
            init.InvoiceTitle = invoiceTitle;
            init.LotShipmentDate = String.IsNullOrEmpty(lotShipmentDate) ? null : lotShipmentDate;
            init.Remark = remark;
            init.ConsignmentNbr = ConsignmentNbr;
           
            business.Update(init);

        }

        [AjaxMethod]
        public void Delete(string id)
        {
            business.Delete(new Guid(id));

        }
    }
}
