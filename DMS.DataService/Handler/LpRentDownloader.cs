using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Business;
using DMS.Model;
using DMS.DataService.Util;
using DMS.Business.DataInterface;
using DMS.Model.DataInterface;

namespace DMS.DataService.Handler
{
    public class LpRentDownloader : DownloadData
    {
        public LpRentDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LPRentDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(LpRentDownloader_LoadData);
        }

        void LpRentDownloader_LoadData(object sender, DataEventArgs e)
        {
            TransferBLL business = new TransferBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitRentInterfaceForLpByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<LpRentData> data = business.QueryRentInfoByBatchNbrForLp(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.TransferOutDealerCode,
                                       r.TransferInDealerCode,
                                       r.TransferDate,
                                       r.ERPFormNo,
                                       r.Remark,
                                       r.ProductLine

                                   }
                                       into g
                                       select new LpRentDataRecord
                                       {
                                           TransferOutDealerCode = g.Key.TransferOutDealerCode,
                                           TransferInDealerCode = g.Key.TransferInDealerCode,
                                           TransferDate = g.Key.TransferDate,                                           
                                           ERPFormNo = g.Key.ERPFormNo,
                                           Remark = g.Key.Remark,
                                           ProductLine = g.Key.ProductLine
                                       }).ToList<LpRentDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.ERPFormNo.Equals(record.ERPFormNo) 
                                         & item.Remark.Equals(record.Remark) 
                                         & item.TransferInDealerCode.Equals(record.TransferInDealerCode)
                                         & item.TransferOutDealerCode.Equals(record.TransferOutDealerCode)
                                     select new LpRentDataItem
                                     {
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         QRCode = item.QRCode.ToUpper() == "NoQR" ? "" : item.QRCode,
                                         ExpDate = item.ExpDate,
                                         Qty = item.Qty,
                                         UnitPrice = item.UnitPrice
                                     }).ToList<LpRentDataItem>();
                        record.Items = items;
                    }

                    LpRentDataSet dataSet = new LpRentDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LpRentDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条借货单数据", records.Count);
                }
                catch (Exception innerException)
                {
                    e.Success = false;
                    throw innerException;
                }
                finally
                {
                    //更新接口状态
                    string rtnVal = string.Empty;
                    business.AfterLpRentDataDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnVal);
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
