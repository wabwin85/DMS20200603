using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Model.DataInterface;
using DMS.DataService.Util;
using DMS.DataAccess;
using System.Collections;

namespace DMS.DataService.Handler
{
    public class DealerInventoryDownloader: DownloadData
    {
        string QrCode = "";
        string DealerCode = "";

        public DealerInventoryDownloader(string qrcode,string dealercode,string clientid)
        {
            QrCode = qrcode;
            DealerCode = dealercode;
            this.ClientID = clientid;
            this.Type = DataInterfaceType.DealerInventoryDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(DealerInventoryDownloader_LoadData);
        }

        void DealerInventoryDownloader_LoadData(object sender, DataEventArgs e)
        {
            LotMasterDao business = new LotMasterDao();
            try
            {
                try
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("DealerCode", DealerCode);
                    ht.Add("QrCode",QrCode);
                    //生成XML
                    IList<QrCodeInventoryData> data = business.SelectDealerInventoryForHospital(ht);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DealerCode
                                   }
                                       into g
                                       select new QrCodeInventoryDataRecord
                                       {
                                           DealerCode = g.Key.DealerCode
                                       }).ToList<QrCodeInventoryDataRecord>();
                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.DealerCode.Equals(record.DealerCode)
                                     select new QrCodeInventoryDataItem
                                     {
                                         UPN = item.UPN,
                                         LOT = item.LOT,
                                         QRCode = item.QRCode,
                                         GTIN = item.GTIN,
                                         ExpDate = item.ExpDate,
                                         DOM = item.DOM,
                                         IsQRUsable = item.IsQRUsable,
                                         Remark = item.Remark
                                     }).ToList<QrCodeInventoryDataItem>();
                        record.Items = items;
                    }

                    QrCodeInventoryDataSet dataSet = new QrCodeInventoryDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<QrCodeInventoryDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条经销商库存信息数据", dataSet.Count);
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
