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
    public class LpTransferUploader : UploadData
    {
        public LpTransferUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LpTransferUploader;
            this.LoadData += new EventHandler<DataEventArgs>(LpTransferUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void LpTransferUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                LpTransferDataSet dataSet = DataHelper.Deserialize<LpTransferDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceTransferForls> importData = new List<InterfaceTransferForls>();

                int line = 1;

                foreach (LpTransferDataRecord record in dataSet.Records)
                {
                    foreach (LpTransferDataItem item in record.Items)
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

                        importData.Add(new InterfaceTransferForls
                        {
                            Id = Guid.NewGuid(),
                            TransferNumber = record.TransferNumber,
                            OutWarehouseCode = record.OutWarehouseCode,
                            InWarehouseCode = record.InWarehouseCode,
                            TransferDate = record.TransferDate,
                            Remark = record.Remark,
                            Upn = item.UPN,
                            Lot = item.Lot,
                            QrCode = item.QRCode,
                            LotMasterLotNumber = item.Lot + "@@" + strQRCode,
                            Qty = item.Qty,
                            TransferType = "Transfer",                            
                            LineNbr = line++,
                            FileName = record.TransferNumber,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr                           
                        });
                    }

                }

                //导入接口表
                TrasferBLL business = new TrasferBLL();
                business.ImportInterfaceTransferForLS(importData);

                //调用存储过程导入TransferNote表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleTransferLSData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<InterfaceTransferForls> errList = business.SelectTransferForLsByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (InterfaceTransferForls errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr.ToString() + " " + errItem.ErrorDescription + "\r\n";
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    //不存在错误信息
                    e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                }


                e.Message = string.Format("共获取{0}条借货数据", importData.Count);
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
