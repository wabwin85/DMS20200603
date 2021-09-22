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
    public class T2OrderDownloader : DownloadData
    {
        public T2OrderDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2OrderDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(T2OrderDownloader_LoadData);
        }

        void T2OrderDownloader_LoadData(object sender, DataEventArgs e)
        {
            IPurchaseOrderBLL business = new PurchaseOrderBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitPurchaseOrderInterfaceForT2ByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }

                try
                {
                    //生成XML
                    IList<T2OrderData> data = business.QueryPurchaseOrderDetailInfoByBatchNbrForT2(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DistributorID,
                                       r.OrderNo,
                                       r.ProductLine,
                                       r.OrderType,
                                       r.Carrier,
                                       r.RDD,
                                       r.ContactPerson,
                                       r.Contact,
                                       r.ContactMobile,
                                       r.Consignee,
                                       r.ConsigneePhone,
                                       r.DeliveryAddress,
                                       r.Remark
                                   }
                                       into g
                                       select new T2OrderDataRecord
                                       {
                                           DistributorID = g.Key.DistributorID,
                                           OrderNo = g.Key.OrderNo,
                                           ProductLine = g.Key.ProductLine,
                                           OrderType = g.Key.OrderType,
                                           Carrier = g.Key.Carrier,
                                           RDD = g.Key.RDD,
                                           ContactPerson = g.Key.ContactPerson,
                                           Contact = g.Key.Contact,
                                           ContactMobile = g.Key.ContactMobile,
                                           ConsigneePhone = g.Key.ConsigneePhone,
                                           Consignee = g.Key.Consignee,
                                           DeliveryAddress = g.Key.DeliveryAddress,
                                           Remark = g.Key.Remark
                                       }).ToList<T2OrderDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.OrderNo.Equals(record.OrderNo)
                                     select new T2OrderDataItem
                                     {
                                         UPN = item.UPN,
                                         ShortUPN = item.ShortUPN,  //产品短编号 Add By SongWeiming on 20161008
                                         Qty = item.Qty,
                                         UnitPrice = item.UnitPrice,
                                         Lot = item.Lot,
                                         HospitalCode = item.HospitalCode,
                                         WHCode=item.WHCode,
                                         SalesNo = item.SalesNo,
                                         QRCode = item.QRCode
                                     }).ToList<T2OrderDataItem>();
                        record.Items = items;
                    }

                    T2OrderDataSet dataSet = new T2OrderDataSet { Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<T2OrderDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条订单数据", records.Count);
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
                    business.AfterPurchaseOrderDetailInfoDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnMsg);
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
