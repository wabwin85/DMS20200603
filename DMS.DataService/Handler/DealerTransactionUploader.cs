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
    public class DealerTransactionUploader : UploadData
    {
        public DealerTransactionUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.DealerTransactionUploader;
            this.LoadData += new EventHandler<DataEventArgs>(DealerTransactionUploader_LoadData);
        }

        void DealerTransactionUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");
                    
                DealerTransactionDataSet dataSet = DataHelper.Deserialize<DealerTransactionDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceqrDealerTransaction> importData = new List<InterfaceqrDealerTransaction>();

                int line = 1;

                foreach (DealerTransactionDataRecord record in dataSet.Records)
                {
                    foreach (DealerTransactionDataItem item in record.Items)
                    {
                        importData.Add(new InterfaceqrDealerTransaction
                        {
                            
                            Id = Guid.NewGuid(),
                            DealerCode= record.DealerCode,
                            UserName = record.UserName,
                            UploadDate = record.UploadDate,
                            DataType = record.DataType,
                            Remark = record.Remark,
                            RowNo = item.RowNo,
                            Upn = item.UPN,
                            Lot = item.LOT,
                            QrCode = item.QRCode,                          
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr,
                        });
                    }
                }

                //导入接口表
                QRCodeBLL business = new QRCodeBLL();
                business.ImportInterfaceQRDealerTransaction(importData);

                //调用存储过程导入DealerTransaction表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                business.HandleQRDealerTransaction(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);

                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<InterfaceqrDealerTransaction> errList = business.SelectInterfaceDealerTransactionByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg>{0}</rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (InterfaceqrDealerTransaction errItem in errList)
                    {
                        errMsg += "<Item>" + errItem.ErrorMsg + "</Item>";
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
