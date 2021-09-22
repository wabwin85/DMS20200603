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
    public class LpComplainDownloader : DownloadData
    {
        public LpComplainDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LpComplainDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(LpComplainDownloader_LoadData);
        }

        void LpComplainDownloader_LoadData(object sender, DataEventArgs e)
        {
            DealerComplainBLL business = new DealerComplainBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitComplainInterfaceForLpByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<LpComplainData> data = business.QueryComplainInfoByBatchNbrForLp(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.ComplainNo,
                                       r.ProductLine,
                                       r.ComplainDate,
                                       r.DistributorID,
                                       r.Remark
                                       
                                   }
                                       into g
                                       select new LpComplainDataRecord
                                       {
                                           ComplainNo = g.Key.ComplainNo,
                                           ProductLine = g.Key.ProductLine,
                                           ComplainDate = g.Key.ComplainDate,
                                           DistributorID = g.Key.DistributorID,
                                           Remark = g.Key.Remark
                                       }).ToList<LpComplainDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.ComplainNo.Equals(record.ComplainNo)
                                     select new LpComplainDataItem
                                     {
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         QRCode = item.QRCode.ToUpper() == "NOQR" ? "" : item.QRCode,
                                         UnitPrice = item.UnitPrice,
                                         WarehouseCode = item.WarehouseCode
                                     }).ToList<LpComplainDataItem>();
                        record.Items = items;
                    }

                    LpComplainDataSet dataSet = new LpComplainDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LpComplainDataSet>(dataSet);

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
                    string rtnVal = string.Empty;
                    business.AfterComplainDataDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnVal);
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
