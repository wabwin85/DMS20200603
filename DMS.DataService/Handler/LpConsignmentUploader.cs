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
    public class LpConsignmentUploader : UploadData
    {
        public LpConsignmentUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LpConsignmentUploader;
            this.LoadData += new EventHandler<DataEventArgs>(LpConsignmentUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void LpConsignmentUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                LpConsignmentDataSet dataSet = DataHelper.Deserialize<LpConsignmentDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceShipment> importData = new List<InterfaceShipment>();

                int line = 1;

                foreach (LpConsignmentDataRecord record in dataSet.Records)
                {
                    foreach (LpConsignmentDataItem item in record.Items)
                    {
                        importData.Add(new InterfaceShipment
                        {
                            Id = Guid.NewGuid(),
                            DealerSapCode = record.DistributorID,
                            OrderNo = record.OrderNo,
                            SapDeliveryNo = record.DeliveryNo,
                            SapDeliveryDate = record.DeliveryDate,
                            ToWhmCode = record.WHID,
                            ShipmentType = record.Type,
                            ArticleNumber = item.UPN,
                            LotNumber = item.Lot,
                            ExpiredDate = item.ExpDate,
                            DeliveryQty = item.Qty,
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr,
                            QrCode = item.QRCode
                        });
                    }
                    
                }

                //导入接口表
                DeliveryBLL business = new DeliveryBLL();
                business.ImportInterfaceShipment(importData);

                //调用存储过程导入DeliveryNote表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                business.HandleShipmentT2ConsignmentData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);

                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<DeliveryNote> errList = business.SelectDeliveryNoteByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (DeliveryNote errItem in errList)
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

                e.Message = string.Format("共获取{0}条销售二级经销商寄售数据", importData.Count);
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
