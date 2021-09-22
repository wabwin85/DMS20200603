using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Model;
using DMS.DataService.Util;
using DMS.Business.DataInterface;
using DMS.Model.Data;

namespace DMS.DataService.Handler
{
    public class SapDeliveryDownloader : DownloadData
    {
        public SapDeliveryDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SapDeliveryDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(SapDeliveryDownloader_LoadData);
        }

        void SapDeliveryDownloader_LoadData(object sender, DataEventArgs e)
        {
            DeliveryBLL business = new DeliveryBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitDeliveryInterfaceByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<SapDeliveryData> data = business.QuerySapDeliveryDataByBatchNbr(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DeliveryNo,
                                       r.ProductLine,
                                       r.DeliveryDate,
                                       r.BatchNo
                                   }
                                       into g
                                       select new SapDeliveryDataRecord
                                       {
                                           DeliveryNo = g.Key.DeliveryNo,
                                           ProductLine = g.Key.ProductLine,
                                           DeliveryDate = g.Key.DeliveryDate,
                                           BatchNo = g.Key.BatchNo
                                       }).ToList<SapDeliveryDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.DeliveryNo.Equals(record.DeliveryNo)
                                     select new SapDeliveryDataItem
                                     {
                                         UPN = item.UPN,
                                         ShortUPN = item.ShortUPN,
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         ExpDate = item.ExpDate,
                                         OrderNo = item.OrderNo,
                                         BoxNo = item.BoxNo,
                                         QRCode = item.QRCode,
                                         ProductDOM = item.ProductDOM,
                                         ProductRegNbr = item.ProductRegNbr,
                                         ProductManuName = item.ProductManuName
                                     }).ToList<SapDeliveryDataItem>();
                        record.Items = items;
                    }

                    SapDeliveryDataSet dataSet = new SapDeliveryDataSet { Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<SapDeliveryDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条发货单数据", records.Count);
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
                    business.UpdateDeliveryInterfaceForDownloadedByBatchNbr(e.BatchNbr, e.Success ? PurchaseOrderMakeStatus.Success : PurchaseOrderMakeStatus.Failure);
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
