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
    public class T2CreditMemoUpload : UploadData
    {
        public T2CreditMemoUpload(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2RedInvoiceUploader;
            this.LoadData += new EventHandler<DataEventArgs>(T2CreditMemoUpload_LoadData);
        }
        //空格-32 \r-13 \n-10
        void T2CreditMemoUpload_LoadData(object sender, DataEventArgs e)
        {
            try {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");
                T2CreditMemoDataSet dataset = DataHelper.Deserialize<T2CreditMemoDataSet>(e.ReturnXml);
                IList<TProRedInvoice> importData = new List<TProRedInvoice>();
                foreach (T2CreditMemoDataRecord item in dataset.Records)
                {
                    importData.Add(new TProRedInvoice
                    {
                        BatchNbr = e.BatchNbr,
                        Tier2DealerCode = item.Tier2DealerCode,
                        Bscbu = item.BSCBU,
                        InvoiceNumber = item.InvoiceNumber,
                        InvoiceDate = item.InvoiceDate,
                        InvoiceAmount=item.InvoiceAmount,
                        Remark = item.Remark,
                        Clientid = ClientID
                    });

                }
                //导入接口表
                TProRedInvoiceBLL business = new TProRedInvoiceBLL();
                business.ImportInterfaceT_PRO_TProRedInvoice(importData);

                //调用存储过程导入DeliveryConfirmation表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleInterfaceTPRORedInvoiceDate(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);
                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);
                IList<TProRedInvoice> errList = business.SelectInterfaceTProRedInvoiceByBatchNbrErrorOnly(e.BatchNbr);
                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (TProRedInvoice errItem in errList)
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
