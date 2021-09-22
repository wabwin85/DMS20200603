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
    public class T2PointsAdjustmentUpload : UploadData
    {
        public T2PointsAdjustmentUpload(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2OutLinePointsUploader;
            this.LoadData += new EventHandler<DataEventArgs>(T2PointsAdjustmentUpload_LoadData);
        }

        //空格-32 \r-13 \n-10
        void T2PointsAdjustmentUpload_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                T2PointsAdjustmenDataSet dataSet = DataHelper.Deserialize<T2PointsAdjustmenDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<TProOutLinePoints> importData = new List<TProOutLinePoints>();

               

                foreach (T2PointsAdjustmentDataRecord record in dataSet.Records)
                {

                    importData.Add(new TProOutLinePoints
                    {
                        BatchNbr=e.BatchNbr,
                        Tier2DealerCode = record.Tier2DealerCode,
                        PointsAdjustDate = record.PointsAdjustDate,
                        Bscbu = record.BSCBU,
                        PointsValidToDate = record.PointsValidToDate,
                        PointsAmount = record.PointsAmount,
                        Remark = record.Remark,
                        Clientid=ClientID
                    });
                }

                //导入接口表
                TProOutLinePointsBLL business = new TProOutLinePointsBLL();
                business.ImportInterfaceT_PRO_OutLinePoints(importData);

                //调用存储过程导入DeliveryConfirmation表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleInterfaceOutLinePointsData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<TProOutLinePoints> errList = business.SelectInterfacePROOutLinePointsonByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (TProOutLinePoints errItem in errList)
                    {
                        errMsg += "二级经销商:" + errItem.Tier2DealerCode.ToString() + " " + errItem.ErMassage + "\r\n";
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
