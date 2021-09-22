﻿using System;
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
    public class LpSalesUploader : UploadData
    {
        public LpSalesUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LpSalesUploader;
            this.LoadData += new EventHandler<DataEventArgs>(LpSalesUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void LpSalesUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                LpSalesDataSet dataSet = DataHelper.Deserialize<LpSalesDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceSales> importData = new List<InterfaceSales>();

                int line = 1;

                foreach (LpSalesDataRecord record in dataSet.Records)
                {
                    foreach(LpSalesDataItem item in record.Items)
                    {
                        importData.Add(new InterfaceSales
                        {
                            Id = Guid.NewGuid(),
                            HospitalCode = record.CustomerID,
                            SaleType = record.Type,
                            SaleDate = record.SalesDate,
                            Remark = record.Remark,

                            SalesNo = record.SalesNo,
                            ServiceAgent = record.ServiceAgent,

                            ArticleNumber = item.UPN,
                            LotNumber = item.Lot,
                            UnitPrice = item.UnitPrice,
                            LotQty = item.Qty,
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr,
                            QrCode = item.QRCode,
                        });
                    }
                    
                }

                //导入接口表
                SalesBLL business = new SalesBLL();
                business.ImportInterfaceSales(importData);

                //调用存储过程导入SalesNote表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleSalesData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<SalesNote> errList = business.SelectSalesNoteByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (SalesNote errItem in errList)
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


                e.Message = string.Format("共获取{0}条销售数据", importData.Count);
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
