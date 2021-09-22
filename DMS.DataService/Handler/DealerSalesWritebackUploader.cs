using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Model.DataInterface;
using DMS.DataService.Util;
using DMS.Model;
using DMS.Business.DataInterface;
using DMS.Business;
using DMS.Model.Data;


namespace DMS.DataService.Handler
{
    public class DealerSalesWritebackUploader : UploadData
    {
        public DealerSalesWritebackUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.DealerSalesWritebackUploader;
            this.LoadData += new EventHandler<DataEventArgs>(DealerSalesWritebackUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void DealerSalesWritebackUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                DealerSalesWritebackDataSet dataSet = DataHelper.Deserialize<DealerSalesWritebackDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceDealerSalesWriteback> importData = new List<InterfaceDealerSalesWriteback>();

                int line = 1;

                foreach (DealerSalesWritebackDataRecord record in dataSet.Records)
                {
                    importData.Add(new InterfaceDealerSalesWriteback
                       {
                           Id = Guid.NewGuid(),
                           WriteBackNo = record.WriteBackNo,
                           SalesNo = record.SalesNo,
                           WriteBackDate = record.WriteBackDate,
                           Remark = record.Remark,
                           LineNbr = line++,
                           ImportDate = DateTime.Now,
                           Clientid = this.ClientID,
                           BatchNbr = e.BatchNbr
                       });


                }

                //导入接口表 
                ShipmentBLL business = new ShipmentBLL();
                business.InsertDealerSalesWriteback(importData);

                //调用存储过程导入Warehouse表，并返回结果
                string RtnMsg = string.Empty;
                string IsValid = string.Empty;
                business.AfterInterfaceDealerSalesWritebackUpload(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);

                //如果调用过程失败则抛错
                if (!IsValid.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<InterfaceDealerSalesWriteback> errList = business.SelectDealerSalesWritebackByBatchNbrErrorOnly(e.BatchNbr);
                IList<InterfaceDealerSalesWriteback> List = business.SelectDealerSalesWritebackByBatchNbr(e.BatchNbr);
                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (InterfaceDealerSalesWriteback errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr.ToString() + " " + errItem.ErrorMsg + "\r\n";
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    //冲红处理
                    foreach (InterfaceDealerSalesWriteback data in List)
                    {
                        business.RevokeInterface(data.WriteBackNo, data.ShipmentId, data.SalesNo,data.WriteBackDate.Value,data.Remark);
                    }

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
