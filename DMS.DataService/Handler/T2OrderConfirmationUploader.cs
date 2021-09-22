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
using System.Data;
using System.Net;
using DMS.DataAccess;
using DMS.Business;

namespace DMS.DataService.Handler
{
    public class T2OrderConfirmationUploader :UploadData
    {
        public T2OrderConfirmationUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2OrderConfirmationUploader;
            this.LoadData += new EventHandler<DataEventArgs>(T2OrderConfirmationUploader_LoadData);
        }
        
        //空格-32 \r-13 \n-10
        void T2OrderConfirmationUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                    throw new Exception("传入字符串为空");

                T2OrderConfirmationDataSet dataSet = DataHelper.Deserialize<T2OrderConfirmationDataSet>(e.ReturnXml);

                if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                    throw new Exception("传入数据为空");

                IList<InterfaceConfirmation> importData = new List<InterfaceConfirmation>();

                int line = 1;

                foreach (T2OrderConfirmationDataRecord record in dataSet.Records)
                {
                    foreach (T2OrderConfirmationDataItem item in record.Items)
                    {
                        importData.Add(new InterfaceConfirmation
                        {
                            Id = Guid.NewGuid(),
                            DealerSapCode = record.DistributorID,
                            OrderNo = record.OrderNo,
                            ArticleNumber = item.UPN,
                            UnitPrice = item.UnitPrice,
                            OrderNum = item.Qty,
                            LineNbr = line++,
                            ImportDate = DateTime.Now,
                            Clientid = this.ClientID,
                            BatchNbr = e.BatchNbr
                        });
                    }
                }

                //导入接口表
                ConfirmationBLL business = new ConfirmationBLL();
                business.ImportInterfaceT2OrderConfirmation(importData);

                //调用存储过程导入DeliveryConfirmation表，并返回结果
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                business.HandleT2OrderConfirmationData(e.BatchNbr, this.ClientID, out RtnVal, out RtnMsg);

                //如果调用过程失败则抛错
                if (!RtnVal.Equals("Success"))
                    throw new Exception(RtnMsg);

                //如果调用过程成功，则检查是否存在未通过验证的数据
                IList<PurchaseOrderConfirmation> errList = business.SelectPurchaseOrderConfirmationByBatchNbrErrorOnly(e.BatchNbr);

                if (errList != null && errList.Count > 0)
                {
                    //存在错误信息
                    e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                    string errMsg = string.Empty;
                    foreach (PurchaseOrderConfirmation errItem in errList)
                    {
                        errMsg += "Line:" + errItem.LineNbr.ToString() + " " + errItem.ProblemDescription + "\r\n";
                    }
                    e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                }
                else
                {
                    string errMsg = string.Empty;
                    //查询本次确认中Endo产品线的订单，判断是否第一次平台调用接口，如果是，则调用WebService传输到EW
                    //Edit By SongWeiming on 2016-11-12 停用接口
                    /*
                    PurchaseOrderBLL purchaseorder = new PurchaseOrderBLL();
                    DataSet ds = new DataSet();
                    ds = purchaseorder.SelectInterfaceOrderByBatchNo(e.BatchNbr);
                    if (ds != null && ds.Tables[0].Rows.Count > 0)
                    {
                        DMS.Business.EwfService.WfAction wfAction = new DMS.Business.EwfService.WfAction();
                        wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);
                        string template = string.Empty;//WorkflowTemplate.EndoOrderTemplate.Clone().ToString();
                        string rtnVal = string.Empty;
                        string rtnMsg = string.Empty;
                        string userAccount = string.Empty;
                        bool result;
                        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        {
                            DataRow dr = ds.Tables[0].Rows[i];
                            result = purchaseorder.GetApplyOrderHtml(new Guid(dr["POH_ID"].ToString()), out rtnVal, out rtnMsg);
                            userAccount = string.IsNullOrEmpty(dr["POH_SalesAccount"].ToString()) ? "" : dr["POH_SalesAccount"].ToString();

                            if (result)
                            {
                                template = WorkflowTemplate.EndoOrderTemplate.Clone().ToString();
                                template = string.Format(template, SR.CONST_ENDO_ORDER_NO, userAccount, userAccount, "", dr["POC_OrderNo"].ToString(), rtnMsg);
                                wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);
                            }
                            else
                            {
                                errMsg = "Html生成失败";
                            }
                        }
                    }
                    */
                    if (!string.IsNullOrEmpty(errMsg))
                    {
                        e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg><![CDATA[{0}]]></rtnMsg></result>";
                        e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                    }
                    else
                    {
                        //不存在错误信息
                        e.ReturnXml = "<result><rtnVal>1</rtnVal></result>";
                    }
                }


                e.Message = string.Format("共获取{0}条二级经销商订单确认数据", importData.Count);
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
