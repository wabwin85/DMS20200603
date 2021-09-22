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
    public class InventoryTransferForT2Uploader:UploadData
    {
        public InventoryTransferForT2Uploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.InventoryTransferForT2Uploader;
            this.LoadData += new EventHandler<DataEventArgs>(InventoryTransferForT2Uploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void InventoryTransferForT2Uploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                InventoryTransferForT2DataSet dataSet = DataHelper.Deserialize<InventoryTransferForT2DataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceTransferFort2> importData = new List<InterfaceTransferFort2>();

                int line = 1;

                foreach (InventoryTransferForT2DataRecord record in dataSet.Records)
                {
                    foreach (InventoryTransferForT2DataItem item in record.Items)
                    {
                        importData.Add(new InterfaceTransferFort2
                        {
                            Id = Guid.NewGuid(),
                            DealerSapCode = record.DistributorID,
                            Remark = record.Remark,
                            TransferFrom = item.TransferFromWHName,
                            TransferTo = item.TransferToWHName,
                            ArticleNumber = item.UPN,
                            LotNumber = item.Lot,
                            QrCode = item.QRCode,
                            LotTransferQty = item.Qty,
                            ImportDate = DateTime.Now,
                            LineNbr = line++,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr
                        });
                    }

                }

                //导入接口表
                TrasferBLL business = new TrasferBLL();
                business.ImportInterfaceTransferForT2(importData);

                //调用存储过程导入DeliveryConfirmation表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleTransferDataForT2(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<TransferNote> errList = business.SelectTransferNoteByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (TransferNote errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr.ToString() + " " + errItem.ProblemDescription + "\r\n";
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    //不存在错误信息
                    e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                }


                e.Message = string.Format("共获取{0}条收货确认数据", importData.Count);
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
