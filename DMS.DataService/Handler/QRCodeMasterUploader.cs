using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using System.Text;
using System.Globalization;
using DMS.Model;
using DMS.Business.MasterData;
using DMS.DataService.Util;

namespace DMS.DataService.Handler
{
    public class QRCodeMasterUploader : UploadData
    {
        public QRCodeMasterUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.QRCodeMasterUploader;
            this.LoadData += new EventHandler<DataEventArgs>(QRCodeMasterUploader_LoadData);
        }

        void QRCodeMasterUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                QRCodeMasterDataSet dataSet = DataHelper.Deserialize<QRCodeMasterDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceqrCodeMaster> importData = new List<InterfaceqrCodeMaster>();

                int line = 1;

                foreach (QRCodeMasterDataRecord record in dataSet.Records)
                {
                    foreach (QRCodeMasterDataItem item in record.Items)
                    {
                        importData.Add(new InterfaceqrCodeMaster
                        {
                            Id = Guid.NewGuid(),
                            QrCode = item.QRCode,
                            Status = item.Status,
                            CreateDate = item.CreateDate,
                            UserCode = item.UserCode,
                            Channel = item.Channel,                           
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr,
                        });
                    }
                }

                //导入接口表
                QRCodeBLL business = new QRCodeBLL();
                business.ImportInterfaceQRCodeMaster(importData);

                //调用存储过程导入QRCodeMaster表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                business.HandleQRMasterData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);

                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<InterfaceqrCodeMaster> errList = business.SelectInterfaceQRCodeMasterByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (InterfaceqrCodeMaster errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr + " " + errItem.ErrorMsg + "\r\n";
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
