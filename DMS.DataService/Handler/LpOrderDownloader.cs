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
    public class LpOrderDownloader : DownloadData
    {
        public LpOrderDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LpOrderDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(LpOrderDownloader_LoadData);
        }

        void LpOrderDownloader_LoadData(object sender, DataEventArgs e)
        {
            IPurchaseOrderBLL business = new PurchaseOrderBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitPurchaseOrderInterfaceForLpByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<LpOrderData> data = business.QueryPurchaseOrderDetailInfoByBatchNbrForLp(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.OrderNo,
                                       r.ProductLine,
                                       r.OrderType,
                                       r.DeliveryAddress,
                                       r.SubmitDate,
                                       r.Remark,
                                       r.ConsignmentSalesOrderNo                                       
                                   }
                                       into g
                                       select new LpOrderDataRecord
                                       {
                                           OrderNo = g.Key.OrderNo,
                                           ProductLine = g.Key.ProductLine,
                                           OrderType = g.Key.OrderType,
                                           DeliveryAddress = g.Key.DeliveryAddress,
                                           SubmitDate = g.Key.SubmitDate,
                                           Remark = g.Key.Remark,
                                           ConsignmentSalesOrderNo =g.Key.ConsignmentSalesOrderNo
                                       }).ToList<LpOrderDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.OrderNo.Equals(record.OrderNo)
                                     select new LpOrderDataItem
                                     {
                                         UPN = item.UPN,
                                         ShortUPN = item.ShortUPN,  //产品短编号 Add By SongWeiming on 20161008 
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         UnitPrice = item.UnitPrice,
                                         QRCode = item.QRCode  //Add By SongWeiming on 2015-12-03 for 二维码项目
                                     }).ToList<LpOrderDataItem>();
                        record.Items = items;
                    }

                    LpOrderDataSet dataSet = new LpOrderDataSet { Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LpOrderDataSet>(dataSet);

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
