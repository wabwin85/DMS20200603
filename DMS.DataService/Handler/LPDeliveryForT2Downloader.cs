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
using DMS.Business;
using DMS.DataAccess;
using DMS.Model.Data;

namespace DMS.DataService.Handler
{
    public class LPDeliveryForT2Downloader : DownloadData
    {
        public LPDeliveryForT2Downloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LPDeliveryForT2Downloader;
            this.LoadData += new EventHandler<DataEventArgs>(LPDeliveryForT2Downloader_LoadData);
        }

        void LPDeliveryForT2Downloader_LoadData(object sender, DataEventArgs e)
        {
            DeliveryBLL business = new DeliveryBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitT2DeliveryInterfaceByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }
                try
                {
                    //生成XML
                    IList<LPDeliveryForT2Data> data = business.QueryT2DeliveryDataByBatchNbr(this.ClientID);

                    //构造接口对象
                    var records = (from r in data

                                   select new LPDeliveryForT2DataRecord
                                   {
                                       DistributorID = r.DistributorID,
                                       OrderNo = r.OrderNo,
                                       DeliveryNo = r.DeliveryNo,
                                       DeliveryDate = r.DeliveryDate,
                                       LPName = r.LPName,
                                       Carrier  =r.Carrier,
                                       CourierNo = r.CourierNo,
                                       TransportType = r.TransportType
                                   }).ToList<LPDeliveryForT2DataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.DeliveryNo.Equals(record.DeliveryNo)
                                     select new LPDeliveryForT2DataItem
                                     {
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         ExpDate = item.ExpDate,    
                                         UnitPrice = item.UnitPrice,
                                         WarehouseName = item.WarehouseName,
                                         QRCode = item.QRCode
                                     }).ToList<LPDeliveryForT2DataItem>();
                        record.Items = items;
                    }

                    LPDeliveryForT2DataSet dataSet = new LPDeliveryForT2DataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LPDeliveryForT2DataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条平台发货数据", dataSet.Count);
                }
                catch (Exception innerException)
                {
                    e.Success = false;
                    throw innerException;
                }
                finally
                {
                    //更新接口状态
                    //string rtnMsg = string.Empty;
                    //business.UpdateDeliveryInterfaceForDownloadedByBatchNbr(e.BatchNbr, e.Success ? PurchaseOrderMakeStatus.Success : PurchaseOrderMakeStatus.Failure);
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
