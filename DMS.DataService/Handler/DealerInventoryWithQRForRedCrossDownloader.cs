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
    public class DealerInventoryWithQRForRedCrossDownloader : DownloadData
    {
        string QrCode = "";
        string DealerCode = "";
        string Upn = "";
        string DealerName = "";
        string ProductName = "";


        public DealerInventoryWithQRForRedCrossDownloader(string qrcode,string upn, string merchandisename,  string supplyid, string supplyname, string clientid )
        {
            QrCode = qrcode;
            DealerCode = supplyid;
            Upn = upn;
            DealerName = supplyname;
            ProductName = merchandisename;
            this.ClientID = clientid;
            this.Type = DataInterfaceType.DealerInventoryWithQRForRedCrossDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(DealerInventoryWithQRForRedCrossDownloader_LoadData);
        }

        void DealerInventoryWithQRForRedCrossDownloader_LoadData(object sender, DataEventArgs e)
        {
            LotMasterDao business = new LotMasterDao();
            try
            {
                try
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("DealerCode", DealerCode);
                    ht.Add("QrCode", QrCode);
                    ht.Add("UPN", Upn);
                    
                    //生成XML
                    IList<QrCodeInventoryForRedCrossData> data = business.SelectDealerInventoryForRedCross(ht);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.SupplyID,
                                       r.SupplyName
                                   }
                                       into g
                                   select new QrCodeInventoryForRedCrossDataRecord
                                   {
                                       SupplyID = g.Key.SupplyID,
                                       SupplyName = g.Key.SupplyName
                                   }).ToList<QrCodeInventoryForRedCrossDataRecord>();
                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.SupplyID.Equals(record.SupplyID)
                                     select new QrCodeInventoryForRedCrossDataItem
                                     {
                                         MerchandiseID = item.MerchandiseID,
                                         MerchandiseName = item.MerchandiseName,
                                         UPN = item.UPN,
                                         LOT = item.LOT,
                                         QRCode = item.QRCode,
                                         GTIN = item.GTIN,
                                         Qty = item.Qty,
                                         CR = item.CR,
                                         ExpDate = item.ExpDate,
                                         DOM = item.DOM,
                                         IsQRUsable = item.IsQRUsable,
                                         Remark = item.Remark,
                                         WHMType = item.WHMType
                                     }).ToList<QrCodeInventoryForRedCrossDataItem>();
                        record.Items = items;
                    }

                    QrCodeInventoryForRedCrossDataSet dataSet = new QrCodeInventoryForRedCrossDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<QrCodeInventoryForRedCrossDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条红会经销商库存信息数据", dataSet.Count);
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