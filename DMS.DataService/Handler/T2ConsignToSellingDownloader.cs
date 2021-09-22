using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DMS.DataService.Core;
using DMS.Common;
using DMS.Business;
using DMS.Model;
using DMS.DataService.Util;
using DMS.Model.DataInterface;
using DMS.Business.DataInterface;

namespace DMS.DataService.Handler
{
    public class T2ConsignToSellingDownloader : DownloadData
    {
        public T2ConsignToSellingDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2ConsignToSellingDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(T2ConsignToSellingDownloader_LoadData);
        }

        void T2ConsignToSellingDownloader_LoadData(object sender, DataEventArgs e)
        {
            AdjustBLL business = new AdjustBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitT2CTOSByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<T2ConsignToSellingData> data = business.QueryCTOSDetailInfoByBatchNbr(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.AdjustNo,
                                       r.ProductLine,
                                       r.AdjustDate,
                                       r.Type,
                                       r.DealerCode,
                                       r.Remark
                                   }
                                       into g
                                       select new T2ConsignToSellingDataRecord
                                       {

                                           AdjustNo = g.Key.AdjustNo,
                                           ProductLine = g.Key.ProductLine,
                                           AdjustDate = g.Key.AdjustDate,
                                           Type = g.Key.Type,
                                           DealerCode = g.Key.DealerCode,
                                           Remark = g.Key.Remark
                                       }).ToList<T2ConsignToSellingDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.AdjustNo.Equals(record.AdjustNo)
                                     select new T2ConsignToSellingDataItem
                                     {
                                         WhmCode = item.WhmCode,
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         QRCode = item.QRCode.ToUpper() == "NOQR" ? "" : item.QRCode,
                                     }).ToList<T2ConsignToSellingDataItem>();
                        record.Items = items;
                    }

                    T2ConsignToSellingDataSet dataSet = new T2ConsignToSellingDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<T2ConsignToSellingDataSet>(dataSet);

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
                    business.AfterLpReturnDetailInfoDownload(e.BatchNbr, this.ClientID, e.Success ? "Success" : "Failure", out rtnMsg);
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
