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
    public class T2ReturnDownloader : DownloadData
    {
        public T2ReturnDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.T2ReturnDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(T2ReturnDownloader_LoadData);
        }

        void T2ReturnDownloader_LoadData(object sender, DataEventArgs e)
        {
            AdjustBLL business = new AdjustBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitAdjustReturnInterfaceForT2ByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<T2ReturnData> data =  business.QueryReturnDetailInfoByBatchNbrForT2(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.DistributorID,
                                       r.ReturnType,
                                       r.WarehouseType,
                                       r.ReturnNo,
                                       r.ProductLine,
                                       r.ReturnDate,
                                       r.Remark
                                   }
                                       into g
                                       select new T2ReturnDataRecord
                                       {
                                           DistributorID = g.Key.DistributorID,
                                           ReturnType = g.Key.ReturnType,
                                           WarehouseType = g.Key.WarehouseType,
                                           ReturnNo = g.Key.ReturnNo,
                                           ProductLine = g.Key.ProductLine,
                                           ReturnDate = g.Key.ReturnDate,
                                           Remark = g.Key.Remark
                                       }).ToList<T2ReturnDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.ReturnNo.Equals(record.ReturnNo)
                                     select new T2ReturnDataItem
                                     {
                                         OrderNo = item.OrderNo,
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         QRCode = item.QRCode.ToUpper() == "NOQR" ? "" : item.QRCode,
                                         WarehouseCode = item.WarehouseCode
                                     }).ToList<T2ReturnDataItem>();
                        record.Items = items;
                    }

                    T2ReturnDataSet dataSet = new T2ReturnDataSet { Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<T2ReturnDataSet>(dataSet);

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
