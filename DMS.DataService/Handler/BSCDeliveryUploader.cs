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

namespace DMS.DataService.Handler
{
    public class BSCDeliveryUploader : UploadData
    {
        public BSCDeliveryUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.BSCDeliveryUploader;
            this.LoadData += new EventHandler<DataEventArgs>(BSCDeliveryUploader_LoadData);
        }

        void BSCDeliveryUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                BSCSLCDeliveryDataSet dataSet = DataHelper.Deserialize<BSCSLCDeliveryDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceShipmentbscslc> importData = new List<InterfaceShipmentbscslc>();

                int line = 1;

                foreach (BSCSLCDeliveryDataRecord record in dataSet.Records)
                {
                    foreach (BSCSLCDeliveryDataItem item in record.Items)
                    {
                        importData.Add(new InterfaceShipmentbscslc
                        {
                            Id = Guid.NewGuid(),
                            DeliveryNo = record.DeliveryNo,
                            DeliveryDate = record.DeliveryDate,
                            SoldTosapCode = record.SoldToSAPCode,
                            SoldToName = record.SoldToName,
                            ShipTosapCode = record.ShipToSAPCode,
                            ShipToName = record.ShipToName,

                            Upn = item.UPN,
                            LotNumber = item.Lot,
                            QrCode = item.QRCode,
                            DeliveryQty = item.Qty,
                            ExpiredDate = item.ExpDate,                           
                            OrderNo = item.OrderNo,
                            BoxNo = item.BoxNo,
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr,
                            WaveNo= item.WaveNo,
                            PlateNo= item.PlateNo

                        });
                    }
                }

                //导入接口表
                DeliveryBLL business = new DeliveryBLL();
                business.ImportInterfaceShipmentBSCSLC(importData);

                //调用存储过程导入DeliveryNote表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                business.HandleShipmentBSCSLCData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);

                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<DeliveryNotebscslc> errList = business.SelectDeliveryNoteBSCSLCByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (DeliveryNotebscslc errItem in errList)
                    {
                        errMsg += "Line:" + errItem.SapDeliveryLineNbr + " " + errItem.ProblemDescription + "\r\n";
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
