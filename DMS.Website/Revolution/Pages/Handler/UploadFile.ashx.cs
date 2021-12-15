using System;
using System.Web;
using System.IO;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using NPOI.XSSF.UserModel;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.SS.Formula.Eval;
using Newtonsoft.Json;
using DMS.Business;
using DMS.Business.DataInterface;
using DMS.Model;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Service;
using DMS.Model.Data;
using System.Web.SessionState;
using DMS.DataAccess;
using DMS.BusinessService.MasterDatas;

namespace DMS.Website.Revolution.Pages.Handler
{
    /// <summary>
    /// Kendo控件Excel上传处理类
    /// </summary>
    public class UploadFile : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                string type = HttpContext.Current.Request.QueryString["Type"].ToString();
                string dest = HttpContext.Current.Request.QueryString["Dest"];
                if (type == "InventoryInit" && !string.IsNullOrEmpty(dest) && dest == "Inv")
                {
                    type = "InventoryMonthly";
                }

                HttpPostedFile postedFile = HttpContext.Current.Request.Files["files"];
                if (postedFile == null)
                {
                    postedFile = HttpContext.Current.Request.Files["files2"];
                }
                string savepath = HttpContext.Current.Server.MapPath("/Upload/" + type + "/");      //type同时作为存放导入文件的文件夹名；
                string filename = postedFile.FileName;
                string msg = ValidateExtensions(filename, DMS.Common.SR.CONST_UploadExcelAllowedExtensions);
                if (!string.IsNullOrEmpty(msg))
                {
                    var lsrtn = new { result = "Error", msg = msg, ImportButtonDisable = true };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
                    return;
                }
                if (!Directory.Exists(savepath))
                    Directory.CreateDirectory(savepath);
                string fullpath = savepath + Guid.NewGuid().ToString() + Path.GetExtension(filename);
                postedFile.SaveAs(fullpath);

                //读取EXCEL文件 
                if (File.Exists(fullpath))
                {
                    ISheet sheet;
                    readSheet(fullpath, filename, out sheet);
                    if (sheet == null)
                    {
                        var lsrtn = new { result = "Error", msg = "模板错误，未找到名为\"" + HttpContext.Current.Request.QueryString["SheetName"].ToString() + "\"的Sheet，请检查模板文件！", ImportButtonDisable = true };

                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
                        return;
                    }

                    #region 读sheet列和数据，放到datatable中；

                    DataTable dt = new DataTable();
                    IEnumerator rows = sheet.GetRowEnumerator();

                    int rowCount = sheet.LastRowNum;//LastRowNum = PhysicalNumberOfRows - 1

                    if (rowCount < 0)
                    {
                        var lsrtn = new { result = "Error", msg = "导入失败，未读取到任何数据。", ImportButtonDisable = true };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
                        return;
                    }
                    for (int j = 0; j < (sheet.GetRow(0).LastCellNum); j++)
                    {
                        DataColumn column = new DataColumn(sheet.GetRow(0).GetCell(j).StringCellValue);
                        dt.Columns.Add(column);
                    }
                    dt.Columns.Add(new DataColumn("LineNbr"));

                    int colCount = dt.Columns.Count;

                    //根据导入的业务类型，检查导入模板是否正确
                    string templateErrorMsg = string.Empty;
                    if (!checkImportTemplate(type, dt, out templateErrorMsg))
                    {
                        var lsrtn = new { result = "Error", msg = templateErrorMsg, ImportButtonDisable = true };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
                        return;
                    }

                    //将Sheet中的数据放到table中；
                    for (int i = (sheet.FirstRowNum); i <= sheet.LastRowNum; i++)
                    {
                        IRow row = sheet.GetRow(i);
                        if (row != null)
                        {
                            //处理空行
                            if (row.Cells.Count <= 0)
                            {
                                continue;
                            }
                            DataRow dataRow = dt.NewRow();
                            if (row != null)
                            {
                                for (int j = row.FirstCellNum; j < colCount; j++)//row.LastCellNum
                                    dataRow[j] = getCellValue(row.GetCell(j));// row.GetCell(j).ToString();

                                dataRow[colCount - 1] = i + 1;      //行号

                                dt.Rows.Add(dataRow);
                            }
                        }
                    }
                    //if (!CheckData(type, dt))
                    //{
                    //    return;
                    //}

                    dt.Columns.Add(new DataColumn("ErrorMessage", Type.GetType("System.String")));

                    #endregion

                    //处理各种类型数据的导入；
                    if (dt.Rows.Count > 0)
                    {
                        //删除数据表中的空白行；
                        removeDatatableNullRow(dt);

                        switch (type)
                        {
                            //近效期打折导入规则
                            case "OrderDiscountRuleImport":
                                OrderDiscountRuleImport(dt);
                                break;
                            //经销商收货
                            case "POReceiPtImport":
                                POReceiPtImport(dt, filename);
                                break;
                            //退换货申请 Excel导入
                            case "InventoryReturnImport":
                                InventoryReturnImport(dt, filename);
                                break;
                            //退换货申请 寄售Excel导入
                            case "InventoryReturnConsignmentImport":
                                InventoryReturnConsignmentImport(dt, filename);
                                break;
                            //二级经销商订单申请  Excel导入
                            case "OrderImport":
                                OrderImport(dt, filename);
                                break;
                            //平台及一级经销商订单申请  Excel导入
                            case "OrderApplyLPImport":
                                OrderApplyLPImport(dt, filename);
                                break;
                            //经销商移库
                            case "TransferEditorImport":
                                TransferEditorImport(dt, filename);
                                break;
                            //销售数据批量上传
                            case "ShipmentInit":
                                ShipmentInitImport(dt, filename);
                                break;
                            //销售单发票号上传
                            case "ShipmentInvoiceInit":
                                ShipmentInvoiceInitImport(dt, filename);
                                break;
                            //销售单导入二维码
                            case "ShipmentQrCode":
                                ShipmentQrCodeImport(dt, filename);
                                break;
                            //期初库存导入
                            case "InventoryInit":
                                InventoryInitImport(dt, filename);
                                break;
                            //库存数据导入
                            case "InventoryMonthly":
                                InventoryMonthlyImport(dt, filename);
                                break;
                            //近效期寄售产品批量导入
                            case "BatchOrderInit":
                                BatchOrderInit(dt, filename);
                                break;
                            //其他出入库，普通仓库导入
                            case "InventoryAdjustAuditImport":
                                InventoryAdjustAuditImport(dt, filename);
                                break;
                            //产品价格导入
                            case "OrderDealerPriceImport":
                                OrderDealerPriceImport(dt);
                                break;
                            //借货出库导入
                            case "TransferListImport":
                                TransferListImport(dt, filename);
                                break;
                            //寄售转移导入
                            case "Consignment":
                                ConsignmentTransferImport(dt, filename);
                                break;
                            //用户入职日期和核算指标日期导入
                            case "UserInfoInit":
                                UserInfoInitImport(dt, filename);
                                break;
                            //用户入职日期和核算指标日期导入
                            case "HospitalPositionInit":
                                HospitalPositionInitImport(dt, filename);
                                break;
                            //发货数据导入
                            case "POReceiptDeliveryImport":
                                POReceiptDeliveryImport(dt);
                                break;
                            //医院标准指标导入
                            case "HospitalBaseAopImport":
                                HospitalBaseAopImport(dt);
                                break;
                            //商品发票配置导入
                            case "InvGoodsCfgImport":
                                VerifyInvGoodsCfgImport(dt);
                            break;
                            case "InvHospitalCfgImport":
                                VerifyInvHospitalCfgImport(dt);
                                break;
                            default:
                                break;
                        }
                    }
                    else
                    {
                        var lsrtn = new { result = "Error", msg = "Excel中没有数据可导入！", ImportButtonDisable = true };

                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                var lsrtn = new { result = "Error", msg = "导入失败!" + ex.Message + "。", ImportButtonDisable = true };

                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lsrtn));

            }
        }
        #region 其他出入库-普通仓库
        /// <summary>
        /// 其他出入库（普通仓库） Excel导入
        /// </summary>
        /// <param name="dt"></param>
        private void InventoryAdjustAuditImport(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = true;
            string errMsg = string.Empty;
            InventoryAdjustBLL business = new InventoryAdjustBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.ImportInventoryAdjustInit(dt, FileName))
                {
                    InventoryAdjustAuditImportData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = "Excel data format error!";
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        /// <summary>
        /// 其他出入库普通仓库
        /// </summary>
        /// <param name="importType"></param>
        /// <param name="errMsg"></param>
        /// <param name="IsValid"></param>
        /// <param name="ImportButtonDisabled"></param>
        private void InventoryAdjustAuditImportData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = true;
            InventoryAdjustBLL business = new InventoryAdjustBLL();
            IsValid = string.Empty;
            if (business.VerifyInventoryAdjustInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = false;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        ImportButtonDisabled = true;
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        #endregion

        #region 借货出库
        /// <summary>
        /// 借货出库 Excel导入
        /// </summary>
        /// <param name="dt"></param>
        private void TransferListImport(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = true;
            string errMsg = string.Empty;
            TransferBLL business = new TransferBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.TransferListImport(dt, FileName))
                {
                    TransferListImportData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = "Excel data format error!";
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void TransferListImportData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = true;
            TransferBLL business = new TransferBLL();
            IsValid = string.Empty;
            if (business.VerifyTransferListInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = false;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        ImportButtonDisabled = true;
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        #endregion

        #region 经销商移库
        /// <summary>
        /// 退换货申请 Excel导入
        /// </summary>
        /// <param name="dt"></param>
        private void TransferEditorImport(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = true;
            string errMsg = string.Empty;
            TransferBLL business = new TransferBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.Import(dt, FileName))
                {
                    TransferEditorImportData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = "Excel data format error!";
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void TransferEditorImportData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = true;
            TransferBLL business = new TransferBLL();
            IsValid = string.Empty;
            if (business.VerifyTransferInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = false;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        ImportButtonDisabled = true;
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        #endregion

        #region 平台及一级经销商订单申请
        /// <summary>
        /// 退换货申请 Excel导入
        /// </summary>
        /// <param name="dt"></param>
        private void OrderApplyLPImport(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = true;
            string errMsg = string.Empty;
            PurchaseOrderBLL business = new PurchaseOrderBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.ImportLP(dt, FileName))
                {
                    OrderApplyImportLPData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = "Excel data format error!";
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void OrderApplyImportLPData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = true;
            PurchaseOrderBLL business = new PurchaseOrderBLL();
            IsValid = string.Empty;
            if (business.VerifyPurchaseOrderInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = false;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        ImportButtonDisabled = true;
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        #endregion

        #region 二级经销商订单申请
        /// <summary>
        /// 退换货申请 Excel导入
        /// </summary>
        /// <param name="dt"></param>
        private void OrderImport(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = true;
            string errMsg = string.Empty;
            PurchaseOrderBLL business = new PurchaseOrderBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.Import(dt, FileName))
                {
                    OrderApplyImportData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = "Excel data format error!";
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void OrderApplyImportData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = true;
            PurchaseOrderBLL business = new PurchaseOrderBLL();
            IsValid = string.Empty;
            if (business.VerifyPurchaseOrderInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = false;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        ImportButtonDisabled = true;
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        #endregion

        #region 退换货申请
        /// <summary>
        /// 退换货申请 Excel导入
        /// </summary>
        /// <param name="dt"></param>
        private void InventoryReturnImport(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = true;
            string errMsg = string.Empty;
            InventoryAdjustBLL business = new InventoryAdjustBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.Import(dt, FileName, out result))
                {
                    ImportData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = result;
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void ImportData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = true;
            InventoryAdjustBLL business = new InventoryAdjustBLL();
            IsValid = string.Empty;
            if (business.VerifyInventoryReturnInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = false;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        ImportButtonDisabled = true;
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        /// <summary>
        /// 退换货申请 寄售Excel导入
        /// </summary>
        /// <param name="dt"></param>
        private void InventoryReturnConsignmentImport(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = false;
            string errMsg = string.Empty;
            InventoryAdjustBLL business = new InventoryAdjustBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.Import(dt, FileName, out result))
                {
                    ImportConsignmentData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = result;
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void ImportConsignmentData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = false;
            InventoryAdjustBLL business = new InventoryAdjustBLL();
            IsValid = string.Empty;
            if (business.VerifyInventoryReturnConsignmentInit(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = true;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        #endregion
        /// <summary>
        /// 近效期打折导入规则
        /// </summary>
        /// <param name="dt"></param>
        private void OrderDiscountRuleImport(DataTable dt)
        {


            IOrderDiscountRule business = new OrderDiscountRuleBLL();
            string IsValid = string.Empty;
            if (business.Import(dt))
            {
                business.VerifyOrderDiscountRuleInit("Import", out IsValid);
            }
            else
            {
                IsValid = "Error";
            }
            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = "", count = dt.Rows.Count };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }

        /// <summary>
        /// 销售数据批量上传
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="FileName"></param>
        private void ShipmentInitImport(DataTable dt, string FileName)
        {
            IShipmentBLL business = new ShipmentBLL();
            //判断队列中是否有未处理数据
            if (business.ShipmentInitCheck())
            {
                //先删除上传人之前的数据
                business.DeleteByUser();

                if (dt.Rows.Count > 0)
                {
                    if (business.Import(dt, FileName, "1"))
                    {
                        var lstresult = new { result = "Success", msg = "数据已在队列处理中！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                    else
                    {
                        var lstresult = new { result = "Error", msg = "数据导入异常！" };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                }
                else
                {
                    var lstresult = new { result = "DataError", msg = "没有数据可导入!" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "队列中包含未处理数据，不能导入销售单！请查看导入明细！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="FileName"></param>
        private void UserInfoInitImport(DataTable dt, string FileName)
        {
            IUserBiz business = new UserBiz();
            business.DeleteUserInfoInitByUser();

            if (dt.Rows.Count > 0)
            {
                if (business.UserInfoInitImport(dt, FileName))
                {
                    string RtnVal = string.Empty;
                    string RtnMsg = string.Empty;
                    business.UserInfoInitVerify(0, out RtnVal, out RtnMsg);
                    if (RtnVal == "Success")
                    {
                        var lstresult = new { result = "Success", msg = "上传成功！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                    else if (RtnVal == "Error")
                    {
                        var lstresult = new { result = "Success", msg = "有错误信息，请修改后重新上传！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                    else
                    {
                        var lstresult = new { result = "Success", msg = RtnMsg, count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                }
                else
                {
                    var lstresult = new { result = "Error", msg = "有错误信息，请修改后重新上传！" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "导入数据为空，请重新上传！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }

        private void HospitalPositionInitImport(DataTable dt, string FileName)
        {
            IPositionHospital business = new PositionHospitalBLL();
            business.DeleteUploadInfoByUser();

            if (dt.Rows.Count > 0)
            {
                if (business.UploadInfoImport(dt, FileName))
                {
                    string RtnVal = string.Empty;
                    string RtnMsg = string.Empty;
                    business.UploadInfoVerify(0, out RtnVal, out RtnMsg);
                    if (RtnVal == "Success")
                    {
                        var lstresult = new { result = "Success", msg = "上传成功！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                    else if (RtnVal == "Error")
                    {
                        var lstresult = new { result = "Success", msg = "有错误信息，请修改后重新上传！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                    else
                    {
                        var lstresult = new { result = "Success", msg = RtnMsg, count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                }
                else
                {
                    var lstresult = new { result = "Error", msg = "有错误信息，请修改后重新上传！" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "导入数据为空，请重新上传！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        /// <summary>
        /// 销售单发票号导入
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="FileName"></param>
        private void ShipmentInvoiceInitImport(DataTable dt, string FileName)
        {
            IShipmentBLL business = new ShipmentBLL();
            business.DeleteShipmentInvoiceInitByUser();

            if (dt.Rows.Count > 0)
            {
                if (business.InvoiceImport(dt, FileName))
                {
                    string RtnVal = string.Empty;
                    string RtnMsg = string.Empty;
                    business.InvoiceVerify(0, out RtnVal, out RtnMsg);
                    if (RtnVal == "Success")
                    {
                        var lstresult = new { result = "Success", msg = "上传成功！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                    else if (RtnVal == "Error")
                    {
                        var lstresult = new { result = "Success", msg = "有错误信息，请修改后重新上传！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                    else
                    {
                        var lstresult = new { result = "Success", msg = RtnMsg, count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                }
                else
                {
                    var lstresult = new { result = "Error", msg = "有错误信息，请修改后重新上传！" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "导入数据为空，请重新上传！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        /// <summary>
        /// 销售单导入二维码
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="FileName"></param>
        private void ShipmentQrCodeImport(DataTable dt, string FileName)
        {
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
                QrCodes = QrCodes.Substring(0, QrCodes.Length - 1);
                var lstresult = new { result = "Success", msg = "上传成功！", qrCode = QrCodes };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));

            }
            else
            {
                var lstresult = new { result = "DataError", msg = "上传失败！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }

        private void InventoryInitImport(DataTable dt, string FileName)
        {
            IInventoryInitBLL business = new InventoryInitBLL();
            if (dt.Rows.Count > 1)
            {
                if (business.Import(dt, FileName))
                {
                    string IsValid = string.Empty;

                    if (business.Verify(out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            var lstresult = new { result = "Success", msg = "上传成功！" };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        }
                        else if (IsValid == "Error")
                        {
                            var lstresult = new { result = "Error", msg = "有错误信息，请修改后重新上传！", count = dt.Rows.Count };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        }
                        else
                        {
                            var lstresult = new { result = "Error", msg = "数据导入异常！", count = dt.Rows.Count };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        }
                    }
                    else
                    {
                        var lstresult = new { result = "DataError", msg = "数据导入过程发生错误！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                }
                else
                {
                    var lstresult = new { result = "Error", msg = "有错误信息，请修改后重新上传！" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "导入数据为空，请重新上传！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }

        private void InventoryMonthlyImport(DataTable dt, string FileName)
        {
            IInventoryInitBLL business = new InventoryInitBLL();
            //先删除上传人之前的数据
            business.DeleteByUser();
            if (dt.Rows.Count > 1)
            {
                if (business.ImportDealerInv(dt, FileName))
                {
                    string IsValid = string.Empty;

                    if (business.VerifyDII(out IsValid, 0))
                    {
                        if (IsValid == "Error")
                        {
                            var lstresult = new { result = "Error", msg = "数据包含错误！", count = dt.Rows.Count };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        }
                    }
                    else
                    {
                        var lstresult = new { result = "DataError", msg = "数据导入过程发生错误！", count = dt.Rows.Count };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                }
                else
                {
                    var lstresult = new { result = "Error", msg = "Excel数据格式错误！" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "没有数据可导入！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }

        #region 近效期寄售产品及订单批量导入

        private void BatchOrderInit(DataTable dt, string FileName)
        {
            bool ImportButtonDisabled = true;
            string errMsg = string.Empty;
            IBatchOrderInitBLL business = new BatchOrderInitBLL();
            string IsValid = string.Empty;
            if (dt.Rows.Count > 1)
            {
                string result = string.Empty;
                if (business.ImportLP(dt, FileName))
                {
                    BatchOrderInitImportData("Upload", out errMsg, out IsValid, out ImportButtonDisabled);
                }
                else
                {
                    errMsg = "Excel data format error!";
                    // Ext.Msg.Alert(GetLocalResourceObject("ImportClick.Alert.Title2").ToString(), result).Show();
                }
            }

            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = errMsg, count = dt.Rows.Count, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = errMsg, ImportButtonDisable = ImportButtonDisabled };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void BatchOrderInitImportData(string importType, out string errMsg, out string IsValid, out bool ImportButtonDisabled)
        {
            errMsg = string.Empty;
            ImportButtonDisabled = true;
            IBatchOrderInitBLL business = new BatchOrderInitBLL();
            IsValid = string.Empty;
            if (business.VerifyBatchOrderInitBLL(importType, out IsValid))
            {
                if (IsValid == "Success")
                {
                    if (importType == "Upload")
                    {
                        ImportButtonDisabled = false;
                        errMsg = "已成功上传文件！";
                    }
                    else
                    {
                        ImportButtonDisabled = true;
                        errMsg = "数据导入成功！";
                    }
                }
                else if (IsValid == "Error")
                {
                    errMsg = "数据包含错误！";
                }
                else
                {
                    errMsg = "数据导入异常！";
                }
            }
            else
            {
                errMsg = "导入数据过程发生错误！";
            }

        }
        #endregion
        /// <summary>
        /// 经销商收货
        /// </summary>
        /// <param name="dt"></param>
        private void POReceiPtImport(DataTable dt, string newFileName)
        {
            IPOReceipt business = new DMS.Business.POReceipt();
            string IsValid = string.Empty;
            //导入到中间表
            if (dt.Rows.Count > 1)
            {

                DeliveryBLL Dbusiness = new DeliveryBLL();
                string batchNumber = string.Empty;
                string ClientID = string.Empty;
                string Messinge = string.Empty;
                if (business.POReceImport(dt, newFileName, out batchNumber, out ClientID, out Messinge))
                {
                    //GridPanel3.ColumnModel.SetHidden(1, true);
                    DataSet ds1 = business.DistinctInterfaceShipmentBYBatchNbr(batchNumber);
                    if (ds1.Tables[0].Rows.Count > 0)
                    {
                        Messinge = Messinge + "一张发货单号不能对应多张采购单编号\r\n";
                    }
                    DataSet ds2 = business.SelectInterfaceShipmentBYBatchNbrQtyUnprice(batchNumber);
                    {
                        foreach (DataRow row in ds2.Tables[0].Rows)
                        {
                            if (row["qtyMessinge"] != DBNull.Value)
                            {
                                Messinge = Messinge + row["qtyMessinge"].ToString() + "\r\n";
                            }
                        }
                    }
                    if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                    {
                        DataSet ds3 = business.SelectPoreCeExistsDma(batchNumber, RoleModelContext.Current.User.CorpId.Value.ToString());
                        if (ds3.Tables[0].Rows.Count > 0)
                        {
                            Messinge = Messinge + ds3.Tables[0].Rows[0][0].ToString();
                            Messinge = Messinge.Replace("</Messinge>", "<br/>");
                        }
                    }
                    if (!string.IsNullOrEmpty(Messinge))
                    {
                        var lstresult = new { result = "DataError", msg = Messinge };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        return;
                    }
                    string RtnMsg = string.Empty;
                    Dbusiness.HandleShipmentT2NormalData(batchNumber, ClientID, out IsValid, out RtnMsg);
                    if (!IsValid.Equals("Success"))
                    {
                        var lstresult = new { result = "DataError", data = batchNumber, msg = RtnMsg };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        return;
                    }
                    else
                    {
                        IList<DeliveryNote> errList = Dbusiness.SelectDeliveryNoteByBatchNbrErrorOnly(batchNumber);

                        if (errList != null && errList.Count > 0)
                        {
                            //存在错误信息
                            var lstresult = new { result = "DataError", data = batchNumber, msg = "存在错误信息" };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                            return;
                        }
                        else
                        {
                            var lstresult = new { result = "Success", msg = "上传成功", count = dt.Rows.Count };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                            return;
                        }
                    }


                }
                else
                {
                    //dataValidMsg = Messinge;
                    var lstresult = new { result = "DataError", msg = Messinge };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    return;
                }
            }
            else
            {
                IsValid = "Error";
            }
            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = "", count = dt.Rows.Count };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }

        /// <summary>
        /// 产品价格导入
        /// </summary>
        /// <param name="dt"></param>
        private void OrderDealerPriceImport(DataTable dt)
        {


            ICfnPriceService business = new CfnPriceService();
            string IsValid = string.Empty;
            if (business.Import(dt))
            {
                business.VerifyDealerPriceInit("Import", out IsValid);
            }
            else
            {
                IsValid = "Error";
            }
            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = "", count = dt.Rows.Count };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        /// <summary>
        /// 发货数据导入
        /// </summary>
        /// <param name="dt"></param>
        private void POReceiptDeliveryImport(DataTable dt)
        {
            string IsVR = HttpContext.Current.Request.Params["IsVR"].ToString();
            string strAutoNbr = HttpContext.Current.Request.Params["AutoNbr"].ToString();
            DeliveryNotes business = new DeliveryNotes();
            PoReceiptHeaderDao prhDao = new PoReceiptHeaderDao();
            string IsValid = string.Empty;
            IList<DeliveryNote> delivery = business.Import(dt, strAutoNbr,IsVR);
            if (delivery.Count<=0)
            {
                //如果是虚拟发货导入直接执行收货操作
                //if (IsVR == "1")
                //{
                //    prhDao.UpdateByAutoNbr(strAutoNbr);
                //}
                var lstresult = new { result = "Success", msg = "", count = dt.Rows.Count };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        private void ConsignmentTransferImport(DataTable dt, string FileName)
        {
            IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
            if (dt.Rows.Count > 1)
            {
                if (bll.ImportTransfer(dt, FileName))
                {
                    string IsValid = string.Empty;

                    if (bll.VerifyConsignmentTransferInit("Upload", out IsValid))
                    {
                        if (IsValid == "Success")
                        {
                            var lstresult = new { result = "Success", msg = "上传成功！", count = dt.Rows.Count };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        }
                        else if (IsValid == "Error")
                        {
                            var lstresult = new { result = "DataError", msg = "上传文件中包含错误数据，详情查看列表！" };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        }
                        else
                        {
                            var lstresult = new { result = "Error", msg = "数据导入异常！" };
                            HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                        }
                    }
                    else
                    {
                        var lstresult = new { result = "Error", msg = "导入数据过程发生错误！" };
                        HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                    }
                }
                else
                {
                    var lstresult = new { result = "DataError", msg = "包含错误数据，请确认！" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "数据为空，请维护数据！" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }
        /// <summary>
        /// 医院标准指标导入
        /// </summary>
        /// <param name="dt"></param>
        private void HospitalBaseAopImport(DataTable dt)
        {


            HospitalBaseAopImportService business = new HospitalBaseAopImportService();
            string IsValid = string.Empty;
            if (business.Import(dt))
            {
                business.VerifyAopHospitalReferenceImport("Import", out IsValid);
            }
            else
            {
                IsValid = "Error";
            }
            if (IsValid == "Success")
            {
                var lstresult = new { result = "Success", msg = "", count = dt.Rows.Count };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                var lstresult = new { result = "DataError", msg = "" };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
        }

        protected void VerifyInvGoodsCfgImport(DataTable dt)
        {
            InvGoodsCfgImportService business = new InvGoodsCfgImportService();
            string IsValid = string.Empty;
            bool isError;
            bool tag = business.ImportTemp(dt,out isError);
            if (isError)
            {
                var lstresult = new { result = "DataError", msg = "上传数据中有误，请检查错误信息", count = dt.Rows.Count };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                if (!tag)
                {
                    IsValid = "Duplicate Data";
                }
                else
                {
                    IsValid = "Success";
                } 
                if (IsValid == "Success")
                {
                    var lstresult = new { result = "Success", msg = "是否要上传数据", count = dt.Rows.Count };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
                else
                {
                    var lstresult = new { result = "DataDuplicate", msg = "数据有重复，是否需要覆盖" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
        }
        
        protected void VerifyInvHospitalCfgImport(DataTable dt)
        {
            InvHospitalImportService business = new InvHospitalImportService();
            string IsValid = string.Empty;
            bool isError;
            bool tag = business.ImportTemp(dt, out isError);
            if (isError)
            {
                var lstresult = new { result = "DataError", msg = "上传数据中有误，请检查错误信息", count = dt.Rows.Count };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
            }
            else
            {
                if (!tag)
                {
                    IsValid = "Duplicate Data";
                }
                else
                {
                    IsValid = "Success";
                }
                if (IsValid == "Success")
                {
                    var lstresult = new { result = "Success", msg = "是否要上传数据", count = dt.Rows.Count };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
                else
                {
                    var lstresult = new { result = "DataDuplicate", msg = "数据有重复，是否需要覆盖" };
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                }
            }
        }

        private bool CheckData(string type, DataTable dt)
        {
            return true;
            /*
            IList<ErrorMsg> lst = new List<ErrorMsg>();

            switch (type)
            {
                case "OrderDiscountRuleImport":
                    #region
                    foreach (DataRow dr in dt.Rows)
                    {
                        string ErrorMessage = string.Empty;
                        if (dr["产品线"] == null || dr["产品线"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "产品线不能为空;";
                        }
                        if (dr["经销商账号"] == null || dr["经销商账号"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "经销商账号不能为空;";
                        }
                        if (dr["产品编号"] == null || dr["产品编号"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "产品编号不能为空;";
                        }
                        if (dr["批号"] != null && dr["批号"].ToString().Trim() != string.Empty)
                        {
                            ErrorMessage += "批号不能为空;";
                        }
                        if (dr["大于等于"] == null || dr["大于等于"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "大于等于不能为空;";
                        }
                        else
                        {
                            int qty = 0;
                            if (!int.TryParse(dr["大于等于"].ToString().Trim(), out qty))
                            {
                                ErrorMessage += "大于等于格式不正确;";
                            }
                            else if(qty < 0)
                            {
                                ErrorMessage += "大于等于不能小于0;";
                            }
                        }
                        if (dr["小于"] == null || dr["小于"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "小于不能为空;";
                        }
                        else
                        {
                            int qty = 0;
                            if (!int.TryParse(dr["小于"].ToString().Trim(), out qty))
                            {
                                ErrorMessage += "小于格式不正确;";
                            }
                            else if (qty < 0)
                            {
                                ErrorMessage += "小于不能小于0;";
                            }
                        }
                        if (dr["折扣率"] == null || dr["折扣率"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "折扣率不能为空;";
                        }
                        else
                        {
                            decimal qty = 0;
                            if (!decimal.TryParse(dr["折扣率"].ToString().Trim(), out qty))
                            {
                                ErrorMessage += "折扣率格式不正确;";
                            }
                        }
                        if (dr["开始时间"] == null || dr["开始时间"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "开始时间不能为空;";
                        }
                        else
                        {
                            DateTime dtTime ;
                            if (!DateTime.TryParse(dr["开始时间"].ToString().Trim(), out dtTime))
                            {
                                ErrorMessage += "开始时间格式不正确;";
                            }
                        }
                        if (dr["终止时间"] == null || dr["终止时间"].ToString().Trim() == string.Empty)
                        {
                            ErrorMessage += "终止时间不能为空;";
                        }
                        else
                        {
                            DateTime dtTime;
                            if (!DateTime.TryParse(dr["终止时间"].ToString().Trim(), out dtTime))
                            {
                                ErrorMessage += "终止时间格式不正确;";
                            }
                        }
                        if (!string.IsNullOrEmpty(ErrorMessage))
                        {
                            OrderDiscountRuleImportVO errorMsg = new OrderDiscountRuleImportVO();
                            errorMsg.ProductLineName = dr["产品线"].ToString();
                            errorMsg.SAPCode = dr["经销商账号"].ToString();
                            errorMsg.DealerName = dr["经销商"].ToString();
                            errorMsg.Upn = dr["产品编号"].ToString();
                            errorMsg.Lot = dr["批号"].ToString();
                            errorMsg.LeftValue = (dr["大于等于"] == null || dr["大于等于"].ToString() == string.Empty) ? (int?)null : Convert.ToInt32(dr["大于等于"]);
                            errorMsg.RightValue = (dr["小于"] == null || dr["小于"].ToString() == string.Empty) ? (int?)null : Convert.ToInt32(dr["小于"]);
                            errorMsg.DiscountValue = (dr["折扣率"] == null || dr["折扣率"].ToString() == string.Empty) ? (decimal?)null : Convert.ToDecimal(dr["折扣率"]);
                            errorMsg.BeginDate = (dr["开始时间"] == null || dr["开始时间"].ToString() == string.Empty) ? (DateTime?)null : Convert.ToDateTime(dr["开始时间"]); 
                            errorMsg.BeginDate = (dr["终止时间"] == null || dr["终止时间"].ToString() == string.Empty) ? (DateTime?)null : Convert.ToDateTime(dr["终止时间"]);
                            int lineNbr;
                            if (int.TryParse(dr["LineNbr"].ToString(), out lineNbr))
                            {
                                errorMsg.LineNbr = lineNbr;
                            }
                            errorMsg.ErrorMessage = ErrorMessage;
                            lst.Add(errorMsg);
                            var query_OrderDiscountRuleImport = lst.Select(item => item);
                            if (query_OrderDiscountRuleImport.Any())
                            {
                                var lstresult = new { result = "DataError", msg = query_OrderDiscountRuleImport };
                                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                                return false;
                            }
                            return true;
                        }
                    }
                    #endregion
                    break;
                default:
                    break;
            }

            var query = lst.Select(item => new { 行号 = item.LineNbr, 错误信息 = item.ErrorMessage });
            if (query.Any())
            {
                var lstresult = new { result = "DataError", msg = query };
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(lstresult));
                return false;
            }
            return true;
            */
        }



        #region 公用

        /// <summary>
        /// 读取导入Excel的数据；
        /// </summary>
        /// <param name="fullpath"></param>
        /// <param name="filename"></param>
        /// <param name="sheet"></param>
        protected void readSheet(string fullpath, string filename, out ISheet sheet)
        {
            //读取xlsx文件；
            XSSFWorkbook xssfworkbook;
            //读取xls文件；
            HSSFWorkbook hssfworkbook;
            try
            {
                using (FileStream file = new FileStream(fullpath, FileMode.Open, FileAccess.Read))
                {
                    if (Path.GetExtension(filename).ToLower() == ".xlsx")
                    {
                        xssfworkbook = new XSSFWorkbook(file);

                        //获取Sheet名称，如果没有传入sheet名称，则默认获取第一个sheet
                        if (HttpContext.Current.Request.QueryString["SheetName"] != null)
                        {
                            sheet = xssfworkbook.GetSheet(HttpContext.Current.Request.QueryString["SheetName"].ToString());
                        }
                        else
                        {
                            sheet = xssfworkbook.GetSheetAt(0);
                        }
                    }
                    else
                    {
                        hssfworkbook = new HSSFWorkbook(file);

                        //获取Sheet名称，如果没有传入sheet名称，则默认获取第一个sheet
                        if (HttpContext.Current.Request.QueryString["SheetName"] != null)
                        {
                            sheet = hssfworkbook.GetSheet(HttpContext.Current.Request.QueryString["SheetName"].ToString());
                        }
                        else
                        {
                            sheet = hssfworkbook.GetSheetAt(0);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        private bool checkCaptions(DataTable dt, string[] captions)
        {
            try
            {
                bool Success = true;
                for (int i = 0; i < captions.Length; i++)
                {
                    if (dt.Columns[i].Caption != captions[i])
                    {
                        Success = false;
                    }
                }
                return Success;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        /// <summary>
        /// 检查导入模板是否正确；
        /// </summary>
        /// <param name="type">导入类型</param>
        protected bool checkImportTemplate(string type, DataTable dt, out string templateErrorMsg)
        {
            bool templateFlag = true;
            string msg = string.Empty;

            switch (type)
            {
                //近效期折扣规则
                case "OrderDiscountRuleImport":
                    if (!checkCaptions(dt, new string[] { "产品线", "经销商账号", "经销商", "产品编号", "产品名称", "批号", "数量", "二维码", "大于等于", "小于", "折扣率", "开始时间", "终止时间" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //PO收货
                case "POReceiPtImport":
                    if (!checkCaptions(dt, new string[] { "二级经销商编号", "二级经销商采购单编号", "物流平台或RLD发货单编号", "发货日期", "销售类型", "产品UPN", "产品批号", "二维码", "发货数量", "发货产品价格(含税单价)" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //退换货申请Excel导入
                case "InventoryReturnImport":
                    if (!checkCaptions(dt, new string[] { "仓库名称", "产品型号", "产品批次号", "退货数量", "关联订单号","二维码" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //退换货申请 寄售申请Excel导入
                case "InventoryReturnConsignmentImport":
                    if (!checkCaptions(dt, new string[] { "仓库名称", "产品型号", "产品批次号", "退货数量", "关联订单号","二维码" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //二级经销商订单申请  Excel导入
                case "OrderImport":
                    if (!checkCaptions(dt, new string[] { "单据类型", "产品线", "产品型号", "订购数量" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //平台及一级经销商订单申请  Excel导入
                case "OrderApplyLPImport":
                    if (!checkCaptions(dt, new string[] { "单据类型", "产品线", "产品型号", "订购数量", "批号", "金额", "积分类型" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //经销商移库  Excel导入
                case "TransferEditorImport":
                    if (!checkCaptions(dt, new string[] { "移出仓库名称", "移入仓库名称", "产品型号", "产品批次号", "二维码", "数量" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //借货出库导入
                case "TransferListImport":
                    if (!checkCaptions(dt, new string[] { "移出经销商名称", "移出仓库名称", "移入经销商名称(简称)", "移入仓库名称", "产品型号", "产品批次号", "二维码", "数量" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //销售数据批量上传
                case "ShipmentInit":
                    if (!checkCaptions(dt, new string[] { "医院名称", "销售日期", "仓库名称", "产品型号", "产品批号", "二维码", "销售数量", "销售单价", "医院科室", "发票号码", "发票日期", "发票抬头", "产品名称", "过效期产品用量日期", "备注", "短期寄售申请单号" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //销售单发票号导入
                case "ShipmentInvoiceInit":
                    if (!checkCaptions(dt, new string[] { "销售单号", "发票号" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //销售单导入二维码
                case "ShipmentQrCode":
                    if (!checkCaptions(dt, new string[] { "二维码" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //期初库存导入
                case "InventoryInit":
                    if (!checkCaptions(dt, new string[] { "经销商SAP Account", "仓库名称", "产品型号", "有效期", "批号/序列号", "数量" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //库存数据导入
                case "InventoryMonthly":
                    if (!checkCaptions(dt, new string[] { "经销商编号", "经销商名称", "仓库名称", "产品型号（UPN）", "批号", "数量", "库存期间" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //近效期寄售产品批量导入
                case "BatchOrderInit":
                    if (!checkCaptions(dt, new string[] { "产品线", "经销商账号", "经销商", "产品编号", "产品名称", "批号", "数量", "二维码", "大于等于", "小于", "折扣率", "开始时间", "终止时间" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //其他出入库，普通仓库导入
                case "InventoryAdjustAuditImport":
                    if (!checkCaptions(dt, new string[] { "类型", "经销商编号", "经销商名称", "仓库名称", "产品型号", "产品批次", "二维码", "数量" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //价格规则维护
                case "OrderDealerPriceImport":
                    if (!checkCaptions(dt, new string[] { "产品代码", "产品价格", "价格类型", "SapCode", "省份", "地区", "开始时间", "终止时间" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //寄售转移导入
                case "Consignment":
                    if (!checkCaptions(dt, new string[] { "移入经销商编号", "移入经销商名称(简称)", "移出经销商编号", "移出经销商名称", "产品线名称", "产品", "申请数量", "医院编号", "寄售合同编号" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //用户入职日期和核算指标日期导入
                case "UserInfoInit":
                    if (!checkCaptions(dt, new string[] { "用户登录ID", "入职时间", "核算指标时间" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //导入销售岗位与医院关系
                case "HospitalPositionInit":
                    if (!checkCaptions(dt, new string[] { "医院编码" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //发货数据导入
                case "POReceiptDeliveryImport":
                    if (!checkCaptions(dt, new string[] { "ERPCode", "订单编号", "发货编号", "发货日期", "销售类型", "快递公司", "快递单号", "运输方式", "UPN", "批次号", "产品有效期", "发货数量", "单价", "产品生产日期", "二维码", "税率", "ERP主表内码", "ERP明细表内码", "ERP金额", "ERP税率" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                //医院标准指标导入
                case "HospitalBaseAopImport":
                    if (!checkCaptions(dt, new string[] { "分子公司", "品牌", "产品线", "产品分类", "年份", "医院名称", "医院编号", "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月","是否删除" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                case "InvGoodsCfgImport":
                    if(!checkCaptions(dt, new string[] { "分子公司", "品牌", "产品线" ,"产品型号","产品中文名称","发票规格型号"}))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                case "InvHospitalCfgImport":
                    if (!checkCaptions(dt, new string[] { "DMS医院名称", "发票医院名称", "医院编号", "SFE医院编号", "省份", "地区" , "区县" }))
                    {
                        templateFlag = false;
                        msg = "模板错误，请从当前页面下载模板导入！";
                    }
                    break;
                default:
                    templateFlag = false;
                    msg = "模板错误！";
                    break;
            }
            templateErrorMsg = msg;

            return templateFlag;
        }


        /// <summary>
        /// 删除数据表中的空白行；
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        protected void removeDatatableNullRow(DataTable dt)
        {
            List<DataRow> removelist = new List<DataRow>();
            foreach (DataRow dr in dt.Rows)
            {
                bool rowIsNull = true;
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    if (dr[i].ToString().Trim() != "" && dt.Columns[i].Caption.ToString() != "LineNbr")
                    {//排除LineNbr列；
                        rowIsNull = false;
                        continue;
                    }
                }
                if (rowIsNull)
                {
                    removelist.Add(dr);
                }
            }
            foreach (DataRow dr in removelist)
            {
                dt.Rows.Remove(dr);
            }
        }
        /// <summary>
        /// 删除数据表中跟本次导入无关的列；并将剩余的列排序；
        /// </summary>
        protected void removeDatatableUselessColumn(DataTable dt, string[] cols)
        {
            //获取需要删除的列
            List<string> lscols = new List<string>();
            foreach (DataColumn dc in dt.Columns)
            {
                if (!cols.Contains(dc.Caption.ToString()) && dc.Caption.ToString() != "LineNbr" && dc.Caption.ToString() != "ErrorMessage")
                {
                    lscols.Add(dc.Caption.ToString());
                }
            }
            //删除不必要的列；
            if (lscols.Count > 0)
            {
                foreach (string col in lscols)
                {
                    dt.Columns.Remove(col);
                }
            }
            //调整dt的列顺序使之与存储过程表类型字段顺序一致；
            foreach (string col in cols)
            {
                dt.Columns[col].SetOrdinal(Array.IndexOf(cols, col));
            }
        }

        protected string getCellValue(ICell cell)
        {
            string rtnvalue = string.Empty;
            if (cell == null) return "";
            switch (cell.CellType)
            {
                case CellType.Boolean:
                    rtnvalue = cell.BooleanCellValue.ToString();
                    break;
                case CellType.Error:
                    rtnvalue = ErrorEval.GetText(cell.ErrorCellValue);
                    break;
                case CellType.Numeric:
                    if (DateUtil.IsCellDateFormatted(cell))
                    {//Excel日期格式列的type也为Numeric；
                        rtnvalue = cell.DateCellValue.ToString("yyyy-MM-dd");
                    }
                    else
                    {
                        rtnvalue = cell.NumericCellValue.ToString();
                    }
                    break;
                case CellType.String:
                    string strValue = cell.StringCellValue;
                    if (!string.IsNullOrEmpty(strValue))
                    {
                        rtnvalue = strValue.ToString();
                    }
                    else
                    {
                        rtnvalue = null;
                    }
                    break;
                case CellType.Unknown:
                case CellType.Blank:
                default:
                    rtnvalue = string.Empty;
                    break;
            }

            return rtnvalue;
        }

        public static bool IsGUID(string expression)
        {
            if (expression != null)
            {
                Regex guidRegEx = new Regex(@"^(\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}{0,1})$");
                return guidRegEx.IsMatch(expression);
            }
            return false;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        /// <summary>
        /// 检查文件类型
        /// </summary>
        /// <param name="filename">文件名</param>
        /// <param name="allowedExtensions">允许的文件类型，多个文件类型用逗号隔开，不传入参数则用配置文件中的不允许文件类型检测</param>
        /// <returns>方法返回空表示正确，错误则返回对应MSG</returns>
        public string ValidateExtensions(string filename, string allowedExtensions = null)
        {
            try
            {
                string ext = System.IO.Path.GetExtension(filename).ToLower();
                if (string.IsNullOrEmpty(allowedExtensions))
                {

                    return string.Empty;

                }
                else
                {
                    if (allowedExtensions.Split(',').Contains(ext))
                    {
                        return string.Empty;
                    }
                    else
                    {
                        return "上传文件格式不在支持范围内,仅支持" + allowedExtensions + "的文件！";
                    }
                }
            }
            catch (Exception ex)
            {

                return ex.ToString();
            }
        }

        #endregion

    }
}