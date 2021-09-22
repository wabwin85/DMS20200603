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
    public class LpReturnConfirmationUploader : UploadData
    {
        public LpReturnConfirmationUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LpReturnConfirmationUploader;
            this.LoadData += new EventHandler<DataEventArgs>(LpReturnConfirmationUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void LpReturnConfirmationUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                LpReturnConfirmationDataSet dataSet = DataHelper.Deserialize<LpReturnConfirmationDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceAdjustConfirmation> importData = new List<InterfaceAdjustConfirmation>();

                int line = 1;

                foreach (LpReturnConfirmationDataRecord record in dataSet.Records)
                {
                    importData.Add(new InterfaceAdjustConfirmation
                    {
                        Id = Guid.NewGuid(),
                        AdjustNo = record.ReturnNo,
                        ConfirmDate = record.ConfirmDate,
                        IsConfirm = record.IsConfirm,
                        Remark = record.Remark,
                        LineNbr = line++,
                        ImportDate = DateTime.Now,
                        Clientid = this.ClientID,
                        BatchNbr = e.BatchNbr
                    });

                }

                //导入接口表
                AdjustBLL business = new AdjustBLL();
                business.ImportInterfaceAdjustConfirmation(importData);

                //调用存储过程导入DeliveryConfirmation表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleAdjustConfirmationData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<AdjustConfirmation> errList = business.SelectAdjustConfirmationByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (AdjustConfirmation errItem in errList)
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


                e.Message = string.Format("共获取{0}条退货确认数据", importData.Count);
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
