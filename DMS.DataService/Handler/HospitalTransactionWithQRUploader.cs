using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.DataService.Util;
using DMS.Model;
using DMS.Business.DataInterface;
using DMS.Model.DataInterface;

namespace DMS.DataService.Handler
{
    public class HospitalTransactionWithQRUploader:UploadData
    {
        public HospitalTransactionWithQRUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.HospitalTransactionWithQRUploader;
            this.LoadData += new EventHandler<DataEventArgs>(HospitalTransactionWithQRUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void HospitalTransactionWithQRUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                HospitalTransactionDataSet dataSet = DataHelper.Deserialize<HospitalTransactionDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceHospitalTransactionWithqr> importData = new List<InterfaceHospitalTransactionWithqr>();

                int line = 1;

                foreach (HospitalTransactionDataRecord record in dataSet.Records)
                {
                    foreach (HospitalTransactionDataItem item in record.Items)
                    {
                        importData.Add(new InterfaceHospitalTransactionWithqr
                        {
                            Id = Guid.NewGuid(),
                            ApplicationType = record.ApplicationType,
                            ApplicationDate = record.ApplicationDate,
                            ApplicationNbr = record.ApplicationNbr,
                            DealerSapCode = record.DealerCode,
                            Remark = record.Remark,
                            QrCode = item.QRCode,
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
                 AdjustBLL business = new AdjustBLL();
                 business.ImportInterfaceHospitalTransaction(importData);

                //调用存储过程导入AdjustNote表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleHospitalTransactionData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<InterfaceHospitalTransactionWithqr> errList = business.SelectHospitalTransactionByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (InterfaceHospitalTransactionWithqr errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr.ToString() + " " + errItem.ErrorMsg + "\r\n";
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    //不存在错误信息
                    e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                }


                e.Message = string.Format("共获取{0}条数据", importData.Count);
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
