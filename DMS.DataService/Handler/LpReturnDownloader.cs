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
    public class LpReturnDownloader : DownloadData
    {
        public LpReturnDownloader(string clientid)
        {
            this.ClientID = clientid;
            this.Type = DataInterfaceType.LpReturnDownloader;
            this.LoadData += new EventHandler<DataEventArgs>(LpReturnDownloader_LoadData);
        }

        void LpReturnDownloader_LoadData(object sender, DataEventArgs e)
        {
            AdjustBLL business = new AdjustBLL();
            try
            {
                //初始化接口数据
                int cnt = business.InitAdjustReturnInterfaceForLpByClientID(this.ClientID, e.BatchNbr);

                if (cnt <= 0)
                {
                    e.ReturnXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><InterfaceDataSet />";
                    e.Success = true;
                    e.Message = "没有可获取的记录";
                }


                try
                {
                    //生成XML
                    IList<LpReturnData> data =  business.QueryReturnDetailInfoByBatchNbrForLp(e.BatchNbr);

                    //构造接口对象
                    var records = (from r in data
                                   group r by new
                                   {
                                       r.ReturnNo,
                                       r.ProductLine,
                                       r.ReturnDate,
                                       r.Remark
                                   }
                                       into g
                                       select new LpReturnDataRecord
                                       {
                                           ReturnNo = g.Key.ReturnNo,
                                           ProductLine = g.Key.ProductLine,
                                           ReturnDate = g.Key.ReturnDate,
                                           Remark = g.Key.Remark
                                       }).ToList<LpReturnDataRecord>();

                    foreach (var record in records)
                    {
                        var items = (from item in data
                                     where item.ReturnNo.Equals(record.ReturnNo)
                                     select new LpReturnDataItem
                                     {
                                         UPN = item.UPN,
                                         Lot = item.Lot,
                                         Qty = item.Qty,
                                         DealerCode = item.DealerCode,
										 QRCode = item.QRCode.ToUpper() == "NOQR" ? "" : item.QRCode,
                                     }).ToList<LpReturnDataItem>();
                        record.Items = items;
                    }

                    LpReturnDataSet dataSet = new LpReturnDataSet { Count = records.Count, Records = records };
                    //序列化得到XML数据
                    e.ReturnXml = DataHelper.Serialize<LpReturnDataSet>(dataSet);

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
