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
using System.Data;
using IBatisNet.Common.Transaction;
using DMS.DataAccess;
using IBatisNet.DataMapper;
using System.Data.SqlClient;
using IBatisNet.Common.Exceptions;
using System.Collections;
using DMS.Business;

namespace DMS.DataService.Handler
{
    public class OrderStatusUploader : UploadData
    {
        public OrderStatusUploader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SapDeliveryUploader;
            this.LoadData += new EventHandler<DataEventArgs>(SapDeliveryUploader_LoadData);
        }

        //空格-32 \r-13 \n-10
        void SapDeliveryUploader_LoadData(object sender, DataEventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(e.ReturnXml))
                {
                    throw new Exception("传入数据为空");
                }
                else
                {
                    OrderStatusDataSet dataSet = DataHelper.Deserialize<OrderStatusDataSet>(e.ReturnXml);
                    if (dataSet == null || dataSet.Records == null || dataSet.Records.Count == 0)
                        throw new Exception("传入数据为空");
                    //DataTable importData = new DataTable();
                    IList<Hashtable> importData = new List<Hashtable>();
                    //添加列名
                    //if (importData.Columns.Count == 0)
                    //{
                    //    importData.Columns.Add("Id", typeof(Guid));
                    //    importData.Columns.Add("ImportDate", typeof(DateTime));
                    //    importData.Columns.Add("ProcessDate", typeof(DateTime));
                    //    importData.Columns.Add("OrderNo", typeof(String));
                    //    importData.Columns.Add("OrderStatus", typeof(String));
                    //    importData.Columns.Add("LineNbr", typeof(Int32));
                    //    importData.Columns.Add("ClientId", typeof(String));
                    //    importData.Columns.Add("BatchNbr", typeof(String)); 
                    //    importData.Columns.Add("ProblemDescription", typeof(String));
                    //}
                    int line = 1;

                    foreach (OrderStatusDataRecord record in dataSet.Records)
                    {
                        Hashtable temp = new Hashtable();
                        temp.Add("Id", Guid.NewGuid());
                        temp.Add("OrderStatus", record.OrderStatus);
                        temp.Add("OrderNo", record.OrderNo);
                        temp.Add("LineNbr", line++);
                        temp.Add("ImportDate", DateTime.Now);
                        temp.Add("ClientId", this.ClientID);
                        temp.Add("BatchNbr", e.BatchNbr);
                        importData.Add(temp);
                    }

                    //导入接口表
                    ImportInterfaceOrderStatus(importData);
                    DeliveryBLL business = new DeliveryBLL();
                    //调用存储过程导入DeliveryNote表，并返回结果
                    string RtnMsg = string.Empty;
                    string IsValid = string.Empty;
                    business.HandleOrderStatusData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);
                    //business.HandleShipmentT2NormalData(e.BatchNbr, this.ClientID, out IsValid, out RtnMsg);
                    //如果调用过程失败则抛错
                    if (!IsValid.Equals("Success")&&!string.IsNullOrEmpty(RtnMsg))
                        throw new Exception(RtnMsg);

                    //针对更新成功，并且是关闭订单的数据，进行订单明细处理
                    DataSet dsSuccessCompletedData = business.SelectOrderStatusNoteByBatchNbrToCompleted(e.BatchNbr);
                    if (null != dsSuccessCompletedData && dsSuccessCompletedData.Tables.Count > 0 &&
                        dsSuccessCompletedData.Tables[0].Rows.Count > 0)
                    {
                        IPurchaseOrderBLL bllPurchaseOrder = new PurchaseOrderBLL();
                        DataTable dtSuccessCompletedData = dsSuccessCompletedData.Tables[0];
                        foreach (DataRow drData in dtSuccessCompletedData.Rows)
                        {
                            bllPurchaseOrder.CompleteOrder(new Guid(drData["POH_ID"].ToString()), "金蝶上传更新订单状态");
                        }
                    }

                    //如果调用过程成功，则检查是否存在未通过验证的数据
                    IList<OrderStatusData> errList = business.SelectOrderStatusNoteByBatchNbrErrorOnly(e.BatchNbr);

                    if (errList != null && errList.Count > 0)
                    {
                        //存在错误信息
                        e.ReturnXml = "<result><rtnVal>0</rtnVal><rtnMsg>{0}</rtnMsg></result>";
                        string errMsg = string.Empty;
                        foreach (OrderStatusData errItem in errList)
                        {
                            errMsg += "Line:" + errItem.LineNbr + " " + errItem.ProblemDescription + "\r\n";
                        }
                        e.ReturnXml = string.Format(e.ReturnXml, errMsg);
                    }
                    else
                    {
                        //不存在错误信息
                        e.ReturnXml = "<result><rtnVal>1</rtnVal><rtnMsg></rtnMsg></result>";
                    }


                    e.Message = string.Format("共获取{0}条EAP更新订单数据", importData.Count);
                    e.Success = true;
                }
            }
            catch (Exception ex)
            {
                e.Success = false;
                e.Message = ex.StackTrace;
            }
        }
        public void ImportInterfaceOrderStatus(IList<Hashtable> list)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceShipmentDao dao = new InterfaceShipmentDao())
                {
                    foreach (Hashtable item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }
    }
}
