using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DMS.Business;
using DMS.DataService.Util;
using DMS.Model.DataInterface;
using System.Data;
using DMS.DataAccess;
using DMS.Model;

namespace DMS.UploadSalesToBSC
{
    public class UploadSales
    {
        public void DoExecute()
        {
            try
            {
                string strUploadCount = ConfigurationManager.AppSettings["UploadCount"];
                int iUploadCount = 0;
                int iTotalCount = 0;
                string strXml = string.Empty;
                if (!int.TryParse(strUploadCount, out iUploadCount))
                {
                    iUploadCount = 100;
                }

                var AuthHeader = new BSCPlatformService.AuthHeader()
                {
                    User = ConfigurationManager.AppSettings["User"],
                    Password = ConfigurationManager.AppSettings["Password"]
                };

                //LpSalesDataSet ds = new LpSalesDataSet();
                //LpSalesDataRecord salesDataRecord = new LpSalesDataRecord();
                //salesDataRecord.CustomerID = "H001017";
                //salesDataRecord.Type = "1";
                //salesDataRecord.SalesDate = DateTime.Now;
                //salesDataRecord.SalesNo = "BPSD2020020601";
                //salesDataRecord.ServiceAgent = "上海葡萄城信息技术有限公司";
                //salesDataRecord.Items = new List<LpSalesDataItem>();
                //LpSalesDataItem salesDataItem = new LpSalesDataItem();
                //salesDataItem.UPN = "644088-207";
                //salesDataItem.Lot = "0000188589";
                //salesDataItem.QRCode = "43212242123221";
                //salesDataItem.UnitPrice = 300;
                //salesDataItem.Qty = 1;
                //salesDataRecord.Items.Add(salesDataItem);

                //ds.Records = new List<LpSalesDataRecord>();
                //ds.Records.Add(salesDataRecord);
                //strXml = DataHelper.Serialize(ds);

                ShipmentBLL bllShipment = new ShipmentBLL();
                DataSet dsShipmentHeader = bllShipment.SelectShipmentHeaderToUploadToBSC(0, iUploadCount,
                    out iTotalCount);
                if (dsShipmentHeader.Tables.Count > 0)
                {
                    DataTable dtShipmentHeader = dsShipmentHeader.Tables[0];
                    foreach (DataRow drShipmentHeader in dtShipmentHeader.Rows)
                    {
                        try
                        {
                            DataSet dsShipmentLot =
                                bllShipment.SelectShipmentLotToUploadToBSC(drShipmentHeader["SPH_ID"].ToString());
                            if (dsShipmentLot.Tables.Count > 0 && dsShipmentLot.Tables[0].Rows.Count > 0)
                            {
                                DataTable dtShipmentLot = dsShipmentLot.Tables[0];

                                LpSalesDataSet lpSalesDataSet = new LpSalesDataSet();
                                LpSalesDataRecord salesDataRecord = new LpSalesDataRecord();
                                salesDataRecord.CustomerID = drShipmentHeader["CustomerID"].ToString();
                                salesDataRecord.Type = "1";
                                salesDataRecord.SalesDate = DateTime.Parse(drShipmentHeader["SalesDate"].ToString());
                                salesDataRecord.SalesNo = drShipmentHeader["SalesNo"].ToString();
                                salesDataRecord.ServiceAgent = drShipmentHeader["ServiceAgent"].ToString();
                                salesDataRecord.Remark = drShipmentHeader["SPH_NoteForPumpSerialNbr"].ToString();
                                salesDataRecord.Items = new List<LpSalesDataItem>();
                                foreach (DataRow drShipmentLot in dtShipmentLot.Rows)
                                {
                                    LpSalesDataItem salesDataItem = new LpSalesDataItem();
                                    salesDataItem.WHMCode = ConfigurationManager.AppSettings["WHMCode"];
                                    salesDataItem.UPN = drShipmentLot["UPN"].ToString();
                                    salesDataItem.Lot = drShipmentLot["Lot"].ToString();
                                    salesDataItem.QRCode = drShipmentLot["QRCode"].ToString();
                                    salesDataItem.UnitPrice = decimal.Parse(drShipmentLot["UnitPrice"].ToString());
                                    salesDataItem.Qty = decimal.Parse(drShipmentLot["Qty"].ToString());
                                    salesDataRecord.Items.Add(salesDataItem);
                                }

                                lpSalesDataSet.Records = new List<LpSalesDataRecord> { salesDataRecord };
                                strXml = DataHelper.Serialize(lpSalesDataSet);

                                BSCPlatformService.PlatformSoapClient soapBSCPlatform =
                                    new BSCPlatformService.PlatformSoapClient();
                                string strResult = soapBSCPlatform.UploadLpSales(AuthHeader, strXml);
                                if (strResult.Equals("<result><rtnVal>1</rtnVal></result>",
                                    StringComparison.OrdinalIgnoreCase) ||
                                    strResult.Contains("销售单号已使用过，不能重复上传")
                                    )
                                {
                                    UploadLog log = new UploadLog();
                                    log.Id = Guid.NewGuid();
                                    log.Type = "UploadSalesToBSC";
                                    log.Rev1 = drShipmentHeader["SalesNo"].ToString();
                                    log.Rev2 = "Success";
                                    log.DmaId = Guid.Empty;
                                    log.CreateUser = Guid.Empty;
                                    log.UploadDate = log.CreateDate = DateTime.Now;
                                    using (UploadLogDao dao = new UploadLogDao())
                                    {
                                        dao.Insert(log);
                                    }
                                }
                                else
                                {
                                    UploadLog log = new UploadLog();
                                    log.Id = Guid.NewGuid();
                                    log.Type = "UploadSalesToBSC";
                                    log.Rev1 = drShipmentHeader["SalesNo"].ToString();
                                    log.Rev2 = "Failed";
                                    log.Rev3 = strResult.Length > 2000 ? strResult.Substring(0, 2000) : strResult;
                                    log.DmaId = Guid.Empty;
                                    log.CreateUser = Guid.Empty;
                                    log.UploadDate = log.CreateDate = DateTime.Now;
                                    using (UploadLogDao dao = new UploadLogDao())
                                    {
                                        dao.Insert(log);
                                    }

                                    //ErrorLog(string.Format("执行时间:{0}, 销售出库单号：{1},错误信息:{2},XML内容：{3}", DateTime.Now,
                                    //    drShipmentHeader["SalesNo"].ToString(), strResult, strXml));
                                    ErrorLog(string.Format("执行时间:{0}, 销售出库单号：{1},错误信息:{2}", DateTime.Now,
                                        drShipmentHeader["SalesNo"].ToString(), strResult));
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            ErrorLog(string.Format("执行时间:{0}, 销售出库单号：{1},错误信息:{2}", DateTime.Now,
                                drShipmentHeader["SalesNo"].ToString(), ex.InnerException));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorLog(ex);
            }
        }

        public static void ErrorLog(Exception ex)
        {
            string strLog = String.Format("执行时间:{0},异常信息：{1}", DateTime.Now, ex.Message + "," + ex.StackTrace);
            ErrorLog(strLog);
        }
        public static void ErrorLog(string errorMsg)
        {
            string path = Directory.GetCurrentDirectory() + "/logs";
            path = path.Replace("/", "\\");
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            FileStream fs;
            StreamWriter sw;
            string strFileName = @"/Error_" + DateTime.Now.ToString("yyyyMMdd") + ".txt";
            if (File.Exists(path + strFileName))
            {
                fs = new FileStream(path + strFileName, FileMode.Append, FileAccess.Write);
            }
            else
            {
                fs = new FileStream(path + strFileName, FileMode.Create, FileAccess.Write);
            }
            sw = new StreamWriter(fs);
            sw.WriteLine(errorMsg);
            sw.Close();
            fs.Close();
        }
    }
}
