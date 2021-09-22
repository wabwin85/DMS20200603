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
    public class HospitalSalesForT2Uploader: UploadData
    {
        public HospitalSalesForT2Uploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.HospitalSalesForT2Uploader;
            this.LoadData += new EventHandler<DataEventArgs>(HospitalSalesForT2Uploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void HospitalSalesForT2Uploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                HospitalSalesForT2DataSet dataSet = DataHelper.Deserialize<HospitalSalesForT2DataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceHospitalSalesFort2> importData = new List<InterfaceHospitalSalesFort2>();

                int line = 1;

                foreach (HospitalSalesForT2DataRecord record in dataSet.Records)
                {
                    foreach (HospitalSalesForT2DataItem item in record.Items)
                    {
                        importData.Add(new InterfaceHospitalSalesFort2
                        {
                            Id = Guid.NewGuid(),
                            Distributorid = record.DistributorID,
                            HospitalCode = record.HospitalCode,
                            Type = record.Type,
                            SaleDate = record.SalesDate,
                            Departments = record.Departments,
                            Remark = record.Remark,
                            InvoiceNo = record.InvoiceNo,
                            InvoiceTitle = record.InvoiceTitle,
                            InvoiceDate = record.InvoiceDate,
                            ArticleNumber = item.UPN,
                            LotNumber = item.Lot,
                            UnitPrice = item.UnitPrice,
                            LotQty = item.Qty,
                            QrCode = item.QRCode,
                            WarehouseName  =item.WarehouseName,
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr
                        });

                    }
                }

                //导入接口表
                SalesBLL business = new SalesBLL();
                business.ImportInterfaceSalesForT2(importData);

                //调用存储过程导入DeliveryConfirmation表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleSalesForT2Data(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

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