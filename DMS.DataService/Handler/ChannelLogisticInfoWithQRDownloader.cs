using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Model.DataInterface;
using DMS.DataService.Util;
using DMS.DataAccess;

namespace DMS.DataService.Handler
{
    public class ChannelLogisticInfoWithQRDownloader: DownloadData
    {
        string QrCode = "";

        public ChannelLogisticInfoWithQRDownloader(string qrcode, string clientid)
        {
            QrCode = qrcode;
            this.ClientID = clientid;
            this.Type = DataInterfaceType.ChannelLogisticInfoWithQRDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(ChannelLogisticInfoWithQRDownloader_LoadData);
        }

        void ChannelLogisticInfoWithQRDownloader_LoadData(object sender, DataEventArgs e)
        {
            QrCodeMasterDao business = new QrCodeMasterDao();
            try
            {
                try
                {
                    //生成XML
                    IList<ChannelLogisticInfoWithQRData> data = business.SelectChannelLogisticInfoWithQR(QrCode);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DeliverytCustomer,
                                       r.DeliverytCustomerCode,
                                       r.ReceiveCustomer,
                                       r.ReceiveCustomerCode,
                                       r.DeliveryDate,
                                       r.LogisticType
                                   }
                                       into g
                                       select new ChannelLogisticInfoWithQRDataRecord
                                       {
                                           DeliverytCustomer = g.Key.DeliverytCustomer,
                                           DeliverytCustomerCode = g.Key.DeliverytCustomerCode,
                                           ReceiveCustomer = g.Key.ReceiveCustomer,
                                           ReceiveCustomerCode = g.Key.ReceiveCustomerCode,
                                           DeliveryDate = g.Key.DeliveryDate,
                                           LogisticType = g.Key.LogisticType,
                                       }).ToList<ChannelLogisticInfoWithQRDataRecord>();
                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where (item.DeliverytCustomerCode.Equals(record.DeliverytCustomerCode) && item.ReceiveCustomerCode.Equals(record.ReceiveCustomerCode) && item.LogisticType.Equals(record.LogisticType))
                                     select new ChannelLogisticInfoWithQRDataItem
                                     {
                                         UPN = item.UPN,
                                         LOT = item.LOT,
                                         QRCode = item.QRCode
                                     }).ToList<ChannelLogisticInfoWithQRDataItem>();
                        record.Items = items;
                    }

                    ChannelLogisticInfoWithQRDataSet dataSet = new ChannelLogisticInfoWithQRDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<ChannelLogisticInfoWithQRDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条渠道物流信息数据", dataSet.Count);
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
