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
    public class SapOrderDownloader : DownloadData
    {
        public SapOrderDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.SapOrderDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(SapOrderDownloader_LoadData);
        }

        void SapOrderDownloader_LoadData(object sender, DataEventArgs e)
        {
            IPurchaseOrderBLL business = new PurchaseOrderBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitPurchaseOrderInterfaceByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<SapOrderData> data = business.QueryPurchaseOrderDetailInfoByBatchNbr(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.CustomerID,
                                       r.PO,
                                       r.POType,
                                       r.Organization,
                                       r.Remark,
                                       r.RDD,
                                       r.ShipTo                                      
                                   }
                                       into g
                                       select new SapOrderDataRecord
                                       {
                                           CustomerID = g.Key.CustomerID,
                                           PO = g.Key.PO,
                                           POType = g.Key.POType,
                                           Organization = g.Key.Organization,
                                           Remark = g.Key.Remark,
                                           PO_ShipTo = "",  //默认为空
                                           Name = "",       //默认为空
                                           RDD = g.Key.RDD,        //默认为空
                                           Reference = "",  //默认为空
                                           Telephone = "",  //默认为空
                                           CusPOType = "DMS",  //默认为空
                                           ShipTo = g.Key.ShipTo      //默认为空 
                                           
                                       }).ToList<SapOrderDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.PO.Equals(record.PO)
                                     select new SapOrderDataItem
                                     {
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         Plant = item.Plant,    
                                         SLocation = "" //默认为空
                                     }).ToList<SapOrderDataItem>();
                        record.Items = items;
                    }

                    SapOrderDataSet dataSet = new SapOrderDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<SapOrderDataSet>(dataSet);

                    e.Success = true;
                    e.Message = string.Format("共获取{0}条订单数据", dataSet.Count);
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
