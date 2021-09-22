using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Business;
using DMS.Model;
using DMS.DataService.Util;

namespace DMS.DataService.Handler
{
    public class T2ConsignmentSalesDownloader : DownloadData
    {
        public T2ConsignmentSalesDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2ConsignmentSalesDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(T2ConsignmentSalesDownloader_LoadData);
        }

        void T2ConsignmentSalesDownloader_LoadData(object sender, DataEventArgs e)
        {
            IShipmentBLL business = new ShipmentBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitLPConsignmentInterfaceByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<LpConsignmentSalesData> data = business.QueryLPConsignmentSalesInfoByBatchNbr(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DistributorID,
                                       r.SalesDate,
                                       r.CustomerID,
                                       r.Remark,
                                       r.SalesNo
                                   }
                                       into g
                                       select new LpConsignmentSalesDataRecord
                                       {
                                           
                                           DistributorID = g.Key.DistributorID,
                                           SalesDate = g.Key.SalesDate,
                                           CustomerID = g.Key.CustomerID,
                                           Remark = g.Key.Remark,
                                           SalesNo=g.Key.SalesNo
                                       }).ToList<LpConsignmentSalesDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.SalesNo.Equals(record.SalesNo)
                                     select new LpConsignmentSalesDataItem
                                     {
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         UnitPrice = item.UnitPrice,
                                         Qty = item.Qty,
                                         WHID=item.WHID,
                                         QRCode = item.QRCode.ToUpper() == "NOQR" ? "" : item.QRCode,
                                     }).ToList<LpConsignmentSalesDataItem>();
                        record.Items = items;
                    }

                    LpConsignmentSalesDataSet dataSet = new LpConsignmentSalesDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LpConsignmentSalesDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条寄售数据", dataSet.Count);
                }
                catch (Exception innerException)
                {
                    e.Success = false;
                    throw innerException;
                }
                finally
                {
                    //更新接口状态
                    string rtnMsg = string.Empty;
                    business.AfterLpConsignmentSalesInfoDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnMsg);
                }
            }
            catch (Exception ex)
            {
                e.Success = false;
                e.Message = ex.Message;
            }
        }
    }
}
