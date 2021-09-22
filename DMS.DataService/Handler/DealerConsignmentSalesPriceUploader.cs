using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using System.Text;
using System.Globalization;
using DMS.Model;
using DMS.Business.DataInterface;
using DMS.DataService.Util;
using DMS.Model.DataInterface;

namespace DMS.DataService.Handler
{
    public class DealerConsignmentSalesPriceUploader : UploadData
    {
        public DealerConsignmentSalesPriceUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.DealerConsignmentSalesPriceUploader;
            this.LoadData += new EventHandler<DataEventArgs>(DealerConsignmentSalesPriceUploader_LoadData);
        }

        void DealerConsignmentSalesPriceUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                DealerConsignmentSalesPriceDataSet dataSet = DataHelper.Deserialize<DealerConsignmentSalesPriceDataSet>(e.ReturnXml);
                
                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceDealerConsignmentSalesPrice> importData = new List<InterfaceDealerConsignmentSalesPrice>();

                int line = 1;

                foreach (DealerConsignmentSalesPriceDataRecord record in dataSet.Records)
                {
                    foreach (DealerConsignmentSalesPriceDataItem item in record.Items)
                    {
                        String strQRCode = "";
                        if (String.IsNullOrEmpty(item.QRCode))
                        {
                            strQRCode = "NoQR";
                        }
                        else
                        {
                            strQRCode = item.QRCode;
                        }
                            
                        
                        importData.Add(new InterfaceDealerConsignmentSalesPrice
                        {
                            Id = Guid.NewGuid(),
                            SalesNo = record.SalesNo,
                            OrderNo = record.OrderNo,
                            ConfirmDate = record.ConfirmDate,
                            Remark = record.Remark,
                            Upn = item.UPN,
                            Lot = item.Lot + "@@" + strQRCode,
                            Qty = item.Qty,
                            UnitPrice = item.UnitPrice,
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr
                        });
                    }
                }

                //导入接口表
                DeliveryBLL business = new DeliveryBLL();
                business.ImportInterfaceDealerConsignmentSalesPrice(importData);

                //调用存储过程导入DeliveryNote表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                business.HandleDealerConsignmentSalesPriceData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);

                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<InterfaceDealerConsignmentSalesPrice> errList = business.SelectDataByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (InterfaceDealerConsignmentSalesPrice errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr + " " + errItem.ProblemDescription + "\r\n"; 
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    //不存在错误信息
                    e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                }


                e.Message = string.Format("共获取{0}条发货数据", importData.Count);
                e.Success = true;
            }
            catch (Exception ex)
            {
                e.Success = false;
                e.Message = ex.Message;
            }
        }
    }
}
